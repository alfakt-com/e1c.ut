﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетФактура = Параметры.СчетФактура;
	ЭтоЗаявлениеОВвозе = (ТипЗнч(СчетФактура) = Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров"));
	ЭтоНалоговыйАгент = (ТипЗнч(СчетФактура) = Тип("ДокументСсылка.СчетФактураНалоговыйАгент"));
	СуммаНДСПоДокументу = РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ПолучитьСуммуНДСКОплатеВБюджет(СчетФактура);
	
	ДанныеОплат = РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ПолучитьДанныеОплат(СчетФактура);
	Для Каждого СтрокаТаблицыОплат Из ДанныеОплат Цикл
		СтрокаОплаты = ДокументыОплаты.Добавить();
		СтрокаОплаты.Сумма 					= СтрокаТаблицыОплат.Сумма;
		СтрокаОплаты.Дата 					= СтрокаТаблицыОплат.ДатаДокументаПеречисленияНалога;
		СтрокаОплаты.Номер 					= СтрокаТаблицыОплат.НомерДокументаПеречисленияНалога;
		СтрокаОплаты.РучнаяКорректировка 	= СтрокаТаблицыОплат.РучнаяКорректировка;
		СтрокаОплаты.ДатаПеречисленияНалога = СтрокаТаблицыОплат.ДатаПодтвержденияОплаты;
	КонецЦикла;
	
	Если ЭтоЗаявлениеОВвозе Тогда
		Если Параметры.Свойство("НомерОтметкиОРегистрации") Тогда
			НомерОтметкиОРегистрацииЗаявления = Параметры.НомерОтметкиОРегистрации;
		Иначе
			НомерОтметкиОРегистрацииЗаявления = "";
		КонецЕсли;
		ДанныеОтметки = РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ПолучитьДанныеОтметкиНалоговогоОргана(СчетФактура);
		Если ДанныеОтметки <> Неопределено Тогда
			ОплатаПодтверждена = Истина;
			НомерОтметкиОРегистрации = ДанныеОтметки.НомерОтметкиОРегистрации;
			ДатаПодтвержденияОплаты = ДанныеОтметки.ДатаПодтвержденияОплаты;
		ИначеЕсли ЗначениеЗаполнено(НомерОтметкиОРегистрацииЗаявления) Тогда
			НомерОтметкиОРегистрации = НомерОтметкиОРегистрацииЗаявления;
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоЗаявлениеОВвозе ИЛИ ЭтоНалоговыйАгент Тогда
		Элементы.ФормаЗаполнить.Заголовок = НСтр("ru = 'Заполнить по оплатам в бюджет'");
	Иначе
		Элементы.ФормаЗаполнить.Заголовок = НСтр("ru = 'Заполнить по расчетам с таможней'");
	КонецЕсли;
	
	УстановитьТекстПодсказки(ЭтотОбъект);	
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОплатаПодтверждена Тогда
	    ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НомерОтметкиОРегистрации"));
	    ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДатаПодтвержденияОплаты"));
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ДокументыОплаты Цикл
		НомерСтроки = ДокументыОплаты.Индекс(СтрокаТЧ)+1;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Номер) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'В строке %1 не заполнен номер документа перечисления налога'"), НомерСтроки),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОплаты", НомерСтроки, "Номер"),
				,
				Отказ);
	    КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Дата) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'В строке %1 не заполнена дата документа перечисления налога'"), НомерСтроки),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОплаты", НомерСтроки, "Дата"),
				,
				Отказ);
	    КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Сумма) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'В строке %1 не заполнена сумма НДС'"), НомерСтроки),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОплаты", НомерСтроки, "Сумма"),
				,
				Отказ);
	    КонецЕсли;
		Если ЭтоНалоговыйАгент И Не ЗначениеЗаполнено(СтрокаТЧ.ДатаПеречисленияНалога) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'В строке %1 не заполнена дата перечисления налога'"), НомерСтроки),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОплаты", НомерСтроки, "ДатаПеречисленияНалога"),
				,
				Отказ);
	    КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОплатаПодтвержденаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыОплаты

&НаКлиенте
Процедура ДокументыОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Не ОтменаРедактирования Тогда
		Элемент.ТекущиеДанные.РучнаяКорректировка = 1;	
	КонецЕсли;
	УстановитьТекстПодсказки(ЭтотОбъект);	
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОплатыДатаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДокументыОплаты.ТекущиеДанные;
	
	Если Не ЭтоНалоговыйАгент ИЛИ ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ДатаПеречисленияНалога = ТекущиеДанные.Дата;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьПоДаннымРасчетовНаСервере();	
	УстановитьТекстПодсказки(ЭтотОбъект);	
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ЗаписатьНаСервере());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстПодсказки(Форма)
	
	ТекстСообщенияОплаченоПолностью = НСтр("ru='Всего перечислено в бюджет [Оплачено] тг.
		|Это соответствует сумме НДС по документу.'");
	ТекстСообщенияОсталосьОплатить = НСтр("ru='Всего перечислено в бюджет [Оплачено] тг.
		|Осталось перечислить [Осталось] тг.'");
	
	СуммаОплачено = Форма.ДокументыОплаты.Итог("Сумма");
	
	Если Форма.СуммаНДСПоДокументу = СуммаОплачено Тогда
		НадписьПеречисленоВБюджет = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
			ТекстСообщенияОплаченоПолностью, 
			Новый Структура("Оплачено", СуммаОплачено));
	Иначе
		НадписьПеречисленоВБюджет = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
			ТекстСообщенияОсталосьОплатить, 
			Новый Структура("Оплачено,Осталось", 
				СуммаОплачено, 
				Форма.СуммаНДСПоДокументу - СуммаОплачено));
	КонецЕсли;
			
	Форма.НадписьОплачено = НадписьПеречисленоВБюджет;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.ДатаПодтвержденияОплаты.Видимость = ОплатаПодтверждена;
	Элементы.НомерОтметкиОРегистрации.Видимость = ОплатаПодтверждена;
	Элементы.ГруппаПодтвержденияОплаты.Видимость = ЭтоЗаявлениеОВвозе;
	Элементы.ДокументыОплатыДатаПеречисленияНалога.Видимость = ЭтоНалоговыйАгент;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНаСервере()

	РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ЗаписатьДанныеОплаты(СчетФактура, ДокументыОплаты);

	Если ЭтоЗаявлениеОВвозе Тогда
		РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ЗаписатьПодтверждениеОплаты(СчетФактура, 
																				   ОплатаПодтверждена,
																				   НомерОтметкиОРегистрации,
																				   ДатаПодтвержденияОплаты);
		Документы.ЗаявлениеОВвозеТоваров.СформироватьДвиженияВЖурналУчетаСчетовФактур(СчетФактура);
	Иначе 		
		Документы.СчетФактураНалоговыйАгент.СформироватьДвиженияВЖурналУчетаСчетовФактур(СчетФактура);
	КонецЕсли;
	
	Возврат РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ТекстСостояниеОплатыНДСВБюджет(СчетФактура);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоДаннымРасчетовНаСервере()
	
	ТаблицаОплат = РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.СформироватьТаблицуОплатНДСВБюджет(СчетФактура, ДокументыОплаты.Выгрузить());
	
	ДокументыОплаты.Загрузить(ТаблицаОплат);	
	
КонецПроцедуры

#КонецОбласти
