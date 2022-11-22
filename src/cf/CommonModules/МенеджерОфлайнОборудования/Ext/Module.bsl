﻿
#Область ПрограммныйИнтерфейс

#Область ВидыЭлектроннойОплаты

// Пустая структура для заполнения параметра "ВидыЭлектроннойОплаты" выгружаемых на ККМ настроек,
// настройки заполняются в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеНастроек
//
Функция ПолучитьЗаписьВидЭлектроннойОплаты() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	// обязательное
	СтруктураЗаписи.Вставить("Код");
	
	// обязательное
	СтруктураЗаписи.Вставить("Наименование");
	
	// Число, обязательное
	// ТипЭлектроннойОплатыПлатежнаяКарта()
	// ТипЭлектроннойОплатыБанковскийКредит()
	// ТипЭлектроннойОплатыПодарочныйСертификат()
	// ТипЭлектроннойОплатыБонусы()
	СтруктураЗаписи.Вставить("ТипЭлектроннойОплаты");
	
	// УникальныйИдентификатор, необязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификатор");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ПолучитьЗаписьВидЭлектроннойОплаты()
//
Функция ТипЭлектроннойОплатыПлатежнаяКарта() Экспорт
	
	Возврат 1;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ПолучитьЗаписьВидЭлектроннойОплаты()
//
Функция ТипЭлектроннойОплатыБанковскийКредит() Экспорт
	
	Возврат 2;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ПолучитьЗаписьВидЭлектроннойОплаты()
//
Функция ТипЭлектроннойОплатыПодарочныйСертификат() Экспорт
	
	Возврат 3;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ПолучитьЗаписьВидЭлектроннойОплаты()
//
Функция ТипЭлектроннойОплатыБонусы() Экспорт
	
	Возврат 4;
	
КонецФункции

#КонецОбласти

#Область ПрайсЛист

// Пустая структура для заполнения массива Товары прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьТовара() Экспорт
	
	ЗаписьТовара = Новый Структура;
	
	// Строка, обязательность - по условию*
	// Идентификатор товарной позиции**
	ЗаписьТовара.Вставить("Код");
	
	// Массив структур, обязательность - по условию*
	// структура - ПолучитьЗаписьШтрихкода()
	ЗаписьТовара.Вставить("Штрихкоды", Новый Массив);
	
	// Число, по условию*
	ЗаписьТовара.Вставить("Цена");
	
	// Число, по условию*
	ЗаписьТовара.Вставить("Остаток");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьТовара.Вставить("УникальныйИдентификатор");
	
	// Строка, обязательное
	ЗаписьТовара.Вставить("Наименование");
	
	// Строка, обязательное
	// ПолучитьСтавкуНДС0()
	// ПолучитьСтавкуНДС10()
	// ПолучитьСтавкуНДС18()
	// ПолучитьСтавкуБезНДС()
	ЗаписьТовара.Вставить("СтавкаНДС");
	
	// Перечисление.ПризнакиПредметаРасчета, обязательное
	ЗаписьТовара.Вставить("ПризнакПредметаРасчета",
		Перечисления.ПризнакиПредметаРасчета.Товар);
	
	// Строка, необязательное
	// Идентификатор ЕИ, ключ связи с таблицей ЕдиницыИзмерения прайс-листа
	ЗаписьТовара.Вставить("КодЕдиницыИзмерения");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторЕдиницыИзмерения");
	
	// Строка, необязательное
	// Идентификатор группы, ключ связи с таблицей ГруппыТоваров прайс-листа
	ЗаписьТовара.Вставить("КодГруппы");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторГруппы");
	
	// Строка, необязательное
	ЗаписьТовара.Вставить("Артикул");
	
	// Строка, необязательное
	ЗаписьТовара.Вставить("Описание");
	
	// Булево
	ЗаписьТовара.Вставить("ЭтоВесовойТовар", Ложь);
	
	// Число, необязательное
	ЗаписьТовара.Вставить("НомерСекции");
	
	// Строка, необязательное
	// Идентификатор данных агента, ключ связи с таблицей ДанныеАгентов прайс-листа
	ЗаписьТовара.Вставить("КодДанныхАгента");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторДанныхАгента");
	
	// Строка, необязательное
	// Идентификатор данных поставщика, ключ связи с таблицей ДанныеПоставщиков прайс-листа
	ЗаписьТовара.Вставить("КодДанныхПоставщика");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторДанныхПоставщика");
	
	// Булево
	ЗаписьТовара.Вставить("ИмеетХарактеристики", Ложь);
	
	// Массив структур, обязательное если ИмеетХарактеристики = Истина
	// структура - ПолучитьЗаписьХарактеристики()
	ЗаписьТовара.Вставить("Характеристики", Новый Массив());
	
	// Булево, не может быть Истина, если ИмеетХарактеристики = Истина
	ЗаписьТовара.Вставить("ИмеетУпаковки", Ложь);
	
	// Массив структур, обязательное если ИмеетУпаковки = Истина
	// структура - ПолучитьЗаписьХарактеристики()
	ЗаписьТовара.Вставить("Упаковки", Новый Массив());
	
	
	// Алкоголь
	
	// Булево
	ЗаписьТовара.Вставить("ЭтоАлкоголь", Ложь);
	АлкогольныеРеквизиты = Новый Структура;
	
	// Булево
	АлкогольныеРеквизиты.Вставить("Маркируемый", Ложь);
	
	// Строка, обязательное
	АлкогольныеРеквизиты.Вставить("КодВидаАлкогольнойПродукции", "");
	
	// Число, обязательное, в литрах
	АлкогольныеРеквизиты.Вставить("ЕмкостьТары", 0);
	
	// Число, обязательное
	АлкогольныеРеквизиты.Вставить("Крепость", 0);
	
	// Строка, обязательное
	АлкогольныеРеквизиты.Вставить("ИННПроизводителя", "");
	
	// Строка, обязательное
	АлкогольныеРеквизиты.Вставить("КПППроизводителя", "");
	
	// Булево
	АлкогольныеРеквизиты.Вставить("ВРозлив", Ложь);
	
	ЗаписьТовара.Вставить("АлкогольныеРеквизиты", АлкогольныеРеквизиты);
	
	// * условие:
	// Если ИмеетХарактеристики = Ложь И ИмеетУпаковки = Ложь,
	// тогда поле "Код" - обязательное
	// Поля "Штрихкоды", "Цена", "Остаток" - заполняются в этой записи, но необязательные к заполнению	
	//
	// Если ИмеетХарактеристики = Ложь И ИмеетУпаковки = Истина, то поля "Код", "Штрихкоды", "Цена", "Остаток"
	// заполняются значениями для базовой единицы измерения.
	//
	// Если ИмеетХарактеристики = Истина И ИмеетУпаковки = Истина - ошибка, такой ситуации быть не должно.
	//
	// Если ИмеетХарактеристики = Истина И ИмеетУпаковки = Ложь
	// поля "Код", "Штрихкоды", "Цена", "Остаток" - не заполняются
	
	// ** товарная позиция - Номенклатура + Характеристика + Упаковка
	
	Возврат ЗаписьТовара;
	
КонецФункции

// Пустая структура для заполнения массива Характеристики прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьХарактеристики() Экспорт
	
	ЗаписьХарактеристики = Новый Структура;
	
	// Строка, обязательность - по условию*
	// Идентификатор товарной позиции**
	ЗаписьХарактеристики.Вставить("Код");
	
	// Массив структур, обязательность - по условию*
	// структура - ПолучитьЗаписьШтрихкода()
	ЗаписьХарактеристики.Вставить("Штрихкоды", Новый Массив);
	
	// Число, по условию*
	ЗаписьХарактеристики.Вставить("Цена");
	
	// Число, по условию*
	ЗаписьХарактеристики.Вставить("Остаток");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьХарактеристики.Вставить("УникальныйИдентификатор");
	
	// Строка, обязательное
	ЗаписьХарактеристики.Вставить("Наименование");
	
	// Булево
	ЗаписьХарактеристики.Вставить("ИмеетУпаковки", Ложь);
	
	// Массив структур, обязательное если ИмеетУпаковки = Истина
	ЗаписьХарактеристики.Вставить("Упаковки", Новый Массив());
	
	// Если ИмеетУпаковки = Ложь,
	// тогда поле "Код" - обязательное
	// Поля Штрихкоды, Цена, Остаток - заполняются в этой записи, но необязательные к заполнению
	//
	// Если ИмеетУпаковки = Истина, то поля "Код", "Штрихкоды", "Цена", "Остаток"
	// заполняются значениями для базовой единицы измерения.
	
	// ** товарная позиция - Номенклатура + Характеристика + Упаковка
	
	Возврат ЗаписьХарактеристики;
	
КонецФункции

// Пустая структура для заполнения массива Упаковки прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьУпаковки() Экспорт
	
	ЗаписьУпаковки = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор товарной позиции**
	ЗаписьУпаковки.Вставить("Код");
	
	// Строка, обязательное
	ЗаписьУпаковки.Вставить("Наименование");
	
	// Число, обязательное
	ЗаписьУпаковки.Вставить("Коэффициент", 0);
	
	// УникальныйИдентификатор, необязательное
	ЗаписьУпаковки.Вставить("УникальныйИдентификатор");
	
	// Массив структур, необязательное
	// структура - ПолучитьЗаписьШтрихкода()
	ЗаписьУпаковки.Вставить("Штрихкоды", Новый Массив);
	
	// Число, необязательное
	ЗаписьУпаковки.Вставить("Цена");
	
	// Число, необязательное
	ЗаписьУпаковки.Вставить("Остаток");
	
	// ** товарная позиция - Номенклатура + Характеристика + Упаковка
	
	Возврат ЗаписьУпаковки;
	
КонецФункции

// Пустая структура для заполнения массива ГруппыТоваров прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьГруппыТоваров() Экспорт
	
	ЗаписьГруппы = Новый Структура;
	
	// Строка, обязательное
	ЗаписьГруппы.Вставить("Код");
	
	// Строка, обязательное
	ЗаписьГруппы.Вставить("Наименование");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьГруппы.Вставить("УникальныйИдентификатор");
	
	// Строка, необязательное
	ЗаписьГруппы.Вставить("КодГруппы");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьГруппы.Вставить("УникальныйИдентификаторГруппы");
	
	Возврат ЗаписьГруппы;
	
КонецФункции

// Пустая структура для заполнения массива ЕдиницыИзмерения прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьЕдиницыИзмерения() Экспорт
	
	ЗаписьЕИ = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор ЕИ, ключ связи с полем КодЕдиницыИзмерения товара
	ЗаписьЕИ.Вставить("Код");
	
	// Строка, обязательное
	ЗаписьЕИ.Вставить("Наименование");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьЕИ.Вставить("УникальныйИдентификатор");
	
	// Строка, необязательное
	ЗаписьЕИ.Вставить("КодОКЕИ");
	
	Возврат ЗаписьЕИ;
	
КонецФункции

// Пустая структура для заполнения массива ДанныеАгентов прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьДанныхАгента() Экспорт
	
	ЗаписьДанныхАгента = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор данных агента, ключ связи с полем КодДанныхАгента товара
	ЗаписьДанныхАгента.Вставить("Код");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьДанныхАгента.Вставить("УникальныйИдентификатор");
	
	// Перечисление.ПризнакиАгента, необязательное
	ЗаписьДанныхАгента.Вставить("ПризнакАгента", Перечисления.ПризнакиАгента.ПустаяСсылка());
	
	
	// Платежный агент
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ОперацияПлатежногоАгента");
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ТелефонПлатежногоАгента");
	
	
	// Оператор перевода
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ТелефонОператораПеревода");
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("НаименованиеОператораПеревода");
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("АдресОператораПеревода");
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ИННОператораПеревода");
	
	
	// Оператор по приему платежей
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ТелефонОператораПоПриемуПлатежей");
	
	Возврат ЗаписьДанныхАгента;
	
КонецФункции

// Пустая структура для заполнения массива ДанныеПоставщиков прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьДанныхПоставщика() Экспорт
	
	ЗаписьДанныхПоставщика = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор данных поставщика, ключ связи с полем КодДанныхПоставщика товара
	ЗаписьДанныхПоставщика.Вставить("Код");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьДанныхПоставщика.Вставить("УникальныйИдентификатор");
	
	// Строка, необязательное
	ЗаписьДанныхПоставщика.Вставить("ТелефонПоставщика");
	
	// Строка, необязательное
	ЗаписьДанныхПоставщика.Вставить("НаименованиеПоставщика");
	
	// Строка, необязательное
	ЗаписьДанныхПоставщика.Вставить("ИННПоставщика");
	
	Возврат ЗаписьДанныхПоставщика;
	
