﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КассаККМОтбор = Параметры.КассаККМ;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаККМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
КонецПроцедуры

#КонецОбласти
