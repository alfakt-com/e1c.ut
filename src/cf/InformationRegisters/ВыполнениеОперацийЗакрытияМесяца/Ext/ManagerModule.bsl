﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ЗавершенныеРасчеты

Функция ПолучитьСведенияОВыполненииЭтапа(МассивОрганизаций, ПериодРасчета, Операция) Экспорт
	
	Результат = Новый Структура("ДатаНачала, ДатаОкончания, БылиОшибки");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МИНИМУМ(Статистика.ДатаНачала), НЕОПРЕДЕЛЕНО) 		КАК ДатаНачала,
	|	ЕСТЬNULL(МАКСИМУМ(Статистика.ДатаОкончания), НЕОПРЕДЕЛЕНО) 	КАК ДатаОкончания,
	|	ЕСТЬNULL(МАКСИМУМ(Статистика.БылиОшибки), ЛОЖЬ) 		   	КАК БылиОшибки
	|ИЗ
	|	РегистрСведений.ВыполнениеОперацийЗакрытияМесяца КАК Статистика
	|ГДЕ
	|	Статистика.Организация В(&МассивОрганизаций)
	|	И Статистика.ПериодРасчета = &ПериодРасчета
	|	И Статистика.Операция = &Операция
	|	И НЕ Статистика.РасчетВыполняется";
	
	Запрос.УстановитьПараметр("МассивОрганизаций", ОрганизацииДляРасчета(МассивОрганизаций));
	Запрос.УстановитьПараметр("ПериодРасчета", 	   ПериодРасчета);
	Запрос.УстановитьПараметр("Операция", 		   Операция);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	
	Возврат Результат;
	
КонецФункции

Процедура СохранитьСведенияОВыполненииЭтапа(МассивОрганизаций, ПериодРасчета, ОписаниеВыполненияЭтапа, БылиОшибки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ТекущаяОрганизация Из ОрганизацииДляРасчета(МассивОрганизаций) Цикл
		
		НаборЗаписей = РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Организация.Установить(ТекущаяОрганизация);
		НаборЗаписей.Отбор.ПериодРасчета.Установить(ПериодРасчета);
		НаборЗаписей.Отбор.Операция.Установить(ОписаниеВыполненияЭтапа.Операция);
		НаборЗаписей.Отбор.РасчетВыполняется.Установить(Ложь);
		
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, ОписаниеВыполненияЭтапа);
		
		Запись.Организация 	     = ТекущаяОрганизация;
		Запись.ПериодРасчета     = ПериодРасчета;
		Запись.БылиОшибки 	     = БылиОшибки;
		Запись.РасчетВыполняется = Ложь;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВыполняемыеРасчеты

Функция ПроверитьНаличиеАктивныхРасчетов(МассивОрганизаций = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Организации.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТОрганизации
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка В(&МассивОрганизаций)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыполнениеРасчета.Организация КАК Организация,
	|	ВыполнениеРасчета.ПериодРасчета КАК ПериодРасчета,
	|	ВыполнениеРасчета.Операция КАК Операция,
	|	ВыполнениеРасчета.ДатаНачала КАК ДатаНачала,
	|	ВыполнениеРасчета.ИнформацияОЗапускеРасчета КАК ИнформацияОЗапускеРасчета,
	|	ВыполнениеРасчета.ИдентификаторРасчета КАК ИдентификаторРасчета
	|ПОМЕСТИТЬ ВТВыполнениеРасчета
	|ИЗ
	|	РегистрСведений.ВыполнениеОперацийЗакрытияМесяца КАК ВыполнениеРасчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОрганизации КАК Организации
	|		ПО ВыполнениеРасчета.Организация = Организации.Ссылка
	|ГДЕ
	|	ВыполнениеРасчета.РасчетВыполняется
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	ВТОрганизации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВыполнениеРасчета КАК ВыполнениеРасчета
	|		ПО Организации.Ссылка = ВыполнениеРасчета.Организация
	|ГДЕ
	|	ВыполнениеРасчета.Организация ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыполнениеРасчета.Организация КАК Организация,
	|	ВыполнениеРасчета.ПериодРасчета КАК ПериодРасчета,
	|	ВыполнениеРасчета.Операция КАК Операция,
	|	ВыполнениеРасчета.ДатаНачала КАК ДатаНачала,
	|	ВыполнениеРасчета.ИнформацияОЗапускеРасчета КАК ИнформацияОЗапускеРасчета,
	|	ВыполнениеРасчета.ИдентификаторРасчета КАК ИдентификаторРасчета
	|ИЗ
	|	ВТВыполнениеРасчета КАК ВыполнениеРасчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыполнениеРасчета.ИнформацияОЗапускеРасчета КАК ИнформацияОЗапускеРасчета,
	|	ВыполнениеРасчета.ИдентификаторРасчета КАК ИдентификаторРасчета
	|ИЗ
	|	ВТВыполнениеРасчета КАК ВыполнениеРасчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИнформацияОЗапускеРасчета";
	
	Запрос.УстановитьПараметр("МассивОрганизаций", ОрганизацииДляРасчета(МассивОрганизаций));
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РасчетПоВсемОрганизациям = РезультатЗапроса[2].Пустой();
	Расчеты 				 = РезультатЗапроса[3].Выгрузить();
	РасчетыПоИдентификаторам = РезультатЗапроса[4].Выгрузить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОписаниеРасчетов = "";
	
	Для Каждого ТекСтр Из РасчетыПоИдентификаторам Цикл
		ОписаниеРасчетов = ОписаниеРасчетов + Символы.ПС + "  - " + СокрЛП(ТекСтр.ИнформацияОЗапускеРасчета);
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьАктивныеРасчеты", 		(Расчеты.Количество() > 0));
	Результат.Вставить("ТекстОшибки", 				"");
	Результат.Вставить("Расчеты", 		      		Расчеты);
	Результат.Вставить("РасчетПоВсемОрганизациям", 	СокрЛП(РасчетПоВсемОрганизациям));
	
	Если Результат.ЕстьАктивныеРасчеты Тогда
		
		ОдноЗадание = (РасчетыПоИдентификаторам.Количество() < 2);
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 закрытия месяца:
				|%2
				|Выполнение операций закрытия месяца остановлено.'"),
			?(ОдноЗадание, НСтр("ru='Обнаружено активное задание'"), НСтр("ru='Обнаружены активные задания'")),
			СокрЛП(ОписаниеРасчетов));
		
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
		 И ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца) Тогда
			ТекстОшибки = ТекстОшибки + Символы.ПС
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Возможно %1 аварийно, в этом случае информацию об %2 необходимо актуализировать вручную.'"),
					?(ОдноЗадание, НСтр("ru='задание завершено'"), НСтр("ru='задания завершены'")),
					?(ОдноЗадание, НСтр("ru='активном задании'"), НСтр("ru='активных заданиях'")));
		КонецЕсли;
		
		ТекстОшибки = ТекстОшибки + Символы.ПС
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Подробнее см. в форме ""%1"", ""Еще"" - ""Активные сеансы закрытия месяца""'"),
				Метаданные.Обработки.ОперацииЗакрытияМесяца.Формы.ЗакрытиеМесяца.Синоним);
		
		Результат.ТекстОшибки = ТекстОшибки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОбновитьСостояниеАктивныхРасчетов() Экспорт
	
	ЭтоФайловаяИБ = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(,, Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыполнениеРасчета.ИдентификаторРасчета КАК ИдентификаторРасчета
	|ИЗ
	|	РегистрСведений.ВыполнениеОперацийЗакрытияМесяца КАК ВыполнениеРасчета
	|ГДЕ
	|	ВыполнениеРасчета.РасчетВыполняется";
	
	Расчеты = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСтр Из Расчеты Цикл
		
		СостояниеЗадания = ЗакрытиеМесяцаСервер.ТекущееСостояниеФоновогоЗадания(
			ЗакрытиеМесяцаСервер.ИмяФоновогоЗадания(ТекСтр.ИдентификаторРасчета));
		
		Если НЕ СостояниеЗадания.Активно Тогда
			
			// Если задание расчета не найдено по GUID, то его нельзя считать завершенным:
			// - в файловой ИБ, т.к. платформа "не видит" фоновые задания другого сеанса
			// - если текущий пользователь не администратор, т.к. менеджер фоновых заданий не показывает такому пользователю
			// задания других пользователей.
			Если НЕ (СостояниеЗадания.НеНайдено И (ЭтоФайловаяИБ ИЛИ НЕ ЭтоПолноправныйПользователь))
			 ИЛИ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
				УстановитьПризнакОкончанияРасчета(ТекСтр.ИдентификаторРасчета);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Расчеты.Количество();
	
КонецФункции


Функция УстановитьПризнакЗапускаРасчета(МассивОрганизаций, ИдентификаторРасчета,
			ИнформацияОЗапускеРасчета = "", ПериодРасчета = Неопределено, Операция = Неопределено) Экспорт
	
	Организации = ОрганизацииДляРасчета(МассивОрганизаций);
	
	ИсточникБлокировки = Новый ТаблицаЗначений;
	ИсточникБлокировки.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	Для Каждого ТекущаяОрганизация Из Организации Цикл
		ИсточникБлокировки.Добавить().Организация = ТекущаяОрганизация;
	КонецЦикла;
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ВыполнениеОперацийЗакрытияМесяца");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ИсточникБлокировки;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
		Блокировка.Заблокировать();		
		
		// Установить признак расчета (и запустить расчет) можно только если нет других активных расчетов по указанным организациям.
		АктивныеРасчеты = ПроверитьНаличиеАктивныхРасчетов(Организации);
		
		Если НЕ АктивныеРасчеты.ЕстьАктивныеРасчеты Тогда
			
			НаборЗаписей = РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.СоздатьНаборЗаписей();
			
			Для Каждого ТекущаяОрганизация Из Организации Цикл
				
				Запись = НаборЗаписей.Добавить();
				
				Запись.Организация 	        	 = ТекущаяОрганизация;
				Запись.РасчетВыполняется    	 = Истина;
				Запись.ИдентификаторРасчета 	 = ИдентификаторРасчета;
				Запись.ДатаНачала		    	 = ДатаНачала;
				Запись.ИнформацияОЗапускеРасчета = Формат(ДатаНачала, "ДЛФ=DT") + "; " + СокрЛП(ИнформацияОЗапускеРасчета);
				Запись.ПериодРасчета 	         = ПериодРасчета;
				Запись.Операция 	        	 = Операция;
				
			КонецЦикла;
			
			НаборЗаписей.Записать(Ложь);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ИнформацияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(
			ЗакрытиеМесяцаСервер.ИмяСобытияЖурналаРегистрации(
				НСтр("ru = 'Установка признака выполнения расчета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ИнформацияОбОшибке);
		
		ВызватьИсключение ИнформацияОбОшибке;
		
	КонецПопытки;
	
	Возврат АктивныеРасчеты;
	
КонецФункции

Функция УстановитьПризнакОкончанияРасчета(ИдентификаторРасчета = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		// Сохраним информацию о всех остальных выполняемых на настоящее время расчетах кроме текущего (оконченного).
		// Это будет быстрее, чем по одной очищать записи по каждой рассчитанной организации,
		// тем более, что в подавляющем большинстве случаев остальных расчетов не будет - выполнится только одна запись пустого набора.
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ВыполнениеОперацийЗакрытияМесяца");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("РасчетВыполняется", Истина);
		Блокировка.Заблокировать();		
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВыполнениеРасчета.Организация КАК Организация,
		|	ВыполнениеРасчета.ПериодРасчета КАК ПериодРасчета,
		|	ВыполнениеРасчета.Операция КАК Операция,
		|	ВыполнениеРасчета.РасчетВыполняется КАК РасчетВыполняется,
		|	ВыполнениеРасчета.ДатаНачала КАК ДатаНачала,
		|	ВыполнениеРасчета.ДатаОкончания КАК ДатаОкончания,
		|	ВыполнениеРасчета.БылиОшибки КАК БылиОшибки,
		|	ВыполнениеРасчета.Длительность КАК Длительность,
		|	ВыполнениеРасчета.ИдентификаторРасчета КАК ИдентификаторРасчета,
		|	ВыполнениеРасчета.ИнформацияОЗапускеРасчета КАК ИнформацияОЗапускеРасчета
		|ИЗ
		|	РегистрСведений.ВыполнениеОперацийЗакрытияМесяца КАК ВыполнениеРасчета
		|ГДЕ
		|	ВыполнениеРасчета.РасчетВыполняется
		|	И ВыполнениеРасчета.ИдентификаторРасчета <> &ИдентификаторРасчета
		|	И НЕ &ОкончаниеВсехРасчетов";
		
		Запрос.УстановитьПараметр("ИдентификаторРасчета",  ?(ИдентификаторРасчета = Неопределено, Новый УникальныйИдентификатор, ИдентификаторРасчета));
		Запрос.УстановитьПараметр("ОкончаниеВсехРасчетов", ИдентификаторРасчета = Неопределено);
		
		Запрос.Выполнить().Выгрузить();
		
		НаборЗаписей = РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.РасчетВыполняется.Установить(Истина);
		
		НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
		
		НаборЗаписей.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ИнформацияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(
			ЗакрытиеМесяцаСервер.ИмяСобытияЖурналаРегистрации(
				НСтр("ru = 'Установка признака выполнения расчета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ИнформацияОбОшибке);
		
		ВызватьИсключение ИнформацияОбОшибке;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область Прочие

Функция ОрганизацииДляРасчета(МассивОрганизаций)
	
	Организации = ?(НЕ ЗначениеЗаполнено(МассивОрганизаций),
		Справочники.Организации.ДоступныеОрганизации(),
		ОбщегоНазначенияУТКлиентСервер.Массив(МассивОрганизаций));
	
	Возврат Организации;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
