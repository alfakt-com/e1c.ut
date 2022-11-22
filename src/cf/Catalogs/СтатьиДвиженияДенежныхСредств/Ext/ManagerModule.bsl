﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает статью движения денежных средств для выбранной хозяйственной операции.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа.
//
// Возвращаемое значение:
// 	СправочникСсылка.СтатьиДвиженияДенежныхСредств - Найденная статья ДДС.
//
Функция СтатьяДвиженияДенежныхСредствПоХозяйственнойОперации(ХозяйственнаяОперация) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 2
		|	СтатьиДвиженияДенежныхСредств.Ссылка КАК СтатьяДвиженияДенежныхСредств
		|ИЗ
		|	Справочник.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперации КАК СтатьиДвиженияДенежныхСредствХозяйственныеОперации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредств
		|		ПО СтатьиДвиженияДенежныхСредствХозяйственныеОперации.Ссылка = СтатьиДвиженияДенежныхСредств.Ссылка
		|			И (НЕ СтатьиДвиженияДенежныхСредств.ПометкаУдаления)
		|			И (СтатьиДвиженияДенежныхСредствХозяйственныеОперации.ХозяйственнаяОперация = &ХозяйственнаяОперация)");
	
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		СтатьяДвиженияДенежныхСредств = Выборка.СтатьяДвиженияДенежныхСредств;
	Иначе
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	КонецЕсли;
	
	Возврат СтатьяДвиженияДенежныхСредств;

КонецФункции

// Получает предопределенную статью движения денежных средств для выбранной хозяйственной операции.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа
//	Валюта - СправочникСсылка.Валюты - Валюта документа.
//
// Возвращаемое значение:
// 	СправочникСсылка.СтатьиДвиженияДенежныхСредств - Предопределенная статья ДДС.
//
Функция ПредопределеннаяСтатьяДДС(ХозяйственнаяОперация, Валюта = Неопределено) Экспорт
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствИзБанка
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		Если Не ЗначениеЗаполнено(Валюта)
		 ИЛИ Валюта = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
			СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанка;
		Иначе
			СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанкаВИностраннойВалюте;
		КонецЕсли;
			
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыНаРасчетныйСчет Тогда
		Если Не ЗначениеЗаполнено(Валюта)
		 ИЛИ Валюта = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
			СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанк;
		Иначе
			СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанкВИностраннойВалюте;
		КонецЕсли;
		
	Иначе
		Соответствие = Новый Соответствие;
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу, 
			Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию, 
			Справочники.СтатьиДвиженияДенежныхСредств.ОплатаДенежныхСредствВДругуюОрганизацию);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);	

		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет,
			Справочники.СтатьиДвиженияДенежныхСредств.ПеречислениеДенежныхСредствНаДругойСчет);

		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации,
			Справочники.СтатьиДвиженияДенежныхСредств.ОплатаДенежныхСредствВДругуюОрганизацию);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу);

		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВКассуККМ);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ,
			Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМ);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыРаздатчиком,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыРаботнику,
			Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.КурсовыеРазницыДСПрибыль,
			Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыПрибыль);
			
		Соответствие.Вставить(Перечисления.ХозяйственныеОперации.КурсовыеРазницыДСУбыток,
			Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыУбыток);
		
		СтатьяДвиженияДенежныхСредств = Соответствие.Получить(ХозяйственнаяОперация);
	КонецЕсли; 
	
	Если СтатьяДвиженияДенежныхСредств = Неопределено Тогда
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	КонецЕсли;
	
	Возврат СтатьяДвиженияДенежныхСредств;
	
КонецФункции

// Получает список хозяйственных операций соответствующих расходу денежных средств.
//
// Возвращаемое значение:
// 	Массив - массив хозяйственных операций.
//
Функция ХозяйственныеОперацииРасходаДенежныхСредств() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиХозяйственныхОпераций.ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|ГДЕ
	|	НастройкиХозяйственныхОпераций.Расход = ЗНАЧЕНИЕ(Перечисление.ТипыДанныхУчета.ДенежныеСредства)
	|	И НастройкиХозяйственныхОпераций.Приход <> ЗНАЧЕНИЕ(Перечисление.ТипыДанныхУчета.ПустаяСсылка)
	|	И НастройкиХозяйственныхОпераций.ХозяйственнаяОперация НЕ В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыРаботнику),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыРаздатчиком),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты)"); 
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ХозяйственнаяОперация");
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТолькоРасходДенежныхСредств") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиХозяйственныхОпераций.ХозяйственнаяОперация КАК Ссылка
		|ПОМЕСТИТЬ ХозяйственныеОперацииРасхода 
		|ИЗ
		|	Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
		|ГДЕ
		|	НастройкиХозяйственныхОпераций.Расход = ЗНАЧЕНИЕ(Перечисление.ТипыДанныхУчета.ДенежныеСредства)
		|	И НастройкиХозяйственныхОпераций.Приход <> ЗНАЧЕНИЕ(Перечисление.ТипыДанныхУчета.ПустаяСсылка)
		|	
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|/////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтатьиДвиженияДенежныхСредствХозОперации.Ссылка
		|ИЗ
		|	Справочник.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперации КАК СтатьиДвиженияДенежныхСредствХозОперации
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		ХозяйственныеОперацииРасхода КАК ХозяйственныеОперацииРасхода
		|	ПО
		|		СтатьиДвиженияДенежныхСредствХозОперации.ХозяйственнаяОперация = ХозяйственныеОперацииРасхода.Ссылка");
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
	ИначеЕсли Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("ХозяйственнаяОперация") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДанныеСправочника.Ссылка
		|ИЗ
		|	Справочник.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперации КАК ДанныеСправочника
		|ГДЕ
		|	ДанныеСправочника.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И (ДанныеСправочника.Ссылка.Наименование ПОДОБНО &СтрокаПоиска ИЛИ &СтрокаПоискаНеЗадана)
		|";
		
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", Параметры.Отбор.ХозяйственнаяОперация);
		
		СтрокаПоиска = "";
		Если Параметры.Свойство("СтрокаПоиска") Тогда
			СтрокаПоиска = Параметры.СтрокаПоиска;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("СтрокаПоискаНеЗадана", Не ЗначениеЗаполнено(СтрокаПоиска));
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		Если Параметры.Свойство("Отбор")
			И Параметры.Отбор.Свойство("ХозяйственнаяОперация")
			И ТипЗнч(Параметры.Отбор.ХозяйственнаяОперация) = Тип("ПеречислениеСсылка.ХозяйственныеОперации") Тогда
			ВыбраннаяФорма = "ФормаВыбораПоХозяйственнойОперации";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьПредопределенныеСтатьиДвиженияДенежныхСредств(СтатьяДДС = Неопределено) Экспорт
	
	Соответствие = Новый Соответствие;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу,
				"1010",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ОплатаПоставщику,
				"3310",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПеречислениеДенежныхСредствНаДругойСчет ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПеречислениеДенежныхСредствНаДругойСчет,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет,
				"1030",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанка ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанка,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка,
				"1030",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанкаВИностраннойВалюте ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзБанкаВИностраннойВалюте,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка,
				"1030",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента,
				"1210",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанк ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанк,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк,
				"1030",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанкВИностраннойВалюте ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.СдачаДенежныхСредствВБанкВИностраннойВалюте,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк,
				"1030",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаДенежныхСредствВДругуюОрганизацию ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ОплатаДенежныхСредствВДругуюОрганизацию,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию,
				"3310",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВКассуККМ ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВКассуККМ,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ,
				"1010",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМ ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствИзКассыККМ,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ,
				"1010",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВыплатаЗаработнойПлаты,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты,
				"3350",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствОтПоставщика ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствОтПоставщика,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика,
				"3310",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиенту ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиенту,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту,
				"1210",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыПрибыль ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыПрибыль,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.КурсовыеРазницыДСПрибыль,
				"6250",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыУбыток ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыУбыток,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.КурсовыеРазницыДСУбыток,
				"7430",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствОтДругойОрганизации ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеДенежныхСредствОтДругойОрганизации,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации,
				"1210",));
	КонецЕсли;
	Если СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствОтДругойОрганизации ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС) Тогда
		Соответствие.Вставить(Справочники.СтатьиДвиженияДенежныхСредств.ВозвратДенежныхСредствОтДругойОрганизации ,
			Новый Структура("ХозяйственнаяОперация, КорреспондирующийСчет",
				Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации,
				"3310",));
	КонецЕсли;
	
	Для Каждого Элемент Из Соответствие Цикл
	
		СтатьяДДСОбъект = Элемент.Ключ.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(СтатьяДДСОбъект, Элемент.Значение);
		Если СтатьяДДСОбъект.ХозяйственныеОперации.Найти(Элемент.Значение.ХозяйственнаяОперация) = Неопределено Тогда
			СтатьяДДСОбъект.ХозяйственныеОперации.Добавить().ХозяйственнаяОперация = Элемент.Значение.ХозяйственнаяОперация;
		КонецЕсли;
		Попытка
			СтатьяДДСОбъект.Записать();
		Исключение
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Справочник %1 не записан, произошли ошибки при записи!'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				СтатьяДДСОбъект);
			ОписаниеОшибки = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


