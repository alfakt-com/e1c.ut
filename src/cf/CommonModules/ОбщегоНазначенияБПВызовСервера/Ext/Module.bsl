﻿#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ДВИЖЕНИЯМИ ДОКУМЕНТОВ


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С УПРАВЛЯЕМЫМИ БЛОКИРОВКАМИ

// Устарела.
// Устанавливает управляемую блокировку таблицы.
//
// Параметры:
//  СтруктураПараметров 		- <Структура>. Структура параметров блокировки. Обязательный параметр.
//								Обязательно должна содержать свойства:
//								"ИмяТаблицы" - <Строка> - имя таблицы, на которую накладывается блокировка.
//									Например: "АвансовыйОтчет"
//								Необязательные свойства:
//								"ТипТаблицы" - <Строка> - тип таблицы, на которую накладывается блокировка.
//									Пространство блокировки состоит из типа таблицы и имени таблицы.
//									Например: "Документ"
//									Значение по умолчанию: "РегистрНакопления"
//								"РежимБлокировки" - <РежимБлокировкиДанных> - режим накладываемой блокировки.
//									Значение по умолчанию: РежимБлокировкиДанных.Исключительный
//								"ИсточникДанных" - источник данных для блокировки.
//									Может передаваться значение любого типа, поддерживаемого свойством ИсточникДанных элемента блокировки,
//									а также типа "Менеджер временных таблиц".
//									Если в структуре нет этого свойства - блокировки через ИспользоватьИзИсточникаДанных() не накладываются.
//								"ИмяВременнойТаблицы" - <Строка> - имя временной таблицы менеджера временных таблиц, которая служит источником данных для блокировки.
//									Обязательно должно указываться, если в качестве источника данных процедуре передан менеджер временных таблиц.
//  КоллекцияЗначенийБлокировки	- <Структура или Соответствие> - описывает значения блокировки, накладываемые с помощью УстановитьЗначение().
//									Ключ - поле блокировки - <Строка или (только для соответствия) ПланыВидовХарактеристикСсылка>,
//										ПланыВидовХарактеристикСсылка используется для блокировки регистра бухгалтерии по виду субконто.
//									Значение - блокируемое значение - <Произвольный тип>.
//									Если передано Неопределено или если коллекция не содержит ни одного элемента -
//									блокировки методом УстановитьЗначение() не накладываются.
//  КоллекцияОписанияИсточника	- <Структура или Соответствие> - описывает значения блокировки, накладываемые с помощью ИспользоватьИзИсточникаДанных().
//									Ключ - поле блокировки - <Строка или (только для соответствия) ПланыВидовХарактеристикСсылка>,
//										ПланыВидовХарактеристикСсылка используется для блокировки регистра бухгалтерии по виду субконто.
//									Значение - поле таблицы источника данных - <Строка>.
//									Если передано Неопределено или если коллекция не содержит ни одного элемента -
//									блокировки методом ИспользоватьИзИсточникаДанных() не накладываются.
//  Отказ 						- <Булево> - при ошибке в процессе установки блокировки в этот параметр процедура возвращает значение Истина.
//  Заголовок 					- <Строка> - заголовок сообщения об ошибке при установке блокировки.
//
Процедура УстановитьУправляемуюБлокировку(СтруктураПараметров, КоллекцияЗначенийБлокировки = Неопределено, КоллекцияОписанияИсточника = Неопределено, Отказ = Ложь, Заголовок = "") Экспорт

	Если НЕ ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	ИспользоватьЗначенияБлокировки = КоллекцияЗначенийБлокировки <> Неопределено
		И (ТипЗнч(КоллекцияЗначенийБлокировки) = Тип("Структура")
			ИЛИ ТипЗнч(КоллекцияЗначенийБлокировки) = Тип("Соответствие"))
		И КоллекцияЗначенийБлокировки.Количество() > 0;

	ИспользоватьИсточникДанных     = КоллекцияОписанияИсточника <> Неопределено
		И (ТипЗнч(КоллекцияОписанияИсточника) = Тип("Структура")
			ИЛИ ТипЗнч(КоллекцияОписанияИсточника) = Тип("Соответствие"))
		И КоллекцияОписанияИсточника.Количество() > 0
		И СтруктураПараметров.Свойство("ИсточникДанных");

	Если НЕ ИспользоватьЗначенияБлокировки И НЕ ИспользоватьИсточникДанных Тогда
		Возврат;
	КонецЕсли;

	Блокировка = Новый БлокировкаДанных;

	ТипТаблицы = ?(СтруктураПараметров.Свойство("ТипТаблицы"), СтруктураПараметров.ТипТаблицы, "РегистрНакопления");
	ИмяТаблицы = СтруктураПараметров.ИмяТаблицы;
	ПространствоБлокировки = ТипТаблицы  + "." + ИмяТаблицы;
	ЭлементБлокировки = Блокировка.Добавить(ПространствоБлокировки);

	РежимБлокировки = ?(СтруктураПараметров.Свойство("РежимБлокировки"), СтруктураПараметров.РежимБлокировки, РежимБлокировкиДанных.Исключительный);
	ЭлементБлокировки.Режим = РежимБлокировки;

	Если ИспользоватьЗначенияБлокировки Тогда

		Для каждого ЭлементКоллекции Из КоллекцияЗначенийБлокировки Цикл

			ЭлементБлокировки.УстановитьЗначение(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);

		КонецЦикла;

	КонецЕсли;

	Если ИспользоватьИсточникДанных Тогда

		ИсточникДанных = СтруктураПараметров.ИсточникДанных;

		Если ТипЗнч(ИсточникДанных) = Тип("МенеджерВременныхТаблиц") Тогда

			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = ИсточникДанных;
			ТекстЗапроса = "";
			Для каждого ЭлементКоллекции Из КоллекцияОписанияИсточника Цикл
				ТекстЗапроса = ТекстЗапроса + ",
				|	Таб." + ЭлементКоллекции.Значение;
			КонецЦикла;
			ТекстЗапроса = Сред(ТекстЗапроса, 2);
			ТекстЗапроса =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ"
			+ ТекстЗапроса + "
			|ИЗ
			|	" + СтруктураПараметров.ИмяВременнойТаблицы + " КАК Таб";
			Запрос.Текст = ТекстЗапроса;
			Результат    = Запрос.Выполнить();

			ЭлементБлокировки.ИсточникДанных = Результат;

		Иначе

			ЭлементБлокировки.ИсточникДанных = ИсточникДанных;

		КонецЕсли;

		Для каждого ЭлементКоллекции Из КоллекцияОписанияИсточника Цикл

			ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);

		КонецЦикла;

	КонецЕсли;

	Блокировка.Заблокировать();

КонецПроцедуры


// Выполняет установку отбора по указанной организации в динамических списках.
// Вызывать необходимо из обработчика формы ПриСозданииНаСервере.
// Если в форму при открытии был передан отбор по организации, то функция не будет выполнена.
//
// Параметры
//  Форма          - УправляемаяФорма  - форма, в которой необходимо установить отбор
//  ИмяСписка      - Строка - имя реквизита формы типа ДинамическийСписок.
//  ИмяРеквизита   - Строка - имя поля-организации в динамическом списке.
//  ЗначениеОтбора - СправочникСсылка.Организации, СписокЗначений, Массив - значение отбора.
//                   Если значение не задано, то будет подставлена основная организация из
//                   настроек пользователя.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации - Если отбор установлен, то вернет значение отбора.
//
Функция УстановитьОтборПоОсновнойОрганизации(Форма, ИмяСписка = "Список", ИмяРеквизита = "Организация", ЗначениеОтбора = Неопределено) Экспорт

	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		
		Если Форма.Параметры.Свойство("Отбор") И Форма.Параметры.Отбор.Свойство(ИмяРеквизита) Тогда
			// Если значение отбора передается в параметрах формы - берем его оттуда, параметр при этом удаляем.
			ОсновнаяОрганизация = Форма.Параметры.Отбор[ИмяРеквизита];
			Форма.Параметры.Отбор.Удалить(ИмяРеквизита);
		ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.Организации") 
			ИЛИ ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") 
			ИЛИ ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
			ОсновнаяОрганизация = ЗначениеОтбора;
		Иначе
			ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		КонецЕсли;
		
		Если ТипЗнч(ОсновнаяОрганизация) = Тип("СправочникСсылка.Организации") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
		Иначе
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
		КонецЕсли;
		
		ИспользованиеОтбора = ЗначениеЗаполнено(ОсновнаяОрганизация);
		
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		
	Иначе
		
		ОсновнаяОрганизация = Справочники.Организации.ПустаяСсылка();
		ВидСравненияОтбора  = ВидСравненияКомпоновкиДанных.Равно;
		ИспользованиеОтбора = Ложь;
		РежимОтображения    = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма[ИмяСписка], ИмяРеквизита, ОсновнаяОрганизация, ВидСравненияОтбора, , ИспользованиеОтбора, РежимОтображения);
	
	Возврат ОсновнаяОрганизация;
	
КонецФункции

// Возвращает структуру данных со сводным описанием контрагента.
//
// Параметры:
//  СписокСведений - список значений со значениями параметров организации.
//   СписокСведений формируется функцией СведенияОЮрФизЛице.
//  Список         - список запрашиваемых параметров организации.
//  СПрефиксом     - Признак выводить или нет префикс параметра организации.
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//
Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) Экспорт

	Возврат БухгалтерскийУчетПереопределяемый.ОписаниеОрганизации(СписокСведений, Список, СПрефиксом);

КонецФункции // ОписаниеОрганизации()

// Проверяет, умещаются ли переданные табличные документы на страницу при печати.
//
// Параметры:
//  ТабДокумент       - ТабличныйДокумент - Табличный документ.
//  ВыводимыеОбласти  - Массив - Массив из проверяемых таблиц или табличный документ.
//  РезультатПриОшибке - Булево - Какой возвращать результат при возникновении ошибки.
//
// Возвращаемое значение:
//   Булево - умещаются или нет переданные документы.
//
Функция ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, РезультатПриОшибке = Истина) Экспорт

	Попытка
		Возврат ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
	Исключение
		ШаблонСообщения = НСтр("ru = 'Невозможно получить информацию о текущем принтере (возможно, в системе не установлено ни одного принтера)
                                |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Проверка вывода на печать'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		Возврат РезультатПриОшибке;
	КонецПопытки;

КонецФункции // ПроверитьВыводТабличногоДокумента()

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ С ОБОСОБЛЕННЫМИ ПОДРАЗДЕЛЕНИЯМИ
//

Процедура ЗаполнитьСписокОрганизаций(ЭлементПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СоответствиеОрганизаций = Новый Структура;
	
	ИспользоватьУправленческуюОрганизацию = БухгалтерскийУчетПереопределяемый.ИспользоватьУправленческуюОрганизацию();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИспользоватьУправленческуюОрганизацию", ИспользоватьУправленческуюОрганизацию);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НаборОрганизаций.Организация КАК Организация,
	|	НаборОрганизаций.ОрганизацияПредставление КАК ОрганизацияПредставление,
	|	НаборОрганизаций.ВключатьОбособленныеПодразделения
	|ИЗ
	|	(ВЫБРАТЬ
	|		Организации.Ссылка КАК Организация,
	|		Организации.Наименование КАК ОрганизацияПредставление,
	|		ЛОЖЬ КАК ВключатьОбособленныеПодразделения
	|	ИЗ
	|		Справочник.Организации КАК Организации
	|	ГДЕ
	|		НЕ Организации.Предопределенный ИЛИ &ИспользоватьУправленческуюОрганизацию
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Организации.ГоловнаяОрганизация,
	|		Организации.ГоловнаяОрганизация.Наименование,
	|		ИСТИНА
	|	ИЗ
	|		Справочник.Организации КАК Организации
	|	ГДЕ
	|		Организации.ОбособленноеПодразделение) КАК НаборОрганизаций
	|УПОРЯДОЧИТЬ ПО
	|	ОрганизацияПредставление";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЭлементПолеОрганизация.СписокВыбора.Очистить();
	МаксКоличествоСимволов = 40;
	Пока Выборка.Следующий() Цикл
		Ключ     = СтрЗаменить(Строка(Выборка.ВключатьОбособленныеПодразделения) + Выборка.Организация.УникальныйИдентификатор(), "-", "");
		Значение = Новый Структура("Организация,ВключатьОбособленныеПодразделения", Выборка.Организация, Выборка.ВключатьОбособленныеПодразделения);
		СоответствиеОрганизаций.Вставить(Ключ, Значение);
		
		Если Выборка.ВключатьОбособленныеПодразделения Тогда
			ОрганизацияПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 с обособленными подразделениями'"),
				Выборка.ОрганизацияПредставление);
		Иначе
			ОрганизацияПредставление = Выборка.ОрганизацияПредставление;
		КонецЕсли;
		
		ЭлементПолеОрганизация.СписокВыбора.Добавить(Ключ, ОрганизацияПредставление);
		
		МаксКоличествоСимволов = Макс(МаксКоличествоСимволов, СтрДлина(ОрганизацияПредставление));
	КонецЦикла;
	
	ЭлементПолеОрганизация.ШиринаСпискаВыбора = Окр(?(МаксКоличествоСимволов > 200, 200, МаксКоличествоСимволов) * 1.3);
	ЭлементПолеОрганизация.ВысотаСпискаВыбора = ?(ЭлементПолеОрганизация.СписокВыбора.Количество() > 15, 15, ЭлементПолеОрганизация.СписокВыбора.Количество());

КонецПроцедуры

// Удаляет повторяющиеся элементы массива.
//
// Параметры:
//  ОбрабатываемыйМассив - Массив - элементы произвольных типов, из которых удаляются неуникальные.
//  НеИспользоватьНеопределено - Булево - если Истина, то все значения Неопределено удаляются из массива.
//  АнализироватьСсылкиКакИдентификаторы - Булево - если Истина, то для ссылок вызывается функция УникальныйИдентификатор()
//                                                  и уникальность определяется по строкам-идентификаторам.
//
// Возвращаемое значение:
//   Массив      - элементы ОбрабатываемыйМассив после удаления лишних.
//
Функция УдалитьПовторяющиесяЭлементыМассива(ОбрабатываемыйМассив, НеИспользоватьНеопределено = Ложь, АнализироватьСсылкиКакИдентификаторы = Ложь) Экспорт

	Если ТипЗнч(ОбрабатываемыйМассив) <> Тип("Массив") Тогда
		Возврат ОбрабатываемыйМассив;
	КонецЕсли;
	
	УжеВМассиве = Новый Соответствие;
	Если АнализироватьСсылкиКакИдентификаторы Тогда   // сравниваем ссылки как строки-уникальные идентификаторы
		
		ОписаниеСсылочныхТипов = ОбщегоНазначения.ОписаниеТипаВсеСсылки();
		
	 	БылоНеопределено = Ложь;
		КоличествоЭлементовВМассиве = ОбрабатываемыйМассив.Количество();

		Для ОбратныйИндекс = 1 По КоличествоЭлементовВМассиве Цикл
			
			ЭлементМассива = ОбрабатываемыйМассив[КоличествоЭлементовВМассиве - ОбратныйИндекс];
			ТипЭлемента = ТипЗнч(ЭлементМассива);
			Если ЭлементМассива = Неопределено Тогда
				Если БылоНеопределено ИЛИ НеИспользоватьНеопределено Тогда
					ОбрабатываемыйМассив.Удалить(КоличествоЭлементовВМассиве - ОбратныйИндекс);
				Иначе
					БылоНеопределено = Истина;
				КонецЕсли;
				Продолжить;
			ИначеЕсли ОписаниеСсылочныхТипов.СодержитТип(ТипЭлемента) Тогда

				ИДЭлемента = Строка(ЭлементМассива.УникальныйИдентификатор());

			Иначе

				ИДЭлемента = ЭлементМассива;

			КонецЕсли;

			Если УжеВМассиве[ИДЭлемента] = Истина Тогда
				ОбрабатываемыйМассив.Удалить(КоличествоЭлементовВМассиве - ОбратныйИндекс);
			Иначе
				УжеВМассиве[ИДЭлемента] = Истина;
			КонецЕсли;
			
		КонецЦикла;

	Иначе
		
		ИндексЭлемента = 0;
		КоличествоЭлементов = ОбрабатываемыйМассив.Количество();
		Пока ИндексЭлемента < КоличествоЭлементов Цикл
			
			ЭлементМассива = ОбрабатываемыйМассив[ИндексЭлемента];
			Если НеИспользоватьНеопределено И ЭлементМассива = Неопределено
			 Или УжеВМассиве[ЭлементМассива] = Истина Тогда      // удаляем, переходя к следующему
			 
				ОбрабатываемыйМассив.Удалить(ИндексЭлемента);
				КоличествоЭлементов = КоличествоЭлементов - 1;
				
			Иначе   // запоминаем, переходя к следующему
				
				УжеВМассиве.Вставить(ЭлементМассива, Истина);
				ИндексЭлемента = ИндексЭлемента + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

	Возврат ОбрабатываемыйМассив;

КонецФункции

#КонецОбласти

