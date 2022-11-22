﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ОписаниеОперацийИТиповДокументов(ТЗХозОперацииИТипыДокументов) Экспорт
	
	#Область СборкаТоваров
	
	СтрокаСборкаТоваров = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка = СтрокаСборкаТоваров;
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.СборкаТоваров;
	Строка.КлючНазначенияИспользования	= "СборкиРазборкиТоваров";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (сборки товаров)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.СборкаТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.СборкаТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыСборокТоваров");
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовВнутреннегоТовародвижения";
	Строка.КлючевыеПоляШапки			= Документы.СборкаТоваров.КлючевыеПоляШапкиРаспоряжения();
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление сборки товаров по выбранным распоряжениям'");
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаСборкаТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.РазборкаТоваров;
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (разборки товаров)'");
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление разборки товаров по выбранным распоряжениям'");
	
	#КонецОбласти
	
	#Область ВнутреннееПотреблениеТоваров
	
	СтрокаВнутреннееПотреблениеТоваров = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка = СтрокаВнутреннееПотреблениеТоваров;
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию;
	Строка.КлючНазначенияИспользования	= "ВнутренниеПотребленияТоваров";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (внутренние потребления товаров)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ВнутреннееПотреблениеТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= Ложь;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовВнутреннегоТовародвижения";
	Строка.КлючевыеПоляШапки			= Документы.ВнутреннееПотреблениеТоваров.КлючевыеПоляШапкиРаспоряжения();
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление списания товаров по выбранным распоряжениям'");
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаВнутреннееПотреблениеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию;
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление передачи в эксплуатацию по выбранным распоряжениям'");
	
	#КонецОбласти
	
	#Область ПеремещениеТоваров
	
	СтрокаПеремещениеТоваров = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка = СтрокаПеремещениеТоваров;
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
	Строка.КлючНазначенияИспользования	= "ПеремещенияТоваров";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (перемещения товаров)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.ПеремещениеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПеремещениеТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыПеремещенийТоваров");
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовВнутреннегоТовародвижения";
	Строка.КлючевыеПоляШапки			= Документы.ПеремещениеТоваров.КлючевыеПоляШапкиРаспоряжения();
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление перемещения товаров по выбранным распоряжениям'");
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаПеремещениеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами;
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление перемещения товаров между филиалами по выбранным распоряжениям'");
	
	#КонецОбласти
	
	#Область АктОРасхожденияхПослеПеремещения
	
	СтрокаАктОРасхожденияхПослеПеремещения = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка = СтрокаАктОРасхожденияхПослеПеремещения;
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
	Строка.КлючНазначенияИспользования	= "АктыОРасхожденияхПослеПеремещения";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (акты о расхождениях после перемещения)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.АктОРасхожденияхПослеПеремещения");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.АктОРасхожденияхПослеПеремещения.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= Истина;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаАктОРасхожденияхПослеПеремещения);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами;
	
	#КонецОбласти
	
	#Область ПрочееОприходованиеТоваров
	
	СтрокаПрочееОприходованиеТоваров = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка = СтрокаПрочееОприходованиеТоваров;
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.ПоступлениеИзПроизводства;
	Строка.КлючНазначенияИспользования	= "ПрочиеОприходованияТоваров";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (прочие оприходования товаров)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.ПрочееОприходованиеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПрочееОприходованиеТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= Ложь;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовВнутреннегоТовародвижения";
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаПрочееОприходованиеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации;
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаПрочееОприходованиеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "";
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаПрочееОприходованиеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОприходованиеЗаСчетДоходов;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "";
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаПрочееОприходованиеТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОприходованиеЗаСчетРасходов;
	
	#КонецОбласти
	
	#Область СкладскиеАкты
	
	// Оприходование излишков товаров.
	СтрокаСкладскиеАкты = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка = СтрокаСкладскиеАкты;
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.ОприходованиеТоваров;
	Строка.КлючНазначенияИспользования	= "";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (складские акты)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.ОприходованиеИзлишковТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ОприходованиеИзлишковТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= Ложь;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналСкладскихАктов";
	
	// Пересортица товаров.
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаСкладскиеАкты);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПересортицаТоваров;
	Строка.ТипДокумента					= Тип("ДокументСсылка.ПересортицаТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПересортицаТоваров.ПолноеИмя();
	
	// Порча товаров.
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаСкладскиеАкты);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПорчаТоваров;
	Строка.ТипДокумента					= Тип("ДокументСсылка.ПорчаТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПорчаТоваров.ПолноеИмя();
	
	// Порча товаров с переоценкой.
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаСкладскиеАкты);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПорчаТоваровСПереоценкой;
	Строка.ТипДокумента					= Тип("ДокументСсылка.ПорчаТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПорчаТоваров.ПолноеИмя();
	
	// Списание недостач товаров.
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаСкладскиеАкты);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.СписаниеТоваров;
	Строка.ТипДокумента					= Тип("ДокументСсылка.СписаниеНедостачТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.СписаниеНедостачТоваров.ПолноеИмя();
	
	#КонецОбласти
	
	
	Возврат ТЗХозОперацииИТипыДокументов;
	
КонецФункции

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	ТекстГиперссылки = НСтр("ru = 'Накладные'");
	ИмяФормыРабочееМесто = "Обработка.ЖурналДокументовВнутреннегоТовародвижения.Форма.СписокДокументовКОформлению";
	
	Если ЕстьДокументыКОформлению(Параметры) Тогда
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,,, ИмяФормыРабочееМесто);
	Иначе
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,ЦветаСтиля.НезаполненноеПолеТаблицы,, ИмяФормыРабочееМесто);
	КонецЕсли;
	
КонецФункции

Процедура СформироватьГиперссылкуКОформлениюФоновоеЗадание(Параметры, АдресХранилища) Экспорт
	
	КОформлению = ОбщегоНазначенияУТ.СформироватьГиперссылкуКОформлению(Параметры[0], Параметры[1]);
	ПоместитьВоВременноеХранилище(КОформлению, АдресХранилища);
	
КонецПроцедуры

Функция ЕстьДокументыКОформлению(Параметры) Экспорт
	
	ПараметрыОтбора = НакладныеСервер.ПараметрыОтбораРаспоряжений(Параметры.Организация,, Параметры.Склад, 
		Параметры.ОтборХозяйственныеОперации, Параметры.Менеджер);
	
	Состояния = НакладныеСервер.СостоянияПоХозоперациям(Параметры.ОтборХозяйственныеОперации.ВыгрузитьЗначения());
	Если Не ЗначениеЗаполнено(Состояния) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Пакет = Новый Массив;
	Выборка = Новый Массив;
	Для каждого КЗ Из Состояния Цикл
		Пакет.Добавить(НакладныеСервер.ТекстЗапросаСостояний(КЗ.Ключ, ПараметрыОтбора, КЗ.Значение, Истина));
		
		Выборка.Добавить(
			"ВЫБРАТЬ
			|	КОформлению
			|ИЗ ВТ" + КЗ.Ключ);
	КонецЦикла;
	
	Пакет.Добавить(СтрСоединить(Выборка, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении()));
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		СписокОрганизаций = Справочники.Организации.ФилиалыСРасчетамиЧерезГоловнуюОрганизацию(Параметры.Организация);
		СписокОрганизаций.Добавить(Параметры.Организация);
	Иначе
		СписокОрганизаций = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос(СтрСоединить(Пакет, ОбщегоНазначенияУТ.РазделительЗапросовВПакете()));
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Организация",       СписокОрганизаций);
	Запрос.УстановитьПараметр("Склад",             Параметры.Склад);
	Запрос.УстановитьПараметр("Менеджер",          Параметры.Менеджер);
	Запрос.УстановитьПараметр("ХозОперация",       Параметры.ОтборХозяйственныеОперации.ВыгрузитьЗначения());
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция КоличествоСтрокКОформлению(ХозОперации) Экспорт
	
	ПараметрыОтбора = НакладныеСервер.ПараметрыОтбораРаспоряжений(,,, ХозОперации);
	
	Пакет = Новый Массив;
	Выборка = Новый Массив;
	Состояния = НакладныеСервер.СостоянияПоХозоперациям(ХозОперации);
	Для каждого КЗ Из Состояния Цикл
		Пакет.Добавить(НакладныеСервер.ТекстЗапросаСостояний(КЗ.Ключ, ПараметрыОтбора, КЗ.Значение));
		
		Если КЗ.Ключ = "СостоянияРасходныхОрдеров" Тогда
			Выборка.Добавить(
			"ВЫБРАТЬ
			|	СостоянияРасходныхОрдеров.Распоряжение КАК Распоряжение,
			|	СостоянияРасходныхОрдеров.Склад КАК Склад,
			|	СостоянияРасходныхОрдеров.Склад КАК Отправитель,
			|	ВЫБОР
			|		КОГДА СостоянияРасходныхОрдеров.Распоряжение ССЫЛКА Документ.ЗаказНаВнутреннееПотребление
			|			ТОГДА НЕОПРЕДЕЛЕНО
			|		ИНАЧЕ СостоянияРасходныхОрдеров.Получатель
			|	КОНЕЦ КАК Получатель,
			|	ВЫБОР
			|		КОГДА ИСТИНА
			|			ТОГДА NULL
			|	КОНЕЦ КАК ХозОперация
			|ИЗ
			|	ВТСостоянияРасходныхОрдеров КАК СостоянияРасходныхОрдеров");
		ИначеЕсли КЗ.Ключ = "СостоянияПриходныхОрдеров" Тогда
			Выборка.Добавить(
			"ВЫБРАТЬ
			|	СостоянияПриходныхОрдеров.Распоряжение КАК Распоряжение,
			|	СостоянияПриходныхОрдеров.Склад КАК Склад,
			|	ВЫБОР
			|		КОГДА СостоянияПриходныхОрдеров.Распоряжение ССЫЛКА Документ.ПрочееОприходованиеТоваров
			|			ТОГДА НЕОПРЕДЕЛЕНО
			|		ИНАЧЕ СостоянияПриходныхОрдеров.Отправитель
			|	КОНЕЦ КАК Отправитель,
			|	СостоянияПриходныхОрдеров.Склад КАК Получатель,
			|	ВЫБОР
			|		КОГДА ИСТИНА
			|			ТОГДА NULL
			|	КОНЕЦ КАК ХозОперация
			|ИЗ
			|	ВтСостоянияПриходныхОрдеров КАК СостоянияПриходныхОрдеров
			|ГДЕ
			|	НЕ СостоянияПриходныхОрдеров.Распоряжение ССЫЛКА Документ.ЗаказНаПеремещение
			|	И НЕ СостоянияПриходныхОрдеров.Распоряжение ССЫЛКА Документ.ПеремещениеТоваров
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СостоянияПриходныхОрдеров.Распоряжение,
			|	СостоянияПриходныхОрдеров.Отправитель,
			|	СостоянияПриходныхОрдеров.Отправитель,
			|	СостоянияПриходныхОрдеров.Склад,
			|	NULL
			|ИЗ
			|	ВтСостоянияПриходныхОрдеров КАК СостоянияПриходныхОрдеров
			|ГДЕ
			|	(СостоянияПриходныхОрдеров.Распоряжение ССЫЛКА Документ.ЗаказНаПеремещение
			|			ИЛИ СостоянияПриходныхОрдеров.Распоряжение ССЫЛКА Документ.ПеремещениеТоваров)
			|	И &ИспользуютсяАктыРасхожденийПослеПеремещения");
		ИначеЕсли КЗ.Ключ = "СостоянияПеремещений" Тогда
			Выборка.Добавить(
			"ВЫБРАТЬ
			|	СостоянияПеремещений.Распоряжение КАК Распоряжение,
			|	ДокЗаказНаПеремещение.СкладОтправитель КАК Склад,
			|	ДокЗаказНаПеремещение.СкладОтправитель КАК Отправитель,
			|	ДокЗаказНаПеремещение.СкладПолучатель КАК Получатель,
			|	NULL КАК ХозОперация
			|ИЗ
			|	ВтСостоянияПеремещений КАК СостоянияПеремещений
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПеремещение КАК ДокЗаказНаПеремещение
			|		ПО СостоянияПеремещений.Распоряжение = ДокЗаказНаПеремещение.Ссылка");
		ИначеЕсли КЗ.Ключ = "СостоянияСборок" Тогда
			Выборка.Добавить(
			"ВЫБРАТЬ
			|	СостоянияСборок.Распоряжение КАК Распоряжение,
			|	ДокЗаказНаСборку.Склад КАК Склад,
			|	ДокЗаказНаСборку.Склад КАК Отправитель,
			|	ДокЗаказНаСборку.Склад КАК Получатель,
			|	NULL КАК ХозОперация
			|ИЗ
			|	ВтСостоянияСборок КАК СостоянияСборок
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаСборку КАК ДокЗаказНаСборку
			|		ПО СостоянияСборок.Распоряжение = ДокЗаказНаСборку.Ссылка");
		ИначеЕсли КЗ.Ключ = "СостоянияВнутреннихПотреблений" Тогда
			Выборка.Добавить(
			"ВЫБРАТЬ
			|	СостоянияВнутреннихПотреблений.Распоряжение КАК Распоряжение,
			|	СостоянияВнутреннихПотреблений.Склад КАК Склад,
			|	СостоянияВнутреннихПотреблений.Склад КАК Отправитель,
			|	НЕОПРЕДЕЛЕНО КАК Получатель,
			|	ВЫБОР
			|		КОГДА ИСТИНА
			|			ТОГДА NULL
			|	КОНЕЦ КАК ХозОперация
			|ИЗ
			|	ВтСостоянияВнутреннихПотреблений КАК СостоянияВнутреннихПотреблений");
		КонецЕсли;
		
	КонецЦикла;
	
	Пакет.Добавить(
		СтрЗаменить(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВложенныйЗапрос.Распоряжение КАК Распоряжение,
		|	ВложенныйЗапрос.Склад КАК Склад,
		|	ВложенныйЗапрос.Отправитель КАК Отправитель,
		|	ВложенныйЗапрос.Получатель КАК Получатель,
		|	ВложенныйЗапрос.ХозОперация КАК ХозОперация
		|ИЗ
		|	ТекстЗапросаВложенный КАК ВложенныйЗапрос",
		"ТекстЗапросаВложенный", "(" + СтрСоединить(Выборка, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении()) + ")"));
	
	Запрос = Новый Запрос(СтрСоединить(Пакет, ОбщегоНазначенияУТ.РазделительЗапросовВПакете()));
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ХозОперация", ХозОперации);
	Запрос.УстановитьПараметр("ИспользуютсяАктыРасхожденийПослеПеремещения",
		ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеПеремещения"));
	
	Возврат Запрос.Выполнить().Выбрать().Количество();
	
КонецФункции

#КонецОбласти

#КонецЕсли
