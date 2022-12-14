#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
			
			Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ДвиженияТовара" Тогда
				ЭтаФорма.ФормаПараметры.Отбор.Вставить("Номенклатура", Параметры.ПараметрКоманды);
			ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ТоварыВПроцессеОтгрузки" Тогда
				СкладДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "Склад");
				
				ЭтаФорма.ФормаПараметры.Отбор.Вставить("Склад",       СкладДокумента);
				ЭтаФорма.ФормаПараметры.Отбор.Вставить("Регистратор", Параметры.ПараметрКоманды);
			КонецЕсли;
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

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
		
	ИспользуетсяОтборПересчетуТоваров  = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
			КомпоновщикНастроек.Настройки, 
			"ИспользуетсяОтборПересчетуТоваров");
	
	Если ИспользуетсяОтборПересчетуТоваров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуетсяОтборПересчетуТоваров.Значение      = Ложь;
	ИспользуетсяОтборПересчетуТоваров.Использование = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	//ТТ Добавляем доп. поля. Если выбрано "Распоряжение"
	ДопКолонкиЕсть = Ложь;
	Для Каждого ТекЭлемент Из НастройкиОсновнойСхемы.Структура Цикл
		Если Тип(ТекЭлемент) = Тип("ГруппировкаКомпоновкиДанных") Тогда
			Для каждого ТекЭлементГруппировки из ТекЭлемент.ПоляГруппировки.Элементы Цикл
				Если ТекЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("Распоряжение") и НЕ ДопКолонкиЕсть и ТекЭлементГруппировки.Использование Тогда
					ПолеГруппировки = ТекЭлемент.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Номер");
					ПолеГруппировки = ТекЭлемент.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Отправитель");
					ПолеГруппировки = ТекЭлемент.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Получатель");
					ДопКолонкиЕсть = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	//ТТ-
	
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(НастройкиОсновнойСхемы.Отбор,"ПересчетТоваров");
	
	ИспользуетсяОтборПересчетуТоваров = Ложь;
	
	Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ЭлементОтбора.Использование Тогда  
			ИспользуетсяОтборПересчетуТоваров = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрИспользуетсяОтборПересчетуТоваров  = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
			КомпоновщикНастроек.Настройки, 
			"ИспользуетсяОтборПересчетуТоваров");
	
	ПараметрИспользуетсяОтборПересчетуТоваров.Значение = Истина;
	ПараметрИспользуетсяОтборПересчетуТоваров.Использование = ИспользуетсяОтборПересчетуТоваров;
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос;
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ТоварыНаСкладахОстаткиИОбороты.Номенклатура.ЕдиницаИзмерения", "ТоварыНаСкладахОстаткиИОбороты.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ТоварыНаСкладахОстаткиИОбороты.Номенклатура.ЕдиницаИзмерения", "ТоварыНаСкладахОстаткиИОбороты.Номенклатура"));
		
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;
		
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПолучитьЗаголовкиПолей(), МакетКомпоновки);
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураДинамическихЗаголовков(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
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

Функция СтруктураДинамическихЗаголовков()
	ДинамическиеЗаголовки = Новый Структура;
	
	Параметр = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ГруппировкаНоменклатуры");
	ДоступнаяНастройка = ОтчетыКлиентСервер.НайтиДоступнуюНастройку(КомпоновщикНастроек.Настройки, Параметр);
	Если ДоступнаяНастройка <> Неопределено Тогда
		ПредставлениеЗначенияПараметра = ДоступнаяНастройка.ДоступныеЗначения[Параметр.Значение-1];
		ДинамическиеЗаголовки.Вставить("ГруппировкаНоменклатуры", ПредставлениеЗначенияПараметра);
	КонецЕсли;
	
	Возврат ДинамическиеЗаголовки;
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли