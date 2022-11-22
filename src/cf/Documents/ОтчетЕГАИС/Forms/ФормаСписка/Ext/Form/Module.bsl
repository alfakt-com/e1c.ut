﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПараметрыВидимостиКолонок();
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ВидДокумента",     ВидДокумента,     СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный",    Ответственный,    СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	НастройкиОрганизацияЕГАИС = ИнтеграцияЕГАИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек(
		"ОрганизацииЕГАИС",
		Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ОрганизацияЕГАИС",
	                                                                       ОрганизацииЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       НастройкиОрганизацияЕГАИС);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Ответственный",
	                                                                       Ответственный,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ВидДокумента",
	                                                                       ВидДокумента,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	Настройки.Удалить("Ответственный");
	Настройки.Удалить("ОрганизацииЕГАИС");
	Настройки.Удалить("ВидДокумента");
	Настройки.Удалить("ТолькоСОшибками");
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОтчетЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ОтчетЕГАИС") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "ВидДокумента",
	                                                                        ВидДокумента,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(ВидДокумента));
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#Область ОтборПоОрганизацииЕГАИС

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацииЕГАИС, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацияЕГАИС, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные.СтатусЕГАИС = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиОтчетаЕГАИС.ПолученОтчет") Тогда
		СтандартнаяОбработка = Ложь;
		
		Отбор = Новый Структура;
		Отбор.Вставить("ОтчетЕГАИС", ТекущиеДанные.Ссылка);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", Отбор);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		
		Если ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами") Тогда
			ОткрытьФорму("Отчет.ДвиженияМеждуРегистрамиЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2") Тогда
			ОткрытьФорму("Отчет.ДвиженияПоСправке2ЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации") Тогда
			ОткрытьФорму("Отчет.ИнформацияОбОрганизацииЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН") Тогда
			ОткрытьФорму("Отчет.НеобработанныеТТНЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки") Тогда
			ОткрытьФорму("Отчет.ОбработанныеЧекиЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1") Тогда
			ПараметрыФормы.Вставить("КлючВарианта", "ОстаткиВРегистре1");
			ОткрытьФорму("Отчет.ОстаткиАлкогольнойПродукцииЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2") Тогда
			ПараметрыФормы.Вставить("КлючВарианта", "ОстаткиВРегистре2");
			ОткрытьФорму("Отчет.ОстаткиАлкогольнойПродукцииЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3") Тогда
			ОткрытьФорму("Отчет.ОстаткиАкцизныхМарокЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2") Тогда
			ОткрытьФорму("Отчет.ИсторияСправок2ЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область КомандыСоздания

&НаКлиенте
Процедура СоздатьЗапросДвиженийМеждуРегистрами(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросДвиженийПоСправке2(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросИнформацииОбОрганизацииЕГАИС(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросНеобработанныхТТН(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОбработанныхЧеков(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОстатковВРегистре1(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОстатковВРегистре2(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОстатковВРегистре3(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросИсторииСправок2(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2"));
	
КонецПроцедуры

#КонецОбласти

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами, НСтр("ru='Движения между регистрами'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2     , НСтр("ru='Движения по справке 2'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации, НСтр("ru='Информация об организации ЕГАИС'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН      , НСтр("ru='Необработанные ТТН'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки       , НСтр("ru='Обработанные чеки'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1      , НСтр("ru='Остатки в регистре №1'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2      , НСтр("ru='Остатки в регистре №2'"));
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеВидаДокумента(ВидДокумента, Представление)
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = ВидДокумента;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Представление);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОтчета(ВидДокумента)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ВидДокумента", ВидДокумента);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ОтчетЕГАИС.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВидимостиКолонок()
	
	ПараметрыВидимостиКолонок = Новый Структура;
	
	ПараметрыВидимостиКолонок.Вставить("Период"              , Новый Массив);
	ПараметрыВидимостиКолонок.Вставить("АлкогольнаяПродукция", Новый Массив);
	ПараметрыВидимостиКолонок.Вставить("Справка2"            , Новый Массив);
	ПараметрыВидимостиКолонок.Вставить("КодФСРАР"            , Новый Массив);
	
	ПараметрыВидимостиКолонок.Период.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами);
	ПараметрыВидимостиКолонок.Период.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации);
	ПараметрыВидимостиКолонок.Период.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки);
	
	ПараметрыВидимостиКолонок.АлкогольнаяПродукция.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами);
	ПараметрыВидимостиКолонок.АлкогольнаяПродукция.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2);
	ПараметрыВидимостиКолонок.АлкогольнаяПродукция.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки);
	
	ПараметрыВидимостиКолонок.Справка2.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2);
	
	ПараметрыВидимостиКолонок.КодФСРАР.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Форма.Элементы.ВидДокумента.Видимость = НЕ ЗначениеЗаполнено(Форма.ВидДокумента);
	
	УстановитьВидимостьКолонки(Форма, "Период");
	УстановитьВидимостьКолонки(Форма, "АлкогольнаяПродукция");
	УстановитьВидимостьКолонки(Форма, "Справка2");
	УстановитьВидимостьКолонки(Форма, "КодФСРАР");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьКолонки(Форма, ИмяКолонки)
	
	Форма.Элементы[ИмяКолонки].Видимость = Форма.ПараметрыВидимостиКолонок[ИмяКолонки].Найти(Форма.ВидДокумента) <> Неопределено;
	
КонецПроцедуры

#КонецОбласти