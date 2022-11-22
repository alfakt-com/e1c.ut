﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ЗначениеПараметраЗаголовок;
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок", ЗначениеПараметраЗаголовок) Тогда
		Заголовок = ЗначениеПараметраЗаголовок;
	Иначе
		Заголовок = НСтр("ru='Подключаемое оборудование (%КоличествоКасс%)'");
	КонецЕсли;
	
	Если Параметры.Свойство("ЕдиницыИзмерения") Тогда
		ЗаполнитьСписокЕдиницИзмерения(Параметры.СписокЕдиницИзмерения);
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЕдиницыИзмерения;
	Иначе
		СписокКасс.ЗагрузитьЗначения(Параметры.СписокКасс.ВыгрузитьЗначения());
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаСписокКасс;
	КонецЕсли;
	
	Заголовок = СтрЗаменить(Заголовок, "%КоличествоКасс%", СписокКасс.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокКассВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(Неопределено, Элементы.СписокКасс.ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокЕдиницИзмерения(СписокЕдиницСервиса)
	
	Для каждого ЭлементМассива Из СписокЕдиницСервиса Цикл
		НоваяСтрока = СписокЕдиницИзмерения.Добавить();
		НоваяСтрока.Код = ?(ЭлементМассива.Code < 1000, Формат(ЭлементМассива.Code, "ЧЦ=3; ЧВН=; ЧГ="), Формат(ЭлементМассива.Code, "ЧЦ=4; ЧВН=; ЧГ="));
		НоваяСтрока.НаименованиеРус = ЭлементМассива.NameRu;
		НоваяСтрока.НаименованиеКаз = ЭлементМассива.NameKz;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти