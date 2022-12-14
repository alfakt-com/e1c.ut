
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 64 Цикл
		СписокПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;
	
	СписокМодель = Элементы.Модель.СписокВыбора;
	СписокМодель.Добавить(0, "DSP860");
	СписокМодель.Добавить(1, "DSP850B");
	СписокМодель.Добавить(2, "DSP840");
	СписокМодель.Добавить(3, "DSP820");
	СписокМодель.Добавить(4, "Firich FV2029");
	
	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(9600,  "9600");

	времПорт     = Неопределено;
	времСкорость = Неопределено;
	времМодель   = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Порт",     времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость", времСкорость);
	Параметры.ПараметрыОборудования.Свойство("Модель",   времМодель);
	
	Порт     = ?(времПорт     = Неопределено,    1, времПорт);
	Скорость = ?(времСкорость = Неопределено, 9600, времСкорость);
	Модель   = ?(времМодель   = Неопределено,    0, времМодель);
	
	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	УстановитьДоступностьЭлементов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"     , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость" , Скорость);
	НовыеЗначениеПараметров.Вставить("Модель"   , Модель);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	ОчиститьСообщения();

	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"						, Порт);
	времПараметрыУстройства.Вставить("Скорость"       			, Скорость);
	времПараметрыУстройства.Вставить("Четность"					, 0);
	времПараметрыУстройства.Вставить("БитыДанных"				, 8);
	времПараметрыУстройства.Вставить("СтопБиты"					, 1);
	времПараметрыУстройства.Вставить("Модель"					, Модель);
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
		                           "");


		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	Элементы.Порт.Доступность              = Истина;
	Элементы.Скорость.Доступность          = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           			, Порт);
	времПараметрыУстройства.Вставить("Скорость"       			, Скорость);
	времПараметрыУстройства.Вставить("Четность"					, 0);
	времПараметрыУстройства.Вставить("БитыДанных"				, 8);
	времПараметрыУстройства.Вставить("СтопБиты"					, 1);
	времПараметрыУстройства.Вставить("Модель"					, Модель);
	
	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры

#КонецОбласти