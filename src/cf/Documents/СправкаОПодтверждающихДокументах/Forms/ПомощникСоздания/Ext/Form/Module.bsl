﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = СозданныеДокументы.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКомандыСпискаДокументов;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// КомандыЭДО
	ОбменСБанками.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюЭДО);
	// Конец КомандыЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СправкаОПодтверждающихДокументах" Тогда
		Элементы.СозданныеДокументы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьБезВопроса Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ТекстВопроса = НСтр("ru = 'Работа по созданию документов не была завершена. Закрыть форму?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытии", ЭтотОбъект), ТекстВопроса, Кнопки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьПодтверждающиеДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура Провести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СозданныеДокументы, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИУдалить(Команда)
	
	ДлительнаяОперация = НачатьУдалениеСозданныхДокументов();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.Вставить("ТекстСообщения", НСтр("ru = 'Удаление справок о подтверждающих документах...'"));
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииУдаленияСозданныхДокументов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	ДлительнаяОперация = СформироватьНаСервере();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииСозданияДокументов", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.Вставить("ТекстСообщения", НСтр("ru = 'Создание документов...'"));
	ПараметрыОжидания.Вставить("ВыводитьПрогрессВыполнения", Истина);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция СформироватьНаСервере()
	
	ДокументыКСозданию = Новый Массив;
	
	СтрокиКСозданию = ПодтверждающиеДокументы.НайтиСтроки(Новый Структура("Пометка", Истина));
	ТаблицаДокументов = ПодтверждающиеДокументы.Выгрузить(СтрокиКСозданию);
	
	КопияТаблицы = ТаблицаДокументов.Скопировать(, "Организация, Контрагент, Договор");
	КопияТаблицы.Свернуть("Организация, Контрагент, Договор");
	
	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	&ТаблицаДокументов КАК ТаблицаДокументов
	|";
	
	Запрос.УстановитьПараметр("ТаблицаДокументов", ТаблицаДокументов);
	Запрос.Выполнить();
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	*,
	|	ТаблицаДокументов.Договор.БанковскийСчет.Банк       КАК Банк,
	|	ТаблицаДокументов.Ссылка                            КАК ПодтверждающийДокумент,
	|	ТаблицаДокументов.Ссылка.Номер                      КАК НомерДокумента,
	|	ТаблицаДокументов.Ссылка.Дата                       КАК ДатаДокумента,
	|	ТаблицаДокументов.Валюта                            КАК ВалютаДокумента,
	|	ТаблицаДокументов.Договор.ВалютаВзаиморасчетов      КАК ВалютаДоговора,
	|	ТаблицаДокументов.Контрагент.СтранаРегистрации      КАК Страна
	|
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|";
	
	ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
	
	СтруктураГруппировки = Новый Структура("Организация, Контрагент, Договор");
	
	Для каждого СтрокаГруппировки Из КопияТаблицы Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураГруппировки, СтрокаГруппировки);
		
		ДокументКСозданию = Новый Структура;
		ДокументКСозданию.Вставить("ТипДокумента", "СправкаОПодтверждающихДокументах");
		ДокументКСозданию.Вставить("ДанныеЗаполнения", ТаблицаДокументов.Скопировать(СтруктураГруппировки));
		ДокументыКСозданию.Добавить(ДокументКСозданию);
	КонецЦикла;
	
	НаименованиеЗадания = НСтр("ru = 'Формирование документов'");
	ВыполняемыйМетод = "ДенежныеСредстваСервер.СоздатьПлатежи";
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДокументыКСозданию", ДокументыКСозданию);
	СтруктураПараметров.Вставить("КлючВременногоХранилища", "ПомощникФормированияСПД");
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СтруктураПараметров, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииСозданияПлатежныхДокументов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ПриЗавершенииСозданияПлатежныхДокументовНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииСозданияПлатежныхДокументовНаСервере()
	
	ЗагрузитьСозданныеДокументы();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьИЗакрыть(Команда)
	
	ВопросНепроведенныеДокументы();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СозданныеДокументы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СозданныеДокументы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СозданныеДокументы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПодтверждающиеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого СтрокаПодтверждающиеДокументы Из ПодтверждающиеДокументы Цикл
		СтрокаПодтверждающиеДокументы.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	Для Каждого СтрокаПодтверждающиеДокументы Из ПодтверждающиеДокументы Цикл
		СтрокаПодтверждающиеДокументы.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ЭтапВыбораДокументов = (Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыборДокументов);
	
	Элементы.Закрыть.Видимость = ЭтапВыбораДокументов;
	Элементы.Сформировать.Видимость = ЭтапВыбораДокументов;
	Элементы.ОтменитьИУдалить.Видимость = Не ЭтапВыбораДокументов;
	Элементы.ПринятьИЗакрыть.Видимость = Не ЭтапВыбораДокументов;
	
	Если ЭтапВыбораДокументов Тогда
		Элементы.ДекорацияШаги.Заголовок = НСтр("ru = 'Шаг 1: отбор документов для справок'");
	Иначе
		КоличествоДокументов = СписокДокументов.Количество();
		
		СклонениеСоздано = НСтр("ru = 'Создан, Создано, Создано'");
		Создано = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеСоздано);
		Создано = СтрЗаменить(Создано, КоличествоДокументов + " ", "");
		
		СклонениеДокументов = НСтр("ru = 'документ, документа, документов'");
		Документов = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеДокументов);
		
		Элементы.ДекорацияШаги.Заголовок = НСтр("ru = 'Шаг 2:'") + " " + Создано + " " + Документов;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодтверждающиеДокументы()
	
	ПоляТаблицы = Новый Структура("Ссылка, Организация, Контрагент, Договор, СуммаДокумента, Валюта");
	
	Если ЗначениеЗаполнено(Договор) Тогда
		ПоляОтбора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Организация, Контрагент");
		ПоляОтбора.Вставить("Договор", Договор);
	Иначе
		ПоляОтбора = Новый Структура("Организация, Контрагент", Организация, Контрагент);
	КонецЕсли;
	
	Схема = Новый СхемаЗапроса;
	Пакет = Схема.ПакетЗапросов[0];
	
	Для каждого ТипДокумента Из Метаданные.ОпределяемыеТипы.ПодтверждающийДокумент.Тип.Типы() Цикл
		
		МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипДокумента);
		
		Если Не ПравоДоступа("Чтение", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Оператор = Пакет.Операторы.Добавить();
		Источник = Оператор.Источники.Добавить("Документ." + МетаданныеДокумента.Имя);
		
		Для каждого Поле Из ПоляТаблицы Цикл
			Если Источник.Источник.ДоступныеПоля.Найти(Поле.Ключ) <> Неопределено Тогда
				Оператор.ВыбираемыеПоля.Добавить(Поле.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		Для каждого ПолеОтбора Из ПоляОтбора Цикл
			Если ЗначениеЗаполнено(ПолеОтбора.Значение) Тогда
				ДоступноеПоле = Источник.Источник.ДоступныеПоля.Найти(ПолеОтбора.Ключ);
				Если ДоступноеПоле <> Неопределено Тогда
					Оператор.Отбор.Добавить(Источник.Источник.Псевдоним + "." + ПолеОтбора.Ключ + " В (&" + ПолеОтбора.Ключ + ")");
				Иначе
					Оператор.Отбор.Добавить("ЛОЖЬ");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Пакет.Операторы.Удалить(0);
	Пакет.ВыбиратьРазрешенные = Истина;
	
	Запрос = Новый Запрос(Схема.ПолучитьТекстЗапроса());
	
	Для каждого ПолеОтбора Из ПоляОтбора Цикл
		Если ЗначениеЗаполнено(ПолеОтбора.Значение) Тогда
			Запрос.УстановитьПараметр(ПолеОтбора.Ключ, ПолеОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ПодтверждающиеДокументы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСозданныеДокументы()
	
	АдресДокументов = ПрочитатьДанныеИзБезопасногоХранилища();
	Если ЗначениеЗаполнено(АдресДокументов) Тогда
		УдалитьДанныеИзБезопасногоХранилища();
	Иначе
		ВызватьИсключение НСтр("ru='Произошла исключительная ситуация при создании документов.'");
		Возврат;
	КонецЕсли;
	СписокДокументов.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(АдресДокументов));
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСозданныеДокументы;
	ЗагрузитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписок()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СозданныеДокументы,
		"Ссылка",
		СписокДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииСозданияДокументов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ПриЗавершенииСозданияДокументовНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииСозданияДокументовНаСервере()
	
	ЗагрузитьСозданныеДокументы();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Функция НачатьУдалениеСозданныхДокументов()
	
	ВыполняемыйМетод = "ДенежныеСредстваСервер.УдалитьПлатежи";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СписокДокументов.ВыгрузитьЗначения(), ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииУдаленияСозданныхДокументов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат;
	КонецЕсли;
	
	СписокОшибок = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если ЗначениеЗаполнено(СписокОшибок) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок);
		Элементы.СозданныеДокументы.Обновить();
	Иначе
		ЗакрытьБезВопроса = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросНепроведенныеДокументы(ВыгрузкаВБанк = Ложь)
	
	Если ЕстьНепроведенныеДокументы() Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да);
		Кнопки.Добавить(КодВозвратаДиалога.Нет);
		ТекстВопроса = НСтр("ru='Некоторые документы не были проведены. Вы уверены, что хотите оставить документы непроведенными?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОЗакрытииНепроведенныеДокументы", ЭтотОбъект, ВыгрузкаВБанк);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ЗакрытьБезВопроса = Истина;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытииНепроведенныеДокументы(РезультатВопроса, ВыгрузкаВБанк) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьБезВопроса = Истина;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.ОК Тогда
		ЗакрытьБезВопроса = Истина;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьНепроведенныеДокументы()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	Документ.СправкаОПодтверждающихДокументах КАК ДанныеДокумента
	|ГДЕ
	|	НЕ ДанныеДокумента.Проведен
	|	И ДанныеДокумента.Ссылка В (&СписокДокументов)
	|");
	
	Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПрочитатьДанныеИзБезопасногоХранилища()
	
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ЗащищенныеДанные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "ПомощникФормированияСПД");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЗащищенныеДанные;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьДанныеИзБезопасногоХранилища()
	
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Владелец, "ПомощникФормированияСПД");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


#КонецОбласти