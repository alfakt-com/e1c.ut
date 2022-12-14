#Область СлужебныйПрограммныйИнтерфейс

// Возвращает через третий параметр признак наличия маркируемой продукции.
//
// Параметры:
//  Коллекция                - ДанныеФормыКоллекция - ТЧ с товарами.
//  ВидМаркируемойПродукции  - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции, наличие которой необходимо определить.
//  ЕстьМаркируемаяПродукция - Булево - Исходящий, признак наличия маркируемой продукции.
Процедура ЕстьМаркируемаяПродукцияВКоллекции(Коллекция, ВидМаркируемойПродукции, ЕстьМаркируемаяПродукция) Экспорт
	
	
КонецПроцедуры

// Возвращает через третий параметр таблицу товаров документа, являющихся маркируемой продукцией требуемого вида.
//
// Параметры:
//  * Контекст                 - УправляемаяФорма, ДокументСсылка - документ, маркируемую продукцию которого необходимо получить.
//  * ВидМаркируемойПродукции  - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции, которую необходимо получить.
//  * ТаблицаМаркируемойПродукции - ТаблицаЗначений - Исходящий, таблица с маркируемой продукцией документа. Должна содержать колонки:
//  ** GTIN           - Строка - GTIN продукции
//  ** Номенклатура   - ОпределяемыйТип.Номенклатура - номенклатура маркируемой продукции
//  ** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатура маркируемой продукции
//  ** Серия          - ОпределяемыйТип.СерияНоменклатуры - серия номенклатура маркируемой продукции
//  ** Количество     - Число - количество маркируемой продукции
Процедура ПриОпределенииМаркируемойПродукцииДокумента(Контекст, ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции) Экспорт
	
	//++ НЕ ГОСИС
	ИСМПТВыбытиеКодовМаркировкиСервер.ПроверкаИПодборПродукцииИСМПУТ_ЗаполнитьМаркируемуюПродукциюДокумента(Контекст, ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возвращает через второй параметр признак что переданный контрагент является нерезидентом.
//
// Параметры:
//  Контрагент - СправочникСсылка.Контрагенты - Проверяемы контрагент
//  НеРезидент - Булево - Признак что контрагент не резидент (Истина) или резидент (Ложь).
//
Процедура ПриОпределенииКонтрагентНеРезидент(Контрагент, НеРезидент) Экспорт
	
	//++ НЕ ГОСИС
	НеРезидент = ИСМПТВыбытиеКодовМаркировкиСервер.ПроверкаИПодборПродукцииИСМПУТ_КонтрагентНеРезидент(Контрагент);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Предназначена для реализации функциональности по отражению результатов проверки и подбора в документе, из которого была вызвана соответствующая форма.
// 
// Параметры:
//  ПараметрыОкончанияПроверки - (См. ПроверкаИПодборИСМП.ЗафиксироватьРезультатПроверкиИПодбора).
Процедура ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияПроверки) Экспорт
	
	
КонецПроцедуры

// Получает сформированный ранее Акт о расхождениях для переданного документа.
// 
// Параметры:
//  Документ         - ДокументСсылка - ссылка на документ, для которого необходимо получить Акт о расхождениях:
//  АктОРасхождениях - ДокументСсылка - ссылка на Акт о расхождениях:
Процедура ПолучитьСформированныйАктОРасхождениях(Документ, АктОРасхождениях) Экспорт
	
	//++ НЕ ГОСИС
	АктОРасхождениях = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтеграцияИСМПУТ_СформированныйАктОРасхождениях(Документ);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Заполняет в табличной части служебные реквизиты, например: признак использования характеристик номенклатуры.
//
// Параметры:
//  Форма          - УправляемаяФорма - Форма.
//  ТабличнаяЧасть - ДанныеФормыКоллекция, ТаблицаЗначений - таблица для заполнения.
Процедура ЗаполнитьСлужебныеРеквизитыВКоллекции(Форма, ТабличнаяЧасть) Экспорт
	
	//++ НЕ ГОСИС
	ИСМПТВыбытиеКодовМаркировкиСервер.ПроверкаИПодборПродукцииИСМПУТ_ЗаполнитьСлужебныеРеквизитыВКоллекции(Форма, ТабличнаяЧасть);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Устанавливает режим просмотра (доступности, для команд) элементам формы.
//   Переопределение необходимо использовать для совместной работы с аналогичными механизмами.
//   Обработанные здесь реквизиты мледует удалить из массива "Блокируемые элементы".
// 
// Параметры:
//  Форма               - УправляемаяФорма - форма в которой производится изменение доступности
//  БлокируемыеЭлементы - Массив - наименования реквизитов
//  Заблокировать       - Булево - заблокировать или разблокировать реквизиты
Процедура УстановитьТолькоПросмотрЭлементов(
		Форма,
		БлокируемыеЭлементы,
		Заблокировать) Экспорт
	
	
КонецПроцедуры

#Область СерииНоменклатуры

// Предназначена для расчета статусов указания серий во всех строках таблицы товаров
//
// Параметры:
//  Форма        - УправляемаяФорма - форма с таблицей товаров
//  ПараметрыУказанияСерий - Структура - параметры указания серий
Процедура ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	ИСМПТВыбытиеКодовМаркировкиСервер.ПроверкаИПодборПродукцииИСМПУТ_ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возвращает через параметр наличие права на добавление элементов справочника СерииНоменклатуры
//
// Параметры:
//  ПравоДобавлениеСерий - Булево - исходящий, наличие права на добавление.
Процедура ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий) Экспорт
	
	//++ НЕ ГОСИС
	ИСМПТВыбытиеКодовМаркировкиСервер.ПроверкаИПодборПродукцииИСМПУТ_ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыИнтеграцииФормыПроверкиИПодбора

// Заполняет специфику интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой настраиваются параметры интеграции.
//  ПараметрыИнтеграции - (См.ПроверкаИПодборПродукцииИС.ПараметрыИнтеграцииФормПроверкиИПодбора).
//  ВидПродукции - Перечислениессылка.ВидыПродукцииИС - вид продукции для которого проводится встраивание
//
Процедура ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(Форма, ПараметрыИнтеграции, ВидПродукции = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(Форма.ИмяФормы,"Документ.ЧекККМ.Форма.ФормаДокументаРМК") Тогда
		
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкиПодбораДокумента = Ложь;
		ПараметрыИнтеграции.ИмяТабличнойЧастиШтрихкодыУпаковок         = "АкцизныеМарки";
		ПараметрыИнтеграции.ИмяКолонкиШтрихкодУпаковки                 = "АкцизнаяМарка";
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Заполняет специфику применения интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой применяются параметры интеграции.
//
Процедура ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСТСД

// Обрабатывает таблицу штриховых кодов и получает для каждого из них данные в информационной базе.
//   На входе имеется таблица, в которой заполнены только колонки "Номер строки", "Штриховой код" и "Количество", опционально заполнена 
//   колонка "Родитель".
//   В процедуре заполняется допустимый штрихкод упаковки из справочника или признак новой (неизвестной) упаковки.
//
// Параметры:
//  ТаблицаНеАкцизныеМарки - ТаблицаЗначение - имеет следующие колонки:
//   * ШтриховойКод        - Строка                              - штриховой код полученный с ТСД.
//   * Количество          - Число                               - сколько раз был считан данный штрихкод.
//   * ШтрихКодУпаковки    - Справочник.ШтрихкодыУпаковокТоваров - ссылка на имеющуюся в базе упаковку.
//   * Родитель            - Строка                              - штрихкод внешней упаковки.
//   * НомерСтроки         - Число                               - номер строки таблицы
//   * ЭтоУпаковка         - Булево                              - признак новой упаковки
//
Процедура РаспознатьШтрихкоды(ТаблицаНеАкцизныеМарки) Экспорт
	
	Возврат;

КонецПроцедуры

#КонецОбласти

#КонецОбласти