КонецФункции

// Пустая структура для заполнения массива Штрихкоды товара прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста
//
Функция ПолучитьЗаписьШтрихкода() Экспорт
	
	ЗаписьШтрихкода = Новый Структура;
	
	// Строка, обязательное
	ЗаписьШтрихкода.Вставить("Штрихкод");
	
	// Строка, необязательное
	// CODE128, CODE39, EAN128, EAN13, EAN8, ITF14, QR
	ЗаписьШтрихкода.Вставить("ТипШтрихкода");
	
	Возврат ЗаписьШтрихкода;
	
КонецФункции

// константы

// Возвращает значение ставки НДС 0
//
Функция ПолучитьСтавкуНДС0() Экспорт
	
	Возврат "0";
	
КонецФункции

// Возвращает значение ставки НДС 10
//
Функция ПолучитьСтавкуНДС10() Экспорт
	
	Возврат "10";
	
КонецФункции

// Возвращает значение ставки НДС 18
//
Функция ПолучитьСтавкуНДС18() Экспорт
	
	Возврат "18";
	
КонецФункции

// Возвращает значение ставки БЕЗ НДС
//
Функция ПолучитьСтавкуБезНДС() Экспорт
	
	Возврат "none";
	
КонецФункции

// Возвращает значение ставки НДС 12
//
Функция ПолучитьСтавкуНДС12() Экспорт
	
	Возврат "12";
	
КонецФункции

#КонецОбласти

#Область Заказы

// Пустая структура для заполнения списка заказов, выгружаемых на оборудование,
// заказы заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов
//
Функция ПолучитьЗаписьЗаказа() Экспорт
	
	ЗаписьЗаказа = Новый Структура;
	
	// Строка, обязательное
	ЗаписьЗаказа.Вставить("НомерЗаказа");
	
	// Дата, обязательное
	ЗаписьЗаказа.Вставить("ДатаЗаказа");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьЗаказа.Вставить("УникальныйИдентификатор");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("ГородДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("УлицаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерДомаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерКвартирыДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерПодъездаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерЭтажаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерТелефонаКлиента");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("EmailКлиента");
	
	// Дата, необязательное
	ЗаписьЗаказа.Вставить("ДатаДоставки");
	
	// Строка, необязательное
	// "НеСогласован", "Согласован", "Отменен"
	ЗаписьЗаказа.Вставить("СтатусЗаказа");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("Комментарий");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("ИмяКлиента");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("ФамилияКлиента");
	
	// Массив структур, необязательное
	// структура - ПолучитьЗаписьТовараЗаказа()
	ЗаписьЗаказа.Вставить("Товары", Новый Массив);
	
	// Массив структур, необязательное
	// структура - ПолучитьЗаписьОплатыЗаказа()
	ЗаписьЗаказа.Вставить("Оплаты", Новый Массив);
	
	Возврат ЗаписьЗаказа;
	
КонецФункции

// Пустая структура для заполнения массива Товары заказа выгружаемого на оборудование,
// заказы заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов
//
Функция ПолучитьЗаписьТовараЗаказа() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор товарной позиции
	СтруктураЗаписи.Вставить("Код");
	
	// Число, обязательное
	СтруктураЗаписи.Вставить("Количество");
	
	// Число, обязательное
	СтруктураЗаписи.Вставить("Цена");
	
	// Число, обязательное
	СтруктураЗаписи.Вставить("Сумма");
	
	// УникальныйИдентификатор, обязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификаторТовара");
	
	// УникальныйИдентификатор, необязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификаторХарактеристики");
	
	// УникальныйИдентификатор, необязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификаторУпаковки");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Пустая структура для заполнения массива Оплаты заказа выгружаемого на оборудование,
// заказы заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов
//
Функция ПолучитьЗаписьОплатыЗаказа() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	// Число
	СтруктураЗаписи.Вставить("СуммаНаличнойОплаты", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаЭлектроннойОплаты", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаПредоплатой", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаПостоплатой", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаВстречнымПредоставлением", 0);
	
	// Строка, необязательное
	// ключ связи с таблицей ВидыЭлектроннойОплаты структуры настроек
	// см. ПолучитьЗаписьВидЭлектроннойОплаты()
	СтруктураЗаписи.Вставить("КодВидаЭлектроннойОплаты");
	
	// УникальныйИдентификатор, необязательное
	// см. ПолучитьЗаписьВидЭлектроннойОплаты()
	СтруктураЗаписи.Вставить("УникальныйИдентификаторВидаЭлектроннойОплаты");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейсСлужебный

// Возвращает доступные версии форматов обмена.
//
Функция ДоступныеВерсииФорматовОбмена() Экспорт
	
	ВерсииФорматовОбмена = Новый СписокЗначений();
	ВерсииФорматовОбмена.Добавить(1005, "1.5");
	ВерсииФорматовОбмена.Добавить(1006, "1.6");
	ВерсииФорматовОбмена.Добавить(1007, "1.7");
	ВерсииФорматовОбмена.Добавить(2003, "2.3");
	
	Возврат ВерсииФорматовОбмена;
	
КонецФункции

Функция ПолучитьНастройкиККМ() Экспорт
	
	НастройкиККМ = Новый Структура;
	НастройкиККМ.Вставить("НаименованиеОрганизации", "");
	НастройкиККМ.Вставить("НаименованиеМагазина", "");
	НастройкиККМ.Вставить("СистемыНалогообложения", Новый Массив);
	НастройкиККМ.Вставить("ИНН", "");
	НастройкиККМ.Вставить("КПП", "");
	НастройкиККМ.Вставить("АдресТочкиПродажи", "");
	НастройкиККМ.Вставить("МестоТочкиПродажи", "");
	
	НастройкиККМ.Вставить("ВидыЭлектроннойОплаты", Новый Массив);
	
	НастройкиККМ.Вставить("ЭлектроннаяПочтаОтправителяЧека", "");
	
	Возврат НастройкиККМ;
	
КонецФункции

Функция ПолучитьПрайсЛистККМ() Экспорт
	
	ПрайсЛист = Новый Структура;
	
	ПрайсЛист.Вставить("Товары", 			Новый Массив);
	ПрайсЛист.Вставить("ЕдиницыИзмерения", 	Новый Массив);
	ПрайсЛист.Вставить("ГруппыТоваров", 	Новый Массив);
	ПрайсЛист.Вставить("ДанныеПоставщиков", Новый Массив);
	ПрайсЛист.Вставить("ДанныеАгентов", 	Новый Массив);
	
	Возврат ПрайсЛист;
	
КонецФункции

Функция ПолучитьЗаказыККМ() Экспорт
	
	ЗаказыККМ = Новый Массив;
	
	Возврат ЗаказыККМ;
	
КонецФункции

Функция ПолучитьЗагружаемыеДанныеИзККМ() Экспорт
	
	ЗагружаемыеДанные = Новый Структура;
	
	ЗагружаемыеДанные.Вставить("ОтчетыОПродажах", Новый Массив);
	ЗагружаемыеДанные.Вставить("ВскрытияАлкогольнойТары", Новый Массив);
	
	Возврат ЗагружаемыеДанные;
	
КонецФункции

Функция ПолучитьЗагружаемыеДанныеИзПрайсЧекера() Экспорт
	
	ЗагружаемыеДанные = Новый Структура;
	
	ЗагружаемыеДанные.Вставить("ОтчетыОПроверкахЦенников", Новый Массив);
	
	Возврат ЗагружаемыеДанные;
	
КонецФункции

Функция ПолучитьОтчетОПродажахККМ() Экспорт
	
	ОтчетОПродажахККМ = Новый Структура;
	
	ОтчетОПродажахККМ.Вставить("НомерСмены");
	ОтчетОПродажахККМ.Вставить("ДатаОткрытияСмены");
	ОтчетОПродажахККМ.Вставить("ДатаЗакрытияСмены");
	ОтчетОПродажахККМ.Вставить("Чеки", Новый Массив);
	ОтчетОПродажахККМ.Вставить("ДвиженияДС", Новый Массив);
	ОтчетОПродажахККМ.Вставить("УникальныйИдентификатор");
	
	Возврат ОтчетОПродажахККМ;
	
КонецФункции

Функция ПолучитьЧекККМ() Экспорт
	
	Чек = Новый Структура;
	
	Чек.Вставить("ДатаЧека");
	Чек.Вставить("НомерЧека");
	Чек.Вставить("УникальныйИдентификатор");
	Чек.Вставить("СистемаНалогообложения", ПредопределенноеЗначение("Перечисление.ТипыСистемНалогообложенияККТ.ПустаяСсылка"));
	Чек.Вставить("ТипСвязанногоДокументаККМ");
	Чек.Вставить("УникальныйИдентификаторСвязанногоДокументаККМ");
	Чек.Вставить("ТипРасчета", ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.ПустаяСсылка"));
	Чек.Вставить("Товары", Новый Массив);
	Чек.Вставить("Оплаты", Новый Массив);
	
	Возврат Чек;
	
КонецФункции

Функция ПолучитьТоварЧекаККМ() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Цена");
	СтруктураЗаписи.Вставить("Сумма");
	СтруктураЗаписи.Вставить("Количество");
	СтруктураЗаписи.Вставить("ШтрихкодАлкогольнойПродукции", Новый Массив);
	СтруктураЗаписи.Вставить("СтавкаНДС");
	СтруктураЗаписи.Вставить("ПризнакСпособаРасчета");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторНоменклатуры");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторХарактеристики");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторУпаковки");

	Возврат СтруктураЗаписи;
	
КонецФункции

Функция ПолучитьОплатуЧекаККМ() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("СуммаНаличнойОплаты", 0);
	СтруктураЗаписи.Вставить("СуммаЭлектроннойОплаты", 0);
	СтруктураЗаписи.Вставить("СуммаПредоплатой", 0);
	СтруктураЗаписи.Вставить("СуммаПостоплатой", 0);
	СтруктураЗаписи.Вставить("СуммаВстречнымПредоставлением", 0);
	СтруктураЗаписи.Вставить("КодВидаЭлектроннойОплаты");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторВидаЭлектроннойОплаты");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

Функция ПолучитьДвижениеДСККМ() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Дата");
	СтруктураЗаписи.Вставить("Номер");
	СтруктураЗаписи.Вставить("УникальныйИдентификатор");
	СтруктураЗаписи.Вставить("Сумма");
	СтруктураЗаписи.Вставить("ТипДвижения");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

Функция ПолучитьВскрытиеТарыККМ() Экспорт
	
	ВскрытиеТары = Новый Структура;
	
	ВскрытиеТары.Вставить("Дата");
	ВскрытиеТары.Вставить("Номер");
	ВскрытиеТары.Вставить("УникальныйИдентификатор");
	ВскрытиеТары.Вставить("Товары", Новый Массив);
	
	Возврат ВскрытиеТары;
	
КонецФункции

Функция ПолучитьТоварВскрытияТарыККМ() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Количество");
	СтруктураЗаписи.Вставить("ШтрихкодАлкогольнойПродукции", Новый Массив);
	СтруктураЗаписи.Вставить("УникальныйИдентификаторНоменклатуры");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторХарактеристики");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторУпаковки");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

Функция ПолучитьОтчетОЦенниках() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Дата");
	СтруктураЗаписи.Вставить("Номер");
	СтруктураЗаписи.Вставить("УникальныйИдентификатор");
	СтруктураЗаписи.Вставить("Товары", Новый Массив);
	
	Возврат СтруктураЗаписи;
	
КонецФункции

Функция ПолучитьТоварОтчетаОЦенниках() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Код");
	СтруктураЗаписи.Вставить("Штрихкод");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторНоменклатуры");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторХарактеристики");
	СтруктураЗаписи.Вставить("УникальныйИдентификаторУпаковки");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

Функция ПолучитьНаборВыгруженныхДанных() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	СтруктураЗаписи.Вставить("Настройки", Ложь);
	СтруктураЗаписи.Вставить("ПрайсЛист", Ложь);
	СтруктураЗаписи.Вставить("Заказы", Ложь);
	
	Возврат СтруктураЗаписи;
	
КонецФункции

#КонецОбласти

