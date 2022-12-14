
//кт Начало Апаев_О [28.08.2022]
//Отправка отчета по выручке XML на почту
Процедура ОтправитьОтчетПоВыручкеXML() Экспорт 
	
	УчетнаяЗапись = Константы.кт_УчетнаяЗаписьДляРассылкиОтчетов.Получить();
	
	Если НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат;
	КонецЕсли;
	
	ПериодВыгрузки = ТекущаяДата();
	ИмяФайла = "Отчет по выручке " + Строка(Формат(ПериодВыгрузки, "ДФ=MMMM")) + " " + СтрЗаменить(Год(ПериодВыгрузки), " ", "");
	
	//кт Начало Апаев_О [15.10.2022]
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КонтрольОтправкиОтчетовПоВыручке.Ошибка КАК Ошибка
	|ИЗ
	|	РегистрСведений.кт_КонтрольОтправкиОтчетовПоВыручке КАК КонтрольОтправкиОтчетовПоВыручке
	|ГДЕ
	|	КонтрольОтправкиОтчетовПоВыручке.ДатаОтправки = &ДатаОтправки
	|	И КонтрольОтправкиОтчетовПоВыручке.Статус = &Статус
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрольОтправкиОтчетовПоВыручке.Ошибка";
	
	Запрос.УстановитьПараметр("ДатаОтправки", НачалоДня(ПериодВыгрузки));
	Запрос.УстановитьПараметр("Статус", Перечисления.кт_СтатусыОтправкиПисем.Отправлено);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	//кт Начало Апаев_О [15.10.2022]
	
	НачалоПериода = НачалоМесяца(ПериодВыгрузки);
	КонецПериода  = КонецДня(ПериодВыгрузки);
	
	Пакет = Новый ПакетОтображаемыхДокументов;
	
	ВыгрузкаОтчетаПоВыручке = Обработки.кт_ВыгрузкаОтчетаПоВыручке.Создать();
	ВыгрузкаОтчетаПоВыручке.ОбновитьСоставПакета(Пакет, НачалоПериода, КонецПериода);
	
	Каталог = КаталогВременныхФайлов();
	ПолныйПутьФайла = Каталог + ИмяФайла + ".xlsx"; 
	
	Пакет.Записать(ПолныйПутьФайла, ТипФайлаПакетаОтображаемыхДокументов.XLSX);
	
	Сообщение = СформироватьСообщение(ПериодВыгрузки, УчетнаяЗапись, ИмяФайла, ПолныйПутьФайла);
	
	Если НЕ Сообщение = Неопределено Тогда	
		
		Профиль = РаботаСПочтовымиСообщениямиСлужебный.ИнтернетПочтовыйПрофиль(УчетнаяЗапись);
		
		//кт Начало Апаев_О [15.10.2022]
		НаборЗаписей = РегистрыСведений.кт_КонтрольОтправкиОтчетовПоВыручке.СоздатьНаборЗаписей();	
		НаборЗаписей.Отбор.ДатаОтправки.Установить(НачалоДня(ПериодВыгрузки)); 
		
		НоваяЗапись 	   		 = НаборЗаписей.Добавить();
		НоваяЗапись.ДатаОтправки = НачалоДня(ПериодВыгрузки);
		
		Попытка
			ОтправитьПисьмо(Профиль, Сообщение);
			НоваяЗапись.Статус = Перечисления.кт_СтатусыОтправкиПисем.Отправлено;
		Исключение
			
			ТекстОшибки = ОписаниеОшибки();
			ТекстОшибки = Лев(Строка(ТекстОшибки), 1024);
			
			НоваяЗапись.Статус = Перечисления.кт_СтатусыОтправкиПисем.НеОтправлено;
			НоваяЗапись.Ошибка = ТекстОшибки;
			
		КонецПопытки;
		
		НаборЗаписей.Записать();
		//кт Начало Апаев_О [15.10.2022]
		
	КонецЕсли;
	
	ИмяПрошлогоФайла = "Отчет по выручке " + Строка(Формат(ДобавитьМесяц(ПериодВыгрузки, -1), "ДФ=MMMM")) + " " + СтрЗаменить(Год(ПериодВыгрузки), " ", "");
	ИмяПрошлогоФайла = Каталог + ИмяПрошлогоФайла + ".xlsx";
	
	ПрошлыйФайл = Новый Файл(ИмяПрошлогоФайла); 
	Если ПрошлыйФайл.Существует() = Истина Тогда
		УдалитьФайлы(Каталог + ИмяПрошлогоФайла + ".xlsx");
	КонецЕсли;
	
	//кт Начало Апаев_О [26.09.2022]
	Если КонецДня(ПериодВыгрузки) = КонецДня(КонецМесяца(ПериодВыгрузки)) Тогда
		ОбновитьДанныеЗначенийПоказателейВыручки(ПериодВыгрузки);
	КонецЕсли;
	//кт Начало Апаев_О [26.09.2022]
	
КонецПроцедуры

//кт Начало Апаев_О [26.09.2022]
Процедура ОбновитьДанныеЗначенийПоказателейВыручки(ПериодВыгрузки) Экспорт
	
	ЗначениеПоказателя = ПолучитьЗначениеПоказателя(ПериодВыгрузки);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", ПериодВыгрузки);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗначенияПоказателейВыручки.Ссылка КАК Показатель
	|ИЗ
	|	Справочник.кт_ЗначенияПоказателейВыручки КАК ЗначенияПоказателейВыручки
	|ГДЕ
	|	ГОД(ЗначенияПоказателейВыручки.Год) = ГОД(&Период)
	|	И ЗначенияПоказателейВыручки.ПлановыеПоказатели = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗначенияПоказателейВыручки.Ссылка";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Показатель = Выборка.Показатель.ПолучитьОбъект(); 			
			
			Для Каждого Строка Из Показатель.ЗначениеПоказателей Цикл
				
				Если НачалоМесяца(Строка.Период) = НачалоМесяца(ПериодВыгрузки) Тогда
					Строка.Значение = ЗначениеПоказателя;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Показатель.Комментарий = "Обновлено автоматически " + Формат(ПериодВыгрузки, "ДФ=dd.MM.yyyy");
			Показатель.Записать();
			
		КонецЕсли;
		
	Иначе
		
		Если Месяц(ПериодВыгрузки) = 1 Тогда
			
			Показатель = Справочники.кт_ЗначенияПоказателейВыручки.СоздатьЭлемент();
			
			Показатель.Год 				  = НачалоГода(ПериодВыгрузки);
			Показатель.ПлановыеПоказатели = Ложь;
			Показатель.Наименование		  = "Показатели " + Формат(ПериодВыгрузки, "ДФ=yyyy");
			
			Месяца = ПолучитьСоответствиеМесяцев();
			
			Для Счетчик = 1 По 12 Цикл		
				
				НоваяСтрока = Показатель.ЗначениеПоказателей.Добавить();
				НоваяСтрока.Месяц = Месяца.Получить(Счетчик);
				
				Если Счетчик = 1 Тогда
					НоваяСтрока.Значение = ЗначениеПоказателя;	
				КонецЕсли;
				
			КонецЦикла;
			
			Показатель.Комментарий = "Обновлено автоматически " + Формат(ПериодВыгрузки, "ДФ=dd.MM.yyyy");
			Показатель.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСоответствиеМесяцев() Экспорт 
	
	Месяца = Новый Соответствие;
	Месяца.Вставить(1,  "Январь");
	Месяца.Вставить(2,  "Февраль");
	Месяца.Вставить(3,  "Март");
	Месяца.Вставить(4,  "Апрель");
	Месяца.Вставить(5,  "Май");
	Месяца.Вставить(6,  "Июнь");
	Месяца.Вставить(7,  "Июль");
	Месяца.Вставить(8,  "Август");
	Месяца.Вставить(9,  "Сентябрь");
	Месяца.Вставить(10, "Октябрь");
	Месяца.Вставить(11, "Ноябрь");
	Месяца.Вставить(12, "Декабрь");
	
	Возврат Месяца;
	
КонецФункции

