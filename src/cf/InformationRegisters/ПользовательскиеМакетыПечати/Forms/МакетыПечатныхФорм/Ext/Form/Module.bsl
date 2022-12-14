#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстВыбора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуМакетовПечатныхФорм();
	Если Параметры.Свойство("ПоказыватьТолькоПользовательскиеИзмененные") Тогда
		ОтборПоИспользованиюМакета = "ИспользуемыеИзмененные";
	Иначе
		ОтборПоИспользованиюМакета = Элементы.ОтборПоИспользованиюМакета.СписокВыбора[0].Значение;
	КонецЕсли;
	
	СпрашиватьРежимОткрытияМакета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкаОткрытияМакетов", "СпрашиватьРежимОткрытияМакета", Истина);
	РежимОткрытияМакетаПросмотр = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкаОткрытияМакетов", "РежимОткрытияМакетаПросмотр", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПользовательскиеМакетыПечати" Тогда
		ОбновитьОтображениеМакетов();
	ИначеЕсли ИмяСобытия = "Запись_ТабличныйДокумент" И Источник.ВладелецФормы = ЭтотОбъект Тогда
		Макет = Параметр.ТабличныйДокумент;
		АдресМакетаВоВременномХранилище = ПоместитьВоВременноеХранилище(Макет);
		ЗаписатьМакет(Параметр.ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
		ОбновитьОтображениеМакетов()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		РежимОткрытияМакетаПросмотр = ВыбранноеЗначение.РежимОткрытияПросмотр;
		СпрашиватьРежимОткрытияМакета = НЕ ВыбранноеЗначение.БольшеНеСпрашивать;
		
		Если КонтекстВыбора = "ОткрытьМакетПечатнойФормы" Тогда
			
			Если ВыбранноеЗначение.БольшеНеСпрашивать Тогда
				СохранитьНастройкиРежимаОткрытияМакета(СпрашиватьРежимОткрытияМакета, РежимОткрытияМакетаПросмотр);
			КонецЕсли;
			
			Если РежимОткрытияМакетаПросмотр Тогда
				ОткрытьМакетПечатнойФормыДляПросмотра();
			Иначе
				ОткрытьМакетПечатнойФормыДляРедактирования();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Параметр = Новый Структура("Отказ", Ложь);
	Оповестить("ЗакрытиеФормыВладельца", Параметр, ЭтотОбъект);
	
	Если Параметр.Отказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборМакетов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМакетыПечатныхФорм

&НаКлиенте
Процедура МакетыПечатныхФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьМакетПечатнойФормы();
КонецПроцедуры

&НаКлиенте
Процедура МакетыПечатныхФормПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьМакет(Команда)
	ОткрытьМакетПечатнойФормыДляРедактирования();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакет(Команда)
	ОткрытьМакетПечатнойФормыДляПросмотра();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИзмененныйМакет(Команда)
	ПереключитьИспользованиеВыбранныхМакетов(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтандартныйМакет(Команда)
	ПереключитьИспользованиеВыбранныхМакетов(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	КонтекстВыбора = "ЗадатьДействиеПриВыбореМакетаПечатнойФормы";
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Начальное заполнение

&НаСервере
Процедура ЗаполнитьТаблицуМакетовПечатныхФорм()
	
	КоллекцииОбъектовМетаданных = Новый Массив;
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Справочники);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Документы);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Обработки);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.БизнесПроцессы);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Задачи);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ЖурналыДокументов);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Отчеты);
	
	МассивМакетовИсключений = Новый Массив;
	
	Для Каждого КоллекцияОбъектовМетаданных Из КоллекцииОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданныхКоллекции Из КоллекцияОбъектовМетаданных Цикл
			Для Каждого ОбъектМетаданныхМакет Из ОбъектМетаданныхКоллекции.Макеты Цикл
				ТипМакета = ТипМакета(ОбъектМетаданныхМакет.Имя);
				Если ТипМакета = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданныхКоллекции)
					И МакетНеВСпискеИсключений(МассивМакетовИсключений,ОбъектМетаданныхМакет.Имя) Тогда
					ДобавитьОписаниеМакета(ОбъектМетаданныхКоллекции.ПолноеИмя() + "." + ОбъектМетаданныхМакет.Имя, ОбъектМетаданныхМакет.Синоним, ОбъектМетаданныхКоллекции.Синоним, ТипМакета);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ОбъектМетаданныхМакет Из Метаданные.ОбщиеМакеты Цикл
		ТипМакета = ТипМакета(ОбъектМетаданныхМакет.Имя);
		Если ТипМакета = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если МакетНеВСпискеИсключений(МассивМакетовИсключений,ОбъектМетаданныхМакет.Имя) Тогда
		ДобавитьОписаниеМакета("ОбщийМакет." + ОбъектМетаданныхМакет.Имя, ОбъектМетаданныхМакет.Синоним, НСтр("ru = 'Общий макет'"), ТипМакета);
		КонецЕсли;
	КонецЦикла;
	
	МакетыПечатныхФорм.Сортировать("ПредставлениеМакета Возр");
	
	УстановитьФлагиИспользованияИзмененныхМакетов();
КонецПроцедуры

&НаСервере
Функция ДобавитьОписаниеМакета(ИмяОбъектаМетаданныхМакета, ПредставлениеМакета, ПредставлениеВладельца, ТипМакета)
	ОписаниеМакета = МакетыПечатныхФорм.Добавить();
	ОписаниеМакета.ТипМакета = ТипМакета;
	ОписаниеМакета.ИмяОбъектаМетаданныхМакета = ИмяОбъектаМетаданныхМакета;
	ОписаниеМакета.ПредставлениеВладельца = ПредставлениеВладельца;
	ОписаниеМакета.ПредставлениеМакета = ПредставлениеМакета;
	ОписаниеМакета.Картинка = ИндексКартинки(ТипМакета);
	ОписаниеМакета.СтрокаПоиска = ИмяОбъектаМетаданныхМакета + " "
								+ ПредставлениеВладельца + " "
								+ ПредставлениеМакета + " "
								+ ТипМакета;
	Возврат ОписаниеМакета;
КонецФункции

&НаСервере
Процедура УстановитьФлагиИспользованияИзмененныхМакетов()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ИзмененныеМакеты.ИмяМакета,
	|	ИзмененныеМакеты.Объект,
	|	ИзмененныеМакеты.Использование
	|ИЗ
	|	РегистрСведений.ПользовательскиеМакетыПечати КАК ИзмененныеМакеты";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ИзмененныеМакеты = Запрос.Выполнить().Выгрузить();
	Для Каждого Макет Из ИзмененныеМакеты Цикл
		ИмяОбъектаМетаданныхМакета = Макет.Объект + "." + Макет.ИмяМакета;
		НайденныеСтроки = МакетыПечатныхФорм.НайтиСтроки(Новый Структура("ИмяОбъектаМетаданныхМакета", ИмяОбъектаМетаданныхМакета));
		Для Каждого ОписаниеМакета Из НайденныеСтроки Цикл
			ОписаниеМакета.Изменен = Истина;
			ОписаниеМакета.ИспользуетсяИзмененный = Макет.Использование;
			ОписаниеМакета.КартинкаИспользования = Число(ОписаниеМакета.Изменен) + Число(ОписаниеМакета.ИспользуетсяИзмененный);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ТипМакета(ИмяОбъектаМетаданныхМакета)
	
	ТипыМакетов = Новый Массив;
	ТипыМакетов.Добавить("MXL");
	ТипыМакетов.Добавить("DOC");
	ТипыМакетов.Добавить("ODT");
	
	Для Каждого ТипМакета Из ТипыМакетов Цикл
		Позиция = СтрНайти(ИмяОбъектаМетаданныхМакета, "ПФ_" + ТипМакета);
		Если Позиция > 0 Тогда
			Возврат ТипМакета;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ИндексКартинки(Знач ТипМакета)
	
	ТипыМакетов = Новый Массив;
	ТипыМакетов.Добавить("DOC");
	ТипыМакетов.Добавить("ODT");
	ТипыМакетов.Добавить("MXL");
	
	Результат = ТипыМакетов.Найти(ВРег(ТипМакета));
	Возврат ?(Результат = Неопределено, -1, Результат);
	
КонецФункции 

// Отборы

