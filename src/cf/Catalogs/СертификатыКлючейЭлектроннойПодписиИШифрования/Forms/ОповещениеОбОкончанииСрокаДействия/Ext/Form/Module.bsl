﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Сертификат = Параметры.Сертификат;
	
	СертификатДействителенДо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Сертификат, "ДействителенДо");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если БольшеНеНапоминать Тогда
		УстановитьПометкуНаСервере(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьПометкуНаСервере(Сертификат)
	
	СертификатОбъект = Сертификат.ПолучитьОбъект();
	СертификатОбъект.ПользовательОповещенОСрокеДействия = Истина;
	СертификатОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти
