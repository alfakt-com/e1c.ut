﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьИсториюПоиска(Элементы.СтрокаПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите, что нужно найти.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПереданнаяСтрокаПоиска", СтрокаПоиска);
	
	ОткрытьФорму("ОбщаяФорма.ФормаПоиска", ПараметрыФормы,, Истина);
	
	ОбновитьИсториюПоиска(Элементы.СтрокаПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсториюПоиска(Элемент)
	
	ИсторияПоиска = СохраненнаяИсторияПоиска();
	Если ТипЗнч(ИсторияПоиска) = Тип("Массив") Тогда
		Элемент.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохраненнаяИсторияПоиска()
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "");
	
КонецФункции

#КонецОбласти
