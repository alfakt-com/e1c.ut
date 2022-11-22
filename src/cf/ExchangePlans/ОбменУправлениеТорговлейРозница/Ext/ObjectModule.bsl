﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если НЕ ИспользоватьОтборПоОрганизациям Тогда
		Организации.Очистить();
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоВидамЦен Тогда
		ВидыЦен.Очистить();
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоКассам Тогда
		Кассы.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли