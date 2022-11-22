﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ИзмененаЦена; // Используется в механизмах обработчиков событий табличной части Товары

&НаКлиенте
Перем ОтображаетсяВопрос;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	УстановкаЦенСервер.ЗагрузитьНастройкиОтбораПоУмолчанию(ЭтотОбъект);
	
	Дата = КонецДня(ТекущаяДатаСеанса());
	КодФормы = "Обработка_ПрайсЛистПоставщика_Форма";
	
	ФлагОткрытияФормы = Истина;
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры       = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ИспользоватьНоменклатуруПоставщиков    = ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруПоставщиков");
	ТекущаяДата = ТекущаяДатаСеанса();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	ПравоРегистрацииШтрихкодовНоменклатурыДоступно = ШтрихкодированиеНоменклатурыСервер.ПравоРегистрацииШтрихкодовНоменклатурыДоступно();
	
	Если ЗначениеЗаполнено(Параметры.НоменклатураПоставщика) Тогда
		Объект.Партнер = Параметры.НоменклатураПоставщика.Владелец;
		БлокироватьИзменениеОтбораПоПоставщику = Истина;
		НоменклатураПоставщика = Параметры.НоменклатураПоставщика;
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Объект.Партнер = Параметры.Партнер;
		БлокироватьИзменениеОтбораПоПоставщику = Истина;
	КонецЕсли;
	
	Элементы.Партнер.ТолькоПросмотр = БлокироватьИзменениеОтбораПоПоставщику;
	
	УстановкаЦенСервер.ИнициализироватьВыбранныеЦены(ЭтотОбъект);
	
	Если Не ЗагрузитьСохраненныеНастройки() Тогда
	
		Если ВыбранныеЦены.Количество() = 1 Тогда
			Для Каждого ТекСтрока Из ВыбранныеЦены Цикл
				ТекСтрока.Выбрана = Истина;
			КонецЦикла;
		Иначе
			Для Каждого СтрокаТаблицы Из ВыбранныеЦены Цикл
				Если Не СтрокаТаблицы.Выбрана И Не СтрокаТаблицы.ЗапрещенныйВидЦены Тогда
					СтрокаТаблицы.Выбрана = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
		УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, Ложь);
		
	КонецЕсли;
	
	УстановитьЗаполнятьАвтоматическиЦеныХарактеристикПоНоменклатуре(Истина);
	ЗафиксироватьКолонкуНоменклатура(Ложь);
	
	Если ЗначениеЗаполнено(Параметры.НоменклатураПоставщика) Тогда
		
		ИспользоватьСохраняемыеНастройки = Ложь;
		
		КомпоновщикНастроекОтбор.Настройки.Отбор.Элементы.Очистить();
		
		СписокНоменклатуры = Новый СписокЗначений;
		СписокНоменклатуры.Добавить(Параметры.НоменклатураПоставщика);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			КомпоновщикНастроекОтбор.Настройки.Отбор,
			"НоменклатураПоставщика",
			ВидСравненияКомпоновкиДанных.ВСписке,
			СписокНоменклатуры,
			Неопределено,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
			
		УстановкаЦенСервер.НастроитьЗаголовокОтбора(ЭтотОбъект);
		
		ПрименитьНастройки();
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		
		ОтборНоменклатура = Параметры.Номенклатура;
		ИспользоватьСохраняемыеНастройки = Ложь;
		
		КомпоновщикНастроекОтбор.Настройки.Отбор.Элементы.Очистить();
		
		СписокНоменклатуры = Новый СписокЗначений;
		СписокНоменклатуры.Добавить(Параметры.Номенклатура);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			КомпоновщикНастроекОтбор.Настройки.Отбор,
			"Номенклатура",
			ВидСравненияКомпоновкиДанных.ВСписке,
			СписокНоменклатуры,
			Неопределено,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
			
		НайтиПартнераПоНоменклатуре(Параметры.Номенклатура);
		
		УстановкаЦенСервер.НастроитьЗаголовокОтбора(ЭтотОбъект);
		
		Если ЗначениеЗаполнено(Объект.Партнер) Тогда
			ПрименитьНастройки();
		КонецЕсли;
		
	Иначе
		ИспользоватьСохраняемыеНастройки = Истина;
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложения.ПриСозданииПодсказокФормы(ЭтотОбъект, Элементы.ПодсказкиБизнесСеть);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект, "СканерШтрихкода");
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложенияКлиент.ОбновитьПодсказкуФормы(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ РазрешитьЗакрытие И ОтображаетсяВопрос <> Истина И НЕ ЗавершениеРаботы Тогда
		
		ОтображаетсяВопрос = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаРезультатаВопросПередЗакрытием", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ЗаписатьИЗакрыть", НСтр("ru = 'Применить'"));
		Кнопки.Добавить("ЗакрытьБезСохранения", НСтр("ru = 'Отменить изменения цен'"));
		Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		ТекстВопроса = НСтр("ru = 'Применить измененные цены?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ИспользоватьСохраняемыеНастройки И НЕ ЗавершениеРаботы Тогда
		СохранитьНастройкиФормыНаСервере();
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПрайсЛистПоставщика.Форма.ФормаНастройки" Тогда
		ДействуетСессияИзмененияЦен = Ложь;
		ОчиститьСохраненныеДокументыИПрименитьНастройки(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ПартнерПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если ДеревоЦен.ПолучитьЭлементы().Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Дата = КонецДня(Дата);
	
	Если Элементы.СтраницыКоманднойПанели.ТекущаяСтраница = Элементы.СтраницыКоманднойПанели.ПодчиненныеЭлементы.СтраницаПросмотр Тогда
		ПрименитьНастройки();
		Возврат;
	КонецЕсли;
	
	ОбновитьСтарыеЦеныНоменклатурыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаУстановленОтборНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастройкиПрайсЛиста(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоЦен

&НаКлиенте
Процедура ДеревоЦенВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДеревоЦенНоменклатура" Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.ДеревоЦен.ТекущиеДанные.Номенклатура);
	ИначеЕсли Поле.Имя = "ДеревоЦенНоменклатураПоставщика" Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.ДеревоЦен.ТекущиеДанные.НоменклатураПоставщика);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЦенПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ДеревоЦен.ТекущиеДанные;
	ИзмененаЦена = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ДеревоЦенУпаковкаПриИзмененииНаСервере(Идентификатор, ИмяТекущейКолонки)
	УстановкаЦенСервер.ДеревоЦенУпаковкаПриИзменении(ЭтотОбъект, Идентификатор, ИмяТекущейКолонки);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЦенПриАктивизацииЯчейки(Элемент)
	
	СтрокаИнформации = УстановкаЦенКлиент.ИнформацияТекущейСтроки(
		Элементы,
		ВыбранныеЦены,
		ДатаДействующихЦен,
		ТекущаяДата,
		ИспользоватьХарактеристикиНоменклатуры,
		Истина);
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "ДеревоЦенУпаковка".
//
&НаКлиенте
Процедура ДеревоЦенУпаковкаПриИзмененииКлиент(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоЦен.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяТекущейКолонки = СтрЗаменить(Элемент.Имя, "ДеревоЦен", "");

	Если ЗаполнятьАвтоматическиЦеныХарактеристикПоНоменклатуре Тогда
		
		ТекущаяСтрока = ДеревоЦен.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
		
		Если ТекущаяСтрока.ПолучитьРодителя() = Неопределено Тогда
			
			ЭлементыХарактеристики = ТекущаяСтрока.ПолучитьЭлементы();
			ТекущееЗначение   = ТекущиеДанные[ИмяТекущейКолонки];
			
			Для Каждого ЭлементХарактеристика Из ЭлементыХарактеристики Цикл
				Если ЭлементХарактеристика[ИмяТекущейКолонки] <> ТекущееЗначение Тогда
					ЭлементХарактеристика[ИмяТекущейКолонки] = ТекущееЗначение;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДеревоЦенУпаковкаПриИзмененииНаСервере(ТекущиеДанные.ПолучитьИдентификатор(), ИмяТекущейКолонки);
	
	СтрокаИнформации = УстановкаЦенКлиент.ИнформацияТекущейСтроки(
		Элементы,
		ВыбранныеЦены,
		ДатаДействующихЦен,
		ТекущаяДата,
		ИспользоватьХарактеристикиНоменклатуры,
		Истина);
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "ДеревоЦенЦена".
//
&НаКлиенте
Функция ДеревоЦенЦенаПриИзмененииКлиент(Элемент)
	
	ДанныеДляРасчетаВычисляемыхЦенНаКлиенте = Неопределено;
	
	ТекущиеДанные = Элементы.ДеревоЦен.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат ДанныеДляРасчетаВычисляемыхЦенНаКлиенте;
	КонецЕсли;
	
	ИмяКолонкиУпаковка = СтрЗаменить(Элемент.Имя, "ДеревоЦенВидЦены", "УпаковкаВидЦены");
	ИмяТекущейКолонки  = СтрЗаменить(Элемент.Имя, "ДеревоЦен", "");
	
	Если СтрНайти(ИмяТекущейКолонки, "ПроцентИзмененияВидЦены") Тогда
		ИмяТекущейКолонки = СтрЗаменить(ИмяТекущейКолонки, "ПроцентИзмененияВидЦены", "ВидЦены");
		ТекущиеДанные[ИмяТекущейКолонки] = Окр(
			ТекущиеДанные["СтараяЦена" + ИмяТекущейКолонки] * ((ТекущиеДанные["ПроцентИзменения"+ИмяТекущейКолонки] / 100) + 1),
			15,
			2);
		ИмяКолонкиУпаковка = СтрЗаменить(СтрЗаменить(Элемент.Имя, "ПроцентИзмененияВидЦены", "ВидЦены"), "ДеревоЦенВидЦены", "УпаковкаВидЦены");
	КонецЕсли;
	Если СтрНайти(ИмяТекущейКолонки, "СуммаИзмененияВидЦены") Тогда
		ИмяТекущейКолонки = СтрЗаменить(ИмяТекущейКолонки, "СуммаИзмененияВидЦены", "ВидЦены");
		ТекущиеДанные[ИмяТекущейКолонки] = ТекущиеДанные["СтараяЦена" + ИмяТекущейКолонки] + ТекущиеДанные["СуммаИзменения" + ИмяТекущейКолонки];
		Если ТекущиеДанные["СтараяЦена" + ИмяТекущейКолонки] <> 0 Тогда
			ТекущиеДанные["ПроцентИзменения"+ИмяТекущейКолонки] = ТекущиеДанные[ИмяТекущейКолонки] / ТекущиеДанные["СтараяЦена" + ИмяТекущейКолонки] * 100;
		Иначе
			ТекущиеДанные["ПроцентИзменения"+ИмяТекущейКолонки] = 0;
		КонецЕсли;
		ИмяКолонкиУпаковка = СтрЗаменить(СтрЗаменить(Элемент.Имя, "СуммаИзмененияВидЦены", "ВидЦены"), "ДеревоЦенВидЦены", "УпаковкаВидЦены");
	КонецЕсли;
	
	ТекущаяСтрока = ДеревоЦен.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	
	ТекущиеДанные["ИзмененаВручную"       + ИмяТекущейКолонки] = Истина;
	ТекущиеДанные["ИзмененаАвтоматически" + ИмяТекущейКолонки] = Ложь;
	
	Если ТекущиеДанные["СтараяЦена"+ИмяТекущейКолонки] <> 0 Тогда
		ТекущиеДанные["ПроцентИзменения"+ИмяТекущейКолонки] = Окр(
			100 * (ТекущиеДанные[ИмяТекущейКолонки] - ТекущиеДанные["СтараяЦена"+ИмяТекущейКолонки]) / ТекущиеДанные["СтараяЦена" + ИмяТекущейКолонки],
			5,
			2);
		ТекущиеДанные["СуммаИзменения"+ИмяТекущейКолонки] = ТекущиеДанные[ИмяТекущейКолонки] - ТекущиеДанные["СтараяЦена" + ИмяТекущейКолонки];
	Иначе
		ТекущиеДанные["ПроцентИзменения"+ИмяТекущейКолонки] = 0;
		ТекущиеДанные["СуммаИзменения"+ИмяТекущейКолонки] = 0;
	КонецЕсли;
	
	Возврат ДанныеДляРасчетаВычисляемыхЦенНаКлиенте;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПривязываютсяДинамически

&НаКлиенте
Процедура Подключаемый_ДеревоЦенЦенаПриИзменении(Элемент)
	
	ИзмененаЦена = Истина;
	ДеревоЦенЦенаПриИзмененииКлиент(Элемент);
	
	Если Не ИспользоватьРежимРедактирования Тогда
		УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДеревоЦенУпаковкаПриИзменении(Элемент)

	ДеревоЦенУпаковкаПриИзмененииКлиент(Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтчетПоДинамикеЦен(Команда)
	
	СписокНоменклатуры  = Новый СписокЗначений;
	СписокХарактеристик = Новый СписокЗначений;
	Для Каждого ИдентификаторСтрокиДереваЦен Из Элементы.ДеревоЦен.ВыделенныеСтроки Цикл
		СтрокаТЧ = ДеревоЦен.НайтиПоИдентификатору(ИдентификаторСтрокиДереваЦен);
		СписокНоменклатуры.Добавить(СтрокаТЧ.Номенклатура);
		Если СтрокаТЧ.ХарактеристикиИспользуются Тогда
			Если СписокХарактеристик.НайтиПоЗначению(СтрокаТЧ.Характеристика) = Неопределено Тогда
				СписокХарактеристик.Добавить(СтрокаТЧ.Характеристика);
			КонецЕсли;
		Иначе
			Если СписокХарактеристик.НайтиПоЗначению(
					ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка")) = Неопределено Тогда
				СписокХарактеристик.Добавить(ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СписокВидовЦен = Новый СписокЗначений;
	Для Каждого СтрокаВидЦены Из УстановкаЦенКлиентСервер.ВыбранныеСтрокиТаблицыВидовЦен(ЭтотОбъект) Цикл
		СписокВидовЦен.Добавить(СтрокаВидЦены.Ссылка, СтрокаВидЦены.Наименование);
	КонецЦикла;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура", СписокНоменклатуры);
	Отбор.Вставить("Характеристика", СписокХарактеристик);
	Отбор.Вставить("ВидЦеныПоставщика", СписокВидовЦен);
	
	ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии",
	        Отбор,
	        НСтр("ru = 'Динамика изменения цен по номенклатуре (Диаграмма)'"),
	        НСтр("ru = 'Динамика изменения цен по номенклатуре (Диаграмма)'"),
	        Истина);
	
	ОткрытьФорму("Отчет.ДинамикаИзмененияЦенНоменклатурыПоставщика.Форма",
	        ПараметрыФормы, ЭтотОбъект, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзмененияЦенКонтекст(Команда)
	
	ТекущиеДанные = Элементы.ДеревоЦен.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Ключ",           ТекущиеДанные.Номенклатура);
	ПараметрыОткрытияФормы.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ИсторияЦенНоменклатуры", ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьИзменениеЦен(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		
		ЗаписатьИзмененияЦен();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		
		ОткрытьФормуНастройкиПрайсЛиста();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСоСхожимиСвойствами(Команда)
	
	ТекущиеДанные = Элементы.ДеревоЦен.ТекущиеДанные;
	ТоварыСоСхожимиСвойствами = Новый Структура;
	ТоварыСоСхожимиСвойствами.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	ТоварыСоСхожимиСвойствами.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ОткрытьФормуНастройкиПрайсЛиста(Ложь, ТоварыСоСхожимиСвойствами);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзменениеЦен(Команда)
	
	ОтменитьИзменениеЦенНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзмененияЦен(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Партнер", Объект.Партнер);
	
	ОткрытьФорму("Документ.РегистрацияЦенНоменклатурыПоставщика.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Партнер", Объект.Партнер);
	ПараметрыОткрытияФормы.Вставить("ВидыЦен", УстановкаЦенКлиентСервер.ВыбранныеВидыЦен(ЭтотОбъект));
	ПараметрыОткрытияФормы.Вставить("БлокироватьИзменениеОтбораПоПоставщику", БлокироватьИзменениеОтбораПоПоставщику);
	
	ОткрытьФорму("Обработка.ЗагрузкаЦенПоставщикаИзВнешнихФайлов.Форма.Форма", ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ТорговыеПредложения
&НаКлиенте
Процедура Подключаемый_ПодсказкиБизнесСетьНажатие(Команда)
	
	ТорговыеПредложенияКлиент.ОткрытьФормуПодсказок(ЭтаФорма);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения

&НаКлиенте
Процедура НастроитьВыводимуюИнформацию(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ПоказыватьИзменениеЦены",   ПоказыватьИзменениеЦены);
	ПараметрыФормы.Вставить("ПоказыватьПроцентНаценки",  ПоказыватьПроцентНаценки);
	ПараметрыФормы.Вставить("ПоказыватьДействующиеЦены", ПоказыватьДействующиеЦены);
	ПараметрыФормы.Вставить("ДатаДействующихЦен",        ДатаДействующихЦен);
	ПараметрыФормы.Вставить("ПоказыватьДату",            Истина);
	
	ОткрытьФорму(
		"Обработка.ПрайсЛист.Форма.ФормаНастройкиВыводимойИнформации",
		ПараметрыФормы,
		ЭтотОбъект,,,, Новый ОписаниеОповещения("НастроитьВыводимуюИнформациюЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВыводимуюИнформациюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказыватьИзменениеЦены   = Результат.ПоказыватьИзменениеЦены;
 	ПоказыватьПроцентНаценки  = Результат.ПоказыватьПроцентНаценки;
	ПоказыватьДействующиеЦены = Результат.ПоказыватьДействующиеЦены;
	ДатаДействующихЦен        = Результат.ДатаДействующихЦен;
	
	УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, ИспользоватьРежимРедактирования);
	СохранитьНастройкиФормыНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЦенХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЦен.ИндексКартинки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЦен.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЦен.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЦен.ИндексКартинки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, 
																			 "ДеревоЦенХарактеристика",
																			 "ДеревоЦен.ХарактеристикиИспользуются");

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормыНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Партнер) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НоменклатураПоставщика) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиКомпоновщика = КомпоновщикНастроекОтбор.ПолучитьНастройки();
	
	МассивВыбранныеЦены = УстановкаЦенКлиентСервер.ВыбранныеВидыЦен(ЭтотОбъект);
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("НастройкиКомпоновщика",      НастройкиКомпоновщика);
	СтруктураДанных.Вставить("ВыбранныеЦены",              МассивВыбранныеЦены);
	СтруктураДанных.Вставить("ТаблицаПараметровОтбора",    ТаблицаПараметровОтбора.Выгрузить());
	СтруктураДанных.Вставить("ВидНастройки",               ВидНастройки);
	СтруктураДанных.Вставить("ВариантНавигации",           ВариантНавигации);
	СтруктураДанных.Вставить("ВидНоменклатуры",            ВидНоменклатуры);
	СтруктураДанных.Вставить("УстановленыНастройкиОтбора", УстановленыНастройкиОтбора);
	СтруктураДанных.Вставить("ПоказыватьСтарыеЦены",       ПоказыватьСтарыеЦены);
	СтруктураДанных.Вставить("ПоказыватьДействующиеЦены",  ПоказыватьДействующиеЦены);
	СтруктураДанных.Вставить("ПоказыватьИзменениеЦены",    ПоказыватьИзменениеЦены);
	СтруктураДанных.Вставить("ПоказыватьПроцентНаценки",   ПоказыватьПроцентНаценки);
	СтруктураДанных.Вставить("ДатаДействующихЦен",         ДатаДействующихЦен);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ПрайсЛистПоставщика", Строка(Объект.Партнер.УникальныйИдентификатор()), СтруктураДанных);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьИзменениеЦенНаСервере(ВыполняетсяЗакрытиеФормы = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	УстановкаЦенСервер.ОчиститьСохраненныеДокументы(СохраненныеДокументы, УникальныйИдентификатор, Истина);
	
	Если Не ВыполняетсяЗакрытиеФормы Тогда
		
		УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
		УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, Ложь);
		ПрименитьНастройки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройки(АдресВоВременномХранилище = Неопределено)
	
	Если АдресВоВременномХранилище <> Неопределено Тогда
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
		
		КомпоновщикНастроекОтбор.ЗагрузитьНастройки(СтруктураДанных.НастройкиКомпоновщика);
		УстановкаЦенСервер.НастроитьЗаголовокОтбора(ЭтотОбъект);
		
		Объект.Партнер = СтруктураДанных.Партнер;
		
		УстановкаЦенСервер.ИнициализироватьВыбранныеЦены(ЭтотОбъект);
		УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
		
		Для Каждого СтрокаТЧ Из ВыбранныеЦены Цикл
			СтрокаТЧ.Выбрана = СтруктураДанных.ВыбранныеЦены.Найти(СтрокаТЧ.Ссылка) <> Неопределено;
		КонецЦикла;
		
		Дата = СтруктураДанных.Дата;
		
		ВидНастройки = СтруктураДанных.ВидНастройки;
		ТаблицаПараметровОтбора.Загрузить(СтруктураДанных.ТаблицаПараметровОтбора);
		
		ВариантНавигации = СтруктураДанных.ВариантНавигации;
		ВидНоменклатуры = СтруктураДанных.ВидНоменклатуры;
		
		УстановленыНастройкиОтбора = КомпоновщикНастроекОтбор.Настройки.Отбор.Элементы.Количество() > 0;
		
	КонецЕсли;
	
	Объект.Товары.Очистить();
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОбязательныеПоля", Новый Массив);
	СтруктураНастроек.Вставить("ПараметрыДанных", Новый Структура);
	СтруктураНастроек.Вставить("КомпоновщикНастроек", Неопределено);
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных", Неопределено);
	СтруктураНастроек.Вставить("ВестиУчетСертификатовНоменклатуры", Ложь);
	СтруктураНастроек.Вставить("ЦеныНаДату", КонецДня(Дата));
	СтруктураНастроек.Вставить("Поставщик", Объект.Партнер);
	
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	Если ИспользоватьНоменклатуруПоставщиков Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("НоменклатураПоставщика");
	КонецЕсли;
	Если ИспользоватьХарактеристикиНоменклатуры Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Характеристика");
	КонецЕсли;
	
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроекОтбор;
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "МакетНоменклатураПоставщика";
	
	УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
	УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, ИспользоватьРежимРедактирования);
	
	ТаблицаНоменклатуры = УстановкаЦенСервер.СоздатьТаблицуНоменклатуры();
	
	// Загрузка сформированного списка товаров.
	СтруктураРезультата = Обработки.ПодборТоваровПоОтбору.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоваров Цикл
		
		НоваяСтрока = ТаблицаНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура           = СтрокаТЧ.Номенклатура;
		Если ИспользоватьНоменклатуруПоставщиков Тогда
			НоваяСтрока.НоменклатураПоставщика = СтрокаТЧ.НоменклатураПоставщика;
		КонецЕсли;
		Если ИспользоватьХарактеристикиНоменклатуры Тогда
			НоваяСтрока.Характеристика = СтрокаТЧ.Характеристика;
		КонецЕсли;
	КонецЦикла;
	
	КэшДанных = УстановкаЦенСервер.ИнициализироватьСтруктуруКэшаДанных();
	
	ТаблицаНоменклатуры = УстановкаЦенСервер.ДобавитьТоварыПоставщика(ЭтотОбъект, ТаблицаНоменклатуры, КэшДанных);
	
	ТаблицаЗначений = УстановкаЦенСервер.ТаблицаТовары(ЭтотОбъект, КэшДанных);
	УстановкаЦенСервер.ЗагрузитьСтарыеЦеныНоменклатурыПоставщикаПрайсЛист(ЭтотОбъект, ТаблицаЗначений, КэшДанных);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьИзмененияЦенНаСервере(Комментарий = "", ВариантПримененияЦен = 0)
	
	РеквизитыНовыхДокументов = Новый Структура;
	РеквизитыНовыхДокументов.Вставить("Ответственный", Пользователи.ТекущийПользователь());
	РеквизитыНовыхДокументов.Вставить("Партнер", Объект.Партнер);
	РеквизитыНовыхДокументов.Вставить("Комментарий", Комментарий);
	РеквизитыНовыхДокументов.Вставить("Дата", Дата);
	
	Данные = Новый Структура;
	Данные.Вставить("Форма",                    ЭтотОбъект);
	Данные.Вставить("Документы",                Новый Массив);
	Данные.Вставить("СохранятьБазовые",         Ложь);
	Данные.Вставить("РеквизитыНовыхДокументов", РеквизитыНовыхДокументов);
	Данные.Вставить("ТолькоИзмененные",         Истина);
	
	Для Каждого СтрокаТЧ Из СохраненныеДокументы Цикл
		ДокументОбъект = СтрокаТЧ.Ссылка.ПолучитьОбъект();
		Данные.Документы.Добавить(ДокументОбъект);
	КонецЦикла;
	
	УстановкаЦенСервер.ПоместитьЦеныВТабличнуюЧасть(Данные);
	
	МассивДокументы = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ДокументОбъект Из Данные.Документы Цикл
			Если ДокументОбъект.Товары.Количество() > 0 Тогда
				
				ДокументОбъект.Дата = Дата;
				
				ДокументОбъект.Записать(?(ВариантПримененияЦен = 0, РежимЗаписиДокумента.Запись,
				РежимЗаписиДокумента.Проведение), РежимПроведенияДокумента.Неоперативный);
				
				СтруктураДокументов = Новый Структура;
				СтруктураДокументов.Вставить("РегистрацияЦенНоменклатурыПоставщика", ДокументОбъект.Ссылка);
				МассивДокументы.Добавить(СтруктураДокументов);
				
			Иначе
				Если ЗначениеЗаполнено(ДокументОбъект.Ссылка) Тогда
					ДокументОбъект.Прочитать();
					ДокументОбъект.Удалить();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке().Описание);
		Возврат Неопределено;
		
	КонецПопытки;
	
	УстановкаЦенСервер.ОчиститьСохраненныеДокументы(СохраненныеДокументы, УникальныйИдентификатор);
	
	Для Каждого СтрокаТЧ Из МассивДокументы Цикл
		НоваяСтрока = СохраненныеДокументы.Добавить();
		НоваяСтрока.Ссылка = СтрокаТЧ.РегистрацияЦенНоменклатурыПоставщика;
		ЗаблокироватьДанныеДляРедактирования(СтрокаТЧ.РегистрацияЦенНоменклатурыПоставщика,,УникальныйИдентификатор);
	КонецЦикла;
	
	УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, Ложь);
	
	Модифицированность = Ложь;
	
	Возврат МассивДокументы;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьИзмененияЦен()
	
	ДействуетСессияИзмененияЦен = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Дата", Дата);
	
	ОткрытьФорму(
		"Обработка.ПрайсЛист.Форма.ФормаПримененияЦен",
		ПараметрыФормы,
		ЭтотОбъект,,,, Новый ОписаниеОповещения("ЗаписатьИзмененияЦенЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияЦенЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ЗаписатьИзмененияЦенНаСервере(Результат.Комментарий, Результат.ВариантПримененияЦен);
	Если Данные <> Неопределено Тогда
		
		Для Каждого СтрокаТЧ Из Данные Цикл
			ТекстОповещения = НСтр("ru = 'Создан новый документ'");
			ПараметрыОповещения = Неопределено;
			Оповестить("Запись_РегистрацияЦенНоменклатурыПоставщика", ПараметрыОповещения, СтрокаТЧ.РегистрацияЦенНоменклатурыПоставщика);
			ПоказатьОповещениеПользователя(ТекстОповещения,
				ПолучитьНавигационнуюСсылку(СтрокаТЧ.РегистрацияЦенНоменклатурыПоставщика),
				Строка(СтрокаТЧ.РегистрацияЦенНоменклатурыПоставщика),
				БиблиотекаКартинок.Информация32);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура ОбработкаРезультатаВопросПередЗакрытием(Результат, Параметры) Экспорт
	
	ОтображаетсяВопрос = Ложь;
	
	Если Результат = "ЗакрытьБезСохранения" Тогда
		
		ОтменитьИзменениеЦенНаСервере(Истина);
		РазрешитьЗакрытие = Истина;
		Если Открыта() Тогда
			Закрыть(Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Результат = "ЗаписатьИЗакрыть" Тогда
		
		ЗаписатьИзмененияЦен();
		
		РазрешитьЗакрытие = Истина;
		Если Открыта() Тогда
			Закрыть(Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьКолонокРедактирования(Форма, ИспользоватьРежимРедактирования)
	
	Для Каждого ТекЭлемент Из Форма.Элементы.ДеревоЦен.ПодчиненныеЭлементы Цикл
		Если СтрНайти(ТекЭлемент.Имя, "ГруппаЦеныВидЦены") Тогда
			Для Каждого ВложенныйЭлемент Из ТекЭлемент.ПодчиненныеЭлементы Цикл
				Если СтрНайти(ВложенныйЭлемент.Имя, "СтараяЦена") Тогда
					ВложенныйЭлемент.Видимость = Форма.ПоказыватьДействующиеЦены;
				КонецЕсли;
				Если СтрНайти(ВложенныйЭлемент.Имя, "ПроцентИзменения") Тогда
					ВложенныйЭлемент.Видимость = Форма.ПоказыватьПроцентНаценки;
				КонецЕсли;
				Если СтрНайти(ВложенныйЭлемент.Имя, "СуммаИзменения") Тогда
					ВложенныйЭлемент.Видимость = Форма.ПоказыватьИзменениеЦены;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если ИспользоватьРежимРедактирования Тогда
		Форма.Элементы.СтраницыКоманднойПанели.ТекущаяСтраница = Форма.Элементы.СтраницыКоманднойПанели.ПодчиненныеЭлементы.СтраницаРедактирование;
		Форма.Элементы.ЗакончитьИзменениеЦен.КнопкаПоУмолчанию = Истина;
	Иначе
		Форма.Элементы.СтраницыКоманднойПанели.ТекущаяСтраница = Форма.Элементы.СтраницыКоманднойПанели.ПодчиненныеЭлементы.СтраницаПросмотр;
		Форма.Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
		Форма.Модифицированность = Ложь;
	КонецЕсли;

	Форма.ИспользоватьРежимРедактирования = ИспользоватьРежимРедактирования;
	
КонецПроцедуры

&НаСервере
Функция АдресНастроекПрайсЛистаВоВременномХранилище()
	
	НастройкиКомпоновщика = КомпоновщикНастроекОтбор.ПолучитьНастройки();
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("НастройкиКомпоновщика", НастройкиКомпоновщика);
	СтруктураДанных.Вставить("ВыбранныеЦены", ВыбранныеЦены.Выгрузить());
	СтруктураДанных.Вставить("Дата", Дата);
	СтруктураДанных.Вставить("ТаблицаПараметровОтбора", ТаблицаПараметровОтбора.Выгрузить());
	СтруктураДанных.Вставить("ВидНастройки", ВидНастройки);
	СтруктураДанных.Вставить("ВариантНавигации", ВариантНавигации);
	СтруктураДанных.Вставить("Партнер", Объект.Партнер);
	СтруктураДанных.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураДанных, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастройкиПрайсЛиста(ТолькоОтбор = Ложь, ТоварыСоСхожимиСвойствами = Неопределено)
	
	АдресВоВременномХранилище = АдресНастроекПрайсЛистаВоВременномХранилище();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыФормы.Вставить("НастройкиПрайсЛиста", АдресВоВременномХранилище);
	ПараметрыФормы.Вставить("Дата", Дата);
	ПараметрыФормы.Вставить("ТолькоОтбор", ТолькоОтбор);
	ПараметрыФормы.Вставить("ТоварыСоСхожимиСвойствами", ТоварыСоСхожимиСвойствами);
	ПараметрыФормы.Вставить("БлокироватьИзменениеОтбораПоПоставщику", БлокироватьИзменениеОтбораПоПоставщику);
	
	ОткрытьФорму("Обработка.ПрайсЛистПоставщика.Форма.ФормаНастройки", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтарыеЦеныНоменклатурыНаСервере()
	УстановкаЦенСервер.ОбновитьСтарыеЦеныНоменклатуры(ЭтотОбъект);
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

// МеханизмВнешнегоОборудования
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	

КонецПроцедуры // ОбработатьШтрихкоды()
// Конец МеханизмВнешнегоОборудования

#КонецОбласти

#Область Прочее

// Устанавливает признак автозаполнения цен характеристик по номенклатуре
//
// Параметры:
// НовоеЗначение - Булево
//
&НаСервере
Процедура УстановитьЗаполнятьАвтоматическиЦеныХарактеристикПоНоменклатуре(НовоеЗначение)
	
	Если НовоеЗначение = Неопределено Тогда
		НовоеЗначение = Истина;
	КонецЕсли;
	
	ЗаполнятьАвтоматическиЦеныХарактеристикПоНоменклатуре = НовоеЗначение;
	
КонецПроцедуры

// Устанавливает признак фиксации колонок "Номенклатура" и "Характеристика" слева
//
// Параметры:
// НовоеЗначение - Булево
//
&НаСервере
Процедура ЗафиксироватьКолонкуНоменклатура(НовоеЗначение)
	
	Если НовоеЗначение = Неопределено Тогда
		НовоеЗначение = Истина;
	КонецЕсли;
	
	ЗафиксироватьКолонкуНоменклатура = НовоеЗначение;
	
	Элементы.ДеревоЦенНоменклатура.ФиксацияВТаблице   = ?(ЗафиксироватьКолонкуНоменклатура,ФиксацияВТаблице.Лево,ФиксацияВТаблице.Нет);
	Элементы.ДеревоЦенХарактеристика.ФиксацияВТаблице = ?(ЗафиксироватьКолонкуНоменклатура,ФиксацияВТаблице.Лево,ФиксацияВТаблице.Нет);
	
КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	УстановкаЦенСервер.ИнициализироватьВыбранныеЦены(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		Если Не ЗагрузитьСохраненныеНастройки() Тогда
			УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
			УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, ИспользоватьРежимРедактирования);
		КонецЕсли;
	Иначе
		УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
		УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, ИспользоватьРежимРедактирования);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьСохраненныеНастройки()
	
	Результат = Ложь;
	
	СохраненныеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ПрайсЛистПоставщика", Строка(Объект.Партнер.УникальныйИдентификатор()));
	Если СохраненныеНастройки <> Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(НоменклатураПоставщика) Тогда
			
			КомпоновщикНастроекОтбор.ЗагрузитьНастройки(СохраненныеНастройки.НастройкиКомпоновщика);
			УстановкаЦенСервер.НастроитьЗаголовокОтбора(ЭтотОбъект);
			
			ТаблицаПараметровОтбора.Загрузить(СохраненныеНастройки.ТаблицаПараметровОтбора);
			ВидНастройки               = СохраненныеНастройки.ВидНастройки;
			ВариантНавигации           = СохраненныеНастройки.ВариантНавигации;
			ВидНоменклатуры            = СохраненныеНастройки.ВидНоменклатуры;
			УстановленыНастройкиОтбора = СохраненныеНастройки.УстановленыНастройкиОтбора;
			
			Если СохраненныеНастройки.Свойство("ПоказыватьПроцентНаценки") Тогда
				ПоказыватьПроцентНаценки = СохраненныеНастройки.ПоказыватьПроцентНаценки;
			КонецЕсли;
			
			Если СохраненныеНастройки.Свойство("ПоказыватьИзменениеЦены") Тогда
				ПоказыватьИзменениеЦены = СохраненныеНастройки.ПоказыватьИзменениеЦены;
			КонецЕсли;
			
			Если СохраненныеНастройки.Свойство("ПоказыватьДействующиеЦены") Тогда
				ПоказыватьДействующиеЦены  = СохраненныеНастройки.ПоказыватьДействующиеЦены;
			КонецЕсли;
			
			Если СохраненныеНастройки.Свойство("ДатаДействующихЦен") Тогда
				ДатаДействующихЦен = СохраненныеНастройки.ДатаДействующихЦен;
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого СтрокаТЧ Из ВыбранныеЦены Цикл
			СтрокаТЧ.Выбрана = СохраненныеНастройки.ВыбранныеЦены.Найти(СтрокаТЧ.Ссылка) <> Неопределено
			                   И Не СтрокаТЧ.ЗапрещенныйВидЦены;
		КонецЦикла;

		УстановкаЦенСервер.ПостроитьДеревоЦен(ЭтотОбъект);
		УстановитьВидимостьКолонокРедактирования(ЭтотОбъект, Ложь);
		
		Результат = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура НайтиПартнераПоНоменклатуре(Номенклатура)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НоменклатураПоставщиков.Владелец КАК Партнер
	|ПОМЕСТИТЬ Партнеры
	|ИЗ
	|	Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
	|ГДЕ
	|	НоменклатураПоставщиков.Номенклатура = &Номенклатура
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЦеныНоменклатуры.Партнер
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыПоставщиков КАК ЦеныНоменклатуры
	|ГДЕ
	|	ЦеныНоменклатуры.Номенклатура = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Партнер
	|ИЗ
	|	Партнеры КАК Т
	|");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() >= 1 Тогда
		
		Элементы.Партнер.РежимВыбораИзСписка = Истина;
		
		Пока Выборка.Следующий() Цикл
			Элементы.Партнер.СписокВыбора.Добавить(Выборка.Партнер);
			Объект.Партнер = Выборка.Партнер;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(Объект.Партнер) Тогда
			УстановкаЦенСервер.ИнициализироватьВыбранныеЦены(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСохраненныеДокументыИПрименитьНастройки(Знач ВыбранноеЗначение)
	
	УстановкаЦенСервер.ОчиститьСохраненныеДокументы(СохраненныеДокументы, УникальныйИдентификатор);
	
	ПрименитьНастройки(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
