
Процедура ПроверитьВозможностьПечатиДляПользователя(МассивОбъектов, ИменаМакетов, Параметры, Отказ) Экспорт
	ТаблицаФормируемыхПечатныхФорм = Новый ТаблицаЗначений;
	ТаблицаФормируемыхПечатныхФорм.Колонки.Добавить("СсылкаНаДокумент");
	ТаблицаФормируемыхПечатныхФорм.Колонки.Добавить("ИмяМакета");
	ТаблицаФормируемыхПечатныхФорм.Колонки.Добавить("ВнешняяПечатнаяФорма");
	ТаблицаФормируемыхПечатныхФорм.Колонки.Добавить("КомандаВнешнейПечатнойФормы");
	Если Не Параметры = Неопределено И ЗначениеЗаполнено(Параметры.ИсточникДанных) Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			Для Каждого ОбъектНазначения Из Параметры.ПараметрыИсточника.ОбъектыНазначения Цикл
				Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ОбъектНазначения)) Тогда
					Если ПроверитьПравоНаФормированиеПечатнойФормы(ОбъектНазначения, "", Параметры.ИсточникДанных, Параметры.ПараметрыИсточника.ИдентификаторКоманды) Тогда
						НоваяСтрока = ТаблицаФормируемыхПечатныхФорм.Добавить();
						НоваяСтрока.СсылкаНаДокумент = ОбъектНазначения;
						НоваяСтрока.ИмяМакета = "";
						НоваяСтрока.ВнешняяПечатнаяФорма = Параметры.ИсточникДанных;
						НоваяСтрока.КомандаВнешнейПечатнойФормы = Параметры.ПараметрыИсточника.ИдентификаторКоманды;
					Иначе
						Отказ = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если ТипЗнч(ИменаМакетов) = Тип("Строка") Тогда
			МассивИменМакетов = СтрРазделить(ИменаМакетов, ",");
		Иначе
			МассивИменМакетов = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ИменаМакетов);
		КонецЕсли;
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			Для Каждого ОбъектНазначения Из МассивОбъектов Цикл
				Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ОбъектНазначения)) Тогда
					Если ПроверитьПравоНаФормированиеПечатнойФормы(ОбъектНазначения, ИмяМакета, Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка(), "") Тогда
						НоваяСтрока = ТаблицаФормируемыхПечатныхФорм.Добавить();
						НоваяСтрока.СсылкаНаДокумент = ОбъектНазначения;
						НоваяСтрока.ИмяМакета = ИмяМакета;
						НоваяСтрока.ВнешняяПечатнаяФорма = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
						НоваяСтрока.КомандаВнешнейПечатнойФормы = "";
					Иначе
						Отказ = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	Если Не Отказ Тогда
		ЗарегистрироватьФормированиеПечатнойФормы(ТаблицаФормируемыхПечатныхФорм);
	КонецЕсли;
КонецПроцедуры

Функция ПроверитьПравоНаФормированиеПечатнойФормы(СсылкаНаДокумент, ИмяМакета, ВнешняяПечатнаяФорма, КомандаВнешнейПечатнойФормы)
	Результат = Истина;
	Если Не РольДоступна("ПолныеПрава") И Константы.swОднократноеФормированиеПечатныхФорм.Получить() = Истина Тогда
		Запрос = Новый Запрос;
		Текст = "ВЫБРАТЬ
		        |	Данные.Дата КАК Дата,
		        |	Данные.Пользователь
		        |ИЗ
		        |	РегистрСведений.swСформированныеПечатныеФормы КАК Данные
		        |ГДЕ
		        |	Данные.СсылкаНаДокумент = &СсылкаНаДокумент
		        |	И Данные.ИмяМакета = &ИмяМакета
		        |	И Данные.ВнешняяПечатнаяФорма = &ВнешняяПечатнаяФорма
		        |	И Данные.КомандаВнешнейПечатнойФормы = &КомандаВнешнейПечатнойФормы
		        |
		        |УПОРЯДОЧИТЬ ПО
		        |	Дата";
		Запрос.Текст = Текст;
		Запрос.УстановитьПараметр("СсылкаНаДокумент", СсылкаНаДокумент);
		Запрос.УстановитьПараметр("ИмяМакета", ИмяМакета);
		Запрос.УстановитьПараметр("ВнешняяПечатнаяФорма", ВнешняяПечатнаяФорма);
		Запрос.УстановитьПараметр("КомандаВнешнейПечатнойФормы", КомандаВнешнейПечатнойФормы);
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Результат = Ложь;
			Если ЗначениеЗаполнено(ИмяМакета) Тогда
				Сообщить("Внимание! Печатная форма '" + ИмяМакета + "' документа '" + СсылкаНаДокумент + "' уже была сформирована ранее:");
			Иначе
				Сообщить("Внимание! Внешняя печатная форма '" + ВнешняяПечатнаяФорма + "' документа '" + СсылкаНаДокумент + "' по команде '" + КомандаВнешнейПечатнойФормы + "' уже была сформирована ранее:");
			КонецЕсли;
			Пока Выборка.Следующий() Цикл                                            
				Сообщить("    Дата формирования: " + Выборка.Дата + ", пользователь: '" + Выборка.Пользователь);
			КонецЦикла;
			Сообщить("Она не может быть вами сформирована повторно. Если вам действительно нужно ее сформировать, то обратитесь к администратору базу данных.");
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Процедура ЗарегистрироватьФормированиеПечатнойФормы(ТаблицаФормируемыхПечатныхФорм)
	Для Каждого СтрокаТаблицы Из ТаблицаФормируемыхПечатныхФорм Цикл
		МенеджерЗаписи = РегистрыСведений.swСформированныеПечатныеФормы.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.СсылкаНаДокумент = СтрокаТаблицы.СсылкаНаДокумент;
		МенеджерЗаписи.ИмяМакета = СтрокаТаблицы.ИмяМакета;
		МенеджерЗаписи.ВнешняяПечатнаяФорма = СтрокаТаблицы.ВнешняяПечатнаяФорма;
		МенеджерЗаписи.КомандаВнешнейПечатнойФормы = СтрокаТаблицы.КомандаВнешнейПечатнойФормы;
		МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		МенеджерЗаписи.Дата = ТекущаяДата();
		МенеджерЗаписи.Записать();
	КонецЦикла;
КонецПроцедуры
