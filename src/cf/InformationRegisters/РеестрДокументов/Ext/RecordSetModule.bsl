#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗагрузитьСОбработкой(ТаблицаРеестрДокументов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаРеестрДокументов.ТипСсылки,
	|	ТаблицаРеестрДокументов.Организация,
	|	ТаблицаРеестрДокументов.ХозяйственнаяОперация,
	|	ТаблицаРеестрДокументов.Партнер,
	|	ТаблицаРеестрДокументов.Контрагент,
	|	ТаблицаРеестрДокументов.НаправлениеДеятельности,
	|	ТаблицаРеестрДокументов.ДополнительнаяЗапись,
	|	ТаблицаРеестрДокументов.Подразделение,
	|	ТаблицаРеестрДокументов.МестоХранения,
	|	ТаблицаРеестрДокументов.ДатаДокументаИБ,
	|	ТаблицаРеестрДокументов.Ссылка,
	|	ТаблицаРеестрДокументов.РазделительЗаписи,
	|	ТаблицаРеестрДокументов.НомерДокументаИБ,
	|	ТаблицаРеестрДокументов.Статус,
	|	ТаблицаРеестрДокументов.Ответственный,
	|	ТаблицаРеестрДокументов.Дополнительно,
	|	ТаблицаРеестрДокументов.Комментарий,
	|	ТаблицаРеестрДокументов.Проведен,
	|	ТаблицаРеестрДокументов.ПометкаУдаления,
	|	ТаблицаРеестрДокументов.ДатаПервичногоДокумента,
	|	ТаблицаРеестрДокументов.НомерПервичногоДокумента,
	|	ТаблицаРеестрДокументов.Сумма,
	|	ТаблицаРеестрДокументов.Валюта,
	|	ТаблицаРеестрДокументов.ДатаОтраженияВУчете,
	|	ТаблицаРеестрДокументов.Договор
	|ПОМЕСТИТЬ ТаблицаРеестрДокументов
	|ИЗ
	|	&ТаблицаРеестрДокументов КАК ТаблицаРеестрДокументов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеестрДокументов.ТипСсылки,
	|	ТаблицаРеестрДокументов.Организация,
	|	ТаблицаРеестрДокументов.ХозяйственнаяОперация,
	|	ТаблицаРеестрДокументов.Партнер,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТаблицаРеестрДокументов.Контрагент) = ТИП(Справочник.КлючиРеестраДокументов)
	|			ТОГДА ТаблицаРеестрДокументов.Контрагент
	|		ИНАЧЕ ЕСТЬNULL(КлючиРеестраДокументовКонтрагент.Ссылка, ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка))
	|	КОНЕЦ КАК Контрагент,
	|	ТаблицаРеестрДокументов.НаправлениеДеятельности,
	|	ТаблицаРеестрДокументов.ДополнительнаяЗапись,
	|	ТаблицаРеестрДокументов.Подразделение,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТаблицаРеестрДокументов.МестоХранения) = ТИП(Справочник.КлючиРеестраДокументов)
	|			ТОГДА ТаблицаРеестрДокументов.МестоХранения
	|		ИНАЧЕ ЕСТЬNULL(КлючиРеестраДокументов.Ссылка, ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка))
	|	КОНЕЦ КАК МестоХранения,
	|	ТаблицаРеестрДокументов.ДатаДокументаИБ,
	|	ТаблицаРеестрДокументов.Ссылка,
	|	ТаблицаРеестрДокументов.РазделительЗаписи,
	|	ТаблицаРеестрДокументов.НомерДокументаИБ,
	|	ТаблицаРеестрДокументов.Статус,
	|	ТаблицаРеестрДокументов.Ответственный,
	|	ТаблицаРеестрДокументов.Дополнительно,
	|	ТаблицаРеестрДокументов.Комментарий,
	|	ТаблицаРеестрДокументов.Проведен,
	|	ТаблицаРеестрДокументов.ПометкаУдаления,
	|	ТаблицаРеестрДокументов.ДатаПервичногоДокумента,
	|	ТаблицаРеестрДокументов.НомерПервичногоДокумента,
	|	ТаблицаРеестрДокументов.Сумма,
	|	ТаблицаРеестрДокументов.Валюта,
	|	ТаблицаРеестрДокументов.ДатаОтраженияВУчете,
	|	ТаблицаРеестрДокументов.Договор
	|ИЗ
	|	ТаблицаРеестрДокументов КАК ТаблицаРеестрДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|		ПО ТаблицаРеестрДокументов.МестоХранения = КлючиРеестраДокументов.Ключ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументовКонтрагент
	|		ПО ТаблицаРеестрДокументов.Контрагент = КлючиРеестраДокументовКонтрагент.Ключ
	|";
	
	Для каждого Измерение Из Метаданные.РегистрыСведений.РеестрДокументов.Измерения Цикл
		
		Колонка = ТаблицаРеестрДокументов.Колонки.Найти(Измерение.Имя);
		
		Если Колонка <> Неопределено Тогда
			Если Колонка.ТипЗначения = Новый ОписаниеТипов("Неопределено")
				Или Колонка.ТипЗначения = Новый ОписаниеТипов("Null") Тогда
				ТаблицаРеестрДокументов.Колонки.Удалить(Колонка);
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ТаблицаРеестрДокументов.Колонки.Добавить(Измерение.Имя, Измерение.Тип);
		
	КонецЦикла;
	
	Для каждого Ресурс Из Метаданные.РегистрыСведений.РеестрДокументов.Ресурсы Цикл
		
		Колонка = ТаблицаРеестрДокументов.Колонки.Найти(Ресурс.Имя);
		
		Если Колонка <> Неопределено Тогда
			Если Колонка.ТипЗначения = Новый ОписаниеТипов("Неопределено")
				Или Колонка.ТипЗначения = Новый ОписаниеТипов("Null") Тогда
				ТаблицаРеестрДокументов.Колонки.Удалить(Колонка);
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ТаблицаРеестрДокументов.Колонки.Добавить(Ресурс.Имя, Ресурс.Тип);
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаРеестрДокументов", ТаблицаРеестрДокументов);
	
	ЭтотОбъект.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