Функция ПолучитьЗначениеПоказателя(ПериодВыгрузки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",	НачалоДня(ПериодВыгрузки));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(ПериодВыгрузки));
	Запрос.УстановитьПараметр("ВидОплаты", 		Перечисления.кт_ВидыПоступленияОплаты.Магазин);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Календарь.Дата КАК Период
	|ПОМЕСТИТЬ ВТ_Периоды
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК Календарь
	|ГДЕ
	|	Календарь.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	Календарь.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ПриходныйКассовыйОрдер.Дата, ДЕНЬ) КАК Период,
	|	Кассы.Подразделение КАК Подразделение,
	|	ПриходныйКассовыйОрдер.Контрагент КАК Контрагент,
	|	ПриходныйКассовыйОрдер.кт_ВидПоступленияОплаты КАК ВидОплаты,
	|	СУММА(ЕСТЬNULL(ПриходныйКассовыйОрдер.СуммаДокумента, 0)) КАК Сумма,
	|	""Наличка"" КАК ТипСредств
	|ПОМЕСТИТЬ ВТ_ДанныеИсточников
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Кассы КАК Кассы
	|		ПО ПриходныйКассовыйОрдер.Касса = Кассы.Ссылка
	|ГДЕ
	|	ПриходныйКассовыйОрдер.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И ПриходныйКассовыйОрдер.Проведен = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(ПриходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	Кассы.Подразделение,
	|	ПриходныйКассовыйОрдер.Контрагент,
	|	ПриходныйКассовыйОрдер.кт_ВидПоступленияОплаты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ОперацияПоПлатежнойКарте.Дата, ДЕНЬ),
	|	ОперацияПоПлатежнойКарте.Подразделение,
	|	ОперацияПоПлатежнойКарте.Контрагент,
	|	ОперацияПоПлатежнойКарте.кт_ВидПоступленияОплаты,
	|	СУММА(ЕСТЬNULL(ОперацияПоПлатежнойКарте.СуммаДокумента, 0)),
	|	""Карта""
	|ИЗ
	|	Документ.ОперацияПоПлатежнойКарте КАК ОперацияПоПлатежнойКарте
	|ГДЕ
	|	ОперацияПоПлатежнойКарте.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И ОперацияПоПлатежнойКарте.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
	|	И ОперацияПоПлатежнойКарте.Проведен = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(ОперацияПоПлатежнойКарте.Дата, ДЕНЬ),
	|	ОперацияПоПлатежнойКарте.Подразделение,
	|	ОперацияПоПлатежнойКарте.Контрагент,
	|	ОперацияПоПлатежнойКарте.кт_ВидПоступленияОплаты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(БДС.Дата, ДЕНЬ),
	|	Платежи.ОснованиеПлатежа.Подразделение,
	|	Платежи.ОснованиеПлатежа.Контрагент,
	|	БДС.кт_ВидПоступленияОплаты,
	|	СУММА(ЕСТЬNULL(Платежи.СуммаВзаиморасчетов, 0)),
	|	""Перечисление""
	|ИЗ
	|	Документ.ПоступлениеБезналичныхДенежныхСредств КАК БДС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК Платежи
	|		ПО БДС.Ссылка = Платежи.Ссылка
	|ГДЕ
	|	БДС.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И БДС.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту))
	|	И БДС.Проведен = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(БДС.Дата, ДЕНЬ),
	|	Платежи.ОснованиеПлатежа.Подразделение,
	|	Платежи.ОснованиеПлатежа.Контрагент,
	|	БДС.кт_ВидПоступленияОплаты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.Подразделение,
	|	РасходныйКассовыйОрдер.Контрагент,
	|	РасходныйКассовыйОрдер.кт_ВидПоступленияОплаты,
	|	СУММА(ЕСТЬNULL(РасходныйКассовыйОрдер.СуммаДокумента, 0)),
	|	""Инкасация""
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И РасходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк)
	|	И РасходныйКассовыйОрдер.Проведен = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.Подразделение,
	|	РасходныйКассовыйОрдер.Контрагент,
	|	РасходныйКассовыйОрдер.кт_ВидПоступленияОплаты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.Подразделение,
	|	РасходныйКассовыйОрдер.Контрагент,
	|	РасходныйКассовыйОрдер.кт_ВидПоступленияОплаты,
	|	СУММА(ЕСТЬNULL(РасходныйКассовыйОрдер.СуммаДокумента, 0)),
	|	""ВозвратНаличные""
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И РасходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту)
	|	И РасходныйКассовыйОрдер.Проведен = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.Подразделение,
	|	РасходныйКассовыйОрдер.Контрагент,
	|	РасходныйКассовыйОрдер.кт_ВидПоступленияОплаты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ОперацияПоПлатежнойКарте.Дата, ДЕНЬ),
	|	ОперацияПоПлатежнойКарте.Подразделение,
	|	ОперацияПоПлатежнойКарте.Контрагент,
	|	ОперацияПоПлатежнойКарте.кт_ВидПоступленияОплаты,
	|	СУММА(ЕСТЬNULL(ОперацияПоПлатежнойКарте.СуммаДокумента, 0)),
	|	""ВозвратКарта""
	|ИЗ
	|	Документ.ОперацияПоПлатежнойКарте КАК ОперацияПоПлатежнойКарте
	|ГДЕ
	|	ОперацияПоПлатежнойКарте.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И ОперацияПоПлатежнойКарте.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту)
	|	И ОперацияПоПлатежнойКарте.Проведен = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(ОперацияПоПлатежнойКарте.Дата, ДЕНЬ),
	|	ОперацияПоПлатежнойКарте.Подразделение,
	|	ОперацияПоПлатежнойКарте.Контрагент,
	|	ОперацияПоПлатежнойКарте.кт_ВидПоступленияОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеИсточников.Период КАК Период,
	|	ВТ_ДанныеИсточников.Подразделение КАК Подразделение,
	|	ВТ_ДанныеИсточников.Контрагент КАК Контрагент,
	|	ВТ_ДанныеИсточников.ВидОплаты КАК ВидОплаты,
	|	СУММА(ВЫБОР
	|			КОГДА ВТ_ДанныеИсточников.ТипСредств = ""Наличка""
	|				ТОГДА ВТ_ДанныеИсточников.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Наличка,
	|	СУММА(ВЫБОР
	|			КОГДА ВТ_ДанныеИсточников.ТипСредств = ""Карта""
	|				ТОГДА ВТ_ДанныеИсточников.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Карта,
	|	СУММА(ВЫБОР
	|			КОГДА ВТ_ДанныеИсточников.ТипСредств = ""ВозвратНаличные""
	|				ТОГДА ВТ_ДанныеИсточников.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВозвратНаличка,
	|	СУММА(ВЫБОР
	|			КОГДА ВТ_ДанныеИсточников.ТипСредств = ""ВозвратКарта""
	|				ТОГДА ВТ_ДанныеИсточников.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВозвратКарта,
	|	СУММА(ВЫБОР
	|			КОГДА ВТ_ДанныеИсточников.ТипСредств = ""Инкасация""
	|				ТОГДА ВТ_ДанныеИсточников.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Инкасация,
	|	СУММА(ВЫБОР
	|			КОГДА ВТ_ДанныеИсточников.ТипСредств = ""Перечисление""
	|				ТОГДА ВТ_ДанныеИсточников.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Перечисление
	|ПОМЕСТИТЬ ВТ_ДанныеПоТипамСредств
	|ИЗ
	|	ВТ_ДанныеИсточников КАК ВТ_ДанныеИсточников
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ДанныеИсточников.Период,
	|	ВТ_ДанныеИсточников.Подразделение,
	|	ВТ_ДанныеИсточников.Контрагент,
	|	ВТ_ДанныеИсточников.ВидОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеПоТипамСредств.Период КАК Период,
	|	ВТ_ДанныеПоТипамСредств.Подразделение КАК Подразделение,
	|	ВТ_ДанныеПоТипамСредств.Контрагент КАК Контрагент,
	|	ВТ_ДанныеПоТипамСредств.ВидОплаты КАК ВидОплаты,
	|	СУММА(ВТ_ДанныеПоТипамСредств.Наличка) КАК Наличка,
	|	СУММА(ВТ_ДанныеПоТипамСредств.Карта) КАК Карта,
	|	СУММА(ВТ_ДанныеПоТипамСредств.ВозвратНаличка) КАК ВозвратНаличка,
	|	СУММА(ВТ_ДанныеПоТипамСредств.ВозвратКарта) КАК ВозвратКарта,
	|	СУММА(ВТ_ДанныеПоТипамСредств.Инкасация) КАК Инкасация,
	|	СУММА(ВТ_ДанныеПоТипамСредств.Перечисление) КАК Перечисление,
	|	СУММА(ЕСТЬNULL(ВТ_ДанныеПоТипамСредств.Наличка, 0) + ЕСТЬNULL(ВТ_ДанныеПоТипамСредств.Карта, 0) - ЕСТЬNULL(ВТ_ДанныеПоТипамСредств.ВозвратНаличка, 0) - ЕСТЬNULL(ВТ_ДанныеПоТипамСредств.ВозвратКарта, 0) + ЕСТЬNULL(ВТ_ДанныеПоТипамСредств.Перечисление, 0)) КАК ИтогоЗаДень
	|ПОМЕСТИТЬ ВТ_ОбщиеДанные
	|ИЗ
	|	ВТ_ДанныеПоТипамСредств КАК ВТ_ДанныеПоТипамСредств
	|ГДЕ
	|	НЕ ВТ_ДанныеПоТипамСредств.Подразделение ЕСТЬ NULL
	|	И ВТ_ДанныеПоТипамСредств.ВидОплаты В (ЗНАЧЕНИЕ(Перечисление.кт_ВидыПоступленияОплаты.Магазин), ЗНАЧЕНИЕ(Перечисление.кт_ВидыПоступленияОплаты.Дилер))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ДанныеПоТипамСредств.Период,
	|	ВТ_ДанныеПоТипамСредств.Подразделение,
	|	ВТ_ДанныеПоТипамСредств.Контрагент,
	|	ВТ_ДанныеПоТипамСредств.ВидОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Периоды.Период КАК Период,
	|	ВТ_ОбщиеДанные.Подразделение КАК Подразделение,
	|	ВТ_ОбщиеДанные.Контрагент КАК Контрагент,
	|	ВТ_ОбщиеДанные.ВидОплаты КАК ВидОплаты
	|ПОМЕСТИТЬ ВТ_Владельцы
	|ИЗ
	|	ВТ_Периоды КАК ВТ_Периоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОбщиеДанные КАК ВТ_ОбщиеДанные
	|		ПО (ИСТИНА)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ОбщиеДанные.Подразделение,
	|	ВТ_ОбщиеДанные.Контрагент,
	|	ВТ_ОбщиеДанные.ВидОплаты,
	|	ВТ_Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Владельцы.Период КАК Период,
	|	ВТ_Владельцы.Подразделение КАК Подразделение,
	|	ВТ_Владельцы.Контрагент КАК Контрагент,
	|	ВТ_Владельцы.ВидОплаты КАК ВидОплаты,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.ИтогоЗаДень, 0)) КАК ИтогоЗаДень
	|ПОМЕСТИТЬ ВТ_ИтогоПоДням
	|ИЗ
	|	ВТ_Владельцы КАК ВТ_Владельцы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОбщиеДанные КАК ВТ_ОбщиеДанные
	|		ПО ВТ_Владельцы.Период > ВТ_ОбщиеДанные.Период
	|			И ВТ_Владельцы.Подразделение = ВТ_ОбщиеДанные.Подразделение
	|			И ВТ_Владельцы.Контрагент = ВТ_ОбщиеДанные.Контрагент
	|			И ВТ_Владельцы.ВидОплаты = ВТ_ОбщиеДанные.ВидОплаты
	|ГДЕ
	|	НЕ ЕСТЬNULL(ВТ_ОбщиеДанные.ИтогоЗаДень, 0) = 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Владельцы.Период,
	|	ВТ_Владельцы.Подразделение,
	|	ВТ_Владельцы.Контрагент,
	|	ВТ_Владельцы.ВидОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Владельцы.Период КАК Период,
	|	ВТ_Владельцы.Подразделение КАК Подразделение,
	|	ВТ_Владельцы.Контрагент КАК Контрагент,
	|	ВТ_Владельцы.ВидОплаты КАК ВидОплаты,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.Наличка, 0)) КАК Наличка,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.Карта, 0)) КАК Карта,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.ВозвратНаличка, 0)) КАК ВозвратНаличка,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.ВозвратКарта, 0)) КАК ВозвратКарта,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.Инкасация, 0)) КАК Инкасация,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.Перечисление, 0)) КАК Перечисление,
	|	СУММА(ЕСТЬNULL(ВТ_ОбщиеДанные.ИтогоЗаДень, 0)) КАК ИтогоЗаДень
	|ПОМЕСТИТЬ ВТ_Финал
	|ИЗ
	|	ВТ_Владельцы КАК ВТ_Владельцы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОбщиеДанные КАК ВТ_ОбщиеДанные
	|		ПО ВТ_Владельцы.Период = ВТ_ОбщиеДанные.Период
	|			И ВТ_Владельцы.Подразделение = ВТ_ОбщиеДанные.Подразделение
	|			И ВТ_Владельцы.Контрагент = ВТ_ОбщиеДанные.Контрагент
	|			И ВТ_Владельцы.ВидОплаты = ВТ_ОбщиеДанные.ВидОплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Владельцы.Период,
	|	ВТ_Владельцы.Подразделение,
	|	ВТ_Владельцы.Контрагент,
	|	ВТ_Владельцы.ВидОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Финал.Период КАК Период,
	|	ВТ_Финал.Подразделение КАК Подразделение,
	|	ВТ_Финал.Контрагент КАК Контрагент,
	|	ВТ_Финал.ВидОплаты КАК ВидОплаты,
	|	СУММА(ВТ_Финал.Наличка) КАК Наличка,
	|	СУММА(ВТ_Финал.Карта) КАК Карта,
	|	СУММА(ВТ_Финал.ВозвратНаличка) КАК ВозвратНаличка,
	|	СУММА(ВТ_Финал.ВозвратКарта) КАК ВозвратКарта,
	|	СУММА(ВТ_Финал.Инкасация) КАК Инкасация,
	|	СУММА(ВТ_Финал.Перечисление) КАК Перечисление,
	|	СУММА(ВТ_Финал.ИтогоЗаДень) КАК ИтогоЗаДень,
	|	СУММА(ВТ_ИтогоПоДням.ИтогоЗаДень) КАК ИтогоЗаПериод
	|ПОМЕСТИТЬ ВТ_Итог
	|ИЗ
	|	ВТ_Финал КАК ВТ_Финал
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИтогоПоДням КАК ВТ_ИтогоПоДням
	|		ПО ВТ_Финал.Период = ВТ_ИтогоПоДням.Период
	|			И ВТ_Финал.Подразделение = ВТ_ИтогоПоДням.Подразделение
	|			И ВТ_Финал.Контрагент = ВТ_ИтогоПоДням.Контрагент
	|			И ВТ_Финал.ВидОплаты = ВТ_ИтогоПоДням.ВидОплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Финал.Период,
	|	ВТ_Финал.Подразделение,
	|	ВТ_Финал.Контрагент,
	|	ВТ_Финал.ВидОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(ЕСТЬNULL(ВТ_Итог.ИтогоЗаПериод, 0) + ЕСТЬNULL(ВТ_Итог.ИтогоЗаДень, 0) КАК ЧИСЛО(15, 0))) КАК ЗначениеПоказателя
	|ИЗ
	|	ВТ_Итог КАК ВТ_Итог
	|ГДЕ
	|	ВТ_Итог.Период МЕЖДУ &НачалоПериода И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И ВТ_Итог.ВидОплаты = &ВидОплаты";
	
	ЗначениеПоказателя = 0;
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			ЗначениеПоказателя = Выборка.ЗначениеПоказателя; 	
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеПоказателя;
	
