#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДССостояниеРеализации0.ДокументРеализации КАК ДокументРеализации,
	|	НДССостояниеРеализации0.Организация КАК Организация,
	|	НДССостояниеРеализации0.Контрагент КАК Контрагент,
	|	НДССостояниеРеализации0.ДатаПодтверждения КАК ДатаПодтверждения,
	|	НДССостояниеРеализации0.ДатаРеализации КАК ДатаРеализации,
	|	НДССостояниеРеализации0.НомерОтметкиНалоговогоОргана КАК НомерОтметкиНалоговогоОргана,
	|	НДССостояниеРеализации0.ДатаОтметкиНалоговогоОргана КАК ДатаОтметкиНалоговогоОргана,
	|	НДССостояниеРеализации0.Состояние КАК Состояние
	|ПОМЕСТИТЬ НДССостояниеРеализации0ПередЗаписью
	|ИЗ
	|	РегистрСведений.НДССостояниеРеализации0 КАК НДССостояниеРеализации0
	|ГДЕ
	|	НДССостояниеРеализации0.Регистратор = &Регистратор
	|";
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	Если НЕ ДополнительныеСвойства.Свойство("УказанаОтметкаНалоговогоОрганаВЗаявлении") Тогда
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НДССостояниеРеализации0.Организация,
		|	НДССостояниеРеализации0.ДокументРеализации,
		|	НДССостояниеРеализации0.ДатаРеализации,
		|	НДССостояниеРеализации0.Контрагент,
		|	НДССостояниеРеализации0.НомерОтметкиНалоговогоОргана,
		|	НДССостояниеРеализации0.ДатаОтметкиНалоговогоОргана
		|ИЗ
		|	НДССостояниеРеализации0ПередЗаписью КАК НДССостояниеРеализации0";
		
		Выборка = Запрос.Выполнить().Выбрать();
		ПоляПоиска = "Организация,ДокументРеализации,ДатаРеализации,Контрагент";
		Для Каждого ЗаписьНабора Из ЭтотОбъект Цикл
			Если НЕ ПустаяСтрока(ЗаписьНабора.НомерОтметкиНалоговогоОргана) ИЛИ ЗначениеЗаполнено(ЗаписьНабора.ДатаОтметкиНалоговогоОргана) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура(ПоляПоиска);
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ЗаписьНабора);
			Если Выборка.НайтиСледующий(СтруктураПоиска) Тогда
				ЗаписьНабора.НомерОтметкиНалоговогоОргана = Выборка.НомерОтметкиНалоговогоОргана;
				ЗаписьНабора.ДатаОтметкиНалоговогоОргана  = Выборка.ДатаОтметкиНалоговогоОргана;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ДатаПодтверждения    КАК ДатаПодтверждения,
	|	Таблица.ДокументРеализации   КАК ДокументРеализации,
	|	Таблица.Организация          КАК Организация
	|ПОМЕСТИТЬ ВтИзменения
	|ИЗ
	|	(ВЫБРАТЬ
	|		НДССостояниеРеализации0.ДокументРеализации КАК ДокументРеализации,
	|		НДССостояниеРеализации0.ДатаПодтверждения КАК ДатаПодтверждения,
	|		НДССостояниеРеализации0.Организация КАК Организация,
	|		ВЫБОР
	|			КОГДА НДССостояниеРеализации0.Состояние = ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ОжидаетсяПодтверждение)
	|				ТОГДА 1
	|			КОГДА НДССостояниеРеализации0.Состояние = ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0)
	|				ТОГДА 2
	|			КОГДА НДССостояниеРеализации0.Состояние = ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.НеПодтвержденаРеализация0)
	|				ТОГДА 3
	|		КОНЕЦ КАК Состояние
	|	ИЗ
	|		НДССостояниеРеализации0ПередЗаписью КАК НДССостояниеРеализации0
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НДССостояниеРеализации0.ДокументРеализации КАК ДокументРеализации,
	|		НДССостояниеРеализации0.ДатаПодтверждения КАК ДатаПодтверждения,
	|		НДССостояниеРеализации0.Организация КАК Организация,
	|		-(ВЫБОР
	|			КОГДА НДССостояниеРеализации0.Состояние = ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ОжидаетсяПодтверждение)
	|				ТОГДА 1
	|			КОГДА НДССостояниеРеализации0.Состояние = ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0)
	|				ТОГДА 2
	|			КОГДА НДССостояниеРеализации0.Состояние = ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.НеПодтвержденаРеализация0)
	|				ТОГДА 3
	|		КОНЕЦ) КАК Состояние
	|	ИЗ
	|		РегистрСведений.НДССостояниеРеализации0 КАК НДССостояниеРеализации0
	|	ГДЕ
	|		НДССостояниеРеализации0.Регистратор = &Регистратор) Таблица
	|ГДЕ
	|	Таблица.ДатаПодтверждения <> ДАТАВРЕМЯ(1,1,1)
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ДатаПодтверждения,
	|	Таблица.ДокументРеализации,
	|	Таблица.Организация
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Состояние) <> 0
	|;
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(Таблица.ДатаПодтверждения, КВАРТАЛ), МЕСЯЦ) КАК Месяц,
	|	Таблица.ДокументРеализации                                             КАК Документ,
	|	Таблица.Организация                                                    КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС)         КАК Операция
	|ПОМЕСТИТЬ НДССостояниеРеализации0ЗаданияКЗакрытиюМесяца
	|ИЗ
	|	ВтИзменения КАК Таблица
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.ДатаПодтверждения, МЕСЯЦ) КАК Месяц,
	|	Таблица.Организация                             КАК Организация,
	|	НДСПредъявленный.СчетФактура                    КАК СчетФактура
	|ИЗ
	|	ВтИзменения КАК Таблица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.НДСПредъявленный КАК НДСПредъявленный
	|	ПО
	|		Таблица.Организация = НДСПредъявленный.Организация
	|		И Таблица.ДокументРеализации = НДСПредъявленный.РеализацияЭкспорт
	|";
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[2].Выбрать();
	РегистрыСведений.ЗаданияКФормированиюЗаписейКнигиПокупокПродаж.СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
