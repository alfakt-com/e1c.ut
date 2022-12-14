

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтображениеЭлементов();
	
	ЗагружатьСделкиЭталон = ЗагружатьСделки;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Организация.Видимость 		= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.Подразделение.Видимость 	= ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");
	
	Если НЕ Параметры.Свойство("НастройкаСинхронизации") тогда
		Возврат;	
	КонецЕсли;
	
	НастройкаСинхронизации = Параметры.НастройкаСинхронизации;	
	
	НастройкиОбмена = НастройкаСинхронизации.НастройкиСинхронизации.Получить();
	
	Если НЕ НастройкиОбмена.Свойство("НастройкиСинхронизацииСделок") тогда
		Возврат;                         
	КонецЕсли;

	НастройкиСинхронизацииСделок = НастройкиОбмена.НастройкиСинхронизацииСделок;
	
	СтруктураССхемамиК = Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьСтруктуруСхемКомпоновки();
	
	НастройкиКомпоновкиДанныхСделок = Неопределено;
	НастройкиСинхронизацииСделок.Свойство("НастройкиКомпоновкиДанныхСделок", НастройкиКомпоновкиДанныхСделок);

	АдресСхемы = ПоместитьВоВременноеХранилище(СтруктураССхемамиК.Сделки, УникальныйИдентификатор);
	КомпоновщикНастроекКомпоновкиДанныхСделок.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
	КомпоновщикНастроекКомпоновкиДанныхСделок.ЗагрузитьНастройки(НастройкиКомпоновкиДанныхСделок);
	КомпоновщикНастроекКомпоновкиДанныхСделок.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	НастройкиСинхронизацииСделок.Свойство("Подразделение"	, Подразделение);
	НастройкиСинхронизацииСделок.Свойство("Организация"		, Организация);
	НастройкиСинхронизацииСделок.Свойство("Соглашение"		, Соглашение);
	
	НастройкиСинхронизацииСделок.Свойство("ЗагружатьСделки", ЗагружатьСделки);
	НастройкиСинхронизацииСделок.Свойство("ВыгружатьСделки", ВыгружатьСделки);
	НастройкиСинхронизацииСделок.Свойство("ОбновлятьСделки", ОбновлятьСделки);
	
	НастройкиСинхронизацииСделок.Свойство("ЗагружатьПользовательскиеПоляСделок", ЗагружатьПользовательскиеПоляСделок);
	НастройкиСинхронизацииСделок.Свойство("ВыгружатьПользовательскиеПоляСделок", ВыгружатьПользовательскиеПоляСделок);

	НастройкиСинхронизацииСделок.Свойство("ДатаНачалаЗагрузкиСделок"	, ДатаНачалаЗагрузкиСделок);
	НастройкиСинхронизацииСделок.Свойство("ДатаНачалаВыгрузкиСделок"	, ДатаНачалаВыгрузкиСделок);
	НастройкиСинхронизацииСделок.Свойство("ИсточникДатыДокумента"		, ИсточникДатыДокумента);
	НастройкиСинхронизацииСделок.Свойство("ИсточникНомераДокумента"	, ИсточникНомераДокумента);
	НастройкиСинхронизацииСделок.Свойство("РежимЗаписиДокумента"		, РежимЗаписиДокумента);
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ НужноЗакрытьОкно тогда
		
		Отказ = Истина; 
		
		Если ЗавершениеРаботы = Истина Тогда 
			ТекстПредупреждения = "Настройки по сделкам не будут сохранены. Закрыть?"; 
		Иначе
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОЗакрытииОкна", ЭтаФорма, Параметры);
			ПоказатьВопрос(Оповещение, "Настройки были изменены. Сохранить изменения перед закрытием?", РежимДиалогаВопрос.ДаНетОтмена, 0);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОЗакрытииОкна(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		НужноЗакрытьОкно = Истина;
		
		Если НЕ ПроверкаПередЗаписьюНастроек() тогда
			СохранениеНастроек();
	        Закрыть();
		КонецЕсли;
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет тогда
		НужноЗакрытьОкно = Истина;
		Закрыть();
    КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбъектПриИзменении(Элемент)
	ОбновитьОтображениеЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьПользовательскиеПоляСделокПриИзменении(Элемент)
	ОбновитьОтображениеЭлементов()
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСопоставлениеСтатусов(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкаСинхронизации", НастройкаСинхронизации);
	
	ОткрытьФорму("Справочник.Б24_НастройкиСинхронизацииСБитрикс24.Форма.ФормаСопоставленияСтатусовСделок", ПараметрыФормы, ЭтаФорма, ,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	Если НЕ ПроверкаПередЗаписьюНастроек() тогда
		
		СохранениеНастроек();
		
		Если ЗагружатьСделкиЭталон <> ЗагружатьСделки тогда
			
			Успешно = Б24_RestApiКлиентСервер.ЗарегистрироватьСобытияЭлементовКоннектора(НастройкаСинхронизации);
			
			Если НЕ Успешно тогда
				ЗагружатьСделки = ЗагружатьСделкиЭталон; 	
			Иначе
				Закрыть();
			КонецЕсли;
		Иначе
			Закрыть();
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСинхронизациюКонтрагентов(Команда)
			
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкаСинхронизации", НастройкаСинхронизации);
	ПараметрыФормы.Вставить("ТипЗапуска"			, "Загрузка");
	
	ОткрытьФорму("Справочник.Б24_НастройкиСинхронизацииСБитрикс24.Форма.НастройкаСинхронизацииКонтрагентов", ПараметрыФормы, ЭтаФорма, ,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти


#Область Прочие

&НаКлиенте
Процедура ОбновитьОтображениеЭлементов()
	
	Элементы.НастройкиЗагрузкиЗаказов.Доступность = ЗагружатьСделки;	
	Элементы.НастройкаВыгрузкиЗаказов.Доступность = ВыгружатьСделки;
	
	//Элементы.ЗагрузитьПользовательскиеПоля.Видимость = ЗагружатьПользовательскиеПоляСделок;
КонецПроцедуры

&НаСервере
Процедура СохранениеНастроек()

	НастройкиОбмена = НастройкаСинхронизации.НастройкиСинхронизации.Получить();
	                                                                                                    
	Если НЕ НастройкиОбмена.Свойство("НастройкиСинхронизацииСделок") тогда
		СтруктураНастроек = Новый Структура;	
	Иначе
		СтруктураНастроек = НастройкиОбмена.НастройкиСинхронизацииСделок;	
	КонецЕсли;
	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "Подразделение"	, Подразделение);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "Организация"		, Организация);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "Соглашение"		, Соглашение);
	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ЗагружатьСделки"	, ЗагружатьСделки);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ВыгружатьСделки"	, ВыгружатьСделки);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ОбновлятьСделки"	, ОбновлятьСделки);
	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ЗагружатьПользовательскиеПоляСделок"		,ЗагружатьПользовательскиеПоляСделок);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ВыгружатьПользовательскиеПоляСделок"	, ВыгружатьПользовательскиеПоляСделок);
	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ДатаНачалаЗагрузкиСделок", ДатаНачалаЗагрузкиСделок);	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ДатаНачалаВыгрузкиСделок", ДатаНачалаВыгрузкиСделок);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ИсточникДатыДокумента"	, ИсточникДатыДокумента);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ИсточникНомераДокумента", ИсточникНомераДокумента);
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "РежимЗаписиДокумента"	, РежимЗаписиДокумента);
	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "НастройкиКомпоновкиДанныхСделок", КомпоновщикНастроекКомпоновкиДанныхСделок.ПолучитьНастройки());
	
	Если НЕ НастройкиОбмена.Свойство("НастройкиСинхронизацииСделок") тогда
		НастройкиОбмена.Вставить("НастройкиСинхронизацииСделок", СтруктураНастроек); 	
	Иначе
		НастройкиОбмена.НастройкиСинхронизацииСделок = СтруктураНастроек;
	КонецЕсли;
	
	СтруктураНастроекКонтрагентов 	= НастройкиОбмена.НастройкиСинхронизацииКонтрагентов;	
	СтруктураНастроекТоваров 		= НастройкиОбмена.НастройкиСинхронизацииТоваров;	
	
	Если ВыгружатьСделки тогда
		Если НЕ СтруктураНастроекТоваров.ВыгружатьТовары тогда
			СтруктураНастроекТоваров.ВыгружатьТовары = Истина;
			Сообщить("Принудительно установлено, чтобы товары выгружались из 1С");	
		КонецЕсли;
		
		Если НЕ СтруктураНастроекКонтрагентов.ВыгружатьКонтрагентов тогда
			СтруктураНастроекКонтрагентов.ВыгружатьКонтрагентов = Истина;
			Сообщить("Принудительно установлено, чтобы контрагенты выгружались из 1С");	
		КонецЕсли;
	КонецЕсли;
	
	Если ЗагружатьСделки тогда
		Если НЕ СтруктураНастроекТоваров.ЗагружатьТовары тогда
			СтруктураНастроекТоваров.ЗагружатьТовары = Истина;
			Сообщить("Принудительно установлено, чтобы товары загружались в 1С");	
		КонецЕсли;
		
		Если НЕ СтруктураНастроекКонтрагентов.ЗагружатьКонтрагентов тогда
			СтруктураНастроекКонтрагентов.ЗагружатьКонтрагентов = Истина;
			Сообщить("Принудительно установлено, чтобы контрагенты загружались в 1С");	
		КонецЕсли;
	КонецЕсли;
	
	НастройкиОбмена.НастройкиСинхронизацииТоваров 		= СтруктураНастроекТоваров;
	НастройкиОбмена.НастройкиСинхронизацииКонтрагентов 	= СтруктураНастроекКонтрагентов;
	
	ТекущаяНастройкаСинхронизации = НастройкаСинхронизации.ПолучитьОбъект();
	ТекущаяНастройкаСинхронизации.НастройкиСинхронизации = Новый ХранилищеЗначения(НастройкиОбмена);
	ТекущаяНастройкаСинхронизации.Записать();	
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаПередЗаписьюНастроек()
	
	Результат = Ложь;
	
	НужноЗакрытьОкно = НЕ Результат;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

