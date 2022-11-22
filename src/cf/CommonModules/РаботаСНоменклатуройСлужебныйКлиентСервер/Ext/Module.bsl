﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройСлужебныйКлиентСервер.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Сброс представления объекта сервиса на формах объектов информационной базы.
//
// Параметры:
//  Форма								 - УправляемаяФорма - обрабатываемая форма.
//  ПодсказкаВвода						 - Строка - подсказка ввода для поля объекта сервиса.
//  ПредставлениеПустогоОбъектСервиса	 - Строка - представление пустого объекта.
//
Процедура СброситьДанныеОбъектаСервиса(Форма, ЭлементФормы, ПредставлениеПустогоОбъектСервиса) Экспорт
	
	Форма.ИдентификаторОбъектаСервиса = "";
	Форма.Модифицированность = Истина;
	
	Если Форма.РаботаСНоменклатурой_РежимПредставленияОбъектаСервиса = "ПолеВвода" Тогда
		ЭлементФормы.ПодсказкаВвода = ПредставлениеПустогоОбъектСервиса;
	Иначе
		Форма.ПредставлениеОбъектаСервиса = Новый ФорматированнаяСтрока(НСтр("ru = 'Выбрать'"),,,,"Выбрать");
		НастроитьВидимостьГиперссылок(Форма);
	КонецЕсли;
		
КонецПроцедуры	

// Представление пустой категории на форме вида номенклатуры.
// 
// Возвращаемое значение:
//   Строка - представление категории.
//
Функция ПредставлениеПустойКатегории(Назначение = "ПолеВвода") Экспорт
	
	Если Назначение = "ПолеВвода" Тогда
		Возврат НСтр("ru = 'Выберите категорию из сервиса'");
	Иначе
		Возврат НСтр("ru = 'Выбрать'");
	КонецЕсли;
		
КонецФункции

// Представление пустой номенклатуры сервиса на форме номенклатуры.
// 
// Возвращаемое значение:
//   Строка - представление номенклатуры.
//
Функция ПредставлениеПустойНоменклатуры(Назначение = "ПолеВвода") Экспорт
	
	Если Назначение = "ПолеВвода" Тогда
		Возврат НСтр("ru = 'Выберите номенклатуру из сервиса'");
	Иначе
		Возврат НСтр("ru = 'Выбрать'");
	КонецЕсли;
		
КонецФункции

// Статусы проверки номенклатуры перед ее загрузкой.
// 
// Возвращаемое значение:
//   Структура - в качестве значения, представление статуса в интерфейсе.
//
Функция СтатусыПроверкиНоменклатуры() Экспорт
	
	Статусы = Новый Структура();
	
	// Статусы готовых к загрузке
	
	Статусы.Вставить("ГотоваКЗагрузке",                     НСтр("ru = '<Номенклатура готова к загрузке>'"));
	Статусы.Вставить("ИндивидуальныеХарактеристики",        НСтр("ru = '<Используются индивидуальные характеристики>'"));
	Статусы.Вставить("ХарактеристикиНеИспользуются",        НСтр("ru = '<Характеристики не используются>'"));
	
	// Статусы для анализа
	
	Статусы.Вставить("НеСопоставленаКатегория",             НСтр("ru = '<Вид номенклатуры не сопоставлен>'"));
	Статусы.Вставить("НесколькоВидовНоменклатуры",          НСтр("ru = '<Выбрано несколько видов номенклатуры>'"));
	Статусы.Вставить("ХарактеристикиГрузятсяВДопРеквизиты", НСтр("ru = '<Характеристики загружаются в дополнительные реквизиты>'"));
	Статусы.Вставить("НеВсеРеквизитыСопоставлены",          НСтр("ru = '<Не все доп. реквизиты сопоставлены>'"));
	Статусы.Вставить("БольшоеКоличествоХарактеристик",      НСтр("ru = '<Количество характеристик более 1000>'"));
	
	Возврат Статусы;
	
КонецФункции

// Состояния сервиса.
// 
// Возвращаемое значение:
// Структура - Ключ - параметр, Значение - значение по-умолчанию.
//
Функция ОписаниеСостоянияСервиса() Экспорт 
	
	Состояние = Новый Структура();
	Состояние.Вставить("ПодключенаИнтернетПоддержка", Ложь);
	Состояние.Вставить("ЕстьДоступныеОпции",          Ложь);
	Состояние.Вставить("ДоступенСтартовыйПакет",      Ложь);
	Состояние.Вставить("ОшибкаОпределенияСостояния",  Ложь);
	
	Возврат Состояние;
	
КонецФункции

// Детализация ошибки при покупке карточек номенклатуры.
// 
// Возвращаемое значение:
//   Структура - Ключ - параметр, Значение - значение по-умолчанию.
//
Функция ОписаниеОшибкиПокупкиНоменклатуры() Экспорт 
	
	Ошибка = Новый Структура();
	Ошибка.Вставить("ПокупаемоеКоличество", 0);
	Ошибка.Вставить("ДоступныйОстаток",     0);
	
	Возврат Ошибка;
	
КонецФункции

// Параметры процедуры создания номенклатуры.
// 
// Возвращаемое значение:
// Структура - Ключ - параметр, Значение - значение по-умолчанию.
//
Функция ОписаниеПараметровСозданияПроцедуры() Экспорт
	
	ПараметрыПроцедуры = Новый Структура();
	
	ПараметрыПроцедуры.Вставить("ИдентификаторыНоменклатуры",           Новый Массив);
	ПараметрыПроцедуры.Вставить("КонтролироватьНастройкиХарактеристик", Истина);
	ПараметрыПроцедуры.Вставить("СохранятьХарактеристикиВНаименование", Ложь);
	ПараметрыПроцедуры.Вставить("СохранятьХарактеристики",              Истина);
	ПараметрыПроцедуры.Вставить("СохранятьДополнительныеРеквизиты",     Истина);
	
	Возврат ПараметрыПроцедуры;
	
КонецФункции

// Идентификатор сервиса 1С:Номенклатура.
// 
// Возвращаемое значение:
//   Строка - идентификатор сервиса.
//
Функция ИдентификаторСервиса() Экспорт 
	
	Возврат "1C-Nomenclature";
	
КонецФункции

// Заголовок гиперссылки режима обновления
//
// Параметры:
//  АвтоматическийРежимОбновления	 - Булево - Истина если режим автоматического обновления.
// 
// Возвращаемое значение:
//  Строка - заголовок.
//
Функция ЗаголовокГиперссылкиРежимаОбновления(АвтоматическийРежимОбновления) Экспорт
	
	Возврат СтрШаблон(НСтр("ru = 'Обновлять %1'"), ?(АвтоматическийРежимОбновления, "автоматически", "вручную"));
	
КонецФункции

// Настройка отображения гиперссылок.
//
// Параметры:
//  Форма	 - УправляемаяФорма - управляемая форма.
//
Процедура НастроитьВидимостьГиперссылок(Форма) Экспорт
	
	Форма.Элементы.РаботаСНоменклатурой_ОчиститьОбъектСервиса.Видимость = ЗначениеЗаполнено(Форма.ИдентификаторОбъектаСервиса);
	Форма.Элементы.РаботаСНоменклатурой_ОбновитьСейчас.Видимость = ЗначениеЗаполнено(Форма.ИдентификаторОбъектаСервиса);
	Форма.Элементы.РежимОбновления.Видимость = ЗначениеЗаполнено(Форма.ИдентификаторОбъектаСервиса);	
	Форма.Элементы.РежимОбновления.Заголовок = ЗаголовокГиперссылкиРежимаОбновления(Форма.ОбновляетсяАвтоматически);
	
КонецПроцедуры

#КонецОбласти
