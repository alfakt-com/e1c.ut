#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("РеквизитыШапки") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.РеквизитыШапки);
		ИначеЕсли ДанныеЗаполнения.Свойство("ВидОперации")
			И ЗначениеЗаполнено(ДанныеЗаполнения.ВидОперации) Тогда
			ВидОперации = ДанныеЗаполнения.ВидОперации;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Товары") Тогда
			ЗаполнитьПоТаблицеТовары(ДанныеЗаполнения.Товары);
		КонецЕсли;
		
	Иначе
		
		ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
		
	КонецЕсли;
	
	Заказ = Неопределено;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура")
		И ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		
		Заказ = ДанныеЗаполнения;
		
	КонецЕсли;
	
	ДокументПоРаспоряжению = ЗначениеЗаполнено(Заказ);
	
	Если ЗначениеЗаполнено(Заказ) Тогда
		
		Назначение = Документы.КорректировкаНазначенияТоваров.НазначениеЗаказа(Заказ);
		
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заказ, "Организация");
		
		Документы.КорректировкаНазначенияТоваров.ЗаполнитьПоОснованию(Назначение, Организация, Ссылка, ВидОперации, Товары, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ПроверитьКомплектностьТоварныхМест = Истина;
	ПараметрыПроверки.ПоляГруппировкиПроверкиКомплектности = "ИсходноеНазначение, НовоеНазначение";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
												
	СкладыСервер.ПроверитьЗаполнениеЯчеек(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	СкладыСервер.ПроверитьЗаполнениеПомещений(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НовоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ИсходноеНазначение");
	
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям
		Или ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.ПроизвольнаяКорректировкаНазначений Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	
	ПроверитьЗаполнениеНовогоНазначения(Отказ);
	
	// Проверка заполнения упаковок номенклатуры на адресных складах
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Склад,
	|	Товары.Помещение
	|ПОМЕСТИТЬ СкладыИПомещения
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладыИПомещения.Склад,
	|	СкладыИПомещения.Помещение
	|ИЗ
	|	СкладыИПомещения КАК СкладыИПомещения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|		ПО (НастройкиАдресныхСкладов.ИспользоватьАдресноеХранение)
	|			И (НастройкиАдресныхСкладов.ДатаНачалаАдресногоХраненияОстатков <= &Дата)
	|			И (НастройкиАдресныхСкладов.Склад = СкладыИПомещения.Склад)
	|			И (НастройкиАдресныхСкладов.Помещение = СкладыИПомещения.Помещение)
	|			И (НЕ СкладыИПомещения.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|				ИЛИ (НЕ НастройкиАдресныхСкладов.Склад.ИспользоватьСкладскиеПомещения
	|					ИЛИ &Дата < НастройкиАдресныхСкладов.Склад.ДатаНачалаИспользованияСкладскихПомещений))";
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"Склад, Помещение"));
	Запрос.УстановитьПараметр("Дата",
		?(ЗначениеЗаполнено(Дата),Дата,ТекущаяДатаСеанса()));
	
	ВыборкаСкладПомещение = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаСкладПомещение.Следующий() Цикл
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияУпаковок();
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Склад", ВыборкаСкладПомещение.Склад);
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Помещение", ВыборкаСкладПомещение.Помещение);
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	КонецЦикла;
	
	// Проверка на то, что одно из двух полей назначения заполнено
	ПустоеНазначение = Справочники.Назначения.ПустаяСсылка();
	СтруктураПоиска = Новый Структура("ИсходноеНазначение, НовоеНазначение", ПустоеНазначение, ПустоеНазначение);
	НайденныеСтроки = Товары.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		ШаблонСообщения = НСтр("ru='Не заполнено назначение в колонках ""Исходное назначение"" и ""Новое назначение"" в строке %НомерСтроки%. 
			|Необходимо заполнить одну из колонок (либо обе).'");
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%НомерСтроки%", Строка.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ)
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ОбменДанными.Загрузка 
		Или ЭтотОбъект.ДополнительныеСвойства.Свойство("ПрограммноеСозданиеДокумента") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПравоПроведенияДокумента(Отказ);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.КорректировкаОбособленногоУчета, Неопределено, Неопределено, Неопределено);
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.Произвольный = "Склад";
		ИменаПолей.Назначение = "ИсходноеНазначение";
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);

		ИменаПолей.Назначение = "НовоеНазначение";
		ИменаПолей.АналитикаУчетаНоменклатуры = "АналитикаУчетаНоменклатурыОприходование";
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
		
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.КорректировкаНазначенияТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	//
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	//
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	// Движения по оборотным регистрам управленческого учета 
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураНоменклатура(ДополнительныеСвойства, Движения, Отказ);
	

	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов(Ложь);
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов(Ложь);
	ПараметрыЗаполненения.ДокументДелаетИПриходИРасход = Ложь;
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);

	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПравоПроведенияДокумента(Отказ)
	
	Если Не Документы.КорректировкаНазначенияТоваров.ДоступнаВозможностьИзменения(Ссылка) Тогда
		СтрокаИсключения = НСтр("ru = 'Недостаточно прав доступа для записи документа с действием ""%1"".'");
		СтрокаИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаИсключения, ВидОперации);
		ВызватьИсключение СтрокаИсключения;
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если Не ЭтотОбъект.ДополнительныеСвойства.Свойство("ПрограммноеСозданиеДокумента") Тогда
		
		Массив.Добавить(Движения.ОбеспечениеЗаказов);
		Массив.Добавить(Движения.СвободныеОстатки);
		// Приходы в регистр (сторно расхода регистра) контролируем при перепроведении и отмене проведения.
		Если Не ДополнительныеСвойства.ЭтоНовый Тогда
			Массив.Добавить(Движения.ТоварыОрганизаций);
		КонецЕсли;
	КонецЕсли;
	Если ИспользуетсяАдресноеХранение() Тогда
		Массив.Добавить(Движения.ТоварыВЯчейках);
	КонецЕсли;
	Массив.Добавить(Движения.ТоварыВЯчейках);
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Процедура ЗаполнитьПоТаблицеТовары(ТаблицаТоваров)
	
	Товары.Очистить();
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		СтрокаПродукция = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПродукция, СтрокаТовара);
	КонецЦикла;
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьЗаполнениеНовогоНазначения(Отказ)
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ВременныеТаблицыДанныхДокумента(НаПустоеНазначение)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаОбособленногоУчета) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.ИсходноеНазначение КАК Назначение,
	|	ТаблицаТоваров.НовоеНазначение КАК НовоеНазначение,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &НаПустоеНазначение
	|				ТОГДА ТаблицаТоваров.НовоеНазначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ИНАЧЕ ТаблицаТоваров.НовоеНазначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	Аналитика.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК СпрВидЗапасов
	|		ПО (СпрВидЗапасов.Ссылка = ТаблицаВидыЗапасов.ВидЗапасов)
	|ГДЕ
	|	НЕ(СпрВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|				И СпрВидЗапасов.ВладелецТовара = НЕОПРЕДЕЛЕНО)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов.Выгрузить(Новый Структура("НовоеНазначениеПустое", НаПустоеНазначение)));
	
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("НаПустоеНазначение", НаПустоеНазначение);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
		
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТоваров.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		ИСТИНА
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтрокиСПустымНазначением = Товары.НайтиСтроки(Новый Структура("НовоеНазначение", Справочники.Назначения.ПустаяСсылка()));
	
	ЕстьПоПустомуНазначению      = СтрокиСПустымНазначением.Количество() > 0;
	ЕстьПоЗаполненномуНазначению = СтрокиСПустымНазначением.Количество() <> Товары.Количество();
	
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	ВидыЗапасовПерезаполнены = Ложь;
	
	Если ЕстьПоПустомуНазначению Тогда
		
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента(Истина);
		
		Если Не Проведен
			Или ПерезаполнитьВидыЗапасов
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			ВидыЗапасовПерезаполнены = Истина;
			
			Если ЕстьПоЗаполненномуНазначению Тогда
				ВидыЗапасовПоЗаполненномуНазначению = ВидыЗапасов.Выгрузить(Новый Структура("НовоеНазначениеПустое", Ложь));
				ВидыЗапасов.Очистить();
			КонецЕсли;
				
			ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(Истина);
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
												МенеджерВременныхТаблиц,
												Отказ,
												ПараметрыЗаполнения);
												
			Для Каждого СтрТабл Из ВидыЗапасов Цикл
				СтрТабл.НовоеНазначениеПустое = Истина;
			КонецЦикла;
												
			Если ЕстьПоЗаполненномуНазначению Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПоЗаполненномуНазначению);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьПоЗаполненномуНазначению Тогда
		
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента(Ложь);
		
		Если Не Проведен
			Или ПерезаполнитьВидыЗапасов
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			ВидыЗапасовПерезаполнены = Истина;
			
			Если ЕстьПоПустомуНазначению Тогда
				ВидыЗапасовПустомуНазначению = ВидыЗапасов.Выгрузить(Новый Структура("НовоеНазначениеПустое", Истина));
				ВидыЗапасов.Очистить();
			КонецЕсли;
		
			ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(Ложь);
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
												МенеджерВременныхТаблиц,
												Отказ,
												ПараметрыЗаполнения);
			
												
			Если ЕстьПоПустомуНазначению Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПустомуНазначению);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидыЗапасовПерезаполнены Тогда
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНоменклатурыОприходование,ВидЗапасовОприходование,ВидЗапасов,НовоеНазначениеПустое, НомерГТД", "Количество");
		ЗаполнитьАналитикуОприходованиеВидовЗапасов();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|		ТаблицаТоваров.Количество КАК Количество
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьАналитикуОприходованиеВидовЗапасов()
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	Для Каждого СтрокаТоваров Из Товары Цикл

		КоличествоТоваров = СтрокаТоваров.Количество;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл

			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);

			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.АналитикаУчетаНоменклатурыОприходование = СтрокаТоваров.АналитикаУчетаНоменклатурыОприходование;
			Если Не ЗначениеЗаполнено(НоваяСтрока.ВидЗапасовОприходование) Тогда
				НоваяСтрока.ВидЗапасовОприходование	= СтрокаЗапасов.ВидЗапасов;
			КонецЕсли;
			НоваяСтрока.Количество					= Количество;

			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;

			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов(НаПустоеНазначение)
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = Истина;

	Если НаПустоеНазначение Тогда
		// типы запасов по умолчанию в этом случае
	Иначе
		ПараметрыЗаполнения.ОтборыВидовЗапасов.ТипЗапасов.Добавить(Перечисления.ТипыЗапасов.МатериалДавальца);
		ПараметрыЗаполнения.ОтборыВидовЗапасов.ТипЗапасов.Добавить(Перечисления.ТипыЗапасов.ПродукцияДавальца);
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ИспользуетсяАдресноеХранение()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЧТовары.Склад КАК Склад,
		|	ТЧТовары.Помещение КАК Помещение
		|ПОМЕСТИТЬ ТЧТовары
		|ИЗ
		|	&ТЧТовары КАК ТЧТовары
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Склад,
		|	Помещение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	1 КАК Поле1
		|ИЗ
		|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТЧТовары КАК ТЧТовары
		|		ПО НастройкиАдресныхСкладов.Склад = ТЧТовары.Склад
		|			И НастройкиАдресныхСкладов.Помещение = ТЧТовары.Помещение
		|ГДЕ
		|	НастройкиАдресныхСкладов.ИспользоватьАдресноеХранение
		|	И НастройкиАдресныхСкладов.ДатаНачалаАдресногоХраненияОстатков <= &Дата
		|	И (НЕ НастройкиАдресныхСкладов.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
		|			ИЛИ (НЕ НастройкиАдресныхСкладов.Склад.ИспользоватьСкладскиеПомещения
		|				ИЛИ &Дата < НастройкиАдресныхСкладов.Склад.ДатаНачалаИспользованияСкладскихПомещений))";
		
	Запрос.УстановитьПараметр("ТЧТовары", Товары.Выгрузить(,"Склад, Помещение"));
	Запрос.УстановитьПараметр("Дата",
		?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
