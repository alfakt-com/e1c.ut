﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстСообщения = НСтр(
		"ru = 'Будет выполнено прерывание процесса и его невыполненных задач.
		|Состояния документов, установленные этим процессом, будут очищены.
		|
		|Внимание! Все внесенные изменения будут необратимыми.'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрерватьПроцесс(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

