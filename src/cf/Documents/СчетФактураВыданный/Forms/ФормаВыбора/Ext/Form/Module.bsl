﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Подсистема "ЭлектронныеДокументы"
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Отбор.Свойство("ДокументОснование")
	 И Параметры.Отбор.Свойство("ВключаяПодчиненныеОснования")
	 И Параметры.Отбор.ВключаяПодчиненныеОснования Тогда
	 	
		УстановитьОтборВключаяПодчиненныеОснования(Параметры.Отбор.ДокументОснование);
		Параметры.Отбор.Удалить("ДокументОснование");
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Корректировочный")
		И Параметры.Отбор.Корректировочный Тогда
		
		ТипыОснованияКорректировки = Метаданные.Документы.КорректировкаРеализации.Реквизиты.ДокументОснование.Тип;
		РазрешенныеТипы = ТипыОснованияКорректировки.Типы();
		РазрешенныеТипы.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ТипОснования",
			РазрешенныеТипы,
			ВидСравненияКомпоновкиДанных.ВСписке);
		
		Параметры.Отбор.Удалить("Корректировочный");
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Дата") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ДатаДень",
			НачалоДня(Параметры.Дата),
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ИсключитьСчетФактуру") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка",
			Параметры.Отбор.ИсключитьСчетФактуру,
			ВидСравненияКомпоновкиДанных.НеРавно,
			,
			Истина);
			
			Параметры.Отбор.Удалить("ИсключитьСчетФактуру");
			
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.СодержитНекорректныхКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
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
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетФактураВыданный.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьОтборВключаяПодчиненныеОснования(Основание)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Основание КАК ДокументОснование
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	(КорректировкаРеализации.Ссылка = &Основание
	|	ИЛИ КорректировкаРеализации.ДокументОснование = &Основание)
	|	И НЕ КорректировкаРеализации.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.Ссылка КАК ДокументОснование
	|ИЗ
	|	Документ.КорректировкаРеализации КАК ТекущийДокумент
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|	ПО КорректировкаРеализации.ДокументОснование = ТекущийДокумент.ДокументОснование
	|ГДЕ
	|	ТекущийДокумент.Ссылка = &Основание
	|	И КорректировкаРеализации.Ссылка <> &Основание
	|	И НЕ КорректировкаРеализации.ПометкаУдаления
	|");
	Запрос.УстановитьПараметр("Основание", Основание);
	
	МассивОснований = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ДокументОснование",
		МассивОснований,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
