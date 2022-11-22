﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();

	Если НЕ Параметры.Свойство("ИсторияНаименований")
		ИЛИ НЕ Параметры.Свойство("ТекущееНаименованиеПолное") Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЮрФизЛицо = Параметры.ЮрФизЛицо;
	
	ИсторияНаименований.Загрузить(Параметры.ИсторияНаименований.Выгрузить());
	Если ИсторияНаименований.Количество() = 0 Тогда
		ИсторияНаименований.Добавить().НаименованиеПолное = Параметры.ТекущееНаименованиеПолное;
	КонецЕсли;

	СформироватьЗаголовки();
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты) Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		
		Элементы.ФормаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияНаименований);
	
	Если ИсторияНаименований.Количество() > 0 Тогда
		Элементы.ИсторияНаименований.ТекущаяСтрока = ИсторияНаименований[ИсторияНаименований.Количество()-1].ПолучитьИдентификатор();
	КонецЕсли;
	
	КоличествоСтрокИстории = ИсторияНаименований.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И Не ВыполняетсяЗакрытие Тогда
		
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены, перенести изменения?'");
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВопросОПереносеИзмененийПослеОтвета", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыИсторияНаименований

&НаКлиенте
Процедура ИсторияНаименованийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда
			
			НовыйПериод = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			ТекущиеДанные.НачальноеЗначение = Ложь;
			
			// Получим максимальный период в таблице
			ПоследнийПериод = '00010101000000';
			Для Каждого ЗаписьИстории Из ИсторияНаименований Цикл
				Если ЗаписьИстории.Период > ПоследнийПериод Тогда
					ПоследнийПериод = ЗаписьИстории.Период;
				КонецЕсли;
			КонецЦикла;
			
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = НачалоДня(ПоследнийПериод + 60*60*24);
			КонецЕсли;
			
			ТекущиеДанные.Период = НовыйПериод;
			
			ЭтотОбъект.ТекущийЭлемент = Элементы.ИсторияНаименованийНаименованиеПолное;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияНаименований);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПередУдалением(Элемент, Отказ)
	
	Если ИсторияНаименований.Индекс(Элемент.ТекущиеДанные) = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПриИзменении(Элемент)
	КоличествоСтрокИстории = ИсторияНаименований.Количество();
	ОтключитьОтметкуНезаполненного();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПризнакПервоначальногоЗначения(ТаблицаИстории)
	
	ТаблицаИстории.Сортировать("Период");
	Если ТаблицаИстории.Количество() > 0 Тогда
		ПерваяСтрока = ТаблицаИстории[0];
		ПерваяСтрока.НачальноеЗначение = Истина;
		ПерваяСтрока.Период = '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИзменения()
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеИстории(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ИсторияНаименований", ИсторияНаименований);
	
	Закрыть(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеИстории(Отказ)
	
	ОчиститьСообщения();
	
	ПериодыСтрок = Новый Массив;
	
	Если ИсторияНаименований.Количество() = 1
		И ПустаяСтрока(ИсторияНаименований[0].НаименованиеПолное) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Запись Из ИсторияНаименований Цикл
		
		ИндексСтроки = ИсторияНаименований.Индекс(Запись);
		ПрефиксСообщенияСтроки = "ИсторияНаименований["+Формат(ИндексСтроки, "ЧЦ=; ЧДЦ=; ЧГ=")+"].";
		
		Если НЕ ЗначениеЗаполнено(Запись.Период) И ИндексСтроки > 0 Тогда
			СообщениеОбОшибке = НСтр("ru = 'Нужно указать дату начала действия'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если ПериодыСтрок.Найти(Запись.Период) = Неопределено Тогда
			Если ЗначениеЗаполнено(Запись.Период) Тогда
				ПериодыСтрок.Добавить(Запись.Период);
			КонецЕсли;
		Иначе
			СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.НаименованиеПолное) Тогда
			Если ЮрФизлицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо")
				Или ЮрФизлицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель") Тогда
				СообщениеОбОшибке = НСтр("ru = 'Поле ""Фамилия, имя, отчество"" не заполнено'");
			Иначе
				СообщениеОбОшибке = НСтр("ru = 'Поле ""Сокр. юр наименование"" не заполнено'");
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"НаименованиеПолное",  , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПереносеИзмененийПослеОтвета(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПеренестиИзменения();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовки()

	Если ЮрФизлицо = Перечисления.ЮрФизЛицо.ФизЛицо
		Или ЮрФизлицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		
		Заголовок = НСтр("ru = 'История изменения ФИО'");
		Элементы.ИсторияНаименованийНаименованиеПолное.Заголовок = НСтр("ru = 'Фамилия, имя, отчество'");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИсторияНаименованийНаименованиеПолное.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоличествоСтрокИстории");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияНаименований.НаименованиеПолное");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИсторияНаименованийПериод.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияНаименований.НачальноеЗначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеактуальногоСписка);

КонецПроцедуры

#КонецОбласти