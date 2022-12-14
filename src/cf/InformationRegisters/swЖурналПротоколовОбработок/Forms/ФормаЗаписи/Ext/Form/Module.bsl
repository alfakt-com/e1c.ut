
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Запись.ДатаНачала) Тогда
		Элементы.НадписьПродолжительностьВыполнения.Заголовок = "";
	ИначеЕсли Не ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда
		Элементы.НадписьПродолжительностьВыполнения.Заголовок = "Не была закончена";
	Иначе
		Продолжительность = Запись.ДатаОкончания - Запись.ДатаНачала;
		Часов = Цел(Продолжительность / 3600);
		Минут = Цел((Продолжительность - (Часов * 3600)) / 60);
		Секунд = Продолжительность - (Часов * 3600) - (Минут * 60);
		Элементы.НадписьПродолжительностьВыполнения.Заголовок = Формат(Часов, "ЧЦ=8; ЧДЦ=0; ЧН=0") + ":" + Формат(Минут, "ЧЦ=2; ЧДЦ=0; ЧН=00; ЧВН=") + ":" + Формат(Секунд, "ЧЦ=2; ЧДЦ=0; ЧН=00; ЧВН=");
	КонецЕсли;
КонецПроцедуры
