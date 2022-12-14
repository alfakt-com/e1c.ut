#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	

	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") 
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ПлательщикЕНВД") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходовЕНВД");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	Если Не ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ПометкаУдаленияДоЗаписи", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления"));
	Иначе
		ДополнительныеСвойства.Вставить("ПометкаУдаленияДоЗаписи", Ложь);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	ОбщегоНазначенияУТ.УстановитьПометкуУдаленияКлюча("Справочник.ВидыЗапасов",
														Ссылка,
														ДополнительныеСвойства,
														ПометкаУдаления,
														ЭтоГруппа);
	
	ОбщегоНазначенияУТ.УстановитьПометкуУдаленияКлюча("Справочник.КлючиАналитикиУчетаПартий",
														Ссылка,
														ДополнительныеСвойства,
														ПометкаУдаления,
														ЭтоГруппа);
														
КонецПроцедуры

#КонецОбласти

#КонецЕсли