&НаКлиенте
Процедура УстановитьОтборМакетов(Текст = Неопределено);
	Если Текст = Неопределено Тогда
		Текст = СтрокаПоиска;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СтрокаПоиска", СокрЛП(Текст));
	Если ОтборПоИспользованиюМакета = "Измененные" Тогда
		СтруктураОтбора.Вставить("Изменен", Истина);
	ИначеЕсли ОтборПоИспользованиюМакета = "НеИзмененные" Тогда
		СтруктураОтбора.Вставить("Изменен", Ложь);
	ИначеЕсли ОтборПоИспользованиюМакета = "ИспользуемыеИзмененные" Тогда
		СтруктураОтбора.Вставить("ИспользуетсяИзмененный", Истина);
	ИначеЕсли ОтборПоИспользованиюМакета = "НеИспользуемыеИзмененные" Тогда
		СтруктураОтбора.Вставить("ИспользуетсяИзмененный", Ложь);
		СтруктураОтбора.Вставить("Изменен", Истина);
	КонецЕсли;
	
	Элементы.МакетыПечатныхФорм.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	УстановитьОтборМакетов(Текст);
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтборМакетов();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	УстановитьОтборМакетов();
	Если Элементы.СтрокаПоиска.СписокВыбора.НайтиПоЗначению(СтрокаПоиска) = Неопределено Тогда
		Элементы.СтрокаПоиска.СписокВыбора.Добавить(СтрокаПоиска);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВидуИспользуемогоМакетаПриИзменении(Элемент)
	УстановитьОтборМакетов();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоИспользованиюМакетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОтборПоИспользованиюМакета = Элементы.ОтборПоИспользованиюМакета.СписокВыбора[0].Значение;
	УстановитьОтборМакетов();
КонецПроцедуры

// Открытие макета

&НаКлиенте
Процедура ОткрытьМакетПечатнойФормы()
	
	Если СпрашиватьРежимОткрытияМакета Тогда
		КонтекстВыбора = "ОткрытьМакетПечатнойФормы";
		ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета", , ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	Если РежимОткрытияМакетаПросмотр Тогда
		ОткрытьМакетПечатнойФормыДляПросмотра();
	Иначе
		ОткрытьМакетПечатнойФормыДляРедактирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетПечатнойФормыДляПросмотра()
	
	ТекущиеДанные = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
	ПараметрыОткрытия.Вставить("ТипМакета", ТекущиеДанные.ТипМакета);
	ПараметрыОткрытия.Вставить("ТолькоОткрытие", Истина);
	
	Если ТекущиеДанные.ТипМакета = "MXL" Тогда
		ПараметрыОткрытия.Вставить("ИмяДокумента", ТекущиеДанные.ПредставлениеМакета);
		ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетПечатнойФормыДляРедактирования()
	
	ТекущиеДанные = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
	ПараметрыОткрытия.Вставить("ТипМакета", ТекущиеДанные.ТипМакета);
	
	Если ТекущиеДанные.ТипМакета = "MXL" Тогда
		ПараметрыОткрытия.Вставить("ИмяДокумента", ТекущиеДанные.ПредставлениеМакета);
		ПараметрыОткрытия.Вставить("Редактирование", Истина);
		ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиРежимаОткрытияМакета(СпрашиватьРежимОткрытияМакета, РежимОткрытияМакетаПросмотр)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкаОткрытияМакетов",
		"СпрашиватьРежимОткрытияМакета", СпрашиватьРежимОткрытияМакета);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкаОткрытияМакетов",
		"РежимОткрытияМакетаПросмотр", РежимОткрытияМакетаПросмотр);
	
КонецПроцедуры

// Действия с макетами

&НаКлиенте
Процедура ПереключитьИспользованиеВыбранныхМакетов(ИспользуетсяИзмененный)
	ПереключаемыеМакеты = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.МакетыПечатныхФорм.ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.МакетыПечатныхФорм.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущиеДанные.Изменен Тогда
			ТекущиеДанные.ИспользуетсяИзмененный = ИспользуетсяИзмененный;
			УстановитьКартинкуИспользования(ТекущиеДанные);
			ПереключаемыеМакеты.Добавить(ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
		КонецЕсли;
	КонецЦикла;
	УстановитьИспользованиеИзмененныхМакетов(ПереключаемыеМакеты, ИспользуетсяИзмененный);
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИспользованиеИзмененныхМакетов(Макеты, ИспользуетсяИзмененный)
	
	Для Каждого ИмяОбъектаМетаданныхМакета Из Макеты Цикл
		ЧастиИмени = СтрРазделить(ИмяОбъектаМетаданныхМакета, ".");
		ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
		
		ИмяВладельца = "";
		Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
			Если Не ПустаяСтрока(ИмяВладельца) Тогда
				ИмяВладельца = ИмяВладельца + ".";
			КонецЕсли;
			ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
		КонецЦикла;
		
		Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		Запись.Объект = ИмяВладельца;
		Запись.ИмяМакета = ИмяМакета;
		Запись.Прочитать();
		Если Запись.Выбран() Тогда
			Запись.Использование = ИспользуетсяИзмененный;
			Запись.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыбранныеИзмененныеМакеты(Команда)
	УдаляемыеМакеты = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.МакетыПечатныхФорм.ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.МакетыПечатныхФорм.ДанныеСтроки(ВыделеннаяСтрока);
		ТекущиеДанные.ИспользуетсяИзмененный = Ложь;
		ТекущиеДанные.Изменен = Ложь;
		УстановитьКартинкуИспользования(ТекущиеДанные);
		УдаляемыеМакеты.Добавить(ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
	КонецЦикла;
	УдалитьИзмененныеМакеты(УдаляемыеМакеты);
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьИзмененныеМакеты(УдаляемыеМакеты)
	
	Для Каждого ИмяОбъектаМетаданныхМакета Из УдаляемыеМакеты Цикл
		ЧастиИмени = СтрРазделить(ИмяОбъектаМетаданныхМакета, ".");
		ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
		
		ИмяВладельца = "";
		Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
			Если Не ПустаяСтрока(ИмяВладельца) Тогда
				ИмяВладельца = ИмяВладельца + ".";
			КонецЕсли;
			ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
		КонецЦикла;
		
		МенеджерЗаписи = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Объект = ИмяВладельца;
		МенеджерЗаписи.ИмяМакета = ИмяМакета;
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище)
	УправлениеПечатью.ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеМакетов();
	
	УстановитьФлагиИспользованияИзмененныхМакетов();
	УстановитьДоступностьКнопокКоманднойПанели();
	
КонецПроцедуры

// Общие

&НаКлиенте
Процедура УстановитьКартинкуИспользования(ОписаниеМакета)
	ОписаниеМакета.КартинкаИспользования = Число(ОписаниеМакета.Изменен) + Число(ОписаниеМакета.ИспользуетсяИзмененный);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопокКоманднойПанели()
	
	ТекущийМакет = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	ТекущийМакетВыбран = ТекущийМакет <> Неопределено;
	ВыбраноНесколькоМакетов = Элементы.МакетыПечатныхФорм.ВыделенныеСтроки.Количество() > 1;
	
	Элементы.МакетыПечатныхФормОткрытьМакет.Доступность = ТекущийМакетВыбран И Не ВыбраноНесколькоМакетов;
	Элементы.МакетыПечатныхФормИзменитьМакет.Доступность = ТекущийМакетВыбран И Не ВыбраноНесколькоМакетов;
	
	ИспользоватьИзмененныйМакетДоступность = Ложь;
	ИспользоватьСтандартныйМакетДоступность = Ложь;
	УдалитьИзмененныйМакетДоступность = Ложь;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.МакетыПечатныхФорм.ВыделенныеСтроки Цикл
		ТекущийМакет = Элементы.МакетыПечатныхФорм.ДанныеСтроки(ВыделеннаяСтрока);
		ИспользоватьИзмененныйМакетДоступность = ТекущийМакетВыбран И ТекущийМакет.Изменен И Не ТекущийМакет.ИспользуетсяИзмененный Или ВыбраноНесколькоМакетов И ИспользоватьИзмененныйМакетДоступность;
		ИспользоватьСтандартныйМакетДоступность = ТекущийМакетВыбран И ТекущийМакет.Изменен И ТекущийМакет.ИспользуетсяИзмененный Или ВыбраноНесколькоМакетов И ИспользоватьСтандартныйМакетДоступность;
		УдалитьИзмененныйМакетДоступность = ТекущийМакетВыбран И ТекущийМакет.Изменен Или ВыбраноНесколькоМакетов И УдалитьИзмененныйМакетДоступность;
	КонецЦикла;
	
	Элементы.МакетыПечатныхФормИспользоватьИзмененныйМакет.Доступность = ИспользоватьИзмененныйМакетДоступность;
	Элементы.МакетыПечатныхФормИспользоватьСтандартныйМакет.Доступность = ИспользоватьСтандартныйМакетДоступность;
	Элементы.МакетыПечатныхФормУдалитьИзмененныйМакет.Доступность = УдалитьИзмененныйМакетДоступность;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МакетНеВСпискеИсключений(МассивМакетовИсключений,ИмяМакета)
	
	Если МассивМакетовИсключений.Количество() = 0 Тогда
		МассивМакетовИсключений = ПолучитьМассивМакетовИсключений();
	КонецЕсли;
	
	Если МассивМакетовИсключений.Найти(ИмяМакета) = Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМассивМакетовИсключений()
	
	МассивМакетовИсключений = Новый Массив;
	МассивМакетовИсключений.Добавить("ПФ_MXL_СправкаПоРасчетуСуммыДоплатыПособия");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Доверенность");
	МассивМакетовИсключений.Добавить("ПФ_MXL_415АПК");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ДоплатаЗаДниНетрудоспособности");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ЗаявлениеВФССОВыплатеПособия_2012");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ЗаявлениеВФССОВыплатеПособия_2017");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2012");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2017");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Запрос");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Заявление");
	МассивМакетовИсключений.Добавить("ПФ_MXL_РасчетПособия");
	МассивМакетовИсключений.Добавить("ПФ_MXL_РеестрПеречисленныхСуммНДФЛ");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Т51");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Т49");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СправкаОСреднемЗаработкеДляПособияПоБезработице");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТрудовойДоговорМикропредприятий");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Т4");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_11");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_2");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_3");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_6_1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_6_1_2017");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_6_2");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаАДВ_6_4");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Реестр");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Реестр2016");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаОДВ_1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаКНД1151087");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСЗВ_6_3");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСЗВ_ИСХ");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСЗВ_К");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСЗВ_КОРР");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСЗВ_СТАЖ");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСПВ_1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ФормаСПВ_2");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Т9а");
	МассивМакетовИсключений.Добавить("ПФ_MXL_Т10а");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СправкаДляОплатыОтпускаЧАЭС");
	
	МассивМакетовИсключений.Добавить("ПФ_MXL_АвансовыйОтчет");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ15");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ16");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ИНВ1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ИНВ18");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ИНВ22");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактураКорректировочный1137");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактура1137_625");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактураКорректировочный1137_625");
	МассивМакетовИсключений.Добавить("ПФ_MXL_М15");
	МассивМакетовИсключений.Добавить("ПФ_MXL_МБ7");
	МассивМакетовИсключений.Добавить("ПФ_MXL_МБ8");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС14");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС1а");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС1б");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС2");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС3");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС4");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС4а");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС4б");
	МассивМакетовИсключений.Добавить("ПФ_MXL_РасчетныйЛистокНастраиваемый");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СправкаОДивидендах");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактура1137_625");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактура1137");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактура981");
	МассивМакетовИсключений.Добавить("ПФ_MXL_СчетФактура451");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ1");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ12");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ12_ГТД");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ3");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ТОРГ4");
	МассивМакетовИсключений.Добавить("ПФ_MXL_УниверсальныйКорректировочныйДокумент");
	МассивМакетовИсключений.Добавить("ПФ_MXL_УниверсальныйКорректировочныйДокумент981");
	МассивМакетовИсключений.Добавить("ПФ_MXL_УниверсальныйКорректировочныйДокумент_625");
	МассивМакетовИсключений.Добавить("ПФ_MXL_УниверсальныйПередаточныйДокумент");
	МассивМакетовИсключений.Добавить("ПФ_MXL_УниверсальныйПередаточныйДокумент981");
	МассивМакетовИсключений.Добавить("ПФ_MXL_УниверсальныйПередаточныйДокумент_625");
	МассивМакетовИсключений.Добавить("ПФ_MXL_ОС6");
	
	Возврат МассивМакетовИсключений;
	
КонецФункции

#КонецОбласти
