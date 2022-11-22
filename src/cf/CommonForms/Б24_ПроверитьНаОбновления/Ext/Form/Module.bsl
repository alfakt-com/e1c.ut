﻿
#Область СобытияФормы 

&НаСервере
Процедура ПолучитьСлужебныеДанныеДляСинхронизации()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	СлужебныеДанные = Новый Структура;
	СлужебныеДанные.Вставить("ВерсияПлатформы1С"			, СистемнаяИнформация.ВерсияПриложения);
	СлужебныеДанные.Вставить("НазваниеПрикладногоРешения"	, Метаданные.Синоним);
	СлужебныеДанные.Вставить("ИмяПрикладногоРешения"		, Метаданные.Имя);
	СлужебныеДанные.Вставить("ВерсияПрикладногоРешения"		, Метаданные.Версия);
	СлужебныеДанные.Вставить("ВерсияМодуляСинхронизации"	, Б24_ОбщегоНазначенияСервер.Версия());
	СлужебныеДанные.Вставить("МодульПервогоПоколения"		, Ложь);	
	СлужебныеДанные.Вставить("ХешСумма"						, "");	
	
	ДанныеОМодуле = Новый Структура;
	ДанныеОМодуле.Вставить("ИдПрикладногоРешения"		, "1C_Syn");
	ДанныеОМодуле.Вставить("МинимальныйРелиз" 			, "");
	ДанныеОМодуле.Вставить("МодульНеОпределен" 			, Ложь);
	ДанныеОМодуле.Вставить("СсылкаНаУстановленныйМодуль", "");
	ДанныеОМодуле.Вставить("МодульДоработан" 			, Ложь);
	
	ДанныеОМодуле.Вставить("ЭтоРасширение" 				, Ложь);
	ДанныеОМодуле.Вставить("ИдСтраны" 					, "KZ");
	ДанныеОМодуле.Вставить("ИдМодуля" 					, "UT_3");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьСлужебныеДанныеДляСинхронизации();	
	
	ИнформацияОМодулях = ПолучитьИнформациюОМодулях();
	
	Если ИнформацияОМодулях = Неопределено тогда
		Возврат;
	КонецЕсли;

	Для каждого ТекМодуль из ИнформацияОМодулях Цикл
		
		ВерсияМодуля = ТекМодуль.Получить("VersionModule");
		ВерсияМодуля = СокрЛП(СтрЗаменить(ВерсияМодуля, "BETA",""));
		
		СсылкаНаМодуль = "https://1c.1c-bitrix.ru/"+Строка(ТекМодуль.Получить("ModuleFile"));
		
		Если Лев(ВерсияМодуля,1)= "1" тогда      
			ВерсияМодуля = ВерсияМодуля + ".0.0";
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СлужебныеДанные.ВерсияМодуляСинхронизации, ВерсияМодуля) > 0 тогда
			Продолжить;	
		ИначеЕсли ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СлужебныеДанные.ВерсияМодуляСинхронизации, ВерсияМодуля) = 0 тогда
			
			Если Не ЗначениеЗаполнено(ДанныеОМодуле.СсылкаНаУстановленныйМодуль) тогда
				ДанныеОМодуле.СсылкаНаУстановленныйМодуль	= СсылкаНаМодуль;
			КонецЕсли;
			
			Если (Строка(СлужебныеДанные.ХешСумма) <> ТекМодуль.Получить("Hash")) И ЗначениеЗаполнено(Строка(СлужебныеДанные.ХешСумма)) И ЗначениеЗаполнено(ТекМодуль.Получить("Hash")) тогда
				//ДанныеОМодуле.МодульДоработан = Истина;	    - пока не используем
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока = УставливаемыеМодули.Добавить();
			
			НоваяСтрока.ВерсияМодуля			= ВерсияМодуля;
			НоваяСтрока.ДатаВыхода 				= ТекМодуль.Получить("ReleaseDate");
			НоваяСтрока.РелизКонфигурации 		= ТекМодуль.Получить("VersionAppSolution");
			НоваяСтрока.Ссылка 					= СсылкаНаМодуль;
			
			Если ТекМодуль.Получить("LOG") <> Ложь тогда
				НоваяСтрока.ИсторияИзменений 		= ТекМодуль.Получить("LOG").Получить("TEXT");
			КонецЕсли;
			
			Если ТекМодуль.Получить("CriticalMessage") <> Ложь тогда
				НоваяСтрока.КритическаяИнформация 	= ТекМодуль.Получить("CriticalMessage").Получить("TEXT");
			КонецЕсли;
			
			НоваяСтрока.МинимальныйРелиз 		= ТекМодуль.Получить("MinimalVersionAppSolution");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ (СлужебныеДанные.ВерсияМодуляСинхронизации = "" ИЛИ СлужебныеДанные.ВерсияМодуляСинхронизации = "0.0.0.0") тогда
		Элементы.ТекущаяВерсияИнфо.Видимость 	= Истина;
		Элементы.ТекущаяВерсия.Видимость 		= Истина;
		Элементы.ТекущаяВерсия.Заголовок 		= СлужебныеДанные.ВерсияМодуляСинхронизации;
	КонецЕсли;
	
	КоличествоУстанавливаемыхМодулей = УставливаемыеМодули.Количество(); 
	
	Если КоличествоУстанавливаемыхМодулей > 0 тогда
			
		Если ЗначениеЗаполнено(ДанныеОМодуле.МинимальныйРелиз) тогда
			Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ДанныеОМодуле.МинимальныйРелиз, СлужебныеДанные.ВерсияПрикладногоРешения)>0 тогда
					
				Элементы.ИнфоОЗапретеУстановки.Видимость = Истина;
				Элементы.ИнфоОЗапретеУстановки.Заголовок = "Не рекомендуется устанавливать модуль синхронизации, т.к. релиз конфигурации меньше требуемой.
				|Требуется не ниже:" + ДанныеОМодуле.МинимальныйРелиз;
					
				//Элементы.ГруппаУстановка.Доступность = Ложь;	
			КонецЕсли;
		Иначе
			Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(УставливаемыеМодули[0].МинимальныйРелиз, СлужебныеДанные.ВерсияПрикладногоРешения)>0 тогда
					
				Элементы.ИнфоОЗапретеУстановки.Видимость = Истина;
				Элементы.ИнфоОЗапретеУстановки.Заголовок = "Не рекомендуется устанавливать модуль синхронизации, т.к. релиз конфигурации меньше требуемой.
				|Требуется не ниже:" + УставливаемыеМодули[0].МинимальныйРелиз;
					
				//Элементы.ГруппаУстановка.Доступность = Ложь;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	Элементы.УставливаемыеМодули.Видимость = НЕ КоличествоУстанавливаемыхМодулей = 0;
		
		Если ЗначениеЗаполнено(ДанныеОМодуле.СсылкаНаУстановленныйМодуль) тогда 
			
			Если КоличествоУстанавливаемыхМодулей = 0 тогда
				Элементы.НоваяВерсияИнфо.Видимость 	= Истина;
				Элементы.НоваяВерсия.Видимость 		= Истина;
				Элементы.НоваяВерсия.Заголовок 		= СлужебныеДанные.ВерсияМодуляСинхронизации;
				Элементы.ИнфоВажноВерсии.Видимость 	= Ложь;
				
				Если ДанныеОМодуле.ЭтоРасширение тогда
					Элементы.УстановитьМодуль.Заголовок = "Переустановить модуль";
				Иначе
					Элементы.УстановитьМодуль.Заголовок = "Заново скачать модуль";
					Элементы.Декорация2.Видимость = Ложь;
				КонецЕсли;
				
			Иначе
				Элементы.НоваяВерсияИнфо.Видимость 	= Истина;
				Элементы.НоваяВерсия.Видимость 		= Истина;
				Элементы.НоваяВерсия.Заголовок 		= УставливаемыеМодули[0].ВерсияМодуля;
				
				Элементы.ИнфоВажноВерсии.Видимость 	= Истина;
				Элементы.ИнфоВажноВерсии.Заголовок 	= УставливаемыеМодули[0].КритическаяИнформация;
				
				Если ДанныеОМодуле.ЭтоРасширение тогда
					Элементы.УстановитьМодуль.Заголовок = "Установить новую версию модуля";
				Иначе
					Элементы.УстановитьМодуль.Заголовок = "Скачать новую версию модуля";
					Элементы.Декорация2.Видимость = Ложь;
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			Если КоличествоУстанавливаемыхМодулей > 0 тогда
				Элементы.НоваяВерсияИнфо.Видимость 	= Истина;
				Элементы.НоваяВерсия.Видимость 		= Истина;
				Элементы.НоваяВерсия.Заголовок 		= УставливаемыеМодули[0].ВерсияМодуля;
				
				Элементы.ИнфоВажноВерсии.Видимость 	= Истина;
				Элементы.ИнфоВажноВерсии.Заголовок 	= УставливаемыеМодули[0].КритическаяИнформация;
			Иначе
				Элементы.ГруппаУстановка.Видимость = Ложь;
				Элементы.ИнфоВажноВерсии.Заголовок = "Обновление не требуется";
			КонецЕсли;
		КонецЕсли;
		
	
КонецПроцедуры

#КонецОбласти


#Область Служебные

&НаСервере
Функция ПолучитьИнформациюОМодулях()
	
	Результат = Неопределено;
	
	НастройкиПодключения = Новый Структура;
	РазобратьАдресСайта("https://util.1c-bitrix.ru/onec/modules_info.php", НастройкиПодключения);	
	
	Соединение = УстановитьСоединениеССервером(НастройкиПодключения);
	
	ПустойПараметр = "&LastParam=last";    //1С может резать символы, поэтому добавляем параметр, который можно спокойно резать.
	
	HTTPЗапрос = Новый HTTPЗапрос;
	HTTPЗапрос.АдресРесурса = "onec/modules_info.php";
	
	ТелоHTTPЗапроса = "q=1&module="+ДанныеОМодуле.ИдПрикладногоРешения+"&country="+ДанныеОМодуле.ИдСтраны+"&app="+ДанныеОМодуле.ИдМодуля+ ПустойПараметр;	
	
	//module - IdModule (символьный код раздела 1 уровня),
	//country - IdCountry (символьный код раздела 2 уровня),
	//app - IdAppSolution (символьный код раздела 2 уровня).	
	
	
	HTTPЗапрос.Заголовки.Вставить("Content-Type"	,"application/x-www-form-urlencoded; charset=utf-8");
	HTTPЗапрос.Заголовки.Вставить("Content-Length"	, Формат(СтрДлина(ТелоHTTPЗапроса), "ЧГ=0"));
	
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоHTTPЗапроса);
	
	Попытка   
		
		Ответ 				= Соединение.ОтправитьДляОбработки(HTTPЗапрос);	
		ОтветСтрокой 		= Ответ.ПолучитьТелоКакСтроку();
		Раскодировка 		= РаскодироватьJSON(ОтветСтрокой);
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ОтветСтрокой);
		
		ИнформацияОМодулях =  ПрочитатьJSON(ЧтениеJSON, Истина);
		
		Результат = ИнформацияОМодулях.Получить("result").Получить("modules");
		
	Исключение
		Сообщить(ИнформацияОбОшибке().Описание);
	КонецПопытки;
	
	Возврат Результат; 
	
КонецФункции

&НаСервере
Функция РазобратьАдресСайта(Знач АдресСайта, НастройкиПодключения) 
	
	АдресСайта = СокрЛП(АдресСайта); 
	
	Сервер		 		 = ""; 
	Порт				 = 0;
	АдресСкрипта 		 = "";
	ЗащищенноеСоединение = Ложь;
	
	Если НЕ ПустаяСтрока(АдресСайта) Тогда
		
		АдресСайта = СтрЗаменить(АдресСайта, "\", "/");
		АдресСайта = СтрЗаменить(АдресСайта, " ", "");
		
		Если НРег(Лев(АдресСайта, 7)) = "http://" Тогда
			
			АдресСайта = Сред(АдресСайта, 8);
			
		ИначеЕсли НРег(Лев(АдресСайта, 8)) = "https://" Тогда
			
			АдресСайта = Сред(АдресСайта, 9);
			ЗащищенноеСоединение = Истина;
			
		КонецЕсли;
		
		ПозицияСлэша = Найти(АдресСайта, "/");
		
		Если ПозицияСлэша > 0 Тогда
			
			Сервер 		 = Лев(АдресСайта, ПозицияСлэша - 1);	
			АдресСкрипта = Прав(АдресСайта, СтрДлина(АдресСайта) - ПозицияСлэша);
			
		Иначе
			
			Сервер 		 = АдресСайта;
			АдресСкрипта = "";
			
		КонецЕсли;
		
		ПозицияДвоеточия = Найти(Сервер, ":");
		ПортСтрока = "0";
		
		Если ПозицияДвоеточия > 0 Тогда
			
			СерверСПортом = Сервер;
			Сервер		  = Лев(СерверСПортом, ПозицияДвоеточия - 1);
			ПортСтрока 	  = Прав(СерверСПортом, СтрДлина(СерверСПортом) - ПозицияДвоеточия);
			
		КонецЕсли;
		
		Попытка
			
			Порт = Число(ПортСтрока);
			
		Исключение
			
			#ЕСЛИ НЕ СЕРВЕР ТОГДА 	
				ПоказатьОповещениеПользователя(НСтр("ru = 'Не удалось получить номер порта ('") + ПортСтрока + ")!"
				+ Символы.ПС + НСтр("ru = 'Проверьте правильность ввода адреса сайта.'"));
			#ИНАЧЕ
				Сообщить(НСтр("ru = 'Не удалось получить номер порта ('") + ПортСтрока + ")!"
				+ Символы.ПС + НСтр("ru = 'Проверьте правильность ввода адреса сайта.'"));
			#КОНЕЦЕСЛИ
			
			Возврат Ложь;
			
		КонецПопытки;
		
		Если Порт = 0 Тогда
			
			Порт = ?(ЗащищенноеСоединение, 443, 80);
			
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиПодключения.Вставить("Сервер"	  				, Сервер); 
	НастройкиПодключения.Вставить("Порт"		   			, Порт);
	НастройкиПодключения.Вставить("АдресСкрипта"			, АдресСкрипта);
	НастройкиПодключения.Вставить("ЗащищенноеСоединение"	, ЗащищенноеСоединение);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция РаскодироватьJSON(URL)
	
	Результат = URL; 
	
	СписокСимволов = Новый СписокЗначений;
	СписокСимволов.Добавить("\u0430", "а");
	СписокСимволов.Добавить("\u0431", "б");
	СписокСимволов.Добавить("\u0432", "в");
	СписокСимволов.Добавить("\u0433", "г");
	СписокСимволов.Добавить("\u0434", "д");
	СписокСимволов.Добавить("\u0435", "е");
	СписокСимволов.Добавить("\u0451", "ё");
	СписокСимволов.Добавить("\u0436", "ж");
	СписокСимволов.Добавить("\u0437", "з");
	СписокСимволов.Добавить("\u0438", "и");
	СписокСимволов.Добавить("\u0439", "й");
	СписокСимволов.Добавить("\u043a", "к");
	СписокСимволов.Добавить("\u043b", "л");
	СписокСимволов.Добавить("\u043c", "м");
	СписокСимволов.Добавить("\u043d", "н");
	СписокСимволов.Добавить("\u043e", "о");
	СписокСимволов.Добавить("\u043f", "п");
	СписокСимволов.Добавить("\u0440", "р");
	СписокСимволов.Добавить("\u0441", "с");
	СписокСимволов.Добавить("\u0442", "т");
	СписокСимволов.Добавить("\u0443", "у");
	СписокСимволов.Добавить("\u0444", "ф");
	СписокСимволов.Добавить("\u0445", "х");
	СписокСимволов.Добавить("\u0446", "ц");
	СписокСимволов.Добавить("\u0447", "ч");
	СписокСимволов.Добавить("\u0448", "ш");
	СписокСимволов.Добавить("\u0448", "щ");
	СписокСимволов.Добавить("\u044a", "ъ");
	СписокСимволов.Добавить("\u044b", "ы");
	СписокСимволов.Добавить("\u044c", "ь");
	СписокСимволов.Добавить("\u044d", "э");
	СписокСимволов.Добавить("\u044e", "ю");
	СписокСимволов.Добавить("\u044f", "я");
	
	СписокСимволов.Добавить("\u0410", "А");
	СписокСимволов.Добавить("\u0411", "Б");
	СписокСимволов.Добавить("\u0412", "В");
	СписокСимволов.Добавить("\u0413", "Г");
	СписокСимволов.Добавить("\u0414", "Д");
	СписокСимволов.Добавить("\u0415", "Е");
	СписокСимволов.Добавить("\u0401", "Ё");
	СписокСимволов.Добавить("\u0416", "Ж");
	СписокСимволов.Добавить("\u0417", "З");
	СписокСимволов.Добавить("\u0418", "И");
	СписокСимволов.Добавить("\u0419", "Й");
	СписокСимволов.Добавить("\u041a", "К");
	СписокСимволов.Добавить("\u041b", "Л");
	СписокСимволов.Добавить("\u041c", "М");
	СписокСимволов.Добавить("\u041d", "Н");
	СписокСимволов.Добавить("\u041e", "О");
	СписокСимволов.Добавить("\u041f", "П");
	СписокСимволов.Добавить("\u0420", "Р");
	СписокСимволов.Добавить("\u0421", "С");
	СписокСимволов.Добавить("\u0422", "Т");
	СписокСимволов.Добавить("\u0423", "У");
	СписокСимволов.Добавить("\u0424", "Ф");
	СписокСимволов.Добавить("\u0425", "Х");
	СписокСимволов.Добавить("\u0426", "Ц");
	СписокСимволов.Добавить("\u0427", "Ч");
	СписокСимволов.Добавить("\u0428", "Ш");
	СписокСимволов.Добавить("\u0428", "Щ");
	СписокСимволов.Добавить("\u042a", "Ъ");
	СписокСимволов.Добавить("\u042b", "Ы");
	СписокСимволов.Добавить("\u042c", "Ь");
	СписокСимволов.Добавить("\u042d", "Э");
	СписокСимволов.Добавить("\u042e", "Ю");
	СписокСимволов.Добавить("\u042f", "Я");
	
	
	СписокСимволов.Добавить("\u0022", "'");
	
	СписокСимволов.Добавить("\u003E", ">");
	СписокСимволов.Добавить("\u003е", ">");
	
	СписокСимволов.Добавить("\u003C", "<");
	СписокСимволов.Добавить("\u003c", "<");
	
	Для Каждого текЭлемент из СписокСимволов Цикл
		
		Результат = СтрЗаменить(Результат,текЭлемент.Значение, текЭлемент.Представление);	
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗакодироватьСтрокуСервер(ЗначениеСтроки) Экспорт
	
	Возврат КодироватьСтроку(XMLСтрока(ЗначениеСтроки), СпособКодированияСтроки.КодировкаURL, "UTF8");
	
КонецФункции

&НаСервере
Функция УстановитьСоединениеССервером(ОбщиеНастройки)    
	
	Соединение = Неопределено;
	
	Попытка
		
		ssl = Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);   
		
		ИнтернетПрокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("HTTP");
		
		Соединение = Новый HTTPСоединение(ОбщиеНастройки.Сервер, ОбщиеНастройки.Порт,,, ИнтернетПрокси, ,ssl);
		
	Исключение
		
		лТекстОшибки = НСтр("ru = 'Не удалось установить соединение с серовером'") + ОбщиеНастройки.Сервер + ":" + Строка(ОбщиеНастройки.Порт) 
		+ НСтр("ru = '.Проверьте правильность токена.'");
		Сообщить(лТекстОшибки);
		
		Соединение = Неопределено;
		
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

#КонецОбласти


#Область КомандыФормы

&НаКлиенте
Процедура УстановитьМодуль(Команда)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Диалог.Заголовок = НСтр("ru = 'Укажите где будет сохранен модуль синхронизации'");
	Диалог.ПолноеИмяФайла   = "Модуль синхронизации с Битрикс24";
	Диалог.Фильтр = "Архив (*.zip)|*.zip";
	
	Диалог.Показать(Новый ОписаниеОповещения("СохранитьФайлЗавершение",ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗавершение(МассивФайлов,ДополнительныеПараметры) Экспорт
    Если МассивФайлов<>Неопределено Тогда
        ИмяФайла=МассивФайлов.Получить(0);
		СкачатьУстановитьМодуль(ИмяФайла);
    КонецЕсли;
КонецПроцедуры
		  
&НаСервере
Процедура СкачатьУстановитьМодуль(ИмяФайла = Неопределено)
	
	УспешнаяЗагрузка = Истина;
	
	Если УставливаемыеМодули.Количество() = 0 тогда
		СсылкаНаМодуль = ДанныеОМодуле.СсылкаНаУстановленныйМодуль; 
		Версия = СлужебныеДанные.ВерсияМодуляСинхронизации;
	Иначе
		СсылкаНаМодуль = УставливаемыеМодули[0].Ссылка; 
		Версия = УставливаемыеМодули[0].ВерсияМодуля;
	КонецЕсли;
	
	ИмяФайла = ?(ИмяФайла = Неопределено, ПолучитьИмяВременногоФайла("cfe"), ИмяФайла);
	
	Результат = Неопределено;
	
	НастройкиПодключения = Новый Структура;
	РазобратьАдресСайта(СсылкаНаМодуль, НастройкиПодключения);	
	
	Соединение = УстановитьСоединениеССервером(НастройкиПодключения);
	
	HTTPЗапрос = Новый HTTPЗапрос(НастройкиПодключения.АдресСкрипта);
	
	Попытка   
		Соединение.Получить(HTTPЗапрос, ИмяФайла);
	Исключение
		УспешнаяЗагрузка = Ложь;
		Сообщить("Не удалось загрузить модуль по адресу: " + СсылкаНаМодуль);
	КонецПопытки;

	Если УспешнаяЗагрузка тогда
		ОтправкаАналитики(Версия);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправкаАналитики(Версия)
	
	Результат = Неопределено;
	
	НастройкиПодключения = Новый Структура;
	РазобратьАдресСайта("https://util.1c-bitrix.ru/onec/ga_send.php", НастройкиПодключения);	
	
	Соединение = УстановитьСоединениеССервером(НастройкиПодключения);
	
	ПустойПараметр = "&LastParam=last";    //1С может резать символы, поэтому добавляем параметр, который можно спокойно резать.
	
	HTTPЗапрос = Новый HTTPЗапрос;
	HTTPЗапрос.АдресРесурса = НастройкиПодключения.АдресСкрипта;
	
	ТелоHTTPЗапроса = "q=1&module="+ЗакодироватьСтрокуСервер(ДанныеОМодуле.ИдСтраны+"_1С:Синхронизация Битрикс24")
	+"&app="+ЗакодироватьСтрокуСервер(СлужебныеДанные.НазваниеПрикладногоРешения)+"&version="+ЗакодироватьСтрокуСервер(Версия)+ ПустойПараметр;	
	
	HTTPЗапрос.Заголовки.Вставить("Content-Type"	,"application/x-www-form-urlencoded; charset=utf-8");
	HTTPЗапрос.Заголовки.Вставить("Content-Length"	, Формат(СтрДлина(ТелоHTTPЗапроса), "ЧГ=0"));
	
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоHTTPЗапроса);
	
	Попытка   
		
		Ответ 			= Соединение.ОтправитьДляОбработки(HTTPЗапрос);	
		ОтветСтрокой 	= Ответ.ПолучитьТелоКакСтроку();
		
	Исключение
		Сообщить(ИнформацияОбОшибке().Описание);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти



