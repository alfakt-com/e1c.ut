﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ДатаПерехода = Дата('00010101');
	Если ДополнительныеПараметры <> Неопределено Тогда
		ДополнительныеПараметры.Свойство("НоваяДата", ДатаПерехода);
	КонецЕсли;
	
	Статус = Перечисления.СтатусыРеализацийТоваровУслуг[НовыйСтатус];
	
	// Установка даты перехода права собственности
	Если ЗначениеЗаполнено(ДатаПерехода) Тогда
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности
			ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияОСсОтложеннымПереходомПрав Тогда
			ДатаПереходаПраваСобственности = ДатаПерехода;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	ИдентификаторПлатежа   = Неопределено;
	РасшифровкаПлатежа.Очистить();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("Расходы");
	НепроверяемыеРеквизиты.Добавить("Расходы.ВидАктива");
	НепроверяемыеРеквизиты.Добавить("Расходы.ВнеоборотныйАктив");
	
	Если Не ЗначениеЗаполнено(ХозяйственнаяОперация)
		Или ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности 
			И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.РеализацияОСсОтложеннымПереходомПрав Тогда
		НепроверяемыеРеквизиты.Добавить("Статус");
		НепроверяемыеРеквизиты.Добавить("ДатаПереходаПраваСобственности");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Статус)
		Или Статус <> Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено Тогда
		НепроверяемыеРеквизиты.Добавить("ДатаПереходаПраваСобственности");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Соглашение)
		Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		НепроверяемыеРеквизиты.Добавить("Договор");
	КонецЕсли;
	
	Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС Тогда
		НепроверяемыеРеквизиты.Добавить("Доходы.СтавкаНДС");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,Новый Структура("Доходы"), НепроверяемыеРеквизиты, Отказ);
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("Расходы"), НепроверяемыеРеквизиты, Отказ);
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		НепроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	ПродажиСервер.ПроверитьЗапретОтгрузки(Партнер, Отказ);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Документы.СчетФактураВыданный.ПроверитьРеквизитыСчетФактурыПередЗаписьюОснования(ЭтотОбъект);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ДозаполнитьДанныеДоходов();
		ОчиститьНеиспользуемыеРеквизиты();
		
		Если СуммаДокумента > 0 И НЕ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаВзаиморасчетов, РасшифровкаПлатежа);
		Иначе
			Если РасшифровкаПлатежа.Количество() <> 0 Тогда
				РасшифровкаПлатежа.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Доходы);
		
	КонецЕсли;
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Доходы, ЦенаВключаетНДС);
	СтруктураКурса = РаботаСКурсамиВалютУТ.СтруктураКурсаВалюты(Курс, Кратность);
	ЗаполнитьСуммуВзаиморасчетов(СтруктураКурса);
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Доходы", СтруктураКурса);
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;

	ИдентификаторПлатежа = ОбщегоНазначенияУТ.ПолучитьУникальныйИдентификаторПлатежа(ЭтотОбъект);
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.РеализацияКлиенту Тогда
		СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;
		НомерДокументаГЗ = "";
		ДатаДокументаГЗ = Дата(1,1,1);
	КонецЕсли;
	
	Если НЕ (СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеГосЗакупа 
		ИЛИ СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеИСЭСФ) И НЕ ДатаПодписанияГЗ = Дата Тогда
		ДатаПодписанияГЗ = Дата;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.РеализацияУслугПрочихАктивов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС,ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.РеализацияУслугПрочихАктивов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Документы.СчетФактураВыданный.АктуализироватьСчетФактуру(ЭтотОбъект, Истина);
	РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОтразитьНеобходимостьОформленияСчетаФактуры(ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Документы.СчетФактураВыданный.АктуализироватьСчетФактуру(ЭтотОбъект, Ложь);
	РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОтразитьНеобходимостьОформленияСчетаФактуры(ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
		УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(ДанныеЗаполнения);
		
		Если УсловияПродаж.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.РеализацияКлиенту Тогда
			ТекстОшибки = НСтр("ru='Ввод на основании соглашения с операцией `%Операция%.` не допускается.'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Операция%", УсловияПродаж.ХозяйственнаяОперация); 
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		ДопустимыеСтатусы = Новый Массив();
		ДопустимыеСтатусы.Добавить(Перечисления.СтатусыСоглашенийСКлиентами.Действует);
		ОшибкиСтатуса = (УсловияПродаж.СтатусСоглашения <> Перечисления.СтатусыСоглашенийСКлиентами.Действует);
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииСоглашения(УсловияПродаж.Типовое);
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения, УсловияПродаж.СтатусСоглашения, , ОшибкиСтатуса, ДопустимыеСтатусы);
		
		Если (Не УсловияПродаж.Типовое) И ЗначениеЗаполнено(УсловияПродаж.Партнер) Тогда
			Партнер = УсловияПродаж.Партнер;
		КонецЕсли;
		Соглашение = ДанныеЗаполнения;
		Документы.РеализацияУслугПрочихАктивов.ЗаполнитьПоУсловиямПродаж(ЭтотОбъект, УсловияПродаж);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	Если ЗначениеЗаполнено(Договор) И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ТипДоговора") = Перечисления.ТипыДоговоров.СПокупателем
		И НЕ СпособВыпискиАктовВыполненныхРабот = (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "СпособВыпискиАктовВыполненныхРабот"))
		И ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту Тогда
		СпособВыпискиАктовВыполненныхРабот = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "СпособВыпискиАктовВыполненныхРабот");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = ОбщегоНазначенияУТПовтИсп.ДополнительныйПрефиксНумератораДокументыРеализацииТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Документы.РеализацияУслугПрочихАктивов.ЗаполнитьПоУмолчанию(ЭтотОбъект);
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
	ВалютаОплаты  = ДенежныеСредстваСервер.ПолучитьВалютуОплаты(ФормаОплаты, БанковскийСчетОрганизации);
	ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов,НалогообложениеНДС,ВалютаОплаты);
	
	СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;
	
КонецПроцедуры


#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Массив.Добавить(Движения.РасчетыСКлиентами);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ДозаполнитьДанныеДоходов()
	Для Каждого Строка Из Доходы Цикл
		Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС И Не ЗначениеЗаполнено(Строка.СтавкаНДС) Тогда
			Строка.СтавкаНДС = Справочники.СтавкиНДС.БезНДС;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ОчищаемыеРеквизиты = Новый Массив;
	
КонецПроцедуры

Процедура ЗаполнитьСуммуВзаиморасчетов(СтруктураКурса)
	
	Если Доходы.НайтиСтроки(Новый Структура("СуммаВзаиморасчетов", 0)).Количество()=0 Тогда
		
		СуммаВзаиморасчетов = Доходы.Итог("СуммаВзаиморасчетов");
		
	Иначе
		
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетов(ЭтотОбъект, , СтруктураКурса);
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
