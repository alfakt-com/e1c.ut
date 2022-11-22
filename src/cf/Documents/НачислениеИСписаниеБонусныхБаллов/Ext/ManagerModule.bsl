﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Начисление и списание бонусных баллов".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьБонусныеПрограммыЛояльности";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                                   КАК Ссылка,
	|	ДанныеДокумента.Дата                                     КАК Период,
	|	ДанныеДокумента.БонуснаяПрограммаЛояльности              КАК БонуснаяПрограммаЛояльности,
	|	ДанныеДокумента.ПериодДействия                           КАК ПериодДействия,
	|	ДанныеДокумента.КоличествоПериодовДействия               КАК КоличествоПериодовДействия,
	|	ДанныеДокумента.ПериодОтсрочкиНачалаДействия             КАК ПериодОтсрочкиНачалаДействия,
	|	ДанныеДокумента.КоличествоПериодовОтсрочкиНачалаДействия КАК КоличествоПериодовОтсрочкиНачалаДействия,
	|	ДанныеДокумента.ДатаОкончанияСрокаДействия               КАК ДатаОкончанияСрокаДействия
	|ИЗ
	|	Документ.НачислениеИСписаниеБонусныхБаллов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Ссылка",                                   Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("Период",                                   Реквизиты.Период);
	Запрос.УстановитьПараметр("БонуснаяПрограммаЛояльности",              Реквизиты.БонуснаяПрограммаЛояльности);
	Запрос.УстановитьПараметр("ПериодДействия",                           Реквизиты.ПериодДействия);
	Запрос.УстановитьПараметр("КоличествоПериодовДействия",               Реквизиты.КоличествоПериодовДействия);
	Запрос.УстановитьПараметр("ПериодОтсрочкиНачалаДействия",             Реквизиты.ПериодОтсрочкиНачалаДействия);
	Запрос.УстановитьПараметр("КоличествоПериодовОтсрочкиНачалаДействия", Реквизиты.КоличествоПериодовОтсрочкиНачалаДействия);
	Запрос.УстановитьПараметр("ДатаОкончанияСрокаДействия",               Реквизиты.ДатаОкончанияСрокаДействия);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаБонусныеБаллы(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаБонусныеБаллы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "БонусныеБаллы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтБонусныеБаллы", ТекстыЗапроса) Тогда
		ТекстЗапросаВтБонусныеБаллы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	БонусныеБаллы.Период                      КАК Период,
	|	БонусныеБаллы.ВидДвижения                 КАК ВидДвижения,
	|	БонусныеБаллы.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|	БонусныеБаллы.Партнер                     КАК Партнер,
	|	СУММА(БонусныеБаллы.Начислено)            КАК Начислено,
	|	СУММА(БонусныеБаллы.КСписанию)            КАК КСписанию
	|ИЗ
	|	ВтБонусныеБаллы КАК БонусныеБаллы
	|СГРУППИРОВАТЬ ПО
	|	БонусныеБаллы.БонуснаяПрограммаЛояльности,
	|	БонусныеБаллы.Партнер,
	|	БонусныеБаллы.Период,
	|	БонусныеБаллы.ВидДвижения";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтБонусныеБаллы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтБонусныеБаллы";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НачалоПериода(ВЫБОР
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|		ИНАЧЕ &Период
	|	КОНЕЦ, ДЕНЬ)                                      КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)            КАК ВидДвижения,
	|	&БонуснаяПрограммаЛояльности                      КАК БонуснаяПрограммаЛояльности,
	|	ТабличнаяЧасть.Партнер                            КАК Партнер,
	|	ТабличнаяЧасть.Баллы                              КАК Начислено,
	|	0                                                 КАК КСписанию
	|ПОМЕСТИТЬ ВтБонусныеБаллы
	|ИЗ
	|	Документ.НачислениеИСписаниеБонусныхБаллов.Начисление КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НачалоПериода(ВЫБОР КОГДА &ДатаОкончанияСрокаДействия = ДатаВремя(1,1,1) ТОГДА 
	|		ВЫБОР
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ДЕНЬ, &КоличествоПериодовДействия)
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, НЕДЕЛЯ, &КоличествоПериодовДействия)
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, МЕСЯЦ, &КоличествоПериодовДействия)
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, КВАРТАЛ, &КоличествоПериодовДействия)
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ГОД, &КоличествоПериодовДействия)
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ДЕКАДА, &КоличествоПериодовДействия)
	|			КОГДА &ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|				ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ПОЛУГОДИЕ, &КоличествоПериодовДействия)
	|			ИНАЧЕ &Период
	|		КОНЕЦ
	|	ИНАЧЕ
	|		&ДатаОкончанияСрокаДействия
	|	КОНЕЦ, ДЕНЬ) КАК Период,
	|	ТабличнаяЧасть.ВидДвижения                        КАК ВидДвижения,
	|	ТабличнаяЧасть.БонуснаяПрограммаЛояльности        КАК БонуснаяПрограммаЛояльности,
	|	ТабличнаяЧасть.Партнер                            КАК Партнер,
	|	ТабличнаяЧасть.Начислено                          КАК Начислено,
	|	ТабличнаяЧасть.КСписанию                          КАК КСписанию
	|ИЗ (
	|	ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			КОГДА &ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, &КоличествоПериодовОтсрочкиНачалаДействия)
	|			ИНАЧЕ &Период
	|		КОНЕЦ                                             КАК Период,
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)            КАК ВидДвижения,
	|		&БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|		ТабличнаяЧасть.Партнер                            КАК Партнер,
	|		0                                                 КАК Начислено,
	|		ТабличнаяЧасть.Баллы                              КАК КСписанию
	|ИЗ
	|	Документ.НачислениеИСписаниеБонусныхБаллов.Начисление КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И (&КоличествоПериодовДействия > 0 ИЛИ &ДатаОкончанияСрокаДействия <> ДатаВремя(1,1,1))) КАК ТабличнаяЧасть
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НачалоПериода(&Период, ДЕНЬ)                      КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)            КАК ВидДвижения,
	|	&БонуснаяПрограммаЛояльности                      КАК БонуснаяПрограммаЛояльности,
	|	ТабличнаяЧасть.Партнер                            КАК Партнер,
	|	ТабличнаяЧасть.Баллы                              КАК Начислено,
	|	ТабличнаяЧасть.Баллы                              КАК КСписанию
	|ИЗ
	|	Документ.НачислениеИСписаниеБонусныхБаллов.Списание КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли