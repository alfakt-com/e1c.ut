
&НаСервере
Процедура ЗаменитьНаСервере()
	
	НетВыб = Ложь;
	Для Каждого СтрПров Из Объект.ТабТовар Цикл 
		Если СтрПров.Выбор = Истина Тогда 
			НетВыб = Истина;
		КонецЕсли;		
	КонецЦикла;
	
	Если Не НетВыб Тогда 
		Сообщить("Не Выбрана Номенклотура для замены!!!");
		Возврат;	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.НоменклотуруЗаменитьНа) Тогда
		Сообщить("Не выбрана Номенклатура на которую необходимо заменить!!!");
		Возврат;		
	КонецЕсли;

	ДокЗаказ = Объект.Заказ.ПолучитьОбъект();
	
	Для Каждого СтрСтар Из Объект.ТабТовар Цикл 
		Если СтрСтар.Выбор = Истина тогда
			///Таб Товары
			Для Каждого СтрТов Из ДокЗаказ.Товары Цикл 
				Если СтрТов.Номенклатура = СтрСтар.Номенклатура и СтрТов.КлючСтроки = СтрСтар.КлючСтроки тогда
					СтрТов.Номенклатура = Объект.НоменклотуруЗаменитьНа;	
				КонецЕсли;		
			КонецЦикла;
			
			///Таб Бонусы Выданные
			Если ДокЗаказ.bon_БонусПартНачис.Количество() > 0 Тогда
				Для Каждого СтрТов Из ДокЗаказ.bon_БонусПартНачис Цикл 
					Если СтрТов.Номенклатура = СтрСтар.Номенклатура и СтрТов.КлючПримВыдано = СтрСтар.КлючСтроки тогда
						СтрТов.Номенклатура = Объект.НоменклотуруЗаменитьНа;	
					КонецЕсли;	
				КонецЦикла;	
			КонецЕсли;
			
			///Таб Партии Бонусов Использованных
			Если ДокЗаказ.bon_ПартииБонусовИст.Количество() > 0 Тогда
				Для Каждого СтрТов Из ДокЗаказ.bon_ПартииБонусовИст Цикл 
					Если СтрТов.Номенклатура = СтрСтар.Номенклатура и СтрТов.КлючСвязи = СтрСтар.КлючСтроки тогда
						СтрТов.Номенклатура = Объект.НоменклотуруЗаменитьНа;	
					КонецЕсли;		
				КонецЦикла;		
			КонецЕсли;
			
			///Та Партий Бонусов
			Если ДокЗаказ.bon_ТабПартий.Количество() > 0 Тогда
				Для Каждого СтрТов Из ДокЗаказ.bon_ТабПартий Цикл 
					Если СтрТов.НомМожПрим = СтрСтар.Номенклатура и СтрТов.КлючМожПрим = СтрСтар.КлючСтроки тогда
						СтрТов.НомМожПрим = Объект.НоменклотуруЗаменитьНа;	
					КонецЕсли;		
				КонецЦикла;		
			КонецЕсли;
	
		КонецЕсли;
	КонецЦикла;

	ДокЗаказ.Записать();
	
	Попытка
		ДокЗаказ.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
	Исключение
		ОшибкаОпис = ОписаниеОшибки();
		Сообщить("Документ не провелся. Передайте ошибка в Help-Desk. Ошибка: "+ОшибкаОпис);	
	КонецПопытки;
		
КонецПроцедуры

&НаКлиенте
Процедура Заменить(Команда)
	ЗаменитьНаСервере();
КонецПроцедуры

&НаСервере
Функция ПроверкаНаСозданиеРеалки()
	
	Рез = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СвязанныеДокументы.Ссылка КАК Ссылка
	|ИЗ
	|	КритерийОтбора.СвязанныеДокументы(&Заказ) КАК СвязанныеДокументы
	|ГДЕ
	|	СвязанныеДокументы.Ссылка.Проведен = Истина";
	Запрос.УстановитьПараметр("Заказ", Объект.Заказ);
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ТипЗнч(ВыборкаДетальныеЗаписи.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			Рез = Истина;
			Возврат Рез;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

&НаКлиенте
Процедура ЗаказПриИзменении(Элемент)
	
	Объект.ТабТовар.Очистить();
	
	ЕстьРеалка = ПроверкаНаСозданиеРеалки();
	Если ЕстьРеалка Тогда
		Элементы.Заменить.Доступность = Ложь;
	Иначе 
		Элементы.Заменить.Доступность = Истина;
		ЗаполнитьТабТовар();	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабТовар()
	
	Для Каждого СтТов Из Объект.Заказ.Товары Цикл 
		НовСт = Объект.ТабТовар.Добавить();
		НовСт.Номенклатура = 	СтТов.Номенклатура;
		НовСт.Количество = 		СтТов.Количество;
		НовСт.ВидЦены = 		СтТов.ВидЦены;
		НовСт.Цена = 			СтТов.Цена;
		НовСт.Сумма = 			СтТов.Сумма;
		НовСт.КлючСтроки = 		СтТов.КлючСтроки;
		НовСт.new_ЭтоСпецЦена = СтТов.new_ЭтоСпецЦена; 			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабТоварВыборПриИзменении(Элемент)
	
	Перм = Элементы.ТабТовар.ТекущиеДанные.Выбор;
	
	Для Каждого СтрРед Из Объект.ТабТовар Цикл 
		СтрРед.Выбор = Ложь;		
	КонецЦикла;	
	
	Элементы.ТабТовар.ТекущиеДанные.Выбор = Перм;	
	
КонецПроцедуры
