﻿
#Область ШтрихкодированиеИСВызовСервера

// Получает данные для уточнения сведений у пользователя из кэша по адресу.
// 
// Параметры:
//  АдресВременногоХранилища - Строка - Адрес кэша обработки кодов маркировки.
// Возвращаемое значение:
//  Неопределено - Структура - 
Функция ШтрихкодированиеИСВызовСервера_ДанныеДляУточненияСведенийПользователя(АдресВременногоХранилища) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(АдресВременногоХранилища) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеКэша = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Возврат ДанныеКэша.ДанныеДляУточненияСведенийПользователя;
	
КонецФункции

// Очищает отложенные коды маркировки.
// 
// Параметры:
//  АдресХранилища - Строка - Адрес временного хранилища.
Процедура ШтрихкодированиеИСВызовСервера_ОчиститьОтложенныеКодыМаркировки(АдресХранилища) Экспорт

	Если Не ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		Возврат;
	КонецЕсли;
	
	КэшМаркируемойПродукции = ПолучитьИзВременногоХранилища(АдресХранилища);
	КэшМаркируемойПродукции.ОтложенныеКодыМаркировки.Очистить();
	
КонецПроцедуры

// Возвращает вид продукции по коду GTIN.
//
// Параметры:
//  GTIN - Строка - Код формата GTIN.
// Возвращаемое значение:
//  ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Функция ШтрихкодированиеИСВызовСервера_ВидПродукцииПоGTIN(GTIN) Экспорт

	ШтрихкодыEAN = Новый Массив;
	ШтрихкодEAN = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ШтрихкодEANИзGTIN(GTIN);
	ШтрихкодыEAN.Добавить(ШтрихкодEAN);

	ДанныеПоШтрихкодам = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ДанныеПоШтрихкодамEAN(ШтрихкодыEAN);
	Если ДанныеПоШтрихкодам.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ДанныеПоШтрихкодам[0].ВидПродукции;

КонецФункции

// Добавляет серию в элемент справочника "ШтрихкодыУпаковок".
//
// Параметры:
//  РезультатОбработки - Структура - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
//  Серия - ОпределяемыйТип.СерияНоменклатуры - Серия.
// Возвращаемое значение:
// (См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода).
Функция ШтрихкодированиеИСВызовСервера_ОбработатьДанныеШтрихкодаПослеВыбораСерии(РезультатОбработки, РезультатВыбора) Экспорт
	
	ДанныеШтрихкода = ПолучитьИзВременногоХранилища(РезультатОбработки.АдресДанныхШтрихкода);
	ДанныеШтрихкода.Серия = РезультатВыбора.ДанныеВыбора.Серия;
	ДанныеШтрихкода.ДополнительныеПараметры = РезультатВыбора;
	
	Если ЗначениеЗаполнено(ДанныеШтрихкода.ШтрихкодУпаковки) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ШтрихкодУпаковкиОбъект       = ДанныеШтрихкода.ШтрихкодУпаковки.ПолучитьОбъект();
		ШтрихкодУпаковкиОбъект.Серия = РезультатВыбора.ДанныеВыбора.Серия;
		ШтрихкодУпаковкиОбъект.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

// Выполняет обработку штрихкода и возвращает результат этой обработки.
//
// Параметры:
//  Штрихкод - Строка - Значение штрихкода.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  КэшированныеЗначения - Структура - Содержит поля кэшируемых значений.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор, по которому будут помещены данные по обработанным
//                                                      штрихкодам в хранилище.
// Возвращаемое значение:
//  Структура - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Функция ШтрихкодированиеИСВызовСервера_ОбработатьШтрихкод(Штрихкод, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор) Экспорт
	
	Штрихкод = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_НормализованныйШтрихкод(Штрихкод, ПараметрыСканирования);
	
	СписокШтрихкодов = Новый Массив;
	СписокШтрихкодов.Добавить(Штрихкод);
	
	Результат = ШтрихкодированиеИСВызовСервера_ОбработатьШтрихкоды(
		СписокШтрихкодов, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор);
	
	Если Результат.ШтрихкодыПродукцииДляСопоставления.Количество() > 0 Тогда
		
		РезультатОбработкиШтрихкода = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_РезультатОбработкиТребуетсяСопоставлениеНоменклатуры(
			Результат.ШтрихкодыПродукцииДляСопоставления, Штрихкод, ПараметрыСканирования);
		
		Возврат РезультатОбработкиШтрихкода;
		
	КонецЕсли;
	
	Возврат Результат.РезультатыОбработки[Штрихкод];
	
КонецФункции

//Выполняет обработку штрихкодов и возвращает результат этой обработки.
//
//Параметры:
//  СписокШтрихкодов - Массив из Строка - значения штрихкодов
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  КэшированныеЗначения - Структура - Содержит поля кэшируемых значений.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор, по которому будут помещены данные по обработанным
//                                                      штрихкодам в хранилище.
//Возвращаемое значение:
//  (См. ИнициализацияРезультатаОбработкиШтрихкодов).
Функция ШтрихкодированиеИСВызовСервера_ОбработатьШтрихкоды(СписокШтрихкодов, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор) Экспорт
	
	РезультатПроверок = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ВыполнитьПроверкиПередПолучениемДанныхПоШтрихкодам(
		СписокШтрихкодов, ПараметрыСканирования);
	
	Если РезультатПроверок.Количество() > 0 Тогда
		
		РезультатОбработкиШтрихкодов = ШтрихкодированиеИСВызовСервера_ИнициализацияРезультатаОбработкиШтрихкодов();
		РезультатОбработкиШтрихкодов.РезультатыОбработки = РезультатПроверок;
		
		Возврат РезультатОбработкиШтрихкодов;
		
	КонецЕсли;
	
	ДанныеПоШтрихкодам = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ДанныеПоШтрихкодам(СписокШтрихкодов, ПараметрыСканирования, КэшированныеЗначения);
	
	РезультатОбработкиШтрихкодов = ШтрихкодированиеИСВызовСервера_ОбработатьДанныеШтрихкодов(
		ДанныеПоШтрихкодам, УникальныйИдентификатор, ПараметрыСканирования);
	
	Возврат РезультатОбработкиШтрихкодов;
	
КонецФункции

// Инициализирует структуру результата обработки штрихкодов.
//
// Возвращаемое значение:
//  Структура - Описание:
//  * ШтрихкодыПродукцииДляСопоставления - Массив Из Строка - Штрихкоды, которым небходимо сопоставить номенклатуру.
//  * РезультатыОбработки - Соответствие:
//    ** Ключ     - Строка - значение штрихкода
//    ** Значение - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Функция ШтрихкодированиеИСВызовСервера_ИнициализацияРезультатаОбработкиШтрихкодов()
	
	Результат = Новый Структура;
	Результат.Вставить("РезультатыОбработки",                Новый Соответствие);
	Результат.Вставить("ШтрихкодыПродукцииДляСопоставления", Новый Массив);
	
	Возврат Результат;
	
КонецФункции

// Выполняет обработку данных по штрихкодам.
//
// Параметры:
//  ДанныеПоШтрихкодам - (См. ШтрихкодированиеИС.ИнициализацияДанныхПоШтрихкодам).
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор, по которому будут помещены данные по обработанным
//  штрихкодам в хранилище.
//  ПараметрыСканирования - Структура - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования и ШтрихкодированиеИС.ПараметрыСканирования).
// Возвращаемое значение:
//  Структура, Структура - Описание:
// * ШтрихкодыПродукцииДляСопоставления - Массив из Строка - Штрихкоды, которые необходимо сопоставить с номенклатурой.
// * РезультатыОбработки - (См. ШтрихкодированиеВызовСервера.ИнициализацияРезультатаОбработкиШтрихкодов).
Функция ШтрихкодированиеИСВызовСервера_ОбработатьДанныеШтрихкодов(ДанныеПоШтрихкодам, УникальныйИдентификатор, ПараметрыСканирования)
	
	ЭтоПакетнаяЗагрузка = ДанныеПоШтрихкодам.ВсеШтрихкоды.Количество() > 1;
	
	Результат = ШтрихкодированиеИСВызовСервера_ИнициализацияРезультатаОбработкиШтрихкодов();
	
	ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ВыполнитьПроверкуНаОшибкиДанныхПоШтрихкодам(ДанныеПоШтрихкодам, ПараметрыСканирования);
	
	Если ДанныеПоШтрихкодам.ЕстьОшибки Тогда
		
		Для Каждого Штрихкод Из ДанныеПоШтрихкодам.ВсеШтрихкоды Цикл
			
			РезультатОбработки = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ИнициализироватьРезультатОбработкиШтрихкода(ПараметрыСканирования);
			РезультатОбработки.ТекстОшибки = ДанныеПоШтрихкодам.ТекстОшибки;
			РезультатОбработки.ЕстьОшибки  = ДанныеПоШтрихкодам.ЕстьОшибки;
			РезультатОбработки.ОбщаяОшибка = Истина;
			
			Результат.РезультатыОбработки.Вставить(Штрихкод, РезультатОбработки);
			
		КонецЦикла;
		
		Возврат Результат;
	КонецЕсли;
	
	Результат.ШтрихкодыПродукцииДляСопоставления = ДанныеПоШтрихкодам.ШтрихкодыПродукцииДляСопоставления;
	
	Если ДанныеПоШтрихкодам.ВложенныеШтрихкоды <> Неопределено Тогда
		АдресДереваУпаковок = ПоместитьВоВременноеХранилище(ДанныеПоШтрихкодам.ВложенныеШтрихкоды.ДеревоУпаковок, УникальныйИдентификатор);
	КонецЕсли;
	
	ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_СформироватьДанныеДокументаОснования(ПараметрыСканирования);
	
	ДанныеДляКэширования = Новый Массив;
	ОшибкиПриОбработке   = Ложь;
	Для Каждого КлючЗначение Из ДанныеПоШтрихкодам.ОбработанныеШтрихкоды Цикл
		
		ДанныеШтрихкода = КлючЗначение.Значение;
		Штрихкод        = КлючЗначение.Ключ;
		
		Если ДанныеПоШтрихкодам.ОшибкаДопустимостиВидовПродукции Тогда
		
			РезультатОбработки = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ИнициализироватьРезультатОбработкиШтрихкода(ПараметрыСканирования, ДанныеШтрихкода);
			РезультатОбработки.ОшибкаДопустимостиВидовПродукции = Истина;
			Если ДанныеПоШтрихкодам.ЕстьОшибкиВДеревеУпаковок Тогда
				РезультатОбработки.ЕстьОшибкиВДеревеУпаковок = Истина;
				РезультатОбработки.АдресДереваУпаковок       = АдресДереваУпаковок;
			КонецЕсли;
		
		ИначеЕсли ИСМПТВыбытиеКодовМаркировкиКлиентСервер.ИнтеграцияИСКлиентСервер_ЭтоУпаковка(ДанныеШтрихкода.ТипУпаковки) Тогда
			
			РезультатОбработки = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ИнициализироватьРезультатОбработкиШтрихкода(ПараметрыСканирования);
			ЗаполнитьЗначенияСвойств(РезультатОбработки, ДанныеШтрихкода);
			
			РезультатОбработки.АдресДанныхШтрихкода = ПоместитьВоВременноеХранилище(ДанныеШтрихкода, УникальныйИдентификатор);
			РезультатОбработки.АдресДереваУпаковок  = АдресДереваУпаковок;
			РезультатОбработки.ЕстьОшибкиВДеревеУпаковок = ДанныеПоШтрихкодам.ЕстьОшибкиВДеревеУпаковок;
			
		ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП")
			И ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ПрисутствуетТабачнаяПродукция(ДанныеШтрихкода.ВидыПродукции) Тогда
			
			МодульШтрихкодированиеМОТП = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеМОТП");
			РезультатОбработки = МодульШтрихкодированиеМОТП.РезультатОбработкиКодаМаркировки(
				ДанныеШтрихкода, ПараметрыСканирования, УникальныйИдентификатор);
			
		КонецЕсли;
		
		Результат.РезультатыОбработки.Вставить(Штрихкод, РезультатОбработки);
		
		Если ДанныеПоШтрихкодам.ВложенныеШтрихкоды <> Неопределено Тогда
			ДеревоУпаковок = ДанныеПоШтрихкодам.ВложенныеШтрихкоды.ДеревоУпаковок;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.ТекстОшибки) Или  ДанныеПоШтрихкодам.ЕстьОшибкиВДеревеУпаковок Тогда
			ОшибкиПриОбработке = Истина;
		Иначе
			ДанныеКэша = Новый Структура("ДанныеШтрихкода, РезультатОбработки, ДеревоУпаковок", ДанныеШтрихкода, РезультатОбработки, ДеревоУпаковок);
			ДанныеДляКэширования.Добавить(ДанныеКэша);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ОшибкиПриОбработке Тогда
		
		Для Каждого ДанныеКэша Из ДанныеДляКэширования Цикл
			
			ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ЗакэшироватьОбработанныеШтрихкоды(
				ПараметрыСканирования, ДанныеКэша.ДанныеШтрихкода, ДанныеКэша.РезультатОбработки, ДанныеКэша.ДеревоУпаковок);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого КлючЗначение Из ДанныеПоШтрихкодам.НеобработанныеШтрихкоды Цикл
		
		ДанныеШтрихкода = КлючЗначение.Значение;
		
		РезультатОбработки = ИСМПТВыбытиеКодовМаркировкиСервер.ШтрихкодированиеИС_ИнициализироватьРезультатОбработкиШтрихкода(ПараметрыСканирования, ДанныеШтрихкода);
		РезультатОбработки.АдресДанныхШтрихкода = ПоместитьВоВременноеХранилище(ДанныеШтрихкода, УникальныйИдентификатор);
		
		Если ЭтоПакетнаяЗагрузка И Не ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура) Тогда
			РезультатОбработки.ТребуетсяСопоставлениеНоменклатуры = Истина;
		КонецЕсли;
		
		Результат.РезультатыОбработки.Вставить(КлючЗначение.Ключ, РезультатОбработки);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ИнтерфейсАвторизацииИСМПВызовСервера

