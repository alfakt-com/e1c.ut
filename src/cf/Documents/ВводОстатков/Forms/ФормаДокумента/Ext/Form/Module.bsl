﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	
	ДоступныеТипыОпераций = Документы.ВводОстатков.ДоступныеТипыОпераций(Ложь);
	Если Параметры.Свойство("ОтборПоТипамОпераций") И Параметры.ОтборПоТипамОпераций.Количество() > 0 Тогда
		Для каждого ТипОперации Из Параметры.ОтборПоТипамОпераций Цикл
			Если ДоступныеТипыОпераций.Найти(ТипОперации.Значение) <> Неопределено Тогда
				СписокТиповОпераций.Добавить(ТипОперации.Значение);
			КонецЕсли;
		КонецЦикла;
	Иначе
		СписокТиповОпераций.ЗагрузитьЗначения(ДоступныеТипыОпераций);
	КонецЕсли;
	СписокТиповОпераций.СортироватьПоЗначению();
	
	
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	КонецЕсли;
	Если Параметры.Свойство("ОтражатьВОперативномУчете") Тогда
		Объект.ОтражатьВОперативномУчете = Параметры.ОтражатьВОперативномУчете;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Модифицированность = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписоктиповопераций

&НаКлиенте
Процедура СписокТиповОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОбработкаВыбораТипаОперации();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораТипаОперации()

	СтрокаТаблицы = Элементы.СписокТиповОпераций.ТекущиеДанные;
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("ТипОперации",               СтрокаТаблицы.Значение);
		ЗначенияЗаполнения.Вставить("Организация",               Объект.Организация);
		ЗначенияЗаполнения.Вставить("ОтражатьВОперативномУчете", Объект.ОтражатьВОперативномУчете);
		
		Если СписокТипыОперацийНеОтражаемыеВРеглУчете.НайтиПоЗначению(ЗначенияЗаполнения.ТипОперации) = Неопределено Тогда
			ЗначенияЗаполнения.Вставить("ОтражатьВБУиНУ",            Объект.ОтражатьВБУиНУ);
			ЗначенияЗаполнения.Вставить("ОтражатьВУУ",               Объект.ОтражатьВУУ);
		Иначе
			ЗначенияЗаполнения.Вставить("ОтражатьВБУиНУ",            Ложь);
			ЗначенияЗаполнения.Вставить("ОтражатьВУУ",               Ложь);
		КонецЕсли;
		
		Если ЗначенияЗаполнения.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.УдалитьОстаткиВозвратнойТарыПринятойОтПоставщиковНаАдресномСкладе")
			ИЛИ ЗначенияЗаполнения.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.УдалитьОстаткиТоваровПолученныхНаКомиссиюНаАдресномСкладе")
			ИЛИ ЗначенияЗаполнения.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.УдалитьОстаткиСобственныхТоваровНаАдресномСкладе") Тогда
			
			ТекстСообщения = НСтр("ru='Начиная с версии 2.4 данная операция не предназначена для ввода начальных остатков и сохранена только для просмотра ранее введенных документов.'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		Иначе
			Модифицированность = Ложь;
			ОткрытьФорму("Документ.ВводОстатков.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ВладелецФормы, );//КлючИзПараметров
			Закрыть();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьТипОперации(Команда)

	ОбработкаВыбораТипаОперации();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
