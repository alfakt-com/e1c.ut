﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПериодНачисления = Новый СтандартныйПериод;
		ПериодНачисления.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
		Объект.ДатаНачала = ПериодНачисления.ДатаНачала;
		Объект.ДатаОкончания = ПериодНачисления.ДатаОкончания;
		
	КонецЕсли;
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Контроль создания документа в подчиенном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		Если РезультатВыбора.Свойство("АдресНачисленийВХранилище") Тогда
			ПолучитьНачисленияИзХранилища(РезультатВыбора.АдресНачисленийВХранилище);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ХозяйственнаяОперацияПриИзмененииСервер();
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные.ТипСуммыГрафика = ПредопределенноеЗначение("Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	ПартнерПриИзмененииНаСервере(ТекущиеДанные.Партнер, ТекущиеДанные.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	Договор = РеквизитыДоговораСервер(ТекущиеДанные.Договор);
	ТекущиеДанные.Партнер = Договор.Партнер;
	ТекущиеДанные.Контрагент = Договор.Контрагент;
	Если ТекущиеДанные.ВалютаВзаиморасчетов <> Договор.ВалютаВзаиморасчетов Тогда
		ТекущиеДанные.ВалютаВзаиморасчетов = Договор.ВалютаВзаиморасчетов;
		ТекущиеДанные.СуммаВзаиморасчетов = 0;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСуммыГрафика = ПредопределенноеЗначение("Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты") Тогда
		ТекущиеДанные.СтатьяДоходовРасходов = Договор.СтатьяДоходовРасходовПроцентов;
	ИначеЕсли ТекущиеДанные.ТипСуммыГрафика = ПредопределенноеЗначение("Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Комиссия") Тогда
		ТекущиеДанные.СтатьяДоходовРасходов = Договор.СтатьяДоходовРасходовКомиссии;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	ТекущиеДанные.СуммаВзаиморасчетов = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Начисления.ТекущиеДанные;
	НоваяСтатья = ТекущаяСтрока.СтатьяДоходовРасходов;
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.НачисленияПоКредитам") Тогда
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
	Иначе
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов");
	КонецЕсли;
	Элемент.ОграничениеТипа = ОграничивающиеТипы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Текст  = НСтр("ru='Не указана хозяйственная операция!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ХозяйственнаяОперация","Объект");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Текст  = НСтр("ru='Не указана организация!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"Организация","Объект");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Текст  = НСтр("ru='Не указано начало периода начислений!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ДатаНачала","Объект");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		Текст  = НСтр("ru='Не указан конец периода начислений!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ДатаОкончания","Объект");
		Возврат;
	КонецЕсли;
	
	АдресНачисленийВХранилище = ПоместитьНачисленияВХранилище();
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("АдресНачисленийВХранилище", АдресНачисленийВХранилище);
	ПараметрыОтбора.Вставить("Организация", Объект.Организация);
	ПараметрыОтбора.Вставить("Регистратор", Объект.Ссылка);
	ПараметрыОтбора.Вставить("ИдентификаторФормыДокумента", УникальныйИдентификатор);
	ПараметрыОтбора.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	ПараметрыОтбора.Вставить("ДатаНачала", Объект.ДатаНачала);
	ПараметрыОтбора.Вставить("ДатаОкончания", Объект.ДатаОкончания);
	
	ОткрытьФорму("Документ.НачисленияКредитовИДепозитов.Форма.ФормаЗаполнения", 
						ПараметрыОтбора,
						ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатьяДоходовРасходов.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Начисления.ТипСуммыГрафика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыСуммГрафикаКредитовИДепозитов.Комиссия;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Начисления.СтатьяДоходовРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()

	УстановитьПараметрыВыбораДоговора();
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачисленияПоКредитам Тогда
		Элементы.СтатьяДоходовРасходов.Заголовок = НСтр("ru='Статья расходов'");
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
	Иначе
		Элементы.СтатьяДоходовРасходов.Заголовок = НСтр("ru='Статья доходов'");
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов");
	КонецЕсли;
	Элементы.СтатьяДоходовРасходов.ОграничениеТипа = ОграничивающиеТипы;
	
	ПартнерыИКонтрагенты.ЗаголовокЭлементаПартнерВЗависимостиОтХозяйственнойОперации( ЭтотОбъект, "Партнер", Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПартнерПриИзмененииНаСервере(Партнер, Контрагент)
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыДоговораСервер(Договор)

	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, 
															"Партнер,
															|Контрагент,
															|ВалютаВзаиморасчетов,
															|СтатьяДоходовРасходовПроцентов,
															|СтатьяДоходовРасходовКомиссии,
															|ХарактерДоговора");
	
	Возврат Результат;

КонецФункции

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

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыВыбораДоговора(Партнер = Неопределено, Контрагент = Неопределено)

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления",Ложь));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ХарактерДоговора", Справочники.ДоговорыКредитовИДепозитов.ХарактерДоговораПоОперации(Объект.ХозяйственнаяОперация)));
	Если НЕ Объект.Организация.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Объект.Организация));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Партнер", Партнер));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Контрагент));
	КонецЕсли;
	
	Элементы.Договор.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);

КонецПроцедуры

&НаСервере
Функция ПоместитьНачисленияВХранилище()

	АдресВХранилище = ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(), УникальныйИдентификатор);
	Возврат АдресВХранилище;

КонецФункции

&НаСервере
Процедура ПолучитьНачисленияИзХранилища(АдресНачисленийВХранилище)

	Объект.Начисления.Загрузить(ПолучитьИзВременногоХранилища(АдресНачисленийВХранилище));
	Если Объект.Начисления.Количество() = 0 Тогда
		ОрганизацияЗаПериод = НСтр("ru = 'Для организации ""%1"" за период с %2 по %3'");
		ОрганизацияЗаПериод = СтрШаблон(ОрганизацияЗаПериод, Объект.Организация,
								Формат(Объект.ДатаНачала, "ДЛФ=D"), Формат(Объект.ДатаОкончания, "ДЛФ=D"));
		Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачисленияПоКредитам Тогда
			ПоДоговорам = НСтр("ru = 'по действующим договорам кредитов и полученных займов не обнаружены графики начислений'");
		ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачисленияПоДепозитам Тогда
			ПоДоговорам = НСтр("ru = 'по действующим договорам депозитов не обнаружены графики начислений'");
		ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачисленияПоЗаймамВыданным Тогда
			ПоДоговорам = НСтр("ru = 'по действующим договорам выданных займов не обнаружены графики начислений'");
		КонецЕсли;
		ТекстСообщения = ОрганизацияЗаПериод + Символы.ПС + ПоДоговорам + ".";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
