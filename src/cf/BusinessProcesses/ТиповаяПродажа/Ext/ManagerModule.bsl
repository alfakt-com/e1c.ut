﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает специализированную форму задачи
//
// Параметры:
//  ЗадачаСсылка         - ЗадачаСсылка - задача, для которой получается форма
//  ТочкаМаршрутаСсылка  - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута, для которой получается форма.
//
// Возвращаемое значение:
//   УправляемаяФорма   - специализированная форма выполнения задачи.
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаСсылка) Экспорт

	Если ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПервичныйКонтакт
	 ИЛИ ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Презентация Тогда
		ИмяФормы = "БизнесПроцесс.ТиповаяПродажа.Форма.Взаимодействия";
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.КвалификацияКлиента Тогда
		ИмяФормы = "БизнесПроцесс.ТиповаяПродажа.Форма.Клиент";
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПодготовкаПредложения
	      Или ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Торг Тогда
		ИмяФормы = "БизнесПроцесс.ТиповаяПродажа.Форма.КоммерческоеПредложение";
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФормированиеЗаказа Тогда
		ИмяФормы = "БизнесПроцесс.ТиповаяПродажа.Форма.ЗаказКлиента";
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Торг
		  Или ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПодтверждениеОбязательств
		  Или ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.КонтрольВыполненияОбязательств
		  Или ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФиксацияРезультатовВыиграннойСделки
		  Или ТочкаМаршрутаСсылка = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФиксацияРезультатовПроиграннойСделки Тогда
		ИмяФормы = "БизнесПроцесс.ТиповаяПродажа.Форма.Документы";
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Ключ", ЗадачаСсылка);
	
	Возврат Новый Структура(
		"ПараметрыФормы, ИмяФормы", ПараметрыФормы, ИмяФормы);

КонецФункции

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка.ЗадачаИсполнителя - задача, для которой выполняется обработка 
//   ТочкаМаршрутаСсылка - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт

КонецПроцедуры

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка       - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) + БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	
КонецПроцедуры

// Получить описание задачи процесса.
//
// Параметры:
//  ТочкаМаршрутаБизнесПроцесса  - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута для которой 
//                                 возвращается описание.
//
// Возвращаемое значение:
//   Строка   - описание для точки маршрута.
//
Функция ОписаниеТочки(ТочкаМаршрутаБизнесПроцесса) Экспорт

	Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПервичныйКонтакт Тогда
		Возврат ?(ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент"), "- " + НСтр("ru='запланируйте и проведите первичный контакт (обязательный);'") + Символы.ПС
			,"") +  "- " +  НСтр("ru='выясните товарные категории и номенклатуру, которые могут заинтересовать клиента;
			|- выясните данные о контактных лицах, потенциально заинтересованных в покупке предлагаемой номенклатуры.'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.КвалификацияКлиента Тогда
		Возврат НСтр(
			"- " + "ru='соберите и проанализируйте информацию о клиенте;
			|- заполните набор дополнительных свойств клиента;
			|- определите рамки работы по сделке - выберите соглашение (обязательный);
			|- выясните и зафиксируйте связи клиента с другими партнерами.'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПодготовкаПредложения Тогда
		Возврат НСтр(
			 "- " + "ru='подготовьте и отошлите коммерческое предложение (обязательный);
			|- узнайте реакцию покупателя;
			|- выясните контактное лицо, имеющее полномочия принять решение о закупке;
			|- договоритесь о сроках и месте проведения демонстрации, запланируйте встречу.'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Презентация Тогда
		Возврат НСтр(
			"- " + "ru='подготовьте демонстрационные материалы и оборудование;
			|- подготовьте участие технических специалистов;
			|- проведите демонстрацию;
			|- выясните реакцию покупателя и решателя;
			|- выясните возможные взаимосвязи клиента, его контактных лиц;
			|- выясните и зарегистрируйте потенциальных конкурентов в списке участников сделки.'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Торг Тогда
		Возврат НСтр(
			"- " + "ru='проанализируйте окружение сделки, дополните список ее участников влиятелями и решателем;
			|- проведите необходимую работу с влиятелями и решателем, предложите доступные скидки;
			|- согласуйте предложение с клиентом.'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФормированиеЗаказа Тогда
		Возврат НСтр(
			"- " + "ru='уточните юридическое лицо партнера (обязательный);
			|- сформируйте заказ клиента (обязательный).'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПодтверждениеОбязательств Тогда
		Возврат НСтр(
			"- " + "ru='при необходимости выставите счет на оплату и дождитесь поступления авансового платежа или
			| произведите отгрузку (обязательный).'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.КонтрольВыполненияОбязательств Тогда
		Возврат НСтр(
			"- " + "ru='проконтролируйте поступление платежей (обязательный);
			|- проконтролируйте отгрузки и доставки (обязательный).'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФиксацияРезультатовВыиграннойСделки Тогда
		Возврат НСтр(
			"- " + "ru='проконтролируйте комплектность первичных документов;
			|- проконтролируйте полноту и корректность внесенной по сделке информации;
			|- проконтролируйте завершение платежей и поставок;
			|- проконтролируйте комплектность первичных документов.'");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФиксацияРезультатовПроиграннойСделки Тогда
		Возврат НСтр(
			"- " + "ru='проконтролируйте отсутствие обязательств по сделке;
			|- укажите причину проигрыша сделки (обязательный);
			|- проконтролируйте полноту и корректность внесенной по сделке информации.'");
	КонецЕсли;

КонецФункции

// Получить типовой срок исполнения задачи в днях.
//
// Параметры:
//  ТочкаМаршрутаБизнесПроцесса  - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута для которой 
//                                 возвращается типовой срок исполнения.
//
// Возвращаемое значение:
//   Число   - типовой срок исполнения для точки маршрута.
//
Функция СрокИсполнения(ТочкаМаршрутаБизнесПроцесса) Экспорт

	Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПервичныйКонтакт Тогда
		Возврат 2;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.КвалификацияКлиента Тогда
		Возврат 2;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПодготовкаПредложения Тогда
		Возврат 3;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Презентация Тогда
		Возврат 5;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.Торг Тогда
		Возврат 7;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФормированиеЗаказа Тогда
		Возврат 1;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ПодтверждениеОбязательств Тогда
		Возврат 2;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.КонтрольВыполненияОбязательств Тогда
		Возврат 14;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФиксацияРезультатовВыиграннойСделки Тогда
		Возврат 1;
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.ТиповаяПродажа.ТочкиМаршрута.ФиксацияРезультатовПроиграннойСделки Тогда
		Возврат 1;
	КонецЕсли;

КонецФункции

// Возвращает список этапов процесса при его плановом выполнении
//
// Возвращаемое значение:
//   Массив   - содержит список этапов бизнес-процесса.
//
Функция СписокЭтапов() Экспорт

	мЭтапы = Новый Массив;
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.ПервичныйКонтакт);
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.КвалификацияКлиента);
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.ФормированиеПредложения);
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.Презентация);
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.СогласованиеУсловий);
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.ПодготовкаКВыполнениюОбязательств);
	мЭтапы.Добавить(Справочники.СостоянияПроцессов.ВыполнениеОбязательств);

	Возврат мЭтапы;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = НСтр("ru = '%1, %2 перенаправил(а) задачу:
		|%3");
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат,
	              ЗадачаСсылка.ДатаИсполнения,
	              ЗадачаСсылка.Исполнитель,
	              Комментарий);
	
	Результат = Результат + Символы.ПС;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли
