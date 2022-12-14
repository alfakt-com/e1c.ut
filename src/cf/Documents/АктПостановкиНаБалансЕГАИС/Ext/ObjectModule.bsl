#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияЕГАИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.АктПостановкиНаБалансЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияЕГАИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияЕГАИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияЕГАИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияЕГАИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1
		Или ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3 Тогда
		
		АкцизныеМаркиЕГАИС.ПроверитьЗаполнениеАкцизныхМарок(ЭтотОбъект, Отказ);
		
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаПостановкиНаБаланс");
	КонецЕсли;
	
	Если ПричинаПостановкиНаБаланс <> Перечисления.ПричиныПостановкиНаБалансЕГАИС.Пересортица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("АктСписанияЕГАИС");
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2
		Или ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоСправке1");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерТТН");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаТТН");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаРозлива");
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1
		Или ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Справка2");
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = ИнтеграцияЕГАИС.НовыйИдентификаторДокумента();
	КонецЕсли;
	
	Если СтатусПроверкиИПодбора <> Перечисления.СтатусыПроверкиИПодбораЕГАИС.Выполняется Тогда
		ДанныеПроверкиИПодбора = Неопределено;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИСПереопределяемый.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, Истина,,Истина);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	Идентификатор           = "";
	ИдентификаторЕГАИС      = "";
	ДатаРегистрацииДвижений = '00010101';
	
	Если Товары.Количество() > 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "Справка2");
	КонецЕсли;
	
	СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораЕГАИС.НеВыполнялось;
	ДанныеПроверкиИПодбора = Неопределено;
	АкцизныеМарки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
