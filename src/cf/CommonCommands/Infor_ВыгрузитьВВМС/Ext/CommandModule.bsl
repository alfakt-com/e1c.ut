﻿&НаСервере
Процедура ВыполнитьРегистрациюОбъекта(Источник)
	Infor_Интеграция.ВыполнитьРегистрациюОбъекта(Источник);
КонецПроцедуры

&НаСервере
Функция _ПолучитьЗначениеСвойстваСправочника(Св, Ном)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураДополнительныеРеквизиты.Значение
	               |ИЗ
	               |	Справочник.Номенклатура.ДополнительныеРеквизиты КАК НоменклатураДополнительныеРеквизиты
	               |ГДЕ
	               |	НоменклатураДополнительныеРеквизиты.Ссылка = &Ссылка
	               |	И НоменклатураДополнительныеРеквизиты.Свойство.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Ссылка", Ном);
	Запрос.УстановитьПараметр("Наименование", Св);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Значение;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция _ОбъектВыгружен(Св)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Infor_ОчередьВыгрузки.Объект
	               |ИЗ
	               |	РегистрСведений.Infor_ОчередьВыгрузки КАК Infor_ОчередьВыгрузки
	               |ГДЕ
	               |	Infor_ОчередьВыгрузки.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", Св);
	Результат = Запрос.Выполнить();
	Пока Результат.Пустой() Цикл
		Возврат Ложь;
	КонецЦикла;
	Возврат Истина;
КонецФункции

&НаСервере
Функция ПроверитьТовары(Источник)
	Ошибка = Ложь;
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаказКлиента") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ПеремещениеТоваров") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Для Каждого СтрокаТовары Из Источник.Товары Цикл
			Ошибка = ?(Ошибка, Ошибка, ПроверкаТовара(СтрокаТовары.Номенклатура));
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("СправочникСсылка.Номенклатура") Тогда
		Ошибка = ?(Ошибка, Ошибка, ПроверкаТовара(Источник));
	КонецЕсли;
	Возврат Ошибка; 
КонецФункции

&НаСервере
Функция МажноВыгрузитьБезРезерва(Источник)
	Ошибка = Ложь;
	Если Infor_Интеграция.ПолучитьОбщуюНастройку("ВЫГРУЗКА", "КонтрольРезерваКнопка") Тогда
		Ошибка = Истина;
	КонецЕсли;
	
	Возврат Ошибка; 
КонецФункции

&НаСервере
Функция ПроверитьРезервы(Источник)
	Ошибка = Ложь;
	Если Infor_Интеграция.ПолучитьОбщуюНастройку("ВЫГРУЗКА", "КонтрольРезерва") Тогда
		ТабОст = Новый ТаблицаЗначений;
		ТабОст.Колонки.Добавить("Номенклатура");
		ТабОст.Колонки.Добавить("Количество");
		
		Для Каждого СтрТовары Из Источник.Товары Цикл
			НС = ТабОст.Добавить();
			НС.Номенклатура = СтрТовары.Номенклатура;
			НС.Количество = СтрТовары.Количество;
		КонецЦикла;
		
		ТабОст.Свернуть("Номенклатура", "Количество");
		ТабРезервов = Infor_Интеграция._ПолучитьРезерв(Источник.Склад, ТабОст.ВыгрузитьКолонку("Номенклатура"));
		ТабОстаток = Infor_Интеграция._ПолучитьОстаток(Источник.Склад, ТабОст.ВыгрузитьКолонку("Номенклатура"));
		
		Для Каждого СтрТабОстатка Из ТабОстаток Цикл
			ПлощадьЕдиницы = СтрТабОстатка.Номенклатура.ПлощадьЕдиницы;
			КолвоВСтандУпаковке = СтрТабОстатка.Номенклатура.КолвоВСтандУпаковке;
			Если ЗначениеЗаполнено(ПлощадьЕдиницы) И ЗначениеЗаполнено(КолвоВСтандУпаковке) Тогда
				Количество = СтрТабОстатка.КоличествоОстаток;
				КоличествоВЯщ = Окр(КолвоВСтандУпаковке / ПлощадьЕдиницы);
				КоличествоЯщ = Цел(Количество / КоличествоВЯщ);
				КоличествоШт = Количество - КоличествоЯщ * КоличествоВЯщ;
				СтрТабОстатка.КоличествоОстаток = КоличествоЯщ * КолвоВСтандУпаковке + КоличествоШт * ПлощадьЕдиницы;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого СтрТабОстатка Из ТабОст Цикл
			РезОст = ТабОстаток.Найти(СтрТабОстатка.Номенклатура, "Номенклатура");
			РезРез = ТабРезервов.Найти(СтрТабОстатка.Номенклатура, "Номенклатура");
			
			Ост = 0;
			
			Если Не РезОст = Неопределено Тогда
				Ост = РезОст.КоличествоОстаток;
			КонецЕсли;
			
			Рез = 0;
			
			Если Не РезРез = Неопределено Тогда
				Рез = РезРез.КоличествоОстаток;
			КонецЕсли;
			
			Если (Ост - Рез - СтрТабОстатка.Количество) < 0 Тогда
				Сообщить("Товара " + СтрТабОстатка.Номенклатура + " не хватает для заказа. Остаток в ВМС " + Строка(Ост) + ". Резерв в 1С " + Строка(Рез) + ". В заказе " + Строка(СтрТабОстатка.Количество), СтатусСообщения.Внимание);
				
				Ошибка = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Ошибка; 
КонецФункции

&НаСервере
Функция ПроверитьВыгрузка(Источник)
	Ошибка = Ложь;
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаказКлиента") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ПеремещениеТоваров") ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Если _ОбъектВыгружен(Источник) Тогда
			Сообщить("Объект " + Источник + " уже выгружался.", СтатусСообщения.Внимание);
			Ошибка = Истина;
		//ТТ Запрет на выгрузку в ВМС перемещения без проведения
		ИначеЕсли ТипЗнч(Источник) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			Если НЕ Источник.Проведен Тогда
				Сообщить("Объект " + Источник + " НЕ проведен.", СтатусСообщения.Внимание);
				Ошибка = Истина;
			КонецЕсли;
		//ТТ Запрет на выгрузку в ВМС возврата проведенного. Наоборот тут
		ИначеЕсли ТипЗнч(Источник) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
			Если Источник.Проведен Тогда
				Сообщить("Объект " + Источник + " проведен. ОТМЕНИТЕ ПРОВЕДЕНИЕ ДЛЯ ВЫГРУЗКИ В WMS", СтатусСообщения.Внимание);
				Ошибка = Истина;
			КонецЕсли;
		//ТТ-	
		КонецЕсли;
	КонецЕсли;
	Возврат Ошибка; 
КонецФункции

&НаСервере
Функция ЕстьПриход(Источник)
	Ошибка = Истина;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПриобретениеТоваровУслуг.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	               |ГДЕ
	               |	ПриобретениеТоваровУслуг.Проведен = ИСТИНА
	               |	И ПриобретениеТоваровУслуг.ЗаказПоставщику = &ЗаказПоставщику";
	Запрос.УстановитьПараметр("ЗаказПоставщику", Источник);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Сообщить("Нельзя выгружать заказ " + Источник + " без создания поступления.", СтатусСообщения.Внимание);
		Ошибка = Ложь;
	КонецЕсли;
	
	Возврат Ошибка; 
КонецФункции

&НаСервере
Функция ПроверкаТовара(Товар)
	Ошибка = Ложь;
	РезГруппа = СокрЛП(ВРег(_ПолучитьЗначениеСвойстваСправочника("Группа товара", Товар.Ссылка)));
	Если РезГруппа = """КАФЕЛЬ""" Тогда
		Если НЕ ЗначениеЗаполнено(Товар.Ссылка.ПлощадьЕдиницы) Тогда
			Сообщить("Для товара " + Товар.Ссылка.Наименование + " не заполнен атрибут площадь единицы.", СтатусСообщения.Внимание);
			Ошибка = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Товар.Ссылка.КолвоВСтандУпаковке) Тогда
			Сообщить("Для товара " + Товар.Ссылка.Наименование + " не заполнен атрибут количество в стандартной упаковке.", СтатусСообщения.Внимание);
			Ошибка = Истина;
		КонецЕсли;
	Иначе
		Если НЕ ЗначениеЗаполнено(РезГруппа) Тогда
			Сообщить("У товара " + Товар.Ссылка.Наименование + " не заполнен атрибут группа товара.", СтатусСообщения.Внимание);
			Ошибка = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Ошибка; 
КонецФункции

&НаСервере
Функция ПроверкаСсылки(Сс)
	Ошибка = Ложь;
	Если Сс.Ссылка.Пустая() Тогда
		Ошибка = Истина;
	КонецЕсли;
	Возврат Ошибка; 
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ПроверитьТовары(ПараметрКоманды) Тогда
		Сообщить("Объект не выгружен.", СтатусСообщения.Важное);
	Иначе
		Если ПроверитьВыгрузка(ПараметрКоманды) Тогда
			Сообщить("Объект не выгружен.", СтатусСообщения.Важное);
		Иначе
			Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
				Если ЕстьПриход(ПараметрКоманды) Тогда
					ВыполнитьРегистрациюОбъекта(ПараметрКоманды);
					Сообщить("Объект успешно выгружен.", СтатусСообщения.Важное);
				Иначе
					Сообщить("Объект не выгружен.", СтатусСообщения.Важное);
				КонецЕсли;
			ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
				Если ПроверитьРезервы(ПараметрКоманды) Тогда
					Сообщить("Объект не выгружен.", СтатусСообщения.Важное);
				Иначе
					Если МажноВыгрузитьБезРезерва(ПараметрКоманды) Тогда
						ВыполнитьРегистрациюОбъекта(ПараметрКоманды);
						Сообщить("Объект успешно выгружен.", СтатусСообщения.Важное);
					Иначе
						Сообщить("Объект не выгружен.", СтатусСообщения.Важное);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ВыполнитьРегистрациюОбъекта(ПараметрКоманды);
				Сообщить("Объект успешно выгружен.", СтатусСообщения.Важное);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
