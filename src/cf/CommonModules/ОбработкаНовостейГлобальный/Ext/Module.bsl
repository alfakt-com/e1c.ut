﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейГлобальный.
//
////////////////////////////////////////////////////////////////////////////////

#Область РегулярнаяПроверкаНовостейТребующихПрочтения

// Процедура выполняет проверку новостей (Справочник.Новости) при запуске программы
//  на предмет наличия важных и очень важных новостей, требующих особого внимания (прочтения).
//
Процедура ПроверитьВажныеНовостиСВключеннымиНапоминаниями_ПервыйЗапуск() Экспорт

	ПроверитьВажныеНовостиСВключеннымиНапоминаниями();

	ОбработкаНовостейКлиент.ПодключитьОбработчикОповещенияОВажныхИОченьВажныхНовостях();

КонецПроцедуры

// Процедура выполняет регулярную проверку новостей (Справочник.Новости)
// на предмет наличия важных и очень важных новостей, требующих особого внимания (прочтения).
//
Процедура ПроверитьВажныеНовостиСВключеннымиНапоминаниями() Экспорт

	Перем ОченьВажныеНовостиСВключеннымиНапоминаниями, ВажныеНовостиСВключеннымиНапоминаниями;

	ОбработкаНовостейВызовСервера.ПолучитьНовостиСНапоминаниями(
		ОченьВажныеНовостиСВключеннымиНапоминаниями,
		ВажныеНовостиСВключеннымиНапоминаниями);

	// При просмотре глобальных очень важных новостей, открывать каждую в отдельной форме.
	// При просмотре контекстных очень важных новостей, их можно открывать в одной форме.
	Для каждого ТекущаяНовость Из ОченьВажныеНовостиСВключеннымиНапоминаниями Цикл
		Если НЕ ТекущаяНовость.Новость.Пустая() Тогда
			// Возможна ситуация, когда очень важная новость является ссылкой или на интернет-ресурс или на раздел помощи.
			// Необходимо сбросить признак оповещения в форме новости сразу, т.к. по-другому сбросить этот признак не получится.
			ФормаНовости = ОбработкаНовостейКлиент.ПоказатьНовость(
				ТекущаяНовость.Новость, // НовостьСсылка
				, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно, т.к. неизвестно что будет за владелец
				       // и блокировать первое попавшееся окно неправильно.
				, // ФормаВладелец
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Автопроверка новостей: %1'"),
					ТекущаяНовость.НовостьУникальныйИдентификатор)); // Отдельная уникальность, не зависит от новостей, открытых из формы списка
		КонецЕсли;
	КонецЦикла;

	Если ВажныеНовостиСВключеннымиНапоминаниями.Количество() > 0 Тогда
		ОбработкаНовостейКлиент.НачатьПоследовательныйПоказВажныхНовостей(ВажныеНовостиСВключеннымиНапоминаниями);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область КонтекстныеНовости

// Процедура запускает оптимизацию кэша контекстных новостей
//  (глобальной переменной ПараметрыПриложения["ИнтернетПоддержкаПользователей.Новости.КэшКонтекстныхНовостей"])).
//
Процедура ОптимизацияВременногоХранилищаКонтекстныхНовостей() Экспорт

	ОбработкаНовостейКлиент.ОптимизацияКонтекстныхНовостейВКэшеПриложения();

КонецПроцедуры

#КонецОбласти