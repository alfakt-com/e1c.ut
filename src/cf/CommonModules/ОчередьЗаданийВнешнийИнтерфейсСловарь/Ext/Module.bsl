
#Область СлужебныйПрограммныйИнтерфейс

#Область ПоляДанных

Функция ПолеОсновнойРаздел() Экспорт
	
	Возврат "general";
	
КонецФункции

Функция ПолеКодСостояния() Экспорт
	
	Возврат "response";
	
КонецФункции

Функция ПолеОшибка() Экспорт
	
	Возврат "error";
	
КонецФункции

Функция ПолеСообщениеОбОшибке() Экспорт
	
	Возврат "message";
	
КонецФункции

Функция ПолеРезультат() Экспорт
	
	Возврат "result";
	
КонецФункции

#КонецОбласти

#Область СообщенияОбОшибках
    
Функция МетодНеПоддерживается() Экспорт
    Возврат НСтр("ru = 'Метод не поддерживается.'");
КонецФункции

Функция ЗаданиеНеНайдено() Экспорт
    Возврат НСтр("ru = 'Задание по идентификатору ''%1'' не найдено.'");
КонецФункции

Функция ЗаданиеПоКлючуНеНайдено() Экспорт
    Возврат НСтр("ru = 'Задание по ключу ''%1'' не найдено.'");
КонецФункции

Функция ФайлНеНайден() Экспорт
    Возврат НСтр("ru='Не найден файл ''%1'''");
КонецФункции

#КонецОбласти 

// Возвращает структуру с именами кодов состояний обработки заданий.
// 
// Возвращаемое значение:
//   - Структура - имена состояний с значениями кодов состояний.
//
Функция КодыСостояний() Экспорт
	
	КодыСостояний = Новый Структура;
    КодыСостояний.Вставить("ОшибкаДанных", 10400);
    КодыСостояний.Вставить("ВнутренняяОшибка", 10500);
    КодыСостояний.Вставить("Ожидание", 10202);
    КодыСостояний.Вставить("Выполнено", 10200);
    КодыСостояний.Вставить("ВыполненоСПредупреждениями", 10240);
    Возврат КодыСостояний;
    
КонецФункции

#КонецОбласти 
