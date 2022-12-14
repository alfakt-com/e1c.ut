
#Область ПрограммныйИнтерфейс

// В процедуре требуется реализовать заполнение данных по номенклатуре для переданного соответствия штрихкодов.
//
// Параметры:
//  Штрихкоды - Соответствие - штрихкоды, не являющиеся штрихкодами упаковок и акцизных марок:
//   * Ключ - Строка - штрихкод,
//   * Значение - Структура - заполняемая структура, см. АкцизныеМаркиКлиентСервер.РезультатОбработкиШтрихкода().
//  КэшированныеЗначения - Структура - кэш формы документа.
//
Процедура ЗаполнитьИнформациюПоШтрихкодам(Штрихкоды, КэшированныеЗначения) Экспорт
	
	//++ НЕ ЕГАИС
	СписокШтрихкодов = Новый Массив;
	Для Каждого КлючЗначение Из Штрихкоды Цикл
		СписокШтрихкодов.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	КонецЕсли;
	
	РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьДанныеПоШтрихкодам(КэшированныеЗначения, СписокШтрихкодов);
	
	Для Каждого КлючЗначение Из КэшированныеЗначения.Штрихкоды Цикл
		Если Штрихкоды[КлючЗначение.Ключ] <> Неопределено Тогда
			Штрихкоды[КлючЗначение.Ключ].Номенклатура = КлючЗначение.Значение.Номенклатура;
			Штрихкоды[КлючЗначение.Ключ].Характеристика = КлючЗначение.Значение.Характеристика;
		КонецЕсли;
	КонецЦикла;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Возвращает Истина, если акцизная марка никогда раньше не продавалась. Ложь - в противном случае.
//
// Параметры:
//  Операция - Строка - текущая операция, для которой требуется осуществить контроль. Возможные значения:
//   "Продажа" - проверка пройдена, если продажи за минусом возвратов <= 0,
//   "Возврат" - проверка пройдена, если продажи за минусом возвратов >= 0,
//   "АктПостановкиНаБаланс" - проверка пройдена, если не было продаж, возвратов, актов постановок на баланс,
//   "АктСписания" - проверка пройдена, если продажи за минусом возвратов <= 0 и поставлено на баланс - списано >= 0.
//
//  КодАкцизнойМарки - Строка - код акцизной марки,
//  ТекстОшибки - Строка, ФорматированнаяСтрока - текст сообщения пользователю, если акцизная марка не уникальна. Выходной параметр.
//
Процедура ПроверитьУникальностьАкцизнойМарки(Операция, КодАкцизнойМарки, ТекстОшибки) Экспорт
	
	//++ НЕ ЕГАИС
	Если Не ЗначениеЗаполнено(Операция) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Операция = "Продажа" ИЛИ Операция = "Возврат" Тогда
		Запрос = ЗапросПроверкиУникальностиПродажаВозврат(КодАкцизнойМарки, Операция);
	ИначеЕсли Операция = "АктПостановкиНаБаланс" Тогда
		Запрос = ЗапросПроверкиУникальностиАктПостановкиНаБаланс(КодАкцизнойМарки);
	ИначеЕсли Операция = "АктСписания" Тогда
		Запрос = ЗапросПроверкиУникальностиАктСписания(КодАкцизнойМарки);
	КонецЕсли;
	
	ВыборкаОбщийИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщийИтог.Следующий();
	
	ТекстОшибки = "";
	Если ТипЗнч(ВыборкаОбщийИтог.Количество) = Тип("Число") И ВыборкаОбщийИтог.Количество > 0 Тогда
		
		Выборка = ВыборкаОбщийИтог.Выбрать();
		Выборка.Следующий();
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru='Считанная акцизная марка была реализована ранее в документе:'"));
		МассивСтрок.Добавить(Символы.ПС);
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			ОбщегоНазначенияУТ.ПолучитьПредставлениеДокумента(Выборка.Ссылка, Выборка.Номер, Выборка.Дата),,,,
			ПолучитьНавигационнуюСсылку(Выборка.Ссылка)));
		
		ТекстОшибки = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

Функция ДанныеДляЗаполненияСлужебныхРеквизитов(Товары) Экспорт
	
	//++ НЕ ЕГАИС
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.НомерСтроки,
	|	Т.ИдентификаторСтроки,
	|	Т.Номенклатура,
	|	Т.АлкогольнаяПродукция,
	|	Т.Справка2,
	|	Т.Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки          КАК НомерСтроки,
	|	Товары.ИдентификаторСтроки  КАК ИдентификаторСтроки,
	|	Товары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	Товары.Справка2             КАК Справка2,
	|	Товары.Количество           КАК Количество,
	|	0                           КАК КоличествоАкцизныхМарок,
	|	ВЫБОР
	|		КОГДА Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			И Товары.АлкогольнаяПродукция = ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
	|			ТОГДА ВЫБОР
	|				КОГДА Товары.Номенклатура.АлкогольнаяПродукцияВоВскрытойТаре
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ
	|					ЕСТЬNULL(Товары.Номенклатура.ВидАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
	|			КОНЕЦ
	|		ИНАЧЕ
	|			ЕСТЬNULL(Товары.АлкогольнаяПродукция.ВидПродукции.Маркируемый, ЛОЖЬ)
	|	КОНЕЦ КАК МаркируемаяАлкогольнаяПродукция
	|ИЗ
	|	Товары КАК Товары");
	
	Запрос.Параметры.Вставить("Товары", Товары);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Возврат Таблица;
	//-- НЕ ЕГАИС
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

//++ НЕ ЕГАИС
#Область СлужебныеПроцедурыИФункцииУТ

// Возвращает запрос, проверяющий уникальность акцизной марки для операций "Продажа" и "Возврат".
//
Функция ЗапросПроверкиУникальностиПродажаВозврат(КодАкцизнойМарки, Операция)
	
	НевыгруженныеСтатусыАктаСписания = Новый Массив;
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.Черновик);
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПередачи);
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПроведенияЕГАИС);
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.Отменен);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАкцизнойМарки",                 КодАкцизнойМарки);
	Запрос.УстановитьПараметр("Возврат",                          Операция = "Возврат");
	Запрос.УстановитьПараметр("НевыгруженныеСтатусыАктаСписания", НевыгруженныеСтатусыАктаСписания);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЧекККМТовары.Ссылка       КАК Ссылка,
	|	ЧекККМТовары.Ссылка.Дата  КАК Дата,
	|	ЧекККМТовары.Ссылка.Номер КАК Номер,
	|	ВЫБОР
	|		КОГДА &Возврат
	|			ТОГДА -ЧекККМТовары.Количество
	|		ИНАЧЕ ЧекККМТовары.Количество
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.Товары КАК ЧекККМТовары
	|		ПО ЧекККМАкцизныеМарки.Ссылка = ЧекККМТовары.Ссылка
	|			И ЧекККМАкцизныеМарки.ИдентификаторСтроки = ЧекККМТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекККМАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекККМАкцизныеМарки.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекККМВозвратТовары.Ссылка,
	|	ЧекККМВозвратТовары.Ссылка.Дата,
	|	ЧекККМВозвратТовары.Ссылка.Номер,
	|	ВЫБОР
	|		КОГДА &Возврат
	|			ТОГДА ЧекККМВозвратТовары.Количество
	|		ИНАЧЕ -ЧекККМВозвратТовары.Количество
	|	КОНЕЦ
	|ИЗ
	|	Документ.ЧекККМВозврат.АкцизныеМарки КАК ЧекККМВозвратАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат.Товары КАК ЧекККМВозвратТовары
	|		ПО ЧекККМВозвратАкцизныеМарки.Ссылка = ЧекККМВозвратТовары.Ссылка
	|			И ЧекККМВозвратАкцизныеМарки.ИдентификаторСтроки = ЧекККМВозвратТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекККМВозвратАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекККМВозвратАкцизныеМарки.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекЕГАИСТовары.Ссылка,
	|	ЧекЕГАИСТовары.Ссылка.Дата,
	|	ЧекЕГАИСТовары.Ссылка.Номер,
	|	ВЫБОР
	|		КОГДА &Возврат
	|			ТОГДА -ЧекЕГАИСТовары.Количество
	|		ИНАЧЕ ЧекЕГАИСТовары.Количество
	|	КОНЕЦ
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК ЧекЕГАИСАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИС.Товары КАК ЧекЕГАИСТовары
	|		ПО ЧекЕГАИСАкцизныеМарки.Ссылка = ЧекЕГАИСТовары.Ссылка
	|			И ЧекЕГАИСАкцизныеМарки.ИдентификаторСтроки = ЧекЕГАИСТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекЕГАИСТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекЕГАИСВозвратТовары.Ссылка,
	|	ЧекЕГАИСВозвратТовары.Ссылка.Дата,
	|	ЧекЕГАИСВозвратТовары.Ссылка.Номер,
	|	ВЫБОР
	|		КОГДА &Возврат
	|			ТОГДА ЧекЕГАИСВозвратТовары.Количество
	|		ИНАЧЕ -ЧекЕГАИСВозвратТовары.Количество
	|	КОНЕЦ
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.АкцизныеМарки КАК ЧекЕГАИСВозвратАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИСВозврат.Товары КАК ЧекЕГАИСВозвратТовары
	|		ПО ЧекЕГАИСВозвратАкцизныеМарки.Ссылка = ЧекЕГАИСВозвратТовары.Ссылка
	|			И ЧекЕГАИСВозвратАкцизныеМарки.ИдентификаторСтроки = ЧекЕГАИСВозвратТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекЕГАИСВозвратАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекЕГАИСВозвратТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктСписанияЕГАИСТовары.Ссылка,
	|	АктСписанияЕГАИСТовары.Ссылка.Дата,
	|	АктСписанияЕГАИСТовары.Ссылка.Номер,
	|	ВЫБОР
	|		КОГДА &Возврат
	|			ТОГДА АктСписанияЕГАИСТовары.Количество
	|		ИНАЧЕ -АктСписанияЕГАИСТовары.Количество
	|	КОНЕЦ
	|ИЗ
	|	Документ.АктСписанияЕГАИС.Товары КАК АктСписанияЕГАИСТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.АктСписанияЕГАИС.АкцизныеМарки КАК АктСписанияЕГАИСАкцизныеМарки
	|		ПО АктСписанияЕГАИСТовары.Ссылка = АктСписанияЕГАИСАкцизныеМарки.Ссылка
	|			И АктСписанияЕГАИСТовары.ИдентификаторСтроки = АктСписанияЕГАИСАкцизныеМарки.ИдентификаторСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО АктСписанияЕГАИСТовары.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	АктСписанияЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И АктСписанияЕГАИСТовары.Ссылка.Проведен
	|	И НЕ СтатусыДокументовЕГАИС.Статус В (&НевыгруженныеСтатусыАктаСписания)
	|	И АктСписанияЕГАИСТовары.Ссылка.ПричинаСписания = ЗНАЧЕНИЕ(Перечисление.ПричиныСписанийЕГАИС.Реализация)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	ОБЩИЕ";
	
	Возврат Запрос;
	
КонецФункции

// Возвращает запрос, проверяющий уникальность акцизной марки для операции "АктПостановкиНаБаланс".
//
Функция ЗапросПроверкиУникальностиАктПостановкиНаБаланс(КодАкцизнойМарки)
	
	НевыгруженныеСтатусы = Новый Массив;
	НевыгруженныеСтатусы.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Черновик);
	НевыгруженныеСтатусы.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачи);
	НевыгруженныеСтатусы.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПроведенияЕГАИС);
	НевыгруженныеСтатусы.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Отменен);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАкцизнойМарки", КодАкцизнойМарки);
	Запрос.УстановитьПараметр("НевыгруженныеСтатусы", НевыгруженныеСтатусы);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЧекККМТовары.Ссылка       КАК Ссылка,
	|	ЧекККМТовары.Ссылка.Дата  КАК Дата,
	|	ЧекККМТовары.Ссылка.Номер КАК Номер,
	|	ЧекККМТовары.Количество   КАК Количество
	|ИЗ
	|	Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.Товары КАК ЧекККМТовары
	|		ПО ЧекККМАкцизныеМарки.Ссылка = ЧекККМТовары.Ссылка
	|			И ЧекККМАкцизныеМарки.ИдентификаторСтроки = ЧекККМТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекККМАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекККМАкцизныеМарки.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекККМВозвратТовары.Ссылка,
	|	ЧекККМВозвратТовары.Ссылка.Дата,
	|	ЧекККМВозвратТовары.Ссылка.Номер,
	|	ЧекККМВозвратТовары.Количество
	|ИЗ
	|	Документ.ЧекККМВозврат.АкцизныеМарки КАК ЧекККМВозвратАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат.Товары КАК ЧекККМВозвратТовары
	|		ПО ЧекККМВозвратАкцизныеМарки.Ссылка = ЧекККМВозвратТовары.Ссылка
	|			И ЧекККМВозвратАкцизныеМарки.ИдентификаторСтроки = ЧекККМВозвратТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекККМВозвратАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекККМВозвратАкцизныеМарки.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекЕГАИСТовары.Ссылка,
	|	ЧекЕГАИСТовары.Ссылка.Дата,
	|	ЧекЕГАИСТовары.Ссылка.Номер,
	|	ЧекЕГАИСТовары.Количество
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК ЧекЕГАИСАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИС.Товары КАК ЧекЕГАИСТовары
	|		ПО ЧекЕГАИСАкцизныеМарки.Ссылка = ЧекЕГАИСТовары.Ссылка
	|			И ЧекЕГАИСАкцизныеМарки.ИдентификаторСтроки = ЧекЕГАИСТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекЕГАИСТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекЕГАИСВозвратТовары.Ссылка,
	|	ЧекЕГАИСВозвратТовары.Ссылка.Дата,
	|	ЧекЕГАИСВозвратТовары.Ссылка.Номер,
	|	ЧекЕГАИСВозвратТовары.Количество
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.АкцизныеМарки КАК ЧекЕГАИСВозвратАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИСВозврат.Товары КАК ЧекЕГАИСВозвратТовары
	|		ПО ЧекЕГАИСВозвратАкцизныеМарки.Ссылка = ЧекЕГАИСВозвратТовары.Ссылка
	|			И ЧекЕГАИСВозвратАкцизныеМарки.ИдентификаторСтроки = ЧекЕГАИСВозвратТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекЕГАИСВозвратАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекЕГАИСВозвратТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.Дата,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.Номер,
	|	АктПостановкиНаБалансЕГАИСТовары.Количество
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК АктПостановкиНаБалансЕГАИСТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.АктПостановкиНаБалансЕГАИС.АкцизныеМарки КАК АктПостановкиНаБалансЕГАИСАкцизныеМарки
	|		ПО АктПостановкиНаБалансЕГАИСТовары.Ссылка = АктПостановкиНаБалансЕГАИСАкцизныеМарки.Ссылка
	|			И АктПостановкиНаБалансЕГАИСТовары.ИдентификаторСтроки = АктПостановкиНаБалансЕГАИСАкцизныеМарки.ИдентификаторСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО АктПостановкиНаБалансЕГАИСТовары.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка.Проведен
	|	И НЕ СтатусыДокументовЕГАИС.Статус В (&НевыгруженныеСтатусы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	ОБЩИЕ";
	
	Возврат Запрос;
	
КонецФункции

// Возвращает запрос, проверяющий уникальность акцизной марки для операции "АктСписания".
//
Функция ЗапросПроверкиУникальностиАктСписания(КодАкцизнойМарки)
	
	НевыгруженныеСтатусыАктаСписания = Новый Массив;
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.Черновик);
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПередачи);
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПроведенияЕГАИС);
	НевыгруженныеСтатусыАктаСписания.Добавить(Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.Отменен);
	
	НевыгруженныеСтатусыАктаПостановкиНаБаланс = Новый Массив;
	НевыгруженныеСтатусыАктаПостановкиНаБаланс.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Черновик);
	НевыгруженныеСтатусыАктаПостановкиНаБаланс.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачи);
	НевыгруженныеСтатусыАктаПостановкиНаБаланс.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПроведенияЕГАИС);
	НевыгруженныеСтатусыАктаПостановкиНаБаланс.Добавить(Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Отменен);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАкцизнойМарки",                           КодАкцизнойМарки);
	Запрос.УстановитьПараметр("НевыгруженныеСтатусыАктаСписания",           НевыгруженныеСтатусыАктаСписания);
	Запрос.УстановитьПараметр("НевыгруженныеСтатусыАктаПостановкиНаБаланс", НевыгруженныеСтатусыАктаПостановкиНаБаланс);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЧекККМТовары.Ссылка       КАК Ссылка,
	|	ЧекККМТовары.Ссылка.Дата  КАК Дата,
	|	ЧекККМТовары.Ссылка.Номер КАК Номер,
	|	ЧекККМТовары.Количество   КАК Количество
	|ИЗ
	|	Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.Товары КАК ЧекККМТовары
	|		ПО ЧекККМАкцизныеМарки.Ссылка = ЧекККМТовары.Ссылка
	|			И ЧекККМАкцизныеМарки.ИдентификаторСтроки = ЧекККМТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекККМАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекККМАкцизныеМарки.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекККМВозвратТовары.Ссылка,
	|	ЧекККМВозвратТовары.Ссылка.Дата,
	|	ЧекККМВозвратТовары.Ссылка.Номер,
	|	-ЧекККМВозвратТовары.Количество
	|ИЗ
	|	Документ.ЧекККМВозврат.АкцизныеМарки КАК ЧекККМВозвратАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат.Товары КАК ЧекККМВозвратТовары
	|		ПО ЧекККМВозвратАкцизныеМарки.Ссылка = ЧекККМВозвратТовары.Ссылка
	|			И ЧекККМВозвратАкцизныеМарки.ИдентификаторСтроки = ЧекККМВозвратТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекККМВозвратАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекККМВозвратАкцизныеМарки.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекЕГАИСТовары.Ссылка,
	|	ЧекЕГАИСТовары.Ссылка.Дата,
	|	ЧекЕГАИСТовары.Ссылка.Номер,
	|	ЧекЕГАИСТовары.Количество
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК ЧекЕГАИСАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИС.Товары КАК ЧекЕГАИСТовары
	|		ПО ЧекЕГАИСАкцизныеМарки.Ссылка = ЧекЕГАИСТовары.Ссылка
	|			И ЧекЕГАИСАкцизныеМарки.ИдентификаторСтроки = ЧекЕГАИСТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекЕГАИСТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекЕГАИСВозвратТовары.Ссылка,
	|	ЧекЕГАИСВозвратТовары.Ссылка.Дата,
	|	ЧекЕГАИСВозвратТовары.Ссылка.Номер,
	|	-ЧекЕГАИСВозвратТовары.Количество
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.АкцизныеМарки КАК ЧекЕГАИСВозвратАкцизныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИСВозврат.Товары КАК ЧекЕГАИСВозвратТовары
	|		ПО ЧекЕГАИСВозвратАкцизныеМарки.Ссылка = ЧекЕГАИСВозвратТовары.Ссылка
	|			И ЧекЕГАИСВозвратАкцизныеМарки.ИдентификаторСтроки = ЧекЕГАИСВозвратТовары.ИдентификаторСтроки
	|ГДЕ
	|	ЧекЕГАИСВозвратАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И ЧекЕГАИСВозвратТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктСписанияЕГАИСТовары.Ссылка,
	|	АктСписанияЕГАИСТовары.Ссылка.Дата,
	|	АктСписанияЕГАИСТовары.Ссылка.Номер,
	|	АктСписанияЕГАИСТовары.Количество
	|ИЗ
	|	Документ.АктСписанияЕГАИС.Товары КАК АктСписанияЕГАИСТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.АктСписанияЕГАИС.АкцизныеМарки КАК АктСписанияЕГАИСАкцизныеМарки
	|		ПО АктСписанияЕГАИСТовары.Ссылка = АктСписанияЕГАИСАкцизныеМарки.Ссылка
	|			И АктСписанияЕГАИСТовары.ИдентификаторСтроки = АктСписанияЕГАИСАкцизныеМарки.ИдентификаторСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО АктСписанияЕГАИСТовары.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	АктСписанияЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И АктСписанияЕГАИСТовары.Ссылка.Проведен
	|	И НЕ СтатусыДокументовЕГАИС.Статус В (&НевыгруженныеСтатусыАктаСписания)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.Дата,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.Номер,
	|	-АктПостановкиНаБалансЕГАИСТовары.Количество
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК АктПостановкиНаБалансЕГАИСТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.АктПостановкиНаБалансЕГАИС.АкцизныеМарки КАК АктПостановкиНаБалансЕГАИСАкцизныеМарки
	|		ПО АктПостановкиНаБалансЕГАИСТовары.Ссылка = АктПостановкиНаБалансЕГАИСАкцизныеМарки.Ссылка
	|			И АктПостановкиНаБалансЕГАИСТовары.ИдентификаторСтроки = АктПостановкиНаБалансЕГАИСАкцизныеМарки.ИдентификаторСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО АктПостановкиНаБалансЕГАИСТовары.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИСАкцизныеМарки.КодАкцизнойМарки = &КодАкцизнойМарки
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка.Проведен
	|	И НЕ СтатусыДокументовЕГАИС.Статус В (&НевыгруженныеСтатусыАктаПостановкиНаБаланс)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	ОБЩИЕ";
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти
//-- НЕ ЕГАИС