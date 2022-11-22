﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если НЕ Параметры.Свойство("НастройкаСинхронизации") тогда
		Возврат;	
	КонецЕсли;
	
	НастройкаСинхронизации = Параметры.НастройкаСинхронизации;	
	
	
	НастройкиОбмена = НастройкаСинхронизации.НастройкиСинхронизации.Получить();
	
	НастройкиСинхронизацииЗаказов = НастройкиОбмена.НастройкиСинхронизацииЗаказов;
	
	Если НастройкиСинхронизацииЗаказов.Свойство("ИнформацияОПлатежныхСистемах") тогда
		
		ИнформацияОПлатежныхСистемах 	= НастройкиСинхронизацииЗаказов.ИнформацияОПлатежныхСистемах;
		СоответствияПлатежныхСистем 	= ИнформацияОплатежныхСистемах.СоответствияПлатежныхСистем;
		
		Для каждого ТекСтрока из СоответствияПлатежныхСистем Цикл
			
			Если ЗначениеЗаполнено(ТекСтрока.Касса) тогда
				
				НовСтрока = Кассы.Добавить();
				НовСтрока.Касса 			= ТекСтрока.Касса;
				НовСтрока.ПлатежнаяСистема 	= ТекСтрока.ПлатежнаяСистема;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекСтрока.Терминал) тогда
				
				НовСтрока = Терминалы.Добавить();
				НовСтрока.Терминал 			= ТекСтрока.Терминал;
				НовСтрока.ПлатежнаяСистема 	= ТекСтрока.ПлатежнаяСистема;
				НовСтрока.ВидПлатежнойКарты = ТекСтрока.ВидПлатежнойКарты;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекСтрока.РасчетныйСчет) тогда
				
				НовСтрока = РасчетныеСчета.Добавить();
				НовСтрока.РасчетныйСчет 	= ТекСтрока.РасчетныйСчет;
				НовСтрока.ПлатежнаяСистема 	= ТекСтрока.ПлатежнаяСистема;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
		
	Если Модифицированность И НЕ НужноЗакрытьОкно тогда
		Отказ = Истина; 
		
		Если ЗавершениеРаботы = Истина Тогда 
			ТекстПредупреждения = "Настройки по платежным системам не будут сохранены. Закрыть?"; 
		Иначе
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОЗакрытииОкна", ЭтаФорма, Параметры);
			ПоказатьВопрос(Оповещение, "Настройки были изменены. Сохранить изменения перед закрытием?", РежимДиалогаВопрос.ДаНетОтмена, 0);
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОЗакрытииОкна(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда		
		НужноЗакрытьОкно = Истина;
		СохранениеНастроек();
    	Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет тогда
		НужноЗакрытьОкно = Истина;
		Закрыть();
    КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПлатежныеСистемы(Команда)
		
	ОбщиеНастройки =  Б24_СинхронизацияКлиентСервер.СформироватьБазовуюСтруктуруНастроек(НастройкаСинхронизации);  
	
	Если ОбщиеНастройки = Неопределено тогда
		Возврат;
	КонецЕсли;
	                                                                                             
	ОбщиеНастройки.Измерение2 = "Получение списка статусов заказов.";
	
	ТелоHTTPЗапроса = "";	  
	СтруктураОтвета = Б24_RestApiВызовСервера.ОтправкаДанныхНаПортал(ОбщиеНастройки, "/rest/sale.paysystem.list", ТелоHTTPЗапроса); 
	
	Если СтруктураОтвета <> Неопределено тогда
		
		Если СтруктураОтвета.Получить("result") <> Неопределено тогда
			
			ПлатежныеСистемы.Очистить();
			
			Для каждого ТекЭлемент из СтруктураОтвета.Получить("result") Цикл 
				
				ИдЭлемента 		= Формат(ТекЭлемент.Получить("ID"), "ЧГ=0");
				Активно 		= ТекЭлемент.Получить("ACTIVE");
				Наименование 	= ТекЭлемент.Получить("NAME");
				ТипПС 			= ТекЭлемент.Получить("IS_CASH");          //"Y" - наличные, "A" -эквайринг, "N" -безнал
				ТипВладельца 	= ТекЭлемент.Получить("ENTITY_REGISTRY_TYPE");
				
				Если Активно <> "Y" тогда
					Продолжить;
				КонецЕсли;
				
				Если ТипВладельца <> "ORDER" тогда
					Продолжить;
				КонецЕсли;
				
				Если Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаКасс И ТипПС <> "Y" тогда
					Продолжить;
				ИначеЕсли Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаЭкТерминалов И ТипПС <> "A" тогда
					Продолжить;
				ИначеЕсли Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаРС И ТипПС <> "N" тогда
					Продолжить;
				КонецЕсли;		
				
				Используется = Ложь;	
			
				Для каждого ТекКасса из Кассы Цикл
					Если ТекКасса.ПлатежнаяСистема.НайтиПоЗначению(ИдЭлемента) <> Неопределено тогда
						Используется = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Для каждого ТекТерминал из Терминалы Цикл
					Если ТекТерминал.ПлатежнаяСистема.НайтиПоЗначению(ИдЭлемента) <> Неопределено тогда
						Используется = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Для каждого ТекСчет из РасчетныеСчета Цикл
					Если ТекСчет.ПлатежнаяСистема.НайтиПоЗначению(ИдЭлемента) <> Неопределено тогда
						Используется = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			
				Если Не Используется тогда
					ПлатежныеСистемы.Добавить(ИдЭлемента, Наименование); 	
				КонецЕсли;
					
				
			КонецЦикла;

		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазборИЗаписьПлатежныхСистем(УзелОбмена, СтрокаCML)
		
	ЧтениеXML = Новый ЧтениеXML;
		
	Попытка
		ЧтениеXML.УстановитьСтроку(СтрокаCML);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Возврат;
	КонецПопытки;
	
	ВсеПлатежныеСистемы.Очистить();
	
	
	лЭтоПлатежныеСистемы= Ложь;
	лЭтоИд 				= Ложь;
	лЭтоНазвание		= Ложь;
	Пока ЧтениеXML.Прочитать() Цикл
			
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "ПлатежныеСистемы" тогда
			лЭтоПлатежныеСистемы = Истина;
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "ПлатежныеСистемы" тогда
			лЭтоПлатежныеСистемы = Ложь;
		КонецЕсли;
		
		Если лЭтоПлатежныеСистемы тогда
			
			Если ЧтениеXML.ТипУзла 	= ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Элемент" тогда
				СтруктураСтр = Новый Структура("ИдПлатежнойСистемы, НазваниеПлатежнойСистемы, Касса")
			КонецЕсли;
			
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Название" тогда
					лЭтоНазвание = Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Название" тогда
					лЭтоНазвание = Ложь;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Ид" тогда
					лЭтоИд = Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Ид" тогда
					лЭтоИд = Ложь;
				КонецЕсли;
				
				Если лЭтоНазвание И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.НазваниеПлатежнойСистемы = ЧтениеXML.Значение;
				КонецЕсли;
				
				Если лЭтоИд И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.ИдПлатежнойСистемы = ЧтениеXML.Значение;
				КонецЕсли;
			
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Элемент" тогда
				
				НовСтр = ВсеПлатежныеСистемы.Добавить();
				НовСтр.ИдПлатежнойСистемы 		= СтруктураСтр.ИдПлатежнойСистемы;
				НовСтр.НазваниеПлатежнойСистемы = СтруктураСтр.НазваниеПлатежнойСистемы;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПлатежныеСистемы.Очистить();
	
	Для каждого ТекПС из ВсеПлатежныеСистемы Цикл
		
		Используется = Ложь;	
	
		Для каждого ТекКасса из Кассы Цикл
			Если ТекКасса.ПлатежнаяСистема.НайтиПоЗначению(ТекПС.ИдПлатежнойСистемы) <> Неопределено тогда
				Используется = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		
		Для каждого ТекТерминал из Терминалы Цикл
			Если ТекТерминал.ПлатежнаяСистема.НайтиПоЗначению(ТекПС.ИдПлатежнойСистемы) <> Неопределено тогда
				Используется = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		
		Если Не Используется тогда
			ПлатежныеСистемы.Добавить(ТекПС.ИдПлатежнойСистемы, ТекПС.НазваниеПлатежнойСистемы); 	
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	СохранениеНастроек();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СохранениеНастроек()

	СоответствиеПлатежныхСистем = Новый ТаблицаЗначений;
	СоответствиеПлатежныхСистем.Колонки.Добавить("Касса");
	СоответствиеПлатежныхСистем.Колонки.Добавить("Терминал");
	СоответствиеПлатежныхСистем.Колонки.Добавить("РасчетныйСчет");
	СоответствиеПлатежныхСистем.Колонки.Добавить("ВидПлатежнойКарты");
	СоответствиеПлатежныхСистем.Колонки.Добавить("ПлатежнаяСистема");

	Для каждого ТекСтрока из Кассы Цикл
		НоваяСтрока = СоответствиеПлатежныхСистем.Добавить();
		НоваяСтрока.Касса 				= ТекСтрока.Касса;
		НоваяСтрока.ПлатежнаяСистема 	= ТекСтрока.ПлатежнаяСистема;
	КонецЦикла;
	
	Для каждого ТекСтрока из Терминалы Цикл
		НоваяСтрока = СоответствиеПлатежныхСистем.Добавить();
		НоваяСтрока.Терминал 			= ТекСтрока.Терминал;
		НоваяСтрока.ПлатежнаяСистема 	= ТекСтрока.ПлатежнаяСистема;
		НоваяСтрока.ВидПлатежнойКарты 	= ТекСтрока.ВидПлатежнойКарты;
	КонецЦикла;
	
	Для каждого ТекСтрока из РасчетныеСчета Цикл
		НоваяСтрока = СоответствиеПлатежныхСистем.Добавить();
		НоваяСтрока.РасчетныйСчет 		= ТекСтрока.РасчетныйСчет;
		НоваяСтрока.ПлатежнаяСистема 	= ТекСтрока.ПлатежнаяСистема;
	КонецЦикла;
	
	НастройкиОбмена = НастройкаСинхронизации.НастройкиСинхронизации.Получить();
	
	Если НЕ НастройкиОбмена.Свойство("НастройкиСинхронизацииЗаказов") тогда
		СтруктураНастроек = Новый Структура;	
	Иначе
		СтруктураНастроек = НастройкиОбмена.НастройкиСинхронизацииЗаказов;	
	КонецЕсли;
	
	СтруктураИнформацииОСтатусах = Новый Структура;
	СтруктураИнформацииОСтатусах.Вставить("СоответствияПлатежныхСистем"	, СоответствиеПлатежныхСистем);
	
	Справочники.Б24_НастройкиСинхронизацииСБитрикс24.ДобавитьНастройкуВСтруктуру(СтруктураНастроек, "ИнформацияОПлатежныхСистемах", СтруктураИнформацииОСтатусах);
			
	Если НЕ НастройкиОбмена.Свойство("НастройкиСинхронизацииЗаказов") тогда
		НастройкиОбмена.Вставить("НастройкиСинхронизацииЗаказов", СтруктураНастроек); 	
	Иначе
		НастройкиОбмена.НастройкиСинхронизацииЗаказов = СтруктураНастроек;
	КонецЕсли;
	
	ТекущаяНастройкаСинхронизации = НастройкаСинхронизации.ПолучитьОбъект();
	ТекущаяНастройкаСинхронизации.НастройкиСинхронизации = Новый ХранилищеЗначения(НастройкиОбмена);
	ТекущаяНастройкаСинхронизации.Записать();	
	
	ОбновитьПовторноИспользуемыеЗначения();	
	
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ДобавитьПС(Команда)
	
	ПлатежнаяСистема = Элементы.ПлатежныеСистемы.ТекущиеДанные;
	
	Если ПлатежнаяСистема = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаКасс тогда
		
		Если Элементы.Кассы.ТекущиеДанные = Неопределено тогда
			Возврат;
		КонецЕсли;	
		
		НайденнаяСтрока = Кассы.НайтиПоИдентификатору(Элементы.Кассы.ТекущаяСтрока);
		
		Если НайденнаяСтрока <> Неопределено тогда
			
			НайденнаяСтрока.ПлатежнаяСистема.Добавить(ПлатежнаяСистема.Значение, ПлатежнаяСистема.Представление);	
			
		КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаЭкТерминалов тогда	
		
		Если Элементы.Терминалы.ТекущиеДанные = Неопределено тогда
			Возврат;
		КонецЕсли;
		
		НайденнаяСтрока = Терминалы.НайтиПоИдентификатору(Элементы.Терминалы.ТекущаяСтрока);
		
		Если НайденнаяСтрока <> Неопределено тогда
			
			НайденнаяСтрока.ПлатежнаяСистема.Добавить(ПлатежнаяСистема.Значение, ПлатежнаяСистема.Представление);	
			
		КонецЕсли;
		
		
	ИначеЕсли Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаРС тогда	
		
		Если Элементы.РасчетныеСчета.ТекущиеДанные = Неопределено тогда
			Возврат;
		КонецЕсли;
		
		НайденнаяСтрока = РасчетныеСчета.НайтиПоИдентификатору(Элементы.РасчетныеСчета.ТекущаяСтрока);
		
		Если НайденнаяСтрока <> Неопределено тогда
			
			НайденнаяСтрока.ПлатежнаяСистема.Добавить(ПлатежнаяСистема.Значение, ПлатежнаяСистема.Представление);	
			
		КонецЕсли;
		
	КонецЕсли;
	
	НайденноеЗначение = ПлатежныеСистемы.НайтиПоИдентификатору(Элементы.ПлатежныеСистемы.ТекущаяСтрока);
	
	Если НайденноеЗначение <> Неопределено тогда
		
		ПлатежныеСистемы.Удалить(НайденноеЗначение);
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УбратьПС(Команда)
	
	Если Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаКасс тогда
		
		Если Элементы.Кассы.ТекущиеДанные = Неопределено тогда
			Возврат;
		КонецЕсли;	
		
		Для каждого Элемент из Элементы.Кассы.ТекущиеДанные.ПлатежнаяСистема Цикл
			ПлатежныеСистемы.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
		
		Кассы.НайтиПоИдентификатору(Элементы.Кассы.ТекущаяСтрока).ПлатежнаяСистема.Очистить();
		
	ИначеЕсли Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаЭкТерминалов тогда	
		
		Если Элементы.Терминалы.ТекущиеДанные = Неопределено тогда
			Возврат;
		КонецЕсли;	
		
		Для каждого Элемент из Элементы.Терминалы.ТекущиеДанные.ПлатежнаяСистема Цикл
			ПлатежныеСистемы.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
		
		Терминалы.НайтиПоИдентификатору(Элементы.Терминалы.ТекущаяСтрока).ПлатежнаяСистема.Очистить();
		
	ИначеЕсли Элементы.ГруппаОбъектов1С.ТекущаяСтраница = Элементы.ГруппаРС тогда	
		
		Если Элементы.РасчетныеСчета.ТекущиеДанные = Неопределено тогда
			Возврат;
		КонецЕсли;	
		
		Для каждого Элемент из Элементы.РасчетныеСчета.ТекущиеДанные.ПлатежнаяСистема Цикл
			ПлатежныеСистемы.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
		
		РасчетныеСчета.НайтиПоИдентификатору(Элементы.Терминалы.ТекущаяСтрока).ПлатежнаяСистема.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТерминалыТерминалОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	//НайденныеСтроки = Терминалы.НайтиСтроки(Новый Структура("Терминал", ВыбранноеЗначение));
	//
	//Если НайденныеСтроки.Количество() > 0 тогда
	//	Сообщить("Эквайринговый терминал уже есть в списке.");
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыКассаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	//НайденныеСтроки = Кассы.НайтиСтроки(Новый Структура("Касса", ВыбранноеЗначение));
	//
	//Если НайденныеСтроки.Количество() > 0 тогда
	//	Сообщить("Касса уже есть в списке.");
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТерминалыПриАктивизацииЯчейки(Элемент)
	
	
	ТекущаяСтрока = Элементы.Терминалы.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено тогда
		
		лЭлемент = Элементы.Терминалы.ПодчиненныеЭлементы.ТерминалыВидПлатежнойКарты;
		лЭлемент.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивВидовПлатежныхКарт(ТекущаяСтрока.Терминал));
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивВидовПлатежныхКарт(пТерминал)
	
	Результат = Новый Массив;
	
	Для Каждого ТекСтрока из пТерминал.ВидыПлатежныхКарт Цикл
		
		Результат.Добавить(СокрЛП(ТекСтрока.ВидПлатежнойКарты));	
		
	КонецЦикла;
	
	Возврат Результат;	
	
КонецФункции

&НаКлиенте
Процедура ГруппаОбъектов1СПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ПлатежныеСистемы.Очистить();
КонецПроцедуры

#КонецОбласти

