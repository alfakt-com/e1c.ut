
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект, Элементы.ГруппаРазблокироватьРеквизиты);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Элементы.ГруппаПараметрыПроизводственногоПодразделения.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	Элементы.ГруппаПараметрыОбособленногоУчета.Видимость = ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Ссылка");
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект, Элементы.ГруппаРазблокироватьРеквизиты);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПеречислениеСсылка.ВариантыОбособленногоУчетаТоваров") Тогда
		
		Модифицированность = Истина;
		Объект.ВариантОбособленногоУчетаТоваров = ВыбранноеЗначение;
		ЗаполнитьПредставлениеПараметров();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_СтруктураПредприятия");
	
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользованиеВСхемахОбеспечения(Команда)
	
	
	Возврат; // в УТ пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура КомандаПараметрыПроизводственногоПодразделения(Команда)
	
	ОткрытьФорму(
		"Справочник.СтруктураПредприятия.Форма.ПараметрыПроизводственногоПодразделения",
		Новый Структура("Ссылка, АдресХранилищаДанныеОбъекта", Объект.Ссылка, ДанныеОбъектаВХранилище()),
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПараметрыПроизводственногоПодразделенияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОбособленногоУчетаТоваров(Команда)
	
	ПараметрыФормы = Новый Структура("ВариантОбособленногоУчетаТоваров", Объект.ВариантОбособленногоУчетаТоваров);
	ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.ПараметрыОбособленногоУчетаТоваров", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(
		ЭтаФорма,
		,
		Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект),
		Новый Структура("Ссылка", Неопределено));
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	
	ЗаполнитьСкладМатериалов();
	ЗаполнитьПредставлениеПараметров();
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСкладМатериалов()
	
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПроизводственногоПодразделенияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		
		ЗагрузитьДанныеОбъектаИзХранилища(РезультатЗакрытия);
		
		НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ПроизводственноеПодразделение");
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеОбъектаИзХранилища(АдресХранилищаДанныеОбъекта)
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресХранилищаДанныеОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(АдресХранилищаДанныеОбъекта);
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Объект[Реквизит.Имя] = ДанныеОбъекта[Реквизит.Имя];
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		Объект[ТабличнаяЧасть.Имя].Загрузить(ДанныеОбъекта[ТабличнаяЧасть.Имя]);
	КонецЦикла;
	
	СкладМатериалов = ДанныеОбъекта.СкладМатериалов;
	
	ЗаполнитьПредставлениеПараметров();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеПараметров()
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	Если Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство, производит продукцию по заказам и без заказов на производство.'");
			
	ИначеЕсли Объект.ПодразделениеДиспетчер  
		И Объект.ПроизводствоПоЗаказам 
		И Не Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство и производит продукцию по заказам.'");
			
	ИначеЕсли Объект.ПодразделениеДиспетчер
		И Не Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство и производит продукцию без заказов.'");
		
	ИначеЕсли Объект.ПодразделениеДиспетчер
		И Не Объект.ПроизводствоПоЗаказам
		И Не Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство.'");
			
	ИначеЕсли Не Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию по заказам и без заказов на производство.'");
			
	ИначеЕсли Не Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Не Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию по заказам на производство.'");
			
	ИначеЕсли Не Объект.ПодразделениеДиспетчер
		И Не Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию без заказов на производство.'");
			
	ИначеЕсли ЭтоКА И Объект.ПроизводственноеПодразделение Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию.'");
			
	Иначе
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение не является производственным.'");
			
	КонецЕсли;
	
	Если Объект.ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.НеВедется Тогда
		ПредставлениеОбособленногоУчетаТоваров = НСтр("ru = 'Обособленный учет товаров не ведется.'");
	ИначеЕсли Объект.ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.ПоПодразделению Тогда
		ПредставлениеОбособленногоУчетаТоваров = НСтр("ru = 'Обособленный учет товаров ведется по подразделению.'");
	ИначеЕсли Объект.ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения Тогда
		ПредставлениеОбособленногоУчетаТоваров = НСтр("ru = 'Обособленный учет товаров ведется по менеджерам подразделения.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если СтруктураРеквизитов.Свойство("ПроизводственноеПодразделение")
		ИЛИ СтруктураРеквизитов.Свойство("Ссылка")
		ИЛИ Инициализация Тогда
		Элементы.ИспользованиеВСхемахОбеспечения.Видимость = 
				Объект.ПроизводственноеПодразделение 
				И Форма.ЕстьПравоПросмотраСхемОбеспечения
				И ЗначениеЗаполнено(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеОбъектаВХранилище()
	
	ДанныеОбъекта = Новый Структура;
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		ДанныеОбъекта.Вставить(Реквизит.Имя, Объект[Реквизит.Имя]);
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		ДанныеОбъекта.Вставить(ТабличнаяЧасть.Имя, Объект[ТабличнаяЧасть.Имя].Выгрузить());
	КонецЦикла;
	
	ДанныеОбъекта.Вставить("СкладМатериалов", СкладМатериалов);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбъекта, УникальныйИдентификатор);
	
КонецФункции


// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти
