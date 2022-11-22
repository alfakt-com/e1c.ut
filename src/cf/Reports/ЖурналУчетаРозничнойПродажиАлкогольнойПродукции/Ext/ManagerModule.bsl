﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет формирование отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - Параметры отчета.
//  АдресХранилища - Строка - Адрес во временном хранилище.
//
Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ДатаНачалаИспользованияНовойФормыЖурнала = Константы.ДатаНачалаПримененияПриказа164.Получить();
	ДатаНачала = НачалоДня(ПараметрыОтчета.НачалоПериода);
	ДатаОкончания = КонецДня(ПараметрыОтчета.КонецПериода);
	
	МассивНастроек = Новый Массив;
	
	Если ДатаНачала >= ДатаНачалаИспользованияНовойФормыЖурнала Тогда
		
		Настройки = Новый Структура();
		Настройки.Вставить("ДатаНачала", ДатаНачала);
		Настройки.Вставить("ДатаОкончания", ДатаОкончания);
		Настройки.Вставить("НовыйФормат", Истина);
		Настройки.Вставить("Макет", Отчеты.ЖурналУчетаРозничнойПродажиАлкогольнойПродукции.ПолучитьМакет("ПФ_MXL_164"));
		Настройки.Вставить("ПараметрыОтчета", ПараметрыОтчета);
		
		МассивНастроек.Добавить(Настройки);
		
	ИначеЕсли ДатаОкончания < ДатаНачалаИспользованияНовойФормыЖурнала Тогда
		
		Настройки = Новый Структура();
		Настройки.Вставить("ДатаНачала", ДатаНачала);
		Настройки.Вставить("ДатаОкончания", ДатаОкончания);
		Настройки.Вставить("НовыйФормат", Ложь);
		Настройки.Вставить("Макет", Отчеты.ЖурналУчетаРозничнойПродажиАлкогольнойПродукции.ПолучитьМакет("Макет"));
		Настройки.Вставить("ПараметрыОтчета", ПараметрыОтчета);
		
		МассивНастроек.Добавить(Настройки);
		
	Иначе
		
		Настройки = Новый Структура();
		Настройки.Вставить("ДатаНачала", ДатаНачала);
		Настройки.Вставить("ДатаОкончания", ДатаНачалаИспользованияНовойФормыЖурнала - 86400);
		Настройки.Вставить("НовыйФормат", Ложь);
		Настройки.Вставить("Макет", Отчеты.ЖурналУчетаРозничнойПродажиАлкогольнойПродукции.ПолучитьМакет("Макет"));
		Настройки.Вставить("ПараметрыОтчета", ПараметрыОтчета);
		
		МассивНастроек.Добавить(Настройки);
		
		Настройки = Новый Структура();
		Настройки.Вставить("ДатаНачала", ДатаНачалаИспользованияНовойФормыЖурнала);
		Настройки.Вставить("ДатаОкончания", ДатаОкончания);
		Настройки.Вставить("НовыйФормат", Истина);
		Настройки.Вставить("Макет", Отчеты.ЖурналУчетаРозничнойПродажиАлкогольнойПродукции.ПолучитьМакет("ПФ_MXL_164"));
		Настройки.Вставить("ПараметрыОтчета", ПараметрыОтчета);
		
		МассивНастроек.Добавить(Настройки);
		
	КонецЕсли;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ВыводитьГоризонтальныйРазделительСтраниц = Ложь;
	
	Для Каждого Настройка Из МассивНастроек Цикл
		
		Если ВыводитьГоризонтальныйРазделительСтраниц Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		Если ПараметрыОтчета.ВыводитьЗаголовок Тогда
			ВывестиТитульныйЛист(ПараметрыОтчета, ТабличныйДокумент, Настройка);
		КонецЕсли;
		
		Если Настройка.НовыйФормат Тогда
			ЗаполнитьФормат164(ТабличныйДокумент, Настройка);
		Иначе
			ЗаполнитьСтарыйФормат(ТабличныйДокумент, Настройка);
		КонецЕсли;
		
		Если ПараметрыОтчета.ВыводитьПодвал Тогда
			БухгалтерскиеОтчетыВызовСервера.ВывестиПодвалОтчета(ПараметрыОтчета, Неопределено, ТабличныйДокумент);
		КонецЕсли;
		
		ВыводитьГоризонтальныйРазделительСтраниц = Истина;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТабличныйДокумент, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтарыйФормат(ТабличныйДокумент, Настройка)
	
	Макет = Настройка.Макет;
	ПараметрыОтчета = Настройка.ПараметрыОтчета;
	
	// Выведем заголовок
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, Настройка.ДатаОкончания);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Область(11, , 11, );
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",               ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("ОрганизацияНаименование",   СведенияОбОрганизации.ПолноеНаименование);
	Запрос.УстановитьПараметр("ОрганизацияИНН",            СведенияОбОрганизации.Инн);
	Запрос.УстановитьПараметр("Склад",                     ПараметрыОтчета.Склад);
	Запрос.УстановитьПараметр("ДатаНач",                   Настройка.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон",                   Настройка.ДатаОкончания);
	Запрос.УстановитьПараметр("ГраницаДатаКон",            Новый Граница(КонецДня(Настройка.ДатаОкончания), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ТипЗапасовСобственныйТовар",Перечисления.ТипыЗапасов.Товар);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	Номенклатура.ОбъемДАЛ * 10 КАК Емкость,
	|	Номенклатура.ОбъемДАЛ КАК КоэффПересчетаДал,
	|	ВидыАлкогольнойПродукции.Наименование КАК ВидПродукции,
	|	ВидыАлкогольнойПродукции.Код КАК КодВидаПродукции
	|ПОМЕСТИТЬ АлкогольнаяПродукция
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО (ВидыАлкогольнойПродукции.Ссылка = Номенклатура.ВидАлкогольнойПродукции)
	|ГДЕ
	|	Номенклатура.АлкогольнаяПродукция
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	|	ДанныеДокумента.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	ДанныеДокумента.Контрагент КАК Поставщик,
	|	ДанныеДокумента.Контрагент.ИНН КАК ПоставщикИНН
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Товары.Склад = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.ДатаВходящегоДокумента,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.Контрагент,
	|	ДанныеДокумента.Контрагент.ИНН
	|ИЗ
	|	Документ.КорректировкаПриобретения КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения.Расхождения КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Расхождения.Склад = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.ДатаВходящегоДокумента,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.Контрагент,
	|	ДанныеДокумента.Контрагент.ИНН
	|ИЗ
	|	Документ.ВозвратТоваровОтКлиента КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтКлиента.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Склад = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.ДатаВходящегоДокумента,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Организация.ИНН
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаТоваровМеждуОрганизациями.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Склад = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Номер,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Организация.ИНН
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.СкладПолучатель = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Номер,
	|	ДанныеДокумента.ОрганизацияПолучатель,
	|	ДанныеДокумента.ОрганизацияПолучатель.ИНН
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.ОрганизацияПолучатель = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.СкладПолучатель = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.ДатаВходящегоДокумента,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Организация.ИНН
	|ИЗ
	|	Документ.ВозвратТоваровМеждуОрганизациями КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровМеждуОрганизациями.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Склад = &Склад)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Номер,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Организация
	|		ИНАЧЕ ДанныеДокумента.Контрагент
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Организация.ИНН
	|		ИНАЧЕ ДанныеДокумента.Контрагент.ИНН
	|	КОНЕЦ
	|ИЗ
	|	Документ.ВводОстатков КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводОстатков.Товары КАК ДанныеДокументаТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|			ПО ДанныеДокументаТовары.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|		ПО (ДанныеДокументаТовары.Ссылка = ДанныеДокумента.Ссылка)
	|			И (ДанныеДокумента.Организация = &Организация)
	|			И (ДанныеДокумента.Дата >= &ДатаНач)
	|			И (ДанныеДокумента.Дата <= &ДатаКон)
	|			И (ДанныеДокумента.Проведен)
	|ГДЕ
	|	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ДанныеДокумента.Склад = &Склад)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОрганизацийОбороты.Период КАК Период,
	|	АлкогольнаяПродукция.Номенклатура КАК Номенклатура,
	|	АлкогольнаяПродукция.ВидПродукции КАК ВидПродукции,
	|	АлкогольнаяПродукция.КодВидаПродукции КАК КодВидаПоступление,
	|	ЕСТЬNULL(ДанныеДокументов.Поставщик, &ОрганизацияНаименование) КАК Поставщик,
	|	ЕСТЬNULL(ДанныеДокументов.ПоставщикИНН, &ОрганизацияИНН) КАК ИНН,
	|	ЕСТЬNULL(ДанныеДокументов.НомерВходящегоДокумента, """") КАК НомерТТН,
	|	ЕСТЬNULL(ДанныеДокументов.ДатаВходящегоДокумента, ТоварыОрганизацийОбороты.Период) КАК ДатаТТН,
	|	АлкогольнаяПродукция.Емкость КАК ЕмкостьПоступление,
	|	СУММА(ТоварыОрганизацийОбороты.КоличествоПриход) КАК КоличествоПоступление,
	|	СУММА(ТоварыОрганизацийОбороты.КоличествоПриход * АлкогольнаяПродукция.КоэффПересчетаДал) КАК ОбъемПоступление,
	|	ТоварыОрганизацийОбороты.Регистратор КАК ДокументПоступление,
	|	NULL КАК ДокументРасход,
	|	NULL КАК СодержаниеРасход,
	|	0 КАК ЕмкостьРасход,
	|	0 КАК КоличествоРасход,
	|	0 КАК ОбъемРасход,
	|	АлкогольнаяПродукция.Номенклатура.НаименованиеПолное КАК НоменклатураНаименованиеПолное 
	|ИЗ
	|	АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций.Обороты(
	|				&ДатаНач,
	|				&ГраницаДатаКон,
	|				Регистратор,
	|				Организация = &Организация
	|					И ВидЗапасов.ТипЗапасов = &ТипЗапасовСобственныйТовар
	|					И &Условие) КАК ТоварыОрганизацийОбороты
	|		ПО (ТоварыОрганизацийОбороты.АналитикаУчетаНоменклатуры.Номенклатура = АлкогольнаяПродукция.Номенклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДокументов КАК ДанныеДокументов
	|		ПО (ДанныеДокументов.Ссылка = ТоварыОрганизацийОбороты.Регистратор)
	|ГДЕ
	|	ТоварыОрганизацийОбороты.КоличествоПриход <> 0
	|	И НЕ ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ТаможеннаяДекларацияИмпорт
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыОрганизацийОбороты.Период,
	|	ТоварыОрганизацийОбороты.Регистратор,
	|	АлкогольнаяПродукция.ВидПродукции,
	|	АлкогольнаяПродукция.КодВидаПродукции,
	|	АлкогольнаяПродукция.Номенклатура,
	|	АлкогольнаяПродукция.Емкость,
	|	ЕСТЬNULL(ДанныеДокументов.НомерВходящегоДокумента, """"),
	|	ЕСТЬNULL(ДанныеДокументов.ДатаВходящегоДокумента, ТоварыОрганизацийОбороты.Период),
	|	ЕСТЬNULL(ДанныеДокументов.Поставщик, &ОрганизацияНаименование),
	|	ЕСТЬNULL(ДанныеДокументов.ПоставщикИНН, &ОрганизацияИНН)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыОрганизацийОбороты.Период,
	|	АлкогольнаяПродукция.Номенклатура,
	|	АлкогольнаяПродукция.ВидПродукции,
	|	АлкогольнаяПродукция.КодВидаПродукции,
	|	ЕСТЬNULL(ДанныеДокументов.Поставщик, &ОрганизацияНаименование),
	|	ЕСТЬNULL(ДанныеДокументов.ПоставщикИНН, &ОрганизацияИНН),
	|	ЕСТЬNULL(ДанныеДокументов.НомерВходящегоДокумента, """"),
	|	ЕСТЬNULL(ДанныеДокументов.ДатаВходящегоДокумента, ТоварыОрганизацийОбороты.Период),
	|	АлкогольнаяПродукция.Емкость,
	|	СУММА(ТоварыОрганизацийОбороты.КоличествоПриход),
	|	СУММА(ТоварыОрганизацийОбороты.КоличествоПриход * АлкогольнаяПродукция.КоэффПересчетаДал),
	|	ТоварыОрганизацийОбороты.Регистратор,
	|	NULL,
	|	NULL,
	|	0,
	|	0,
	|	0,
	|	АлкогольнаяПродукция.Номенклатура.НаименованиеПолное
	|ИЗ
	|	АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Обороты(
	|				&ДатаНач,
	|				&ГраницаДатаКон,
	|				Регистратор,
	|				Организация = &Организация
	|					И ВидЗапасов.ТипЗапасов = &ТипЗапасовСобственныйТовар
	|					И &Условие) КАК ТоварыОрганизацийОбороты
	|		ПО (ТоварыОрганизацийОбороты.АналитикаУчетаНоменклатуры.Номенклатура = АлкогольнаяПродукция.Номенклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДокументов КАК ДанныеДокументов
	|		ПО (ДанныеДокументов.Ссылка = ТоварыОрганизацийОбороты.Регистратор)
	|ГДЕ
	|	ТоварыОрганизацийОбороты.КоличествоПриход <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыОрганизацийОбороты.Период,
	|	ТоварыОрганизацийОбороты.Регистратор,
	|	АлкогольнаяПродукция.ВидПродукции,
	|	АлкогольнаяПродукция.КодВидаПродукции,
	|	АлкогольнаяПродукция.Номенклатура,
	|	ТоварыОрганизацийОбороты.ВидЗапасов,
	|	АлкогольнаяПродукция.Емкость,
	|	ЕСТЬNULL(ДанныеДокументов.НомерВходящегоДокумента, """"),
	|	ЕСТЬNULL(ДанныеДокументов.ДатаВходящегоДокумента, ТоварыОрганизацийОбороты.Период),
	|	ЕСТЬNULL(ДанныеДокументов.Поставщик, &ОрганизацияНаименование),
	|	ЕСТЬNULL(ДанныеДокументов.ПоставщикИНН, &ОрганизацияИНН)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыОрганизацийОбороты.Период,
	|	АлкогольнаяПродукция.Номенклатура,
	|	АлкогольнаяПродукция.ВидПродукции,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	0,
	|	0,
	|	0,
	|	ТоварыОрганизацийОбороты.Регистратор,
	|	ВЫБОР
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|			ТОГДА &ПроданнаяПродукция
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ВозвратТоваровПоставщику
	|			ТОГДА &ПродукцияВозвращеннаяПоставщику
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.СписаниеНедостачТоваров
	|			ТОГДА &НедостачиПродукции
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТоваров
	|			ТОГДА &ПродукцияПереданнаяВДругоеПодразделение
	|		ИНАЧЕ &СписаннаяПродукция
	|	КОНЕЦ,
	|	АлкогольнаяПродукция.Емкость,
	|	СУММА(ТоварыОрганизацийОбороты.КоличествоРасход),
	|	СУММА(ТоварыОрганизацийОбороты.КоличествоРасход * АлкогольнаяПродукция.КоэффПересчетаДал),
	|	АлкогольнаяПродукция.Номенклатура.НаименованиеПолное
	|ИЗ
	|	АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций.Обороты(
	|				&ДатаНач,
	|				&ГраницаДатаКон,
	|				Регистратор,
	|				Организация = &Организация
	|					И ВидЗапасов.ТипЗапасов = &ТипЗапасовСобственныйТовар
	|					И &Условие) КАК ТоварыОрганизацийОбороты
	|		ПО (ТоварыОрганизацийОбороты.АналитикаУчетаНоменклатуры.Номенклатура = АлкогольнаяПродукция.Номенклатура)
	|ГДЕ
	|	ТоварыОрганизацийОбороты.КоличествоРасход <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыОрганизацийОбороты.Период,
	|	ТоварыОрганизацийОбороты.Регистратор,
	|	АлкогольнаяПродукция.ВидПродукции,
	|	АлкогольнаяПродукция.Номенклатура,
	|	АлкогольнаяПродукция.Емкость,
	|	ВЫБОР
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|			ТОГДА &ПроданнаяПродукция
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ВозвратТоваровПоставщику
	|			ТОГДА &ПродукцияВозвращеннаяПоставщику
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.СписаниеНедостачТоваров
	|			ТОГДА &НедостачиПродукции
	|		КОГДА ТоварыОрганизацийОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТоваров
	|			ТОГДА &ПродукцияПереданнаяВДругоеПодразделение
	|		ИНАЧЕ &СписаннаяПродукция
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &Условие", ?(ЗначениеЗаполнено(ПараметрыОтчета.Склад), "И АналитикаУчетаНоменклатуры.Склад = &Склад", ""));

	Запрос.УстановитьПараметр("ПроданнаяПродукция", НСтр("ru='Проданная продукция'"));
	Запрос.УстановитьПараметр("ПродукцияВозвращеннаяПоставщику", НСтр("ru='Продукция, возвращенная поставщику'"));
	Запрос.УстановитьПараметр("НедостачиПродукции", НСтр("ru='Недостачи продукции'"));
	Запрос.УстановитьПараметр("ПродукцияПереданнаяВДругоеПодразделение", НСтр("ru='Продукция, переданная в другое подразделение'"));
	Запрос.УстановитьПараметр("СписаннаяПродукция", НСтр("ru='Списанная продукция'"));
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	
	НомерСтроки 			= 1;
	ОбъемПоступление		= 0;
	ОбъемРасход 			= 0;
	КоличествоПоступление	= 0;
	КоличествоРасход		= 0;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");

	Пока Результат.Следующий() Цикл
		
		ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
		ОбластьМакета.Параметры.Заполнить(Результат);
		
		ПродукцияНаименование = НСтр("ru = '%ВидПродукции% (%Номенклатура%)'");
		ПродукцияНаименование = СтрЗаменить(ПродукцияНаименование, "%ВидПродукции%", Результат.ВидПродукции); 
		ПродукцияНаименование = СтрЗаменить(ПродукцияНаименование, "%Номенклатура%", Результат.НоменклатураНаименованиеПолное); 
		
		Если ЗначениеЗаполнено(Результат.КоличествоПоступление) Тогда
			ОбластьМакета.Параметры.ВидПродукцииПоступление = ПродукцияНаименование;
			ОбластьМакета.Параметры.ВидПродукцииРасход      = "";
		Иначе
			ОбластьМакета.Параметры.ВидПродукцииПоступление = "";
			ОбластьМакета.Параметры.ВидПродукцииРасход      = ПродукцияНаименование;
		КонецЕсли;
	
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбъемПоступление 		= ОбъемПоступление + Результат.ОбъемПоступление;
		ОбъемРасход 			= ОбъемРасход + Результат.ОбъемРасход;
		КоличествоПоступление 	= КоличествоПоступление + Результат.КоличествоПоступление;
		КоличествоРасход 		= КоличествоРасход + Результат.КоличествоРасход;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
	
	ОбластьМакета.Параметры.ОбъемПоступление 		= ОбъемПоступление;
	ОбластьМакета.Параметры.ОбъемРасход 			= ОбъемРасход;
	ОбластьМакета.Параметры.КоличествоПоступление 	= КоличествоПоступление;
	ОбластьМакета.Параметры.КоличествоРасход 		= КоличествоРасход;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

Процедура ЗаполнитьФормат164(ТабличныйДокумент, Настройка)
	
	Макет = Настройка.Макет;
	
	ПараметрыОтчета = Настройка.ПараметрыОтчета;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Область(11, , 11, );
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",               ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("Склад",                     ПараметрыОтчета.Склад);
	Запрос.УстановитьПараметр("ДатаНач",                   Настройка.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон",                   Настройка.ДатаОкончания);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	Номенклатура.ОбъемДАЛ * 10 КАК Емкость,
	|	Номенклатура.НаименованиеПолное КАК НаименованиеПродукции,
	|	ВидыАлкогольнойПродукции.Код КАК КодВидаПродукции
	|ПОМЕСТИТЬ АлкогольнаяПродукция
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО (ВидыАлкогольнойПродукции.Ссылка = Номенклатура.ВидАлкогольнойПродукции)
	|ГДЕ
	|	Номенклатура.АлкогольнаяПродукция
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыручкаОбороты.Период КАК ДатаПродажи,
	|	АлкогольнаяПродукция.НаименованиеПродукции КАК НаименованиеПродукции,
	|	АлкогольнаяПродукция.КодВидаПродукции КАК КодВидаПродукции,
	|	АлкогольнаяПродукция.Емкость КАК Емкость,
	|	ВыручкаОбороты.КоличествоОборот КАК Количество
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж.Обороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			День,
	|			АналитикаУчетаНоменклатуры.Склад = &Склад
	|				И АналитикаУчетаПоПартнерам.Организация = &Организация
	|				И АналитикаУчетаНоменклатуры.Номенклатура В
	|					(ВЫБРАТЬ
	|						Т.Номенклатура
	|					ИЗ
	|						АлкогольнаяПродукция КАК Т)) КАК ВыручкаОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|		ПО ВыручкаОбороты.АналитикаУчетаНоменклатуры.Номенклатура = АлкогольнаяПродукция.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПродажи";
		
		
	УстановитьПривилегированныйРежим(Истина);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Период = Выгрузка.Скопировать(,"ДатаПродажи");
	Период.Свернуть("ДатаПродажи");
	
	НомерСтроки = 0;
	
	Для Каждого День Из Период Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");

		СтрокиДня = Выгрузка.Скопировать(Новый Структура("ДатаПродажи", День.ДатаПродажи));
	
		Для Каждого ТекСтрока Из СтрокиДня Цикл
			
			Если ЗначениеЗаполнено(ТекСтрока.НаименованиеПродукции) Тогда
				ТекСтрока.НаименованиеПродукции = СокрЛП(ТекСтрока.НаименованиеПродукции);
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		ИтогиПоКоду = СтрокиДня.Скопировать();
		ИтогиПоКоду.Свернуть("КодВидаПродукции", "Количество");
		Для Каждого ТекСтрока Из ИтогиПоКоду Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогиПоКоду");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ИтогиПоНаименованию = СтрокиДня.Скопировать();
		ИтогиПоНаименованию.Свернуть("НаименованиеПродукции", "Количество");
		Для Каждого ТекСтрока Из ИтогиПоНаименованию Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогиПоНаименованию");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогиПоКоличеству");
		ОбластьМакета.Параметры.Количество = СтрокиДня.Итог("Количество");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиТитульныйЛист(ПараметрыОтчета, Результат, Настройка)
	
	ДатаНачала = Настройка.ДатаНачала;
	ДатаОкончания = Настройка.ДатаОкончания;
	
	ОбластьОрганизация = Настройка.Макет.ПолучитьОбласть("ТитульныйЛист");
	
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	ОбластьОрганизация.Параметры.ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	Если Не Настройка.НовыйФормат Тогда
		// Организация
		Если ЗначениеЗаполнено(ПараметрыОтчета.Склад) Тогда
			ОбластьОрганизация.Параметры.Подразделение = ПараметрыОтчета.Склад;
		ИначеЕсли ЗначениеЗаполнено(ПараметрыОтчета.Подразделение) Тогда
			ОбластьОрганизация.Параметры.Подразделение = ПараметрыОтчета.Подразделение;
		КонецЕсли;
	Иначе
		СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, ДатаОкончания);
		АдресСклада = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ПараметрыОтчета.Склад, Справочники.ВидыКонтактнойИнформации.АдресСклада);
		
		ОбластьОрганизация.Параметры.ИННКПП = СведенияОбОрганизации.ИНН + ?(ПараметрыОтчета.Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо,
			" / " + СведенияОбОрганизации.КПП,
			"");
			
		ОбластьОрганизация.Параметры.Адрес = АдресСклада;
	КонецЕсли;
		
	Результат.Вывести(ОбластьОрганизация);
	Результат.ВывестиГоризонтальныйРазделительСтраниц();
	
	Результат.Область("R1:R" + Формат(Результат.ВысотаТаблицы,"ЧГ=0")).Имя = "ТитульныйЛист";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли