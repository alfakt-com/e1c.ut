﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.Валюты.РежимВыбора = Параметры.РежимВыбора;
	
	ДатаКурса = НачалоДня(ТекущаяДатаСеанса());
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ДатаКурса", ДатаКурса);
	
	ИзменяемыеПоля = Новый Массив;
	ИзменяемыеПоля.Добавить("Курс");
	ИзменяемыеПоля.Добавить("Кратность");
	Список.УстановитьОграниченияИспользованияВГруппировке(ИзменяемыеПоля);
	Список.УстановитьОграниченияИспользованияВПорядке(ИзменяемыеПоля);
	Список.УстановитьОграниченияИспользованияВОтборе(ИзменяемыеПоля);
	
	ДоступноИзменениеВалют = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.КурсыВалют);
	ДоступнаЗагрузкаКурсов = Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено И ДоступноИзменениеВалют;
	
	Элементы.ФормаПодборИзКлассификатора.Видимость = ДоступнаЗагрузкаКурсов;
	Элементы.ФормаЗагрузитьКурсыВалют.Видимость = ДоступнаЗагрузкаКурсов;
	Если Не ДоступнаЗагрузкаКурсов Тогда
		Если ДоступноИзменениеВалют Тогда
			Элементы.СоздатьВалюту.Заголовок = НСтр("ru = 'Создать'");
		КонецЕсли;
		Элементы.Создать.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Элементы.Валюты.ИзменятьСоставСтрок = Ложь;
		Элементы.ФормаПодборИзКлассификатора.Видимость = Ложь;
		Элементы.ФормаЗагрузитьКурсыВалют.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Элементы.Валюты.Обновить();
	Элементы.Валюты.ТекущаяСтрока = РезультатВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КурсыВалют"
		Или ИмяСобытия = "Запись_ЗагрузкаКурсовВалют" Тогда
		Элементы.Валюты.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВалюты

&НаСервереБезКонтекста
Процедура ВалютыПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Перем ДатаКурса;
	
	Если Не Настройки.ДополнительныеСвойства.Свойство("ДатаКурса", ДатаКурса) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КурсыВалют.Валюта КАК Валюта,
		|	КурсыВалют.Курс КАК Курс,
		|	КурсыВалют.Кратность КАК Кратность
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&КонецПериода, Валюта В (&Валюты)) КАК КурсыВалют";
	Запрос.УстановитьПараметр("Валюты", Строки.ПолучитьКлючи());
	Запрос.УстановитьПараметр("КонецПериода", ДатаКурса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаСписка = Строки[Выборка.Валюта];
		СтрокаСписка.Данные["Курс"] = Выборка.Курс;
		Если Выборка.Кратность <> 1 Тогда 
			Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'тг. за %1 %2'"), 
				Выборка.Кратность, СтрокаСписка.Данные["Наименование"]);
			СтрокаСписка.Данные["Кратность"] = Пояснение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ИмяФормыПодбора = "Обработка.ЗагрузкаКурсовВалют.Форма.ПодборВалютИзКлассификатора";
	ОткрытьФорму(ИмяФормыПодбора, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	
	ИмяФормыЗагрузки = "Обработка.ЗагрузкаКурсовВалют.Форма";
	ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	ОткрытьФорму(ИмяФормыЗагрузки, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
