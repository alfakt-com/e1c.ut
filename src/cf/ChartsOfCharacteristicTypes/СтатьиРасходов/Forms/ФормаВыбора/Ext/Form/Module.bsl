﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьПараметрыДинамическогоСписка();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	
	ХозяйственнаяОперация = Неопределено;
	
	Если Параметры.Свойство("Отбор") Тогда
		
		Если Параметры.Отбор.Свойство("ХозяйственнаяОперация") Тогда
			
			Если ЗначениеЗаполнено(Параметры.Отбор.ХозяйственнаяОперация) Тогда
				ХозяйственнаяОперация = Параметры.Отбор.ХозяйственнаяОперация;
			КонецЕсли;
			Параметры.Отбор.Удалить("ХозяйственнаяОперация");
			
		КонецЕсли;
		
		ВариантРаспределенияРасходов = Неопределено;
		Если Параметры.Отбор.Свойство("ВариантРаспределенияРасходов", ВариантРаспределенияРасходов) Тогда
			Если ЗначениеЗаполнено(ВариантРаспределенияРасходов) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список,
					"ВариантРаспределенияРасходовУпр",
					ВариантРаспределенияРасходов,
					ВидСравненияКомпоновкиДанных.ВСписке,,
					Истина);
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список,
					"ВариантРаспределенияРасходовРегл",
					ВариантРаспределенияРасходов,
					ВидСравненияКомпоновкиДанных.ВСписке,,
					Истина);	
			КонецЕсли;
			Параметры.Отбор.Удалить("ВариантРаспределенияРасходов");
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("ВариантРаспределенияРасходовИли", ВариантРаспределенияРасходов) Тогда
			Если ЗначениеЗаполнено(ВариантРаспределенияРасходов) Тогда
				ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
					Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
					НСтр("ru='Варианты распределения расходов'"), 
					ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбора,
					"ВариантРаспределенияРасходовУпр",
					ВариантРаспределенияРасходов, 
					ВидСравненияКомпоновкиДанных.ВСписке,
					"ВариантРаспределенияРасходовУпр",
					Истина);
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбора,
					"ВариантРаспределенияРасходовРегл",
					ВариантРаспределенияРасходов, 
					ВидСравненияКомпоновкиДанных.ВСписке,
					"ВариантРаспределенияРасходовРегл",
					Истина);
			КонецЕсли;
			Параметры.Отбор.Удалить("ВариантРаспределенияРасходовИли");
		КонецЕсли;
		
		ВидДеятельностиДляНалоговогоУчетаЗатрат = Неопределено;
		Если Параметры.Отбор.Свойство("ВидДеятельностиДляНалоговогоУчетаЗатрат", ВидДеятельностиДляНалоговогоУчетаЗатрат) Тогда
			Параметры.Отбор.Удалить("ВидДеятельностиДляНалоговогоУчетаЗатрат");
		КонецЕсли;
	
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Список.Параметры.УстановитьЗначениеПараметра("БезОграниченияИспользования", Не ЗначениеЗаполнено(ХозяйственнаяОперация));
	
	ФормироватьФинансовыйРезультат = ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат");
	
	ЭтоУТБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	Если ЭтоУТБазовая Тогда
		Элементы.ВариантРаспределенияРасходовРегл.Заголовок = НСтр("ru = 'Вариант распределения'");
		Элементы.ВариантРаспределенияРасходовУпр.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
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

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		ПланыВидовХарактеристик.СтатьиРасходов.ЗаблокированныеСтатьиРасходов(),
		ВидСравненияКомпоновкиДанных.НеВСписке);
	
КонецПроцедуры

#КонецОбласти
