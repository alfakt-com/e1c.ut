﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	// Пропускаем обработку, чтобы гарантировать получение формы объекта при передаче параметра "АвтоТест".
	Если ДанныеЗаполнения = "АвтоТест" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("КассоваяКнига")
			И ДанныеЗаполнения.КассоваяКнига <> "<Основная кассовая книга организации>" Тогда
			ЕстьВладелец = Истина;
			ДанныеЗаполнения.Вставить("Владелец", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассоваяКнига, "Владелец"));
			ДанныеЗаполнения.Вставить("ЭтоКассаОбособленногоПодразделения", 1);
			ДанныеЗаполнения.Вставить("ВалютаДенежныхСредств", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассоваяКнига, "ВалютаДенежныхСредств"));
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Организация") Тогда
			ДанныеЗаполнения.Вставить("Владелец", ДанныеЗаполнения.Организация);
		КонецЕсли;
		Если НЕ ДанныеЗаполнения.Свойство("ВалютаДенежныхСредств") Тогда	
			ВалютаДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаДенежныхСредств);
		КонецЕсли;
	КонецЕсли;
	
	ДенежныеСредстваСервер.ОбработкаЗаполненияСправочников(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Не ЭтоКассаОбособленногоПодразделения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КассоваяКнига");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс") Тогда
		УстановитьПривилегированныйРежим(Истина);
 		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Кассы.Ссылка
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|ГДЕ
		|	Кассы.Ссылка <> &Ссылка
		|	И НЕ Кассы.ПометкаУдаления");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() И Не ЭтоБазовая Тогда
			Константы.ИспользоватьНесколькоКасс.Установить(Истина);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Справочники.КлючиРеестраДокументов.СоздатьОбновитьКлючРеестра(ЭтотОбъект, ДополнительныеСвойства.ЭтоНовый);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
