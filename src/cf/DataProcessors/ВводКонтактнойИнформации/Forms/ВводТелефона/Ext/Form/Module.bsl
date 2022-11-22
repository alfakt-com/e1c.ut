﻿// Форма параметризуется:
//
//      Заголовок     - Строка  - заголовок формы.
//      ЗначенияПолей - Строка  - сериализованное значение контактной информации или пустая строка для 
//                                ввода нового.
//      Представление - Строка  - представление адреса (используется только при работе со старыми данными).
//      ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации, Структура - описание того, что мы
//                                редактируем.
//      Комментарий  - Строка   - необязательный комментарий, для подстановки в поле "Комментарий".
//
//      ВозвращатьСписокЗначений - Булево - необязательный флаг того, что возвращаемое значение поля.
//                                 КонтактнаяИнформация будет иметь тип СписокЗначений (совместимость).
//
//  Результат выбора:
//      Структура - поля:
//          * КонтактнаяИнформация   - Строка - XML контактной информации.
//          * Представление          - Строка - Представление.
//          * Комментарий            - Строка - Комментарий.
//
// -------------------------------------------------------------------------------------------------

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВозвращатьСписокЗначений", ВозвращатьСписокЗначений);
	
	// Разбор параметров в реквизиты.
	Если ТипЗнч(Параметры.ВидКонтактнойИнформации) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		ВидКонтактнойИнформации = Параметры.ВидКонтактнойИнформации;
		ТипКонтактнойИнформации = ВидКонтактнойИнформации.Тип;
	Иначе
		СтруктураВидКонтактнойИнформации = Параметры.ВидКонтактнойИнформации;
		ТипКонтактнойИнформации = СтруктураВидКонтактнойИнформации.Тип;
	КонецЕсли;
	
	ПроверятьКорректность      = ВидКонтактнойИнформации.ПроверятьКорректность;
	
	Заголовок = ?(ПустаяСтрока(Параметры.Заголовок), Строка(ВидКонтактнойИнформации), Параметры.Заголовок);
	
	ЭтоНовый = Истина;
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Параметры.ЗначенияПолей) Тогда
		ЭтоНовый = Ложь;
		РезультатыЧтения = Новый Структура;
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(Параметры.ЗначенияПолей, ТипКонтактнойИнформации, РезультатыЧтения);
		Если РезультатыЧтения.Свойство("ТекстОшибки") Тогда
			// Распознали с ошибками, сообщим при открытии.
			ТекстПредупрежденияПриОткрытии = РезультатыЧтения.ТекстОшибки;
			XDTOКонтактная.Представление   = Параметры.Представление;
		КонецЕсли;
	Иначе
		Если ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияТелефона(Параметры.ЗначенияПолей, Параметры.Представление, ТипКонтактнойИнформации);
		Иначе
			XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияФакса(Параметры.ЗначенияПолей, Параметры.Представление, ТипКонтактнойИнформации);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Комментарий <> Неопределено Тогда
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(XDTOКонтактная, Параметры.Комментарий);
	КонецЕсли;
	
	ЗначениеРеквизитовПоКонтактнойИнформации(XDTOКонтактная);
	Элементы.Добавочный.Видимость = ВидКонтактнойИнформации.ТелефонCДобавочнымНомером;
	
	// Группа команд "все действия" зависит от интерфейса.
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ФормаВсеДействия.Видимость = Ложь;
	Иначе
		Элементы.ОчиститьТелефон.Видимость = Ложь;
		Элементы.ИзменитьФорму.Видимость   = Ложь;
	КонецЕсли;
	
	Коды = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ВводКонтактнойИнформации.Форма.ВводТелефона", "КодыСтраныИГорода");
	Если ТипЗнч(Коды) = Тип("Структура") Тогда
		Если ЭтоНовый Тогда
				Коды.Свойство("КодСтраны", КодСтраны);
				Коды.Свойство("КодГорода", КодГорода);
		КонецЕсли;
		
		Если Коды.Свойство("СписокКодовГорода") Тогда
			Элементы.КодГорода.СписокВыбора.ЗагрузитьЗначения(Коды.СписокКодовГорода);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидКонтактнойИнформации.ХранитьИсториюИзменений Тогда
		Если Параметры.Свойство("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов") Тогда
			Для каждого СтрокаКИ Из Параметры.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов Цикл
				НоваяСтрока = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКИ);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(ТекстПредупрежденияПриОткрытии) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьПослеОткрытияФормы", 0.1, Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодГорода) Тогда
		ТекущийЭлемент = Элементы.КодГорода;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодСтраныПриИзменении(Элемент)
	
	ЗаполнитьПредставлениеТелефона();
	
КонецПроцедуры

&НаКлиенте
Процедура КодГородаПриИзменении(Элемент)
	
	Если (КодСтраны = "+7" ИЛИ КодСтраны = "8") И СтрНачинаетсяС(КодГорода, "9") И СтрДлина(КодГорода) <> 3 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Кода мобильных телефонов начинающиеся на цифру 9 имеют фиксированную длину в 3 цифры, например - 916.'"),, "КодГорода");
	КонецЕсли;
	
	ЗаполнитьПредставлениеТелефона();
КонецПроцедуры

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
	ЗаполнитьПредставлениеТелефона();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавочныйПриИзменении(Элемент)
	
	ЗаполнитьПредставлениеТелефона();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	ПодтвердитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТелефон(Команда)
	
	ОчиститьТелефонСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПредупредитьПослеОткрытияФормы()
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупрежденияПриОткрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	// При немодифицированности работает "отмена".
	
	Если Модифицированность Тогда
		
		ЕстьОшибкиЗаполнения = Ложь;
		// Смотрим, надо ли проверять на корректность.
		Если ПроверятьКорректность Тогда
			СписокОшибок = ОшибкиЗаполненияТелефона();
			ЕстьОшибкиЗаполнения = СписокОшибок.Количество() > 0;
		КонецЕсли;
		Если ЕстьОшибкиЗаполнения Тогда
			СообщитьОбОшибкахЗаполнения(СписокОшибок);
			Возврат;
		КонецЕсли;
		
		Результат = РезультатВыбора();
	
		СброситьМодифицированностьПриВыборе();
		ОповеститьОВыборе(Результат);
		
	ИначеЕсли Комментарий <> КопияКомментария Тогда
		// Изменен только комментарий, пробуем вернуть обновленное.
		Результат = РезультатВыбораТолькоКомментария();
		
		СброситьМодифицированностьПриВыборе();
		ОповеститьОВыборе(Результат);
		
	Иначе
		Результат = Неопределено;
		
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда
		СброситьМодифицированностьПриВыборе();
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьМодифицированностьПриВыборе()
	
	Модифицированность = Ложь;
	КопияКомментария   = Комментарий;
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	Результат = Новый Структура("КонтактнаяИнформация, Представление, Комментарий, Вид, Тип, КонтактнаяИнформацияОписаниеДополнительныхРеквизитов");
	
	СписокВыбора = Элементы.КодГорода.СписокВыбора;
	ЭлементСписка = СписокВыбора.НайтиПоЗначению(КодГорода);
	Если ЭлементСписка = Неопределено Тогда
		СписокВыбора.Вставить(0, КодГорода);
		Если СписокВыбора.Количество() > 10 Тогда
			СписокВыбора.Удалить(10);
		КонецЕсли;
	Иначе
		Индекс = СписокВыбора.Индекс(ЭлементСписка);
		Если Индекс <> 0 Тогда
			СписокВыбора.Сдвинуть(Индекс, -Индекс);
		КонецЕсли;
	КонецЕсли;
	
	Коды = Новый Структура("КодСтраны, КодГорода, СписокКодовГорода", КодСтраны, КодГорода, СписокВыбора.ВыгрузитьЗначения());
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ВводКонтактнойИнформации.Форма.ВводТелефона", "КодыСтраныИГорода", Коды, НСтр("ru = 'Коды страны и города'"));
	
	XDTOИнформация = КонтактнаяИнформацияПоЗначениюРеквизитов();
	
	Если ВозвращатьСписокЗначений Тогда
		ДанныеВыбора = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтаруюСтруктуру(XDTOИнформация);
		ДанныеВыбора = ДанныеВыбора.ЗначенияПолей;
	Иначе
		ДанныеВыбора = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(XDTOИнформация);
	КонецЕсли;
	
	Результат.Вид = ВидКонтактнойИнформации;
	Результат.Тип = ВидКонтактнойИнформации.Тип;
	Результат.КонтактнаяИнформация = ДанныеВыбора;
	Результат.Представление = XDTOИнформация.Представление;
	Результат.Комментарий = XDTOИнформация.Комментарий;
	Результат.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	
	Возврат Результат
КонецФункции

&НаСервере
Функция РезультатВыбораТолькоКомментария()
	
	КонтактнаяИнфо = Параметры.ЗначенияПолей;
	Если ПустаяСтрока(КонтактнаяИнфо) Тогда
		Если ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			КонтактнаяИнфо = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияТелефона("", "", ТипКонтактнойИнформации);
		Иначе
			КонтактнаяИнфо = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияФакса("", "", ТипКонтактнойИнформации);
		КонецЕсли;
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(КонтактнаяИнфо, Комментарий);
		КонтактнаяИнфо = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(КонтактнаяИнфо);
		
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(КонтактнаяИнфо) Тогда
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(КонтактнаяИнфо, Комментарий);
	КонецЕсли;
	
	Возврат Новый Структура("КонтактнаяИнформация, Представление, Комментарий",
		КонтактнаяИнфо, Параметры.Представление, Комментарий);
КонецФункции

// Заполняет реквизиты формы из XTDO объекта типа "Контактная информация".
&НаСервере
Процедура ЗначениеРеквизитовПоКонтактнойИнформации(РедактируемаяИнформация)
	
	Телефон = РедактируемаяИнформация.Состав;
	
	// Общие реквизиты
	Представление = РедактируемаяИнформация.Представление;
	Комментарий   = РедактируемаяИнформация.Комментарий;
	
	// Копия комментария для анализа измененности.
	КопияКомментария = Комментарий;
	
	КодСтраны     = Телефон.КодСтраны;
	КодГорода     = Телефон.КодГорода;
	НомерТелефона = Телефон.Номер;
	Добавочный    = Телефон.Добавочный;
	
КонецПроцедуры

// Возвращает XTDO объект типа "Контактная информация" по значению реквизитов.
&НаСервере
Функция КонтактнаяИнформацияПоЗначениюРеквизитов()
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	
	Результат = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация") );
	
	Если ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		Данные = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(ПространствоИмен, "НомерТелефона") );
		Данные.КодСтраны  = КодСтраны;
		Данные.КодГорода  = КодГорода;
		Данные.Номер      = НомерТелефона;
		Данные.Добавочный = Добавочный;
		Результат.Представление = УправлениеКонтактнойИнформациейСлужебный.ПредставлениеТелефона(Данные);
	Иначе        
		Данные = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(ПространствоИмен, "НомерФакса") );
		Данные.КодСтраны  = КодСтраны;
		Данные.КодГорода  = КодГорода;
		Данные.Номер      = НомерТелефона;
		Данные.Добавочный = Добавочный;
		Результат.Представление = УправлениеКонтактнойИнформациейСлужебный.ПредставлениеФакса(Данные);
	КонецЕсли;
	
	Результат.Состав      = Данные;
	Результат.Комментарий = Комментарий;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПредставлениеТелефона()
	
	ПодключитьОбработчикОжидания("ЗаполнитьПредставлениеТелефонаСейчас", 0.1, Истина);
	
КонецПроцедуры    

&НаКлиенте
Процедура ЗаполнитьПредставлениеТелефонаСейчас()
	
	ЗаполнитьПредставлениеТелефонаСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеТелефонаСервер(XDTOКонтактная = Неопределено)
	
	Инфо = ?(XDTOКонтактная = Неопределено, КонтактнаяИнформацияПоЗначениюРеквизитов(), XDTOКонтактная);
	Представление = Инфо.Представление;
	
КонецПроцедуры    

// Возвращает список ошибок заполнения в виде списка значений:
//      Представление   - описание ошибки.
//      Значение        - XPath для поля.
&НаКлиенте
Функция ОшибкиЗаполненияТелефона()
	
	СписокОшибок = Новый СписокЗначений;
	ПолныйНомерТелефона = КодСтраны + КодГорода + НомерТелефона;
	НомерТелефонаТолькоЦифры = ТолькоЦифры(ПолныйНомерТелефона);
	
	Если СтрДлина(НомерТелефонаТолькоЦифры) > 15 Тогда
		СписокОшибок.Добавить("НомерТелефона", НСтр("ru = 'Номер телефона слишком длинный'"));
	КонецЕсли;
	
	Если НомерТелефонаСодержитНедопустимыеСимволы(ПолныйНомерТелефона) Тогда
		СписокОшибок.Добавить("НомерТелефона", НСтр("ru = 'Номер телефона содержит недопустимые символы'"));
	КонецЕсли;
	
	Если КодСтраны = "7" ИЛИ КодСтраны = "+7" Тогда
		Если СтрДлина(ТолькоЦифры(НомерТелефона)) > 7 Тогда
			СписокОшибок.Добавить("НомерТелефона", НСтр("ru = 'В России номер телефона не может быть больше 7 цифр'"));
		КонецЕсли;
	КонецЕсли;
	
	Если СтрНачинаетсяС(КодГорода, "9") И СтрДлина(КодГорода) <> 3 Тогда
		СписокОшибок.Добавить("НомерТелефона", НСтр("ru = 'В России номера мобильных телефонов должны содержать 3 цифры'"));
	КонецЕсли;
	
	Возврат СписокОшибок;
КонецФункции

// Сообщает об ошибках заполнения по результату функции ОшибкиЗаполненияТелефонаСервер.
&НаКлиенте
Процедура СообщитьОбОшибкахЗаполнения(СписокОшибок)
	
	Если СписокОшибок.Количество()=0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Телефон введен корректно.'"));
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Значение - XPath, представление - описание ошибки.
	Для Каждого Элемент Из СписокОшибок Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Элемент.Представление,,,
		ПутьКДаннымФормыПоПутиXPath(Элемент.Значение));
	КонецЦикла;
	
КонецПроцедуры    

&НаКлиенте 
Функция ПутьКДаннымФормыПоПутиXPath(ПутьXPath) 
	Возврат ПутьXPath;
КонецФункции

&НаСервере
Процедура ОчиститьТелефонСервер()
	КодСтраны     = "";
	КодГорода     = "";
	НомерТелефона = "";
	Добавочный    = "";
	Комментарий   = "";
	
	ЗаполнитьПредставлениеТелефонаСервер();
	Модифицированность = Истина;
КонецПроцедуры

// Проверяет, содержит ли строка только ~
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка для проверки.
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
&НаКлиенте
Функция НомерТелефонаСодержитНедопустимыеСимволы(Знач СтрокаПроверки)
	
	СписокДопустимыхСимволов = "+-.,() wp1234567890";
	Возврат СтрРазделить(СтрокаПроверки, СписокДопустимыхСимволов, Ложь).Количество() > 0;
	
КонецФункции

&НаКлиенте
Функция ТолькоЦифры(Знач Строка)
	
	ЛишниеСимволы = СтрСоединить(СтрРазделить(Строка, "0123456789"), "");
	Результат     = СтрСоединить(СтрРазделить(Строка, ЛишниеСимволы), "");
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти
