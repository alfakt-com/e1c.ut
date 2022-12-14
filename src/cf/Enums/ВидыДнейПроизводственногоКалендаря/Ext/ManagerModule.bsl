#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДанныеВыбора = Новый СписокЗначений;
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыДнейПроизводственногоКалендаря.ЗначенияПеречисления Цикл
		Если Перечисления.ВидыДнейПроизводственногоКалендаря[ЗначениеПеречисления.Имя] <> Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
			ДанныеВыбора.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря[ЗначениеПеречисления.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
