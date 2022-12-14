#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет состав документов и хозяйственных операций, доступных для отображения в рабочем месте.
//
// Параметры:
//  ОтборХозяйственныеОперации		 - СписокЗначений - список значений типа ПеречислениеСсылка.ХозяйственныеОперации
//  ОтборТипыДокументов				 - СписокЗначений - список значений типа СправочникСсылка.ИдентификаторыОбъектовМетаданных
//  КлючНазначенияИспользования		 - Строка - ключ рабочего места для которого вызывается функция.
// 
// Возвращаемое значение:
//   - ТаблицаЗначений - См. ОбщегоНазначенияУТ.НоваяТаблицаХозяйственныеОперацииИДокументы
//
Функция ИнициализироватьХозяйственныеОперацииИДокументы(ОтборХозяйственныеОперации,
		ОтборТипыДокументов, КлючНазначенияИспользования) Экспорт
		
	ХозяйственныеОперацииИДокументы = ХозяйственныеОперацииИДокументы();
		
	Если КлючНазначенияИспользования = "ДокументыЗакупки" Тогда
		КлючНастроек = "";
	Иначе
		КлючНастроек = КлючНазначенияИспользования;
	КонецЕсли;
	
	ТаблицаЗначенийДоступно = ОбщегоНазначенияУТ.ДоступныеХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы,
		ОтборХозяйственныеОперации, ОтборТипыДокументов, КлючНастроек);
		
	ИспользоватьАктыРасхожденийПослеПриемкиПоПриемкамТоваровНаХранение = Ложь;
	ИспользоватьАктыРасхожденийПослеОтгрузкиПоОтгрузкамТоваровСХранения = Ложь;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеПриемкиПоПоступлениям") Тогда
		СтрокиКУдалению = ТаблицаЗначенийДоступно.НайтиСтроки(Новый Структура("ПолноеИмяДокумента",
			Метаданные.Документы.АктОРасхожденияхПослеПриемки.ПолноеИмя()));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Если СтрокаКУдалению.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи Тогда
				ТаблицаЗначенийДоступно.Удалить(СтрокаКУдалению);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ИспользоватьАктыРасхожденийПослеПриемкиПоПриемкамТоваровНаХранение Тогда
		СтрокиКУдалению = ТаблицаЗначенийДоступно.НайтиСтроки(Новый Структура("ПолноеИмяДокумента, ХозяйственнаяОперация",
																	Метаданные.Документы.АктОРасхожденияхПослеПриемки.ПолноеИмя(),
																	Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			ТаблицаЗначенийДоступно.Удалить(СтрокаКУдалению);
		КонецЦикла;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеОтгрузкиПоВозвратам") Тогда
		СтрокиКУдалению = ТаблицаЗначенийДоступно.НайтиСтроки(Новый Структура("ПолноеИмяДокумента",
			Метаданные.Документы.АктОРасхожденияхПослеОтгрузки.ПолноеИмя()));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Если СтрокаКУдалению.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ОтгрузкаПринятыхСПравомПродажиТоваровСХранения Тогда
				ТаблицаЗначенийДоступно.Удалить(СтрокаКУдалению);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ИспользоватьАктыРасхожденийПослеОтгрузкиПоОтгрузкамТоваровСХранения Тогда
		СтрокиКУдалению = ТаблицаЗначенийДоступно.НайтиСтроки(Новый Структура("ПолноеИмяДокумента, ХозяйственнаяОперация",
																	Метаданные.Документы.АктОРасхожденияхПослеОтгрузки.ПолноеИмя(),
																	Перечисления.ХозяйственныеОперации.ОтгрузкаПринятыхСПравомПродажиТоваровСХранения));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			ТаблицаЗначенийДоступно.Удалить(СтрокаКУдалению);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаЗначенийДоступно;
	
КонецФункции

Функция ХозяйственныеОперацииИДокументы()
	
	ХозяйственныеОперацииИДокументы = ОбщегоНазначенияУТ.НоваяТаблицаХозяйственныеОперацииИДокументы();
	
	// ПриобретениеТоваровУслуг
	
	СтрокаПриобретениеТоваровУслуг = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаПриобретениеТоваровУслуг;
	Строка.КлючНазначенияИспользования 	= "Накладные";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.ПриобретениеТоваровУслуг");
	Строка.ПолноеИмяДокумента			= "Документ.ПриобретениеТоваровУслуг";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (накладные по приемке)'");
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовЗакупки";
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПриемНаКомиссию;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПриобретениеТоваровУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути;
	
	// АктОРасхожденияхПослеОтгрузки
	
	СтрокаАктОРасхожденияхПослеОтгрузки = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаАктОРасхожденияхПослеОтгрузки;
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратТоваровПоставщику;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки");
	Строка.ПолноеИмяДокумента			= "Документ.АктОРасхожденияхПослеОтгрузки";
	Строка.ИспользуютсяСтатусы          = Истина;
	Строка.КлючНазначенияИспользования 	= "АктОРасхожденияхПослеОтгрузки";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (расхождения)'");
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеОтгрузки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратТоваровКомитенту;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеОтгрузки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОтгрузкаПринятыхСПравомПродажиТоваровСХранения;
	
	// АктОРасхожденияхПослеПриемки
	
	СтрокаАктОРасхожденияхПослеПриемки = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаАктОРасхожденияхПослеПриемки;
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.АктОРасхожденияхПослеПриемки");
	Строка.ПолноеИмяДокумента			= "Документ.АктОРасхожденияхПослеПриемки";
	Строка.ИспользуютсяСтатусы          = Истина;
	Строка.КлючНазначенияИспользования 	= "АктОРасхожденияхПослеПриемки";
	Если УправлениеДоступом.ЕстьРоль("ДобавлениеИзменениеАктовОРасхожденияхПослеПриемкиПоПоступлению") Тогда
		Строка.ИменаЭлементовРабочегоМеста = "ОформляемыеДокументы";
	КонецЕсли;
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (расхождения)'");
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеПриемки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеПриемки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПриемНаКомиссию;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеПриемки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеПриемки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеПриемки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаАктОРасхожденияхПослеПриемки);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС;
	
	СтрокаЗаявлениеОВвозеТоваров = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаЗаявлениеОВвозеТоваров;
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров");
	Строка.ПолноеИмяДокумента			= "Документ.ЗаявлениеОВвозеТоваров";
	Строка.КлючНазначенияИспользования 	= "ЗаявленияОВвозеТоваров";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (заявления о ввозе)'");
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Документ.ЗаявлениеОВвозеТоваров";
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаЗаявлениеОВвозеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаЗаявлениеОВвозеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки;
	
	// КорректировкиПоступлений
	
	СтрокаКорректировкаПриобретения = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаКорректировкаПриобретения;
	Строка.КлючНазначенияИспользования 	= "КорректировкиПоступлений";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.КорректировкаПриобретения");
	Строка.ПолноеИмяДокумента			= "Документ.КорректировкаПриобретения";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (корректировки)'");
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаКорректировкаПриобретения);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаКорректировкаПриобретения);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки;
	
	// СчетФактураПолученный
	
	СтрокаСчетФактураПолученный = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаСчетФактураПолученный;
	Строка.КлючНазначенияИспользования 	= "СчетаФактурыПолученные";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.СчетФактураПолученный");
	Строка.ПолноеИмяДокумента			= "Документ.СчетФактураПолученный";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (счета-фактуры)'");
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратНедопоставленногоТовара;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.НачислениеПоЛизинговомуДоговору;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОплатаПоставщику;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОтчетКомиссионера;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОтчетКомитенту;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПроизводствоУПереработчика;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаСчетФактураПолученный);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки;
	
	// СчетФактураПолученныйНалоговыйАгент
	
	СтрокаСчетФактураПолученный = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаСчетФактураПолученный;
	Строка.КлючНазначенияИспользования 	= "СчетаФактурыПолученныеНалоговыйАгент";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.НачислениеНДСНалоговымАгентом;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент");
	Строка.ПолноеИмяДокумента			= "Документ.СчетФактураПолученныйНалоговыйАгент";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки товаров с обратным обложением НДС (счета-фактуры)'");
	
	// ТаможеннаяДекларацияИмпорт
	
	СтрокаТаможенныеДекларацииИмпорт = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаТаможенныеДекларацииИмпорт;
	Строка.КлючНазначенияИспользования 	= "ТаможенныеДекларацииИмпорт";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.ТаможеннаяДекларацияИмпорт");
	Строка.ПолноеИмяДокумента			= "Документ.ТаможеннаяДекларацияИмпорт";
	Строка.ИспользуютсяСтатусы          = Истина;
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (ГТД)'");
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Документ.ТаможеннаяДекларацияИмпорт";
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаТаможенныеДекларацииИмпорт);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаТаможенныеДекларацииИмпорт);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаТаможенныеДекларацииИмпорт);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки;
	
	// ПриобретениеУслугПрочихАктивов
	
	СтрокаПоступлениеУслуг = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаПоступлениеУслуг;
	Строка.КлючНазначенияИспользования 	= "ПоступленияУслугПрочихАктивов";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов");
	Строка.ПолноеИмяДокумента			= "Документ.ПриобретениеУслугПрочихАктивов";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (накладные)'");
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПоступлениеУслуг);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо;
	
	// ВозвратТоваровПоставщику
	
	СтрокаВозвратТоваровПоставщику = ХозяйственныеОперацииИДокументы.Добавить();
	
	Строка                                       = СтрокаВозвратТоваровПоставщику;
	Строка.КлючНазначенияИспользования           = "ВозвратТоваровПоставщику";
	Строка.ХозяйственнаяОперация                 = Перечисления.ХозяйственныеОперации.ВозвратТоваровПоставщику;
	Строка.ДобавитьКнопкуСоздать                 = Истина;
	Строка.ТипДокумента                          = Тип("ДокументСсылка.ВозвратТоваровПоставщику");
	Строка.ПолноеИмяДокумента                    = "Документ.ВозвратТоваровПоставщику";
	Строка.ЗаголовокРабочегоМеста                = НСтр("ru = 'Документы закупки (возвраты поставщикам)'");
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаВозвратТоваровПоставщику);
	Строка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровКомитенту;
	
	
	// ПоступлениеТоваров
	
	СтрокаПоступлениеТоваров = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаПоступлениеТоваров;
	Строка.КлючНазначенияИспользования 	= "Накладные";
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаПоступлениеИзТоваровВПути;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ТипДокумента 				= Тип("ДокументСсылка.ПоступлениеТоваров");
	Строка.ПолноеИмяДокумента			= "Документ.ПоступлениеТоваров";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Документы закупки (накладные по приемке)'");
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовЗакупки";
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПоступлениеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаНеотфактурованнаяПоставка;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПоступлениеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуПоступлениеИзТоваровВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПоступлениеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСПоступлениеИзТоваровВПути;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка,СтрокаПоступлениеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСНеотфактурованнаяПоставка;
	
	
	Возврат ХозяйственныеОперацииИДокументы;
	
КонецФункции

// Возвращает строковый идентификатор форм обработки "ЖурналДокументовЗакупки" по умолчанию.
//
// ВозвращаемоеЗначение:
//	Строка - идентификатор форм обработки "ЖурналДокументовЗакупки" по умолчанию.
//
Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "ДокументыЗакупки";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
	МассивКомандОтчетов = Команды.НайтиСтроки(Новый Структура("Вид", "Отчеты"));
	МассивКомандПечати = Команды.НайтиСтроки(Новый Структура("Вид", "Печать"));
	
	МенеджерСостояниеВыполненияДокументов = Метаданные.Отчеты.СостояниеВыполненияДокументов.ПолноеИмя();
	МенеджерСостояниеРасчетовСПоставщиками = Метаданные.Отчеты.СостояниеРасчетовСПоставщиками.ПолноеИмя();
	МенеджерКарточкаРасчетовСПоставщиками = Метаданные.Отчеты.КарточкаРасчетовСПоставщиками.ПолноеИмя();
	МенеджерКарточкаРасчетовПоПринятойВозвратнойТаре = Метаданные.Отчеты.КарточкаРасчетовПоПринятойВозвратнойТаре.ПолноеИмя();
	МенеджерОтклоненияОтУсловийЗакупок = Метаданные.Отчеты.ОтклоненияОтУсловийЗакупок.ПолноеИмя();
	МенеджерАнализЦенПоставщиков = Метаданные.Отчеты.АнализЦенПоставщиков.ПолноеИмя();
	МенеджерАнализРасхожденийПриПоступленииАлкогольнойПродукции = Метаданные.Отчеты.АнализРасхожденийПриПоступленииАлкогольнойПродукции.ПолноеИмя();
	
	Для каждого ТекКоманда Из МассивКомандОтчетов Цикл
		Если ТекКоманда.Менеджер = МенеджерСостояниеВыполненияДокументов Тогда
			ТекКоманда.Порядок = 1;
			ТекКоманда.ВидимостьВФормах = "СписокДокументов, ФормаСозданныеДокументы";
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерСостояниеРасчетовСПоставщиками Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовСПоставщиками Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовПоПринятойВозвратнойТаре Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 3;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерОтклоненияОтУсловийЗакупок Тогда
			ТекКоманда.Важность = "СмТакже";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерАнализЦенПоставщиков Тогда
			ТекКоманда.Важность = "СмТакже";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерАнализРасхожденийПриПоступленииАлкогольнойПродукции Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекКоманда Из МассивКомандПечати Цикл
		ТекКоманда.ВидимостьВФормах = "СписокДокументов";
	КонецЦикла;
	
