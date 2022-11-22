﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("КассыККМ") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	
	Для Каждого Касса Из Параметры.КассыККМ Цикл
		ЗаполнитьЗначенияСвойств(КассыККМ.Добавить(), Касса);
	КонецЦикла;
	ЗаполнитьСвязанныеКассыККМ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьКомандРегистрации();
	УстановитьДоступностьОперацийПоКассе(КассыККМ.Количество() > 0);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьДоступностьКомандРегистрации();
	КассыККМ.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКассыККМ

&НаКлиенте
Процедура КассыККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "КассыККМПредставлениеКассыККМ" Тогда
		ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
		ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ПросмотрСпискаКасс",
			Новый Структура("СписокКасс", ТекущиеДанные.СвязанныеКассыККМ));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьРегистрациюКассы(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ОповещениеПослеРегистрацииКассы = Новый ОписаниеОповещения("ОткрытьРегистрациюКассы_ПослеРегистрации", ЭтотОбъект);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.РегистрацияКассы", ПараметрыФормы, ЭтотОбъект, , , ,ОповещениеПослеРегистрацииКассы);
КонецПроцедуры

&НаКлиенте
Процедура СкачатьКарточкуКассы(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("СерийныйНомер", Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	ВходныеПараметры.Вставить("Организация", Организация);
	
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("СкачатьКарточкуКассы_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьСкачиваниеКарточкиКассы(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодтверждениеРегистрации(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("СерийныйНомер",     Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	ОповещениеПослеПодтвержденияРегистрации = Новый ОписаниеОповещения("ОткрытьПодтверждениеРегистрации_ПослеПодтвержденияРегистрации", ЭтотОбъект);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ПодтверждениеРегистрации", ПараметрыФормы, ЭтотОбъект, , , ,ОповещениеПослеПодтвержденияРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктивациюКассы(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПодключения = Новый Структура;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьАктивациюКассы_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаПартнеров(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменаТокена(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",     Организация);
	ПараметрыФормы.Вставить("СерийныйНомер",   Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	ПараметрыФормы.Вставить("ТекущийТокенОФД", Элементы.КассыККМ.ТекущиеДанные.ТокенОФД);
	ОповещениеПослеСменыТокена = Новый ОписаниеОповещения("ОткрытьСменаТокена_ПослеСменыТокена", ЭтотОбъект);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.СменаТокенаОФД", ПараметрыФормы, ЭтотОбъект, , , ,ОповещениеПослеСменыТокена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПолучениеЧека(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("СерийныйНомер",     Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ПолучениеЧекаПоНомеру", ПараметрыФормы, ЭтотОбъект, , , ,);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокКасс(Команда)
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОбновитьСписокКасс_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаКасс(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПереводКассы(Команда)
	
	ПараметрыПодключения = Новый Структура;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьПереводКассы_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаПартнеров(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменуПартнера(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПодключения = Новый Структура;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьСменуПартнера_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеСпискаПартнеров(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюЧеков(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("СерийныйНомер",     Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ИсторияЧеков", ПараметрыФормы, ЭтотОбъект, , , ,);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюОтчетов(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",   ?(Организация=Неопределено,Неопределено, Организация));
	ПараметрыФормы.Вставить("СерийныйНомер", Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	
	ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ИсторияОтчетов", ПараметрыФормы, ЭтотОбъект, , , ,);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЕдиницыИзмерения(Команда)
	
	ПараметрыПодключения = Новый Структура;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОткрытьЕдиницыИзмерения_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеЕдиницИзмерения(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКомандРегистрации()
	
	ДоступностьЭлемента = ЗначениеЗаполнено(Организация);
	
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "РегистрацияКассы"         , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "АктивацияКассы"           , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "СменаТокена"              , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ПодтверждениеРегистрации" , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "СкачатьКарточкуКассы"     , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "КассыККМ"                 , "Доступность", ДоступностьЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьОперацийПоКассе(ДоступностьЭлемента)
	
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "АктивацияКассы"           , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "СменаТокена"              , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "ПодтверждениеРегистрации" , "Доступность", ДоступностьЭлемента);
	ИнтеграцияWebKassaКлиентСерверПереопределяемый.УстановитьСвойствоЭлементаФормы(Элементы, "СкачатьКарточкуКассы"     , "Доступность", ДоступностьЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвязанныеКассыККМ()
	
	ТаблицаКасс = РеквизитФормыВЗначение("КассыККМ");
	МассивСерийныхНомеров = ТаблицаКасс.ВыгрузитьКолонку("СерийныйНомер");
	СоответствиеКассККМСерийнымНомерам = ИнтеграцияWebKassaВызовСервера.СоответствиеКассККМСерийнымНомерам(МассивСерийныхНомеров);
	
	Для Каждого СтрокаКассы Из ТаблицаКасс Цикл
		СписокКассККМ = СоответствиеКассККМСерийнымНомерам[СтрокаКассы.СерийныйНомер];
		Если СписокКассККМ <> Неопределено Тогда
			СтрокаКассы.СвязанныеКассыККМ.ЗагрузитьЗначения(СписокКассККМ);
			СтрокаКассы.ПредставлениеКассыККМ = СтрСоединить(СписокКассККМ, ",");
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаКасс, "КассыККМ");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКассНаСервере(МассивКасс)
	
	Для Каждого Касса Из МассивКасс Цикл
		ЗаполнитьЗначенияСвойств(КассыККМ.Добавить(), Новый Структура("СерийныйНомер, ДатаОкончания, ТокенОФД",
			Касса.CashboxUniqueNumber,
			?(Касса.Свойство("ActivationEndDate"),Касса.ActivationEndDate,""),
			Касса.OfdToken,
			));
	КонецЦикла;
	ЗаполнитьСвязанныеКассыККМ();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоКассеККМ(Касса)
	
	ТаблицаКасс = РеквизитФормыВЗначение("КассыККМ");
	МассивСерийныхНомеров = Новый Массив;
	МассивСерийныхНомеров.Добавить(Касса.СерийныйНомер);
	СоответствиеКассККМСерийнымНомерам = ИнтеграцияWebKassaВызовСервера.СоответствиеКассККМСерийнымНомерам(МассивСерийныхНомеров);
	
	Для Каждого СтрокаКассы Из ТаблицаКасс Цикл
		СписокКассККМ = СоответствиеКассККМСерийнымНомерам[СтрокаКассы.СерийныйНомер];
		Если СписокКассККМ <> Неопределено Тогда
			СтрокаКассы.СвязанныеКассыККМ.ЗагрузитьЗначения(СписокКассККМ);
			СтрокаКассы.ПредставлениеКассыККМ = СтрСоединить(СписокКассККМ, ",");
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаКасс, "КассыККМ");
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьВыборКассы()
	
	Если Элементы.КассыККМ.ТекущиеДанные = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для выполнения операции необходимо выбрать кассу!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#Область ЗавершениеИнтерактивныхДействий

&НаКлиенте
Процедура ОткрытьРегистрациюКассы_ПослеРегистрации(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		ЭлементДобавлен = Ложь;
		Для каждого Строка из КассыККМ Цикл
			НайденныйЭлемент = Строка.СвязанныеКассыККМ.НайтиПоЗначению(Результат.КассаККМ);
			Если НайденныйЭлемент<>Неопределено Тогда
				Если Строка.СерийныйНомер <> Результат.СерийныйНомер Тогда
					Строка.СвязанныеКассыККМ.Удалить(НайденныйЭлемент);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		НоваяСтрока = КассыККМ.Добавить();
		НоваяСтрока.СвязанныеКассыККМ = Новый СписокЗначений;
		НоваяСтрока.СвязанныеКассыККМ.Добавить(Результат.КассаККМ);
		НоваяСтрока.ПредставлениеКассыККМ = СтрСоединить(НоваяСтрока.СвязанныеКассыККМ.ВыгрузитьЗначения(), ",");
		НоваяСтрока.СерийныйНомер = Результат.СерийныйНомер;
		УстановитьДоступностьОперацийПоКассе(КассыККМ.Количество() > 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьКарточкуКассы_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Содержание", Результат.ОбъектыJSON.Data.Content);
		ДополнительныеПараметры.Вставить("ИмяФайла",   Результат.ОбъектыJSON.Data.Name);
		
		ОповещениеПодключенияРасширенияРаботыСФайлами = Новый ОписаниеОповещения(
			"СкачатьКарточкуКассы_ПослеПодключенияРасширенияРаботыСФайлами",
			ЭтаФорма, ДополнительныеПараметры);
		
		ТекстСообщения = НСтр("ru = 'Для сохранения карточки кассы необходимо установить расширение для веб-клиента 1С:Предприятие.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.ПоказатьВопросОбУстановкеРасширения(ОповещениеПодключенияРасширенияРаботыСФайлами, ТекстСообщения, Ложь);
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При получении карточки кассы произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьКарточкуКассы_ПослеПодключенияРасширенияРаботыСФайлами(Результат, ДополнительныеПараметры) Экспорт
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Base64Значение(ДополнительныеПараметры.Содержание), УникальныйИдентификатор);
	
	Если Результат = "РасширениеПодключено" Или Результат = "ПодключениеНеТребуется" Тогда
		
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ДиалогВыбораФайла.Фильтр = "Документ PDF (*.pdf)|*.pdf";
		ДиалогВыбораФайла.Расширение = "pdf";
		
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайла, АдресХранилища));
		
		ОписаниеОповещенияПолученияФайлов = Новый ОписаниеОповещения(
			"СкачатьКарточкуКассы_СохранитьФайл",
			ЭтаФорма, ДополнительныеПараметры);
		
		НачатьПолучениеФайлов(ОписаниеОповещенияПолученияФайлов, ПолучаемыеФайлы, ДиалогВыбораФайла, Истина);
		
	Иначе
		
		ПолучитьФайл(АдресХранилища, ДополнительныеПараметры.ИмяФайла, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьКарточкуКассы_СохранитьФайл(Результат, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодтверждениеРегистрации_ПослеПодтвержденияРегистрации(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		Для Каждого Стр Из КассыККМ Цикл
			Если Стр.СерийныйНомер = Результат.СерийныйНомер Тогда
				Стр.ТокенОФД = Результат.ТокенОФД;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктивациюКассы_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Партнеры",      Новый Массив);
			ПараметрыФормы.Вставить("Организация",   ?(Организация=Неопределено,Неопределено, Организация));
			ПараметрыФормы.Вставить("ДатаОкончания", Элементы.КассыККМ.ТекущиеДанные.ДатаОкончания);
			ПараметрыФормы.Вставить("СерийныйНомер", Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
			
			Для Каждого Партнер из Результат.ОбъектыJSON.Data Цикл
				ВремСтруктура = Новый Структура("НомерПартнера, Наименование, Адрес");
				ВремСтруктура.НомерПартнера=Партнер.PartnerXin;
				ВремСтруктура.Наименование=Партнер.Name;
				ВремСтруктура.Адрес=Партнер.Address;
				ПараметрыФормы.Партнеры.Добавить(ВремСтруктура);
			КонецЦикла;
			
			ОповещениеПослеАктивацииКассы = Новый ОписаниеОповещения("ОткрытьАктивациюКассы_ПослеАктивацииКассы", ЭтотОбъект);
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.АктивацияКассы", ПараметрыФормы, ЭтотОбъект, , , ,ОповещениеПослеАктивацииКассы);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении списка партнеров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении списка партнеров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктивациюКассы_ПослеАктивацииКассы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		Для Каждого Стр Из КассыККМ Цикл
			Если Стр.СерийныйНомер = Результат.СерийныйНомер Тогда
				Стр.ДатаОкончания = Результат.ДатаОкончания;
			КонецЕсли;
		КонецЦикла;
		ТекстСообщения = НСтр("ru = 'Активация кассы прошла успешно.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Активация кассы прошла успешно. При обновление информации о кассе произошла ошибка.
		|Обновите список касс вручную.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменаТокена_ПослеСменыТокена(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		Для Каждого Стр Из КассыККМ Цикл
			Если Стр.СерийныйНомер = Результат.СерийныйНомер Тогда
				Стр.ТокенОФД = Результат.НовыйТокенОФД;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокКасс_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Если Результат.РезультатВыполнения Тогда
		КассыККМ.Очистить();
		ЗаполнитьСписокКассНаСервере(Результат.ОбъектыJSON.Data);
		УстановитьДоступностьОперацийПоКассе(КассыККМ.Количество() > 0);
		ТекстСообщения = НСтр("ru = 'Список касс успешно обновлен!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При получении списка касс произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюПоКассе(Команда)
	
	Если Не ПроверитьВыборКассы() Тогда
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация", Организация);
	ВходныеПараметры.Вставить("СерийныйНомер", Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОбновитьИнформациюПоКассе_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПолучениеИнформацииКассы(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюПоКассе_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Если Результат.РезультатВыполнения Тогда
		
		Касса = Новый Структура("ДатаОкончания, ТокенОФД, СерийныйНомер");
		Касса.СерийныйНомер = Результат.ОбъектыJSON.Data.CashboxUniqueNumber;
		Касса.ДатаОкончания = ?(Результат.ОбъектыJSON.Data.Свойство("ActivationEndDate"), Результат.ОбъектыJSON.Data.ActivationEndDate, "");
		Касса.ТокенОФД      = Результат.ОбъектыJSON.Data.OfdToken;
		
		ОбновитьИнформациюПоКассеККМ(Касса);
		
		ТекстСообщения = НСтр("ru = 'Информация успешно обновлена!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При обновлении информации произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПереводКассы_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Партнеры",      Новый Массив);
			ПараметрыФормы.Вставить("Организация",   ?(Организация=Неопределено,Неопределено, Организация));
			
			Для Каждого Партнер из Результат.ОбъектыJSON.Data Цикл
				ВремСтруктура = Новый Структура("НомерПартнера, Наименование, Адрес");
				ВремСтруктура.НомерПартнера=Партнер.PartnerXin;
				ВремСтруктура.Наименование=Партнер.Name;
				ВремСтруктура.Адрес=Партнер.Address;
				ПараметрыФормы.Партнеры.Добавить(ВремСтруктура);
			КонецЦикла;
			
			ОповещениеПослеАктивацииКассы = Новый ОписаниеОповещения("ОткрытьПереводКассы_ПослеПереводаКассы", ЭтотОбъект);
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ПереводКассы", ПараметрыФормы, ЭтотОбъект, , , ,ОповещениеПослеАктивацииКассы);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении списка партнеров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении списка партнеров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПереводКассы_ПослеПереводаКассы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		ЭлементДобавлен = Ложь;
		Для каждого Строка из КассыККМ Цикл
			НайденныйЭлемент = Строка.СвязанныеКассыККМ.НайтиПоЗначению(Результат.КассаККМ);
			Если НайденныйЭлемент<>Неопределено Тогда
				Если Строка.СерийныйНомер <> Результат.СерийныйНомер Тогда
					Строка.СвязанныеКассыККМ.Удалить(НайденныйЭлемент);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		НоваяСтрока = КассыККМ.Добавить();
		НоваяСтрока.СвязанныеКассыККМ = Новый СписокЗначений;
		НоваяСтрока.СвязанныеКассыККМ.Добавить(Результат.КассаККМ);
		НоваяСтрока.ПредставлениеКассыККМ = СтрСоединить(НоваяСтрока.СвязанныеКассыККМ.ВыгрузитьЗначения(), ",");
		НоваяСтрока.СерийныйНомер = Результат.СерийныйНомер;
		УстановитьДоступностьОперацийПоКассе(КассыККМ.Количество() > 0);
		ТекстСообщения = НСтр("ru = 'Касса успешно перенесена.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменуПартнера_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Партнеры",      Новый Массив);
			ПараметрыФормы.Вставить("Организация",   ?(Организация=Неопределено,Неопределено, Организация));
			ПараметрыФормы.Вставить("СерийныйНомер", Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
			
			Для Каждого Партнер из Результат.ОбъектыJSON.Data Цикл
				ВремСтруктура = Новый Структура("НомерПартнера, Наименование, Адрес");
				ВремСтруктура.НомерПартнера=Партнер.PartnerXin;
				ВремСтруктура.Наименование=Партнер.Name;
				ВремСтруктура.Адрес=Партнер.Address;
				ПараметрыФормы.Партнеры.Добавить(ВремСтруктура);
			КонецЦикла;
			
			ОповещениеПослеСменыПартнера = Новый ОписаниеОповещения("ОткрытьСменуПартнера_ПослеСменыПартнера", ЭтотОбъект);
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.СменаПартнера1С", ПараметрыФормы, ЭтотОбъект, , , ,ОповещениеПослеСменыПартнера);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении списка партнеров произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении списка партнеров произошла ошибка.
			                  |Дополнительное описание:
			                  |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСменуПартнера_ПослеСменыПартнера(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполнения Тогда
		ТекстСообщения = НСтр("ru = 'Смена обслуживающего партнера 1С прошла успешно.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Ошибка при смене обслуживающего партнера 1С.'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюОтчетов_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ПерваяСтраницаОтчетов", Результат.ОбъектыJSON.Data);
			ПараметрыФормы.Вставить("Организация",   ?(Организация=Неопределено,Неопределено, Организация));
			ПараметрыФормы.Вставить("СерийныйНомер", Элементы.КассыККМ.ТекущиеДанные.СерийныйНомер);
			
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ИсторияОтчетов", ПараметрыФормы, ЭтотОбъект, , , ,);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении списка отчетов произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении списка отчетов произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЕдиницыИзмерения_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		Попытка
			ПараметрыФормы =  Новый Структура();
			ПараметрыФормы.Вставить("Заголовок", "Единицы измерения сервиса");
			ПараметрыФормы.Вставить("СписокЕдиницИзмерения", Результат.ОбъектыJSON.Data);
			ПараметрыФормы.Вставить("ЕдиницыИзмерения", Истина);
			ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ПросмотрСпискаКасс", ПараметрыФормы);
		Исключение
			ТекстСообщения = НСтр("ru = 'При получении единиц измерения произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	Иначе
		ТекстСообщения = НСтр("ru = 'При получении единиц измерения произошла ошибка.
			                      |Дополнительное описание:
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

