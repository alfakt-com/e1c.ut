﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/RemoteAdministration/App/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
Функция Версия() Экспорт
	
	Возврат "1.0.3.10";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "RemoteAdministrationApp";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_1);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_2);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_3);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_4);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_5);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_6);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_7);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_8);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_9);
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияОбработчикСообщения_1_0_3_10);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}UpdateUser.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОбновитьПользователя(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "UpdateUser");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetFullControl.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПолныеПраваОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetFullControl");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetApplicationAccess.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьДоступКОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetApplicationAccess");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetDefaultUserRights.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПраваПользователяПоУмолчанию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetDefaultUserRights");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetAPIAccess.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьДоступКAPIОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetAPIAccess");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}PrepareApplication.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодготовитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PrepareApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}BindApplication.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПрикрепитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "BindApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}BindApplication.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодготовитьИПрикрепитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PrepareAndBindApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}UsersList.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеСписокПользователей(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "UsersList");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}PrepareCustomApplication.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодготовитьОбластьДанныхИзВыгрузки(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PrepareCustomApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}DeleteApplication.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУдалитьОбластьДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteApplication");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetApplicationParams.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПараметрыОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetApplicationParams");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetIBParams.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьПараметрыИБ(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetIBParams");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetServiceManagerEndPoint.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьКонечнуюТочкуМенеджераСервиса(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetServiceManagerEndPoint");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}ApplicationsRating.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция ТипРейтингОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationRating");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}SetApplicationsRating.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеУстановитьРейтингОбластейДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetApplicationsRating");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cfresh/RemoteAdministration/App/a.b.c.d}PrepareApplicationForMigration.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПодготовитьОбластьДанныхДляМиграции(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PrepareApplicationForMigration");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
