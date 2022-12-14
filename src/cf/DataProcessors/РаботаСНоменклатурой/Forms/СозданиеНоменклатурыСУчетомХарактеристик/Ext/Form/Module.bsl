
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	Если Не Параметры.Свойство("НоменклатураДляАнализа", НоменклатураДляАнализа)
		ИЛИ НЕ ЭтоАдресВременногоХранилища(НоменклатураДляАнализа) Тогда
		
		ВызватьИсключение НСтр("ru = 'Ошибка передачи данных номенклатуры'");
	КонецЕсли;
	
	ДанныеПоНоменклатуре = ПолучитьИзВременногоХранилища(НоменклатураДляАнализа);
	
	Если ТипЗнч(ДанныеПоНоменклатуре) <> Тип("ТаблицаЗначений")Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка формата данных номенклатуры'");
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	СформироватьДеревоНоменклатуры(ДанныеПоНоменклатуре);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоНоменклатуры

&НаКлиенте
Процедура ДеревоНоменклатурыВидНоменклатурыПриИзменении(Элемент)
	
	Если Элементы.ДеревоНоменклатуры.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Действие = НСтр("ru = 'Сопоставить реквизиты'");
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДеревоНоменклатурыВидНоменклатуры Тогда
		
		СтрокаДанных = ДеревоНоменклатуры.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если НЕ ЗначениеЗаполнено(СтрокаДанных.ВидНоменклатуры) Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуВидаНоменклатуры(СтрокаДанных.ВидНоменклатуры, ЭтотОбъект);
		
	ИначеЕсли Поле = Элементы.ДеревоНоменклатурыНоменклатураБазы Тогда	
		
		СтрокаДанных = ДеревоНоменклатуры.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если НЕ ЗначениеЗаполнено(СтрокаДанных.НоменклатураБазы) Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуНоменклатуры(СтрокаДанных.НоменклатураБазы, ЭтотОбъект);		
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	
	Если Элементы.ДеревоНоменклатуры.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = ДеревоНоменклатуры.НайтиПоИдентификатору(Элементы.ДеревоНоменклатуры.ТекущаяСтрока);
	РодительСтроки = СтрокаДерева.ПолучитьРодителя();
	
	Если РодительСтроки <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтатусыЗапрещающиеСоздание = СтатусыЗапрещающиеСозданиеНоменклатуры();
	
	Если СтатусыЗапрещающиеСоздание.Найти(СтрокаДерева.СтатусПроверки) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	ТекущиеДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания",     Неопределено);
	ПараметрыЗавершения.Вставить("СозданиеБезХарактеристик", Ложь);
	ПараметрыЗавершения.Вставить("ИдентификаторСтроки",      Элементы.ДеревоНоменклатуры.ТекущаяСтрока);
	
	ПараметрыСоздания = РаботаСНоменклатуройСлужебныйКлиентСервер.ОписаниеПараметровСозданияПроцедуры();
	
	ПараметрыСоздания.ИдентификаторыНоменклатуры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.Идентификатор);
	ПараметрыСоздания.СохранятьХарактеристикиВНаименование = Истина;
	ПараметрыСоздания.КонтролироватьНастройкиХарактеристик = Ложь;
	ПараметрыСоздания.СохранятьДополнительныеРеквизиты     = ЗначениеЗаполнено(ТекущиеДанные.ВидНоменклатуры);
	
	Оповещение = Новый ОписаниеОповещения("СоздатьНоменклатуруПродолжение", ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.СоздатьНоменклатуруСУсловиями(Оповещение, ПараметрыСоздания, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруБезХарактеристик(Команда)
	
	Если Элементы.ДеревоНоменклатуры.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
	ПараметрыЗавершения.Вставить("СозданиеБезХарактеристик", Истина);
	ПараметрыЗавершения.Вставить("ИдентификаторСтроки",      Элементы.ДеревоНоменклатуры.ТекущаяСтрока);
		
	ПараметрыСоздания = РаботаСНоменклатуройСлужебныйКлиентСервер.ОписаниеПараметровСозданияПроцедуры();
	
	ПараметрыСоздания.ИдентификаторыНоменклатуры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.Идентификатор);
	ПараметрыСоздания.СохранятьХарактеристики              = Ложь;
	ПараметрыСоздания.КонтролироватьНастройкиХарактеристик = Ложь;
	ПараметрыСоздания.СохранятьДополнительныеРеквизиты     = ЗначениеЗаполнено(ТекущиеДанные.ВидНоменклатуры);
	
	Оповещение = Новый ОписаниеОповещения("СоздатьНоменклатуруПродолжение", ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.СоздатьНоменклатуруСУсловиями(Оповещение, ПараметрыСоздания, ЭтотОбъект);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтатусыЗапрещающиеСозданиеНоменклатуры()
	
	Статусы = РаботаСНоменклатуройСлужебныйКлиентСервер.СтатусыПроверкиНоменклатуры();
	
	СтатусыЗапрещающиеСоздание = Новый Массив;
	СтатусыЗапрещающиеСоздание.Добавить(Статусы.НеСопоставленаКатегория);
	СтатусыЗапрещающиеСоздание.Добавить(Статусы.НеВсеРеквизитыСопоставлены);
	
	Возврат СтатусыЗапрещающиеСоздание;
		
КонецФункции

&НаКлиенте
Процедура СоздатьНоменклатуруПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Ошибка = Ложь;
	ПроставитьПризнакЗагрузки = Ложь;
	РезультатСоздания = Неопределено;
	
	РаботаСНоменклатуройКлиент.ОбработкаРезультатаСозданияНоменклатуры(
		Результат, РезультатСоздания, Ошибка, ПроставитьПризнакЗагрузки, ЭтотОбъект);
	
	Если Ошибка Тогда 
		Возврат;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	Если ДополнительныеПараметры.СозданиеБезХарактеристик Тогда
		Если РезультатСоздания.Создано = РезультатСоздания.ДолжноБытьСоздано
			И РезультатСоздания.НовыеЭлементы.Количество() > 0 Тогда
		
			СтрокаДерева = ДеревоНоменклатуры.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
			
			Если СтрокаДерева <> Неопределено Тогда
				СтрокаДерева.НоменклатураБазы = РезультатСоздания.НовыеЭлементы[0];
				СтрокаДерева.Загружена = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если РезультатСоздания.Создано = РезультатСоздания.ДолжноБытьСоздано
			И РезультатСоздания.НовыеЭлементы.Количество() > 0 Тогда
			
			СтрокаДерева = ДеревоНоменклатуры.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
			
			ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
			КоличествоЭлементов = МИН(ПодчиненныеСтроки.Количество(), РезультатСоздания.НовыеЭлементы.Количество());
			
			Для Счетчик = 0 По КоличествоЭлементов - 1 Цикл
				ПодчиненныеСтроки[Счетчик].НоменклатураБазы = РезультатСоздания.НовыеЭлементы[Счетчик];
				ПодчиненныеСтроки[Счетчик].Загружена = Истина;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НажатиеОповещенияПользователя(ДополнительныеПараметры) Экспорт 
	
	РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуСпискаНоменклатуры(ДополнительныеПараметры, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Загруженные элементы
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоНоменклатуры.Загружена");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНоменклатурыНоменклатураБазы.Имя);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНоменклатурыХарактеристика.Имя);
	
	
	// Пустой вид номенклатуры
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоНоменклатуры.ВидНоменклатуры");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНоменклатурыВидНоменклатуры.Имя);

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоНоменклатуры.ВидНоменклатуры");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНоменклатурыСтатусПроверки.Имя);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоНоменклатуры(ДанныеПоНоменклатуре)
	
	Для Каждого Номенклатура Из ДанныеПоНоменклатуре Цикл
		
		СтрокаДерева = ДеревоНоменклатуры.ПолучитьЭлементы().Добавить();
		
		ЗаполнитьЗначенияСвойств(СтрокаДерева, Номенклатура);
		
		ХарактеристикиНоменклатуры   = Номенклатура.Характеристики;
		
		Если ЗначениеЗаполнено(Номенклатура.Категория.ВидыНоменклатурыИнформационнойБазы) Тогда
			СтрокаДерева.ВидНоменклатуры = Номенклатура.Категория.ВидыНоменклатурыИнформационнойБазы[0]; 
		КонецЕсли;
		
		Если ХарактеристикиНоменклатуры = Неопределено Тогда 
			СтрокаДерева.Характеристика = ТекстХарактеристикиНеИспользуются();
			СтрокаДерева.НоменклатураБазы = СтрШаблон(ТекстБудетСозданоЭлементов(), 1);
		Иначе
			Если ХарактеристикиНоменклатуры.Количество() >= 1000 Тогда
				СтрокаДерева.НоменклатураБазы = СтрШаблон(ТекстБудетСозданоЭлементов(), ХарактеристикиНоменклатуры.Количество());
			Иначе
				СтрокаДерева.НоменклатураБазы = СтрШаблон(ТекстБудетСозданоЭлементов(), ХарактеристикиНоменклатуры.Количество());
				
				Для каждого Характеристика Из ХарактеристикиНоменклатуры Цикл
					
					СтрокаСХарактеристикой = СтрокаДерева.ПолучитьЭлементы().Добавить();
					
					СтрокаСХарактеристикой.Характеристика = СтрШаблон("%1, %2", 
						СтрокаСХарактеристикой.ПолучитьРодителя().Наименование, 
						Характеристика.Наименование);
					СтрокаСХарактеристикой.НоменклатураБазы = СтрШаблон("%1, %2", 
						СтрокаСХарактеристикой.ПолучитьРодителя().Наименование, 
						Характеристика.Наименование);
					СтрокаСХарактеристикой.Наименование = Характеристика.Наименование;
					
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СтроковыеКонстанты

&НаКлиентеНаСервереБезКонтекста
Функция ТекстХарактеристикиНеИспользуются()
	
	Возврат НСтр("ru = '<характеристики не используются>'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстБудетСозданоЭлементов()
	
	Возврат НСтр("ru = '<будет создано %1>'");
		
КонецФункции

#КонецОбласти
