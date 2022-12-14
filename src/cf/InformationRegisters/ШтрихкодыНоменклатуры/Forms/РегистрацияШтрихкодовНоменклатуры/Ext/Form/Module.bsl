&НаКлиенте
Перем ВыполняетсяЗакрытие;

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ПроверятьТЧПередЗакрытием; //признак необходимости проверки заполненности ТЧ перед закрытием

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	ЕстьАлкогольнаяПродукция = Ложь;
	Для Каждого СтрокаШтрихкода Из Параметры.НеизвестныеШтрихкоды Цикл
		
		НоваяСтрока = ШтрихкодыНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаШтрихкода);
		
		Если ЗначениеЗаполнено(НоваяСтрока.АлкогольнаяПродукция) Тогда
			ЕстьАлкогольнаяПродукция = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.АлкогольнаяПродукция.Видимость = ЕстьАлкогольнаяПродукция;
	
	ДействияСНеизвестнымиШтрихкодами = Параметры.ДействияСНеизвестнымиШтрихкодами;
	
	Если ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать" Тогда
		Элементы.ЗаписатьИЗакрыть.Заголовок = НСтр("ru = 'Зарегистрировать штрихкоды'");
	Иначе
		Элементы.ЗаписатьИЗакрыть.Заголовок = НСтр("ru = 'Перенести в документ'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
	Сигнал();
	#КонецЕсли
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	ПроверятьТЧПередЗакрытием = Ложь;
	ТекущийЭлемент = Элементы.Номенклатура;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ВыполняетсяЗакрытие И Не ПроверятьТЧПередЗакрытием И НЕ ЗавершениеРаботы Тогда
		Отказ = Истина;
			
		Если ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать" Тогда
			ТекстВопроса = НСтр("ru='Штрихкоды не будут зарегистрированы.'");
		Иначе
			ТекстВопроса = НСтр("ru='Товары не будут перенесены в документ.
								|Отложите их в сторону как неотсканированные.'");
		КонецЕсли;					
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ЕстьАлкогольнаяПродукция Тогда
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(
			Новый ОписаниеОповещения("ПриВыбореНоменклатуры", ЭтотОбъект), ВыбранноеЗначение, ИсточникВыбора);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ШтрихкодыНоменклатуры.Штрихкод                    КАК Штрихкод,
	|	ШтрихкодыНоменклатуры.Номенклатура                КАК Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика              КАК Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка                    КАК Упаковка,
	|	ШтрихкодыНоменклатуры.Номенклатура.Наименование   КАК НоменклатураПредставление,
	|	ШтрихкодыНоменклатуры.Характеристика.Наименование КАК ХарактеристикаПредставление,
	|	ШтрихкодыНоменклатуры.Упаковка.Наименование       КАК УпаковкаПредставление
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод В (&Штрихкоды)
	|";
	
	Запрос.УстановитьПараметр("Штрихкоды", ШтрихкодыНоменклатуры.Выгрузить(Новый Структура("Зарегистрирован", Ложь),"Штрихкод").ВыгрузитьКолонку("Штрихкод"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда // Штрихкод уже записан в БД
		
		СтрокаТЧ = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", Выборка.Штрихкод))[0];
		
		ОписаниеОшибки = НСтр("ru='Такой штрихкод уже назначен для номенклатуры %Номенклатура%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Номенклатура%", """" + Выборка.НоменклатураПредставление + """"
		                + ?(ЗначениеЗаполнено(Выборка.Характеристика), " " + НСтр("ru='с характеристикой'") + " """ + Выборка.ХарактеристикаПредставление + """", "")
		                + ?(ЗначениеЗаполнено(Выборка.Упаковка), " """ + НСтр("ru='в упаковке'") + " " + Выборка.УпаковкаПредставление + """", ""));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки,,"ШтрихкодыНоменклатуры["+ШтрихкодыНоменклатуры.Индекс(СтрокаТЧ)+"].Штрихкод",,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШтрихкодыНоменклатуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущиеДанные.Упаковка);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если ЕстьАлкогольнаяПродукция
		И ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.АлкогольнаяПродукция) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(
			ЭтотОбъект,
			ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(ТекущиеДанные.АлкогольнаяПродукция));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если ЕстьАлкогольнаяПродукция
		И ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.АлкогольнаяПродукция) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(
			ЭтотОбъект,
			ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(ТекущиеДанные.АлкогольнаяПродукция));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	ПараметрЗакрытия = ЗарегистрироватьШтрихкодыНаСервере();
	Если ПараметрЗакрытия <> Неопределено Тогда
		
		Если ПараметрЗакрытия.НайденыНезарегистрированныеТовары Тогда
			
			Если ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать" Тогда
				Если ИспользоватьХарактеристикиНоменклатуры Тогда
					ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура и характеристика.
					|По этим позициям штрихкод не будет зарегистрирован.'");
				Иначе
					ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура.
					|По этим позициям штрихкод не будет зарегистрирован.'");
				КонецЕсли;
			Иначе	
				Если ИспользоватьХарактеристикиНоменклатуры Тогда
					ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура и характеристика.
					|Эти товары не будут перенесены в документ.
					|Отложите их в сторону как неотсканированные.'");
				Иначе
					ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура.
					|Эти товары не будут перенесены в документ.
					|Отложите их в сторону как неотсканированные.'");
				КонецЕсли;
			КонецЕсли;
			РезультатВопроса = Неопределено;

			
			ПоказатьВопрос(Новый ОписаниеОповещения("ПеренестиВДокументЗавершение", ЭтотОбъект, Новый Структура("ПараметрЗакрытия", ПараметрЗакрытия)), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
            Возврат;
			
		КонецЕсли;
		
		ПеренестиВДокументФрагмент(ПараметрЗакрытия);

		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ПараметрЗакрытия = ДополнительныеПараметры.ПараметрЗакрытия;
    
    
    Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
        Возврат;
    КонецЕсли;
    
    
    ПеренестиВДокументФрагмент(ПараметрЗакрытия);

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументФрагмент(Знач ПараметрЗакрытия)
    
    ПроверятьТЧПередЗакрытием = Истина;
    Закрыть();
    
    ПараметрЗакрытия.Вставить("ФормаВладелец", ВладелецФормы.УникальныйИдентификатор);
    
    Оповестить("НеизвестныеШтрихкоды", ПараметрЗакрытия, "ПодключаемоеОборудование");

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.ШтрихкодыНоменклатуры.ТекущаяСтрока;
	НайденныйШК = ШтрихкодыНоменклатуры.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Если НайденныйШК = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	Если РаботаСНоменклатуройКлиент.ДоступенФункционалПодсистемы() Тогда
		РаботаСНоменклатуройКлиент.НайтиНоменклатуруПоШтрихкодуВСервисе(НайденныйШК.ШтрихКод);
	Иначе
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Номенклатура не найдена'"),,
			СтрШаблон(НСтр("ru = 'По штрихкоду %1 номенклатура не найдена.'"), НайденныйШК.ШтрихКод),,
			СтатусОповещенияПользователя.Информация);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "ЕдиницаИзмерения", 
                                                                   "ШтрихкодыНоменклатуры.Упаковка");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Номенклатура.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Характеристика.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Упаковка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "Характеристика",
																		     "ШтрихкодыНоменклатуры.ХарактеристикиИспользуются");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Состояние.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Новый'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Состояние.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Зарегистрирован'"));

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Для Каждого ЭлементДанных Из ДанныеШтрихкодов Цикл
		НайденныеСтроки = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", ЭлементДанных.Штрихкод));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].Количество = НайденныеСтроки[0].Количество + ЭлементДанных.Количество;
		Иначе
			ДанныеШтрихкода = ПолучитьДанныеШтрихкода(ЭлементДанных.Штрихкод);
			Если ДанныеШтрихкода = Неопределено Тогда
				НовыйШтрихкод = ШтрихкодыНоменклатуры.Добавить();
				НовыйШтрихкод.Штрихкод = ЭлементДанных.Штрихкод;
				НовыйШтрихкод.Количество = ЭлементДанных.Количество;
			Иначе
				
				НовыйШтрихкод = ШтрихкодыНоменклатуры.Добавить();
				НовыйШтрихкод.Штрихкод   = ЭлементДанных.Штрихкод;
				НовыйШтрихкод.Количество = ЭлементДанных.Количество;
				ЗаполнитьЗначенияСвойств(НовыйШтрихкод, ДанныеШтрихкода);
				НовыйШтрихкод.Зарегистрирован = Истина;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Номенклатура = Номенклатура;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущиеДанные.Упаковка);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеШтрихкода(Штрихкод)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДанныеШтрихкода = Новый Структура("Номенклатура, Характеристика, Упаковка");
		ЗаполнитьЗначенияСвойств(ДанныеШтрихкода, Выборка);
		Возврат ДанныеШтрихкода;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗарегистрироватьШтрихкодыНаСервере()
	
	Если ПроверитьЗаполнение() Тогда
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных();
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ШтрихкодыНоменклатуры");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			Для Каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
				
				Если СтрокаШтрихкода.Зарегистрирован ИЛИ Не ЗначениеЗаполнено(СтрокаШтрихкода.Номенклатура)
					ИЛИ (СтрокаШтрихкода.ХарактеристикиИспользуются И Не ЗначениеЗаполнено(СтрокаШтрихкода.Характеристика))Тогда
					Продолжить;
				КонецЕсли;
				
				МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Штрихкод = СтрокаШтрихкода.Штрихкод;
				МенеджерЗаписи.Номенклатура = СтрокаШтрихкода.Номенклатура;
				МенеджерЗаписи.Характеристика = СтрокаШтрихкода.Характеристика;
				МенеджерЗаписи.Упаковка = СтрокаШтрихкода.Упаковка;
				МенеджерЗаписи.Записать();
				
				СтрокаШтрихкода.ЗарегистрированОбработкой = Истина;
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОписаниеОшибки = НСтр("ru = 'При записи штрихкодов произошла ошибка.
			                            |Дополнительное описание:
			                            |%ДополнительноеОписание%'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрЗаменить(ОписаниеОшибки, "%ДополнительноеОписание%", ИнформацияОбОшибке().Описание));
			
			Возврат Неопределено;
			
		КонецПопытки;
		
		НайденыНезарегистрированныеТовары = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь));
		
		ЗарегистрированныеШтрихкоды = Новый Массив;
		НайденныеЗарегистрированныеШтрихкоды = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ЗарегистрированОбработкой", Истина));
		Для Каждого СтрокаШтрихкода Из НайденныеЗарегистрированныеШтрихкоды Цикл
			ЗарегистрированныеШтрихкоды.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
		КонецЦикла;
		
		ОтложенныеТовары = Новый Массив;
		НайденныеОтложенныеТовары = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь));
		Для Каждого СтрокаШтрихкода Из НайденныеОтложенныеТовары Цикл
			ОтложенныеТовары.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
		КонецЦикла;
		
		ПолученыНовыеШтрихкоды = Новый Массив;
		НайденныеПолученныеШтрихкоды = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован", Истина));
		Для Каждого СтрокаШтрихкода Из НайденныеПолученныеШтрихкоды Цикл
			ПолученыНовыеШтрихкоды.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
		КонецЦикла;
		
		ПараметрЗакрытия = Новый Структура("ОтложенныеТовары, ЗарегистрированныеШтрихкоды, ПолученыНовыеШтрихкоды, НайденыНезарегистрированныеТовары", ОтложенныеТовары, ЗарегистрированныеШтрихкоды, ПолученыНовыеШтрихкоды, НайденыНезарегистрированныеТовары.Количество() > 0);
		Возврат ПараметрЗакрытия;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ПроверятьТЧПередЗакрытием = Истина;
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;