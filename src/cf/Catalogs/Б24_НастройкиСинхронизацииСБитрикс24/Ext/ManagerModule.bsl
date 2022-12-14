
#Область Прочее

Функция Версия() Экспорт
	Возврат Б24_ОбщегоНазначенияСервер.Версия();	
КонецФункции

Функция ПроверкаОбновленияДанныхМодуляОбменаСБитрикс24() Экспорт
	Возврат Б24_ОбщегоНазначенияСервер.ПроверкаОбновленияДанныхМодуляОбменаСБитрикс24();	
КонецФункции

Процедура ДобавитьНастройкуВСтруктуру(СтруктураНастроек, НазваниеНастройки, ЗначениеНастройки) Экспорт
	
	Если СтруктураНастроек.Свойство(НазваниеНастройки) тогда
		СтруктураНастроек[НазваниеНастройки] = ЗначениеНастройки;	
	Иначе
		СтруктураНастроек.Вставить(НазваниеНастройки, ЗначениеНастройки);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСтруктуруСхемКомпоновки() Экспорт
	
	Результат = Новый Структура();
	                                      
	Результат.Вставить("Компании"			, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиКомпаний")); 	
	Результат.Вставить("Контакты"			, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиКонтактов")); 	
	Результат.Вставить("Реквизиты"			, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиРеквизитов")); 	
	Результат.Вставить("Адреса"				, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиАдресов")); 	
	Результат.Вставить("БанкСчета"			, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиБанковскихСчетов")); 	
	
	Результат.Вставить("Товары"				, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиТоваров")); 	
	Результат.Вставить("ЕдиницыИзмерения"	, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиЕдиницИзмерения")); 	
	Результат.Вставить("СвойстваТоваров"	, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиСвойствТоваров")); 	
	
	Результат.Вставить("Счета"				, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиСчетов")); 	
	Результат.Вставить("Сделки"				, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиСделок")); 	
	Результат.Вставить("Заказы"				, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиЗаказов")); 	
	Результат.Вставить("Отгрузки"			, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиОтгрузок")); 	
	Результат.Вставить("Оплаты"				, Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиОплат")); 	
		
	Результат.Вставить("ПользовательскиеПоля", Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиПользовательскихПолей")); 	
	
	Результат.Вставить("СвойстваЗаказов"	 , Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьМакет("СхемаВыгрузкиСвойствЗаказов")); 	
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьНастройкиСинхронизацииПоУмолчанию() Экспорт
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор;
	
	СтруктураССхемами = Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ПолучитьСтруктуруСхемКомпоновки();
	
	НастройкиОбмена = Новый Структура;
	
		НастройкиСинхронизацииТоваров = Новый Структура;
		НастройкиСинхронизацииТоваров.Вставить("ВыгружатьТовары"				, Истина);
		НастройкиСинхронизацииТоваров.Вставить("ВыгружатьКартинкиИФайлы"		, Истина);
		
		
		КомпоновщикНастроекКомпоновкиДанныхТоваров = Новый КомпоновщикНастроекКомпоновкиДанных;		
		АдресСхемы = ПоместитьВоВременноеХранилище(СтруктураССхемами.Товары, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанныхТоваров.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
		КомпоновщикНастроекКомпоновкиДанныхТоваров.ЗагрузитьНастройки(СтруктураССхемами.Товары.НастройкиПоУмолчанию);
		
		НастройкиСинхронизацииТоваров.Вставить("НастройкиКомпоновкиДанныхТоваров"	, КомпоновщикНастроекКомпоновкиДанныхТоваров.ПолучитьНастройки());
		
		
		СтавкиНДС = Новый ТаблицаЗначений;
		СтавкиНДС.Колонки.Добавить("НаименованиеСтавкиНДС");
		СтавкиНДС.Колонки.Добавить("ИдСтавки");
		СтавкиНДС.Колонки.Добавить("СтавкаНДС");
		
		НастройкиСинхронизацииТоваров.Вставить("СтавкиНДС"	, СтавкиНДС);
		
		НастройкиСинхронизацииТоваров.Вставить("ЗагружатьТовары", Истина); 		
		НастройкиСинхронизацииТоваров.Вставить("ОбновлятьТовары", Ложь);
		НастройкиСинхронизацииТоваров.Вставить("ТипЦены"		 , Справочники.ВидыЦен.ВидЦеныПоУмолчанию(Неопределено));
		НастройкиСинхронизацииТоваров.Вставить("Склад"			 , Справочники.Склады.СкладПоУмолчанию());
		
		НастройкиСинхронизацииТоваров.Вставить("ВыгружатьКартинкиИФайлы" , Истина);
		НастройкиСинхронизацииТоваров.Вставить("ЗагружатьКартинкиИФайлы" , Ложь);
		
		НастройкиСинхронизацииТоваров.Вставить("ИдентификаторКаталога" 	, "");
		НастройкиСинхронизацииТоваров.Вставить("ДеревоГрупп" 			, Справочники.Б24_ПользовательскиеГруппыТоваров.ПустаяСсылка());
		
	НастройкиОбмена.Вставить("НастройкиСинхронизацииТоваров", НастройкиСинхронизацииТоваров);
	
	
	///////////////////////////////////////////
	// 			КОНТРАГЕНТЫ					//
	/////////////////////////////////////////
	
	
		СпкПорядокИдентификацииЮ = новый СписокЗначений;
		СпкПорядокИдентификацииЮ.Добавить("Внешний идентификатор");
		
		СпкПорядокИдентификацииФ = новый СписокЗначений;
		СпкПорядокИдентификацииФ.Добавить("Внешний идентификатор");
	
		НастройкиСинхронизацииКонтрагентов = Новый Структура;
		НастройкиСинхронизацииКонтрагентов.Вставить("ПорядокИдентификацииФизЛиц", СпкПорядокИдентификацииФ);
		НастройкиСинхронизацииКонтрагентов.Вставить("ПорядокИдентификацииЮрЛиц"	, СпкПорядокИдентификацииЮ);
		
		
		СпкТипыКонтрагентовДляКомпаний = новый СписокЗначений;
		СпкТипыКонтрагентовДляКомпаний.Добавить(Перечисления.КомпанияЧастноеЛицо.Компания);
		
		СпкТипыКонтрагентовДляКонтактов = новый СписокЗначений;
		СпкТипыКонтрагентовДляКонтактов.Добавить(Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо);
	
		НастройкиСинхронизацииКонтрагентов.Вставить("ТипыКонтрагентовДляКомпаний"	, СпкТипыКонтрагентовДляКомпаний);
		НастройкиСинхронизацииКонтрагентов.Вставить("ТипыКонтрагентовДляКонтактов"	, СпкТипыКонтрагентовДляКонтактов);
		
		
		КомпоновщикНастроекКомпоновкиДанныхКонтрагентов = Новый КомпоновщикНастроекКомпоновкиДанных;		
		АдресСхемы = ПоместитьВоВременноеХранилище(СтруктураССхемами.Компании, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанныхКонтрагентов.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
		КомпоновщикНастроекКомпоновкиДанныхКонтрагентов.ЗагрузитьНастройки(СтруктураССхемами.Компании.НастройкиПоУмолчанию);
		
		НастройкиСинхронизацииКонтрагентов.Вставить("НастройкиКомпоновкиДанныхКонтрагентов"	, КомпоновщикНастроекКомпоновкиДанныхКонтрагентов.ПолучитьНастройки());
		
		тзнПресеты = Новый ТаблицаЗначений;
		тзнПресеты.Колонки.Добавить("НаименованиеШаблона");
		тзнПресеты.Колонки.Добавить("ИдШаблона");
		тзнПресеты.Колонки.Добавить("ТипКонтрагента");
		
		НастройкиСинхронизацииКонтрагентов.Вставить("Пресеты", тзнПресеты);
		
		НастройкиСинхронизацииКонтрагентов.Вставить("ЗагружатьКонтрагентов"	, Истина);
		НастройкиСинхронизацииКонтрагентов.Вставить("ВыгружатьКонтрагентов"	, Истина);
		НастройкиСинхронизацииКонтрагентов.Вставить("ОбновлятьКонтрагентов"	, Истина);
		НастройкиСинхронизацииКонтрагентов.Вставить("ГруппаДляНовыхКонтрагентов", Справочники.Контрагенты.ПустаяСсылка());
		
		НастройкиСинхронизацииКонтрагентов.Вставить("ВыгружатьПользовательскиеПоляКомпанийИКонтактов", Истина);
		НастройкиСинхронизацииКонтрагентов.Вставить("ЗагружатьПользовательскиеПоляКомпанийИКонтактов", Истина);
		
	НастройкиОбмена.Вставить("НастройкиСинхронизацииКонтрагентов", НастройкиСинхронизацииКонтрагентов);
	
	
	///////////////////////////////////////////
	// 				СЧЕТА			  		//
	/////////////////////////////////////////
	
		НастройкиСинхронизацииСчетов = Новый Структура;
		НастройкиСинхронизацииСчетов.Вставить("ЗагружатьСчета"	, Истина);
		НастройкиСинхронизацииСчетов.Вставить("ВыгружатьСчета"	, Истина);
		НастройкиСинхронизацииСчетов.Вставить("ОбновлятьСчета"	, Истина);
		
		НастройкиСинхронизацииСчетов.Вставить("ЗагружатьПользовательскиеПоляСчетов", Истина);
		НастройкиСинхронизацииСчетов.Вставить("ВыгружатьПользовательскиеПоляСчетов", Истина);
		
		НастройкиСинхронизацииСчетов.Вставить("Подразделение"	, Справочники.СтруктураПредприятия.ПустаяСсылка());

		НастройкиСинхронизацииСчетов.Вставить("ДатаНачалаЗагрузкиСчетов"	, ТекущаяДата()- 60*60*24*30);
		НастройкиСинхронизацииСчетов.Вставить("ДатаНачалаВыгрузкиСчетов"	, ТекущаяДата()- 60*60*24*30);
		
		НастройкиСинхронизацииСчетов.Вставить("ИсточникДатыДокумента"		, "Автоматически в 1С");
		НастройкиСинхронизацииСчетов.Вставить("ИсточникНомераДокумента"		, "Автоматически в 1С");
		НастройкиСинхронизацииСчетов.Вставить("РежимЗаписиДокумента"		, "Проводить оплаченные");
		
		ПечатныеФормыСчетов = Новый ТаблицаЗначений;
		ПечатныеФормыСчетов.Колонки.Добавить("НаименованиеПечатнойФормы");
		ПечатныеФормыСчетов.Колонки.Добавить("ИдПечатнойФормы");
		ПечатныеФормыСчетов.Колонки.Добавить("Используется");
		ПечатныеФормыСчетов.Колонки.Добавить("ТипКлиента");
		ПечатныеФормыСчетов.Колонки.Добавить("Организация");
		
		НастройкиСинхронизацииСчетов.Вставить("ПечатныеФормыСчетов", ПечатныеФормыСчетов);
		
		КомпоновщикНастроекКомпоновкиДанныхСчетов = Новый КомпоновщикНастроекКомпоновкиДанных;		
		АдресСхемы = ПоместитьВоВременноеХранилище(СтруктураССхемами.Счета, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанныхСчетов.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
		КомпоновщикНастроекКомпоновкиДанныхСчетов.ЗагрузитьНастройки(СтруктураССхемами.Счета.НастройкиПоУмолчанию);
		
		НастройкиСинхронизацииСчетов.Вставить("НастройкиКомпоновкиДанныхСчетов"	, КомпоновщикНастроекКомпоновкиДанныхСчетов.ПолучитьНастройки());
		
	НастройкиОбмена.Вставить("НастройкиСинхронизацииСчетов", НастройкиСинхронизацииСчетов);
	
	
	///////////////////////////////////////////
	// 				СДЕЛКИ			 		//
	/////////////////////////////////////////
	
		НастройкиСинхронизацииСделок = Новый Структура;
		НастройкиСинхронизацииСделок.Вставить("ЗагружатьСделки"	, Истина);
		НастройкиСинхронизацииСделок.Вставить("ВыгружатьСделки"	, Истина);
		НастройкиСинхронизацииСделок.Вставить("ОбновлятьСделки"	, Истина);
		
		НастройкиСинхронизацииСделок.Вставить("ЗагружатьПользовательскиеПоляСделок"	, Истина);
		НастройкиСинхронизацииСделок.Вставить("ВыгружатьПользовательскиеПоляСделок"	, Истина);
		
		
		НастройкиСинхронизацииСделок.Вставить("Подразделение"	, Справочники.СтруктураПредприятия.ПустаяСсылка());
		НастройкиСинхронизацииСделок.Вставить("Организация"		, Справочники.Организации.ОрганизацияПоУмолчанию());
		НастройкиСинхронизацииСделок.Вставить("Соглашение"		, Справочники.СоглашенияСКлиентами.ПустаяСсылка());
		
		НастройкиСинхронизацииСделок.Вставить("ДатаНачалаЗагрузкиСделок"	, ТекущаяДата()- 60*60*24*30);
		НастройкиСинхронизацииСделок.Вставить("ДатаНачалаВыгрузкиСделок"	, ТекущаяДата()- 60*60*24*30);
		НастройкиСинхронизацииСделок.Вставить("ИсточникДатыДокумента"		, "Автоматически в 1С");
		НастройкиСинхронизацииСделок.Вставить("ИсточникНомераДокумента"		, "Автоматически в 1С");
		НастройкиСинхронизацииСделок.Вставить("РежимЗаписиДокумента"		, "Проводить закрытые");
		
		
		КомпоновщикНастроекКомпоновкиДанныхСделок = Новый КомпоновщикНастроекКомпоновкиДанных;		
		АдресСхемы = ПоместитьВоВременноеХранилище(СтруктураССхемами.Сделки, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанныхСделок.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
		КомпоновщикНастроекКомпоновкиДанныхСделок.ЗагрузитьНастройки(СтруктураССхемами.Сделки.НастройкиПоУмолчанию);		
		
		НастройкиСинхронизацииСделок.Вставить("НастройкиКомпоновкиДанныхСделок"	, КомпоновщикНастроекКомпоновкиДанныхСделок.ПолучитьНастройки());
		
	НастройкиОбмена.Вставить("НастройкиСинхронизацииСделок", НастройкиСинхронизацииСделок);	
	
	///////////////////////////////////////////
	// 				ЗАКАЗЫ			 		//
	/////////////////////////////////////////
	
		НастройкиСинхронизацииЗаказов = Новый Структура;
		НастройкиСинхронизацииЗаказов.Вставить("ЗагружатьЗаказы"	, Истина);
		НастройкиСинхронизацииЗаказов.Вставить("ВыгружатьЗаказы"	, Истина);
		НастройкиСинхронизацииЗаказов.Вставить("ОбновлятьДокументы"	, Истина);
		
		НастройкиСинхронизацииЗаказов.Вставить("ЗагружатьПользовательскиеПоляЗаказов"	, Истина);
		НастройкиСинхронизацииЗаказов.Вставить("ВыгружатьПользовательскиеПоляЗаказов"	, Истина);		
		
		НастройкиСинхронизацииЗаказов.Вставить("Подразделение"	, Справочники.СтруктураПредприятия.ПустаяСсылка());
		НастройкиСинхронизацииЗаказов.Вставить("Организация"	, Справочники.Организации.ОрганизацияПоУмолчанию());
		НастройкиСинхронизацииЗаказов.Вставить("Соглашение"		, Справочники.СоглашенияСКлиентами.ПустаяСсылка());
		НастройкиСинхронизацииЗаказов.Вставить("ВидЗаказа"		, Неопределено);
		НастройкиСинхронизацииЗаказов.Вставить("Ответственный"	, Справочники.Пользователи.ПустаяСсылка());	
		
		НастройкиСинхронизацииЗаказов.Вставить("ДатаНачалаЗагрузкиЗаказов"	, ТекущаяДата()- 60*60*24*30);
		НастройкиСинхронизацииЗаказов.Вставить("ДатаНачалаВыгрузкиЗаказов"	, ТекущаяДата()- 60*60*24*30);
		НастройкиСинхронизацииЗаказов.Вставить("ИсточникДатыДокумента"		, "Автоматически в 1С");
		НастройкиСинхронизацииЗаказов.Вставить("ИсточникНомераДокумента"	, "Автоматически в 1С");
		НастройкиСинхронизацииЗаказов.Вставить("РежимЗаписиДокумента"		, "Проводить закрытые");
		НастройкиСинхронизацииЗаказов.Вставить("КогдаОтменен"				, "Помечать на удаление");		
		НастройкиСинхронизацииЗаказов.Вставить("Склад"						, Справочники.Склады.СкладПоУмолчанию());		
		НастройкиСинхронизацииЗаказов.Вставить("НоменклатураДоставка"		, Справочники.Номенклатура.ПустаяСсылка());		
		
		
		НастройкиСинхронизацииЗаказов.Вставить("ЗагружатьОплаты"		, Истина);
		НастройкиСинхронизацииЗаказов.Вставить("ВыгружатьОплаты"		, Истина);
		НастройкиСинхронизацииЗаказов.Вставить("ПроводитьЕслиОплачен"	, Истина);		
		НастройкиСинхронизацииЗаказов.Вставить("СтатьяДДС"				, Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка());		
		НастройкиСинхронизацииЗаказов.Вставить("СтавкаНДСРасшифровки"	, Неопределено);		
		
		НастройкиСинхронизацииЗаказов.Вставить("ЗагружатьОтгрузки"		, Ложь);
		НастройкиСинхронизацииЗаказов.Вставить("ВыгружатьОтгрузки"		, Истина);
		НастройкиСинхронизацииЗаказов.Вставить("ПроводитьЕслиОтгружен"	, Ложь);
		
		НастройкиСинхронизацииЗаказов.Вставить("ВыгружатьОфлайнЗаказы"	, Ложь);
			
		КомпоновщикНастроекКомпоновкиДанныхЗаказов = Новый КомпоновщикНастроекКомпоновкиДанных;		
		АдресСхемы = ПоместитьВоВременноеХранилище(СтруктураССхемами.Заказы, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанныхЗаказов.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
		КомпоновщикНастроекКомпоновкиДанныхЗаказов.ЗагрузитьНастройки(СтруктураССхемами.Заказы.НастройкиПоУмолчанию);		
		
		НастройкиСинхронизацииЗаказов.Вставить("НастройкиКомпоновкиДанныхЗаказов"	, КомпоновщикНастроекКомпоновкиДанныхЗаказов.ПолучитьНастройки());
		
	НастройкиОбмена.Вставить("НастройкиСинхронизацииЗаказов", НастройкиСинхронизацииЗаказов);
		
	Возврат НастройкиОбмена;
	
КонецФункции

#КонецОбласти


