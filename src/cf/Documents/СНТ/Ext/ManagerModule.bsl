﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ДляВызоваИзДругихПодсистем

Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	СНТСерверПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение, "СНТ");
	
КонецПроцедуры

#КонецОбласти

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	СНТСерверПереопределяемый.ДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СНТСерверПереопределяемый.ПечатьСНТ(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.
	
Функция ПечатьСНТ(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	ТабличныйДокумент = ОбработкаОбменСНТ.ПечатьСНТ(МассивОбъектов, ОбъектыПечати);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ЗаполнитьНомерСтрокиСНТ(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	Если Параметры.Свойство("МассивОбработанныхСНТ") Тогда
		МассивОбработанныхСНТ = Параметры.МассивОбработанныхСНТ;
	Иначе
		МассивОбработанныхСНТ = Новый Массив;
		Параметры.Вставить("МассивОбработанныхСНТ", МассивОбработанныхСНТ);
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	СНТ.Ссылка КАК Ссылка
		|
		|ИЗ
		|	Документ.СНТ КАК СНТ
		|ГДЕ
		|	НЕ СНТ.Ссылка В (&МассивОбработанныхСНТ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СНТ.Дата
		|";
	
	Запрос.УстановитьПараметр("МассивОбработанныхСНТ", МассивОбработанныхСНТ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;

	Выборка = РезультатЗапроса.Выбрать();
	ОбъектовОбработано = 0;
	
	СоответствиеНомеровТаблицИНазванийСНТ = СНТСервер.СоответствиеНомеровТаблицИНазванийСНТ();
	
	Пока Выборка.Следующий() Цикл
		
		МассивОбработанныхСНТ.Добавить(Выборка.Ссылка);
		СНТ = Выборка.Ссылка.ПолучитьОбъект();
		
		СНТ.ОбменДанными.Загрузка 	 = Истина;
		
		Для Каждого СтрокаСоответствия Из СоответствиеНомеровТаблицИНазванийСНТ Цикл
			
			Для Каждого СтрокаТовары Из СНТ[СтрокаСоответствия.Значение] Цикл
				Если Не ЗначениеЗаполнено(СтрокаТовары.НомерСтрокиСНТ) Тогда
					СтрокаТовары.НомерСтрокиСНТ = СтрокаТовары.НомерСтроки;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;

		Попытка
			СНТ.Записать();
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
		Исключение
			ТекстСообщения = НСтр("ru='При записи документа %1 произошла ошибка: %2'");
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, СНТ, ОписаниеОшибки());
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
				
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
КонецПроцедуры

Процедура ЗаполнитьСПСНТ(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	Если Параметры.Свойство("МассивОбработанныхСНТ") Тогда
		МассивОбработанныхСНТ = Параметры.МассивОбработанныхСНТ;
	Иначе
		МассивОбработанныхСНТ = Новый Массив;
		Параметры.Вставить("МассивОбработанныхСНТ", МассивОбработанныхСНТ);
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	СНТ.Ссылка КАК Ссылка,
		|	Организации.%СтруктурнаяЕдиницаИдентификационныйНомер КАК БИНОрганизации
		|
		|ИЗ
		|	Документ.СНТ КАК СНТ
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО СНТ.Организация = Организации.Ссылка
		|ГДЕ
		|	НЕ СНТ.Ссылка В (&МассивОбработанныхСНТ)
		|УПОРЯДОЧИТЬ ПО
		|	СНТ.Дата
		|";
	
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%СтруктурнаяЕдиницаИдентификационныйНомер", "");
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(Запрос.Текст, СоответсвиеИменРеквизитов);

	Запрос.УстановитьПараметр("МассивОбработанныхСНТ", МассивОбработанныхСНТ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;

	Выборка = РезультатЗапроса.Выбрать();
	ОбъектовОбработано = 0;
	
	Пока Выборка.Следующий() Цикл
		
		МассивОбработанныхСНТ.Добавить(Выборка.Ссылка);
		СНТ = Выборка.Ссылка.ПолучитьОбъект();
		
		СНТ.ОбменДанными.Загрузка 	 = Истина;
		
		Если Не ЗначениеЗаполнено(СНТ.СтруктурноеПодразделение) 
			И ЗначениеЗаполнено(СНТ.Поставщик) 
			И ТипЗнч(СНТ.Поставщик) = СНТСерверПереопределяемый.ПолучитьТипПодразделенияОрганизаций() Тогда
			
			СНТ.СтруктурноеПодразделение = СНТ.Поставщик;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СНТ.СтруктурноеПодразделениеПолучатель) 
			И ЗначениеЗаполнено(СНТ.Получатель) 
			И ТипЗнч(СНТ.Получатель) = СНТСерверПереопределяемый.ПолучитьТипПодразделенияОрганизаций() Тогда
			
			СНТ.СтруктурноеПодразделениеПолучатель = СНТ.Получатель;
		КонецЕсли;
		
		//в поле Поставщик д.б. указана головная организация, если в поле БИН указан БИН головы
		Если ЗначениеЗаполнено(СНТ.Поставщик) И ТипЗнч(СНТ.Поставщик) = СНТСерверПереопределяемый.ПолучитьТипПодразделенияОрганизаций() Тогда
			Если ЗначениеЗаполнено(СНТ.ПоставщикИдентификатор) И ЗначениеЗаполнено(СНТ.ПоставщикБИНСтруктурногоПодразделения) 
				И (СНТ.ПоставщикИдентификатор <> СНТ.ПоставщикБИНСтруктурногоПодразделения) 
				И (СНТ.ПоставщикИдентификатор = Выборка.БИНОрганизации)Тогда
				
				СНТ.Поставщик = СНТ.Организация;
			КонецЕсли;
		КонецЕсли;
		
		//в поле Получатель д.б. указана головная организация, если в поле БИН указан БИН головы
		Если ЗначениеЗаполнено(СНТ.Получатель) И ТипЗнч(СНТ.Получатель) = СНТСерверПереопределяемый.ПолучитьТипПодразделенияОрганизаций() Тогда
			Если ЗначениеЗаполнено(СНТ.ПолучательИдентификатор) И ЗначениеЗаполнено(СНТ.ПолучательБИНСтруктурногоПодразделения) 
				И (СНТ.ПолучательИдентификатор <> СНТ.ПолучательБИНСтруктурногоПодразделения) 
				И (СНТ.ПолучательИдентификатор = Выборка.БИНОрганизации)Тогда
				
				СНТ.Получатель = СНТ.Организация;
			КонецЕсли;
		КонецЕсли;

		Попытка
			СНТ.Записать();
			ОбъектовОбработано = ОбъектовОбработано + 1;
		Исключение
			ТекстСообщения = НСтр("ru='При записи документа %1 произошла ошибка: %2'");
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, СНТ, ОписаниеОшибки());
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
				
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
КонецПроцедуры

Процедура ЗаполнитьСтатусСопоставленияДляСНТ(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	Если Параметры.Свойство("МассивОбработанныхСНТ") Тогда
		МассивОбработанныхСНТ = Параметры.МассивОбработанныхСНТ;
	Иначе
		МассивОбработанныхСНТ = Новый Массив;
		Параметры.Вставить("МассивОбработанныхСНТ", МассивОбработанныхСНТ);
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	СНТ.Ссылка КАК Ссылка
		|
		|ИЗ
		|	Документ.СНТ КАК СНТ
		|ГДЕ
		|	НЕ СНТ.Ссылка В (&МассивОбработанныхСНТ)
		|	И СНТ.СтатусСопоставленияДляСНТ = ЗНАЧЕНИЕ(Перечисление.СтатусыСопоставленияДляСНТ.ПустаяСсылка)
		|УПОРЯДОЧИТЬ ПО
		|	СНТ.Дата
		|";
	
	Запрос.УстановитьПараметр("МассивОбработанныхСНТ", МассивОбработанныхСНТ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;

	Выборка = РезультатЗапроса.Выбрать();
	ОбъектовОбработано = 0;
	
	Пока Выборка.Следующий() Цикл
		
		МассивОбработанныхСНТ.Добавить(Выборка.Ссылка);
		СНТ = Выборка.Ссылка.ПолучитьОбъект();
		
		СНТ.ОбменДанными.Загрузка = Истина;
		
		СНТ.СтатусСопоставленияДляСНТ = Перечисления.СтатусыСопоставленияДляСНТ.НеТребуетсяСопоставление;

		Попытка
			СНТ.Записать();
			ОбъектовОбработано = ОбъектовОбработано + 1;
		Исключение
			ТекстСообщения = НСтр("ru='При записи документа %1 произошла ошибка: %2'");
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, СНТ, ОписаниеОшибки());
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
				
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Представление = "СНТ № " + Данные.НомерСНТ + " от " + Формат(Данные.Дата, "ДФ = dd.MM.yyyy HH:mm:ss") + "";
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("НомерСНТ");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли