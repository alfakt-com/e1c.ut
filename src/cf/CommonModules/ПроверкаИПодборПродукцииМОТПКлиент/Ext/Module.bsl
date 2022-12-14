
#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм

// Пересчитывает хеш-суммы всех упаковок формы. На клиенте формируется структура для расчёта, на сервере
// вычисляются хеш-суммы и проверяется необходимость перемаркировки.
//
// Параметры:
//	Форма - УправляемаяФорма - форма проверки и подбора маркируемой продукции.
//
Процедура ПересчитатьХешСуммыВсехУпаковок(Форма) Экспорт

	Если НЕ Форма.РасчитыватьХешСуммуУпаковок Тогда
		Возврат;
	КонецЕсли;

	Если Форма.ДетализацияСтруктурыХранения = ПредопределенноеЗначение("Перечисление.ДетализацияСтруктурыХраненияТабачнойПродукцииМОТП.Пачки") Тогда
		Форма.КоличествоУпаковокКоторыеНеобходимоПеремаркировать = 0;
		ПроверкаИПодборПродукцииМОТПКлиентСервер.ОтобразитьИнформациюОНеобходимостиПеремаркировки(Форма);
		Возврат;
	КонецЕсли;
	
	ЗначенияСтрокДерева = Новый Массив();
	
	ИСМПТВыбытиеКодовМаркировкиКлиент.ПроверкаИПодборПродукцииИСКлиент_ЗаполнитьЗначенияСтрокДереваДляРасчетаХешСумм(ЗначенияСтрокДерева, Форма.ДеревоМаркированнойПродукции.ПолучитьЭлементы());

	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииМОТПВызовСервера.ПересчитатьХешСуммыВсехУпаковок(ЗначенияСтрокДерева);
	
	ИСМПТВыбытиеКодовМаркировкиКлиент.ПроверкаИПодборПродукцииИСКлиент_ЗаполнитьХешСуммыВСтрокахДереваУпаковок(ЗначенияСтрокДерева, Форма.ДеревоМаркированнойПродукции);
	
	ПроверкаИПодборПродукцииМОТПКлиентСервер.ПроверитьНеобходимостьПеремаркировки(Форма, ТаблицаПеремаркировки, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТипыШтрихкодов

Функция ДоступныеТипыШтрихкодовСтрокой() Экспорт
	
	ДоступныеТипы = Новый СписокЗначений();
	
	ДоступныеТипы.Добавить("GS1128");
	ДоступныеТипы.Добавить("SSCC");
	
	Возврат ДоступныеТипы;
	
КонецФункции

#КонецОбласти

#КонецОбласти