﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|	
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ДанныеДоговора.ХарактерДоговора КАК ХарактерДоговора,
	|	ТаблицаДокумента.Дата КАК ДатаНачисления,
	|	ТаблицаДокумента.СтатьяДоходовРасходов = НЕОПРЕДЕЛЕНО
	|		ИЛИ ТаблицаДокумента.СтатьяДоходовРасходов = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиДоходов.ПустаяСсылка)
	|		ИЛИ ТаблицаДокумента.СтатьяДоходовРасходов = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка) КАК НеУказанаСтатья,
	|	НЕ (ТаблицаДокумента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания) КАК ДатаНеВПериоде
	|
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК ДанныеДоговора
	|	ПО ТаблицаДокумента.Договор = ДанныеДоговора.Ссылка
	|
	|ГДЕ
	|	(ТаблицаДокумента.ТипСуммыГрафика <> ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Комиссия)
	|	И (ТаблицаДокумента.СтатьяДоходовРасходов = НЕОПРЕДЕЛЕНО
	|		ИЛИ ТаблицаДокумента.СтатьяДоходовРасходов = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиДоходов.ПустаяСсылка)
	|		ИЛИ ТаблицаДокумента.СтатьяДоходовРасходов = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка))
	|	)
	|	ИЛИ (НЕ (ТаблицаДокумента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокумента.НомерСтроки
	|;
	|");
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", Начисления.Выгрузить());
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НеУказанаСтатья Тогда
			Текст = СтрШаблон(НСтр("ru = 'Не указана статья %1 в строке %2 списка ""Начисления""'"),
						Справочники.ДоговорыКредитовИДепозитов.ТипСтатьи(Выборка.ХарактерДоговора),
						Выборка.НомерСтроки);
			ПолеТабЧасти = "СтатьяДоходовРасходов";
			
		ИначеЕсли Выборка.ДатаНеВПериоде Тогда
			Текст = СтрШаблон(НСтр("ru = 'Дата начисления %1 в строке %2 не входит в заданный период начисления.'"),
						Формат(Выборка.ДатаНачисления, "ДЛФ=D"),
						Выборка.НомерСтроки);
			ПолеТабЧасти = "Дата";
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Начисления", Выборка.НомерСтроки, ПолеТабЧасти),
			,
			Отказ);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.НачисленияКредитовИДепозитов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Кредиты
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Депозиты и займы выданные
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения расчетов по договорам кредитов и депозитов.
	ДенежныеСредстваСервер.ОтразитьРасчетыПоДоговорамКредитовИДепозитов(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по суммам в валюте регламентированного учета
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Начисления);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
