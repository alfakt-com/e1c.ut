﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Дата) Тогда
		Параметры.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ВалютаДокумента = Параметры.ВалютаДокумента;
	ВыполняетсяЗакрытие = Ложь;
	
	Заголовок = СтрШаблон(НСтр("ru = 'Подбор материалов из заказа: %1'"), Параметры.ЗаказПереработчику);
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "ТаблицаТоваровНоменклатураЕдиницаИзмерения",
		"ТаблицаТоваров.Упаковка");
	
	ЗаполнитьТаблицуТоваров(Параметры.ЗаказПереработчику, Параметры.ДокументВводаОстатков, Параметры.ВалютаДокумента);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы И Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Ответ = РезультатВопроса;

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		ПеренестиТоварыВДокумент();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		
		// Снятие модифицированности, т.к. перед закрытием признак проверяется.
		Модифицированность = Ложь;

		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиТоварыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТоваров.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	// Формирование таблицы для возврата в документ.
	ТаблицаВыбранныхТоваров = ТаблицаТоваров.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(Новый Структура("Товары", ТаблицаВыбранныхТоваров));
	
	Возврат АдресТоваровВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров(ЗаказПереработчику, Документ, ВалютаДокумента)
	
	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Валюта", Параметры.ВалютаДокумента);
	ДанныеОтбора.Вставить("Склад",  Параметры.Склад);
	ДанныеОтбора.Вставить("Ссылка", Параметры.ДокументВводаОстатков);
	ДанныеОтбора.Вставить("Дата",   Параметры.Дата);
	
	МассивЗаказов = Новый Массив();
	МассивЗаказов.Добавить(Параметры.ЗаказПереработчику);
	
	ЗаполнитьПоОстаткамЗаказов(
		ДанныеОтбора,
		ТаблицаТоваров,
		МассивЗаказов,
		Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамЗаказов(ДанныеОтбора, 
	                                 Товары,
	                                 МассивЗаказов = Неопределено,
	                                 ЗаполнятьНаДатуОтгрузки = Ложь)
	
	// Данные по остаткам товаров заказа
	ВыборкаТовары = ПолучитьРезультатЗапросаПоОстаткамЗаказов(
		ДанныеОтбора,
		?(ЗаполнятьНаДатуОтгрузки, ДанныеОтбора.Дата, Неопределено),
		МассивЗаказов).Выбрать();
	
	МассивЗаказовКлиентов = Новый Массив();
	
	Пока ВыборкаТовары.Следующий() Цикл
		Если МассивЗаказовКлиентов.Найти(ВыборкаТовары.ЗаказПереработчику) = Неопределено Тогда
			МассивЗаказовКлиентов.Добавить(ВыборкаТовары.ЗаказПереработчику);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивЗаказовКлиентов", МассивЗаказовКлиентов);
	Запрос.УстановитьПараметр("ВалютаДокумента",       ДанныеОтбора.Валюта);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ТаблицаЗаказов.Дата, ДЕНЬ) КАК Дата,
	|	ТаблицаЗаказов.Ссылка КАК ЗаказПереработчику,
	|	ТаблицаЗаказов.Валюта КАК Валюта,
	|	ЛОЖЬ КАК ЦенаВключаетНДС,
	|	ВЫБОР
	|		КОГДА ТаблицаЗаказов.Валюта <> &ВалютаДокумента
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПересчитатьВВалютуДокумента
	|ИЗ
	|	Документ.ЗаказПереработчику КАК ТаблицаЗаказов
	|ГДЕ
	|	ТаблицаЗаказов.Ссылка В(&МассивЗаказовКлиентов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаЗаказов.Дата, ДЕНЬ) КАК Дата,
	|	ТаблицаЗаказов.Валюта КАК Валюта
	|ИЗ
	|	Документ.ЗаказПереработчику КАК ТаблицаЗаказов
	|ГДЕ
	|	ТаблицаЗаказов.Ссылка В(&МассивЗаказовКлиентов)
	|	И ТаблицаЗаказов.Валюта <> &ВалютаДокумента";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	РеквизитыЗаказов = РезультатЗапроса[0].Выбрать();
	РеквизитыЗаказов.Следующий();
	
	ТаблицаКурсовВалют = Новый ТаблицаЗначений;
	ТаблицаКурсовВалют.Колонки.Добавить("Валюта",    Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	ТаблицаКурсовВалют.Колонки.Добавить("Дата",      Новый ОписаниеТипов("Дата"));
	ТаблицаКурсовВалют.Колонки.Добавить("Курс",      Новый ОписаниеТипов("Число"));
	ТаблицаКурсовВалют.Колонки.Добавить("Кратность", Новый ОписаниеТипов("Число"));
	
	Выборка = РезультатЗапроса[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаКурсовВалют.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		КурсыВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Выборка.Валюта, Выборка.Дата);
		НоваяСтрока.Курс      = КурсыВалюты.Курс;
		НоваяСтрока.Кратность = КурсыВалюты.Кратность;
		
	КонецЦикла;
	
	Если ТаблицаКурсовВалют.Количество() > 0 Тогда
		СтруктураКурсовНовойВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДанныеОтбора.Валюта, ТекущаяДатаСеанса());
	КонецЕсли;
	
	ВыборкаТовары.Сбросить();
	Пока ВыборкаТовары.Следующий() Цикл
		
		// Добавим новую строку
		СтрокаТаб = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаб, ВыборкаТовары);
		
		// Если остаток по заказу отличается от первоначального количества, то нужно скорректировать сумму.
		Если ВыборкаТовары.Количество <> ВыборкаТовары.КоличествоВЗаказе Тогда
			СтрокаТаб.Сумма = СтрокаТаб.Цена * СтрокаТаб.КоличествоУпаковок;;
		КонецЕсли;
		
		// Пересчитаем суммы в валюту документа
		Если Не РеквизитыЗаказов.ПересчитатьВВалютуДокумента Тогда
			Продолжить;
		КонецЕсли;
		
		РеквизитыЗаказов.Сбросить();
		ЗаказНайден = РеквизитыЗаказов.НайтиСледующий(СтрокаТаб.ЗаказПереработчику, "ЗаказПереработчику");
		
		Если ЗаказНайден Тогда
			
			ПараметрыОтбора = Новый Структура("Валюта, Дата", РеквизитыЗаказов.Валюта, РеквизитыЗаказов.Дата);
			КурсВалюты = ТаблицаКурсовВалют.НайтиСтроки(ПараметрыОтбора);
			
			Если КурсВалюты.Количество() = 1 Тогда
				
				СтрокаТаб.Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаТаб.Цена,
					РеквизитыЗаказов.Валюта, ДанныеОтбора.Валюта,
					КурсВалюты[0].Курс,      СтруктураКурсовНовойВалюты.Курс,
					КурсВалюты[0].Кратность, СтруктураКурсовНовойВалюты.Кратность);
				
				СтрокаТаб.Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаТаб.Сумма,
					РеквизитыЗаказов.Валюта, ДанныеОтбора.Валюта,
					КурсВалюты[0].Курс,      СтруктураКурсовНовойВалюты.Курс,
					КурсВалюты[0].Кратность, СтруктураКурсовНовойВалюты.Кратность);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатЗапросаПоОстаткамЗаказов(ДанныеОтбора, 
	                                              Дата            = Неопределено,
	                                              МассивЗаказов   = Неопределено)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивЗаказов",   МассивЗаказов);
	Запрос.УстановитьПараметр("Регистратор",     ДанныеОтбора.Ссылка);
	
	Если Дата <> Неопределено Тогда
		Запрос.УстановитьПараметр("Период",        КонецДня(Дата));
		Запрос.УстановитьПараметр("ГраницаПериод", Новый Граница(КонецДня(Дата), ВидГраницы.Включая));
	Иначе
		Запрос.УстановитьПараметр("Период",        '00010101');
		Запрос.УстановитьПараметр("ГраницаПериод", Неопределено);
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаЗаказы.ЗаказПереработчику      КАК ЗаказПереработчику,
	|	ТаблицаЗаказы.Номенклатура            КАК Номенклатура,
	|	ТаблицаЗаказы.Характеристика          КАК Характеристика,
	|	ТаблицаЗаказы.КодСтроки               КАК КодСтроки,
	|	ТаблицаЗаказы.Склад                   КАК Склад,
	|	СУММА(ТаблицаЗаказы.Заказано)      КАК Количество
	|ПОМЕСТИТЬ ТаблицаОстатки
	|ИЗ
	// Выбираем остатки на конец дня к оформлению
	|	(ВЫБРАТЬ
	|		ЗаказыОстатки.ЗаказКлиента       КАК ЗаказПереработчику,
	|		ЗаказыОстатки.Номенклатура       КАК Номенклатура,
	|		ЗаказыОстатки.Характеристика     КАК Характеристика,
	|		ЗаказыОстатки.КодСтроки          КАК КодСтроки,
	|		ЗаказыОстатки.Склад              КАК Склад,
	|		ЗаказыОстатки.ЗаказаноОстаток КАК Заказано
	|	ИЗ
	|		РегистрНакопления.ЗаказыКлиентов.Остатки(
	|				&ГраницаПериод,
	|				ЗаказКлиента В (&МассивЗаказов)) КАК ЗаказыОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	// Исключаем из остатков по заказам движения текущей передачи
	|	ВЫБРАТЬ
	|		ЗаказыДвижения.ЗаказКлиента                                                           КАК ЗаказПереработчику,
	|		ЗаказыДвижения.Номенклатура                                                           КАК Номенклатура,
	|		ЗаказыДвижения.Характеристика                                                         КАК Характеристика,
	|		ЗаказыДвижения.КодСтроки                                                              КАК КодСтроки,
	|		ЗаказыДвижения.Склад                                                                  КАК Склад,
	|		ВЫБОР КОГДА ЗаказыДвижения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			ЗаказыДвижения.Заказано * (-1)
	|		ИНАЧЕ
	|			ЗаказыДвижения.Заказано
	|		КОНЕЦ                                                                                 КАК Количество
	|	ИЗ
	|		РегистрНакопления.ЗаказыКлиентов КАК ЗаказыДвижения
	|	ГДЕ
	|		ЗаказыДвижения.Регистратор = &Регистратор
	|		И ЗаказыДвижения.Активность
	|		И ЗаказыДвижения.ЗаказКлиента В (&МассивЗаказов)
	|		И ВЫБОР КОГДА &Период <> ДАТАВРЕМЯ(1, 1, 1) ТОГДА
	|			ЗаказыДвижения.Период <= &Период
	|		ИНАЧЕ
	|			ИСТИНА
	|		КОНЕЦ) КАК ТаблицаЗаказы
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗаказы.ЗаказПереработчику,
	|	ТаблицаЗаказы.Номенклатура,
	|	ТаблицаЗаказы.Характеристика,
	|	ТаблицаЗаказы.КодСтроки,
	|	ТаблицаЗаказы.Склад
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаЗаказы.Заказано) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатки.ЗаказПереработчику                                                                КАК ЗаказПереработчику,
	|	ТаблицаОстатки.Номенклатура                                                                      КАК Номенклатура,
	|	ТаблицаОстатки.Характеристика                                                                    КАК Характеристика,
	|	ВЫБОР КОГДА ЗаказТовары.ВариантОбеспечения В(
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно),
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)) ТОГДА
	|		ВЫБОР КОГДА ТаблицаОстатки.ЗаказПереработчику.ПереработкаПоЗаказу ТОГДА
	|				ЗаказТовары.Назначение
	|			ИНАЧЕ
	|				ТаблицаОстатки.ЗаказПереработчику.Назначение
	|		КОНЕЦ
	|	КОНЕЦ                                                                                            КАК Назначение,
	|	ЗаказТовары.Серия                                                                                КАК Серия,
	|	ТаблицаОстатки.КодСтроки                                                                         КАК КодСтроки,
	|	ТаблицаОстатки.Количество                                                                        КАК Количество,
	|	ТаблицаОстатки.Количество / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1)                        КАК КоличествоУпаковок,
	|	ТаблицаОстатки.Склад                                                                             КАК Склад,
	|	ЗаказТовары.НомерСтроки                                                                          КАК НомерСтроки,
	|	ЗаказТовары.Ссылка.Сделка                                                                        КАК Сделка,
	|	ЗаказТовары.ДатаОтгрузки                                                                         КАК ДатаОтгрузки,
	|	ЗаказТовары.Упаковка                                                                             КАК Упаковка,
	|	ЗаказТовары.ВидЦены                                                                              КАК ВидЦены,
	|	ЗаказТовары.Количество                                                                           КАК КоличествоВЗаказе,
	|	ЗаказТовары.Цена                                                                                 КАК Цена,
	|	ЗаказТовары.Сумма                                                                                КАК Сумма,
	|	ЗаказТовары.Номенклатура.ТипНоменклатуры                                                         КАК ТипНоменклатуры,
	|	ЗаказТовары.КлючСвязи                                                                            КАК КлючСвязи,
	|	ЗаказТовары.СрокПоставки                                                                         КАК СрокПоставки,
	|	ВЫБОР КОГДА ЗаказТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) ТОГДА
	|		1
	|	ИНАЧЕ
	|		&ТекстЗапросаКоэффициентУпаковки
	|	КОНЕЦ                                                                                            КАК Коэффициент
	|ИЗ
	|	ТаблицаОстатки КАК ТаблицаОстатки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Материалы КАК ЗаказТовары
	|		ПО    ТаблицаОстатки.Номенклатура       = ЗаказТовары.Номенклатура
	|			И ТаблицаОстатки.Характеристика     = ЗаказТовары.Характеристика
	|			И ТаблицаОстатки.КодСтроки          = ЗаказТовары.КодСтроки
	|			И ТаблицаОстатки.ЗаказПереработчику = ЗаказТовары.Ссылка	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаказПереработчику.Услуги КАК ЗаказНаПереработку
	|	ПО
	|		ТаблицаОстатки.ЗаказПереработчику = ЗаказНаПереработку.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОстатки.ЗаказПереработчику,
	|	ЗаказТовары.НомерСтроки";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ЗаказТовары.Упаковка",
		"ЗаказТовары.Номенклатура"));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Запрос.Выполнить();
	
КонецФункции

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	
	Закрыть();
	
	ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
