﻿#Область ОбработчикСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	времТокен  = Неопределено;
	времМагазин = Неопределено;
	времМагазинПредставление = Неопределено;
	времТерминал = Неопределено;
	времТерминалПредставление = Неопределено;
	времПериодВыгрузки = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Токен", времТокен);
	Параметры.ПараметрыОборудования.Свойство("Магазин", времМагазинПредставление);
	Параметры.ПараметрыОборудования.Свойство("МагазинЗначение", времМагазин);
	Параметры.ПараметрыОборудования.Свойство("Терминал", времТерминалПредставление);
	Параметры.ПараметрыОборудования.Свойство("ТерминалЗначение", времТерминал);
	Параметры.ПараметрыОборудования.Свойство("ПериодВыгрузки", времПериодВыгрузки);
	
	Токен = ?(времТокен = Неопределено, "", времТокен);
	МагазинЗначение = ?(времМагазин = Неопределено, "", времМагазин);
	ТерминалЗначение = ?(времТерминал = Неопределено, "", времТерминал);
	Если Не ЗначениеЗаполнено(времПериодВыгрузки) Тогда
		ПериодВыгрузки = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	Иначе
		ПериодВыгрузки = времПериодВыгрузки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(времМагазин) Тогда
		Магазин = Элементы.Магазин.СписокВыбора.Добавить(времМагазин, времМагазинПредставление);
	Иначе
		Магазин = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(времТерминал) Тогда
		Терминал = Элементы.Терминал.СписокВыбора.Добавить(времТерминал, времТерминалПредставление);
	Иначе
		Терминал = "";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Токен) Тогда 
		Элементы.Магазин.Доступность = Ложь;
		Элементы.Терминал.Доступность = Ложь;
	КонецЕсли;
	
	МенеджерОфлайнОборудованияПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСозданииНаСервере(ЭтотОбъект, Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Токен) Тогда
		ПолучитьДанныеОбУстройстве();
	КонецЕсли;
	
#Если ВебКлиент Тогда
	Оповещение = Новый ОписаниеОповещения("ПроверкаРасширенияРаботыСФайлами", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	СтандартнаяОбработка = Ложь;
#КонецЕсли
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриОткрытии(ЭтотОбъект, Идентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		НовыеЗначениеПараметров = Новый Структура;
		НовыеЗначениеПараметров.Вставить("Токен", Токен);
		НовыеЗначениеПараметров.Вставить("МагазинЗначение", МагазинЗначение);
		НовыеЗначениеПараметров.Вставить("ТерминалЗначение", ТерминалЗначение);
		НовыеЗначениеПараметров.Вставить("Магазин", Магазин);
		НовыеЗначениеПараметров.Вставить("Терминал", Терминал);
		НовыеЗначениеПараметров.Вставить("ПериодВыгрузки", ПериодВыгрузки);
		
		ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE");
		НовыеЗначениеПараметров.Вставить("ВидТранспортаОфлайнОбмена", ВидОбмена);
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор"        , Идентификатор);
		Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
		
		МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСохраненииПараметров(ЭтотОбъект,
			Идентификатор,
			НовыеЗначениеПараметров
		);
		
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		ВходныеПараметры = Неопределено;
		ВыходныеПараметры = Неопределено;
	
		ПоддержкаАсинхронногоРежима = ОфлайнОборудование1СЭвоторКлиент.ПоддержкаАсинхронногоРежима();
		ПараметрыУстройства = Новый Структура;
		ПараметрыУстройства.Вставить("Токен", Токен);
		ПараметрыУстройства.Вставить("Идентификатор", Идентификатор);
		ПараметрыУстройства.Вставить("Команда", "ТестУстройства");
		ПараметрыУстройства.Вставить("ПоддержкаАсинхронногоРежима", ПоддержкаАсинхронногоРежима);
		
		ПараметрыПодключения = Новый Структура;
		ПараметрыПодключения.Вставить("ТипОборудования", "ККМOffline");
	
		Если ПоддержкаАсинхронногоРежима Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ТестУстройстваЗавершение", ЭтотОбъект, ПараметрыУстройства);
			ОфлайнОборудование1СЭвоторКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, "ТестУстройства", ВходныеПараметры, Идентификатор, ПараметрыУстройства, ПараметрыПодключения);
		Иначе
			Результат = ОфлайнОборудование1СЭвоторКлиент.ВыполнитьКоманду("ТестУстройства", ВходныеПараметры, ВыходныеПараметры, Идентификатор, ПараметрыУстройства, ПараметрыПодключения);
			РезультатСтруктура = Новый Структура;
			РезультатСтруктура.Вставить("Результат", Результат);
			РезультатСтруктура.Вставить("ВыходныеПараметры", ВыходныеПараметры);
			ТестУстройстваЗавершение(РезультатСтруктура, ПараметрыУстройства);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТокенПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(Токен) Тогда
		Элементы.Магазин.Доступность = Истина;
		Элементы.Терминал.Доступность = Истина;
		ПолучитьДанныеОбУстройстве();
	Иначе
		Элементы.Магазин.Доступность = Ложь;
		Элементы.Терминал.Доступность = Ложь;
		МагазинЗначение = "";
		ТерминалЗначение = "";
		Магазин = "";
		Терминал = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МагазинОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Значение = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	Магазин = Значение.Представление;
	МагазинЗначение = ВыбранноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура ТерминалОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Значение = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	Терминал = Значение.Представление;
	ТерминалЗначение = ВыбранноеЗначение;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСписокВыбора(Результат, ПараметрыУстройства) Экспорт
	
	Данные = Результат.ВыходныеПараметры;
	
	Если Не Результат.Результат Тогда
		ТекстСообщения = НСтр("ru='По введенному токену нет данных для заполнения. Проверьте корректность введенного токена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Элементы.Магазин.СписокВыбора.Очистить();
		Элементы.Магазин.Доступность = Ложь;
		МагазинЗначение = "";
		Магазин = "";
		Элементы.Терминал.СписокВыбора.Очистить();
		Элементы.Терминал.Доступность = Ложь;
		ТерминалЗначение = "";
		Терминал = "";
		КорректностьТокена = Ложь;
	Иначе
		КорректностьТокена = Истина;
		Если ПараметрыУстройства.Команда = "ЗагрузитьМагазины" Тогда
			
			Для Каждого Элемент Из Данные Цикл
				НаименованиеМагазина = Элемент.name + " " + Элемент.address;
				УИДМагазина = Элемент.uuid;
				Если Элементы.Магазин.СписокВыбора.НайтиПоЗначению(УИДМагазина) = Неопределено Тогда
					Элементы.Магазин.СписокВыбора.Добавить(УИДМагазина, НаименованиеМагазина);
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ПараметрыУстройства.Команда = "ЗагрузитьТерминалы" Тогда
			Для Каждого Элемент Из Данные Цикл
				НаименованиеТерминала = Элемент.name;
				УИДТерминала = Элемент.uuid;
				Если Элементы.Терминал.СписокВыбора.НайтиПоЗначению(УИДТерминала) = Неопределено Тогда
					Элементы.Терминал.СписокВыбора.Добавить(УИДТерминала, НаименованиеТерминала);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеОбУстройстве()
	
	ВходныеПараметры = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	ПоддержкаАсинхронногоРежима = ОфлайнОборудование1СЭвоторКлиент.ПоддержкаАсинхронногоРежима();
	ПараметрыУстройства = Новый Структура;
	ПараметрыУстройства.Вставить("Токен", Токен);
	ПараметрыУстройства.Вставить("Идентификатор", Идентификатор);
	ПараметрыУстройства.Вставить("Команда", "ЗагрузитьМагазины");
	ПараметрыУстройства.Вставить("ПоддержкаАсинхронногоРежима", ПоддержкаАсинхронногоРежима);
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("ТипОборудования", "ККМOffline");
	
	Если ПоддержкаАсинхронногоРежима Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьСписокВыбора", ЭтотОбъект, ПараметрыУстройства);
		ОфлайнОборудование1СЭвоторКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, "ЗагрузитьМагазины", ВходныеПараметры, Идентификатор, ПараметрыУстройства, ПараметрыПодключения);
		
		Если КорректностьТокена Тогда
			ПараметрыУстройства.Команда = "ЗагрузитьТерминалы";
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьСписокВыбора", ЭтотОбъект, ПараметрыУстройства);
			ОфлайнОборудование1СЭвоторКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, "ЗагрузитьТерминалы", ВходныеПараметры, Идентификатор, ПараметрыУстройства, ПараметрыПодключения);
		КонецЕсли;
	Иначе
		Результат = ОфлайнОборудование1СЭвоторКлиент.ВыполнитьКоманду("ЗагрузитьМагазины", ВходныеПараметры, ВыходныеПараметры, Идентификатор, ПараметрыУстройства, ПараметрыПодключения);
		РезультатСтруктура = Новый Структура;
		РезультатСтруктура.Вставить("Результат", Результат);
		РезультатСтруктура.Вставить("ВыходныеПараметры", ВыходныеПараметры);
		ЗаполнитьСписокВыбора(РезультатСтруктура, ПараметрыУстройства);
		
		Если КорректностьТокена Тогда
			ПараметрыУстройства.Команда = "ЗагрузитьТерминалы";
			Результат = ОфлайнОборудование1СЭвоторКлиент.ВыполнитьКоманду("ЗагрузитьТерминалы", ВходныеПараметры, ВыходныеПараметры, Идентификатор, ПараметрыУстройства, ПараметрыПодключения);
			РезультатСтруктура = Новый Структура;
			РезультатСтруктура.Вставить("Результат", Результат);
			РезультатСтруктура.Вставить("ВыходныеПараметры", ВыходныеПараметры);
			ЗаполнитьСписокВыбора(РезультатСтруктура, ПараметрыУстройства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройстваЗавершение(Результат, ПараметрыУстройства) Экспорт
	
	Если Результат.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Тест не пройден.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаРасширенияРаботыСФайлами(Установлено, ДополнительныеПараметры) Экспорт
	
	Если Не Установлено Тогда
		Оповещение = Новый ОписаниеОповещения("УстановкаРасширенияРаботыСФайлами", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru='Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаРасширенияРаботыСФайлами(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
