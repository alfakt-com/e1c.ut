﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ЗакрытиеМесяцаСервер.ЭтаФормаОткрытаИзФормыЗакрытияМесяца(ЭтаФорма) Тогда
		
		ЭтаФорма.КлючНазначенияИспользования = "КонтекстЗакрытиеМесяца";
		Параметры = ЭтаФорма.Параметры;
		ФормаПараметры = ЭтаФорма.ФормаПараметры;
		
		ФормаПараметры.КлючНазначенияИспользования = ЭтаФорма.КлючНазначенияИспользования;
		
		ПериодОтчета = Новый СтандартныйПериод(НачалоМесяца(Параметры.ПериодРегистрации), КонецМесяца(Параметры.ПериодРегистрации));
		ФормаПараметры.Отбор.Очистить();
		ФормаПараметры.Отбор.Вставить("ПериодОтчета", ПериодОтчета);
		Если НЕ Параметры.ВсеОрганизации Тогда
			ФормаПараметры.Отбор.Вставить("Организация", Параметры.МассивОрганизаций);
		КонецЕсли;
		
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	УстановитьОтборТребующиеНачисления(НастройкиОтчета);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураДинамическихЗаголовков(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОтборТребующиеНачисления(НастройкиОтчета)
	
	Отборы = Новый Структура;
	ПолучитьОтборыТребующиеНачисления(НастройкиОтчета.Структура, Отборы);
	Если Отборы.Свойство("Аналитика") Тогда
		НовоеИспользование = Отборы.Аналитика.Использование;
		Для Каждого Отбор Из Отборы Цикл
			Отбор.Значение.Использование = НовоеИспользование;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОтборыТребующиеНачисления(СтруктураОтчета, Отборы)
	
	Для Каждого Группировка Из СтруктураОтчета Цикл
		
		Если ТипЗнч(Группировка) = Тип("ГруппировкаКомпоновкиДанных")
			ИЛИ ТипЗнч(Группировка) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
			ЭлементОтбора = НайтиОтборПоПредставлению(Группировка.Отбор.Элементы, "ТребующиеНачисления");
			Если ЭлементОтбора <> Неопределено Тогда
				Отборы.Вставить(Группировка.Имя, ЭлементОтбора);
			КонецЕсли;
			ПолучитьОтборыТребующиеНачисления(Группировка.Структура, Отборы);
			
		ИначеЕсли ТипЗнч(Группировка) = Тип("ТаблицаКомпоновкиДанных") Тогда
			ПолучитьОтборыТребующиеНачисления(Группировка.Строки, Отборы);
			ПолучитьОтборыТребующиеНачисления(Группировка.Колонки, Отборы);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

Функция НайтиОтборПоПредставлению(Отбор, Представление)
	
	Результат = Неопределено;
	Для Каждого Элемент Из Отбор Цикл
		Если СтрНачинаетсяС(Элемент.Представление, Представление) Тогда
			Результат = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция СтруктураДинамическихЗаголовков()
	
	ДинамическиеЗаголовки = Новый Структура;
	
	ДинамическиеЗаголовки.Вставить("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	ДинамическиеЗаголовки.Вставить("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	
	Возврат ДинамическиеЗаголовки;
	
КонецФункции

#КонецОбласти

#КонецЕсли
