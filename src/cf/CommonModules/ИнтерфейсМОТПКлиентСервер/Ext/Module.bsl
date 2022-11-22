﻿#Область ПрограммныйИнтерфейс

// Инициализировать структуру параметров запроса в ИС МОТП (ИС МП) для получения ключа сессии.
// 
// Параметры:
// 	Организация - ОпределяемыйТип.Организация, Неопределено - Организация.
// Возвращаемое значение:
// 	Структура - Параметры запроса ключа сессии См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии.
//
Функция ПараметрыЗапросаКлючаСессии(Организация = Неопределено) Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = ПараметрыОтправкиHTTPЗапросов();
	
	ПараметрыЗапроса = ИСМПТВыбытиеКодовМаркировкиКлиентСервер.ИнтерфейсАвторизацииИСМПКлиентСервер_ПараметрыЗапросаКлючаСессии();
	ПараметрыЗапроса.Организация = Организация;
	
	ПараметрыЗапроса.ПредставлениеСервиса             = ПараметрыОтправкиHTTPЗапросов.ПредставлениеСервиса;
	ПараметрыЗапроса.Сервер                           = ПараметрыОтправкиHTTPЗапросов.Сервер;
	ПараметрыЗапроса.Порт                             = ПараметрыОтправкиHTTPЗапросов.Порт;
	ПараметрыЗапроса.Таймаут                          = ПараметрыОтправкиHTTPЗапросов.Таймаут;
	ПараметрыЗапроса.ИспользоватьЗащищенноеСоединение = ПараметрыОтправкиHTTPЗапросов.ИспользоватьЗащищенноеСоединение;
	
	ПараметрыЗапроса.ИмяПараметраСеанса                = "ДанныеКлючаСессииМОТП";
	ПараметрыЗапроса.АдресЗапросаПараметровАвторизации = "api/v3/auth/cert/key";
	ПараметрыЗапроса.АдресЗапросаКлючаСессии           = "api/v3/auth/cert/";
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Возвращает адрес сервера ИС МОТП.
// 
// Возвращаемое значение:
// 	Строка - адрес сервера ИС МОТП.
//
Функция АдресСервера() Экспорт
	
	Возврат "ismotp.crptech.ru";
	
КонецФункции

// Возвращает параметры для отправки HTTP запросов МОТП.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ИспользоватьЗащищенноеСоединение - Булево - Признак использования SSL.
// * Таймаут - Число - Таймаут соединения.
// * Порт - Число - Порт соединения.
// * Сервер - Строка - Адрес сервера.
// * ПредставлениеСервиса - Строка - Представления сервиса.
//
Функция ПараметрыОтправкиHTTPЗапросов() Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = Новый Структура;
	ПараметрыОтправкиHTTPЗапросов.Вставить("Сервер",                           АдресСервера());
	ПараметрыОтправкиHTTPЗапросов.Вставить("Порт",                             443);
	ПараметрыОтправкиHTTPЗапросов.Вставить("Таймаут",                          60);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ИспользоватьЗащищенноеСоединение", Истина);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ПредставлениеСервиса",             НСтр("ru = 'ИС МОТП';
																					|en = 'ИС МОТП'"));
	
	Возврат ПараметрыОтправкиHTTPЗапросов;
	
КонецФункции

#КонецОбласти