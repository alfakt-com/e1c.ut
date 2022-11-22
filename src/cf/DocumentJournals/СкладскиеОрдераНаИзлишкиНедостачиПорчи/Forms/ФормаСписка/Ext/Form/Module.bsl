﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ИспользоватьКачествоТоваров = ПолучитьФункциональнуюОпцию("ИспользоватьКачествоТоваров");
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	СкладПомещениеПриИзмененииСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Элементы.СписокОрдеровСоздатьОрдерНаОтражениеИзлишков.Видимость = ПравоДоступа("Изменение", Метаданные.Документы.ОрдерНаОтражениеИзлишковТоваров);
	Элементы.СписокОрдеровСоздатьОрдерНаОтражениеНедостач.Видимость = ПравоДоступа("Изменение", Метаданные.Документы.ОрдерНаОтражениеНедостачТоваров);
	Элементы.СписокОрдеровСоздатьОрдерНаОтражениеПорчи.Видимость    = ПравоДоступа("Изменение", Метаданные.Документы.ОрдерНаОтражениеПорчиТоваров);
	Элементы.СписокОрдеровСоздатьОрдерНаОтражениеПересортицыТоваров.Видимость = ПравоДоступа("Изменение", Метаданные.Документы.ОрдерНаОтражениеПересортицыТоваров);
	
	Элементы.СписокОрдеровСкопировать.Видимость = 
		Элементы.СписокОрдеровСоздатьОрдерНаОтражениеИзлишков.Видимость
		ИЛИ Элементы.СписокОрдеровСоздатьОрдерНаОтражениеНедостач.Видимость
		ИЛИ Элементы.СписокОрдеровСоздатьОрдерНаОтражениеПорчи.Видимость;
	
	Элементы.СписокОрдеровУстановитьПометкуУдаления.Видимость = Элементы.СписокОрдеровСкопировать.Видимость;
	Элементы.СписокОрдеровПровести.Видимость = Элементы.СписокОрдеровСкопировать.Видимость;
	Элементы.СписокОрдеровОтменаПроведения.Видимость = Элементы.СписокОрдеровСкопировать.Видимость;
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокОрдеров.Дата", Элементы.СписокОрдеровДата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Склад = Настройки.Получить("Склад");
	Помещение = Настройки.Получить("Помещение");
	СкладПомещениеПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	СкладПомещениеПриИзмененииСервер();
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	СкладПомещениеПриИзмененииСервер();
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();
КонецПроцедуры

&НаКлиенте
Процедура ПроблемаЕстьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылка = "ЗапуститьФормирование" Тогда
		
		ОчиститьСообщения();
		ЗапуститьФормированиеКорректировок();		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВниманиеНажатие(Элемент)
	ОчиститьСообщения();
	ЗапуститьФормированиеКорректировок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОрдеров

&НаКлиенте
Процедура СписокОрдеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		
		Отказ = Истина;
		
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров"),,,БиблиотекаКартинок.Документ);
		СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров"),,,БиблиотекаКартинок.Документ);
		СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеПересортицыТоваров"),,,БиблиотекаКартинок.Документ);
		
		Если ИспользоватьКачествоТоваров Тогда
			СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров"),,,БиблиотекаКартинок.Документ);
		КонецЕсли;
		
		ВыбранноеЗначение = Неопределено;

		
		СписокЗначений.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("СписокОрдеровПередНачаломДобавленияЗавершение", ЭтотОбъект), НСтр("ru = 'Выбор типа документа'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОрдеровПередНачаломДобавленияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    ВыбранноеЗначение = ВыбранныйЭлемент;
    
    Если ВыбранноеЗначение <> Неопределено Тогда
        СоздатьОрдерКлиент(ВыбранноеЗначение.Значение)
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокОрдеровПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеИзлишков(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеНедостач(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеПересортицыТоваров(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеПересортицыТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеПорчи(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров"));
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокОрдеров);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокОрдеров, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокОрдеров);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПомещениеПриИзмененииСервер()
	Если СкладыСервер.ИспользоватьСкладскиеПомещения(Склад) Тогда
		Элементы.ГруппаПомещение.ТекущаяСтраница = Элементы.СтраницаПомещение;
	Иначе
		Элементы.ГруппаПомещение.ТекущаяСтраница = Элементы.СтраницаПустая;
	КонецЕсли;
	
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОрдеров, "Склад",Склад, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОрдеров, "Помещение",Помещение, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеИзлишковТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеНедостачТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеПересортицыТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеПорчиТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерКлиент(Тип)
	Основание = Новый Структура;
	Основание.Вставить("Склад", Склад);
	Основание.Вставить("Помещение", Помещение);
	
	Если Тип = Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеИзлишковТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	ИначеЕсли Тип = Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеНедостачТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	ИначеЕсли Тип = Тип("ДокументСсылка.ОрдерНаОтражениеПересортицыТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеПересортицыТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	ИначеЕсли Тип = Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеПорчиТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ФоновоеЗаданиеФормированияКорректировок

&НаСервере
Процедура ЗапуститьФормированиеКорректировок()
	
	Помещения = СкладыСервер.ПомещенияПоКоторымНетФоновогоЗаданияФормированияКорректировокИзлишковНедостачПоТоварнымМестам(Склад);
	ЕстьОшибка = Ложь;
	Для Каждого Помещение Из Помещения Цикл
		ЕстьОшибка = СкладыСервер.СформироватьКорректировкиИзлишковНедостачПоТоварнымМестам(Склад, Помещение)
			Или ЕстьОшибка;
	КонецЦикла;
	
	Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = ЕстьОшибка; 	
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольРаботыФоновыхЗаданийФормированияОчереди()
		
	КонтрольРаботыФоновыхЗаданийФормированияОчередиНаСервере();
			
КонецПроцедуры

&НаСервере
Процедура КонтрольРаботыФоновыхЗаданийФормированияОчередиНаСервере()
		
	Помещения = СкладыСервер.ПомещенияПоКоторымНетФоновогоЗаданияФормированияКорректировокИзлишковНедостачПоТоварнымМестам(Склад);
	
	Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = (Помещения.Количество() > 0);
				
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди()
	
	Если Не ИспользоватьАдресноеХранение Тогда
		Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = Ложь;
		ОтключитьОбработчикОжидания("КонтрольРаботыФоновыхЗаданийФормированияОчереди");
		Возврат;
	КонецЕсли; 
	
	КонтрольРаботыФоновыхЗаданийФормированияОчереди();
	ПодключитьОбработчикОжидания("КонтрольРаботыФоновыхЗаданийФормированияОчереди", 600);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
