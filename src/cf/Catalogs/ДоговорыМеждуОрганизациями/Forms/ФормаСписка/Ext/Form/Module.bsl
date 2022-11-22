﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокДействия.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацияПолучатель", ОрганизацияПолучатель, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "ОрганизацияПолучатель", ОрганизацияПолучатель, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Организация", 
		Организация, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОрганизацияПолучательПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"ОрганизацияПолучатель", 
		ОрганизацияПолучатель, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(ОрганизацияПолучатель));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНеСогласован(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Не согласован"". По действующим договорам могут быть оформлены документы. После изменения статуса действующие договоры перестанут действовать. Продолжить?'");
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = УстановитьСтатусСервер(ВыделенныеСтроки, "НеСогласован");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Не согласован'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Действует"". Продолжить?'");
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусДействуетЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействуетЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	КоличествоОбработанных = УстановитьСтатусСервер(ВыделенныеСтроки, "Действует");
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Действует'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Закрыт"". После изменения статуса действующие договоры перестанут действовать. Продолжить?'");
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = УстановитьСтатусСервер(ВыделенныеСтроки, "Закрыт");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Закрыт'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция УстановитьСтатусСервер(Знач Договоры, НовыйСтатус)
	
	Возврат Справочники.ДоговорыМеждуОрганизациями.УстановитьСтатус(Договоры, Перечисления.СтатусыДоговоровКонтрагентов[НовыйСтатус]);
	
КонецФункции

#КонецОбласти

#КонецОбласти
