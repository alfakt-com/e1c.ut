﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Открывает форму нового, не записанного, элемента справочника "Контрагенты", 
//  заполненного данными из параметра ДанныеЗаполнения.
// Форма должна открываться в модальном режиме или в режиме блокирования окна владельца,
//  так как в форме ЭСФ может быть изменена текущая строка таблицы "Поставщики".
// В качестве владельца формы должно быть указано значение параметра ВладелецФормы.
//
// Параметры:
//  ДанныеЗаполнения - Структура - Данные для заполнения новой формы.
//  ВладелецФормы - Объект, который нужно указать владельцем открываемой формы.
//
Процедура ОткрытьЗаполненнуюФормуНовогоКонтрагента(Знач ДанныеЗаполнения, Знач ВладелецФормы, Оповещение = Неопределено) Экспорт
	
	КонтрагентОснование = Новый Структура;
	КонтрагентОснование.Вставить("Наименование", ДанныеЗаполнения.Наименование);
	КонтрагентОснование.Вставить("СокращенноеНаименование", ДанныеЗаполнения.Наименование);
	КонтрагентОснование.Вставить("ИНН", ДанныеЗаполнения.Идентификатор);
	КонтрагентОснование.Вставить("КБЕ", ДанныеЗаполнения.КБЕ);
	КонтрагентОснование.Вставить("ОбособленноеПодразделение", Ложь);
	
	КонтрагентОснование.Вставить("ЮрФизЛицо", ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо"));
	Если СтрНайти("6", Сред(ДанныеЗаполнения.Идентификатор, 5, 1)) <> 0 Тогда
		КонтрагентОснование.Вставить("ЮрФизЛицо", ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель"));
	ИначеЕсли СтрНайти("0123", Сред(ДанныеЗаполнения.Идентификатор, 5, 1)) <> 0 Тогда
		КонтрагентОснование.Вставить("ЮрФизЛицо", ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"));
	КонецЕсли;
	
	Если СтрНайти("12", Сред(ДанныеЗаполнения.Идентификатор, 6, 1)) <> 0
		И КонтрагентОснование.ЮрФизЛицо <> ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо") Тогда
		КонтрагентОснование.Вставить("ОбособленноеПодразделение", Истина);
	КонецЕсли;
	
	СписокОтборПоТипуПартнера = Новый СписокЗначений;
	СписокОтборПоТипуПартнера.Добавить("Клиент");
	СписокОтборПоТипуПартнера.Добавить("Поставщик");
	
	ПараметрыФормы = Новый Структура("Основание, СписокОтборПоТипуПартнера", КонтрагентОснование, СписокОтборПоТипуПартнера);
	ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового", ПараметрыФормы, ВладелецФормы, , , , Оповещение);
	
КонецПроцедуры

// Открывает форму нового, не записанного, элемента справочника "ДоговорыКонтрагентов".
// Элемент должен быть заполнен по данным параметра ФормаЭСФ.
// В качестве владельца открываемой формы должен быть указан параметр ФормаЭСФ.
//
// Параметры:
//  ФормаЭСФ - УправляемаяФорма - Форма по которой необходимо заполнить новый элемент.
//   Таблица ИмяТаблицыКонтрагентов обязательно содержит хотя бы одну строку.
//   Все поля в колонке ИмяРеквизитаКонтрагента обязательно заполнены.
//  ИмяТаблицыКонтрагентов - Стркоа - Имя таблицы, в которой содержатся контрагенты для создания догвора.
//  ИмяРеквизитаКонтрагента - Стркоа - Имя реквизита, в которой содержатся ссылка на контрагента.
//
Процедура ОткрытьЗаполненнуюФормуНовогоДоговора(Знач ФормаЭСФ, Знач ИмяТаблицыКонтрагентов, Знач ИмяРеквизитаКонтрагента, ДополнительныеПараметры = Неопределено) Экспорт
	
	ФормаДоговора = ПолучитьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", , ФормаЭСФ); 
	
	ЗаполнитьФормуДоговора(ФормаЭСФ, ИмяТаблицыКонтрагентов, ИмяРеквизитаКонтрагента, ФормаДоговора, ДополнительныеПараметры);

	ФормаДоговора.Открыть();
	
КонецПроцедуры

// Открывает форму существующего элемента справочника "ДоговорыКонтрагентов".
// Элемент должен быть заполнен по данным параметра ФормаЭСФ.
// В качестве владельца открываемой формы должен быть указан параметр ФормаЭСФ.
//
// Параметры:
//  ФормаЭСФ - УправляемаяФорма - Форма по которой необходимо перезаполнить существующий элемент.
//   Таблица ИмяТаблицыКонтрагентов обязательно содержит хотя бы одну строку.
//   Все поля в колонке ИмяРеквизитаКонтрагента обязательно заполнены.
//  ИмяТаблицыКонтрагентов - Стркоа - Имя таблицы, в которой содержатся контрагенты для создания догвора.
//  ИмяРеквизитаКонтрагента - Стркоа - Имя реквизита, в которой содержатся ссылка на контрагента.
//
Процедура ОткрытьЗаполненнуюФормуСтарогоДоговора(Знач ФормаЭСФ, Знач ИмяТаблицыКонтрагентов, Знач ИмяРеквизитаКонтрагента, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ФормаЭСФ.Объект.ДоговорПоставки);
	ФормаДоговора = ПолучитьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ФормаЭСФ); 
	
	ЗаполнитьФормуДоговора(ФормаЭСФ, ИмяТаблицыКонтрагентов, ИмяРеквизитаКонтрагента, ФормаДоговора, ДополнительныеПараметры);
	
	ФормаДоговора.Открыть();
	ФормаДоговора.Модифицированность = Истина;
	
КонецПроцедуры

// Открывает форму нового, не записанного, товара, 
//  заполненного данными из СтрокаТовары.
// Форма должна открываться в модальном режиме или в режиме блокирования окна владельца,
//  так как в форме ЭСФ может быть изменена текущая строка таблицы "Товары".
// В качестве владельца формы должно быть указано значение параметра ФормаЭСФ.
//
// Параметры:
//  ФормаЭСФ - УправляемаяФорма - Форма по которой необходимо создать товар.
//  СтрокаТовары - ДанныеФормыЭлементКоллекции - Строка таблицы товары,
//   по данным которой необходимо создать новый товар.
//
Процедура ОткрытьЗаполненнуюФормуНовогоТовара(Знач ФормаЭСФ, Знач СтрокаТовары) Экспорт
	
	ТекстКомментария = ЭСФКлиентСервер.ТекстКомментарияСозданПоДаннымЭСФ(ФормаЭСФ.Объект.Ссылка);
	
	ФормаТовара = ПолучитьФорму("Справочник.Номенклатура.ФормаОбъекта", , ФормаЭСФ);
	Объект = ?(ЭСФКлиентСервер.ЭтоОбычнаяФорма(ФормаТовара), ФормаТовара, ФормаТовара.Объект);
	
	Объект.Наименование = СтрокаТовары.ТоварНаименование;
	Объект.ЕдиницаИзмерения = СтрокаТовары.ЕдиницаИзмерения;
	Объект.Описание = ТекстКомментария;
	Объект.НаименованиеПолное = СтрокаТовары.ТоварНаименование;
	Объект.СтавкаНДС = СтрокаТовары.СтавкаНДС;
	Объект.КодТНВЭД = ЭСФВызовСервера.ПолучитьКодТНВЭДВызовСервера(СтрокаТовары.КодТНВЭД);
	Если ЗначениеЗаполнено(СтрокаТовары.СтавкаАкциза) Тогда
		Объект.ПодакцизныйТовар = Истина;
	КонецЕсли;
	
	ФормаТовара.Открыть();
	
КонецПроцедуры

Процедура ОткрытьЗаполненнуюФормуНовогоТовараЗавершение(ВыбранныйТипТовара, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры		

Процедура ЗаполнитьФормуДоговора(Знач ФормаЭСФ, Знач ИмяТаблицыКонтрагентов, Знач ИмяРеквизитаКонтрагента, ФормаДоговора, ДополнительныеПараметры = Неопределено)
	
	Объект = ?(ЭСФКлиентСервер.ЭтоОбычнаяФорма(ФормаДоговора), ФормаДоговора, ФормаДоговора.Объект);
	
	Объект.Наименование = ЭСФКлиентСервер.НаименованиеДоговора(ФормаЭСФ.Объект);
	Объект.НаименованиеДляПечати = Объект.Наименование;
	Объект.Контрагент = ФормаЭСФ.Объект[ИмяТаблицыКонтрагентов][0][ИмяРеквизитаКонтрагента];
	Объект.Партнер = ЭСФВызовСервера.ПолучитьЗначениеРеквизита(Объект.Контрагент, "Партнер");
	Объект.ВалютаВзаиморасчетов = ФормаЭСФ.Объект.Валюта;
	Если НЕ ЗначениеЗаполнено(Объект.ПорядокРасчетов) Тогда
		Объект.ПорядокРасчетов = ПредопределенноеЗначение("Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ПорядокОплаты) Тогда
		Объект.ПорядокОплаты = ПредопределенноеЗначение("Перечисление.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях");
	КонецЕсли;
	
	Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует");
	
	ТекстКомментария = ЭСФКлиентСервер.ТекстКомментарияСозданПоДаннымЭСФ(ФормаЭСФ.Объект.Ссылка);
	Объект.Комментарий = ТекстКомментария;
	
	Объект.Организация = ФормаЭСФ.Объект.Организация;
	
	Если ФормаЭСФ.Объект.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Входящий") Тогда
		Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоставщиком");
	Иначе
		Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПокупателем");
	КонецЕсли;
	
	Объект.Номер = ФормаЭСФ.Объект.ДоговорПоставкиНомер;
	Объект.Дата = ФормаЭСФ.Объект.ДоговорПоставкиДата;
	
КонецПроцедуры

Процедура ОткрытьФормуПечати(ТабличныйДокумент, МассивДокументов) Экспорт
	
КонецПроцедуры

// Создает новый сторнирующий документ,
// заполняет его на основании счета-фактуры,
// открывает форму созданного сторнирующего документа.
//
// Параметры:
//  СчетФактура - ДокументОбъект.СчетФактураВыданный, ДокументОбъект.СчетФактураПолученный -
//   Счет-фактура, для которого необходимо создать сторнирующий документ.
//
Процедура ОткрытьФормуНовогоСторнирующегоДокумента(Знач СчетФактура) Экспорт

КонецПроцедуры

// Открывает форму выбора выданного или полученного счета-фактуры.
// Используется в команде "Выбрать счет-фактуру", подменю "Отражение в учете".
// Обработка выбора выполняется в форме ЭСФ и не требует переопределения.
//
// Параметры:
//  ФормаЭСФ - УправляемаяФорма - Форма документа ЭСФ, 
//   из которой открывается форма выбора счета-фактуры.
//  ТипСчетаФактуры - Тип - Используется для определения того,
//   какую форму открыть: полученных или выданных счетов-фактур.
//
Процедура ОткрытьФормуВыбораСчетаФактуры(Знач ФормаЭСФ, Знач ТипСчетаФактуры) Экспорт
	
	// Сформировать отбор формы выбора.
	Отбор = Новый Структура;
	
	Отбор.Вставить("Организация", ФормаЭСФ.Объект.Организация);
	Если ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
		Отбор.Вставить("СтруктурноеПодразделение", ФормаЭСФ.Объект.СтруктурноеПодразделение);
	КонецЕсли;
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;

	//Устанавливаем отбор по контрагенту
	Если ТипСчетаФактуры = ЭСФКлиентСерверПереопределяемый.ТипДокументСсылкаСчетФактураПолученный() Тогда
		Если ЗначениеЗаполнено(ФормаЭСФ.Объект.Поставщики) Тогда
			ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Контрагент", ФормаЭСФ.Объект.Поставщики[0].Поставщик);
		КонецЕсли;	
	Иначе
		Если ЗначениеЗаполнено(ФормаЭСФ.Объект.Получатели) Тогда
			ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Контрагент", ФормаЭСФ.Объект.Получатели[0].Получатель);
		КонецЕсли;
	КонецЕсли;
	
	// Получить имя формы выбора.
	Если ТипСчетаФактуры = ЭСФКлиентСерверПереопределяемый.ТипДокументСсылкаСчетФактураВыданный() Тогда
		ИмяФормыВыбора = "Документ.СчетФактураВыданный.ФормаВыбора";
	Иначе
		ИмяФормыВыбора = "Документ.СчетФактураПолученный.ФормаВыбора";
	КонецЕсли;
	
	// Открыть форму выбора с отбором.
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);		
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ФормаЭСФ, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму выбора номера ГТД при нажатии на кнопку выбора
// в поле "Номер ГТД", таблицы "Товары", документа "ЭСФ".
Процедура ТоварыНомерГТДНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

Процедура ОбработкаОповещенияЭСФ_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр) Экспорт

	Если Параметр = Неопределено
		ИЛИ НЕ ТипЗнч(Параметр) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	РезультатРаботыЗадания = Параметр;
	
	Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		
		АдресСообщенияПользователю = ЭСФВызовСервера.СообщенияФоновогоЗадания(РезультатРаботыЗадания.ИдентификаторЗадания);
		СообщенияПользователю = ПолучитьИзВременногоХранилища(АдресСообщенияПользователю);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ЭСФКлиент.ОповеститьФормы(ЭСФКлиентСервер.ИмяСобытияЗаписьЭСФ(), Параметр, ЭтаФорма);
		ДополнительныеОповещения = ?(Параметр.Свойство("ДополнительныеОповещения"), Параметр.ДополнительныеОповещения, Новый Структура);
		Для Каждого ДополнительноеОповещение Из ДополнительныеОповещения Цикл
			ЭСФКлиент.ОповеститьФормы(ДополнительноеОповещение.Ключ, Параметр, ЭтаФорма);
		КонецЦикла;			
	Иначе
	
		ПараметрыДлительнойОперации = Новый Структура;
		ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания");
		ПараметрыДлительнойОперации.Вставить("ВыводитьОкноОжидания", Истина);
		//ПараметрыДлительнойОперации.Вставить("ВыводитьПрогрессВыполнения", Истина);
		ПараметрыДлительнойОперации.Вставить("АдресРезультата", РезультатРаботыЗадания.АдресХранилища);
		ПараметрыДлительнойОперации.Вставить("ВыводитьСообщения", Истина);
		
		Если РезультатРаботыЗадания.Свойство("ТекстСообщения") Тогда
			ПараметрыДлительнойОперации.Вставить("ТекстСообщения", РезультатРаботыЗадания.ТекстСообщения);
		КонецЕсли;
		
		ПараметрыДлительнойОперации.ИдентификаторЗадания = РезультатРаботыЗадания.ИдентификаторЗадания;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповеститьОЗавершениияДлительнойОперацииЭСФ", ЭСФКлиентПереопределяемый, ЭтаФорма);
		
		ОткрытьФорму("Обработка.ОбменЭСФ.Форма.ДлительнаяОперация", ПараметрыДлительнойОперации, ЭтаФорма,,,, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповеститьОЗавершениияДлительнойОперацииЭСФ(Результат, Источник) Экспорт

	Оповестить(ЭСФКлиентСервер.ИмяСобытияЗаписьЭСФ(), Результат, Источник);
	
КонецПроцедуры

// Открывает форму обновления компоненты при обновлении на релиз типового решения
Процедура ОткрытьФормуОбновленияКриптобиблиотеки() Экспорт
	
	ОткрытьФорму("Обработка.ОбменЭСФ.Форма.ОбновлениеКомпонентыКриптографии");
	
КонецПроцедуры

Процедура ОткрытьФормуВыбораКлассификатора(СтруктураПараметров, Элемент, УдалятьПрефиксМакета = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", ?(УдалятьПрефиксМакета,(СтрЗаменить(СтруктураПараметров.ИмяМакета, "ПФ_MXL_", "")), СтруктураПараметров.ИмяМакета));
	ПараметрыФормы.Вставить("ИмяСекции", СтруктураПараметров.ИмяСекции);
	//ПараметрыФормы.Вставить("ИмяОбъекта", СтруктураПараметров.ИмяОбъекта);
	//ПараметрыФормы.Вставить("ТипОбъекта", СтруктураПараметров.ТипОбъекта);
	ПараметрыФормы.Вставить("ПолучатьПолныеДанные", Ложь);
	ПараметрыФормы.Вставить("ТекущийКодСтроки"	 , ?(НЕ ЗначениеЗаполнено(СтруктураПараметров.ТекущийКодСтроки), Неопределено, СокрЛП(СтруктураПараметров.ТекущийКодСтроки)));
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзКлассификатора", ПараметрыФормы, Элемент, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры	

Процедура УстановитьПредставлениеСпособаОбменаПриПолученииДанных(Знач ЭтоСчетФактураВыданный, Знач СписокСчетовФактур, ОформленияСтрок) Экспорт
	
КонецПроцедуры	

Функция ИмяДокументаПоступленияТоваровУслуг() Экспорт 
	Возврат "Приобретение товаров и услуг";
КонецФункции	

Процедура УстановитьОграничениеТипаЕдиницыИзмерения(Форма, СтрокаТабличнойЧасти) Экспорт
	
КонецПроцедуры