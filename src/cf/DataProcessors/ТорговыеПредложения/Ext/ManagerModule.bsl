#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Формирование заказов.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения процедуры:
//   * Таблица - ТаблицаЗначений - таблица с товарами для заказа.
//   * ДополнительныеПараметры - Структура - дополнительные параметры:
//       ** Организация - СправочникСсылка.Организация - организация отправитель.
//       ** КонтекстИсточника - Структура - данные документа основания.
//       ** ЗарегистрироватьОрганизацию - Булево - признак регистрации организации в сервисе 1С:Бизнес-сеть.
//       ** Валюта - СправочникСсылка.Валюта - валюта для создания заказов.
//  АдресРезультата - Строка - адрес временного хранилища с результатом.
//
Процедура СформироватьЗаказы(Знач ПараметрыПроцедуры, Знач АдресРезультата) Экспорт
	
	МассивЗаказов = Новый Массив;
	
	Организация       = ПараметрыПроцедуры.ДополнительныеПараметры.Организация;
	КонтекстИсточника = ПараметрыПроцедуры.ДополнительныеПараметры.КонтекстИсточника;
	ТаблицаДоставки   = ПараметрыПроцедуры.ДополнительныеПараметры.Доставка;
	
	Отказ = Ложь;
	Если Не БизнесСеть.ОрганизацияЗарегистрирована(Организация) Тогда
		// Регистрация организации в сервисе.
		Если ПараметрыПроцедуры.ДополнительныеПараметры.ЗарегистрироватьОрганизацию Тогда
			МассивОрганизаций = Новый Массив;
			МассивОрганизаций.Добавить(Организация);
			БизнесСеть.ЗарегистрироватьОрганизации(МассивОрганизаций, Отказ);
		Иначе
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Поставщики = ПараметрыПроцедуры.Таблица.Скопировать(
		Новый Структура("Пометка", Истина),
		"ПоставщикИдентификатор, ПоставщикНаименование, ПоставщикИНН, ПоставщикКПП");
	Поставщики.Свернуть("ПоставщикИдентификатор, ПоставщикНаименование, ПоставщикИНН, ПоставщикКПП");
	
	Товары = ПараметрыПроцедуры.Таблица.Скопировать(Новый Структура("Пометка", Истина));
	Товары.Индексы.Добавить("ПоставщикИдентификатор, НоменклатураПоставщика");
	
	Для каждого Поставщик Из Поставщики Цикл
		
		ИдентификаторыПредложенийВЗаказе = Новый Массив;
		
		// Создание/поиск контрагента.
		РеквизитыКонтрагента = Новый Структура;
		РеквизитыКонтрагента.Вставить("ИНН", Поставщик.ПоставщикИНН);
		РеквизитыКонтрагента.Вставить("КПП", Поставщик.ПоставщикКПП);
	
		Контрагент = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.НайтиСсылкуНаОбъект("Контрагенты",, РеквизитыКонтрагента);
		Если Контрагент = Неопределено Тогда
			РеквизитыКонтрагента.Вставить("Наименование", Поставщик.ПоставщикНаименование);
			БизнесСетьПереопределяемый.СоздатьКонтрагентаПоРеквизитам(РеквизитыКонтрагента, Контрагент, Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Контрагент) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Отбор = Новый Структура("ПоставщикИдентификатор", Поставщик.ПоставщикИдентификатор);
		СтрокиЗаказа = Товары.НайтиСтроки(Отбор);
		
		Для каждого СтрокаЗаказа Из СтрокиЗаказа Цикл
			
			ИдентификаторПредложения = Лев(
				СтрокаЗаказа.ПредложениеИдентификатор, СтрНайти(СтрокаЗаказа.ПредложениеИдентификатор, "#") - 1);
				
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИдентификаторыПредложенийВЗаказе,
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторПредложения),Истина);
				
			// Создание/поиск номенклатуры поставщиков.
			Если Не ЗначениеЗаполнено(СтрокаЗаказа.НоменклатураПоставщика) Тогда
			
				ИдентификаторНоменклатурыПоставщика = СтрЗаменить(
					СтрокаЗаказа.ПредложениеИдентификатор, ИдентификаторПредложения + "#", "");
					
				ДополнительныеРеквизиты = Новый Структура;
				ДополнительныеРеквизиты.Вставить("Идентификатор", ИдентификаторНоменклатурыПоставщика);
				
				Наименование = Лев(СтрШаблон("%1 %2",
					СтрокаЗаказа.Наименование, ?(ЗначениеЗаполнено(СтрокаЗаказа.ХарактеристикаНоменклатуры),
						"("+ СтрокаЗаказа.ХарактеристикаНоменклатуры +")", "")), 100);
				
				НоменклатураПоставщика = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.НайтиСсылкуНаОбъект(
					"НоменклатураПоставщиков",, ДополнительныеРеквизиты);
					
				ЗначенияРеквизитовНоменклатурыПоставщика = Неопределено;
				Если НоменклатураПоставщика <> Неопределено Тогда
					ЗначенияРеквизитовНоменклатурыПоставщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоменклатураПоставщика,
						"Наименование, Характеристика");
				КонецЕсли;
				
				Если ЗначенияРеквизитовНоменклатурыПоставщика <> Неопределено
					И (ЗначенияРеквизитовНоменклатурыПоставщика.Наименование <> Наименование
					ИЛИ ЗначенияРеквизитовНоменклатурыПоставщика.Характеристика <> СтрокаЗаказа.ХарактеристикаНоменклатуры)
					ИЛИ НоменклатураПоставщика = Неопределено Тогда
					
					ДеревоДанных = Новый ДеревоЗначений;
					ДеревоДанных.Колонки.Добавить("Реквизит");
					ДеревоДанных.Колонки.Добавить("ЗначениеРеквизита");
					ДеревоДанных.Колонки.Добавить("СсылкаНаОбъект");
					ДеревоДанных.Колонки.Добавить("ТипОбъекта");
					ДеревоДанных.Колонки.Добавить("ИндексСтроки");
					
					ЗаполнитьЗначенияСвойств(ДеревоДанных.Строки.Добавить(),
						Новый Структура("Реквизит, СсылкаНаОбъект", "Номенклатура", СтрокаЗаказа.Номенклатура));
					ЗаполнитьЗначенияСвойств(ДеревоДанных.Строки.Добавить(),
						Новый Структура("Реквизит, ЗначениеРеквизита", "Наименование", Наименование));
					ЗаполнитьЗначенияСвойств(ДеревоДанных.Строки.Добавить(),
						Новый Структура("Реквизит, ЗначениеРеквизита", "Характеристика", СтрокаЗаказа.ХарактеристикаНоменклатуры));
					ЗаполнитьЗначенияСвойств(ДеревоДанных.Строки.Добавить(),
						Новый Структура("Реквизит, ЗначениеРеквизита", "Ид", ИдентификаторНоменклатурыПоставщика));
					ЗаполнитьЗначенияСвойств(ДеревоДанных.Строки.Добавить(),
						Новый Структура("Реквизит, ЗначениеРеквизита", "Упаковка", СтрокаЗаказа.Упаковка));
					СтрокаКонтрагенты = ДеревоДанных.Строки.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКонтрагенты,
						Новый Структура("ТипОбъекта, СсылкаНаОбъект", "Контрагенты"));
					ЗаполнитьЗначенияСвойств(СтрокаКонтрагенты.Строки.Добавить(),
						Новый Структура("Реквизит, СсылкаНаОбъект", "Контрагент", Контрагент));
							
					СтруктураДанных = Новый Структура;
					СтруктураДанных.Вставить("СсылкаНаОбъект", НоменклатураПоставщика);
					ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("НоменклатураПоставщиков");
					СтруктураДанных.Вставить("ОписаниеТипа", "СправочникСсылка." + ИмяПрикладногоСправочника);
					СтруктураДанных.Вставить("Строки",       ДеревоДанных.Строки);
					ОбменСКонтрагентамиПереопределяемый.СоздатьОбъектВБД(СтруктураДанных, СтруктураДанных, НоменклатураПоставщика);
					
				КонецЕсли;
				СтрокаЗаказа.НоменклатураПоставщика = НоменклатураПоставщика;
				
			КонецЕсли;
		КонецЦикла;
		
		// Создание документа заказ.
		ДанныеЗаказа = Новый Структура;
		ДанныеЗаказа.Вставить("Организация",  Организация);
		ДанныеЗаказа.Вставить("Контрагент",   Контрагент);
		ДанныеЗаказа.Вставить("Валюта",       ПараметрыПроцедуры.ДополнительныеПараметры.Валюта);
		ДанныеЗаказа.Вставить("СтрокиЗаказа", СтрокиЗаказа);
		ДанныеЗаказа.Вставить("КонтекстИсточника", КонтекстИсточника);
		
		// Доставка.
		ДанныеЗаказа.Вставить("СпособДоставки", Неопределено);
		ДанныеЗаказа.Вставить("АдресДоставки", "");
		ДанныеЗаказа.Вставить("АдресДоставкиЗначенияПолей", "");
		СтрокаДоставки = ТаблицаДоставки.Найти(СтрокаЗаказа.ПоставщикИдентификатор, "ПоставщикИдентификатор");
		Если СтрокаДоставки <> Неопределено Тогда
			ДанныеЗаказа.Вставить("СпособДоставки", СтрокаДоставки.СпособДоставки);
			ДанныеЗаказа.Вставить("АдресДоставки",  СтрокаДоставки.АдресДоставки);
			ДанныеЗаказа.Вставить("АдресДоставкиЗначенияПолей", СтрокаДоставки.АдресДоставкиЗначенияПолей);
		КонецЕсли;
		
		ДокументЗаказ = Неопределено;
		ТорговыеПредложенияПереопределяемый.СоздатьДокументЗаказПоставщикуНаОснованииТорговогоПредложения(ДанныеЗаказа, ДокументЗаказ);
		
		Если ДокументЗаказ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			ДокументЗаказ.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Создание заказа на основании торгового предложения'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), Текст);
			ЗаписьЖурналаРегистрации(Текст, УровеньЖурналаРегистрации.Ошибка, ДокументЗаказ.Метаданные(),,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Попытка
				ДокументЗаказ.Записать(РежимЗаписиДокумента.Запись);
			Исключение
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Создание заказа на основании торгового предложения'",
						ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), Текст);
				ЗаписьЖурналаРегистрации(Текст, УровеньЖурналаРегистрации.Ошибка, ДокументЗаказ.Метаданные(),,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				Продолжить;
			КонецПопытки;
		КонецПопытки;
		
		Заказ = Новый Структура;
		Заказ.Вставить("Ссылка", ДокументЗаказ.Ссылка);
		Заказ.Вставить("ИдентификаторыПредложений", ИдентификаторыПредложенийВЗаказе);
		МассивЗаказов.Добавить(Заказ);
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(МассивЗаказов, АдресРезультата);
	
КонецПроцедуры

// Удаление сформированных заказов.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры процедуры:
//   * Таблица - ТаблицаЗначений - таблица с документами удаления, колонка "Ссылка" - ссылка на документ.
//  АдресРезультата	- Строка - адрес временного хранилища с результатом.
//
Процедура УдалитьЗаказы(Знач ПараметрыПроцедуры, Знач АдресРезультата) Экспорт
	
	ЗаказыУдалены = Ложь; Отказ = Ложь;
	
	ТаблицаДокументы = ПараметрыПроцедуры.Таблица;
	Если ТаблицаДокументы.Количество() > 0 Тогда
		ТорговыеПредложенияПереопределяемый.УдалитьДокументыЗаказПоставщику(ТаблицаДокументы, Отказ);
		Если ТаблицаДокументы.Количество() = 0 И Не Отказ Тогда
			ЗаказыУдалены = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ЗаказыУдалены, АдресРезультата);
	
