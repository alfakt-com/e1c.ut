﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
		
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Автор.Пустая() тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры


