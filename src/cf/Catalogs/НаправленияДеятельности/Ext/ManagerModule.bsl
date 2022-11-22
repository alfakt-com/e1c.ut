﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//  Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("УчетДоходов");
	Результат.Добавить("УчетЗатрат");
	Результат.Добавить("УчетВнеоборотныхАктивов");
	Результат.Добавить("УчетДенежныхСредств;ГруппаУчетДС");
	Результат.Добавить("ДопускаетсяОбособлениеСверхПотребности");
	Результат.Добавить("НалогообложениеНДС;НалогообложениеНДС");
	Результат.Добавить("НалогообложениеНДСОпределяетсяВДокументе;РежимНалогообложенияОпределяетсяЗначением,РежимНалогообложенияОпределяетсяВДокументе");
	Возврат Результат;
	
КонецФункции

// Возвращеат признак ведения учета по направлениям деятельности
//
Функция ИспользуетсяУчетПоНаправлениям() Экспорт
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности")
			ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности")
			ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетДСпоНаправлениямДеятельностиРаздельно")
			ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетДСпоНаправлениямДеятельностиПоКорреспонденции");
КонецФункции

// Определяет обязательность указания направления деятельности для заданного раздела учета.
// Если во всех созданых направлениях есть хотя бы один сброшенный флаг заданного раздела,
// то указывать направление деятельности необязательно.
// Иначе если во всех направлениях все флаги заданного раздела взведены, то указание направления обязательно.
//
// Параметры:
//  ИмяРазделаУчета - Строка - Возможные значения:
//                             "УчетДоходов"
//                             "УчетЗатрат"
//                             "УчетДенежныхСредствРаздельно"
//                             "УчетДенежныхСредствПоКорреспонденции"
//                             "УчетВнеоборотныхАктивов".
//
// Возвращаемое значение:
//  Истина - если указание направления деятельности обязательно.
//
Функция ОбязательноеУказаниеНаправленияДеятельности(ИмяРазделаУчета) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает структуру целевых параметров контракта ГОЗ
//
// Возвращаемое значение
// 	ЦелевыеПраметры - Структура - Целевые параметры контракта.
// 
Функция СтруктураЦелевыхПараметровКонтрактаГОЗ() Экспорт
	
	ЦелевыеПараметры = Новый Структура;
	ЦелевыеПараметры.Вставить("ДатаЗавершения");
	ЦелевыеПараметры.Вставить("ОбъемФинансированияКонтракта");
	ЦелевыеПараметры.Вставить("СуммаНДС");
	ЦелевыеПараметры.Вставить("ЗатратыНаМатериалы");
	ЦелевыеПараметры.Вставить("ЗатратыНаОплатуТруда");
	ЦелевыеПараметры.Вставить("ПрочиеПроизводственныеЗатраты");
	ЦелевыеПараметры.Вставить("ОбщепроизводственныеЗатраты");
	ЦелевыеПараметры.Вставить("ОбщехозяйственныеЗатраты");
	ЦелевыеПараметры.Вставить("КоммерческиеРасходы");
	ЦелевыеПараметры.Вставить("ПрибыльКонтракта");
	ЦелевыеПараметры.Вставить("УправленческиеРасходы");
	
	Возврат ЦелевыеПараметры;
	
КонецФункции

// Возвращает целевые параметры контракта ГОЗ
//
// Параметры:
// 	НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - Направление деятельности контракта ГОЗ.
//
// Возвращаемое значение:
// 	ЦелевыеПараметры - Структура - Целевые параметры контракта ГОЗ.
//
Функция ЦелевыеПараметрыКонтрактаГОЗ(НаправлениеДеятельности) Экспорт
	
	СтруктураЦелевыхПараметров = СтруктураЦелевыхПараметровКонтрактаГОЗ();
	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НаправлениеДеятельности, СтруктураЦелевыхПараметров);
	Результат.Вставить("Затраты", 
		Результат.ЗатратыНаМатериалы 
		+ Результат.ЗатратыНаОплатуТруда
		+ Результат.ПрочиеПроизводственныеЗатраты
		+ Результат.ОбщепроизводственныеЗатраты
		+ Результат.ОбщехозяйственныеЗатраты);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Назначения

// Возврашает шаблон для генерации назначения товаров в документе.
//
// Параметры:
// 		Объект - СправочникОбъект.НаправленияДеятельности, ДанныеФормыСтруктура - направление деятельности, по которому необходимо получить шаблон назначения.
//
// Возвращаемое значение:
// 		Структура - (см. функцию Справочники.Назначения.ШаблонНового).
//
Функция ШаблонНазначения(Объект) Экспорт
	
	ШаблонНазначения = Справочники.Назначения.ШаблонНового();
	
	Если Объект.УчетЗатрат Тогда
		
		ШаблонНазначения.НаправлениеДеятельности = Объект.Ссылка;
		
	КонецЕсли;
	
	Возврат ШаблонНазначения;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляГенерацииНазначений(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаОбъекта.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НаправленияДеятельности КАК ТаблицаОбъекта
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|		ПО ТаблицаОбъекта.Ссылка = Назначения.НаправлениеДеятельности
	|			И Назначения.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			И Назначения.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|			И Назначения.Заказ = НЕОПРЕДЕЛЕНО
	|ГДЕ
	|	ТаблицаОбъекта.УчетЗатрат
	|	И ТаблицаОбъекта.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	И Назначения.Ссылка ЕСТЬ NULL");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляГенерацииНазначений(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.НаправленияДеятельности";
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Назначения") Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ЗапросПоиска = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Назначения.Ссылка КАК Назначение
	|ИЗ
	|	Справочник.Назначения КАК Назначения
	|ГДЕ
	|	Назначения.НаправлениеДеятельности = &НаправлениеДеятельности
	|	И Назначения.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|	И Назначения.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|	И Назначения.Заказ = НЕОПРЕДЕЛЕНО
	// Тип назначения пропускается, т.к. он еще не обработан на этот момент
	|");
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			
			ЭлементБлокировки = Блокировка.Добавить("Справочник.Назначения");
			ЭлементБлокировки.УстановитьЗначение("НаправлениеДеятельности", Выборка.Ссылка);
			ЭлементБлокировки.УстановитьЗначение("Заказ",                   Неопределено);
			ЭлементБлокировки.УстановитьЗначение("Партнер",                 Справочники.Партнеры.ПустаяСсылка());
			ЭлементБлокировки.УстановитьЗначение("Договор",                 Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
			
			Блокировка.Заблокировать();
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если Объект <> Неопределено Тогда
				
				Если Объект.УчетЗатрат И Не ЗначениеЗаполнено(Объект.Назначение) Тогда
					
					ЗапросПоиска.УстановитьПараметр("НаправлениеДеятельности", Объект.Ссылка);
					ВыборкаПоиска = ЗапросПоиска.Выполнить().Выбрать();
					
					Если Не ВыборкаПоиска.Следующий() Тогда
						
						НазначениеОбъект = Справочники.Назначения.СоздатьЭлемент();
						ЗаполнитьЗначенияСвойств(НазначениеОбъект, ШаблонНазначения(Объект));
						
						НазначениеОбъект.Наименование                = Строка(Объект.Ссылка);
						НазначениеОбъект.ПометкаУдаления             = Объект.ПометкаУдаления;
						НазначениеОбъект.КонтролироватьТолькоНаличие = Объект.ДопускаетсяОбособлениеСверхПотребности;
						
						ОбновлениеИнформационнойБазы.ЗаписатьДанные(НазначениеОбъект, Истина);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаОбъекта.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НаправленияДеятельности КАК ТаблицаОбъекта
	|ГДЕ
	|	ТаблицаОбъекта.УдалитьВариантОбособления <> ЗНАЧЕНИЕ(Перечисление.УдалитьВариантыОбособленияПоНаправлениюДеятельности.ПустаяСсылка)
	|	И ТаблицаОбъекта.УчетЗатрат И ТаблицаОбъекта.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	ИЛИ (НЕ ТаблицаОбъекта.НалогообложениеНДСОпределяетсяВДокументе
	|		И ТаблицаОбъекта.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка))
	|");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.НаправленияДеятельности";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДопПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДопПараметры.ИмяВременнойТаблицы = "ВтЗаблокированныеСсылки";
	ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуЗаблокированныхДляЧтенияИИзмененияДанных(Параметры.Очередь,
		"Справочник.Назначения", МенеджерВременныхТаблиц, ДопПараметры);
	
	ЗапросПоиска = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Назначения.Ссылка КАК Назначение
	|ИЗ
	|	Справочник.Назначения КАК Назначения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтЗаблокированныеСсылки КАК ЗаблокированныеСсылки
	|		ПО Назначения.Ссылка = ЗаблокированныеСсылки.Ссылка
	|ГДЕ
	|	Назначения.НаправлениеДеятельности = &НаправлениеДеятельности
	|	И Назначения.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|	И Назначения.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|	И Назначения.Заказ = НЕОПРЕДЕЛЕНО
	// Тип назначения пропускается, т.к. он еще не обработан на этот момент
	|	И ЗаблокированныеСсылки.Ссылка ЕСТЬ NULL");
	
	ЗапросПоиска.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если Объект <> Неопределено Тогда
				
				ОбъектИзменен = Ложь;
				
				
				Если Объект.УдалитьВариантОбособления <> Перечисления.УдалитьВариантыОбособленияПоНаправлениюДеятельности.ПустаяСсылка() Тогда
					Если Объект.УчетЗатрат
						И Объект.УдалитьВариантОбособления = Перечисления.УдалитьВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом Тогда
						Объект.ДопускаетсяОбособлениеСверхПотребности = Истина;
					КонецЕсли;
					Объект.УдалитьВариантОбособления = Перечисления.УдалитьВариантыОбособленияПоНаправлениюДеятельности.ПустаяСсылка();
					ОбъектИзменен = Истина;
				КонецЕсли;
			
				Если НЕ Объект.НалогообложениеНДСОпределяетсяВДокументе 
					И Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка() Тогда
					Объект.НалогообложениеНДСОпределяетсяВДокументе = Истина;
					ОбъектИзменен = Истина;
				КонецЕсли;
				
				Если Объект.УчетЗатрат И Не ЗначениеЗаполнено(Объект.Назначение) Тогда
					ЗапросПоиска.УстановитьПараметр("НаправлениеДеятельности", Объект.Ссылка);
					ВыборкаПоиска = ЗапросПоиска.Выполнить().Выбрать();
					Если ВыборкаПоиска.Следующий() Тогда
						Объект.Назначение = ВыборкаПоиска.Назначение;
					Иначе
						ВызватьИсключение НСтр("ru = 'В информационной базе не обнаружено нужное назначение'");
					КонецЕсли;
					ОбъектИзменен = Истина;
				КонецЕсли;
				
				Если ОбъектИзменен Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Объект);
				КонецЕсли;
				
			Иначе
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
