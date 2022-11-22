﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		Если Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
			
			Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ОстаткиНоменклатурыПоСрокамГодности" Тогда
				ЭтаФорма.ФормаПараметры.Отбор.Вставить("Номенклатура", Параметры.ПараметрКоманды);
			КонецЕсли;
			
		Иначе
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ПересчетТоваров", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПослеЗаполненияПанелиБыстрыхНастроек
//
Процедура ПослеЗаполненияПанелиБыстрыхНастроек(ЭтаФорма, ПараметрыЗаполнения) Экспорт
	
	
	// Оптимизация взаимного расположения отбора и параметров периода истечения срока годности.
	ЭлементыФормы = ЭтаФорма.Элементы;

	Если ЭлементыФормы.Найти("Периоды") <> Неопределено
		И ЭлементыФормы.Периоды.ПодчиненныеЭлементы.Количество()Тогда
		
		СтруктураИстечениеСрокаГодности = НайтиЭлементФормыПоПредставлениюОтбора(ЭтаФорма, "С истекающим сроком годности", Истина);
		Если СтруктураИстечениеСрокаГодности <> Неопределено Тогда
			Если СтруктураИстечениеСрокаГодности.ГруппаОтбораИспользование <> Неопределено Тогда
				ЭлементыФормы.Переместить(СтруктураИстечениеСрокаГодности.ГруппаОтбораИспользование,
					ЭлементыФормы.Периоды,
					ЭлементыФормы.Периоды.ПодчиненныеЭлементы[0]);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СхемаЗапроса = ПолучитьМакет("ЗапросОстатковПоСправочномуУчетуСроковГодности");
	
	ТекстЗапроса = СхемаЗапроса.НаборыДанных.НаборВозможныхСерий.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения",
																							"ТоварыНаСкладахОстатки.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения",
																							"ТоварыНаСкладахОстатки.Номенклатура"));
	СхемаЗапроса.НаборыДанных.НаборВозможныхСерий.Запрос = ТекстЗапроса;	
	
	
	НастройкиЗапроса = СхемаЗапроса.НастройкиПоУмолчанию;
	
	ОсновнаяСхема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
	ТекстЗапроса = ОсновнаяСхема.НаборыДанных.СерииОстаткиИСерииСправочно.Элементы.ЗапросПоОстаткам.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения",
																							"ТоварыНаСкладахОстатки.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения",
																							"ТоварыНаСкладахОстатки.Номенклатура"));
	ОсновнаяСхема.НаборыДанных.СерииОстаткиИСерииСправочно.Элементы.ЗапросПоОстаткам.Запрос = ТекстЗапроса;	
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновкаДанныхКлиентСервер.СкопироватьОтборКомпоновкиДанных(СхемаЗапроса, НастройкиЗапроса, НастройкиОсновнойСхемы);
	КомпоновкаДанныхКлиентСервер.ЗаполнитьЭлементы(НастройкиЗапроса.ПараметрыДанных, НастройкиОсновнойСхемы.ПараметрыДанных);
	
	СкладскиеОперацииПриемки = Перечисления.СкладскиеОперации.СкладскиеОперацииПриемки();
	СкладскиеОперацииПриемки.Добавить(Перечисления.СкладскиеОперации.ПеремещениеМеждуПомещениями);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиЗапроса, "СкладскиеОперацииПриемки", СкладскиеОперацииПриемки, Истина);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаЗапроса,НастройкиЗапроса,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.ОтображатьПроцентВывода = Истина;
	ДеревоОбработки = Новый ДеревоЗначений;
	ПроцессорВывода.УстановитьОбъект(ДеревоОбработки);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	ОстаткиСерийСправочно = Новый ТаблицаЗначений;
	ОстаткиСерийСправочно.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ОстаткиСерийСправочно.Колонки.Добавить("ЕдиницаХранения", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ОстаткиСерийСправочно.Колонки.Добавить("ЕдиницаДляОтчетов", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ОстаткиСерийСправочно.Колонки.Добавить("КоэффициентЕдиницыДляОтчетов", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)));
	ОстаткиСерийСправочно.Колонки.Добавить("НоменклатураВес", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)));
	ОстаткиСерийСправочно.Колонки.Добавить("НоменклатураОбъем", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)));
	ОстаткиСерийСправочно.Колонки.Добавить("СрокГодности", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,0)));
	ОстаткиСерийСправочно.Колонки.Добавить("ЕдиницаИзмеренияСрокаГодности", Новый ОписаниеТипов("ПеречислениеСсылка.ЕдиницыИзмеренияВремени"));
	ОстаткиСерийСправочно.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ОстаткиСерийСправочно.Колонки.Добавить("Назначение", Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	ОстаткиСерийСправочно.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	ОстаткиСерийСправочно.Колонки.Добавить("Помещение", Новый ОписаниеТипов("СправочникСсылка.СкладскиеПомещения"));
	ОстаткиСерийСправочно.Колонки.Добавить("Остаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,3)));
	ОстаткиСерийСправочно.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ОстаткиСерийСправочно.Колонки.Добавить("ГоденДо", Новый ОписаниеТипов("Дата"));
	ОстаткиСерийСправочно.Колонки.Добавить("УказыватьСрокГодностиСТочностьюДоЧасов", Новый ОписаниеТипов("Булево"));
	
	ИспользоватьЕдиницыИзмеренияДляОтчетов = ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов");
	
	Для каждого СтрТовары Из ДеревоОбработки.Строки Цикл
		
		КоличествоТоваров = СтрТовары.ВНаличииОстаток;
		
		Для Каждого СтрСрокаГодности Из СтрТовары.Строки Цикл
			
			НоваяСтрокаДанных = ОстаткиСерийСправочно.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДанных,СтрСрокаГодности);
			
			НоваяСтрокаДанных.СрокГодности = СтрСрокаГодности.СрокГодностиАвторасчет;
			НоваяСтрокаДанных.ЕдиницаИзмеренияСрокаГодности = СтрСрокаГодности.ЕдиницаИзмеренияСрокаГодностиАвторасчет;
			НоваяСтрокаДанных.Серия = СтрСрокаГодности.СерияАвторасчет;
			НоваяСтрокаДанных.ГоденДо = СтрСрокаГодности.ГоденДоАвторасчет;
			НоваяСтрокаДанных.УказыватьСрокГодностиСТочностьюДоЧасов = СтрСрокаГодности.УказыватьСрокГодностиСТочностьюДоЧасовАвторасчет;
			НоваяСтрокаДанных.ЕдиницаХранения = СтрСрокаГодности.ЕдиницаХраненияАвторасчет;
			
			Если ИспользоватьЕдиницыИзмеренияДляОтчетов Тогда
				НоваяСтрокаДанных.ЕдиницаДляОтчетов = СтрСрокаГодности.ЕдиницаДляОтчетовАвторасчет;
				НоваяСтрокаДанных.КоэффициентЕдиницыДляОтчетов = СтрСрокаГодности.КоэффициентЕдиницыДляОтчетовАвторасчет;
			КонецЕсли;
			
			НоваяСтрокаДанных.НоменклатураВес = СтрСрокаГодности.НоменклатураВесАвторасчет;
			НоваяСтрокаДанных.НоменклатураОбъем = СтрСрокаГодности.НоменклатураОбъемАвторасчет;
			
			НоваяСтрокаДанных.Остаток = Мин(КоличествоТоваров, СтрСрокаГодности.КоличествоСерия);
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрокаДанных.Остаток;
			
			Если КоличествоТоваров <= 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если КоличествоТоваров <> 0 Тогда
			
			НоваяСтрокаДанных = ОстаткиСерийСправочно.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДанных, СтрТовары);
			
			НоваяСтрокаДанных.СрокГодности = СтрТовары.СрокГодностиАвторасчет;
			НоваяСтрокаДанных.ЕдиницаИзмеренияСрокаГодности = СтрТовары.ЕдиницаИзмеренияСрокаГодностиАвторасчет;
			НоваяСтрокаДанных.Серия = СтрТовары.СерияАвторасчет;
			НоваяСтрокаДанных.ГоденДо = СтрТовары.ГоденДоАвторасчет;
			НоваяСтрокаДанных.УказыватьСрокГодностиСТочностьюДоЧасов = СтрТовары.УказыватьСрокГодностиСТочностьюДоЧасовАвторасчет;
			НоваяСтрокаДанных.ЕдиницаХранения = СтрСрокаГодности.ЕдиницаХраненияАвторасчет;
			
			Если ИспользоватьЕдиницыИзмеренияДляОтчетов Тогда
				НоваяСтрокаДанных.ЕдиницаДляОтчетов = СтрСрокаГодности.ЕдиницаДляОтчетовАвторасчет;
				НоваяСтрокаДанных.КоэффициентЕдиницыДляОтчетов = СтрСрокаГодности.КоэффициентЕдиницыДляОтчетовАвторасчет;
			КонецЕсли;
			
			НоваяСтрокаДанных.НоменклатураВес = СтрСрокаГодности.НоменклатураВесАвторасчет;
			НоваяСтрокаДанных.НоменклатураОбъем = СтрСрокаГодности.НоменклатураОбъемАвторасчет;
			
			НоваяСтрокаДанных.Остаток = КоличествоТоваров;
			
		КонецЕсли;
		
	КонецЦикла;

	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ОстаткиСерийСправочно", ОстаткиСерийСправочно);
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ОсновнаяСхема, НастройкиОсновнойСхемы, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПолучитьЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция ПолучитьЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СтруктураЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиЭлементФормыПоПредставлениюОтбора(ЭтаФорма, ПредставлениеОтбора, ИскатьГруппу = Ложь)
	СтруктураИскомыйЭлемент = Неопределено;
	НайденныйОтбор = Неопределено;
	ЭлементыФормы = ЭтаФорма.Элементы;
	НастройкиКомпоновкиДанных = ЭтаФорма.Отчет.КомпоновщикНастроек.Настройки;
	
	Для каждого ЭлементОтбора Из НастройкиКомпоновкиДанных.Отбор.Элементы Цикл
		Если ЭлементОтбора.Представление = ПредставлениеОтбора Тогда
			НайденныйОтбор = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НайденныйОтбор <> Неопределено Тогда
		ИдентификаторПользовательскойНастройки = НайденныйОтбор.ИдентификаторПользовательскойНастройки;
		Если Не ПустаяСтрока(ИдентификаторПользовательскойНастройки) Тогда
			ИдПараметрСтрока = СтрЗаменить(ИдентификаторПользовательскойНастройки, "-", "");
			Если ИскатьГруппу Тогда
				СтруктураИскомыйЭлемент = Новый Структура("ГруппаОтбора,
				|ГруппаОтбораИспользование,
				|ГруппаПанелиОтбора",
				ЭлементыФормы.Найти("ГруппаОтбора_" + ИдПараметрСтрока),
				ЭлементыФормы.Найти("ГруппаОтбора_Использование_" + ИдПараметрСтрока),
				ЭлементыФормы.Найти("ГруппаПанелиОтбора_" + ИдПараметрСтрока));
			Иначе
				СтруктураИскомыйЭлемент = Новый Структура("Отбор,
				|ИспользованиеОтбора,
				|ОтборЗначение",
				ЭлементыФормы.Найти("Отбор_" + ИдПараметрСтрока),
				ЭлементыФормы.Найти("ИспользованиеОтбора_" + ИдПараметрСтрока),
				ЭлементыФормы.Найти("Отбор_Значение_" + ИдПараметрСтрока));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураИскомыйЭлемент;
КонецФункции

#КонецОбласти

#КонецЕсли