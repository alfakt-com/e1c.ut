﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаказПоставщику = Неопределено;
	
	Если Параметры.Свойство("ПараметрКоманды", ЗаказПоставщику) 
			ИЛИ Параметры.Свойство("ЗаказПоставщику", ЗаказПоставщику) Тогда
		
		Если ТипЗнч(ЗаказПоставщику) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			ДокументыЗаказов.Добавить(Параметры.Партнер);
		ИначеЕсли ТипЗнч(ЗаказПоставщику) = Тип("Массив") Тогда
			ДокументыЗаказов.ЗагрузитьЗначения(ЗаказПоставщику);
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	СформироватьОтчет();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьОтчет();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура СформироватьОтчет()

	ТаблицаОтчета.Очистить();
	ОбъектОтчет = РеквизитФормыВЗначение("Отчет");
	
	Для Каждого ДокументЗаказа Из ДокументыЗаказов Цикл
		
		ОбъектОтчет.СформироватьОтчет(ТаблицаОтчета, ДокументЗаказа.Значение)
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
