﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("АктивПассив; АктивПассив");
	Результат.Добавить("ТипЗначения; ТипЗначения");
	
	Возврат Результат;
	
КонецФункции

// Функция определяет аналитику активов и пассивов для подстановки в документ по статье активов и пассивов.
//
// Параметры:
//  СтатьяАктивовПассивов - ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов - Ссылка на статью активов и пассивов
//	Объект - ДанныеФормыСтруктура - Текущий объект.
//
// Возвращаемое значение:
//	СправочникСсылка - значение аналитики по умолчанию для активов и пассивов.
//
Функция ПолучитьАналитикуАктивовПассивовПоУмолчанию(СтатьяАктивовПассивов, Объект) Экспорт
	
	ОписаниеТипов = Новый ОписаниеТипов(СтатьяАктивовПассивов.ТипЗначения);
	АналитикаАктивовПассивов = ОписаниеТипов.ПривестиЗначение();
	
	Если СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады")
		И Объект.Свойство("Склад") Тогда
	
		АналитикаАктивовПассивов = Объект.Склад;
	
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Партнеры")
		И Объект.Свойство("Партнер") Тогда
		
		АналитикаАктивовПассивов = Объект.Партнер;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты")
		И Объект.Свойство("Контрагент") Тогда
		
		АналитикаАктивовПассивов = Объект.Контрагент;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия")
		И Объект.Свойство("Подразделение") Тогда
		
		АналитикаАктивовПассивов = Объект.Подразделение;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия")
		И Объект.Свойство("ПодразделениеПредприятия") Тогда
		
		АналитикаАктивовПассивов = Объект.ПодразделениеПредприятия;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации")
		И Объект.Свойство("Организация") Тогда
	
		АналитикаАктивовПассивов = Объект.Организация;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица")
		И Объект.Свойство("ФизическоеЛицо") Тогда
	
		АналитикаАктивовПассивов = Объект.ФизическоеЛицо;
		
	КонецЕсли;
	
	Возврат АналитикаАктивовПассивов;
	
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
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаАктиваПассива(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "ФормаЭлемента,ФормаСписка";
	КонецЕсли;
	
КонецПроцедуры

// Возвращает статьи активов/пассивов, использование которых запрещено
//
// Возвращаемое значение:
// 	ЗаблокированныеСтатьи - СписокЗначений - Список заблокированных статей активов/пассивов.
//
Функция ЗаблокированныеСтатьиАктивовПассивов() Экспорт
	
	ЗаблокированныеСтатьи = Новый СписокЗначений;
	
	Возврат ЗаблокированныеСтатьи;
	
КонецФункции

// Процедура заполнения колонок "АналитикаАктивовПассивовНеИспользуется" в формах.
//
// Параметры:
// 		ТаблицаФормы - ДанныеФормыКоллекция - Коллекция формы, в которой необходимо заполнить реквизиты признаков обязательности аналитики доходов
// 		Реквизиты - Строка - Реквизиты статей доходов и их аналитик
// 			Перечисление пар реквизитов в формате "СтатьяАктивовПассивов1, АналитикаАктивовПассивов1, СтатьяАктивовПассивов2, АналитикаАктивовПассивов2, ..."
// 			Пустая строка трактуется как "СтатьяАктивовПассивов, АналитикаАктивовПассивов".
//
Процедура ЗаполнитьПризнакАналитикаАктивовПассивовНеИспользуется(ТаблицаФормы, Реквизиты="") Экспорт
	
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки%ПоляСтатей%
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки%ПоляФлагов%
	|ИЗ
	|	Таблица КАК Таблица%ПоляСоединений%";
	
	ШаблонСтатьи = ",
	|	Таблица.%ИмяСтатьи% КАК %ИмяСтатьи%";
	ШаблонФлага = ",
	|	ЕСТЬNULL(ПВХ%ИмяСтатьи%.БезАналитики, ЛОЖЬ) КАК %ИмяАналитики%НеИспользуется";
	ШаблонСоединения = "
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиАктивовПассивов КАК ПВХ%ИмяСтатьи%
	|		ПО Таблица.%ИмяСтатьи% = ПВХ%ИмяСтатьи%.Ссылка";
	
	ПоляСтатей = "";
	ПоляФлагов = "";
	ПоляСоединений ="";
	
	СтруктураРеквизитов = РеквизитыАктивовПассивов(Реквизиты);
	
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ПоляСтатей = ПоляСтатей + СтрЗаменить(ШаблонСтатьи, "%ИмяСтатьи%", КлючИЗначение.Ключ);
		ПоляФлагов = ПоляФлагов + СтрЗаменить(СтрЗаменить(ШаблонФлага, "%ИмяАналитики%", КлючИЗначение.Значение), "%ИмяСтатьи%", КлючИЗначение.Ключ);
		ПоляСоединений = ПоляСоединений + СтрЗаменить(ШаблонСоединения, "%ИмяСтатьи%", КлючИЗначение.Ключ);
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПоляСтатей%", ПоляСтатей);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПоляФлагов%", ПоляФлагов);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПоляСоединений%", ПоляСоединений);
	
	Запрос.УстановитьПараметр(
		"Таблица",
		ТаблицаФормы.Выгрузить(,"НомерСтроки, " + ?(ПустаяСтрока(Реквизиты), "СтатьяАктивовПассивов, АналитикаАктивовПассивов", Реквизиты)));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаФормы[Выборка.НомерСтроки-1], Выборка,, "НомерСтроки");
	КонецЦикла;
	
КонецПроцедуры

// Производит заполнение условного оформления формы
//
// Параметры:
// 		УсловноеОФормление - УсловноеОформлениеКомпоновкиДанных - Условное оформление формы объекта
// 		Реквизиты - Строка, Структура, Массив - Реквизиты статей доходов и их аналитик для оформления
// 			<Строка> Перечисление пар реквизитов в формате "СтатьяАктивовПассивов1, АналитикаАктивовПассивов1, СтатьяАктивовПассивов2, АналитикаАктивовПассивов2, ..."
// 				Пустая строка трактуется как "СтатьяАктивовПассивов, АналитикаАктивовПассивов"
// 			<Структура> Ключ: Строка с именем табличной части; Значение - Строка в нотации как у параметра типа <Строка>
// 			<Массив> Массив, элементы которого либо структуры в нотации как у параметра с типа <Структура>, либо строки в нотации <Строка>
// 		ФормаОбъекта - Булево - Признак формы объекта ИБ.
//
Процедура УстановитьУсловноеОформлениеАналитик(УсловноеОФормление, Реквизиты = "", ФормаОбъекта = Истина) Экспорт
	
	МассивОбработки = Новый Массив;
	Если ТипЗнч(Реквизиты) = Тип("Массив") Тогда
		МассивОбработки = Реквизиты;
	Иначе
		МассивОбработки.Добавить(Реквизиты);
	КонецЕсли;
	
	Для Каждого ЭлементМассива Из МассивОбработки Цикл
		
		Если ТипЗнч(ЭлементМассива) = Тип("Структура") Тогда
			
			Для Каждого КлючИЗначение Из ЭлементМассива Цикл
				
				СтруктураРеквизитов = РеквизитыАктивовПассивов(КлючИЗначение.Значение);
				УстановитьУсловноеОформление(УсловноеОформление, СтруктураРеквизитов, КлючИЗначение.Ключ, ФормаОбъекта)
				
			КонецЦикла;
			
		Иначе
			
			СтруктураРеквизитов = РеквизитыАктивовПассивов(ЭлементМассива);
			УстановитьУсловноеОформление(УсловноеОформление, СтруктураРеквизитов, "", ФормаОбъекта)
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТВызовСервера.ОбработкаПолученияДанныхВыбораПВХСтатьиАктивовПассивов(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция РеквизитыАктивовПассивов(СтрокаРеквизитов, НепроверяемыеРеквизиты = Неопределено, ПрефиксТабличнойЧасти = "")
	
	Если ПустаяСтрока(СтрокаРеквизитов) Тогда
		Если НепроверяемыеРеквизиты <> Неопределено Тогда
			НепроверяемыеРеквизиты.Добавить(ПрефиксТабличнойЧасти + "АналитикаАктивовПассивов");
		КонецЕсли;
		Возврат Новый Структура("СтатьяАктивовПассивов", "АналитикаАктивовПассивов");
	КонецЕсли;
	
	СтруктураОбработки = Новый Структура(СтрокаРеквизитов);
	СтруктураВозврата = Новый Структура;
	ПредыдущийКлюч = Неопределено;
	Для Каждого КлючИЗначение Из СтруктураОбработки Цикл
		Если ПредыдущийКлюч = Неопределено Тогда
			ПредыдущийКлюч = КлючИЗначение.Ключ;
		Иначе
			СтруктураВозврата.Вставить(ПредыдущийКлюч, КлючИЗначение.Ключ);
			ПредыдущийКлюч = Неопределено;
			Если НепроверяемыеРеквизиты <> Неопределено Тогда
				НепроверяемыеРеквизиты.Добавить(ПрефиксТабличнойЧасти + КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура УстановитьУсловноеОформление(УсловноеОформление, СтруктураРеквизитов, ИмяТабличнойЧасти = "", ФормаОбъекта = Истина)
	
	ПревиксТЧ = ?(ПустаяСтрока(ИмяТабличнойЧасти), "", ИмяТабличнойЧасти + ".");
	ПрефиксАналитики = ?(ФормаОбъекта, "Объект.", "") + ПревиксТЧ;
	ПрефиксКонтроля  = ?(ФормаОбъекта И Не ПустаяСтрока(ПревиксТЧ), "Объект.", "") + ПревиксТЧ;
	
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		
		ИмяСтатьи = КлючИЗначение.Ключ;
		ИмяАналитики = КлючИЗначение.Значение;
		ИмяКонтроля = ИмяАналитики + "НеИспользуется";
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(ИмяТабличнойЧасти + ИмяАналитики);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПрефиксКонтроля + ИмяКонтроля);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПодсказкиВвода);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не используется'"));
		
	КонецЦикла;
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьНастройкиПредопределенныхЭлементов() Экспорт
	
	МетаданныеОбъекта = Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов;
	ПолноеИмяОбъекта  = МетаданныеОбъекта.ПолноеИмя();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиАктивовПассивов.Ссылка,
		|	СтатьиАктивовПассивов.ИмяПредопределенныхДанных КАК Имя,
		|	ВЫБОР
		|		КОГДА СтатьиАктивовПассивов.Ссылка В (
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ВыводСобственныхСредств),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ВыданныеАвансы),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ОсновныеСредства),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НематериальныеАктивы),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.КапитализацияОС),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.КапитализацияНМАиНИОКР),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.КапитализацияОбъектовСтроительства),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ЗадолженностьКлиентов),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваБезналичные),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваНаправления),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваВПути),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваНаличные),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваУПодотчетныхЛиц),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеДокументы),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДепозитыВБанках),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ЗадолженностьСобственныхОрганизаций),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ЗаймыВыданные),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеАктивы),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.РасходыБудущихПериодов),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НезавершенноеПроизводство),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.РасходыТекущегоПериода),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыПереданныеВПереработку),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыПереданныеНаКомиссию),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыВПути),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыВРознице),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыНаОптовыхСкладах))
		|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСтатейУправленческогоБаланса.Актив)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСтатейУправленческогоБаланса.Пассив)
		|	КОНЕЦ КАК АктивПассив
		|ИЗ
		|	ПланВидовХарактеристик.СтатьиАктивовПассивов КАК СтатьиАктивовПассивов
		|ГДЕ
		|	СтатьиАктивовПассивов.Предопределенный
		|	И НЕ СтатьиАктивовПассивов.ЭтоГруппа
		|	И НЕ СтатьиАктивовПассивов.Ссылка В (&АктивыПассивы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Статьи.Ссылка,
		|	Статьи.ИмяПредопределенныхДанных КАК Имя,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыСтатейУправленческогоБаланса.АктивПассив) КАК АктивПассив
		|ИЗ
		|	ПланВидовХарактеристик.СтатьиАктивовПассивов КАК Статьи
		|ГДЕ
		|	Статьи.Ссылка В (&АктивыПассивы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Статьи.Ссылка,
		|	Статьи.ИмяПредопределенныхДанных КАК Имя,
		|	НЕОПРЕДЕЛЕНО КАК АктивПассив
		|ИЗ
		|	ПланВидовХарактеристик.СтатьиАктивовПассивов КАК Статьи
		|ГДЕ
		|	Статьи.Предопределенный
		|	И Статьи.ЭтоГруппа";
		
	АктивыПассивы = Новый Массив;
	АктивыПассивы.Добавить(ПланыВидовХарактеристик.СтатьиАктивовПассивов.Лизинг);
	АктивыПассивы.Добавить(ПланыВидовХарактеристик.СтатьиАктивовПассивов.Налоги);
	Запрос.УстановитьПараметр("АктивыПассивы", АктивыПассивы);
	
	ПорядокСтатейXML = ПолучитьМакет("ПорядокСтатей").ПолучитьТекст();
	ПорядокСтатей = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ПорядокСтатейXML).Данные;
	ТипБезАналитики = Новый ОписаниеТипов("ПеречислениеСсылка.СтатьиБезАналитики");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Порядок = ПорядокСтатей.Найти(Выборка.Имя);
			Если Порядок <> Неопределено Тогда
				Объект.РеквизитДопУпорядочивания = Порядок.РеквизитДопУпорядочивания;
			КонецЕсли;
			Если ЗначениеЗаполнено(Выборка.АктивПассив) Тогда
				Объект.БезАналитики = Объект.ТипЗначения = ТипБезАналитики;
				Объект.АктивПассив = Выборка.АктивПассив;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать элемент: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,
				Выборка.Ссылка,
				ТекстСообщения);
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	УстановитьПредставлениеОборотовСтатейАктивовПассивов();
	
