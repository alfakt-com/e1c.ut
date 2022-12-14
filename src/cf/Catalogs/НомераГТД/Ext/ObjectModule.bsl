#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если Не ПометкаУдаления Тогда
		ПроверитьДублиЭлемента(Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Наименование = СформироватьАвтоНаименование();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПорядковыйНомерТовара) Тогда
		ПорядковыйНомерТовара = НомерСтрокиГТД;		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СпособПроисхождения = Перечисления.СпособыПроисхожденияТоваров.СТ1 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Код");
		Если Не ЗначениеЗаполнено(Код) Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Номер сертификата"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"Код",
			,
			Отказ);
		КонецЕсли;
	ИначеЕсли СпособПроисхождения = Перечисления.СпособыПроисхожденияТоваров.ТС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Код");
		Если Не ЗначениеЗаполнено(Код) Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Номер заявления"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"Код",
			,
			Отказ);
		КонецЕсли;
	ИначеЕсли СпособПроисхождения = Перечисления.СпособыПроисхожденияТоваров.ЕТТЕАЭС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтранаПроисхождения");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ПроверитьДублиЭлемента(Отказ)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	НомераГТД.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НомераГТД КАК НомераГТД
	|ГДЕ
	|	НомераГТД.Ссылка <> &Ссылка
	|	И НЕ НомераГТД.ПометкаУдаления
	|	И НомераГТД.Код = &Код
	|	И НомераГТД.КодТНВЭД = &КодТНВЭД
	|	И НомераГТД.НомерСтрокиГТД = &НомерСтрокиГТД
	|	И НомераГТД.НаименованиеТовара = &НаименованиеТовара
	|	И НомераГТД.СтранаПроисхождения = &СтранаПроисхождения
	|	И НомераГТД.СпособПроисхождения = &СпособПроисхождения
	|	И НомераГТД.ПризнакПроисхождения = &ПризнакПроисхождения
	|	И НомераГТД.РегистрационныйНомерЭСФ = &РегистрационныйНомерЭСФ	
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Код", Код);
	Запрос.УстановитьПараметр("СтранаПроисхождения", СтранаПроисхождения);
	Запрос.УстановитьПараметр("КодТНВЭД", КодТНВЭД);
	Запрос.УстановитьПараметр("НомерСтрокиГТД", НомерСтрокиГТД);
	Запрос.УстановитьПараметр("НаименованиеТовара", НаименованиеТовара);
	Запрос.УстановитьПараметр("СпособПроисхождения", СпособПроисхождения);
	Запрос.УстановитьПараметр("ПризнакПроисхождения", ПризнакПроисхождения);
	Запрос.УстановитьПараметр("РегистрационныйНомерЭСФ", РегистрационныйНомерЭСФ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Аналогичный номер ГТД уже существует: %1'"),
			Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			, // Поле
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьАвтоНаименование()
	
	Если ЗначениеЗаполнено(СтранаПроисхождения) И ЗначениеЗаполнено(НомерСтрокиГТД) И ЗначениеЗаполнено(КодТНВЭД) Тогда
		Возврат СокрЛП(Код) + "/" + Формат(НомерСтрокиГТД, "ЧГ=0") + "/" + СтранаПроисхождения + "/" + СокрЛП(КодТНВЭД) + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтранаПроисхождения) И ЗначениеЗаполнено(НомерСтрокиГТД) Тогда
		Возврат СокрЛП(Код) + "/" + Формат(НомерСтрокиГТД, "ЧГ=0") + "/" + СтранаПроисхождения + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтранаПроисхождения) И ЗначениеЗаполнено(КодТНВЭД) Тогда
		Возврат СокрЛП(Код) + "/" + СтранаПроисхождения + "/" + СокрЛП(КодТНВЭД) + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерСтрокиГТД) И ЗначениеЗаполнено(КодТНВЭД) Тогда
		Возврат СокрЛП(Код) + "/" + Формат(НомерСтрокиГТД, "ЧГ=0") + "/" + СокрЛП(КодТНВЭД) + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерСтрокиГТД) Тогда
		Возврат СокрЛП(Код) + "/" + Формат(НомерСтрокиГТД, "ЧГ=0") + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодТНВЭД) Тогда
		Возврат СокрЛП(Код) + "/" + СокрЛП(КодТНВЭД) + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	КонецЕсли;
	
	Возврат СокрЛП(Код) + "/" + СпособПроисхождения + "/" + ПризнакПроисхождения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
