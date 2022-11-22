﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ПартнерыИКонтрагенты.ПартнерФормаЭлементаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Объект.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо Тогда
		Элементы.СтраницыПубличноеНаименованиеКомпанияЧастноеЛицо.ТекущаяСтраница = Элементы.СтраницаПубличноеНаименованиеЧастноеЛицо;
	Иначе
		Элементы.СтраницыПубличноеНаименованиеКомпанияЧастноеЛицо.ТекущаяСтраница = Элементы.СтраницаПубличноеНаименованиеКомпания;
	КонецЕсли;
	
	ОтгрузкаЗапрещена = СегментыСервер.ПартнерВходитВСегментыЗапретаОтгрузки(Объект.Ссылка);
	
	Если ОтгрузкаЗапрещена Тогда
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаЗапрещена;
	Иначе
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаРазрешена;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Версионирование
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Версионирование
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ДополнительныеПараметрыКИ = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформацией();
	ДополнительныеПараметрыКИ.Вставить("ИмяЭлементаДляРазмещения", "ГруппаКонтактнаяИнформация");
	ДополнительныеПараметрыКИ.Вставить("ПоложениеЗаголовкаКИ", ПоложениеЗаголовкаЭлементаФормы.Лево);
	ДополнительныеПараметрыКИ.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, ДополнительныеПараметрыКИ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ПравоДоступа("Изменение", Метаданные.Справочники.Партнеры)
		ИЛИ ПравоДоступа("Добавление", Метаданные.Справочники.Партнеры) Тогда
		УправлениеДоступом.ПриСозданииФормыЗначенияДоступа(ЭтаФорма);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Взаимодействия
	Взаимодействия.ПодготовитьОповещения(ЭтаФорма, Параметры, Ложь);
	// Конец СтандартныеПодсистемы.Взаимодействия
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

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
	
	ПартнерыИКонтрагенты.ПартнерФормаЭлементаПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект); 
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "ДобавлениеПартнераВСегмент"
		ИЛИ ИмяСобытия = "УдалениеПартнераИзСегмента" Тогда
		
		ОбновитьЗапретОтгрузки(Объект.Ссылка, ОтгрузкаЗапрещена);
		УстановитьДоступностьЗапретаОтгрузки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ПартнерыИКонтрагенты.ПартнерФормаЭлементаПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ВзаимодействияКлиент.КонтактПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи, "Партнеры");
	Оповестить("Запись_Партнеры", Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	Отбор = Новый Структура();
	Отбор.Вставить("Назначение",ПредопределенноеЗначение("Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляДоставки"));
	ПараметрыФормы.Вставить("Отбор",Отбор);
	ШаблонЭтикетки = Неопределено;

	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенников.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ШаблонЭтикеткиНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ШаблонЭтикетки = Результат;
    Если ШаблонЭтикетки=Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    Объект.ШаблонЭтикетки =  ШаблонЭтикетки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаналПервичногоИнтересаПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерФормаЭлементаКаналПервичногоИнтересаПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры 

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерФормаЭлементаНаименованиеПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПризнакПартнераПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерФормаЭлементаФлагПризнакПартнераПриИзменении(ЭтаФорма, Элемент);
	ОбновитьЭлементыДополнительныхРеквизитов();
	УстановитьДоступностьЗапретаОтгрузки();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПартнерыИКонтрагентыКлиент.ПартнерФормаЭлементаКомментарииНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура БизнесРегионПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерФормаЭлементаБизнесРегионПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.НаименованиеПолное;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпанияЧастноеЛицоПриИзменении(Элемент)
	
	ЭтоЧастноеЛицо = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.КомпанияЧастноеЛицо.ЧастноеЛицо");
	
	Элементы.Пол.Доступность                             = ЭтоЧастноеЛицо;
	Элементы.ДатаРождения.Доступность                    = ЭтоЧастноеЛицо;
	Элементы.ВариантОтправкиЭлектронногоЧека.Доступность = ЭтоЧастноеЛицо;
	
	Если ЭтоЧастноеЛицо Тогда
		Элементы.СтраницыПубличноеНаименованиеКомпанияЧастноеЛицо.ТекущаяСтраница = Элементы.СтраницаПубличноеНаименованиеЧастноеЛицо;
	Иначе
		Элементы.СтраницыПубличноеНаименованиеКомпанияЧастноеЛицо.ТекущаяСтраница = Элементы.СтраницаПубличноеНаименованиеКомпания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпанияЧастноеЛицоОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#Область ПроцедурыПодсистемыКонтактнаяИнформация

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

&НаСервере
Процедура КонтактнаяИнформацияПриСменеСтраницы()
	
	УправлениеКонтактнойИнформацией.ВыполнитьОтложеннуюИнициализацию(ЭтотОбъект, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	Если ТекущаяСтраница.Имя = ПараметрыКонтактнойИнформации.ГруппаКонтактнаяИнформация.ГруппаДляРазмещения
		И Не ПараметрыКонтактнойИнформации.ГруппаКонтактнаяИнформация.ВыполненаОтложеннаяИнициализация Тогда
		
		КонтактнаяИнформацияПриСменеСтраницы();
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуСегментовЗапретаОтгрузки(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = Нстр("ru = 'Данные еще не записаны.
		|Переход к запрету отгрузки возможен только после записи данных.
		|Данные будут записаны.'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОткрытьФормуСегментовЗапретаОтгрузкиЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
        Возврат;
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Партнеры.Форма.ФормаСегментовЗапретаОтгрузки", Новый Структура("Партнер", Объект.Ссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСегментовЗапретаОтгрузкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
        Возврат;
    КонецЕсли;
    
    Попытка
        ЭлементЗаписан = Записать();
    Исключение
        Возврат;
    КонецПопытки;
    
    Если Не ЭлементЗаписан Тогда
        Возврат;
    КонецЕсли;
    
    
    ОткрытьФорму("Справочник.Партнеры.Форма.ФормаСегментовЗапретаОтгрузки", Новый Структура("Партнер", Объект.Ссылка));

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппаДоступа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользуютсяОграниченияДоступаНаУровнеЗаписей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаРождения.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Пол.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮрФизЛицо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЗапретаОтгрузки()
	
	Если ИспользоватьЗапретОтгрузки И Объект.Клиент Тогда
		Если ОтгрузкаЗапрещена Тогда
			Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаЗапрещена;
		Иначе
			Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаРазрешена;
		КонецЕсли;
	Иначе
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаПустая;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьЗапретОтгрузки(Партнер, ОтгрузкаЗапрещена)
	
	ОтгрузкаЗапрещена = СегментыСервер.ПартнерВходитВСегментыЗапретаОтгрузки(Партнер);
	
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

#КонецОбласти