КонецПроцедуры

Процедура УстановитьПредставлениеОборотовСтатейАктивовПассивов()
	
	СтатьиАП = ПланыВидовХарактеристик.СтатьиАктивовПассивов;
	
	УстановитьПредставлениеОборотовСтатьи(
		СтатьиАП.ЗадолженностьПоКредитам,
		НСтр("ru = 'Возврат кредита и процентов'"),
		НСтр("ru = 'Кредит и начисления процентов'"));
		
	УстановитьПредставлениеОборотовСтатьи(
		СтатьиАП.ПолученныеАвансы,
		НСтр("ru = 'Зачет авансов'"),
		НСтр("ru = 'Авансы'"));
		
	УстановитьПредставлениеОборотовСтатьи(
		СтатьиАП.ЗадолженностьПередПоставщиками,
		НСтр("ru = 'Оплата и прочие взаиморасчеты'"),
		НСтр("ru = 'Кредит'"));
		
	УстановитьПредставлениеОборотовСтатьи(
		СтатьиАП.ПрибылиИУбытки,
		НСтр("ru = 'Себестоимость и прочие расходы'"),
		НСтр("ru = 'Выручка и прочие доходы'"));
	
КонецПроцедуры

Процедура УстановитьПредставлениеОборотовСтатьи(Статья, ПредставлениеДебетаСтатьи, ПредставлениеКредитаСтатьи)
	
	Объект = Статья.ПолучитьОбъект();
	Объект.ВыводитьОборот = Истина;
	Объект.ПредставлениеДебетаСтатьи = ПредставлениеДебетаСтатьи;
	Объект.ПредставлениеКредитаСтатьи = ПредставлениеКредитаСтатьи;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли
