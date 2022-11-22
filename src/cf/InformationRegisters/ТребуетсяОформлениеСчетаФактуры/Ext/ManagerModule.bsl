﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Вызывает при проведении/отмене проведения документов продажи или счетов-фактуры выданных.
// Анализирует проводимые документы, регистрируя документы продажи, по которым необходим счет-фактура.
//
// Параметры:
//	ДополнительныеСвойства - Структура - свойство документа-объекта при проведении
//	Отказ - Булево - Признак отмены операции проведения.
//
Процедура ОтразитьНеобходимостьОформленияСчетаФактуры(ДополнительныеСвойства, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// 1. Если это проведение/отмена проведения счета-фактуры проверяются документы:
	//		- основания счета-фактуры перед записью
	//		- основания счета-фактуры в записываемом объекте
	//		массив этих оснований в свойстве "МассивОснованийДляПроверки"
	// 2. Если это проведение документа продажи, то проверяется сам документ
	// 3. Если это отмена проведения документа продажи, то документ автоматически удаляется из регистра.
	
	Основание = ДополнительныеСвойства.ДляПроведения.Ссылка;
	УдалениеПроведения = (ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения);
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураВыданный")
		ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент") Тогда
		СнятьНеобходимостьНепосредственно = Ложь;
		МассивСсылок = ДополнительныеСвойства.МассивОснованийДляПроверки;
		Если МассивСсылок.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
	Иначе
		СнятьНеобходимостьНепосредственно = УдалениеПроведения;
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(Основание);
	КонецЕсли;
	
	Если СнятьНеобходимостьНепосредственно Тогда
		
		Для Каждого СтрокаСсылка Из МассивСсылок Цикл
			Набор = РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.СоздатьНаборЗаписей();
			Набор.Отбор.Основание.Установить(СтрокаСсылка);
			Набор.Записать(Истина);
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	ВыборкаОснований = ВыборкаПризнакаНеобходимостиСчетаФактуры(МассивСсылок, Основание, УдалениеПроведения);
	
	Пока ВыборкаОснований.Следующий() Цикл
		
		Набор = РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.СоздатьНаборЗаписей();
		Набор.Отбор.Основание.Установить(ВыборкаОснований.Основание);
		
		ДетальнаяВыборка = ВыборкаОснований.Выбрать();
		Пока ДетальнаяВыборка.Следующий() Цикл
			
			Если ДетальнаяВыборка.Требуется Тогда
				СтрокаНабора = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора, ДетальнаяВыборка);
			КонецЕсли;
			
		КонецЦикла;
		
		Набор.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыборкаПризнакаНеобходимостиСчетаФактуры(МассивСсылок, Основание, УдалениеПроведения) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстЗапросаВременныхТаблиц =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка                 КАК СчетФактура,
	|	ДанныеДокумента.ДокументОснование      КАК Основание,
	|	ДанныеДокумента.Ссылка.Организация     КАК Организация,
	|	ДанныеДокумента.Ссылка.Контрагент      КАК Контрагент,
	|	&ТипСФВыданный                         КАК ТипСчетаФактуры
	|ПОМЕСТИТЬ ТаблицаСчетовФактуры
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.ДокументОснование В(&МассивОснований)
	|	И ДанныеДокумента.Ссылка.Проведен
	|	//УсловиеИсключенияСчетаФактуры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка                 КАК СчетФактура,
	|	ДанныеДокумента.ДокументОснование      КАК Основание,
	|	ДанныеДокумента.Ссылка.Организация     КАК Организация,
	|	ДанныеДокумента.Ссылка.Контрагент      КАК Контрагент,
	|	&ТипСФПолученныйНалоговыйАгент         КАК ТипСчетаФактуры
	|ИЗ
	|	Документ.СчетФактураПолученныйНалоговыйАгент.ДокументыОснования КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.ДокументОснование В(&МассивОснований)
	|	И ДанныеДокумента.Ссылка.Проведен
	|	//УсловиеИсключенияСчетаФактуры
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ДанныеПервичныхДокументов.ДатаРегистратора КАК Дата,
	|	ДанныеПервичныхДокументов.Организация КАК Организация,
	|	ДанныеПервичныхДокументов.Документ КАК Ссылка
	|ПОМЕСТИТЬ ДанныеПервичныхДокументов
	|ИЗ
	|	РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|ГДЕ
	|	ДанныеПервичныхДокументов.Документ В (&МассивОснований)
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПервичныхДокументов.Организация       КАК Организация,
	|	ДанныеПервичныхДокументов.Ссылка            КАК Ссылка,
	|	МАКСИМУМ(УчетнаяПолитикаОрганизаций.Период) КАК Период
	|ПОМЕСТИТЬ ПериодыУчетныхПолитик
	|ИЗ
	|	ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ДанныеПервичныхДокументов.Дата >= УчетнаяПолитикаОрганизаций.Период
	|		И ДанныеПервичныхДокументов.Организация = УчетнаяПолитикаОрганизаций.Организация
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПервичныхДокументов.Организация,
	|	ДанныеПервичныхДокументов.Ссылка
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыУчетныхПолитик.Организация                     КАК Организация,
	|	ПериодыУчетныхПолитик.Ссылка                          КАК Ссылка,
	|	СпрУчетныеПолитики.ПрименяетсяОсвобождениеОтУплатыНДС КАК ПрименяетсяОсвобождениеОтУплатыНДС
	|ПОМЕСТИТЬ УчетнаяПолитика
	|ИЗ
	|	ПериодыУчетныхПолитик КАК ПериодыУчетныхПолитик
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ПериодыУчетныхПолитик.Период = УчетнаяПолитикаОрганизаций.Период
	|		И ПериодыУчетныхПолитик.Организация = УчетнаяПолитикаОрганизаций.Организация
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.УчетныеПолитикиОрганизаций КАК СпрУчетныеПолитики
	|	ПО
	|		УчетнаяПолитикаОрганизаций.УчетнаяПолитика = СпрУчетныеПолитики.Ссылка
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|";
	
	Если (ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураВыданный")
		ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент"))
		И УдалениеПроведения Тогда
		
		ТекстЗапросаВременныхТаблиц = СтрЗаменить(ТекстЗапросаВременныхТаблиц, 
			"//УсловиеИсключенияСчетаФактуры", 
			"И ДанныеДокумента.Ссылка <> &ТекушийСчетФактура");
		
		Запрос.УстановитьПараметр("ТекушийСчетФактура", Основание);
		
	КонецЕсли;
	
	СоответствиеТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивСсылок);
	
	ТекстЗапроса = "";
	
	Для Каждого ТипДокумента Из СоответствиеТипов Цикл
		
		Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипДокумента.Ключ);
		ТекстЗапроса    = ТекстЗапроса + МенеджерОбъекта.ТекстЗапросаДляРасчетаНеобходимостиСчетаФактуры();
		
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапросаВременныхТаблиц + ТекстЗапроса + "
	|ИТОГИ ПО
	|	Основание";
	
	Запрос.УстановитьПараметр("МассивОснований", МассивСсылок);
	Запрос.УстановитьПараметр("ПродажаОблагаетсяЕНВД", Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД);
	Запрос.УстановитьПараметр("ПродажаНаЭкспорт", Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт);
	Запрос.УстановитьПараметр("ТипСФВыданный", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураВыданный"));
	Запрос.УстановитьПараметр("ТипСФПолученныйНалоговыйАгент", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураПолученныйНалоговыйАгент"));
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Возврат Выборка;
	
КонецФункции

#КонецОбласти

#КонецЕсли


