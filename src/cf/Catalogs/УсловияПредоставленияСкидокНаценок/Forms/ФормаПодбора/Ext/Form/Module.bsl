﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УсловияПредоставления = Параметры.УсловияПредоставления.Скопировать();
	Заголовок = Заголовок + ": " + Строка(Параметры.Документ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСоздать",
		"Видимость",
		ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.УсловияПредоставленияСкидокНаценок));
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СкидкиНаценкиСервер.ДобавитьКомандыСозданияНовыхУсловийПредоставленияСкидокНаценок(ЭтотОбъект, Элементы.ГруппаСоздать);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПоиска = УсловияПредоставления.НайтиПоЗначению(Элемент.ТекущиеДанные.Ссылка);
	
	Если РезультатПоиска = Неопределено Тогда
		УсловияПредоставления.Добавить(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если УсловияПредоставления.Количество() = 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПеренестиВДокументЗавершение", ЭтотОбъект), НСтр("ru = 'Не подобрано ни одного условия. Закрыть?'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	
	Закрыть(УсловияПредоставления);
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Закрыть(УсловияПредоставления);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	СкидкиНаценкиКлиент.ОбработатьКомандуДобавленияУсловияПредоставленияСкидокНаценок(
		ЭтотОбъект,
		Команда,
		Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
