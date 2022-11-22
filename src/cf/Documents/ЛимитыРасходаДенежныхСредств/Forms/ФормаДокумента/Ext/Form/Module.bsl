﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РезультатВыбора = Неопределено;
	ВыбратьПериодИзВыпадающегоСписка(РезультатВыбора, Элемент, ВидПериода, Объект.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛимитыНетЛимитаРасходаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Лимиты.ТекущиеДанные;
	
	Если Не ТекущиеДанные.ЕстьЛимит Тогда
		ТекущиеДанные.Сумма = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЛимитамиПрошлогоМесяца(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьЛимитамиПрошлогоМесяцаЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Объект.Лимиты, 
		Неопределено,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЛимитамиПрошлогоМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Объект.Лимиты.Очистить();
	ЗаполнитьЛимитамиПрошлогоМесяцаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьямиДвиженияДенежныхСредств(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьСтатьямиДвиженияДенежныхСредствЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Объект.Лимиты, 
		Неопределено,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьямиДвиженияДенежныхСредствЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Объект.Лимиты.Очистить();
	ЗаполнитьСтатьямиДвиженияДенежныхСредствСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЛимитыСумма.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Лимиты.ЕстьЛимит");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не ограничен>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ВыбратьПериодИзВыпадающегоСписка(РезультатВыбора, Элемент, ВидПериода, Период, ИндексНачальногоЗначения = Неопределено)
	
	СписокПериодов = ОтчетыУТКлиентСервер.СписокФиксированныхПериодов(Период, ВидПериода);
	Если ИндексНачальногоЗначения = Неопределено Тогда
		ИндексНачальногоЗначения = СписокПериодов.НайтиПоЗначению(Период);
	КонецЕсли;
	Если ИндексНачальногоЗначения = Неопределено Тогда
		ИндексНачальногоЗначения = СписокПериодов.Количество() - 1;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("СписокПериодов", СписокПериодов);
	ПараметрыОповещения.Вставить("РезультатВыбора", РезультатВыбора);
	ПараметрыОповещения.Вставить("Элемент", Элемент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборПериодаИзСпискаЗавершение", ЭтаФорма, ПараметрыОповещения);
	
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокПериодов, Элемент, ИндексНачальногоЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаИзСпискаЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	РезультатВыбора = ДополнительныеПараметры.РезультатВыбора;
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		РезультатВыбора = Неопределено;
		Возврат;
	КонецЕсли;
	
	// Листание вверх-вниз.
	СписокПериодов = ДополнительныеПараметры.СписокПериодов;
	Индекс = СписокПериодов.Индекс(ВыбранныйЭлемент);
	Если Индекс = 0 Или Индекс = СписокПериодов.Количество() - 1 Тогда
		ВыбратьПериодИзВыпадающегоСписка(РезультатВыбора, ДополнительныеПараметры.Элемент, ВидПериода, ВыбранныйЭлемент.Значение, Индекс);
	Иначе
		Объект.Период = ВыбранныйЭлемент.Значение;
		Модифицированность = Истина;
		ЗаполнитьСписокВыбораПериода();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Месяц;
	
	ЗаполнитьСписокВыбораПериода();
	
	ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Элементы.ЛимитыСумма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Лимит (%1)'"),
		Строка(ВалютаУпрУчета));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораПериода()
	
	СписокВыбораПериода = Элементы.Период.СписокВыбора;
	СписокВыбораПериода.Очистить();
	
	ПериодСтрокой = ОтчетыУТКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		ВидПериода, Объект.Период, КонецМесяца(Объект.Период));
		
	СписокВыбораПериода.Добавить(Объект.Период, ПериодСтрокой);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛимитамиПрошлогоМесяцаСервер()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЛимитыРасходаДенежныхСредств.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ИСТИНА КАК ЕстьЛимит,
	|	ЛимитыРасходаДенежныхСредств.ЛимитОборот КАК Сумма
	|ИЗ
	|	РегистрНакопления.ЛимитыРасходаДенежныхСредств.Обороты(
	|		ДОБАВИТЬКДАТЕ(&ДатаНачала, МЕСЯЦ, -1),
	|		ДОБАВИТЬКДАТЕ(&ДатаОкончания, МЕСЯЦ, -1),
	|		,
	|		Организация = &Организация
	|		И Подразделение = &Подразделение) КАК ЛимитыРасходаДенежныхСредств");
	
	ИспользоватьЛимитыПоОрганизация = ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям"); 
	ИспользоватьЛимитыПоПодразделениям = ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям");
	
	Запрос.УстановитьПараметр("Организация", 
		?(ИспользоватьЛимитыПоОрганизация, Объект.Организация, Справочники.Организации.ПустаяСсылка()));
	Запрос.УстановитьПараметр("Подразделение", 
		?(ИспользоватьЛимитыПоПодразделениям, Объект.Подразделение, Справочники.СтруктураПредприятия.ПустаяСсылка()));
		
	Запрос.УстановитьПараметр("ДатаНачала", Объект.Период);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Объект.Период));
	
	Объект.Лимиты.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если Не Объект.Лимиты.Количество() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Остутствуют данные для заполнения.'"),,"Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатьямиДвиженияДенежныхСредствСервер()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтатьиДвиженияДенежныхСредств.Ссылка КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперации КАК СтатьиДвиженияДенежныхСредств
	|ГДЕ
	|	СтатьиДвиженияДенежныхСредств.ХозяйственнаяОперация В(&МассивОпераций)");
	
	Запрос.УстановитьПараметр("МассивОпераций", Справочники.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперацииРасходаДенежныхСредств());
	Объект.Лимиты.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