// Запросить из сервиса ИС МП параметры авторизации.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ПараметрыЗапросаКлючаСессии) - Параметры запроса ключа сессии.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ПараметрыАвторизации - (См. ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыАвторизации). - Параметры авторизации
//                        - Неопределено - Если при получении параметров авторизации возникла ошибка.
// * ТекстОшибки          - Строка - Текст сообщения об ошибке.
Функция ИнтерфейсАвторизацииИСМПВызовСервера_ЗапроситьПараметрыАвторизации(ПараметрыЗапроса) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПараметрыАвторизации", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	РезультатЗапроса = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтеграцияИСМП_ПолучитьДанныеИзСервиса(
		ПараметрыЗапроса.АдресЗапросаПараметровАвторизации, Неопределено,
		ПараметрыЗапроса);
	
	РезультатОтправкиЗапроса = ИнтерфейсМОТПСлужебный.ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса);
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда
		
		Если РезультатОтправкиЗапроса.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ИнтерфейсМОТПСлужебный.ТекстJSONВОбъект(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
			
			Если ДанныеОтвета = Неопределено Тогда
				
				ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
					ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
					РезультатОтправкиЗапроса);
				
			Иначе
				
				ПараметрыАвторизации = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтерфейсАвторизацииИСМПСлужебный_ПараметрыАвторизации();
				ПараметрыАвторизации.Идентификатор = ДанныеОтвета.uuid;
				ПараметрыАвторизации.Данные        = ДанныеОтвета.data;
				
				ВозвращаемоеЗначение.ПараметрыАвторизации = ПараметрыАвторизации;
				
			КонецЕсли;
			
		Иначе
			
			ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
				ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
				РезультатОтправкиЗапроса);
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
			ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
			РезультатОтправкиЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполнить запрос ключа сессии в МОТП.
// 
// Параметры:
// 	ПараметрыЗапросаПоОрганизации - Структура - Структура со свойствами:
//	* ПараметрыЗапроса
//	* ПараметрыАвторизации
//	* СвойстваПодписи
//
// Возвращаемое значение:
// 	Структура - Описание:
// * Результат   - (См. ИнтерфейсМОТПСлужебный.ПараметрыКлючаСессии).
//               - Неопределено - При получении параметров ключа сессии произошла ошибка.
// * ТекстОшибки - Строка - Текст ошибки.
Функция ИнтерфейсАвторизацииИСМПВызовСервера_ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПараметрыКлючаСессии", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	ТелоЗапроса = Новый Структура;
	ТелоЗапроса.Вставить("uuid", ПараметрыЗапросаПоОрганизации.ПараметрыАвторизации.Идентификатор);
	ТелоЗапроса.Вставить("data", ИСМПТВыбытиеКодовМаркировкиКлиентСервер.ИнтеграцияИСКлиентСервер_ДвоичныеДанныеBase64(ПараметрыЗапросаПоОрганизации.СвойстваПодписи.Подпись));
	
	РезультатЗапроса = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтеграцияИСМП_ОтправитьДанныеВСервис(
		ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии, ТелоЗапроса, Неопределено, "POST",
		ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса);
	
	РезультатОтправкиЗапроса = ИнтерфейсМОТПСлужебный.ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса);
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда
		
		Если РезультатОтправкиЗапроса.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ИнтерфейсМОТПСлужебный.ТекстJSONВОбъект(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
			
			Если ДанныеОтвета = Неопределено Тогда
				
				ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
					ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
					РезультатОтправкиЗапроса);
				
			Иначе
				
				ДействуетДо = ТекущаяДатаСеанса() + 900; // 15 минут
				РезультатРазбораТокена = ИнтерфейсМОТПСлужебный.РасшифроватьТокенJWT(ДанныеОтвета.token);
				Если РезультатРазбораТокена <> Неопределено Тогда
					ДействуетДо = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтеграцияИС_ДатаИзСтрокиUNIX(РезультатРазбораТокена.exp, 1);
				КонецЕсли;
				
				ПараметрыКлючаСессии = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтерфейсАвторизацииИСМПСлужебный_ПараметрыКлючаСессии();
				ПараметрыКлючаСессии.КлючСессии  = ДанныеОтвета.token;
				ПараметрыКлючаСессии.ДействуетДо = ДействуетДо;
				
				ВозвращаемоеЗначение.ПараметрыКлючаСессии = ПараметрыКлючаСессии;
				
			КонецЕсли;
			
		Иначе
			
			ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
				РезультатОтправкиЗапроса);
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
			ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
			РезультатОтправкиЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Проверить актуальность ключа сессии.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	СрокДействия - Дата, Неопределено - Требуемый срок действия ключа сессии.
// Возвращаемое значение:
// 	Булево - Необходимость обновления ключа сессии.
Функция ИнтерфейсАвторизацииИСМПВызовСервера_ТребуетсяОбновлениеКлючаСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	КлючСессии = ИнтерфейсАвторизацииИСМПВызовСервера_ТекущийКлючСессии(ПараметрыЗапроса, СрокДействия);
	
	ТребуетсяОбновление = (КлючСессии = Неопределено);
	
	Если Не ТребуетсяОбновление Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючСессииОбновлен = ИСМПТВыбытиеКодовМаркировкиСервер.ИнтерфейсАвторизацииИСМПСлужебный_ОбновитьКлючСессииНаСервере(ПараметрыЗапроса);
	
	Возврат Не КлючСессииОбновлен;
	
КонецФункции

// Возвращает текущий ключ сессии для обмена с ИСМП.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	СрокДейтвия - Дата, Неопределено - Срок действия ключа сессии.
// Возвращаемое значение:
// 	Строка, Неопределено - Действующий ключ сессии для организации.
Функция ИнтерфейсАвторизацииИСМПВызовСервера_ТекущийКлючСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	Попытка
		ДанныеКлючаСессии = ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса].Получить();
	Исключение
		ДанныеКлючаСессии = Неопределено;
	КонецПопытки;
	
	// Ключ сессии еще не установлен
	Если ДанныеКлючаСессии = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если СрокДействия = Неопределено Тогда
		
		Таймаут      = 60;
		СрокДействия = ТекущаяДатаСеанса() + Таймаут;
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.Организация <> Неопределено Тогда
		
		ДанныеКлючаСессииДляОрганизации = ДанныеКлючаСессии.Получить(ПараметрыЗапроса.Организация);
		
		Если ДанныеКлючаСессииДляОрганизации = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		// Ключ сессии устарел
		Если ДанныеКлючаСессииДляОрганизации.ДействуетДо <= СрокДействия Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		
		Для Каждого КлючИЗначение Из ДанныеКлючаСессии Цикл
			
			Если КлючИЗначение.Значение.ДействуетДо > СрокДействия Тогда
				
				ДанныеКлючаСессииДляОрганизации = КлючИЗначение.Значение;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДанныеКлючаСессииДляОрганизации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КлючСессии = ДанныеКлючаСессииДляОрганизации.КлючСессии;
	
	Возврат КлючСессии;
	