КонецФункции
//кт Начало Апаев_О [26.09.2022]

Процедура ДобавитьПолучателейСообщения(Сообщение)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	кт_ПолучателиОтчетов.Почта КАК Почта
	|ИЗ
	|	РегистрСведений.кт_ПолучателиОтчетов КАК кт_ПолучателиОтчетов
	|ГДЕ
	|	кт_ПолучателиОтчетов.ОтчетПоВыручке = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	кт_ПолучателиОтчетов.Почта";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Сообщение.Получатели.Добавить(Выборка.Почта);
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьСообщение(ПериодВыгрузки, УчетнаяЗапись, ИмяФайла, ПолныйПутьФайла)
	
	Сообщение = Новый ИнтернетПочтовоеСообщение;
	
	ДобавитьПолучателейСообщения(Сообщение);
	
	Если Сообщение.Получатели.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Сообщение.Кодировка 		= "UTF-8";	
	Сообщение.Отправитель.Адрес = УчетнаяЗапись.АдресЭлектроннойПочты;
	Сообщение.Тема 				= "Отчет по выручке " + Формат(ПериодВыгрузки, "ДФ=dd.MM.yyyy");
	
	Попытка
		Сообщение.Вложения.Добавить(ПолныйПутьФайла, "Отчет");
		ТекстПисьма = ИмяФайла;
	Исключение
		ТекстПисьма = ТекстПисьма + "Не удалось добавить вложение! " + ОписаниеОшибки() + Символы.ПС;
	КонецПопытки;
	
	Сообщение.Тексты.Добавить(ТекстПисьма);
	
	Возврат Сообщение;
	
КонецФункции

Процедура ОтправитьПисьмо(Профиль, Сообщение)
	
	Почта = Новый ИнтернетПочта;
	Почта.Подключиться(Профиль);
	Почта.Послать(Сообщение);
	Почта.Отключиться();
	
КонецПроцедуры
//кт Окончание Апаев_О [28.08.2022]