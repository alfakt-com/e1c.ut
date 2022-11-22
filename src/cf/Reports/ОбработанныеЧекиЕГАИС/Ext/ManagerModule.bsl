﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки – Коллекция – Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета – СтрокаДереваЗначений – Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); 
// Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	
	НастройкиВарианта.ФункциональныеОпции.Добавить("ВестиСведенияДляДекларацийПоАлкогольнойПродукции");
	НастройкиВарианта.ВидимостьПоУмолчанию = Истина;
	НастройкиВарианта.Описание = НСтр("ru='Количество отправленных в ЕГАИС чеков за выбранный период.'");
	
	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ИнтеграцияЕГАИС.Подсистемы.ОтчетыЕГАИС);
	
КонецПроцедуры

// Возвращает внешний набор данных для построения отчета.
//
// Параметры:
//  СписокОтчетов - Массив - массив документов ОтчетЕГАИС.
//
// Возвращаемое значение:
//  ТаблицаЗначений - внешний набор данных.
//
Функция ДанныеИнформационнойБазы(СписокОтчетов) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ОрганизацияЕГАИС"    , Новый ОписаниеТипов("СправочникСсылка.КлассификаторОрганизацийЕГАИС"));
	Результат.Колонки.Добавить("АлкогольнаяПродукция", Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));
	Результат.Колонки.Добавить("Период"              , Новый ОписаниеТипов("Дата"));
	Результат.Колонки.Добавить("ЧековПродаж"         , Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("ЧековНаВозврат"      , Новый ОписаниеТипов("Число"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОтчетЕГАИС", СписокОтчетов);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетЕГАИС.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ОтчетЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	НАЧАЛОПЕРИОДА(ОтчетЕГАИС.Период, МЕСЯЦ) КАК Период
	|ИЗ
	|	Документ.ОтчетЕГАИС КАК ОтчетЕГАИС
	|ГДЕ
	|	ОтчетЕГАИС.Ссылка В(&ОтчетЕГАИС)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
	КонецЦикла;
	
	ОтчетыЕГАИСПереопределяемый.ЗаполнитьКоличествоЧековПродаж(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает Истина в случае наличия расхождений между полученными данными и данными ИБ. Ложь - в противном случае.
//
Функция ЕстьРасхожденияВПолученныхДанных(ДокументСсылка) Экспорт
	
	Возврат ОтчетыЕГАИС.ЕстьРасхожденияВПолученныхДанных(ДокументСсылка, Метаданные.Отчеты.ОбработанныеЧекиЕГАИС.Имя);
	
КонецФункции

#КонецОбласти

#КонецЕсли