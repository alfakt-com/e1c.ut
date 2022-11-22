﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
	|	Таблица.Номенклатура       КАК Номенклатура,
	|	Таблица.Характеристика     КАК Характеристика,
	|	Таблица.Серия              КАК Серия,
	|	Таблица.КодСтроки          КАК КодСтроки,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.КОформлению
	|		ИНАЧЕ
	|			-Таблица.КОформлению
	|	КОНЕЦ                      КАК КОформлениюПередЗаписью
	|ПОМЕСТИТЬ ДвиженияЗаказыНаПеремещениеПередЗаписью
	|ИЗ
	|	РегистрНакопления.ЗаказыНаПеремещение КАК Таблица
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
	|	ТаблицаИзменений.ЗаказНаПеремещение          КАК ЗаказНаПеремещение,
	|	ТаблицаИзменений.Номенклатура                КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика              КАК Характеристика,
	|	ТаблицаИзменений.Серия                       КАК Серия,
	|	ТаблицаИзменений.КодСтроки                   КАК КодСтроки,
	|	СУММА(ТаблицаИзменений.КОформлениюИзменение) КАК КОформлениюИзменение
	|ПОМЕСТИТЬ ДвиженияЗаказыНаПеремещениеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаказНаПеремещение  КАК ЗаказНаПеремещение,
	|		Таблица.Номенклатура        КАК Номенклатура,
	|		Таблица.Характеристика      КАК Характеристика,
	|		Таблица.Серия               КАК Серия,
	|		Таблица.КодСтроки           КАК КодСтроки,
	|		Таблица.КОформлениюПередЗаписью КАК КОформлениюИзменение
	|	ИЗ
	|		ДвиженияЗаказыНаПеремещениеПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
	|		Таблица.Номенклатура       КАК Номенклатура,
	|		Таблица.Характеристика     КАК Характеристика,
	|		Таблица.Серия               КАК Серия,
	|		Таблица.КодСтроки          КАК КодСтроки,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.КОформлению
	|			ИНАЧЕ
	|				Таблица.КОформлению
	|		КОНЕЦ                      КАК КОформлениюИзменение
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаПеремещение КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаказНаПеремещение,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.КодСтроки
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КОформлениюИзменение) <> 0
	|;
	|УНИЧТОЖИТЬ ДвиженияЗаказыНаПеремещениеПередЗаписью
	|";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу.
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыНаПеремещениеИзменение", Выборка.Количество > 0);

	Если ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров Тогда
		
		Регистратор = Отбор.Регистратор.Значение;
		
		СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
		
		Если СтруктураВременныеТаблицы.ДвиженияЗаказыНаПеремещениеИзменение Тогда
		
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров",
				Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить());
			Запрос.УстановитьПараметр("МерныеТипыЕдиницИзмерений",
				Справочники.УпаковкиЕдиницыИзмерения.МерныеТипыЕдиницИзмерений());
			Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
			
			ТекстЗапроса = "
			|ВЫБРАТЬ
			|	Таблица.ЗаказНаПеремещение,
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Серия
			|ПОМЕСТИТЬ ДвиженияЗаказыНаПеремещениеИзменениеМерныеТовары
			|ИЗ
			|	ДвиженияЗаказыНаПеремещениеИзменение КАК Таблица
			|ГДЕ 
			|	Таблица.Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины В (&МерныеТипыЕдиницИзмерений)
			|СГРУППИРОВАТЬ ПО
			|	Таблица.ЗаказНаПеремещение,
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			// Основная таблица
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	ЗаказыНаПеремещение.ВидДвижения        КАК ВидДвижения,
			|	ЗаказыНаПеремещение.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
			|	ЗаказыНаПеремещение.Номенклатура       КАК Номенклатура,
			|	ЗаказыНаПеремещение.Характеристика     КАК Характеристика,
			|	ЗаказыНаПеремещение.Серия              КАК Серия,
			|	ЗаказыНаПеремещение.КОформлению        КАК КОформлению
			|ПОМЕСТИТЬ ВТЗаказыНаПеремещение
			|ИЗ
			|	РегистрНакопления.ЗаказыНаПеремещение КАК ЗаказыНаПеремещение
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ДвиженияЗаказыНаПеремещениеИзменение КАК Изменения
			|		ПО ЗаказыНаПеремещение.ЗаказНаПеремещение = Изменения.ЗаказНаПеремещение
			|			И ЗаказыНаПеремещение.Номенклатура    = Изменения.Номенклатура
			|			И ЗаказыНаПеремещение.Характеристика  = Изменения.Характеристика
			|			И ЗаказыНаПеремещение.Серия           = Изменения.Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			// Допустимые отклонения
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	ЗаказыНаПеремещение.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
			|	ЗаказыНаПеремещение.Номенклатура       КАК Номенклатура,
			|	ЗаказыНаПеремещение.Характеристика     КАК Характеристика,
			|	ЗаказыНаПеремещение.Серия              КАК Серия,
			|	СУММА(ЗаказыНаПеремещение.КОформлению
			|		* (&ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров / 100)) КАК ДопустимоеОтклонение
			|ПОМЕСТИТЬ ВТДопустимыеОтклоненияЗаказыНаПеремещение
			|ИЗ
			|	ВТЗаказыНаПеремещение КАК ЗаказыНаПеремещение
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ДвиженияЗаказыНаПеремещениеИзменениеМерныеТовары КАК Изменения
			|		ПО ЗаказыНаПеремещение.ЗаказНаПеремещение = Изменения.ЗаказНаПеремещение
			|			И ЗаказыНаПеремещение.Номенклатура    = Изменения.Номенклатура
			|			И ЗаказыНаПеремещение.Характеристика  = Изменения.Характеристика
			|			И ЗаказыНаПеремещение.Серия           = Изменения.Серия
			|ГДЕ
			|	ЗаказыНаПеремещение.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|СГРУППИРОВАТЬ ПО
			|	ЗаказыНаПеремещение.ЗаказНаПеремещение,
			|	ЗаказыНаПеремещение.Номенклатура,
			|	ЗаказыНаПеремещение.Характеристика,
			|	ЗаказыНаПеремещение.Серия
			|ИНДЕКСИРОВАТЬ ПО
			|	ЗаказНаПеремещение,
			|	Номенклатура,
			|	Характеристика,
			|	Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			//Остатки
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	ЗаказыНаПеремещение.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
			|	ЗаказыНаПеремещение.Номенклатура       КАК Номенклатура,
			|	ЗаказыНаПеремещение.Характеристика     КАК Характеристика,
			|	ЗаказыНаПеремещение.Серия              КАК Серия,
			|	СУММА(ВЫБОР КОГДА ЗаказыНаПеремещение.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
			|			ЗаказыНаПеремещение.КОформлению
			|		ИНАЧЕ
			|			-ЗаказыНаПеремещение.КОформлению
			|	КОНЕЦ)                                 КАК КОформлениюОстаток
			|ПОМЕСТИТЬ ВТЗаказыНаПеремещениеОстатки
			|ИЗ
			|	ВТЗаказыНаПеремещение КАК ЗаказыНаПеремещение
			|СГРУППИРОВАТЬ ПО
			|	ЗаказыНаПеремещение.ЗаказНаПеремещение,
			|	ЗаказыНаПеремещение.Номенклатура,
			|	ЗаказыНаПеремещение.Характеристика,
			|	ЗаказыНаПеремещение.Серия
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЗаказыОстатки.ЗаказНаПеремещение КАК ЗаказНаПеремещение
			|ИЗ
			|	ВТЗаказыНаПеремещениеОстатки КАК ЗаказыОстатки
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ВТДопустимыеОтклоненияЗаказыНаПеремещение КАК ДопустимыеОтклонения
			|		ПО
			|			ЗаказыОстатки.ЗаказНаПеремещение = ДопустимыеОтклонения.ЗаказНаПеремещение
			|			И ЗаказыОстатки.Номенклатура     = ДопустимыеОтклонения.Номенклатура
			|			И ЗаказыОстатки.Характеристика   = ДопустимыеОтклонения.Характеристика
			|			И ЗаказыОстатки.Серия            = ДопустимыеОтклонения.Серия
			|ГДЕ
			|	ЗаказыОстатки.КОформлениюОстаток <= ДопустимыеОтклонения.ДопустимоеОтклонение
			|	И ЗаказыОстатки.КОформлениюОстаток >= -ДопустимыеОтклонения.ДопустимоеОтклонение
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|";
			
			Запрос.Текст = ТекстЗапроса;
			
			ВыборкаЗаказ = Запрос.Выполнить().Выбрать();
			
			Пока ВыборкаЗаказ.Следующий() Цикл
				
				РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.ДобавитьЗаказВОчередь(
					ВыборкаЗаказ.ЗаказНаПеремещение);
				
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли