﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает значение параметра учетной политики.
//
// Параметры:
//  УчетнаяПолитика - Справочник - Ссылка на элемент справочника "Учетная политика"
//	ИмяПараметра - Строка - Имя параметра учетной политики, значение которого необходимо получить.
//
// Возвращаемое значение:
// 	ЗначениеПараметра - Значение параметра по имени.
//
Функция ПараметрУчетнойПолитики(Знач УчетнаяПолитика, ИмяПараметра) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	*
		|ИЗ
		|	Справочник.УчетныеПолитикиОрганизаций КАК Данные
		|ГДЕ
		|	Данные.Ссылка = &УчетнаяПолитика");
	
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка[ИмяПараметра], Неопределено);
	
КонецФункции

// Функция возвращает значения параметров учетной политики, которые являются параметризируемыми значениями
// функциональных опций
//		(см. ресурсы регистра сведений "УчетнаяПолитикаОрганизаций").
//
// Параметры:
//  УчетнаяПолитика - Справочник - Ссылка на элемент справочника "Учетная политика".
//
// Возвращаемое значение:
// 	Выборка - ВыборкаИзРезультатаЗапроса  - Выборка параметров учетной политики.
//
Функция ПараметрыУчетнойПолитики(Знач УчетнаяПолитика) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Данные.ПрименяетсяЕНВД КАК ПлательщикЕНВД,
	|	Данные.ПрименяетсяПБУ18,
	|	Данные.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Упрощенная) КАК ПрименяетсяУСН,
	|	ЛОЖЬ КАК ПрименяетсяУСНДоходыМинусРасходы
	|ИЗ
	|	Справочник.УчетныеПолитикиОрганизаций КАК Данные
	|ГДЕ
	|	Данные.Ссылка = &УчетнаяПолитика";
	
	
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка, Неопределено);
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значание:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("МетодОценкиСтоимостиТоваров");
	Результат.Добавить("СистемаНалогообложения");
	Результат.Добавить("ПрименяетсяЕНВД");
	Результат.Добавить("ПрименяетсяУчетНДСПоФактическомуИспользованию");
	Результат.Добавить("МетодНачисленияАмортизацииНУ");
	Результат.Добавить("ПрименяетсяПБУ18");
	Результат.Добавить("УчетГотовойПродукцииПоПлановойСтоимости; ВариантУчетаСтоимостиПродукции");
	Результат.Добавить("ИспользоватьСчет40");
	Результат.Добавить("Учитывать5ПроцентныйПорог");
	Результат.Добавить("ФормироватьРезервыПоСомнительнымДолгамБУ");
	Результат.Добавить("ФормироватьРезервыПоСомнительнымДолгамНУ");
	Результат.Добавить("ПроводкиПоРаботникам");
	Результат.Добавить("ЗабалансовыйУчетТМЦВЭксплуатации");
	Результат.Добавить("ВзаимозачетЧерезСчет76");
	Результат.Добавить("ФормироватьРезервОтпусковБУ");
	Результат.Добавить("ФормироватьРезервОтпусковНУ");
	Результат.Добавить("ОпределятьИзлишкиРезервовОтпусковЕжемесячно");
	Результат.Добавить("МетодНачисленияРезерваОтпусков");
	Результат.Добавить("НормативОтчисленийВРезервОтпусков");
	Результат.Добавить("ПредельнаяВеличинаОтчисленийВРезервОтпусков");
	Результат.Добавить("ОбъектНалогообложенияУСН");
	Результат.Добавить("ДатаПереходаНаУСН");
	Результат.Добавить("УведомлениеНомерУСН");
	Результат.Добавить("УведомлениеДатаУСН");
	Результат.Добавить("СтавкаНалогаУСН");
	Результат.Добавить("БазаРаспределенияКосвенныхРасходовПоВидамДеятельности");
	Результат.Добавить("ВключатьВСоставНалоговыхРасходовЛизинговыеПлатежи");
	Результат.Добавить("ВариантУчетаНДСПриИзмененииВидаДеятельности");
	Результат.Добавить("СтатьяРасходовНеНДС");
	Результат.Добавить("АналитикаРасходовНеНДС");
	Результат.Добавить("СтатьяРасходовЕНВД");
	Результат.Добавить("АналитикаРасходовЕНВД");
	Результат.Добавить("ПрименяетсяОсвобождениеОтУплатыНДС");
	Результат.Добавить("ПравилоОтбораАвансовДляРегистрацииСчетовФактур");
	Результат.Добавить("ВариантУчетаСтоимостиТоваров");
	Результат.Добавить("СборкаТоваровЧерезСчет20");
	Результат.Добавить("РаспределятьНДСМетодомЗачета");
	
	Возврат Результат;
	
КонецФункции

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Если НЕ УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВключен()
		ИЛИ Не ПолучитьФункциональнуюОпцию("ФормироватьОтчетностьПоНДС")
		ИЛИ Не ПолучитьФункциональнуюОпцию("РаспределятьНДС") Тогда
		Результат.Добавить("ПрименяетсяУчетНДСПоФактическомуИспользованию");
		Результат.Добавить("Учитывать5ПроцентныйПорог");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		Результат.Добавить("МетодОценкиСтоимостиТоваров");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Результат.Добавить("ПрименяетсяПБУ18");
		Результат.Добавить("ФормироватьРезервыПоСомнительнымДолгамБУ");
		Результат.Добавить("ФормироватьРезервыПоСомнительнымДолгамНУ");
		Результат.Добавить("ФормироватьРезервОтпусковБУ");
		Результат.Добавить("МетодНачисленияРезерваОтпусков");
		Результат.Добавить("ФормироватьРезервОтпусковНУ");
		Результат.Добавить("ОпределятьИзлишкиРезервовОтпусковЕжемесячно");
		Результат.Добавить("НормативОтчисленийВРезервОтпусков");
		Результат.Добавить("ПредельнаяВеличинаОтчисленийВРезервОтпусков");
		Результат.Добавить("УчетГотовойПродукцииПоПлановойСтоимости");
		Результат.Добавить("ИспользоватьСчет40");
		Результат.Добавить("ПроводкиПоРаботникам");
		Результат.Добавить("ЗабалансовыйУчетТМЦВЭксплуатации");
		Результат.Добавить("ВзаимозачетЧерезСчет76");
		Результат.Добавить("ДатаПереходаНаУСН");
		Результат.Добавить("УведомлениеНомерУСН");
		Результат.Добавить("УведомлениеДатаУСН");
		Результат.Добавить("ОбъектНалогообложенияУСН");
		Результат.Добавить("СтавкаНалогаУСН");
		Результат.Добавить("СборкаТоваровЧерезСчет20");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак использования выпуска по плановой стоимости. 
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период - Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату.
//
// Возвращаемое значение:
// 	Результат - Булево - Значение признака.
// 
Функция ИспользуетсяВыпускПоПлановойСтоимости(Организация, Период = Неопределено) Экспорт
	
	ПериодУчетнойПолитики = ?(ЗначениеЗаполнено(Период), Период, ТекущаяДатаСеанса());
	ПараметрыПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Организация, ПериодУчетнойПолитики);
	
	Если ПараметрыПолитики <> Неопределено Тогда
		Возврат ПараметрыПолитики.УчетГотовойПродукцииПоПлановойСтоимости;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УП 2.4.2,
// заполняет реквизит "СборкаТоваровЧерезСчет20" справочника "УчетныеПолитикиОрганизаций".
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УчетныеПолитикиОрганизаций.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УчетныеПолитикиОрганизаций КАК УчетныеПолитикиОрганизаций
	|ГДЕ
	|	УчетныеПолитикиОрганизаций.ПравилоОтбораАвансовДляРегистрацииСчетовФактур = ЗНАЧЕНИЕ(Перечисление.ПорядокРегистрацииСчетовФактурНаАванс.ПустаяСсылка)
	|	";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	СписокСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, СписокСсылок);
		
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.УчетныеПолитикиОрганизаций";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыОбработки = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(
					Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
					
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка КАК Ссылка,
	|	ТаблицаОбъекта.ВерсияДанных КАК ВерсияДанных
	|ИЗ
	|	 ВТДляОбработки КАК СсылкиДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК ТаблицаОбъекта
	|		ПО ТаблицаОбъекта.Ссылка = СсылкиДляОбработки.Ссылка";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТДляОбработки", ПараметрыОбработки.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	
 	Пока Выборка.Следующий() Цикл
 		
 		НачатьТранзакцию();
		
 		Попытка
			
 			Блокировка = Новый БлокировкаДанных;
 			ЭлементБлокировки = Блокировка.Добавить("Справочник.УчетныеПолитикиОрганизаций");
 			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
 			Блокировка.Заблокировать();
 			
			ДанныеОбъекта = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка, Выборка.ВерсияДанных, Параметры.Очередь);
			Если ДанныеОбъекта = Неопределено Тогда
				ЗафиксироватьТранзакцию();
 				Продолжить;
 			КонецЕсли;
			
			Если ДанныеОбъекта.ПравилоОтбораАвансовДляРегистрацииСчетовФактур = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.ПустаяСсылка() Тогда
				ДанныеОбъекта.ПравилоОтбораАвансовДляРегистрацииСчетовФактур = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеПятиДней; 
			КонецЕсли;
			
 			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДанныеОбъекта);
	
			ЗафиксироватьТранзакцию();
			
 		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать объект: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									Выборка.Ссылка.Метаданные(),
									Выборка.Ссылка,
									ТекстСообщения);
									
 		КонецПопытки;
 
 	КонецЦикла;
 		
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