КонецФункции

// Выполняет запрос ключа сессии для организации с учетом результата подписания.
// 
// Параметры:
// 	ПараметрыЗапросовПоОрганизациям - (См. ИнтерфейсАвторизацииИСМПСлужебныйКлиент.РезультатПодписания).
// Возвращаемое значение:
// 	Соответствие - Результат запроса ключей сессий по организациям.
Функция ИнтерфейсАвторизацииИСМПВызовСервера_ЗапроситьКлючиСессий(ПараметрыЗапросовПоОрганизациям) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие;
	
	Для Каждого ПараметрыЗапросаПоОрганизации Из ПараметрыЗапросовПоОрганизациям Цикл
		
		РезультатЗапросаКлючаСессии = ИнтерфейсАвторизацииИСМПВызовСервера_ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации);
		
		Если РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии <> Неопределено Тогда
			
			ИСМПТВыбытиеКодовМаркировкиСервер.ИнтерфейсАвторизацииИСМПСлужебный_УстановитьКлючСессии(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса,
				РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии);
			
			// Ключ сессии обновлен
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация, Истина);
			
		Иначе
			
			// Ключ сессии не обновлен
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация, РезультатЗапросаКлючаСессии.ТекстОшибки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции


#КонецОбласти

#Область ИнтеграцияИСВызовСервера

// Возвращает ИНН и КПП переданной организации и торгового объекта, структурой со свойствами:
//   * КПП - Строка - КПП организации,
//   * ИНН - Строка - ИНН организации.
//
// Параметры:
//   Организация - ОпределяемыйТип.ОрганизацияКонтрагентГосИС, ОпределяемыйТип.КонтрагентГосИС - ссылка на организацию, 
//     реквизиты которой нужно определить,
//   ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - ссылка на торговый объект для определения КПП.
// 
// Возвращаемое значение:
//   Структура - структура со свойствами ИНН, КПП
//
Функция ИнтеграцияИСВызовСервера_ИННКПППоОрганизацииКонтрагенту(ОрганизацияКонтрагент, ТорговыйОбъект = Неопределено) Экспорт
	
	ИННиКПП = Новый Структура("ИНН, КПП", "", "");
	ИСМПТВыбытиеКодовМаркировкиСервер.ИнтеграцияИСПереопределяемый_ЗаполнитьИННКПППоОрганизацииКонтрагенту(ИННиКПП, ОрганизацияКонтрагент, ТорговыйОбъект);
	Возврат ИННиКПП;
	
КонецФункции

#КонецОбласти

#Область ИнтеграцияИСВызовСервераУТ_

Функция ИнтеграцияИСВызовСервераУТ_ВидыПродукцииВТоварах(Знач Товары) Экспорт
	
	Возврат ИСМПТВыбытиеКодовМаркировкиСервер.ИнтеграцияИСУТ_ВидыПродукцииВТоварах(Товары);
	
КонецФункции

#КонецОбласти

#Область ПроверкаИПодборПродукцииИСМПУТВызовСервера

Функция ПроверкаИПодборПродукцииИСМПУТВызовСервера_АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(ПараметрыСканирования, Знач Объект, УникальныйИдентификатор, ВидМаркируемойПродукции) Экспорт
	
	Возврат ИСМПТВыбытиеКодовМаркировкиСервер.ПроверкаИПодборПродукцииИСМПУТ_АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(
		ПараметрыСканирования,
		Объект,
		УникальныйИдентификатор,
		ВидМаркируемойПродукции);
	
КонецФункции
	
#КонецОбласти	



