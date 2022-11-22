﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Владелец.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;

	Если НЕ Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Владелец) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Данная операция доступна только ответственному за ведение папок для данной учетной записи'"),
			Ссылка,,,Отказ);
	ИначеЕсли ПредопределеннаяПапка И ПометкаУдаления И (НЕ Владелец.ПометкаУдаления) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru = 'Нельзя установить пометку удаления для предопределенной папки'"),
		Ссылка,,,Отказ);
	ИначеЕсли ПредопределеннаяПапка И (Не Родитель.Пустая()) Тогда
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru = 'Нельзя переместить предопределенную папку в другую папку'"),
		Ссылка,,,Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Родитель",ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект.Ссылка,"Родитель"));
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПредопределеннаяПапка = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Родитель") И Родитель <> ДополнительныеСвойства.Родитель Тогда
		Если НЕ ДополнительныеСвойства.Свойство("ОбработаноИзменениеРодителя") Тогда
			Взаимодействия.УстановитьРодителяУПапки(Ссылка,Родитель,Истина)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли