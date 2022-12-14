
#Область ОтражениеАктовВУчете
	
Функция ПолучитьСписокДокументовОснованияДляАВР(Направление = Неопределено) Экспорт
	
	// Получить список документов ЭДВС по типу формы.
	ДокументыВыбора = Новый СписокЗначений;
	
	Если Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Входящий") Тогда	
		// Список документов основания - входящего АВР
		ДокументыВыбора.Добавить("ПриобретениеТоваровУслуг", "Приобретение товаров и услуг");
		ДокументыВыбора.Добавить("ПриобретениеУслугПрочихАктивов", "Приобретение услуг и прочих активов");
	Иначе
		// Список документов основания - исходящего АВР
		ДокументыВыбора.Добавить("АктВыполненныхРабот", "Акт выполненных работ для клиента");
		ДокументыВыбора.Добавить("РеализацияУслугПрочихАктивов", "Реализация услуг и прочих активов");
	КонецЕсли;
	
	Возврат ДокументыВыбора;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, ИмяПоля,
	ПравоеЗначение = Неопределено,
	ВидСравнения = Неопределено,
	Представление = Неопределено,
	Использование = Неопределено,
	РежимОтображения = Неопределено,
	ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, ИмяПоля,
		ПравоеЗначение,
		ВидСравнения,
		Представление,
		Использование,
		РежимОтображения,
		ИдентификаторПользовательскойНастройки);
	
КонецПроцедуры

#КонецОбласти
