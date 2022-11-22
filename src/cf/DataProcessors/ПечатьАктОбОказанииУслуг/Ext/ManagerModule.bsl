﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
// 		ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
// 		МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "Акт", НСтр("ru='Акт об оказании услуг'"),
			СформироватьПечатнуюФормуАктОбОказанииУслуг(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Р1") Тогда
		
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм, "Р1", НСтр("ru='Акт выполненных работ (Р-1)'"),
		СформироватьПечатнуюФормуАктВыполненныхРаботР1(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, СтруктураТипов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАктОбОказанииУслуг(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктОбОказанииУслуг";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		ЭтаПечатнаяФормаДоступна = Ложь;
		КомандыПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		МенеджерОбъекта.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого ДоступнаяПечатнаяФорма Из КомандыПечати Цикл
			Если ДоступнаяПечатнаяФорма.Идентификатор = "Акт" Тогда
				ЭтаПечатнаяФормаДоступна = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЭтаПечатнаяФормаДоступна Тогда
			Продолжить;
		КонецЕсли;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыАктОбОказанииУслуг(ПараметрыПечати, СтруктураОбъектов.Значение);
		ЗаполнитьТабличныйДокументАктОбОказанииУслуг(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументАктОбОказанииУслуг(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьАктОбОказанииУслуг.ПФ_MXL_Акт");
	
	ИспользоватьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	ПоказыватьНДС = Константы.ВыводитьДопКолонкиНДС.Получить();
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ПервыйДокумент = Истина;
	СтруктураПоиска = Новый Структура("Ссылка");
	СсылкиБезСтрок = Новый Соответствие;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		СтруктураПоиска.Ссылка = ДанныеПечати.Ссылка;
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если СсылкиБезСтрок[ДанныеПечати.Ссылка] = Неопределено Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют услуги. Печать акта об оказании услуг не требуется.'"), ДанныеПечати.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ДанныеПечати.Ссылка);
			КонецЕсли;
			СсылкиБезСтрок.Вставить(ДанныеПечати.Ссылка,ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		ВыборкаПоУслугам = ВыборкаПоДокументам.Выбрать();
		ЗаголовокСкидки = ФормированиеПечатныхФорм.НужноВыводитьСкидки(ВыборкаПоУслугам, ИспользоватьРучныеСкидки Или ИспользоватьАвтоматическиеСкидки);
		ЕстьСкидки = ЗаголовокСкидки.ЕстьСкидки;
		
		ЕстьНДС = ДанныеПечати.УчитыватьНДС;
		ВыборкаПоУслугам.Сбросить();
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку акта
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);

		ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеПечати, НСтр("ru='Акт'"));
		СтруктураДанныхШапки = Новый Структура;
		СтруктураДанныхШапки.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхШапки);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета                                   = Макет.ПолучитьОбласть("Поставщик");
		СтруктураДанныхПоставщик = Новый Структура;
		ПредставлениеПоставщика                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхПоставщик.Вставить("ПредставлениеПоставщика", ПредставлениеПоставщика);
		СтруктураДанныхПоставщик.Вставить("Поставщик", ДанныеПечати.Организация);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхПоставщик);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета                                   = Макет.ПолучитьОбласть("Покупатель");
		СтруктураДанныхПокупатель = Новый Структура;
		ПредставлениеПолучателя                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхПокупатель.Вставить("ПредставлениеПолучателя", ПредставлениеПолучателя);
		СтруктураДанныхПокупатель.Вставить("Получатель", ДанныеПечати.Контрагент);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхПокупатель);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим заголовок таблицы Услуги
		
		СуффиксОбласти = ?(ЕстьСкидки, "СоСкидкой", "") + ?(ЕстьНДС И ПоказыватьНДС, "СНДС", "");
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы" + СуффиксОбласти);
		ОбластьСтроки = Макет.ПолучитьОбласть("Строка" + СуффиксОбласти);
		Если ЕстьСкидки Тогда
			СтруктураЗаголовокСкидки = Новый Структура("Скидка, СуммаБезСкидки", 
				ЗаголовокСкидки.Скидка,
				ЗаголовокСкидки.СуммаСкидки);
			ОбластьМакета.Параметры.Заполнить(СтруктураЗаголовокСкидки);
		КонецЕсли; 
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Сумма       = 0;
		СуммаНДС    = 0;
		НомерСтроки = 0;
		
		// Выводим строки таблицы Услуги
		
		Пока ВыборкаПоУслугам.Следующий() Цикл
		
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьСтроки.Параметры.Заполнить(ВыборкаПоУслугам);
			
			СтруктураДанныхСтроки = Новый Структура;
			СтруктураДанныхСтроки.Вставить("НомерСтроки", НомерСтроки);
			СтруктураДанныхСтроки.Вставить("Товар", НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоУслугам.УслугаНаименованиеПолное,
				ВыборкаПоУслугам.ХарактеристикаНаименованиеПолное));
			
			Если ЕстьСкидки Тогда
				СтруктураДанныхСтроки.Вставить("Скидка", ?(ЗаголовокСкидки.ТолькоНаценка,- ВыборкаПоУслугам.СуммаСкидки,ВыборкаПоУслугам.СуммаСкидки));
				СтруктураДанныхСтроки.Вставить("СуммаБезСкидки", ФормированиеПечатныхФорм.ФорматСумм(ВыборкаПоУслугам.Сумма + ВыборкаПоУслугам.СуммаСкидки));
			КонецЕсли;
			ОбластьСтроки.Параметры.Заполнить(СтруктураДанныхСтроки);
			Сумма    = Сумма    + ВыборкаПоУслугам.Сумма;
			СуммаНДС = СуммаНДС + ВыборкаПоУслугам.СуммаНДС;
			
			ТабличныйДокумент.Вывести(ОбластьСтроки);
		
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		СтруктураДанныхВсего = Новый Структура("Всего", ФормированиеПечатныхФорм.ФорматСумм(Сумма));
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхВсего);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		СтруктураДанныхИтогоНДС = Новый Структура;
		СтруктураДанныхИтогоНДС.Вставить("ВсегоНДС", СуммаНДС);
		Если ЕстьНДС Тогда
			СтруктураДанныхИтогоНДС.Вставить("НДС", ?(ДанныеПечати.ЦенаВключаетНДС, " " + НСтр("ru = 'В том числе НДС'"), " " + НСтр("ru = 'Сумма НДС'")));
		Иначе
			СтруктураДанныхИтогоНДС.Вставить("НДС", НСтр("ru='Без налога (НДС)'"));
		КонецЕсли;
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхИтогоНДС);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СуммаКПрописи = Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		
		ИтоговаяСтрока = НСтр("ru = 'Всего оказано услуг %КоличествоНаименований%, на сумму %СуммаДокумента%'");
		ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%КоличествоНаименований%", НомерСтроки);
		ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%СуммаДокумента%", ФормированиеПечатныхФорм.ФорматСумм(СуммаКПрописи, ДанныеПечати.Валюта));
		
		СтруктураДанныхСуммаПрописью = Новый Структура;
		СтруктураДанныхСуммаПрописью.Вставить("ИтоговаяСтрока", ИтоговаяСтрока);
		СтруктураДанныхСуммаПрописью.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКПрописи, ДанныеПечати.Валюта));
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхСуммаПрописью);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАктВыполненныхРаботР1(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, КомплектыПечати = Неопределено) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктВыполненныхРабот_Р1";
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		Если СтруктураОбъектов.Ключ = "Документ.ОтчетКомиссионераОСписании"
			Или СтруктураОбъектов.Ключ = "Документ.ОтчетКомитентуОСписании" Тогда
			Продолжить;
		КонецЕсли;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыАктВыполненныхРаботР1(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументАктВыполненныхРаботР1(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументАктВыполненныхРаботР1(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьАктОбОказанииУслуг.ПФ_MXL_Р1");
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПересчетВВалютуРегл = ДанныеДляПечати.Свойство("ТаблицаКурсовВалют");
	Если ПересчетВВалютуРегл Тогда
		ТаблицаКурсовВалют = ДанныеДляПечати.ТаблицаКурсовВалют;
		ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
	ПервыйДокумент  = Истина;
	СсылкиБезСтрок  = Новый Соответствие;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка,"Ссылка");
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
		КонецЕсли;
		
		ВыборкаПоДокументам.Сбросить();
		
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(ДанныеПечати.Ссылка, "Ссылка") Тогда
			Если СсылкиБезСтрок[ДанныеПечати.Ссылка] = Неопределено Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют услуги (работы). Печать акта выполненных работ не требуется.'"), ДанныеПечати.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ДанныеПечати.Ссылка);
			КонецЕсли;
			СсылкиБезСтрок.Вставить(ДанныеПечати.Ссылка,ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		ВыборкаПоУслугам = ВыборкаПоДокументам.Выбрать();
		
		ВыборкаПоУслугам.Сбросить();
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент    = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.ДатаДокумента, ,);
		СведенияОЗаказчике    = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент,  ДанныеПечати.ДатаДокумента, ,);
		
		КоэффициентПересчета = 1;
		Если ПересчетВВалютуРегл Тогда
			КоэффициентПересчета = КоэффициентПересчетаВалюты(ДанныеПечати, ТаблицаКурсовВалют, ВалютаРегламентированногоУчета);
		КонецЕсли; 
		
		СтруктураЗаполнения = Новый Структура;
		
		// Выводим общие реквизиты шапки
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		
		//Реквизиты организации
		ПредставлениеИсполнителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование, ЮридическийАдрес, Телефоны", Ложь);
		СтруктураЗаполнения.Вставить("ПредставлениеИсполнителя", ПредставлениеИсполнителя);
		СтруктураЗаполнения.Вставить("ОрганизацияБИН",           ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ИНН", Ложь));
		
		//Реквизиты Контрагента
		ПредставлениеЗаказчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОЗаказчике, "ПолноеНаименование, ЮридическийАдрес, Телефоны", Ложь);
		СтруктураЗаполнения.Вставить("ПредставлениеЗаказчика",   ПредставлениеЗаказчика);
		СтруктураЗаполнения.Вставить("КонтрагентБИН",            ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОЗаказчике, "ИНН", Ложь));
		СтруктураЗаполнения.Вставить("НомерДокумента",           ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеПечати.Номер, Ложь, Истина));
		
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим заголовок таблицы
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ЗаполнитьЗначенияСвойств(ЗаголовокТаблицы.Параметры, ДанныеПечати);
		ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
		
		// инициализация итогов по документу
		ИтогоКоличество = 0;
		ИтогоСумма      = 0;
		Ном             = 0;
		
		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаТаблицы");
		
		// Выборка товаров
		Пока ВыборкаПоУслугам.Следующий() Цикл
			
			Если НЕ ЗначениеЗаполнено(ВыборкаПоУслугам.Номенклатура) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.'")
					);
				Продолжить;
			КонецЕсли;
			
			Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ОбластьМакета) Тогда
				
				// Выведем разрыв страницы
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				// Выведем переносимую часть заголовка таблицы	
				ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
				
			КонецЕсли;
			
			СтруктураЗаполнения = Новый Структура;
			
			Ном = Ном + 1;
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаПоУслугам);
			СтруктураЗаполнения.Вставить("НомерПП", Ном);
			
			СтруктураЗаполнения.Вставить("Наименование", НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(ВыборкаПоУслугам.УслугаНаименованиеПолное,
				ВыборкаПоУслугам.ХарактеристикаНаименованиеПолное));
			
			Если ВыборкаПоУслугам.Количество = 0 Тогда
				Цена      = 0;
				СуммаСНДС = 0;
			Иначе
				ЦенаНеЗадана = НЕ ЗначениеЗаполнено(ВыборкаПоУслугам.Цена);
				Цена         = ?(ЦенаНеЗадана, 0, Окр(ВыборкаПоУслугам.СуммаСНДС * КоэффициентПересчета / ВыборкаПоУслугам.Количество, 2));
				СуммаСНДС    = ?(ЦенаНеЗадана, 0, ВыборкаПоУслугам.СуммаСНДС * КоэффициентПересчета);
			КонецЕсли;
			
			СтруктураЗаполнения.Вставить("Цена",  Цена);
			СтруктураЗаполнения.Вставить("Сумма", СуммаСНДС);
			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Обновим итоги по документу
			ИтогоКоличество = ИтогоКоличество + ВыборкаПоУслугам.Количество;
			ИтогоСумма      = ИтогоСумма      + СуммаСНДС;
		КонецЦикла;
		
		//Выводим итоги по таблице
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		
		СтруктураЗаполнения = Новый Структура;
		
		СтруктураЗаполнения.Вставить("ИтогоКоличество", ИтогоКоличество);
		СтруктураЗаполнения.Вставить("ИтогоСумма",      ИтогоСумма);
		
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Запасы");
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим сноску
		ОбластьМакета = Макет.ПолучитьОбласть("Сноска");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
			КонецЦикла;
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

// Функция получения коэффициента пересчета валюты документа в валюту регл. учета.
//
// Параметры:
//	ДанныеПечати - ВыборкаИзРезультатаЗапроса - Данные шапки документа
//	ВалютаРегламентированногоУчета - СпрвочникСсылка.Валюты - Валюта регл. учета
//
// Возвращаемое значение:
//	Число - Коэффициент пересчета
//
Функция КоэффициентПересчетаВалюты(ДанныеПечати, ТаблицаКурсовВалют, ВалютаРегламентированногоУчета)
	
	КоэффициентПересчета = 1;
	Если ДанныеПечати.Валюта <> ВалютаРегламентированногоУчета Тогда
		
		СтруктураПоиска = Новый Структура("Валюта, Дата", ДанныеПечати.Валюта, НачалоДня(ДанныеПечати.ДатаДокумента));
		Массив = ТаблицаКурсовВалют.НайтиСтроки(СтруктураПоиска);
		Если Массив.Количество() > 0 Тогда
			КоэффициентПересчета = ?(Массив[0].Кратность <> 0, Массив[0].Курс / Массив[0].Кратность, 1);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КоэффициентПересчета;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
