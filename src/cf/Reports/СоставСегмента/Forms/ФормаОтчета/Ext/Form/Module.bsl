﻿
#Область ОбработчикиСобытийФормы
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда 
		Параметры.Сегмент = Параметры.ПараметрКоманды;
	КонецЕсли;
	
	Сегмент = Параметры.Сегмент;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сегмент,"ЭтоГруппа") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отчет не может быть сформирован для группы сегментов.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Партнеры = (
		ТипЗнч(Сегмент) = Тип("СправочникСсылка.СегментыПартнеров"));
	ХарактеристикиНоменклатуры =
		ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	Элементы.ДобавитьВСегмент.Видимость = (
		Сегмент.СпособФормирования =
		Перечисления.СпособыФормированияСегментов.ФормироватьВручную);
	Элементы.УдалитьИзСегмента.Видимость = Элементы.ДобавитьВСегмент.Видимость;
	Элементы.ДобавитьВСегментПоОтбору.Видимость = Элементы.ДобавитьВСегмент.Видимость И НЕ Партнеры;
	Элементы.СформироватьСегмент.Видимость = (
		Сегмент.СпособФормирования <>
		Перечисления.СпособыФормированияСегментов.ФормироватьДинамически);
	
	Отчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить(
		"Сегмент", Сегмент);
	
	Если Партнеры Тогда
		ПравоИзменения = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПартнерыСегмента);
	Иначе
		ПравоИзменения = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НоменклатураСегмента);
	КонецЕсли;
	
	Элементы.ГруппаИзменениеСегмента.Доступность = ПравоИзменения;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	Если ТипЗнч(Расшифровка) <> Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	Элемент = ЗначениеРасшифровкиЭлемента(Расшифровка);
	Если ЗначениеЗаполнено(Элемент) Тогда
		ПоказатьЗначение(Неопределено, Элемент);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВСегмент(Команда)

	Если Партнеры Тогда
		Элемент = Неопределено;

		ОткрытьФорму("Справочник.Партнеры.ФормаВыбора",Новый Структура("МножественныйВыбор",Истина),,,,, Новый ОписаниеОповещения("ДобавитьВСегментПослеВыбора", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	ИначеЕсли ХарактеристикиНоменклатуры Тогда
		ОткрытьФорму("Отчет.СоставСегмента.Форма.ВыборНоменклатуры",,,,,, Новый ОписаниеОповещения("ДобавитьВСегментПослеВыбораСостава", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	Иначе
		ПараметрыФормыВыбораНоменклатуры = Новый Структура;
		ПараметрыФормыВыбораНоменклатуры.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
		
		РезультатВыбора = Неопределено;

		
		ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",ПараметрыФормыВыбораНоменклатуры,,,,, Новый ОписаниеОповещения("ДобавитьВСегментЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	КонецЕсли;
	
	ДобавитьВСегментФрагмент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментПослеВыбора(Результат1, ДополнительныеПараметры) Экспорт
    
    Элемент = Результат1;
    
    ДобавитьВСегментФрагмент(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментПослеВыбораСостава(Результат1, ДополнительныеПараметры) Экспорт
    
    Элемент = Результат1;
    Если ТипЗнч(Элемент) <> Тип("Структура") Тогда
        Возврат;
    КонецЕсли;
    
    ДобавитьВСегментФрагмент(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментЗавершение(Результат1, ДополнительныеПараметры) Экспорт
    
    РезультатВыбора = Результат1;
    Элемент = ?(РезультатВыбора = Неопределено,Неопределено,Новый Структура("Номенклатура",РезультатВыбора));
    
    ДобавитьВСегментФрагмент(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментФрагмент(Знач Элемент)
    
    Если ЗначениеЗаполнено(Элемент) Тогда
        ДобавитьЭлемент(Элемент,Истина,Истина);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзСегмента(Команда)
	
	МассивРасшифровок = Новый Массив();
	Области = Результат.ВыделенныеОбласти;
	
	Для Каждого Область Из Области Цикл
		
		Если Область.Верх = 0 Тогда
			ОчиститьСегмент();
			Возврат;
		Иначе
			
			Для Строка = Область.Верх По Область.Низ Цикл
				Для Столбец = 1 По 200 Цикл
					Попытка
						Расшифровка = Результат.Область("R" + Формат(Строка, "ЧГ=0") + "C" + Столбец).Расшифровка;
						Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
							МассивРасшифровок.Добавить(Расшифровка);
							Прервать;
						КонецЕсли;
					Исключение
						Продолжить;
					КонецПопытки
				КонецЦикла;
			КонецЦикла;
			УдалитьЭлементы(МассивРасшифровок);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСегмент()

	СегментыВызовСервера.Очистить(Сегмент);
	СкомпоноватьРезультат();

КонецПроцедуры

&НаКлиенте
Процедура СформироватьСегмент(Команда)

	ОбработчикЗавершения = Новый ОписаниеОповещения( "ПриОтветеНаВопросФормированиеСегмента", ЭтотОбъект);
	ПоказатьВопрос(ОбработчикЗавершения,
	               НСтр("ru = 'Состав сегмента будет переформирован в соответствии с настройками схемы компоновки. Продолжить?'"),
	               РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментПоОтбору(Команда)
	
	ЗаголовокФормыПодбора = НСтр("ru='Подбор номенклатуры в сегмент'");
	ЗаголовокКнопкиПеренестиФормыПодбора = НСтр("ru='Перенести в сегмент'");
	
	АдресВоВременномХранилище = Неопределено;

	
	ОткрытьФорму(
		"Обработка.ПодборТоваровПоОтбору.Форма.Форма",
		Новый Структура("Заголовок,ЗаголовокКнопкиПеренести, УникальныйИдентификатор",ЗаголовокФормыПодбора, ЗаголовокКнопкиПеренестиФормыПодбора, УникальныйИдентификатор),
		ЭтаФорма,,,, Новый ОписаниеОповещения("ДобавитьВСегментПоОтборуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментПоОтборуЗавершение(Результат1, ДополнительныеПараметры) Экспорт
    
    АдресВоВременномХранилище = Результат1;
    Если ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
        ДобавитьНоменклатуруПоОтборуНаСервере(АдресВоВременномХранилище);
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОтветеНаВопросФормированиеСегмента(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Если КодВозврата = КодВозвратаДиалога.Да Тогда
		
		СформироватьСегментСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементы(Расшифровки)
	
	ДанныеРасшифровкиОтчета = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	Для Каждого Расшифровка Из Расшифровки Цикл
		ЭлементРасшифровки = ДанныеРасшифровкиОтчета.Элементы[Расшифровка];
		Для Каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Значение = ЗначениеПоляРасшифровки.Значение;
			Если Партнеры Тогда
				Если ТипЗнч(Значение) = Тип("СправочникСсылка.Партнеры") Тогда
					НаборЗаписей = РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Сегмент.Установить(Сегмент);
					НаборЗаписей.Отбор.Партнер.Установить(Значение);
					НаборЗаписей.Записать();
				КонецЕсли;
			Иначе 
				Если ТипЗнч(Значение) = Тип("СправочникСсылка.Номенклатура") Тогда
					НаборЗаписей = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Сегмент.Установить(Сегмент);
					НаборЗаписей.Отбор.Номенклатура.Установить(Значение);
					Попытка
						ЗначениеСледущейРасшифровки = ДанныеРасшифровкиОтчета.Элементы[Расшифровка+1].ПолучитьПоля()[0].Значение;
						Если ТипЗнч(ЗначениеСледущейРасшифровки) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
							НаборЗаписей.Отбор.Характеристика.Установить(ЗначениеСледущейРасшифровки);
						Иначе
							НаборЗаписей.Отбор.Характеристика.Установить(Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
						КонецЕсли;
					Исключение
						Продолжить;
					КонецПопытки;
					НаборЗаписей.Записать();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	СкомпоноватьРезультат();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлемент(Элемент, СкомпоноватьРезультат = Ложь, ВыводитьСообщения = Ложь)
	
	Если ТипЗнч(Элемент) = Тип("Массив") Тогда
		Для каждого ЭлементМассива Из Элемент Цикл
			ДобавитьЭлемент(ЭлементМассива,СкомпоноватьРезультат,ВыводитьСообщения);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Если Партнеры Тогда
		Если Элемент.Пустая() Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Если Элемент.Номенклатура.Пустая() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Партнеры Тогда
		Запись = РегистрыСведений.ПартнерыСегмента.СоздатьМенеджерЗаписи();
		Запись.Сегмент = Сегмент;
		Запись.Партнер = Элемент;
	Иначе
		Запись = РегистрыСведений.НоменклатураСегмента.СоздатьМенеджерЗаписи();
		Запись.Сегмент = Сегмент;
		Если ХарактеристикиНоменклатуры Тогда
			Запись.Номенклатура = Элемент.Номенклатура;
			Если ЗначениеЗаполнено(Элемент.Характеристика) Тогда
				Запись.Характеристика = Элемент.Характеристика;
			КонецЕсли;
		Иначе
			Запись.Номенклатура = Элемент.Номенклатура;
		КонецЕсли;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Если ВыводитьСообщения Тогда
			Если Партнеры Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Элемент.Наименование + " " + НСтр("ru='уже включен в сегмент.'"))
			Иначе	
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Строка(Строка(Элемент.Номенклатура) + ?(Элемент.Характеристика.Пустая(),"","/" + Строка(Элемент.Характеристика))) + " " + НСтр("ru='уже включен в сегмент.'"));
			КонецЕсли;
		КонецЕсли;
	Иначе
		
		Запись.Сегмент = Сегмент;
		Если Партнеры Тогда
			Запись.Партнер = Элемент;
		Иначе
			Если ХарактеристикиНоменклатуры Тогда
				Запись.Номенклатура = Элемент.Номенклатура;
				Если ЗначениеЗаполнено(Элемент.Характеристика) Тогда
					Запись.Характеристика = Элемент.Характеристика;
				КонецЕсли;
			Иначе
				Запись.Номенклатура = Элемент.Номенклатура;
			КонецЕсли;
		КонецЕсли;
		Запись.Записать();
		Если СкомпоноватьРезультат Тогда
			СкомпоноватьРезультат();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗначениеРасшифровкиЭлемента(Расшифровка)

	ДанныеРасшифровкиОтчета = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	ЭлементРасшифровки = ДанныеРасшифровкиОтчета.Элементы[Расшифровка];

	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Значение = ЗначениеПоляРасшифровки.Значение;
			Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Значение))
			 ИЛИ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Значение)) Тогда
				Возврат Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

&НаСервере
Процедура ДобавитьНоменклатуруПоОтборуНаСервере(АдресВоВременномХранилище);

	ТаблицаНоменклатура = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Для каждого СтрокаТаблицы Из ТаблицаНоменклатура Цикл
		ДобавитьЭлемент(СтрокаТаблицы);
	КонецЦикла;

	СкомпоноватьРезультат();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСегментСервер()

	СегментыВызовСервера.Сформировать(Сегмент);
	СкомпоноватьРезультат();

КонецПроцедуры

#КонецОбласти
