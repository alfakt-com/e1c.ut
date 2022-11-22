﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыКОтгрузкеПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ЗаказКлиента   КАК ЗаказКлиента,
	|	Таблица.Номенклатура   КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Серия          КАК Серия,
	|	Таблица.КодСтроки      КАК КодСтроки,
	|	Таблица.Склад          КАК Склад,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.КОформлению
	|		ИНАЧЕ
	|			-Таблица.КОформлению
	|	КОНЕЦ                  КАК КОформлениюПередЗаписью
	|ПОМЕСТИТЬ ДвиженияЗаказыКлиентовПередЗаписью
	|ИЗ
	|	РегистрНакопления.ЗаказыКлиентов КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|";
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров =
		ПолучитьФункциональнуюОпцию("ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.ЗаказКлиента                КАК ЗаказКлиента,
	|	ТаблицаИзменений.Номенклатура                КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика              КАК Характеристика,
	|	ТаблицаИзменений.Серия                       КАК Серия,
	|	ТаблицаИзменений.КодСтроки                   КАК КодСтроки,
	|	ТаблицаИзменений.Склад                       КАК Склад,
	|	СУММА(ТаблицаИзменений.КОформлениюИзменение) КАК КОформлениюИзменение
	|ПОМЕСТИТЬ ДвиженияЗаказыКлиентовИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаказКлиента            КАК ЗаказКлиента,
	|		Таблица.Номенклатура            КАК Номенклатура,
	|		Таблица.Характеристика          КАК Характеристика,
	|		Таблица.Серия                   КАК Серия,
	|		Таблица.КодСтроки               КАК КодСтроки,
	|		Таблица.Склад                   КАК Склад,
	|		Таблица.КОформлениюПередЗаписью КАК КОформлениюИзменение
	|	ИЗ
	|		ДвиженияЗаказыКлиентовПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаказКлиента           КАК ЗаказКлиента,
	|		Таблица.Номенклатура           КАК Номенклатура,
	|		Таблица.Характеристика         КАК Характеристика,
	|		Таблица.Серия                  КАК Серия,
	|		Таблица.КодСтроки              КАК КодСтроки,
	|		Таблица.Склад                  КАК Склад,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.КОформлению
	|			ИНАЧЕ
	|				Таблица.КОформлению
	|		КОНЕЦ                          КАК КОформлениюИзменение
	|	ИЗ
	|		РегистрНакопления.ЗаказыКлиентов КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаказКлиента,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.КодСтроки,
	|	ТаблицаИзменений.Склад
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КОформлениюИзменение) <> 0
	|;
	|УНИЧТОЖИТЬ ДвиженияЗаказыКлиентовПередЗаписью
	|";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияТоварыКОтгрузкеИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыКлиентовИзменение", Выборка.Количество > 0);

	Если ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров Тогда
		
		Регистратор = Отбор.Регистратор.Значение;
		
		СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
		
		Если СтруктураВременныеТаблицы.ДвиженияЗаказыКлиентовИзменение Тогда
		
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров",
				Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить());
			Запрос.УстановитьПараметр("МерныеТипыЕдиницИзмерений",
				Справочники.УпаковкиЕдиницыИзмерения.МерныеТипыЕдиницИзмерений());
			Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
			
			ТекстЗапроса = "
			|ВЫБРАТЬ
			|	Таблица.ЗаказКлиента,
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Серия,
			|	Таблица.Склад
			|ПОМЕСТИТЬ ДвиженияЗаказыКлиентовИзменениеМерныеТовары
			|ИЗ
			|	ДвиженияЗаказыКлиентовИзменение КАК Таблица
			|ГДЕ 
			|	Таблица.Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины В (&МерныеТипыЕдиницИзмерений)
			|СГРУППИРОВАТЬ ПО
			|	Таблица.ЗаказКлиента,
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Серия,
			|	Таблица.Склад
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			// Основная таблица
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	ЗаказыКлиентов.ВидДвижения    КАК ВидДвижения,
			|	ЗаказыКлиентов.ЗаказКлиента   КАК ЗаказКлиента,
			|	ЗаказыКлиентов.Номенклатура   КАК Номенклатура,
			|	ЗаказыКлиентов.Характеристика КАК Характеристика,
			|	ЗаказыКлиентов.Склад          КАК Склад,
			|	ЗаказыКлиентов.Серия          КАК Серия,
			|	ЗаказыКлиентов.КОформлению    КАК КОформлению
			|ПОМЕСТИТЬ ВТЗаказыКлиентов
			|ИЗ
			|	РегистрНакопления.ЗаказыКлиентов КАК ЗаказыКлиентов
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ДвиженияЗаказыКлиентовИзменение КАК Изменения
			|		ПО ЗаказыКлиентов.ЗаказКлиента      = Изменения.ЗаказКлиента
			|			И ЗаказыКлиентов.Номенклатура   = Изменения.Номенклатура
			|			И ЗаказыКлиентов.Характеристика = Изменения.Характеристика
			|			И ЗаказыКлиентов.Склад          = Изменения.Склад
			|			И ЗаказыКлиентов.Серия          = Изменения.Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			// Допустимые отклонения
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	ЗаказыКлиентов.ЗаказКлиента   КАК ЗаказКлиента,
			|	ЗаказыКлиентов.Номенклатура   КАК Номенклатура,
			|	ЗаказыКлиентов.Характеристика КАК Характеристика,
			|	ЗаказыКлиентов.Склад          КАК Склад,
			|	ЗаказыКлиентов.Серия          КАК Серия,
			|	СУММА(ЗаказыКлиентов.КОформлению
			|		* (&ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров / 100)) КАК ДопустимоеОтклонение
			|ПОМЕСТИТЬ ВТДопустимыеОтклоненияЗаказыКлиентов
			|ИЗ
			|	ВТЗаказыКлиентов КАК ЗаказыКлиентов
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДвиженияЗаказыКлиентовИзменениеМерныеТовары КАК Изменения
			|		ПО ЗаказыКлиентов.ЗаказКлиента      = Изменения.ЗаказКлиента
			|			И ЗаказыКлиентов.Номенклатура   = Изменения.Номенклатура
			|			И ЗаказыКлиентов.Характеристика = Изменения.Характеристика
			|			И ЗаказыКлиентов.Склад          = Изменения.Склад
			|			И ЗаказыКлиентов.Серия          = Изменения.Серия
			|ГДЕ
			|	ЗаказыКлиентов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|СГРУППИРОВАТЬ ПО
			|	ЗаказыКлиентов.ЗаказКлиента,
			|	ЗаказыКлиентов.Номенклатура,
			|	ЗаказыКлиентов.Характеристика,
			|	ЗаказыКлиентов.Склад,
			|	ЗаказыКлиентов.Серия
			|ИНДЕКСИРОВАТЬ ПО
			|	ЗаказКлиента,
			|	Номенклатура,
			|	Характеристика,
			|	Склад,
			|	Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			//Остатки
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	ЗаказыКлиентов.ЗаказКлиента       КАК ЗаказКлиента,
			|	ЗаказыКлиентов.Номенклатура       КАК Номенклатура,
			|	ЗаказыКлиентов.Характеристика     КАК Характеристика,
			|	ЗаказыКлиентов.Склад              КАК Склад,
			|	ЗаказыКлиентов.Серия              КАК Серия,
			|	СУММА(ВЫБОР КОГДА ЗаказыКлиентов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
			|			ЗаказыКлиентов.КОформлению
			|		ИНАЧЕ
			|			-ЗаказыКлиентов.КОформлению
			|	КОНЕЦ)                            КАК КОформлениюОстаток
			|ПОМЕСТИТЬ ВТЗаказыКлиентовОстатки
			|ИЗ
			|	ВТЗаказыКлиентов КАК ЗаказыКлиентов
			|СГРУППИРОВАТЬ ПО
			|	ЗаказыКлиентов.ЗаказКлиента,
			|	ЗаказыКлиентов.Номенклатура,
			|	ЗаказыКлиентов.Характеристика,
			|	ЗаказыКлиентов.Склад,
			|	ЗаказыКлиентов.Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЗаказыОстатки.ЗаказКлиента КАК ЗаказКлиента
			|ИЗ
			|	ВТЗаказыКлиентовОстатки КАК ЗаказыОстатки
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ВТДопустимыеОтклоненияЗаказыКлиентов КАК ДопустимыеОтклонения
			|		ПО
			|			ЗаказыОстатки.ЗаказКлиента     = ДопустимыеОтклонения.ЗаказКлиента
			|			И ЗаказыОстатки.Номенклатура   = ДопустимыеОтклонения.Номенклатура
			|			И ЗаказыОстатки.Характеристика = ДопустимыеОтклонения.Характеристика
			|			И ЗаказыОстатки.Склад          = ДопустимыеОтклонения.Склад
			|			И ЗаказыОстатки.Серия          = ДопустимыеОтклонения.Серия
			|ГДЕ
			|	ЗаказыОстатки.КОформлениюОстаток <= ДопустимыеОтклонения.ДопустимоеОтклонение
			|	И ЗаказыОстатки.КОформлениюОстаток >= -ДопустимыеОтклонения.ДопустимоеОтклонение
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			Запрос.Текст = ТекстЗапроса;
			
			ВыборкаЗаказ = Запрос.Выполнить().Выбрать();
			
			Пока ВыборкаЗаказ.Следующий() Цикл
				
				РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.ДобавитьЗаказВОчередь(ВыборкаЗаказ.ЗаказКлиента);
				
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли