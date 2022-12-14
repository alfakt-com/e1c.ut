#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЭтоНовый() 
		И Не Константы.ИспользуетсяОбменСБухгалтериейПредприятия.Получить() Тогда
		Константы.ИспользуетсяОбменСБухгалтериейПредприятия.Установить(Истина);
	Иначе
		Если ПометкаУдаления Тогда
			//Выполним проверку на наличие других правил обмена с Бухгалтерией предприятия
			Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
				|	ОбменУправлениеТорговлейБухгалтерияПредприятия.Ссылка
				|ИЗ
				|	ПланОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия КАК ОбменУправлениеТорговлейБухгалтерияПредприятия
				|ГДЕ
				|	ОбменУправлениеТорговлейБухгалтерияПредприятия.ПометкаУдаления = ЛОЖЬ
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 1
				|	ОбменУправлениеТорговлейБухгалтерияПредприятия30.Ссылка
				|ИЗ
				|	ПланОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30 КАК ОбменУправлениеТорговлейБухгалтерияПредприятия30
				|ГДЕ
				|	ОбменУправлениеТорговлейБухгалтерияПредприятия30.ПометкаУдаления = ЛОЖЬ
				|	И ОбменУправлениеТорговлейБухгалтерияПредприятия30.Ссылка <> &ЭтотУзел");

			Запрос.УстановитьПараметр("ЭтотУзел", Ссылка);
			
			Если Запрос.Выполнить().Пустой() Тогда
				Константы.ИспользуетсяОбменСБухгалтериейПредприятия.Установить(Ложь);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	// Очистка неиспользуемых реквизитов и заполнение служебных
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		ВыгружатьЦеныНоменклатуры       = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		РежимВыгрузкиПриНеобходимости    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;

		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			ВыгружатьЦеныНоменклатуры       = Ложь;
			РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если Не ВыгружатьЦеныНоменклатуры И ВидыЦенНоменклатуры.Количество() <> 0 Тогда
		ВидыЦенНоменклатуры.Очистить();
	ИначеЕсли ВидыЦенНоменклатуры.Количество() = 0 И ВыгружатьЦеныНоменклатуры Тогда
		ВыгружатьЦеныНоменклатуры = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УправленческаяОрганизация) Тогда
		УправленческаяОрганизация = Справочники.Организации.УправленческаяОрганизация;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	ОбменДаннымиСобытияУТУП.ОбновитьКэшМеханизмовРегистрации();
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОбменДаннымиУТ.АктуализироватьПризнакИспользованияОбменаСБухгалтерией(ЭтотОбъект, ПометкаУдаления);
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ПравилаСозданияДоговоровКонтрагентов"));
	Иначе
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") 
			И Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи")
			И Не СворачиватьДокументыПоСкладу Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад"));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры //ОбработкаПроверкиЗаполнения()

#КонецОбласти

#КонецЕсли