КонецПроцедуры

// Отправление заказов по торговым предложениям продавцу.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения процедуры.
//    * Таблица - ТаблицаЗначения - таблица заказов для отправки:
//      ** Ссылка - ДокументСсылка - ссылка на документ.
//    * ДополнительныеПараметры - Структура - дополнительные параметры
//                                см. ФормированиеЗаказов.ОписаниеСопроводительнойИнформацииЗаказа():
//        ** Организация - СправочникСсылка.Организации - организация отправитель.
//        ** СопроводительнаяИнформация - Строка - сопроводительная информация для отправки.
//        ** УведомлятьПоПочте - Булево - признак необходимости уведомления по электронной почте о загрузке документа.
//        ** КонтактноеЛицо - Строка - контактное лицо отправителя.
//        ** Телефон - Строка - телефон контактного лица отправителя.
//        ** ЭлектроннаяПочта - Строка - электронная почта контактного лица отправителя.
//        ** УникальныйИдентификатор - УникальныйИдентификатор - идентификатор для хранения электронного документа.
//  АдресРезультата - Строка - адрес временного хранилища с результатом.
//
Процедура ОтправитьЗаказы(Знач ПараметрыПроцедуры, Знач АдресРезультата) Экспорт
	
	// Подготовка электронного документа.
	УникальныйИдентификатор = ПараметрыПроцедуры.ДополнительныеПараметры.УникальныйИдентификатор;
	
	ТаблицаНеОтправленныхЗаказов = ПараметрыПроцедуры.Таблица.Скопировать(
		Новый Структура("Пометка", Истина),
		"Ссылка, ИдентификаторыПредложений");
	МассивСсылок = ТаблицаНеОтправленныхЗаказов.ВыгрузитьКолонку("Ссылка");

	СписокЗаказов = Новый ТаблицаЗначений;
	СписокЗаказов.Колонки.Добавить("Ссылка");
	СписокЗаказов.Колонки.Добавить("Поставщик");
	СписокЗаказов.Колонки.Добавить("ПоставщикИНН");
	СписокЗаказов.Колонки.Добавить("ПоставщикКПП");
	СписокЗаказов.Колонки.Добавить("НаименованиеФайла");
	СписокЗаказов.Колонки.Добавить("ВидЭД");
	СписокЗаказов.Колонки.Добавить("СуммаДокумента");
	СписокЗаказов.Колонки.Добавить("АдресХранилища");
	СписокЗаказов.Колонки.Добавить("ТипПредставления");
	СписокЗаказов.Колонки.Добавить("АдресХранилищаПредставления");
	СписокЗаказов.Колонки.Добавить("ИдентификаторыПредложений");
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("МассивСсылокНаОбъект", МассивСсылок);
	ПараметрыЗадания.Вставить("ОтправкаЧерезБС", Ложь);

	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Обработки.ОбменСКонтрагентами.ПодготовитьДанныеДляЗаполненияДокументов(ПараметрыЗадания, АдресХранилища);

	Если АдресХранилища = "" Тогда
		Возврат;
	КонецЕсли;

	ЭлектронныеДокументы = ПолучитьИзВременногоХранилища(АдресХранилища);
	ТипыДокументов = БизнесСеть.ВидыДокументовСервиса();
	
	Если ЭлектронныеДокументы.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВладельцыЭД", ЭлектронныеДокументы.ВыгрузитьКолонку("ВладелецЭД"));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВладелецЭД.Ссылка         КАК СсылкаНаВладельцаЭД,
	|	ВладелецЭД.Номер          КАК Номер,
	|	ВладелецЭД.Дата           КАК Дата,
	|	ВладелецЭД.Контрагент     КАК Поставщик,
	|	ВладелецЭД.Контрагент.ИНН КАК ПоставщикИНН,
	|	ВладелецЭД.Контрагент.КПП КАК ПоставщикКПП,
	|	ВладелецЭД.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	&ТаблицаВладелецЭД КАК ВладелецЭД
	|ГДЕ
	|	ВладелецЭД.Ссылка В (&ВладельцыЭД)";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаВладелецЭД", ЭлектронныеДокументы[0].ВладелецЭД.Метаданные().ПолноеИмя());
	ЗначенияРеквизитовЗаказов = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ЭлектронныеДокументы Цикл
		ШаблонНаименования = НСтр("ru = '%1 %2 от %3'");
		
		Тип = ТипыДокументов.НайтиПоЗначению(СтрокаТаблицы.ВидЭД);
		Если Тип = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не определен тип документа.'");
		КонецЕсли;
		
		ЗначенияРеквизитовЗаказа = ЗначенияРеквизитовЗаказов.Найти(
			СтрокаТаблицы.ВладелецЭД, "СсылкаНаВладельцаЭД");
			
		СтрокаТаблицыЗаказов = СписокЗаказов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыЗаказов, ЗначенияРеквизитовЗаказа);
		СтрокаТаблицыЗаказов.Ссылка = СтрокаТаблицы.ВладелецЭД;
		СтрокаТаблицыЗаказов.ВидЭД  = СтрокаТаблицы.ВидЭД;
		
		НомерДок = "";
		ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьПечатныйНомерДокумента(СтрокаТаблицы.ВладелецЭД, НомерДок);
		СтрокаТаблицыЗаказов.НаименованиеФайла = СтрШаблон(
			ШаблонНаименования,
			Тип.Представление,
			НомерДок,
			Формат(ЗначенияРеквизитовЗаказа.Дата, "ДЛФ=Д"));
			
		СтрокаТаблицыЗаказов.АдресХранилища = ПоместитьВоВременноеХранилище(СтрокаТаблицы.ДвоичныеДанныеПакета, УникальныйИдентификатор);
		СтрокаТаблицыЗаказов.АдресХранилищаПредставления = ПоместитьВоВременноеХранилище(СтрокаТаблицы.ДвоичныеДанныеПредставления,
			УникальныйИдентификатор);
		СтрокаИдентификаторыПредложений = ТаблицаНеОтправленныхЗаказов.НайтиСтроки(Новый Структура("Ссылка",
			СтрокаТаблицы.ВладелецЭД));
		СтрокаТаблицыЗаказов.ИдентификаторыПредложений = СтрокаИдентификаторыПредложений[0].ИдентификаторыПредложений.ВыгрузитьЗначения();
		
	КонецЦикла;
	
	// Отправка электронного документа.
	Организация       = ПараметрыПроцедуры.ДополнительныеПараметры.Организация;
	УведомлятьПоПочте = ПараметрыПроцедуры.ДополнительныеПараметры.УведомлятьПоПочте;
	КонтактноеЛицо    = ПараметрыПроцедуры.ДополнительныеПараметры.КонтактноеЛицо;
	Телефон           = ПараметрыПроцедуры.ДополнительныеПараметры.Телефон;
	ЭлектроннаяПочта  = ПараметрыПроцедуры.ДополнительныеПараметры.ЭлектроннаяПочта;
	СопроводительнаяИнформация = ПараметрыПроцедуры.ДополнительныеПараметры.СопроводительнаяИнформация;
	
	Отказ = Ложь;
	МассивСтатусовОтправкиЗаказов = Новый Массив;
	Для каждого СтрокаТаблицыЗаказов Из СписокЗаказов Цикл
		
		Поставщик = Новый Структура;
		Поставщик.Вставить("Наименование", СтрокаТаблицыЗаказов.Поставщик);
		Поставщик.Вставить("ИНН",          СтрокаТаблицыЗаказов.ПоставщикИНН);
		Поставщик.Вставить("КПП",          СтрокаТаблицыЗаказов.ПоставщикКПП);
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("УникальныйИдентификатор",     Организация.УникальныйИдентификатор());
		ПараметрыКоманды.Вставить("Отправитель",                 Организация);
		ПараметрыКоманды.Вставить("Получатель",                  Поставщик);
		ПараметрыКоманды.Вставить("Заголовок",                   СтрокаТаблицыЗаказов.НаименованиеФайла);
		ПараметрыКоманды.Вставить("Ссылка",                      СтрокаТаблицыЗаказов.Ссылка);
		ПараметрыКоманды.Вставить("ВидЭД",                       СтрокаТаблицыЗаказов.ВидЭД);
		ПараметрыКоманды.Вставить("Сумма",                       СтрокаТаблицыЗаказов.СуммаДокумента);
		ПараметрыКоманды.Вставить("АдресХранилища",              СтрокаТаблицыЗаказов.АдресХранилища);
		ПараметрыКоманды.Вставить("ТипПредставления",            "");
		ПараметрыКоманды.Вставить("СопроводительнаяИнформация",  СопроводительнаяИнформация);
		ПараметрыКоманды.Вставить("АдресХранилищаПредставления", СтрокаТаблицыЗаказов.АдресХранилищаПредставления);
		ПараметрыКоманды.Вставить("КонтактноеЛицо",              КонтактноеЛицо);
		ПараметрыКоманды.Вставить("Телефон",                     Телефон);
		ПараметрыКоманды.Вставить("ЭлектроннаяПочта",            ЭлектроннаяПочта);
		ПараметрыКоманды.Вставить("УведомлятьПоПочте",           УведомлятьПоПочте);
		ПараметрыКоманды.Вставить("ИдентификаторыПредложений",   СтрокаТаблицыЗаказов.ИдентификаторыПредложений);
		
		Результат = БизнесСетьВызовСервера.ОтправитьДокумент(ПараметрыКоманды, Отказ);
		
		СтатусОтправкиЗаказа = Новый Структура;
		СтатусОтправкиЗаказа.Вставить("Ссылка", СтрокаТаблицыЗаказов.Ссылка);
		СтатусОтправкиЗаказа.Вставить("Статус",
			?(Отказ, НСтр("ru = 'Ошибка отправки'"), НСтр("ru = 'Отправлен'")));
		СтатусОтправкиЗаказа.Вставить("Пометка", Отказ);
		МассивСтатусовОтправкиЗаказов.Добавить(СтатусОтправкиЗаказа);
		
	КонецЦикла;
	
	Если СписокЗаказов.Количество() <> МассивСсылок.Количество() Тогда
		Для каждого ЗначениеМассива Из МассивСсылок Цикл
			Если СписокЗаказов.Найти(ЗначениеМассива) = Неопределено Тогда
				СтатусОтправкиЗаказа = Новый Структура;
				СтатусОтправкиЗаказа.Вставить("Ссылка", ЗначениеМассива);
				СтатусОтправкиЗаказа.Вставить("Статус", НСтр("ru = 'Ошибка формирования'"));
				СтатусОтправкиЗаказа.Вставить("Пометка", Истина);
				МассивСтатусовОтправкиЗаказов.Добавить(СтатусОтправкиЗаказа);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	ПоместитьВоВременноеХранилище(МассивСтатусовОтправкиЗаказов, АдресРезультата);
	
КонецПроцедуры

// Получение списка категорий рубрикатора.
//
// Параметры:
//  СтруктураПараметров - Структура - параметры для выполнения:
//   * АдресКэшаКатегорийРубрик - Строка - адрес временного хранилища для кэширования категорий рубрикатора.
//  АдресХранилища - Строка - адрес временного хранилища с результатом.
//
Процедура ПолучитьКатегорииРубрикатора(СтруктураПараметров, АдресХранилища) Экспорт
	
	Отказ = Ложь;
	ПараметрыКоманды = ТорговыеПредложения.ПараметрыКомандыПолучитьСписокВсехКатегорий();
	Результат = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Дерево = ОписаниеСтруктурыКатегорийРубрикатора();
	Для каждого ЭлементСтруктуры Из Результат Цикл
		
		ИдентификаторРодителя = XMLСтрока(ЭлементСтруктуры.parentCategoryId);
		
		Если ПустаяСтрока(ИдентификаторРодителя) Тогда
			НоваяСтрока = Дерево.Строки.Добавить();
		Иначе
			СтрокаРодителя = Дерево.Строки.Найти(ИдентификаторРодителя, "Идентификатор", Истина);
			Если СтрокаРодителя = Неопределено Тогда
				ВызватьИсключение НСтр("ru = 'Ошибка загрузки рубрикатора. Не найден идентификатор группы.'");
			КонецЕсли;
			НоваяСтрока = СтрокаРодителя.Строки.Добавить();
		КонецЕсли; 
		
		НоваяСтрока.Идентификатор         = XMLСтрока(ЭлементСтруктуры.Id);
		НоваяСтрока.Представление         = ЭлементСтруктуры.title;
		НоваяСтрока.КоличествоПодчиненных = ЭлементСтруктуры.childrenCount;
		НоваяСтрока.ИндексКартинки        = ?(НоваяСтрока.КоличествоПодчиненных > 0, 0 ,3);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Дерево, АдресХранилища); // Помещение в хранилище.

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеСтруктурыКатегорийРубрикатора()

	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Идентификатор",         Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Представление",         Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("КоличествоПодчиненных", Новый ОписаниеТипов("Число"));
	Дерево.Колонки.Добавить("ИндексКартинки",        Новый ОписаниеТипов("Число"));

	Возврат Дерево;
	
КонецФункции

Процедура ЗаполнитьУзелРубрикатора(Владелец, Идентификатор)
	
	Отказ = Ложь;
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("ИдентификаторКатегории", Идентификатор);
	ПараметрыКоманды = ТорговыеПредложения.ПараметрыКомандыПолучитьСписокДочернихКатегорий(ПараметрыМетода, Отказ);
	Результат = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЭлементСтруктуры Из Результат Цикл
		
		НоваяСтрока = Владелец.Строки.Добавить();
		НоваяСтрока.Идентификатор         = Формат(ЭлементСтруктуры.Id, "ЧГ="); // Преобразование локализованного числа.
		НоваяСтрока.Представление         = ЭлементСтруктуры.title;
		НоваяСтрока.КоличествоПодчиненных = ЭлементСтруктуры.childrenCount;
		
		Если НоваяСтрока.КоличествоПодчиненных > 0 Тогда
			ЗаполнитьУзелРубрикатора(НоваяСтрока, НоваяСтрока.Идентификатор);
			НоваяСтрока.ИндексКартинки = 0;
		Иначе
			НоваяСтрока.ИндексКартинки = 3;
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
