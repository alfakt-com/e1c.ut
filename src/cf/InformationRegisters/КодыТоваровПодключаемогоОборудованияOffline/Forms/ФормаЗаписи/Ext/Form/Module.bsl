﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	КодНачалоВыбораИзСпискаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код
	|ИЗ
	|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
	|ГДЕ
	|	КодыТоваровПодключаемогоОборудованияOffline.Код = &Код
	|	И КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = &ПравилоОбмена
	|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|");
	
	Запрос.УстановитьПараметр("Код", ТекущийОбъект.Код);
	Запрос.УстановитьПараметр("ПравилоОбмена", ТекущийОбъект.ПравилоОбмена);
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		УдаляемаяЗапись = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьМенеджерЗаписи();
		УдаляемаяЗапись.Код = ТекущийОбъект.Код;
		УдаляемаяЗапись.ПравилоОбмена = ТекущийОбъект.ПравилоОбмена;
		УдаляемаяЗапись.Удалить();
	КонецЕсли;
	
	Код = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьМаксимальныйКод(Запись.ПравилоОбмена)+1;
	Пока Код < ТекущийОбъект.Код Цикл
		ПодключаемоеОборудованиеOfflineВызовСервера.УдалитьКод(ТекущийОбъект.ПравилоОбмена, Код);
		Код = Код+1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Запись.ИсходныйКлючЗаписи.Код <> ТекущийОбъект.Код Тогда
		ПодключаемоеОборудованиеOfflineВызовСервера.УдалитьКод(ТекущийОбъект.ПравилоОбмена, Запись.ИсходныйКлючЗаписи.Код);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
	|	КодыТоваровПодключаемогоОборудованияOffline.Номенклатура КАК Номенклатура,
	|	КодыТоваровПодключаемогоОборудованияOffline.Характеристика КАК Характеристика,
	|	КодыТоваровПодключаемогоОборудованияOffline.Упаковка КАК Упаковка,
	|	КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.Наименование КАК НоменклатураПредставление,
	|	КодыТоваровПодключаемогоОборудованияOffline.Характеристика.Наименование КАК ХарактеристикаПредставление,
	|	КодыТоваровПодключаемогоОборудованияOffline.Упаковка.Наименование КАК УпаковкаПредставление
	|ИЗ
	|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
	|ГДЕ
	|	КодыТоваровПодключаемогоОборудованияOffline.Код = &Код
	|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|");
	
	Запрос.УстановитьПараметр("Код", Запись.Код);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() // Штрихкод уже записан в БД
		И Запись.ИсходныйКлючЗаписи.Код <> Запись.Код Тогда
		
		ОписаниеОшибки = НСтр("ru='Такой код уже назначен для номенклатуры %Номенклатура%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Номенклатура%", """" + Выборка.НоменклатураПредставление + """"
		                + ?(ЗначениеЗаполнено(Выборка.Характеристика), " " + НСтр("ru='с характеристикой'") + " """ + Выборка.ХарактеристикаПредставление + """", "")
		                + ?(ЗначениеЗаполнено(Выборка.Упаковка), " " + НСтр("ru='в упаковке'") + " """ + Выборка.УпаковкаПредставление + """", ""));
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки;
		Сообщение.Поле = "Запись.Код";
		Сообщение.Сообщить();
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура КодНачалоВыбораИзСпискаНаСервере()
	
	СвободныеКоды = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьСвободныеКоды(Запись.ПравилоОбмена, 20);
	НоваяСтрока = СвободныеКоды.Добавить();
	НоваяСтрока.Код = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьМаксимальныйКод(Запись.ПравилоОбмена)+1;
	
	Элементы.Код.СписокВыбора.Очистить();
	Для Каждого СвободныйКод Из СвободныеКоды Цикл
		Элементы.Код.СписокВыбора.Добавить(СвободныйКод.Код);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
