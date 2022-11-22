﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьСписокССервера(Команда)

	КомандаОбновитьСписокССервераСервер();
	Элементы.СписокЗаписей.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДанныеССервера(Команда)

	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
		Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
		ЭтотОбъект,
		"");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура КомандаОбновитьСписокССервераСервер()

	Обработки.УправлениеНовостями.ОбновитьСписокСправочниковИВерсииССервера();

КонецПроцедуры

#КонецОбласти
