#Область Серии

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(Метаданные.Обработки.СопоставлениеКлассификаторовЕГАИС);
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерий(Метаданные.Обработки.СопоставлениеКлассификаторовЕГАИС, Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ТекстЗапросаЗаполненияСтатусовУказанияСерий(Метаданные.Обработки.СопоставлениеКлассификаторовЕГАИС, ПараметрыУказанияСерий);

КонецФункции

#КонецОбласти