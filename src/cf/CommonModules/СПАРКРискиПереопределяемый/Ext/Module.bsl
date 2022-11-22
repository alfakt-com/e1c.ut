﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРКРиски".
// ОбщийМодуль.СПАРКРискиПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет свойства справочников контрагентов.
// Параметры:
//	СвойстваСправочников - ТаблицаЗначений - в таблице заполняется список
//		справочников контрагентов и их свойства. Колонки таблицы:
//		* Имя - Строка - имя справочника;
//		* Иерархический - Булево - справочник является иерархическим;
//		* РеквизитИНН - Строка- имя реквизита ИНН;
//		* ИмяФормыПодбора - Строка - если для справочника определена собственная
//			форма подбора контрагентов, в этом поле можно указать ее полное имя.
//			Форма должна возвращать в оповещении о выборе Массив ссылок на
//			элементы справочника контрагентов.
//			Если не определена, тогда используется стандартная форма подбора.
//
Процедура ПриОпределенииСвойствСправочниковКонтрагентов(СвойстваСправочников) Экспорт
	
	ОписаниеСправочника = СвойстваСправочников.Добавить();
	ОписаниеСправочника.Иерархический           = Ложь;
	ОписаниеСправочника.Имя                     = "Контрагенты";
	ОписаниеСправочника.РеквизитИНН             = "ИНН";
	
КонецПроцедуры

// В методе заполняется список контрагентов для постановки на мониторинг и для
// снятия с мониторинга.
// Используется регламентным заданием ВсеОбновленияСПАРКРискиРазделенное
// и методом программного интерфейса СПАРКРиски.ЗаполнитьКонтрагентовНаМониторинге().
// При получении списком контрагентов можно использовать обращение к регистру сведений
// КонтрагентыНаМониторингеСПАРКРиски: если запись присутствует в регистре сведений,
// то это означает, что контрагент уже поставлен на мониторинг.
// Допускается обращение к регистру сведений КонтрагентыНаМониторингеСПАРКРиски:
// контрагент уже добавлен в список для мониторинга, если в регистре существует
// запись со значениями измерений:
//	- Контрагент = <Текущий контрагент>;
//	- РучноеДобавление = Ложь.
//
// Параметры:
//	ПоставитьНаМониторинг - Массив - Массив ссылок, в ОпределяемыйТип.КонтрагентБИП -
//		контрагенты для постановки на мониторинг;
//	СнятьСМониторинга - Массив - Массив ссылок, в ОпределяемыйТип.КонтрагентБИП -
//		контрагенты для снятия с мониторинга;
//
Процедура КонтрагентыДляМониторинга(ПоставитьНаМониторинг, СнятьСМониторинга) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипыДоговоровПоставщиков = Новый СписокЗначений;
	ТипыДоговоровПоставщиков.Добавить(Перечисления.ТипыДоговоров.СКомитентом);
	ТипыДоговоровПоставщиков.Добавить(Перечисления.ТипыДоговоров.СПоставщиком);
	ТипыДоговоровПоставщиков.Добавить(Перечисления.ТипыДоговоров.СПереработчиком);
	ТипыДоговоровПоставщиков.Добавить(Перечисления.ТипыДоговоров.СДавальцем);
	ТипыДоговоровПоставщиков.Добавить(Перечисления.ТипыДоговоров.Импорт);
	
	ТипыДоговоровКлиентов = Новый СписокЗначений;
	ТипыДоговоровКлиентов.Добавить(Перечисления.ТипыДоговоров.СПокупателем);
	ТипыДоговоровКлиентов.Добавить(Перечисления.ТипыДоговоров.СКомиссионером);
	ТипыДоговоровКлиентов.Добавить(Перечисления.ТипыДоговоров.СПереработчиком);
	ТипыДоговоровКлиентов.Добавить(Перечисления.ТипыДоговоров.СДавальцем);
	
	АвтоПостановкаКлиентов = Константы.АвтоПостановкаКлиентовНаМониторингСПАРК.Получить();
	АвтоПостановкаПоставщиков = Константы.АвтоПостановкаПоставщиковНаМониторингСПАРК.Получить();
	
	Договоры = Новый ТаблицаЗначений();
	Договоры.Колонки.Добавить("Контрагент", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Если АвтоПостановкаКлиентов Тогда
		Обработки.НастройкаПостановкиКонтрагентовНаМониторингСПАРК.ПолучитьДоговоры(Договоры, ТипыДоговоровКлиентов, 
					Константы.АвтоПостановкаКлиентовНаМониторингСПАРКНастройка.Получить());
	КонецЕсли;
	
	Если АвтоПостановкаПоставщиков Тогда
		Обработки.НастройкаПостановкиКонтрагентовНаМониторингСПАРК.ПолучитьДоговоры(Договоры, ТипыДоговоровПоставщиков, 
					Константы.АвтоПостановкаПоставщиковНаМониторингСПАРКНастройка.Получить());
	КонецЕсли;
	
	Договоры.Свернуть("Контрагент");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договоры", Договоры);
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Закрыт);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтрагентыНаМониторингеСПАРКРиски.Контрагент
	|ПОМЕСТИТЬ КонтрагентыНаМониторинге
	|ИЗ
	|	РегистрСведений.КонтрагентыНаМониторингеСПАРКРиски КАК КонтрагентыНаМониторингеСПАРКРиски
	|ГДЕ
	|	НЕ КонтрагентыНаМониторингеСПАРКРиски.РучноеДобавление
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Контрагент
	|ПОМЕСТИТЬ Договоры
	|ИЗ
	|	&Договоры КАК ДоговорыКонтрагентов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
	|	И Контрагенты.СтранаРегистрации = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|	И НЕ Контрагенты.Ссылка В
	|				(ВЫБРАТЬ
	|					КонтрагентыНаМониторинге.Контрагент.Ссылка
	|				ИЗ
	|					КонтрагентыНаМониторинге КАК КонтрагентыНаМониторинге)
	|	И Контрагенты.Ссылка В
	|				(ВЫБРАТЬ
	|					Договоры.Контрагент
	|				ИЗ
	|					Договоры КАК Договоры)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
	|	И Контрагенты.СтранаРегистрации = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|	И Контрагенты.Ссылка В
	|			(ВЫБРАТЬ
	|				КонтрагентыНаМониторинге.Контрагент.Ссылка
	|			ИЗ
	|				КонтрагентыНаМониторинге КАК КонтрагентыНаМониторинге)
	|	И НЕ Контрагенты.Ссылка В
	|			(ВЫБРАТЬ
	|				Договоры.Контрагент
	|			ИЗ
	|				Договоры КАК Договоры)";
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если НЕ Результат[2].Пустой() Тогда
		ПоставитьНаМониторинг = Результат[2].Выгрузить().ВыгрузитьКолонку("Контрагент");
	КонецЕсли;
	
	Если НЕ Результат[3].Пустой() Тогда
		СнятьСМониторинга = Результат[3].Выгрузить().ВыгрузитьКолонку("Контрагент");
	КонецЕсли;
	
КонецПроцедуры

// Определяет параметры отображения отчетов.
//
// Параметры:
//	ПараметрыОтображения - Структура - параметры отображения отчетов.
//		Поля структуры:
//		* ИмяМакетаОформления - Строка - имя макета оформления отчетов,
//			По умолчанию используются стандартный макет оформления.
//
Процедура ПараметрыОтображенияОтчетов(ПараметрыОтображения) Экспорт
	
	
	
КонецПроцедуры

#Область ИндексыСПАРКРиски

// Вызывается из форм, в которые встроен показ индексов 1СПАРК Риски.
//
// Параметры:
//  Форма                - УправляемаяФорма - форма, в которой инициировано событие;
//  КонтрагентОбъект     - Объект, Неопределено - заполняется в том случае, если форма - это форма элемента справочника,
//                                                а не форма документа.
//  Контрагент           - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  ПараметрыОтображения - Структура - прочие параметры. Возможные ключи:
//    * ВариантОтображения - Строка - см. описание в СПАРКРиски.ОтобразитьИндексыСПАРК.
//  ИспользованиеРазрешено          - Булево - признак разрешения использования функциональности;
//  СтандартнаяОбработкаБиблиотекой - Булево - в этот параметр возвратить Ложь, если надо запретить стандартную
//                                             обработку события библиотекой.
//
Процедура ПриСозданииНаСервере(Форма, КонтрагентОбъект, Контрагент, ПараметрыОтображения, ИспользованиеРазрешено, СтандартнаяОбработкаБиблиотекой) Экспорт



КонецПроцедуры

// Переопределяет время ожидания завершения фонового задания получения индексов СПАРК Риски.
//
// Параметры:
//  ОжидатьЗавершение - Число - значение ключа "ОжидатьЗавершение" для параметра ПараметрыВыполнения.ОжидатьЗавершение
//           процедуры ДлительныеОперации.ВыполнитьВФоне. Если = 0, то не ожидать завершения.
//
Процедура ВремяОжиданияФоновогоЗадания(ОжидатьЗавершение) Экспорт
	
	ОжидатьЗавершение = 0;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИБ

// Вызывается при переходе на версию конфигурации с внедренной подсистемой СПАРКРиски.
// Возвращает параметры, необходимые для начального заполнения данных
// в объектах метаданных подсистемы.
//
// Параметры:
//	ПараметрыЗаполнения - Структура - в параметре возвращаются значения для
//		начального заполнения данных подсистемы.
//		Поля структуры:
//		* ЗапросСвойствКонтрагентов - Строка - текст запроса для получения свойств
//			контрагентов, подлежащих проверке в сервисе 1СПАРК Риски: только
//			юридические лица, не являющиеся иностранными.
//			В запросе должны быть определены колонки:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//			** ИНН - Строка - ИНН контрагента;
//			** СвояОрганизация - Булево - признак того, что контрагент является собственным -
//				дочерним по отношению к организации, в которой ведется учет.
//				Свойство может быть использовано для отбора данных в отчетах;
//			Значение по умолчанию: Неопределено.
//			Если значение свойства Неопределено, будет вызвано исключение.
//			Если значение - пустая строка - получение свойств контрагентов
//			не будет выполнено;
//		* ЗаполнитьКонтрагентовНаМониторинге - Булево - провести заполнение
//			списка контрагентов на мониторинге в соответствии с алгоритмом,
//			определенным в методе КонтрагентыДляМониторинга() текущего модуля.
//			Значение по умолчанию: Ложь;
//		* ЗаполнитьИндексыКонтрагентов - Булево - заполнить значения индексов
//			контрагентов. Истина - заполнить, Ложь - не заполнять.
//			Для заполненных индексов значения будут обновлены при следующем
//			обновлении значений индексов по расписанию (в регламентов).
//			Если индексы не заполнены, тогда контрагенты будут добавляться в
//			список индексов "По требованию";
//			Правило заполнения определяется значением поля
//			ЗапросКонтрагентовДляЗаполненияИндексов.
//		* ЗапросКонтрагентовДляЗаполненияИндексов - Строка - текст запроса для
//			получения контрагентов для заполнения индексов. Используется только
//			при ЗаполнитьИндексыКонтрагентов = Истина.
//			Если значение <Пустая строка>, список индексов будет заполнен
//			всеми контрагентами, полученными при выполнении запроса
//			ЗапросСвойствКонтрагентов, иначе - в соответствии с текстом запроса.
//			Значение по умолчанию: <Пустая строка>.
//			В запросе должна быть определена колонка:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРиски(ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.ЗапросСвойствКонтрагентов =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ИНН
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
	|	И Контрагенты.СтранаРегистрации = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)";
	
	ПараметрыЗаполнения.ЗаполнитьКонтрагентовНаМониторинге = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексыКонтрагентов       = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
