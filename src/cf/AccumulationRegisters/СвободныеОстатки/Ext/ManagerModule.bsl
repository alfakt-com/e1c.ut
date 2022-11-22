﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция ТекстЗапросаОстатков предназначена для получения остатков регистра
// в разрезе номенклатуры, характеристики и склада.
//
// Параметры:
//  ИспользоватьКорректировку - Булево - признак необходимости скорректировать движения регистра перед получением остатков.
//  Разделы - Массив - массив в который будет добавлена информация о временных таблицах создаваемых при выполнении запроса.
//
// Возвращаемое значение:
//  Строка - Текст запроса свободного остатка регистра в разрезе номенклатуры, характеристики и склада.
//
Функция ТекстЗапросаОстатков(ИспользоватьКорректировку, Разделы = Неопределено) Экспорт

	Если Не ИспользоватьКорректировку Тогда
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Т.Номенклатура           КАК Номенклатура,
			|	Т.Характеристика         КАК Характеристика,
			|	Т.Склад                  КАК Склад,
			|
			|	Т.ВНаличииОстаток
			|		- Т.ВРезервеСоСкладаОстаток
			|		- Т.ВРезервеПодЗаказОстаток КАК Количество
			|
			|ПОМЕСТИТЬ ВтОстаткиСклада
			|ИЗ
			|	РегистрНакопления.СвободныеОстатки.Остатки(,
			|		(Номенклатура, Характеристика, Склад) В(
			|			ВЫБРАТЬ
			|				Ключи.Номенклатура   КАК Номенклатура,
			|				Ключи.Характеристика КАК Характеристика,
			|				Ключи.Склад          КАК Склад
			|			ИЗ
			|				ВтТовары КАК Ключи
			|		)) КАК Т
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Склад
			|;
			|
			|/////////////////////////////////////////////////////////////
			|";
	Иначе
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	НаборДанных.Номенклатура           КАК Номенклатура,
			|	НаборДанных.Характеристика         КАК Характеристика,
			|	НаборДанных.Склад                  КАК Склад,
			|
			|	СУММА(НаборДанных.Количество)      КАК Количество
			|
			|ПОМЕСТИТЬ ВтОстаткиСклада
			|ИЗ (
			|	ВЫБРАТЬ
			|		Т.Номенклатура           КАК Номенклатура,
			|		Т.Характеристика         КАК Характеристика,
			|		Т.Склад                  КАК Склад,
			|
			|		Т.ВНаличииОстаток
			|			- Т.ВРезервеСоСкладаОстаток
			|			- Т.ВРезервеПодЗаказОстаток КАК Количество
			|
			|	ИЗ
			|		РегистрНакопления.СвободныеОстатки.Остатки(,
			|			(Номенклатура, Характеристика, Склад) В(
			|				ВЫБРАТЬ
			|					Ключи.Номенклатура   КАК Номенклатура,
			|					Ключи.Характеристика КАК Характеристика,
			|					Ключи.Склад          КАК Склад
			|				ИЗ
			|					ВтТовары КАК Ключи
			|			)) КАК Т
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|		Т.Номенклатура            КАК Номенклатура,
			|		Т.Характеристика          КАК Характеристика,
			|		Т.Склад                   КАК Склад,
			|
			|		- Т.ВРезерве - Т.КОтгрузке КАК Количество
			|
			|	ИЗ
			|		ВтТоварыКОтгрузкеКорректировка КАК Т
			|	ГДЕ
			|		Т.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|
			|	) КАК НаборДанных
			|
			|СГРУППИРОВАТЬ ПО
			|	НаборДанных.Номенклатура, НаборДанных.Характеристика, НаборДанных.Склад
			|ИМЕЮЩИЕ
			|	СУММА(НаборДанных.Количество) <> 0
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Склад
			|;
			|
			|/////////////////////////////////////////////////////////////
			|";
	КонецЕсли;

	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаОстаткиСклада");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра = "СвободныеОстатки";
	ПолноеИмяРегистра = "РегистрНакопления.СвободныеОстатки";
	
	СписокДокументов = Новый Массив;
	СписокДокументов.Добавить("Документ.КорректировкаПоОрдеруНаТовары");
	
	Для Каждого ПолноеИмяДокумента Из СписокДокументов Цикл
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		ТекстЗапросаМеханизмаПроведения = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
		Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
								ТекстЗапросаМеханизмаПроведения,
								ПолноеИмяРегистра,
								ПолноеИмяДокумента);
								
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.СвободныеОстатки";
	
	ОбработкаЗавершена = Ложь;
	
	Регистраторы = Новый Массив;
	
	Регистраторы.Добавить("Документ.КорректировкаПоОрдеруНаТовары");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, ПолноеИмяРегистра, Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли