﻿
Функция ШаблоныAvailable(Запрос)
	СтатусОтвета = 200;
	
	Попытка
		Токен = Запрос.Заголовки.Получить("Authorization");
		Если Токен <> "VSj90ehR2FD08saZye4HVHHeFukYkW" Тогда
			ВызватьИсключение "Не верный токен";
		КонецЕсли;
		
		//Получаем номер телефона
		ОтносительныйURL = нрег(Запрос.ОтносительныйURL);
		НомерКлиента = СтрЗаменить(ОтносительныйURL,"/available/","");
		
		//Запрос данных по номеру телефона
		Бонусы = ПолучитьДанныеПоТелефону(НомерКлиента);
		
		Если Бонусы.Количество() = 0 Тогда
			СтатусОтвета = 404;
			XMLСтрока = "";
		Иначе
			//XML
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.УстановитьСтроку();
			ЗаписьXML.ЗаписатьОбъявлениеXML();
			
			//Запись данных в XML
			ЗаписатьЗначение(Бонусы,ЗаписьXML);
			XMLСтрока = ЗаписьXML.Закрыть();
		КонецЕсли;
		
	Исключение
		
		СтатусОтвета = 500;
		
	КонецПопытки;
	
	
	Ответ = Новый HTTPСервисОтвет(СтатусОтвета);
	Ответ.Заголовки["Content-Type"] = "text/xml; charset=utf-8";
	Ответ.УстановитьТелоИзСтроки(XMLСтрока);	
	Возврат Ответ;
КонецФункции

Функция ПолучитьДанныеПоТелефону(НомерКлиента)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	bon_ПартииБонусовНаСчетахОстаткиИОбороты.БуферКонечныйОстаток КАК future,
	               |	bon_ПартииБонусовНаСчетахОстаткиИОбороты.ОстатокКонечныйОстаток КАК available,
	               |	bon_ПартииБонусовНаСчетахОстаткиИОбороты.ОстатокРасход КАК used
	               |ИЗ
	               |	РегистрНакопления.bon_ПартииБонусовНаСчетах.ОстаткиИОбороты(, , , , ) КАК bon_ПартииБонусовНаСчетахОстаткиИОбороты
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.bon_ТелефоныНомОбъектов КАК bon_ТелефоныНомОбъектов
	               |		ПО bon_ПартииБонусовНаСчетахОстаткиИОбороты.НоминальныйОбъект.Держатель = bon_ТелефоныНомОбъектов.Контрагенты
	               |ГДЕ
	               |	bon_ТелефоныНомОбъектов.Сотовый = &Сотовый";
	Запрос.УстановитьПараметр("Сотовый",НомерКлиента);
	
	Бонусы = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовЭлемент = Новый Структура("phone, summary");
		НовЭлемент.phone = НомерКлиента;
		
		СуммаБонусов 	= 	Новый Структура("available,future,used");
		СуммаБонусов.available = ФорматироватьЧисло(Выборка.available);
		СуммаБонусов.future = ФорматироватьЧисло(Выборка.future);
		СуммаБонусов.used = ФорматироватьЧисло(Выборка.used);
		НовЭлемент.summary = СуммаБонусов;
		Бонусы.Добавить(НовЭлемент,"bonuses");
	КонецЦикла;
	
	Возврат Бонусы;
КонецФункции

Процедура XMLСтруктура(ТекЭлемент,ЗаписьXML)
	Для Каждого ТекСвойство Из ТекЭлемент Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента(ТекСвойство.Ключ);
		ЗаписатьЗначение(ТекСвойство.Значение,ЗаписьXML);
		ЗаписьXML.ЗаписатьКонецЭлемента(); // КлючДоп
	КонецЦикла;
КонецПроцедуры

Процедура XMLСписокЗначений(СпЗначений,ЗаписьXML)
	Для Каждого ТекЭлемент Из СпЗначений Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента(ТекЭлемент.Представление);
		ЗаписатьЗначение(ТекЭлемент.Значение,ЗаписьXML);
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Ключ
	КонецЦикла;
КонецПроцедуры

Процедура ЗаписатьЗначение(Значение,ЗаписьXML)
	Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		XMLСписокЗначений(Значение,ЗаписьXML);
	ИначеЕсли ТипЗнч(Значение) = Тип("Структура") Тогда
		XMLСтруктура(Значение,ЗаписьXML);
	Иначе
		ЗаписьXML.ЗаписатьТекст(Строка(Значение));
	КонецЕсли;
КонецПроцедуры

Функция ФорматироватьЧисло(ИсходноеЧисло)
	ФорматированноеЧисло = ИсходноеЧисло;
	ФорматированноеЧисло = СтрЗаменить(ФорматированноеЧисло,Символ(160),"");
	ФорматированноеЧисло = СтрЗаменить(ФорматированноеЧисло,",",".");
	Возврат ФорматированноеЧисло;
КонецФункции