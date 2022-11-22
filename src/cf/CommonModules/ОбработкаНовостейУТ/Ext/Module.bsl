﻿
#Область СлужебныеПроцедурыИФункции

// Обработчик обновления конфигурации с подсистемой ИнтернетПоддержкаПользователей.Новости.
//
Процедура ЗаполнитьОтборыНовостей() Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостями") Тогда
		Возврат;
	КонецЕсли;

	// В модели сервиса обновление должно происходить в каждой области данных отдельно
	// Поэтому, если пытаемся запустить процедуру из неразделённого сеанса, то завершить работу процедуры.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Если РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
			// Запись в журнал регистрации
			ТекстСообщения = НСтр("ru='Вызов ОбработкаНовостейУТ.ЗаполнитьОтборыНовостей() в модели сервиса в неразделённом сеансе не поддерживается.'");
			// Запись в журнал регистрации
			ЗаписьЖурналаРегистрации(
				НСтр("ru='Новости.Переопределяемый.Обновление ИБ.ЗаполнитьОтборыНовостей'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), // ИмяСобытия
				УровеньЖурналаРегистрации.Ошибка, // УровеньЖурналаРегистрации.*
				, // ОбъектМетаданных
				, // Данные
				ТекстСообщения, // Комментарий
				РежимТранзакцииЗаписиЖурналаРегистрации.Независимая // РежимТранзакцииЗаписиЖурналаРегистрации.*
			);
			Возврат; // пока не поддерживается
		КонецЕсли;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);

	// Права на чтение ленты "Что нового в версии" - по доступным пользователю разделам ГКИ.
	ОтборПоЛентеНовостей = Справочники.ЛентыНовостей.НайтиПоКоду("WhatIsNew");
	ОтборПоКатегорииНовостей = ПланыВидовХарактеристик.КатегорииНовостей.НайтиПоКоду("SectionPanel");

	Если НЕ ЗначениеЗаполнено(ОтборПоЛентеНовостей)
	 ИЛИ НЕ ЗначениеЗаполнено(ОтборПоКатегорииНовостей) Тогда
		Возврат;
	КонецЕсли;

	// Подготовим таблицу соответствий разделов ГКИ и ролей для доступа к ним
	ТаблицаПодсистем = ТаблицаПодсистемИРолейДляПросмотра(Ложь);

	// Получим данные о доступности пользователям разделов ГКИ
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Т",                        ТаблицаПодсистем);
	Запрос.УстановитьПараметр("ОтборПоЛентеНовостей",     ОтборПоЛентеНовостей);
	Запрос.УстановитьПараметр("ОтборПоКатегорииНовостей", ОтборПоКатегорииНовостей);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Т.Подсистема КАК СТРОКА(100)) КАК Подсистема,
	|	ВЫРАЗИТЬ(Т.Роль КАК Справочник.ИдентификаторыОбъектовМетаданных) КАК Роль
	|ПОМЕСТИТЬ ВТТаблицаПодсистем
	|ИЗ
	|	&Т КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиГруппДоступаРоли.Ссылка КАК Профиль,
	|	ПрофилиГруппДоступаРоли.Роль
	|ПОМЕСТИТЬ ВТПрофили
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаПодсистем КАК ВТТаблицаПодсистем
	|		ПО ПрофилиГруппДоступаРоли.Роль = ВТТаблицаПодсистем.Роль
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГруппыДоступаПользователи.Пользователь КАК ПользовательИлиГруппа,
	|	ВТПрофили.Роль
	|ПОМЕСТИТЬ ВТПользователиИГруппы
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПрофили КАК ВТПрофили
	|		ПО ГруппыДоступаПользователи.Ссылка.Профиль = ВТПрофили.Профиль
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГруппыПользователейСостав.Пользователь КАК Пользователь,
	|	ВТПользователиИГруппы.Роль КАК Роль
	|ПОМЕСТИТЬ ВТПользователи
	|ИЗ
	|	ВТПользователиИГруппы КАК ВТПользователиИГруппы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	|		ПО ВТПользователиИГруппы.ПользовательИлиГруппа = ГруппыПользователейСостав.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Пользователи.Ссылка,
	|	ВТПользователиИГруппы.Роль
	|ИЗ
	|	ВТПользователиИГруппы КАК ВТПользователиИГруппы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО ВТПользователиИГруппы.ПользовательИлиГруппа = Пользователи.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТПользователи.Пользователь,
	|	ВТТаблицаПодсистем.Подсистема КАК ЗначениеКатегорииНовостей
	|ПОМЕСТИТЬ ВТНовыеОтборы
	|ИЗ
	|	ВТПользователи КАК ВТПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаПодсистем КАК ВТТаблицаПодсистем
	|		ПО ВТПользователи.Роль = ВТТаблицаПодсистем.Роль
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтборыПоЛентамНовостейПользовательские.Пользователь,
	|	ОтборыПоЛентамНовостейПользовательские.ЗначениеКатегорииНовостей
	|ПОМЕСТИТЬ ВТСтарыеОтборы
	|ИЗ
	|	РегистрСведений.ОтборыПоЛентамНовостейПользовательские КАК ОтборыПоЛентамНовостейПользовательские
	|ГДЕ
	|	ОтборыПоЛентамНовостейПользовательские.ЛентаНовостей = &ОтборПоЛентеНовостей
	|	И ОтборыПоЛентамНовостейПользовательские.КатегорияНовостей = &ОтборПоКатегорииНовостей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТНовыеОтборы.Пользователь
	|ПОМЕСТИТЬ ВТПользователиДляИзменения
	|ИЗ
	|	ВТНовыеОтборы КАК ВТНовыеОтборы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтарыеОтборы КАК ВТСтарыеОтборы
	|		ПО ВТНовыеОтборы.Пользователь = ВТСтарыеОтборы.Пользователь
	|			И ВТНовыеОтборы.ЗначениеКатегорииНовостей = ВТСтарыеОтборы.ЗначениеКатегорииНовостей
	|ГДЕ
	|	ВТСтарыеОтборы.Пользователь ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТСтарыеОтборы.Пользователь
	|ИЗ
	|	ВТСтарыеОтборы КАК ВТСтарыеОтборы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНовыеОтборы КАК ВТНовыеОтборы
	|		ПО ВТСтарыеОтборы.Пользователь = ВТНовыеОтборы.Пользователь
	|			И ВТСтарыеОтборы.ЗначениеКатегорииНовостей = ВТНовыеОтборы.ЗначениеКатегорииНовостей
	|ГДЕ
	|	ВТНовыеОтборы.Пользователь ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТНовыеОтборы.Пользователь КАК Пользователь,
	|	&ОтборПоЛентеНовостей КАК ЛентаНовостей,
	|	&ОтборПоКатегорииНовостей КАК КатегорияНовостей,
	|	ВТНовыеОтборы.ЗначениеКатегорииНовостей КАК ЗначениеКатегорииНовостей,
	|	ИСТИНА КАК УстановленоПрограммно
	|ИЗ
	|	ВТНовыеОтборы КАК ВТНовыеОтборы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПользователиДляИзменения КАК ВТПользователиДляИзменения
	|		ПО ВТНовыеОтборы.Пользователь = ВТПользователиДляИзменения.Пользователь
	|			И (ВТНовыеОтборы.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователь,
	|	ЗначениеКатегорииНовостей
	|ИТОГИ ПО
	|	Пользователь";

	// Перезапишем только измененные пользовательские отборы
	ВыборкаПользователи = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПользователи.Следующий() Цикл

		НаборЗаписей = РегистрыСведений.ОтборыПоЛентамНовостейПользовательские.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Пользователь.Установить(ВыборкаПользователи.Пользователь);
		НаборЗаписей.Отбор.ЛентаНовостей.Установить(ОтборПоЛентеНовостей);
		НаборЗаписей.Отбор.КатегорияНовостей.Установить(ОтборПоКатегорииНовостей);

		Выборка = ВыборкаПользователи.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;

		НаборЗаписей.Записать(Истина);

	КонецЦикла;

	// Позовем сервисные процедуры отборов из механизма новостей

	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		// Для модели сервиса может запускаться только в неразделённом сеансе, например, фоновым заданием
		// Считаем, что "лишние" отборы в модели сервиса уже очищены.
		ОбработкаНовостей.ОптимизироватьОтборыПоНовостям();
	КонецЕсли;

	// Пересчёт пользовательских отборов может осуществляться как в модели сервиса, так и без неё,
	//  вне зависимости от того, запущен ли разделённый сеанс или в области данных.
	ОбработкаНовостей.ПересчитатьОтборыПоНовостям_Пользовательские();

КонецПроцедуры

// Заполняет отборы текущего пользователя для чтение лент новостей.
//
Процедура ЗаполнитьОтборыПользователяДляЧтенияНовостей() Экспорт

	Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Возврат; // отборы будут заполнены централизованно, см. ЗаполнитьОтборыНовостей()
	КонецЕсли;

	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	Если НЕ ЗначениеЗаполнено(ТекущийПользователь)
	 ИЛИ ТипЗнч(ТекущийПользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
	 	// Работа механизма чтения новостей пока не поддерживается для Внешних пользователей.
		Возврат;
	КонецЕсли;

	Если НЕ ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостями")
	 ИЛИ НЕ Пользователи.РолиДоступны("ЧтениеНовостей, РедактированиеНовостей",, Ложь) Тогда
		Возврат; // не требуется обновление отборов
	КонецЕсли;

	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Если НЕ РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
			Возврат; // пока не поддерживается
		КонецЕсли;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);

	// Права на чтение ленты "Что нового в версии" - по доступным пользователю разделам ГКИ.
	ОтборПоЛентеНовостей = Справочники.ЛентыНовостей.НайтиПоКоду("WhatIsNew");
	ОтборПоКатегорииНовостей = ПланыВидовХарактеристик.КатегорииНовостей.НайтиПоКоду("SectionPanel");

	Если НЕ ЗначениеЗаполнено(ОтборПоЛентеНовостей)
	 ИЛИ НЕ ЗначениеЗаполнено(ОтборПоКатегорииНовостей) Тогда
		Возврат;
	КонецЕсли;

	// Подготовим таблицу соответствий разделов ГКИ и ролей для доступа к ним
	ТаблицаПодсистем = ТаблицаПодсистемИРолейДляПросмотра(Истина);

	// Получим данные о доступности пользователям разделов ГКИ
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Т",                        ТаблицаПодсистем);
	Запрос.УстановитьПараметр("ОтборПоЛентеНовостей",     ОтборПоЛентеНовостей);
	Запрос.УстановитьПараметр("ОтборПоКатегорииНовостей", ОтборПоКатегорииНовостей);
	Запрос.УстановитьПараметр("ТекущийПользователь",      ТекущийПользователь);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Т.Подсистема КАК СТРОКА(100)) КАК ЗначениеКатегорииНовостей
	|ПОМЕСТИТЬ ВТТаблицаПодсистем
	|ИЗ
	|	&Т КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтборыПоЛентамНовостейПользовательские.ЗначениеКатегорииНовостей
	|ПОМЕСТИТЬ ВТСтарыеОтборы
	|ИЗ
	|	РегистрСведений.ОтборыПоЛентамНовостейПользовательские КАК ОтборыПоЛентамНовостейПользовательские
	|ГДЕ
	|	ОтборыПоЛентамНовостейПользовательские.Пользователь = &ТекущийПользователь
	|	И ОтборыПоЛентамНовостейПользовательские.ЛентаНовостей = &ОтборПоЛентеНовостей
	|	И ОтборыПоЛентамНовостейПользовательские.КатегорияНовостей = &ОтборПоКатегорииНовостей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНовыеОтборы.ЗначениеКатегорииНовостей
	|ИЗ
	|	ВТТаблицаПодсистем КАК ВТНовыеОтборы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтарыеОтборы КАК ВТСтарыеОтборы
	|		ПО ВТНовыеОтборы.ЗначениеКатегорииНовостей = ВТСтарыеОтборы.ЗначениеКатегорииНовостей
	|ГДЕ
	|	ВТСтарыеОтборы.ЗначениеКатегорииНовостей ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТСтарыеОтборы.ЗначениеКатегорииНовостей
	|ИЗ
	|	ВТСтарыеОтборы КАК ВТСтарыеОтборы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаПодсистем КАК ВТНовыеОтборы
	|		ПО ВТСтарыеОтборы.ЗначениеКатегорииНовостей = ВТНовыеОтборы.ЗначениеКатегорииНовостей
	|ГДЕ
	|	ВТНовыеОтборы.ЗначениеКатегорииНовостей ЕСТЬ NULL ";

	// Перезапишем только измененные пользовательские отборы
	Выборка = Запрос.Выполнить().Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		Возврат; // права на подсистемы не менялись - не надо менять отборы новостей
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.ОтборыПоЛентамНовостейПользовательские.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
	НаборЗаписей.Отбор.ЛентаНовостей.Установить(ОтборПоЛентеНовостей);
	НаборЗаписей.Отбор.КатегорияНовостей.Установить(ОтборПоКатегорииНовостей);

	Для Каждого ТекущаяСтрока Из ТаблицаПодсистем Цикл

		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.Пользователь              = ТекущийПользователь;
		НоваяСтрока.ЛентаНовостей             = ОтборПоЛентеНовостей;
		НоваяСтрока.КатегорияНовостей         = ОтборПоКатегорииНовостей;
		НоваяСтрока.ЗначениеКатегорииНовостей = ТекущаяСтрока.Подсистема;
		НоваяСтрока.УстановленоПрограммно     = Истина;

	КонецЦикла;

	НаборЗаписей.Записать(Истина);

	// Позовем сервисные процедуры механизма новостей

	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		// Для модели сервиса может запускаться только в неразделённом сеансе, например, фоновым заданием
		// Считаем, что "лишние" отборы в модели сервиса уже очищены.
		ОбработкаНовостей.ОптимизироватьОтборыПоНовостям();
	КонецЕсли;

	// Пересчёт пользовательских отборов может осуществляться как в модели сервиса, так и без неё,
	//  вне зависимости от того, запущен ли разделённый сеанс или в области данных.
	ОбработкаНовостей.ПересчитатьОтборыПоНовостям_Пользовательские(ТекущийПользователь);

КонецПроцедуры

// Возвращает таблицу соответствия интерфейсных подсистем и ролей для доступа к ним.
//
Функция ТаблицаПодсистемИРолейДляПросмотра(ПроверятьРольТекущегоПользователя)

	ТаблицаПодсистем = Новый ТаблицаЗначений;
	ТаблицаПодсистем.Колонки.Добавить("Подсистема", Новый ОписаниеТипов("Строка"));
	ТаблицаПодсистем.Колонки.Добавить("Роль",       Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));

	Если Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		Возврат ТаблицаПодсистем; // без ограничений по подсистемам
	КонецЕсли;

	ТаблицаПодсистем.Колонки.Добавить("МетаданныеРоли");

	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.Администрирование.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделАдминистрирование;

		НоваяСтрока = ТаблицаПодсистем.Добавить();
		НоваяСтрока.Подсистема = Метаданные.Подсистемы.Найти("Планирование").Имя;
		НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделБюджетированиеИПланирование;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.Закупки.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделЗакупки;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.БанкИКассаБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделБанкИКассаБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.ЗакупкиБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделЗакупкиБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.НастройкиБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделНастройкиБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.ОрганизацияБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделОрганизацияБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.ОтчетыБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделОтчетыБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.ПродажиБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделПродажиБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.СкладБазовая.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделСкладБазовая;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.CRMИМаркетинг.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.ПодсистемаCRMИМаркетинг;


	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.Продажи.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделПродажи;


	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.Склад.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделСклад;

	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.Казначейство.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.РазделКазначейство;
	
	НоваяСтрока = ТаблицаПодсистем.Добавить();
	НоваяСтрока.Подсистема = Метаданные.Подсистемы.ФинансовыйРезультатИКонтроллинг.Имя;
	НоваяСтрока.МетаданныеРоли = Метаданные.Роли.ПодсистемаФинансовыйРезультатИКонтроллинг;

	МассивСтрокДляУдаления = Новый Массив;

	Для Каждого ТекущаяСтрока Из ТаблицаПодсистем Цикл

		Если ПроверятьРольТекущегоПользователя И НЕ РольДоступна(ТекущаяСтрока.МетаданныеРоли) Тогда
			МассивСтрокДляУдаления.Добавить(ТекущаяСтрока);
		Иначе
			ТекущаяСтрока.Роль = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТекущаяСтрока.МетаданныеРоли);
		КонецЕсли;

	КонецЦикла;

	Для Каждого ТекущаяСтрока Из МассивСтрокДляУдаления Цикл
		ТаблицаПодсистем.Удалить(ТекущаяСтрока);
	КонецЦикла;

	ТаблицаПодсистем.Колонки.Удалить("МетаданныеРоли");

	Возврат ТаблицаПодсистем;

КонецФункции

#КонецОбласти