КонецПроцедуры

#Область ФормированиеГиперссылкиВЖурналеЗакупок 

Функция ТекстЗапросаЗаказыКОформлению(Организация = Неопределено, Склад = Неопределено, МассивСсылок = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикам.ЗаказПоставщику КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику ССЫЛКА Документ.ЗаказПоставщику И &УсловиеОтбора) КАК ЗаказыПоставщикам
	|ГДЕ
	|	ЗаказыПоставщикам.КОформлениюОстаток > 0";
	
	УсловиеОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ЗаказПоставщику.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ЗаказПоставщику.Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ЗаказПоставщику.Ссылка В (&МассивСсылок)";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбора", УсловиеОтбора);
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаРаспоряженияНаПриемку(Организация = Неопределено, Склад = Неопределено, МассивСсылок = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаРаспоряжений.ДокументПоступления КАК Ссылка,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Склад) КАК Склад,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Характеристика) КАК Характеристика,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Назначение) КАК Назначение,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Серия) КАК Серия,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Отправитель) КАК Отправитель
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			,
	|			(ДокументПоступления ССЫЛКА Документ.ЗаказПоставщику
	|				ИЛИ ДокументПоступления ССЫЛКА Документ.ПриобретениеТоваровУслуг
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.ДоговорыКонтрагентов
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.СоглашенияСПоставщиками)
	|				И &УсловиеОтбора) КАК ТаблицаРаспоряжений
	|ГДЕ
	|	ТаблицаРаспоряжений.КОформлениюПоступленийПоОрдерамОстаток <> 0
	|	И &УсловиеОтбора
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРаспоряжений.ДокументПоступления";
	
	УсловиеОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Ссылка В (&МассивСсылок)";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбора", УсловиеОтбора);
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ЕстьЗаказыКОформлению(Организация = Неопределено, Склад = Неопределено) Экспорт
	
	Если НЕ (ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПоставщику)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыПоставщикам)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаЗаказыКОформлению(Организация, Склад);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВЫБРАТЬ", "ВЫБРАТЬ ПЕРВЫЕ 1");

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЕстьРаспоряженияНаПриемку(Организация = Неопределено, Склад = Неопределено) Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаРаспоряженияНаПриемку(Организация, Склад);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВЫБРАТЬ РАЗЛИЧНЫЕ", "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1");

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
		
КонецФункции

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	Организация = Параметры.Организация;
	Склад = Параметры.Склад;
	
	ПоказыватьЗаказы = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам")
		И ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПоставщику)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыПоставщикам)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
	
	ПоказыватьРаспоряженияНаПриемку = СкладыСервер.ЕстьОрдерныйНаПоступлениеСклад(Склад,ТекущаяДатаСеанса())
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
		
	ПоказыватьРаспоряженияНаПоступления = (ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков"))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
		
	ГиперссылкаПоЗаказам = Неопределено;
	ГиперссылкаПоПриемке = Неопределено;
	ГиперссылкаПоПоступлениям = Неопределено;
	
	ТекстГиперссылкаПоПоступлениям = НСтр("ru = 'К оформлению поступления'");
	ТекстГиперссылкиПоЗаказам = НСтр("ru = 'К оформлению приобретения'");
	ТекстГиперссылкиПоПриемке = НСтр("ru = 'Контроль ордеров'");
	
	ЦветНезаполненный = ЦветаСтиля.НезаполненноеПолеТаблицы;
	ЦветЗаполненный = ЦветаСтиля.ГиперссылкаЦвет;
	
	МассивСтрок = Новый Массив;
	
	Если ПоказыватьЗаказы Тогда
		ЕстьЗаказы = ЕстьЗаказыКОформлению(Организация, Склад);
		ГиперссылкаПоЗаказам = Новый ФорматированнаяСтрока(ТекстГиперссылкиПоЗаказам,,
			?(ЕстьЗаказы,ЦветЗаполненный,ЦветНезаполненный),
			,
			"СтраницаРаспоряженияНаОформление");
		МассивСтрок.Добавить(ГиперссылкаПоЗаказам);
	КонецЕсли;
	
	Если ПоказыватьРаспоряженияНаПоступления Тогда
		ЕстьРаспоряжения = ЕстьРаспоряженияНаПоступление(Организация, Склад);
		ГиперссылкаПоПоступлениям = Новый ФорматированнаяСтрока(ТекстГиперссылкаПоПоступлениям,,
			?(ЕстьРаспоряжения,ЦветЗаполненный,ЦветНезаполненный),
			,
			"СтраницаРаспоряженияНаПоступление");
			
		Если МассивСтрок.Количество() > 0 Тогда
			МассивСтрок.Добавить("; ");
		КонецЕсли;
		МассивСтрок.Добавить(ГиперссылкаПоПоступлениям)
	КонецЕсли;
	
	Если ПоказыватьРаспоряженияНаПриемку Тогда
		ЕстьРаспоряжения = ЕстьРаспоряженияНаПриемку(Организация, Склад);
		ГиперссылкаПоПриемке = Новый ФорматированнаяСтрока(ТекстГиперссылкиПоПриемке,,
			?(ЕстьРаспоряжения,ЦветЗаполненный,ЦветНезаполненный),
			,
			"СтраницаРаспоряженияНаПриемку");
			
		Если МассивСтрок.Количество() > 0 Тогда
			МассивСтрок.Добавить("; ");
		КонецЕсли;
		МассивСтрок.Добавить(ГиперссылкаПоПриемке);
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ТекстЗапросаРаспоряженияНаПоступление(Организация = Неопределено, Склад = Неопределено, МассивСсылок = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ТаблицаРаспоряжений.ДокументПоступления КАК Ссылка,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Склад) КАК Склад,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Характеристика) КАК Характеристика,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Назначение) КАК Назначение,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Серия) КАК Серия,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Отправитель) КАК Отправитель
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			,
	|			(ДокументПоступления ССЫЛКА Документ.ЗаказПоставщику
	|				ИЛИ ДокументПоступления ССЫЛКА Документ.ПриобретениеТоваровУслуг
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.ДоговорыКонтрагентов
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.СоглашенияСПоставщиками)
	|				И ХозяйственнаяОперация В (&СписокХозОпераций)
	|				И &УсловиеОтбора) КАК ТаблицаРаспоряжений
	|ГДЕ
	|	(ТаблицаРаспоряжений.КОформлениюПоступленийПоНакладнымОстаток <> 0
	|	ИЛИ ТаблицаРаспоряжений.КОформлениюПоступленийПоРаспоряжениюОстаток <> 0)
	|	И &УсловиеОтбора
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРаспоряжений.ДокументПоступления";
	
	УсловиеОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Ссылка В (&МассивСсылок)";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбора", УсловиеОтбора);
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ЕстьРаспоряженияНаПоступление(Организация = Неопределено, Склад = Неопределено) Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаРаспоряженияНаПоступление(Организация, Склад);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВЫБРАТЬ РАЗЛИЧНЫЕ", "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1");

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("СписокХозОпераций", ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов());
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция СформироватьГиперссылкуСмТакжеВРаботе(Параметры) Экспорт
	
	ХозяйственныеОперацииИДокументы = ХозяйственныеОперацииИДокументы();
	НайденныеСтроки = ХозяйственныеОперацииИДокументы.НайтиСтроки(
		Новый Структура("КлючНазначенияИспользования", Параметры.КлючНазначенияИспользования));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выводить = Ложь;
	
	//Все строки с одинаковым ключом должны иметь одинаковый заголовок рабочего места 
	СтрокаПоКлючуНазначенияИспользования = НайденныеСтроки[0];
	
	Возврат Новый ФорматированнаяСтрока(СтрокаПоКлючуНазначенияИспользования.ЗаголовокРабочегоМеста, , , ,
				"Обработка.ЖурналДокументовЗакупки.Форма.СписокДокументов");
	
КонецФункции


#КонецОбласти

#КонецОбласти

#КонецЕсли
