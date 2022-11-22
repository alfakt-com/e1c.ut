﻿///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Повторно используемые значения для механизмов
//	- партионного учета версии 2.2
//	- расчета себестоимости
//	- закрытия месяца.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УчетнаяПолитикаОрганизаций

// Возвращает систему налогообложения, используемую в организации в указанном месяце.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация
//	Дата - Дата - месяц.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.СистемыНалогообложения - используемая система налогообложения.
//
Функция СистемаНалогообложенияОрганизации(Организация, Дата) Экспорт
	
	СистемаНалогообложения = ПолучитьПараметрУчетнойПолитикиОрганизации(
		Организация,
		Дата,
		"СистемаНалогообложения",
		Перечисления.СистемыНалогообложения.Общая);
	
	Возврат СистемаНалогообложения;
	
КонецФункции

// Возвращает метод оценки стоимости товаров, используемый в организации в указанном месяце.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация
//	Дата - Дата - месяц.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.МетодыОценкиСтоимостиТоваров - используемый метод оценки стоимости товаров.
//
Функция МетодОценкиСтоимостиТоваровОрганизации(Организация, Дата) Экспорт
	
	МетодОценки = ПолучитьПараметрУчетнойПолитикиОрганизации(
		Организация,
		Дата,
		"МетодОценкиСтоимостиТоваров",
		Перечисления.МетодыОценкиСтоимостиТоваров.СредняяЗаМесяц);
	
	Возврат МетодОценки;
	
КонецФункции

// Возвращает вариант учета НДС при изменении вида деятельности, используемый в организации в указанном месяце.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация
//	Дата - Дата - месяц.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую - используемый вариант учета НДС.
//
Функция ВариантУчетаНДСОрганизацииПриИзмененииВидаДеятельности(Организация, Дата) Экспорт
	
	ВариантУчетаНДС = ПолучитьПараметрУчетнойПолитикиОрганизации(
		Организация,
		Дата,
		"ВариантУчетаНДСПриИзмененииВидаДеятельности",
		Перечисления.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую.ВключатьВСтоимость);
	
	Возврат ВариантУчетаНДС;
	
КонецФункции

// Возвращает параметры списания НДС при изменении вида деятельности, используемые в организации в указанном месяце.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация
//	Дата - Дата - месяц.
//
// Возвращаемое значение:
//	Фиксированная структура с ключами
//		- СтатьяСписанияПродажаНеОблагаетсяНДС
//		- АналитикаСписанияПродажаНеОблагаетсяНДС
//		- СтатьяСписанияПродажаОблагаетсяЕНВД
//		- АналитикаСписанияПродажаОблагаетсяЕНВД.
//
Функция ПараметрыСписанияНДСОрганизации(Организация, Дата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СтатьяСписанияПродажаНеОблагаетсяНДС", ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка());
	Результат.Вставить("АналитикаСписанияПродажаНеОблагаетсяНДС");
	Результат.Вставить("СтатьяСписанияПродажаОблагаетсяЕНВД",  ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка());
	Результат.Вставить("АналитикаСписанияПродажаОблагаетсяЕНВД");
	
	ВариантУчетаНДС = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ВариантУчетаНДСОрганизацииПриИзмененииВидаДеятельности(
		Организация,
		НачалоМесяца(Дата));
	
	Если ВариантУчетаНДС <> Перечисления.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую.ВключатьВСтоимость Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СправочникУчетныеПолитики.СтатьяРасходовНеНДС 	 КАК СтатьяСписанияПродажаНеОблагаетсяНДС,
		|	СправочникУчетныеПолитики.АналитикаРасходовНеНДС КАК АналитикаСписанияПродажаНеОблагаетсяНДС,
		|	СправочникУчетныеПолитики.СтатьяРасходовЕНВД 	 КАК СтатьяСписанияПродажаОблагаетсяЕНВД,
		|	СправочникУчетныеПолитики.АналитикаРасходовЕНВД  КАК АналитикаСписанияПродажаОблагаетсяЕНВД
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(&Период, Организация = &Организация) КАК РегистрУчетныеПолитики
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК СправочникУчетныеПолитики
		|		ПО РегистрУчетныеПолитики.УчетнаяПолитика = СправочникУчетныеПолитики.Ссылка";
		
		Запрос.УстановитьПараметр("Период", 	 НачалоМесяца(Дата));
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(Результат, Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

#Область ТипыЗаписейПартий

// Возвращает правила заполнения полей в первичных движениях документов по регистру "Себестоимость товаров".
//
// Параметры:
//	ИмяДокументаДляОтбора - Строка - имя документа для отбора строк таблицы; если не указано, то выводится таблица по всем документам
//
// Возвращаемое значение:
//	ТаблицаЗначений - правила заполнения записей, полученные из макета регистра накопления СебестоимостьТоваров
//
Функция ПравилаЗаполненияПоляТипЗаписи(ИмяДокументаДляОтбора = "") Экспорт
	
	ТаблицаПравил = Новый ТаблицаЗначений;
	ТаблицаПравил.Колонки.Добавить("ИмяДокумента", 				 Новый ОписаниеТипов("Строка"));
	ТаблицаПравил.Колонки.Добавить("ПустоеЗначениеРегистратора", Новый ОписаниеТипов(Документы.ТипВсеСсылки()));
	ТаблицаПравил.Колонки.Добавить("ХозяйственнаяОперация",   	 Новый ОписаниеТипов("ПеречислениеСсылка.ХозяйственныеОперации"));
	ТаблицаПравил.Колонки.Добавить("ПоложительноеКоличество", 	 Новый ОписаниеТипов("Булево, NULL")); // допустимо Неопределено
	ТаблицаПравил.Колонки.Добавить("ТипЗаписиПриход", 		  	 Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЗаписейПартий, NULL")); // допустимо Неопределено
	ТаблицаПравил.Колонки.Добавить("ТипЗаписиРасход", 		  	 Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЗаписейПартий, NULL")); // допустимо Неопределено
	ТаблицаПравил.Колонки.Добавить("ДокументИсточникВПриходе", 	 Новый ОписаниеТипов("Булево"));
	ТаблицаПравил.Колонки.Добавить("ДокументИсточникВРасходе", 	 Новый ОписаниеТипов("Булево"));
	ТаблицаПравил.Колонки.Добавить("КорПартияВРасходе", 		 Новый ОписаниеТипов("Булево"));
	
	Макет = РегистрыНакопления.СебестоимостьТоваров.ПолучитьМакет("ПравилаЗаполненияРеквизитаТипЗаписи");
	
	// Первая строка макета содержит заголовок, остальные строки - правила заполнения.
	Для НомерСтроки = 2 По Макет.ВысотаТаблицы Цикл
		
		// 1. Регистратор
		ИмяДокумента = СокрЛП(Макет.Область(НомерСтроки, 1, НомерСтроки, 1).Текст);
		Если НЕ ЗначениеЗаполнено(ИмяДокумента) Тогда
			Прервать; // возможно есть пустые строки в конце документа или под таблицей правил есть комментарии
		ИначеЕсли ЗначениеЗаполнено(ИмяДокументаДляОтбора) И НРег(ИмяДокументаДляОтбора) <> НРег(ИмяДокумента) Тогда
			Продолжить; // не тот тип документа
		ИначеЕсли Метаданные.Документы.Найти(ИмяДокумента) = Неопределено Тогда
			Продолжить; // в этой конфигурации (УТ11, КА2) нет такого документа
		КонецЕсли;
		
		НовоеПравило = ТаблицаПравил.Добавить();
		НовоеПравило.ИмяДокумента 				= ИмяДокумента;
		НовоеПравило.ПустоеЗначениеРегистратора = Документы[ИмяДокумента].ПустаяСсылка();
		
		// 2. Хозяйственная операция
		ИмяХозОперации = СокрЛП(Макет.Область(НомерСтроки, 2, НомерСтроки, 2).Текст);
		Если НЕ ПустаяСтрока(ИмяХозОперации) Тогда
			НовоеПравило.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации[ИмяХозОперации];
		КонецЕсли;
		
		// 3. Отрицательное количество
		ЗнакКоличества = СокрЛП(Макет.Область(НомерСтроки, 3, НомерСтроки, 3).Текст);
		НовоеПравило.ПоложительноеКоличество = ?(ПустаяСтрока(ЗнакКоличества), Неопределено, (ЗнакКоличества = "+"));
		
		// 4. Тип записи приходных движений
		ТипЗаписиПриход = СокрЛП(Макет.Область(НомерСтроки, 4, НомерСтроки, 4).Текст);
		Если ПустаяСтрока(ТипЗаписиПриход) Тогда 
			НовоеПравило.ТипЗаписиПриход = Неопределено;
		ИначеЕсли ТипЗаписиПриход = "<>" Тогда
			НовоеПравило.ТипЗаписиПриход = Перечисления.ТипыЗаписейПартий.ПустаяСсылка();
		Иначе
			НовоеПравило.ТипЗаписиПриход = Перечисления.ТипыЗаписейПартий[ТипЗаписиПриход];
		КонецЕсли;
		
		// 5. Тип записи расходных движений
		ТипЗаписиРасход = СокрЛП(Макет.Область(НомерСтроки, 5, НомерСтроки, 5).Текст);
		Если ПустаяСтрока(ТипЗаписиРасход) Тогда 
			НовоеПравило.ТипЗаписиРасход = Неопределено;
		ИначеЕсли ТипЗаписиРасход = "<>" Тогда
			НовоеПравило.ТипЗаписиРасход = Перечисления.ТипыЗаписейПартий.ПустаяСсылка();
		Иначе
			НовоеПравило.ТипЗаписиРасход = Перечисления.ТипыЗаписейПартий[ТипЗаписиРасход];
		КонецЕсли;
		
		// 6. Заполнение документа-источника в приходе
		ДокументИсточникВПриходе = СокрЛП(Макет.Область(НомерСтроки, 6, НомерСтроки, 6).Текст);
		НовоеПравило.ДокументИсточникВПриходе = НЕ ПустаяСтрока(ДокументИсточникВПриходе);
		
		// 7. Заполнение документа-источника в расходе
		ДокументИсточникВРасходе = СокрЛП(Макет.Область(НомерСтроки, 7, НомерСтроки, 7).Текст);
		НовоеПравило.ДокументИсточникВРасходе = НЕ ПустаяСтрока(ДокументИсточникВРасходе);
		
		// 8. Указание кор. партии в расходе
		КорПартияВРасходе = СокрЛП(Макет.Область(НомерСтроки, 8, НомерСтроки, 8).Текст);
		НовоеПравило.КорПартияВРасходе = НЕ ПустаяСтрока(КорПартияВРасходе);
		
		// 9. Комментарий (не используется)
		
	КонецЦикла;
	
	Возврат ТаблицаПравил;
	
КонецФункции

// Определяет, является ли указанный тип записи записью партии.
//
Функция ЭтоТипЗаписиПервичнойПартии(ТипЗаписи) Экспорт
	
	Возврат (УниверсальныеМеханизмыПартийИСебестоимости.ТипыЗаписейПервичныхПартий().Найти(ТипЗаписи) <> Неопределено);
	
КонецФункции

// Определяет, возможен ли пересчет записи указанного типа.
//
Функция ЭтоНепересчитываемыйТипЗаписи(ТипЗаписи) Экспорт
	
	Возврат (УниверсальныеМеханизмыПартийИСебестоимости.НепересчитываемыеТипыЗаписей().Найти(ТипЗаписи) <> Неопределено);
	
КонецФункции

// Определяет, является ли переданный тип записи расчетным (не используется в первичных движениях).
// Если это расчетный тип записи (например, Выпуск, Распределение), значит она сгенерирована
// на этапе заполнения партий в себестоимости - для таких записей устанавливается признак "РасчетПартий".
// В противном случае считаем что это уже существующая первичная запись, для которой просто заполнились поля партионного
// учета. Используется только для регистра СебестоимостьТоваров на этапе заполнения партий в движениях этого регистра.
//
Функция ЭтоТолькоРасчетныйТипЗаписи(ТипЗаписи) Экспорт
	
	Правила = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПравилаЗаполненияПоляТипЗаписи();
	СтрокаПравил = Правила.Найти(ТипЗаписи, "ТипЗаписиПриход, ТипЗаписиРасход");
	
	Возврат (СтрокаПравил = Неопределено); // тип записи не используется в первичных движениях
	
КонецФункции

#КонецОбласти

#Область РежимыПартионногоУчета

// Определяет, используется ли партионный учет версии 2.2 на указанную дату.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить режим партионного учета.
//
// Возвращаемое значение:
//	Булево - признак использования партионного учета версии 2.2 на указанную дату
//	Если дата не указана, то определяется сам факт использования партионного учета версии 2.2.
//
Функция ПартионныйУчетВерсии22(Дата = Неопределено) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
		Возврат Ложь; // партионный учет 2.2 выключен
	ИначеЕсли НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
		ВызватьИсключение НСтр("ru='Некорректно установлены функциональные опции партионного учета'"); // такого быть не должно - обе опции включаются синхронно
	КонецЕсли;
	
	ВключенПартионныйУчетВерсии22 =
		(Дата = Неопределено ИЛИ Дата >= УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22());
	
	Возврат ВключенПартионныйУчетВерсии22;
	
КонецФункции

// Определяет, используется ли партионный учет версии 2.1 на указанную дату.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить режим партионного учета.
//
// Возвращаемое значение:
//	Булево - признак использования партионного учета версии 2.1 на указанную дату
//	Если дата не указана, то определяется сам факт использования партионного учета версии 2.1.
//
Функция ПартионныйУчетВерсии21(Дата = Неопределено) Экспорт
	
	БылВключенПартионныйУчет = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ИспользовалсяПартионныйУчетДоПереходаНаВерсию22(Дата);
	
	Возврат ?(БылВключенПартионныйУчет = Неопределено, Ложь, БылВключенПартионныйУчет);
	
КонецФункции

// Определяет, отключен ли партионный учет на указанную дату.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить режим партионного учета.
//
// Возвращаемое значение:
//	Булево - признак отключенного партионного учета на указанную дату.
//
Функция ПартионныйУчетНеИспользуется(Дата = Неопределено) Экспорт
	
	БылВключенПартионныйУчет = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ИспользовалсяПартионныйУчетДоПереходаНаВерсию22(Дата);
	
	Возврат ?(БылВключенПартионныйУчет = Неопределено, Ложь, НЕ БылВключенПартионныйУчет);
	
КонецФункции

// Определяет, включен ли партионный учет на указанную дату.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить режим партионного учета.
//
// Возвращаемое значение:
//	Булево - признак использования партионного учета на указанную дату.
//
Функция ПартионныйУчетВключен(Дата = Неопределено) Экспорт
	
	БылВключенПартионныйУчет =
		УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(Дата)
		ИЛИ УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии21(Дата);
	
	Возврат БылВключенПартионныйУчет;
	
КонецФункции

// Определяет "старый" режим партионного учета, до перехода на партионный учет версии 2.2.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить режим партионного учета.
//
// Возвращаемое значение:
//	Булево, Неопределено - признак использования партионного учета на указанную дату
// 		Если параметр Дата не передан, или Дата находится в периоде действия партионного учета версии 2.2,
//		то возвращается значение Неопределено - в такой проверке нет смысла.
//
Функция ИспользовалсяПартионныйУчетДоПереходаНаВерсию22(Дата) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
		Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет"); // перехода на версию 2.2 не было - проверяем стандартно
	ИначеЕсли НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
		ВызватьИсключение НСтр("ru='Некорректно установлены функциональные опции партионного учета'"); // такого быть не должно - обе опции включаются синхронно
	ИначеЕсли Дата = Неопределено ИЛИ Дата >= УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22() Тогда
		Возврат Неопределено; // нет смысла проверять режим "старого" партионного учета, т.к. используется партионный учет версии 2.2
	КонецЕсли;
	
	// До даты перехода на версию 2.2 партионный учет версии 2.1 мог быть как включен, так и выключен.
	// Информация об этом не сохранилась, т.к. константа ИспользоватьПартионныйУчет при переходе установилась в значение Истина.
	// Наиболее достоверный способ узнать "старый" режим партионного учета - определить его по данным ИБ.
	// Например, если партионный учет не использовался, то не должно быть движений по регистру партий товаров.
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК БылВключенПартионныйУчет
	|ИЗ
	|	РегистрНакопления.ПартииТоваровОрганизаций КАК Т";
	
	БылВключенПартионныйУчет = НЕ Запрос.Выполнить().Пустой();
	
	Возврат БылВключенПартионныйУчет;
	
КонецФункции

// Возвращает дату перехода на партионный учет версии 2.2.
// Дата может быть пустой - значит партионный учет версии 2.2 включен для всех периодов.
//
// Возвращаемое значение:
//	Дата - начало месяца перехода на партионный учет версии 2.2.
//
Функция ДатаПереходаНаПартионныйУчетВерсии22() Экспорт
	
	Возврат НачалоМесяца(Константы.ДатаПереходаНаПартионныйУчетВерсии22.Получить());
	
КонецФункции

#КонецОбласти

#Область УправленческийУчетОрганизаций

// Определяет, включен ли управленческий учет организаций на указанную дату.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить ведение управленческого учета организаций.
//
// Возвращаемое значение:
//	Булево - признак использования управленческого учета организаций на указанную дату
//	Если дата не указана, то определяется сам факт включения партионного учета организаций.
//
Функция УправленческийУчетОрганизаций(Дата = Неопределено) Экспорт
	
	ВключенУправленческийУчетОрганизаций = ПолучитьФункциональнуюОпцию("ВестиУправленческийУчетОрганизаций")
		И УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(Дата)
		И (Дата = Неопределено
			ИЛИ Дата >= ДатаНачалаВеденияУправленческогоУчетаОрганизаций());
	Возврат ВключенУправленческийУчетОрганизаций;
	
КонецФункции

#КонецОбласти

#Область ТехнологическиеПараметрыРасчета

// Возвращает значения технологических параметров операции закрытия месяца.
//
// Параметры:
//	Операция - ПеречислениеСсылка.ОперацииЗакрытияМесяца - операция, для которой получаются технологические параметры;
//				если не указана, то возвращаются значения параметров для операции "Расчет партий и себестоимости".
//
// Возвращаемое значение:
//	Структура - см. Константы.НастройкиЗакрытияМесяца.СоздатьМенеджерЗначения().УстановленныеЗначенияПараметровОперации().
//
Функция ЗначенияТехнологическихПараметров(Операция = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Операция = Неопределено Тогда
		Операция = Перечисления.ОперацииЗакрытияМесяца.РасчетПартийИСебестоимости;
	КонецЕсли;
	
	ЗначенияПараметров = Константы.НастройкиЗакрытияМесяца.СоздатьМенеджерЗначения().УстановленныеЗначенияПараметровОперации(Операция);
	
	Возврат ЗначенияПараметров;
	
КонецФункции

#КонецОбласти

#Область АнализСостоянияСистемы

// Возвращает важность указанной проверки состояния системы.
//
// Параметры:
//	Проверка - СправочникСсылка.ПроверкиСостоянияСистемы - проверка.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.ВариантыВажностиПроблемыСостоянияСистемы - важность проверки.
//
Функция ВажностьПроверкиСостоянияСистемы(Проверка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Важность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Проверка, "Важность");
	
	Возврат Важность;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УчетнаяПолитикаОрганизаций

// Возвращает значение указанного параметра учетной политики организации.
//
Функция ПолучитьПараметрУчетнойПолитикиОрганизации(Организация, Дата, ИмяПараметра, ЗначениеПоУмолчанию = Неопределено)
	Перем ЗначениеПараметра;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СправочникУчетныеПолитики.%1 КАК ЗначениеПараметра
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(&Период, Организация = &Организация) КАК РегистрУчетныеПолитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК СправочникУчетныеПолитики
	|		ПО РегистрУчетныеПолитики.УчетнаяПолитика = СправочникУчетныеПолитики.Ссылка";
	
	Запрос.УстановитьПараметр("Период", 	 НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Запрос.Текст, ИмяПараметра);
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		ЗначениеПараметра = Выборка.ЗначениеПараметра;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		ЗначениеПараметра = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

#КонецОбласти

#Область УправленческийУчетОрганизаций

// Возвращает дату начала ведения управленческого учета.
//
Функция ДатаНачалаВеденияУправленческогоУчетаОрганизаций()
	
	Возврат НачалоМесяца(Константы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций.Получить());
	
КонецФункции

#КонецОбласти

#КонецОбласти
