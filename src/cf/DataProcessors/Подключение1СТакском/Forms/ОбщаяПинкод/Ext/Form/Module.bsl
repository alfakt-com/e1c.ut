﻿
#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение формы необходимыми параметрами.
	ЗаполнитьФорму();
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаПоясненияЗаголовкаПинКод.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаЗаполненияКонтентаПинКод.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаКартинкиКонтентаПинКод.Отображение   = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ПрограммноеЗакрытие Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходаПользователяПинКодНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеЗаголовкаПинКодОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ЛогинПользователя = Подключение1СТакскомКлиентСервер.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"login");
		
		ТекстСообщения =
			НСтр("ru = 'Не получается зарегистрировать программный продукт.
				|
				|Пинкод: %1.'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			Элементы.ПинКодЗначение.ТекстРедактирования);
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Регистрация продукта.'"),
			ТекстСообщения,
			,
			,
			Новый Структура("Логин, Пароль",
				ЛогинПользователя,
				Подключение1СТакскомКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "backRegistration", "true"));
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПинКод(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "regnumber", РегистрационныйНомерПинКод));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "pincode", СтрЗаменить(ПинКод, "-", "")));
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет начальное заполнение полей формы
&НаСервере
Процедура ЗаполнитьФорму()
	
	ЗаголовокПользователя = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	Элементы.НадписьЛогинаПользователяПинКод.Заголовок = ЗаголовокПользователя;
	РегистрационныйНомерПинКод = Параметры.regNumber;
	ПинКод                     = Параметры.pincode;
	
КонецПроцедуры

// Выполняет проверку заполненности полей РегНомер и ПинКод
//
// Возвращаемое значение: Булево. Истина - поля заполнены Некорректно,
//		Ложь - в противном случае.
//
&НаКлиенте
Функция ЗаполнениеПолейКорректно()
	
	Результат = Истина;
	
	Если ПустаяСтрока(РегистрационныйНомерПинКод) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено поле ""Регистрационный номер""'");
		Сообщение.Поле  = "РегистрационныйНомерПинКод";
		Сообщение.Сообщить();
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ПинКод) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено поле ""Пинкод""'");
		Сообщение.Поле  = "ПинКод";
		Сообщение.Сообщить();
		
		Результат = Ложь;
		
	КонецЕсли;
	
	ПинКодСтр = СтрЗаменить(СтрЗаменить(ПинКод, "-", ""), " ", "");
	Если СтрДлина(ПинКодСтр) <> 16 Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Пин-код должен состоять из 16 цифр.'");
		Сообщение.Поле  = "ПинКод";
		Сообщение.Сообщить();
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
