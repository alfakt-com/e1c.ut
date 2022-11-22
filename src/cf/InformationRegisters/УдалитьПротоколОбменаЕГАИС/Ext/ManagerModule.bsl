﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает сессию обмена с УТМ.
//
// Параметры:
//  ПараметрыСессии - Структура - параметры сессии обмена.
//
Процедура ЗаписатьСессиюОбменаСУТМ(ПараметрыСессии) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.УдалитьПротоколОбменаЕГАИС.СоздатьМенеджерЗаписи();
	Запись.ИдентификаторСессииОбмена = Строка(Новый УникальныйИдентификатор);
	
	ЗаполнитьЗначенияСвойств(Запись, ПараметрыСессии);
	Запись.Записать();
	
КонецПроцедуры

// Возвращает данные последнего исходящего запроса по идентификатору.
//
// Параметры:
//  ИдентификаторЗапроса - Строка - идентификатор исходящего запроса.
//
// Возвращаемое значение:
//   Структура - данные последнего исходящего запроса. Неопределено - если запрос не найден.
//
Функция НайтиИсходящийЗапрос(ИдентификаторЗапроса) Экспорт
	
	Результат = Новый Структура("ВидДокумента, ДокументОснование");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторЗапроса", ИдентификаторЗапроса);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УдалитьПротоколОбменаЕГАИС.ДатаЗапроса КАК ДатаЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ВидДокумента КАК ВидДокумента,
	|	УдалитьПротоколОбменаЕГАИС.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|ГДЕ
	|	УдалитьПротоколОбменаЕГАИС.ТипЗапроса = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий)
	|	И УдалитьПротоколОбменаЕГАИС.ИдентификаторЗапроса = &ИдентификаторЗапроса
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаЗапроса УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст последней ошибки, полученной из ЕГАИС.
//
// Параметры:
//  ДокументОснование - ДокументСсылка - ссылка на выгруженный ранее документ.
//
// Возвращаемое значение:
//   Строка - текст последней ошибки. Пустая строка - если ошибок не было.
//
Функция ТекстПоследнейОшибки(ДокументОснование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УдалитьПротоколОбменаЕГАИС.Комментарий КАК Комментарий,
	|	УдалитьПротоколОбменаЕГАИС.ДатаЗапроса КАК ДатаЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ПолученОтказ КАК ПолученОтказ
	|ИЗ
	|	РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|ГДЕ
	|	УдалитьПротоколОбменаЕГАИС.ДокументОснование = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаЗапроса УБЫВ";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если Выборка.ПолученОтказ Тогда
			Возврат Выборка.Комментарий;
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ХешТекстСообщения(ТекстСообщенияXML)
	
	ХешированиеДанныхОбъект = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешированиеДанныхОбъект.Добавить(ТекстСообщенияXML);
	ХешСуммаBase64 = Base64Строка(ХешированиеДанныхОбъект.ХешСумма);
	
	Возврат ХешСуммаBase64;
	
КонецФункции

Функция ТекстСообщенияXMLВоВременномХранилище(ТекстСообщенияXML)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстСообщенияXML);
	ТекстовыйДокумент.Записать(ИмяВременногоФайла, КодировкаТекста.UTF8, "");
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
	АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	Попытка
		
		УдалитьФайлы(ИмяВременногоФайла);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
		                         УровеньЖурналаРегистрации.Ошибка,
		                         Метаданные.Справочники.ЕГАИСПрисоединенныеФайлы,
		                         ИмяВременногоФайла,
		                         ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат АдресФайлаВоВременномХранилище;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюИсходящиеСообщения(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УдалитьПротоколОбменаЕГАИС";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена КАК ИдентификаторСессииОбмена
	|ИЗ
	|	РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|ГДЕ
	|	УдалитьПротоколОбменаЕГАИС.ТипЗапроса = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий)
	|	И УдалитьПротоколОбменаЕГАИС.ВидДокумента <> ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ПустаяСсылка)
	|");
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Таблица, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюИсходящиеСообщения(Параметры) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуИзмеренийНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		"РегистрСведений.УдалитьПротоколОбменаЕГАИС",
		МенеджерВременныхТаблиц);
	
	Если Не Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если Не Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТаблицаСоответствияДокументовТипамЕГАИС = Перечисления.ВидыДокументовЕГАИС.ТаблицаСоответствияДокументовТипамЕГАИС();
	
	АбстрактныеОперации = Перечисления.ВидыДокументовЕГАИС.АбстрактныеОперации();
	
	ТекущаяУниверсальнаяДата = ТекущаяУниверсальнаяДата();
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	ДельтаВремени = ТекущаяУниверсальнаяДата - ТекущаяДатаСеанса;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.Ссылка КАК ОрганизацияЕГАИС,
	|	Т.Код КАК КодФСРАР
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОтметитьВыполнениеОбработки,
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена       КАК ИдентификаторСессииОбмена,
	|	УдалитьПротоколОбменаЕГАИС.ТипЗапроса                      КАК ТипЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ДатаЗапроса                     КАК ДатаЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ВидДокумента                    КАК ВидДокумента,
	|	УдалитьПротоколОбменаЕГАИС.ПолученОтказ                    КАК ПолученОтказ,
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторЗапроса            КАК ИдентификаторЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.Комментарий                     КАК Комментарий,
	|	УдалитьПротоколОбменаЕГАИС.ФайлОбмена                      КАК ФайлОбмена,
	|	УдалитьПротоколОбменаЕГАИС.ДокументОснование               КАК ДокументОснование,
	|	УдалитьПротоколОбменаЕГАИС.ДокументОснование.Ответственный КАК Ответственный,
	|	ВЫБОР
	|		КОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование ССЫЛКА Документ.ТТНВходящаяЕГАИС
	|			ТОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование.Грузополучатель
	|		КОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование ССЫЛКА Документ.ТТНИсходящаяЕГАИС
	|			ТОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование.Грузоотправитель
	|		ИНАЧЕ УдалитьПротоколОбменаЕГАИС.ДокументОснование.ОрганизацияЕГАИС
	|	КОНЕЦ КАК ОрганизацияЕГАИС
	|ИЗ
	|	&ВТДанныеДляОбработки КАК ВТДанныеДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|		ПО (УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена = ВТДанныеДляОбработки.ИдентификаторСессииОбмена)";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВТДанныеДляОбработки", Результат.ИмяВременнойТаблицы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОрганизацииЕГАИС = РезультатЗапроса[0].Выгрузить();
	
	Выборка = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ИсходящееСообщениеТекстСообщенияXML = "";
		
		Если ЗначениеЗаполнено(Выборка.ФайлОбмена) Тогда
			ИсходящееСообщениеТекстСообщенияXML = Выборка.ФайлОбмена.Получить();
			Если ИсходящееСообщениеТекстСообщенияXML = Неопределено Тогда
				ИсходящееСообщениеТекстСообщенияXML = "";
			КонецЕсли;
		КонецЕсли;
		
		ОбъектXDTO = Неопределено;
		Если ЗначениеЗаполнено(ИсходящееСообщениеТекстСообщенияXML) Тогда
			
			ТекстОшибки = "";
			
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(ИсходящееСообщениеТекстСообщенияXML);
			
			Попытка
				
				ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ИнтеграцияЕГАИС.ОбъектXDTOПоИмениСвойства(ИнтеграцияЕГАИС.КорневоеПространствоИмен(), "Documents").Тип());
				
			Исключение
				
				ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				
				Попытка
					
					ОбъектXDTO = ИнтеграцияЕГАИС.ПреобразоватьПроизвольныйОбъектXDTOВОбъектXDTO(
						ИнтеграцияЕГАИС.ПроизвольныйОбъектXDTOПоТекстуСообщенияXML(ИсходящееСообщениеТекстСообщенияXML),
						ИнтеграцияЕГАИС.ОбъектXDTOПоИмениСвойства(ИнтеграцияЕГАИС.КорневоеПространствоИмен(), "Documents", Неопределено));
					
				Исключение
					
					ТекстОшибки = ПодробноеПредставлениеОшибки;
					
				КонецПопытки;
				
			КонецПопытки;
			
			Если ЗначениеЗаполнено(ТекстОшибки) Тогда
				
				// Не удалось прочитать текст сообщения XML.
				ИсходящееСообщениеТекстСообщенияXML = "";
				
			КонецЕсли;
		КонецЕсли;
		
		Операция          = Неопределено;
		ФорматОбмена      = Неопределено;
		ТипЕГАИС          = Неопределено;
		ЗагруженныйОбъект = Неопределено;
		
		Если ОбъектXDTO <> Неопределено Тогда
			Попытка
				ДокументыПоТипамЕГАИС = ИнтеграцияЕГАИС.ОбъектXDTOВСтруктуру(ОбъектXDTO.Document);
				Для Каждого КлючИЗначение Из ДокументыПоТипамЕГАИС Цикл
					Если КлючИЗначение.Значение <> Неопределено Тогда
						ТипЕГАИС                  = КлючИЗначение.Ключ;
						ЗагруженныйОбъект         = ДокументыПоТипамЕГАИС[ТипЕГАИС];
						ВидДокументаИФорматОбмена = Перечисления.ВидыДокументовЕГАИС.ДанныеДокументаПоТипуЕГАИС(
							ТипЕГАИС, ТаблицаСоответствияДокументовТипамЕГАИС);
						Операция                  = ВидДокументаИФорматОбмена.ВидДокументаЕГАИС;
						ФорматОбмена              = ВидДокументаИФорматОбмена.ФорматОбмена;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			Исключение
				ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
		КонецЕсли;
		
		ОрганизацияЕГАИС = Неопределено;
		Если ЗначениеЗаполнено(Выборка.ОрганизацияЕГАИС) Тогда
			ОрганизацияЕГАИС = Выборка.ОрганизацияЕГАИС;
		Иначе
			Если ОбъектXDTO <> Неопределено Тогда
				НайденнаяСтрока = ОрганизацииЕГАИС.Найти(ОбъектXDTO.Owner.FSRAR_ID, "КодФСРАР");
				Если НайденнаяСтрока <> Неопределено Тогда
					ОрганизацияЕГАИС = НайденнаяСтрока.ОрганизацияЕГАИС;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		НачатьТранзакцию();
		
		Попытка
			
			Если Выборка.ОтметитьВыполнениеОбработки Тогда
				
				ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
				ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
				ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УдалитьПротоколОбменаЕГАИС";
				
				Таблица = Новый ТаблицаЗначений;
				Таблица.Колонки.Добавить("ИдентификаторСессииОбмена");
				НоваяСтрокаТаблицы = Таблица.Добавить();
				НоваяСтрокаТаблицы.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Таблица, ДополнительныеПараметры, Параметры.Очередь);
				
				ЗафиксироватьТранзакцию();
				Продолжить;
				
			КонецЕсли;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УдалитьПротоколОбменаЕГАИС");
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторСессииОбмена", Выборка.ИдентификаторСессииОбмена);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Если Не ЗначениеЗаполнено(ОрганизацияЕГАИС) Тогда
				
				// Без организации ЕГАИС записать данные в протокол обмена нельзя.
				
				ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
				ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
				ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УдалитьПротоколОбменаЕГАИС";
				
				Таблица = Новый ТаблицаЗначений;
				Таблица.Колонки.Добавить("ИдентификаторСессииОбмена");
				НоваяСтрокаТаблицы = Таблица.Добавить();
				НоваяСтрокаТаблицы.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Таблица, ДополнительныеПараметры, Параметры.Очередь);
				
				ЗафиксироватьТранзакцию();
				Продолжить;
				
			КонецЕсли;
			
			ИсходящееСообщениеПараметрыФайла = Новый Структура;
			ИсходящееСообщениеПараметрыФайла.Вставить("Автор",                       Выборка.Ответственный);
			ИсходящееСообщениеПараметрыФайла.Вставить("ВладелецФайлов",              ОрганизацияЕГАИС);
			ИсходящееСообщениеПараметрыФайла.Вставить("ИмяБезРасширения",            Выборка.ИдентификаторСессииОбмена);
			ИсходящееСообщениеПараметрыФайла.Вставить("РасширениеБезТочки",          "xml");
			ИсходящееСообщениеПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Выборка.ДатаЗапроса + ДельтаВремени);
			
			ИсходящееСообщениеПрисоединенныйФайл = ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(
				ИсходящееСообщениеПараметрыФайла,
				ТекстСообщенияXMLВоВременномХранилище(ИсходящееСообщениеТекстСообщенияXML),,,
				Справочники.ЕГАИСПрисоединенныеФайлы.ПолучитьСсылку());
			
			ИсходящееСообщениеПрисоединенныйФайлОбъект = ИсходящееСообщениеПрисоединенныйФайл.ПолучитьОбъект();
			ИсходящееСообщениеПрисоединенныйФайлОбъект.ДатаСоздания         = Выборка.ДатаЗапроса;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.Описание             = Выборка.Комментарий;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.Операция             = ?(Операция <> Неопределено И АбстрактныеОперации.Найти(Операция) = Неопределено, Операция, Выборка.ВидДокумента);
			ИсходящееСообщениеПрисоединенныйФайлОбъект.ТипСообщения         = Выборка.ТипЗапроса;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.ХешСумма             = ХешТекстСообщения(ИсходящееСообщениеТекстСообщенияXML);
			ИсходящееСообщениеПрисоединенныйФайлОбъект.ИдентификаторЗапроса = Выборка.ИдентификаторЗапроса;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.Документ             = Выборка.ДокументОснование;
			
			ИсходящееСообщениеПрисоединенныйФайлОбъект.ОперацияКвитанции    = Неопределено;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.СообщениеОснование   = Неопределено;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.СтатусОбработки      = Перечисления.СтатусыОбработкиСообщенийЕГАИС.КПередаче;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.ФорматОбмена         = ФорматОбмена;
			ИсходящееСообщениеПрисоединенныйФайлОбъект.Версия               = 1;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИсходящееСообщениеПрисоединенныйФайлОбъект);
			
			ВходящееСообщениеТекстСообщенияXML = 
			"<?xml version=""1.0"" encoding=""UTF-8""?>
			|<A>
			|  <url>" + Выборка.ИдентификаторЗапроса + "</url>
			|  <sign></sign>
			|  <ver>2</ver>
			|</A>";
			
			ВходящееСообщениеПараметрыФайла = Новый Структура;
			ВходящееСообщениеПараметрыФайла.Вставить("Автор",                       Выборка.Ответственный);
			ВходящееСообщениеПараметрыФайла.Вставить("ВладелецФайлов",              ОрганизацияЕГАИС);
			ВходящееСообщениеПараметрыФайла.Вставить("ИмяБезРасширения",            Строка(Новый УникальныйИдентификатор));
			ВходящееСообщениеПараметрыФайла.Вставить("РасширениеБезТочки",          "xml");
			ВходящееСообщениеПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Выборка.ДатаЗапроса + ДельтаВремени);
			
			ВходящееСообщениеПрисоединенныйФайл = ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(
				ВходящееСообщениеПараметрыФайла,
				ТекстСообщенияXMLВоВременномХранилище(ВходящееСообщениеТекстСообщенияXML),,,
				Справочники.ЕГАИСПрисоединенныеФайлы.ПолучитьСсылку());
			
			ВходящееСообщениеПрисоединенныйФайлОбъект = ВходящееСообщениеПрисоединенныйФайл.ПолучитьОбъект();
			ВходящееСообщениеПрисоединенныйФайлОбъект.ДатаСоздания         = Выборка.ДатаЗапроса;
			ВходящееСообщениеПрисоединенныйФайлОбъект.Операция             = Выборка.ВидДокумента;
			ВходящееСообщениеПрисоединенныйФайлОбъект.ТипСообщения         = Перечисления.ТипыЗапросовЕГАИС.Входящий;
			ВходящееСообщениеПрисоединенныйФайлОбъект.ХешСумма             = ХешТекстСообщения(ИсходящееСообщениеТекстСообщенияXML);
			ВходящееСообщениеПрисоединенныйФайлОбъект.ИдентификаторЗапроса = Выборка.ИдентификаторЗапроса;
			ВходящееСообщениеПрисоединенныйФайлОбъект.Документ             = Выборка.ДокументОснование;
			
			ВходящееСообщениеПрисоединенныйФайлОбъект.ОперацияКвитанции  = Неопределено;
			ВходящееСообщениеПрисоединенныйФайлОбъект.СообщениеОснование = ИсходящееСообщениеПрисоединенныйФайлОбъект.Ссылка;
			ВходящееСообщениеПрисоединенныйФайлОбъект.СтатусОбработки    = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ПереданоВУТМ;
			ВходящееСообщениеПрисоединенныйФайлОбъект.ФорматОбмена       = ФорматОбмена;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВходящееСообщениеПрисоединенныйФайлОбъект);
			
			НаборЗаписей = РегистрыСведений.УдалитьПротоколОбменаЕГАИС.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИдентификаторСессииОбмена.Установить(Выборка.ИдентификаторСессииОбмена);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать запись регистра ""УдалитьПротоколОбменаЕГАИС"" с идентификатором сессии обмена %Идентификатор%
			                            |по причине %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Идентификатор%", Выборка.ИдентификаторСессииОбмена);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         Метаданные.РегистрыСведений.УдалитьПротоколОбменаЕГАИС,
			                         Выборка.ИдентификаторСессииОбмена,
			                         ТекстСообщения);
			
			Продолжить;
			
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(
		Параметры.Очередь,
		"РегистрСведений.УдалитьПротоколОбменаЕГАИС");
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюВходящиеСообщения(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УдалитьПротоколОбменаЕГАИС";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена КАК ИдентификаторСессииОбмена
	|ИЗ
	|	РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|ГДЕ
	|	УдалитьПротоколОбменаЕГАИС.ТипЗапроса = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Входящий)
	|	И УдалитьПротоколОбменаЕГАИС.ВидДокумента <> ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ПустаяСсылка)
	|");
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Таблица, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюВходящиеСообщения(Параметры) Экспорт
	
	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь, "РегистрСведений.УдалитьПротоколОбменаЕГАИС") Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуИзмеренийНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		"РегистрСведений.УдалитьПротоколОбменаЕГАИС",
		МенеджерВременныхТаблиц);
	
	Если Не Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если Не Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТаблицаСоответствияДокументовТипамЕГАИС = Перечисления.ВидыДокументовЕГАИС.ТаблицаСоответствияДокументовТипамЕГАИС();
	
	АбстрактныеОперации = Перечисления.ВидыДокументовЕГАИС.АбстрактныеОперации();
	
	ТекущаяУниверсальнаяДата = ТекущаяУниверсальнаяДата();
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	ДельтаВремени = ТекущаяУниверсальнаяДата - ТекущаяДатаСеанса;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.Ссылка КАК ОрганизацияЕГАИС,
	|	Т.Код    КАК КодФСРАР
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК Т
	|;
	|
	|/////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена ЕСТЬ NULL
	|		ИЛИ (УдалитьПротоколОбменаЕГАИС.ВидДокумента В(&Квитанции) И ТаблицаСообщениеОснованиеКвитанции.Ссылка ЕСТЬ NULL) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОтметитьВыполнениеОбработки,
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена                       КАК ИдентификаторСессииОбмена,
	|	УдалитьПротоколОбменаЕГАИС.ТипЗапроса                                      КАК ТипЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ДатаЗапроса                                     КАК ДатаЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ВидДокумента                                    КАК ВидДокумента,
	|	УдалитьПротоколОбменаЕГАИС.ПолученОтказ                                    КАК ПолученОтказ,
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторЗапроса                            КАК ИдентификаторЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.Комментарий                                     КАК Комментарий,
	|	УдалитьПротоколОбменаЕГАИС.ФайлОбмена                                      КАК ФайлОбмена,
	|	УдалитьПротоколОбменаЕГАИС.ДокументОснование                               КАК ДокументОснование,
	|	УдалитьПротоколОбменаЕГАИС.ДокументОснование.Ответственный                 КАК Ответственный,
	|	ВЫБОР
	|		КОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование ССЫЛКА Документ.ТТНВходящаяЕГАИС
	|			ТОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование.Грузополучатель
	|		КОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование ССЫЛКА Документ.ТТНИсходящаяЕГАИС
	|			ТОГДА УдалитьПротоколОбменаЕГАИС.ДокументОснование.Грузоотправитель
	|		ИНАЧЕ УдалитьПротоколОбменаЕГАИС.ДокументОснование.ОрганизацияЕГАИС
	|	КОНЕЦ КАК ОрганизацияЕГАИС,
	|	ТаблицаСообщениеОснованиеКвитанции.Ссылка                                     КАК СообщениеОснование,
	|	ЕСТЬNULL(ТаблицаСообщениеОснованиеКвитанции.ВладелецФайла, Неопределено)      КАК ВладелецФайлаКвитанции,
	|	ЕСТЬNULL(ТаблицаСообщениеОснованиеОтветаНаЗапрос.ВладелецФайла, Неопределено) КАК ВладелецФайлаОтветаНаЗапрос,
	|	ТаблицаСообщениеОснованиеКвитанции.ВерсияДанных                               КАК СообщениеОснованиеВерсияДанных,
	|	ЕСТЬNULL(ТаблицаСообщениеОснованиеКвитанции.Операция, Неопределено)           КАК СообщениеОснованиеОперация
	|ИЗ
	|	&ВТДанныеДляОбработки КАК ВТДанныеДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|		ПО УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена = ВТДанныеДляОбработки.ИдентификаторСессииОбмена
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ТаблицаСообщениеОснованиеКвитанции
	|		ПО ТаблицаСообщениеОснованиеКвитанции.ИдентификаторЗапроса = УдалитьПротоколОбменаЕГАИС.ИдентификаторЗапроса
	|		И (ТаблицаСообщениеОснованиеКвитанции.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий))
	|		И (УдалитьПротоколОбменаЕГАИС.ВидДокумента В(&Квитанции))
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ТаблицаСообщениеОснованиеОтветаНаЗапрос
	|		ПО ТаблицаСообщениеОснованиеОтветаНаЗапрос.ИдентификаторЗапроса = УдалитьПротоколОбменаЕГАИС.ИдентификаторЗапроса
	|		И (ТаблицаСообщениеОснованиеОтветаНаЗапрос.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий))
	|		И (УдалитьПротоколОбменаЕГАИС.ВидДокумента В(&Запросы))
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВТДанныеДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Квитанции = Новый Массив;
	Квитанции.Добавить(Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС);
	Квитанции.Добавить(Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС);
	Запрос.УстановитьПараметр("Квитанции", Квитанции);
	
	Запросы = Новый Массив;
	Запросы.Добавить(Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросАлкогольнойПродукции);
	Запросы.Добавить(Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросДанныхОрганизации);
	Запросы.Добавить(Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросСправки1);
	Запросы.Добавить(Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросСправки2);
	Запрос.УстановитьПараметр("Запросы", Запросы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОрганизацииЕГАИС = РезультатЗапроса[0].Выгрузить();
	
	Выборка = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВходящееСообщениеТекстСообщенияXML = "";
		
		Если ЗначениеЗаполнено(Выборка.ФайлОбмена) Тогда
			ВходящееСообщениеТекстСообщенияXML = Выборка.ФайлОбмена.Получить();
			Если ВходящееСообщениеТекстСообщенияXML = Неопределено Тогда
				ВходящееСообщениеТекстСообщенияXML = "";
			КонецЕсли;
		КонецЕсли;
		
		ОбъектXDTO = Неопределено;
		Если ЗначениеЗаполнено(ВходящееСообщениеТекстСообщенияXML) Тогда
			
			ТекстОшибки = "";
			
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(ВходящееСообщениеТекстСообщенияXML);
			
			Попытка
				
				ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ИнтеграцияЕГАИС.ОбъектXDTOПоИмениСвойства(ИнтеграцияЕГАИС.КорневоеПространствоИмен(), "Documents").Тип());
				
			Исключение
				
				ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				
				Попытка
					
					ОбъектXDTO = ИнтеграцияЕГАИС.ПреобразоватьПроизвольныйОбъектXDTOВОбъектXDTO(
						ИнтеграцияЕГАИС.ПроизвольныйОбъектXDTOПоТекстуСообщенияXML(ВходящееСообщениеТекстСообщенияXML),
						ИнтеграцияЕГАИС.ОбъектXDTOПоИмениСвойства(ИнтеграцияЕГАИС.КорневоеПространствоИмен(), "Documents", Неопределено));
					
				Исключение
					
					ТекстОшибки = ПодробноеПредставлениеОшибки;
					
				КонецПопытки;
				
			КонецПопытки;
			
			Если ЗначениеЗаполнено(ТекстОшибки) Тогда
				
				// Не удалось прочитать текст сообщения XML.
				ВходящееСообщениеТекстСообщенияXML = "";
				
			КонецЕсли;
		КонецЕсли;
		
		Операция          = Неопределено;
		ФорматОбмена      = Неопределено;
		ТипЕГАИС          = Неопределено;
		ЗагруженныйОбъект = Неопределено;
		
		Если ОбъектXDTO <> Неопределено Тогда
			Попытка
				ДокументыПоТипамЕГАИС = ИнтеграцияЕГАИС.ОбъектXDTOВСтруктуру(ОбъектXDTO.Document);
				Для Каждого КлючИЗначение Из ДокументыПоТипамЕГАИС Цикл
					Если КлючИЗначение.Значение <> Неопределено Тогда
						ТипЕГАИС                  = КлючИЗначение.Ключ;
						ЗагруженныйОбъект         = ДокументыПоТипамЕГАИС[ТипЕГАИС];
						ВидДокументаИФорматОбмена = Перечисления.ВидыДокументовЕГАИС.ДанныеДокументаПоТипуЕГАИС(
							ТипЕГАИС, ТаблицаСоответствияДокументовТипамЕГАИС);
						Операция                  = ВидДокументаИФорматОбмена.ВидДокументаЕГАИС;
						ФорматОбмена              = ВидДокументаИФорматОбмена.ФорматОбмена;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
		КонецЕсли;
		
		ОрганизацияЕГАИС = Неопределено;
		Если ЗначениеЗаполнено(Выборка.ОрганизацияЕГАИС) Тогда
			ОрганизацияЕГАИС = Выборка.ОрганизацияЕГАИС;
		Иначе
			Если ОбъектXDTO <> Неопределено Тогда
				НайденнаяСтрока = ОрганизацииЕГАИС.Найти(ОбъектXDTO.Owner.FSRAR_ID, "КодФСРАР");
				Если НайденнаяСтрока <> Неопределено Тогда
					ОрганизацияЕГАИС = НайденнаяСтрока.ОрганизацияЕГАИС;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОрганизацияЕГАИС) Тогда
			Если ЗначениеЗаполнено(Выборка.ВладелецФайлаКвитанции) Тогда
				ОрганизацияЕГАИС = Выборка.ВладелецФайлаКвитанции;
			ИначеЕсли ЗначениеЗаполнено(Выборка.ВладелецФайлаОтветаНаЗапрос) Тогда
				ОрганизацияЕГАИС = Выборка.ВладелецФайлаОтветаНаЗапрос;
			КонецЕсли;
		КонецЕсли;
		
		НачатьТранзакцию();
		
		Попытка
			
			Если Выборка.ОтметитьВыполнениеОбработки Тогда
				
				ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
				ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
				ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УдалитьПротоколОбменаЕГАИС";
				
				Таблица = Новый ТаблицаЗначений;
				Таблица.Колонки.Добавить("ИдентификаторСессииОбмена");
				НоваяСтрокаТаблицы = Таблица.Добавить();
				НоваяСтрокаТаблицы.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Таблица, ДополнительныеПараметры, Параметры.Очередь);
				
				ЗафиксироватьТранзакцию();
				Продолжить;
				
			КонецЕсли;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УдалитьПротоколОбменаЕГАИС");
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторСессииОбмена", Выборка.ИдентификаторСессииОбмена);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Если ЗначениеЗаполнено(Выборка.СообщениеОснование) Тогда
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник.ЕГАИСПрисоединенныеФайлы");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.СообщениеОснование);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
				Блокировка.Заблокировать();
				
				СообщениеОснованиеВерсияДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.СообщениеОснование, "ВерсияДанных");
				Если СообщениеОснованиеВерсияДанных <> Выборка.СообщениеОснованиеВерсияДанных Тогда
					
					ОтменитьТранзакцию();
					Продолжить;
					
				КонецЕсли;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ОрганизацияЕГАИС) Тогда
				
				// Без организации ЕГАИС записать данные в протокол обмена нельзя.
				
				ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
				ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
				ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.УдалитьПротоколОбменаЕГАИС";
				
				Таблица = Новый ТаблицаЗначений;
				Таблица.Колонки.Добавить("ИдентификаторСессииОбмена");
				НоваяСтрокаТаблицы = Таблица.Добавить();
				НоваяСтрокаТаблицы.ИдентификаторСессииОбмена = Выборка.ИдентификаторСессииОбмена;
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Таблица, ДополнительныеПараметры, Параметры.Очередь);
				
				ЗафиксироватьТранзакцию();
				Продолжить;
				
			КонецЕсли;
			
			Если ЗагруженныйОбъект <> Неопределено 
				И (Выборка.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС 
					ИЛИ Выборка.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС) Тогда
					Если ИнтеграцияЕГАИСКлиентСервер.ЕстьРеквизитОбъекта(ЗагруженныйОбъект, "OperationResult")
						И ЗагруженныйОбъект.OperationResult <> Неопределено Тогда
					Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС;
				ИначеЕсли ИнтеграцияЕГАИСКлиентСервер.ЕстьРеквизитОбъекта(ЗагруженныйОбъект, "Result")
					И ЗагруженныйОбъект.Result <> Неопределено Тогда
					Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС;
				КонецЕсли;
			КонецЕсли;
			
			ВходящееСообщениеПараметрыФайла = Новый Структура;
			ВходящееСообщениеПараметрыФайла.Вставить("Автор",                       Выборка.Ответственный);
			ВходящееСообщениеПараметрыФайла.Вставить("ВладелецФайлов",              ОрганизацияЕГАИС);
			ВходящееСообщениеПараметрыФайла.Вставить("ИмяБезРасширения",            Строка(Новый УникальныйИдентификатор));
			ВходящееСообщениеПараметрыФайла.Вставить("РасширениеБезТочки",          "xml");
			ВходящееСообщениеПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Выборка.ДатаЗапроса + ДельтаВремени);
			
			ВходящееСообщениеПрисоединенныйФайл = ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(
				ВходящееСообщениеПараметрыФайла,
				ТекстСообщенияXMLВоВременномХранилище(ВходящееСообщениеТекстСообщенияXML),,,
				Справочники.ЕГАИСПрисоединенныеФайлы.ПолучитьСсылку());
			
			ВходящееСообщениеПрисоединенныйФайлОбъект = ВходящееСообщениеПрисоединенныйФайл.ПолучитьОбъект();
			ВходящееСообщениеПрисоединенныйФайлОбъект.ДатаСоздания         = Выборка.ДатаЗапроса;
			ВходящееСообщениеПрисоединенныйФайлОбъект.Описание             = Выборка.Комментарий;
			ВходящееСообщениеПрисоединенныйФайлОбъект.Операция             = ?(Операция <> Неопределено И АбстрактныеОперации.Найти(Операция) = Неопределено, Операция, Выборка.ВидДокумента);
			ВходящееСообщениеПрисоединенныйФайлОбъект.ТипСообщения         = Выборка.ТипЗапроса;
			ВходящееСообщениеПрисоединенныйФайлОбъект.ХешСумма             = ХешТекстСообщения(ВходящееСообщениеТекстСообщенияXML);
			ВходящееСообщениеПрисоединенныйФайлОбъект.ИдентификаторЗапроса = Выборка.ИдентификаторЗапроса;
			ВходящееСообщениеПрисоединенныйФайлОбъект.Документ             = Выборка.ДокументОснование;
			
			Если Выборка.ПолученОтказ Тогда
				СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ПринятИзЕГАИС;
			Иначе
				СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.Ошибка;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.СообщениеОснование) Тогда
				
				ВходящееСообщениеПрисоединенныйФайлОбъект.ОперацияКвитанции  = Выборка.СообщениеОснованиеОперация;
				ВходящееСообщениеПрисоединенныйФайлОбъект.СообщениеОснование = Выборка.СообщениеОснование;
				
				Если ЗагруженныйОбъект <> Неопределено
					И ВходящееСообщениеПрисоединенныйФайлОбъект.Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС Тогда
					
					ОперацияВыполнена = (ВРег(ЗагруженныйОбъект.OperationResult.OperationResult) <> ВРег("Rejected"));
					
					Если ВРег(ЗагруженныйОбъект.OperationResult.OperationName) = ВРег("Confirm")
						И ОперацияВыполнена Тогда
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ДокументПроведен;
						
					ИначеЕсли ВРег(ЗагруженныйОбъект.OperationResult.OperationName) = ВРег("UnConfirm")
						И ОперацияВыполнена Тогда
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ДокументРаспроведен;
						
					Иначе
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.Ошибка;
						
					КонецЕсли;
					
				КонецЕсли;
				
				Если ЗагруженныйОбъект <> Неопределено
					И ВходящееСообщениеПрисоединенныйФайлОбъект.Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС Тогда
					
					Если ВРег(ЗагруженныйОбъект.Result.Conclusion) = ВРег("Rejected") Тогда
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.Ошибка;
						
					Иначе
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ОбрабатываетсяЕГАИС;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ВходящееСообщениеПрисоединенныйФайлОбъект.СтатусОбработки = СтатусОбработки;
			ВходящееСообщениеПрисоединенныйФайлОбъект.ФорматОбмена    = ФорматОбмена;
		
			НаборЗаписей = РегистрыСведений.УдалитьПротоколОбменаЕГАИС.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИдентификаторСессииОбмена.Установить(Выборка.ИдентификаторСессииОбмена);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВходящееСообщениеПрисоединенныйФайлОбъект);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать запись регистра ""УдалитьПротоколОбменаЕГАИС"" с идентификатором сессии обмена %Идентификатор%
			                            |по причине %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Идентификатор%", Выборка.ИдентификаторСессииОбмена);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         Метаданные.РегистрыСведений.УдалитьПротоколОбменаЕГАИС,
			                         Выборка.ИдентификаторСессииОбмена,
			                         ТекстСообщения);
			
			Продолжить;
			
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(
		Параметры.Очередь,
		"РегистрСведений.УдалитьПротоколОбменаЕГАИС");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
