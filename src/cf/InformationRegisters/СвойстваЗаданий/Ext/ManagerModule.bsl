﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс
    
// Устанавливает свойства с результатами выполнения задания, сохраняемые после выполнения задания и его удаления.
//
// Параметры:
//  Задание  - СпрвочникСсылка.ОчередьЗаданий, СпрвочникСсылка.ОчередьЗаданийОбластейДанных - задание.
//  Свойства - Структура - значения свойств для установки (см. функцию НовыйСвойстваЗадания()).
//
Процедура Установить(Знач Задание, Свойства = Неопределено) Экспорт
    
    Словарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    ИдентификаторЗадания = ИдентификаторЗадания(Задание);
    Запись = СоздатьМенеджерЗаписи();
    Запись.ИдентификаторЗадания = ИдентификаторЗадания;
    Запись.Прочитать();
    Если Не Запись.Выбран() Тогда
        Запись.ИдентификаторЗадания = ИдентификаторЗадания;
        Задание = Справочники.ОчередьЗаданийОбластейДанных.ПолучитьСсылку(ИдентификаторЗадания);
        Если ОбщегоНазначения.СсылкаСуществует(Задание) Тогда
            Запись.Задание = Задание;
        КонецЕсли;
    Иначе
        // Если у задания были результаты или сообщения об ошибках, их нужно пометить временными (к удалению).
        Если ЗначениеЗаполнено(Запись.ИдентификаторСообщенияОбОшибке) Тогда
            РегистрыСведений.ФайлыОбластейДанных.УстановитьПризнакВременного(Запись.ИдентификаторСообщенияОбОшибке);
        КонецЕсли; 
        Если ЗначениеЗаполнено(Запись.ИдентификаторРезультата) Тогда
            РегистрыСведений.ФайлыОбластейДанных.УстановитьПризнакВременного(Запись.ИдентификаторРезультата);
        КонецЕсли; 
    КонецЕсли;
    Если Свойства <> Неопределено Тогда
        Если ЗначениеЗаполнено(Свойства.Результат) Тогда
            ИмяФайла = Словарь.ПолеРезультат() + "-" + Строка(ИдентификаторЗадания);
            Данные = ПолучитьДвоичныеДанныеИзСтроки(Свойства.Результат);
            ИдентификаторРезультата = РегистрыСведений.ФайлыОбластейДанных.Загрузить(ИмяФайла, Данные); 
        Иначе
            ИдентификаторРезультата = ПустойИдентификатор();
        КонецЕсли; 
        Если ЗначениеЗаполнено(Свойства.СообщениеОбОшибке) Тогда
            ИмяФайла = Словарь.ПолеСообщениеОбОшибке() + "-" + Строка(ИдентификаторЗадания);
            Данные = ПолучитьДвоичныеДанныеИзСтроки(Свойства.СообщениеОбОшибке);
            ИдентификаторСообщенияОбОшибке = РегистрыСведений.ФайлыОбластейДанных.Загрузить(ИмяФайла, Данные); 
        Иначе
            ИдентификаторСообщенияОбОшибке = ПустойИдентификатор();     
        КонецЕсли; 
        Запись.КодСостояния = Свойства.КодСостояния;
        Запись.ИдентификаторРезультата = ИдентификаторРезультата;
        Запись.ИдентификаторСообщенияОбОшибке = ИдентификаторСообщенияОбОшибке;
    КонецЕсли; 
    Если ЗначениеЗаполнено(Запись.ИдентификаторСообщенияОбОшибке) Тогда
        Запись.Ошибка = Истина;
    Иначе
        Запись.Ошибка = Ложь;
    КонецЕсли; 
    Запись.Записать();
	
КонецПроцедуры

// Очищает свойство "Задание" при необходимости. Вызывается, если объект задания удаляется.
// Если в данных записи нет результатов или ошибки (КодСостояния = Ожидание), тогда удаляется запись о свойствах. 
//
// Параметры:
//  Задание  - СпрвочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - задание.
//
Процедура ОчиститьСвойствоЗадание(Знач Задание) Экспорт
    
    ИдентификаторЗадания = ИдентификаторЗадания(Задание);
    
    Запись = СоздатьМенеджерЗаписи();
    Запись.ИдентификаторЗадания = ИдентификаторЗадания;
    Запись.Прочитать();
    Если Запись.Выбран() Тогда
        Ожидание = КодыСостояний().Ожидание;
        Если Запись.КодСостояния = Ожидание Тогда
            Запись.Удалить();
        Иначе
            Запись.Задание = Неопределено;
            Запись.Записать();
        КонецЕсли; 
    КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру с пустыми значениями свойств задания. 
// Может использоваться как шаблон для заполнения свойств.
// 
// Возвращаемое значение:
//   - Структура - свойства задания:
//     * КодСостояния - Строка - код состояния задания (см. функцию ОчередьЗаданийВнешнийИнтерфейсСловарь.КодыСостояний())
//     * Ошибка - Булево - признак возникновения ошибки в процессе выполнения задания.
//     * СообщениеОбОшибке - Строка - сообщение об ошибке в процессе выполнения задания.
//     * Результат - Строка - описание результата выполнения задания. Если передана строка в формате JSON, 
//                            то она будет интегрирована в результирующий ответ в составе JSON.
//
Функция НовыйСвойстваЗадания() Экспорт
	
	СвойстваЗадания = Новый Структура;
    СвойстваЗадания.Вставить("КодСостояния", 0);
    СвойстваЗадания.Вставить("Ошибка", Ложь);
    СвойстваЗадания.Вставить("СообщениеОбОшибке", "");
    СвойстваЗадания.Вставить("Результат", "");
    Возврат СвойстваЗадания;
	
КонецФункции

// Возвращает структуру с именами кодов состояний обработки заданий.
// 
// Возвращаемое значение:
//   - Структура - имена состояний с значениями кодов состояний.
//
Функция КодыСостояний() Экспорт
    
    Возврат ОчередьЗаданийВнешнийИнтерфейсСловарь.КодыСостояний();
    
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ПеренестиДанныеВФайлы() Экспорт
	
    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ
        |   СвойстваЗаданий.ИдентификаторЗадания КАК ИдентификаторЗадания,
        |   СвойстваЗаданий.КодСостояния КАК КодСостояния,
        |   СвойстваЗаданий.Ошибка КАК Ошибка,
        |   СвойстваЗаданий.УдалитьСообщениеОбОшибке КАК СообщениеОбОшибке,
        |   СвойстваЗаданий.УдалитьРезультат КАК Результат
        |ИЗ
        |   РегистрСведений.СвойстваЗаданий КАК СвойстваЗаданий
        |ГДЕ
        |   (СвойстваЗаданий.ИдентификаторРезультата = &ПустойИдентификатор
        |               И СвойстваЗаданий.УдалитьРезультат <> """"
        |           ИЛИ СвойстваЗаданий.ИдентификаторСообщенияОбОшибке = &ПустойИдентификатор
        |               И СвойстваЗаданий.УдалитьСообщениеОбОшибке <> """")";
    
    Запрос.УстановитьПараметр("ПустойИдентификатор", ПустойИдентификатор());
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    
    Пока Выборка.Следующий() Цикл
        Свойства = НовыйСвойстваЗадания();
        ЗаполнитьЗначенияСвойств(Свойства, Выборка);
        Установить(Выборка.ИдентификаторЗадания, Свойства);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция УдалитьНеАктуальныеЗаписи(Параметры) Экспорт
	
	СостояниеОжидание = ОчередьЗаданийВнешнийИнтерфейсСловарь.КодыСостояний().Ожидание;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
        |   СвойстваЗаданий.ИдентификаторЗадания КАК ИдентификаторЗадания
        |ИЗ
        |   РегистрСведений.СвойстваЗаданий КАК СвойстваЗаданий
        |ГДЕ
        |   СвойстваЗаданий.КодСостояния = &СостояниеОжидание
        |   И (СвойстваЗаданий.Задание = НЕОПРЕДЕЛЕНО
        |           ИЛИ СвойстваЗаданий.Задание ЕСТЬ NULL
        |           ИЛИ СвойстваЗаданий.Задание = &ПустоеЗадание)";
	Запрос.УстановитьПараметр("СостояниеОжидание", СостояниеОжидание);
    Запрос.УстановитьПараметр("ПустоеЗадание", Справочники.ОчередьЗаданийОбластейДанных.ПустаяСсылка());
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Набор = СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторЗадания.Установить(Выборка.ИдентификаторЗадания, Истина);
		Набор.Записать();
	КонецЦикла;

КонецФункции

Функция ИдентификаторЗадания(Знач Задание)
	
    Если ТипЗнч(Задание) = Тип("УникальныйИдентификатор") Тогда
        ИдентификаторЗадания = Задание;
    Иначе
        ИдентификаторЗадания = Задание.УникальныйИдентификатор();
    КонецЕсли;
    Возврат ИдентификаторЗадания;
	
КонецФункции

Функция ПустойИдентификатор()
	
	Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
КонецФункции
 
#КонецОбласти 

#КонецЕсли
 
 