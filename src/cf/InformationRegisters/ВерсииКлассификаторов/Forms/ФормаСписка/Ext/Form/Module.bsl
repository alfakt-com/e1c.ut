﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ВерсииКлассификаторов.ФормаСпискаПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
