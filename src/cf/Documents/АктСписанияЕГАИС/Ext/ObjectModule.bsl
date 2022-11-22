﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияЕГАИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.АктСписанияЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
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
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра2
		Или ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Справка2");
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаСписания");
	КонецЕсли;
	
	Если Дата < '20180101' И ВидДокумента <> Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра3 Тогда
		ПроверятьТолькоЕслиЗаполнены = Истина;
	Иначе
		ПроверятьТолькоЕслиЗаполнены = ПричинаСписания <> Перечисления.ПричиныСписанийЕГАИС.Реализация;
	КонецЕсли;
	
	АкцизныеМаркиЕГАИС.ПроверитьЗаполнениеАкцизныхМарок(ЭтотОбъект, Отказ, ПроверятьТолькоЕслиЗаполнены);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
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
	
	ИнтеграцияЕГАИСПереопределяемый.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, Истина);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра3 Тогда
		ПричинаСписания = Неопределено;
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
