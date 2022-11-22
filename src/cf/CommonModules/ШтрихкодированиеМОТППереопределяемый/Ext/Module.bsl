﻿
//В процедуре необходимо реализовать заполнение таблицы "ОстаткиМаркируемойПродукции". На основании данных таблицы
//будет происходить контроль остатков, если в параметрах сканирования будет заполнено свойство 
//"ОперацияКонтроляАкцизныхМарок" значением  "Продажа" или "Возврат". Первая продажа или возврат контролю не подлежит.
//Если сформирован документ продажи - контроля выполнено не будет, даже если по данным таблицы
//"ОстаткиМаркируемойПродукции" марки нет в наличии. Повторно выполнить продажу той же марки система не даст.
//Если процедура не будет заполнена - никакого контроля выполняться не будет.
// 
// Параметры:
//  ОстаткиМаркируемойПродукции - (См. ШтрихкодированиеМОТП.ИнициализацияТаблицыПроверкиОстатков).
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
Процедура ПриОпределенииОстатковМаркируемойПродукции(ОстаткиМаркируемойПродукции, ПараметрыСканирования) Экспорт
	
	//++ НЕ ГОСИС
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаркируемаяПродукция.ШтрихкодУпаковки КАК ШтрихкодУпаковки,
	|	МаркируемаяПродукция.Доступно         КАК Доступно
	|ПОМЕСТИТЬ ВТМаркируемаяПродукция
	|ИЗ
	|	&МаркируемаяПродукция КАК МаркируемаяПродукция
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ШтрихкодУпаковки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекККМАкцизныеМарки.АкцизнаяМарка  КАК ШтрихкодУпаковки,
	|	-1                                 КАК Доступно
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ЧекККМАкцизныеМарки.АкцизнаяМарка
	|ГДЕ
	|	ЧекККМАкцизныеМарки.Ссылка.Организация = &Организация
	|	И ЧекККМАкцизныеМарки.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтчетОРозничныхПродажахАкцизныеМарки.АкцизнаяМарка,
	|	-1
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.АкцизныеМарки КАК ОтчетОРозничныхПродажахАкцизныеМарки
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ОтчетОРозничныхПродажахАкцизныеМарки.АкцизнаяМарка
	|ГДЕ
	|	ОтчетОРозничныхПродажахАкцизныеМарки.Ссылка.Организация = &Организация
	|	И ОтчетОРозничныхПродажахАкцизныеМарки.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровОтКлиентаШтрихкодыУпаковок.ШтрихкодУпаковки,
	|	1
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтКлиента.ШтрихкодыУпаковок КАК
	|			ВозвратТоваровОтКлиентаШтрихкодыУпаковок
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ВозвратТоваровОтКлиентаШтрихкодыУпаковок.ШтрихкодУпаковки
	|ГДЕ
	|	ВозвратТоваровОтКлиентаШтрихкодыУпаковок.Ссылка.Организация = &Организация
	|	И ВозвратТоваровОтКлиентаШтрихкодыУпаковок.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТМаркируемаяПродукция.ШтрихкодУпаковки,
	|	ВТМаркируемаяПродукция.Доступно
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.ШтрихкодУпаковки       КАК ШтрихкодУпаковки,
	|	СУММА(ДанныеДокументов.Доступно)        КАК Доступно
	|ИЗ
	|	ДанныеДокументов КАК ДанныеДокументов
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.ШтрихкодУпаковки";
	
	Запрос.УстановитьПараметр("Организация",          ПараметрыСканирования.Организация);
	Запрос.УстановитьПараметр("МаркируемаяПродукция", ОстаткиМаркируемойПродукции);
	
	ОстаткиМаркируемойПродукции = Запрос.Выполнить().Выгрузить();
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо определить необходимость запроса МРЦ для номенклатуры в системе МОТП.
// 
// Параметры:
//  Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура.
//  ТребуетсяЗапрос - Истина, если для номенклатуры требуется запрашивать МРЦ в системе МОТП.
Процедура ПриОпределенииНеобходимостиЗапросаМРЦ(Номенклатура, ТребуетсяЗапрос) Экспорт
	
	//++ НЕ ГОСИС
	ТребуетсяЗапрос = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВидНоменклатуры.ИспользоватьМРЦМОТПСерии");
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры