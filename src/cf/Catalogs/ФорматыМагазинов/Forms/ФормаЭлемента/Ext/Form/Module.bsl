﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ЗаполнитьСписокВыбораЦелевоеМестоположение();
	ЗаполнитьСписокВыбораТехнологияРазмещения();

	ИспользоватьНесколькоВидовЦен = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	
	Если (НЕ ИспользоватьНесколькоВидовЦен)
		И (НЕ ЗначениеЗаполнено(Объект.РозничныйВидЦены)) Тогда
		Объект.РозничныйВидЦены = Ценообразование.ВидЦеныПрайсЛист();
	КонецЕсли;

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
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

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТехнологияРазмещенияТовараИОбслуживанияПокупателейПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораТехнологияРазмещения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦелевоеМестоположениеПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораЦелевоеМестоположение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлощадьТорговогоЗалаМинимальнаяПриИзменении(Элемент)
	Если Объект.ПлощадьТорговогоЗалаМаксимальная < Объект.ПлощадьТорговогоЗалаМинимальная Тогда
		Если Объект.ПлощадьТорговогоЗалаМаксимальная <> 0 Тогда
			ТекстСообщения = НСтр("ru='Минимальная площадь не может быть больше максимальной!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		Объект.ПлощадьТорговогоЗалаМаксимальная = Объект.ПлощадьТорговогоЗалаМинимальная;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПлощадьТорговогоЗалаМаксимальнаяПриИзменении(Элемент)
	Если Объект.ПлощадьТорговогоЗалаМаксимальная < Объект.ПлощадьТорговогоЗалаМинимальная Тогда
		ТекстСообщения = НСтр("ru='Максимальная площадь не может быть меньше минимальной!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Объект.ПлощадьТорговогоЗалаМинимальная = Объект.ПлощадьТорговогоЗалаМаксимальная;
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		ОткрытьФорму("Справочник.ФорматыМагазинов.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораЦелевоеМестоположение()
	Элементы.ЦелевоеМестоположение.СписокВыбора.Очистить();
	МассивВариантов = ПолучитьВарианты("ФорматыМагазинов", "ЦелевоеМестоположение", "ЭтоГруппа");
	
	Для Каждого Вариант Из МассивВариантов Цикл
		Элементы.ЦелевоеМестоположение.СписокВыбора.Добавить(Вариант);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТехнологияРазмещения()
	Элементы.ТехнологияРазмещенияТовараИОбслуживанияПокупателей.СписокВыбора.Очистить();
	МассивВариантов = ПолучитьВарианты("ФорматыМагазинов", "ТехнологияРазмещенияТовараИОбслуживанияПокупателей", "ЭтоГруппа");
	
	Для Каждого Вариант Из МассивВариантов Цикл
		Элементы.ТехнологияРазмещенияТовараИОбслуживанияПокупателей.СписокВыбора.Добавить(Вариант);
	КонецЦикла;
	
КонецПроцедуры

// Функция формирует запрос для получения всех текстов, вводимых ранее в указанное поле
// параметры
//	ИмяТаблицы - строка, содержащее имя таблицы, из которой осуществляется выборка
//	ИмяРеквизита - имя реквизита, значения которого нужно получить
//	СтрокаУсловияГруппы - путь к значению реквизита "ЭтоГруппа" 
//							для исключения попадания в результат запроса групп
// Возвращаемое занчение 
//	МассивВариантов - массив, содержащий значения текстов.
&НаСервере
Функция ПолучитьВарианты(ИмяТаблицы, ИмяРеквизита, СтрокаУсловияГруппы)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Таблица."+ИмяРеквизита+" КАК ЗначениеВарианта
	                      |ИЗ
	                      |	Справочник."+ИмяТаблицы+" КАК Таблица
						  |ГДЕ
						  |	(НЕ Таблица."+СтрокаУсловияГруппы+")
						  |	И Таблица."+ИмяРеквизита+"<>""""
	                      |СГРУППИРОВАТЬ ПО
	                      |	Таблица."+ИмяРеквизита+"
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ЗначениеВарианта
						  |");
	РезультатЗапроса=Запрос.Выполнить();
	МассивВариантов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ЗначениеВарианта");
	Если ЗначениеЗаполнено(Объект[ИмяРеквизита]) Тогда
		Если МассивВариантов.Найти(Объект[ИмяРеквизита]) = Неопределено Тогда
			МассивВариантов.Добавить(Объект[ИмяРеквизита]);
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивВариантов;
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства


// СтандартныеПодсистемы.Свойства 

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

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

#КонецОбласти
