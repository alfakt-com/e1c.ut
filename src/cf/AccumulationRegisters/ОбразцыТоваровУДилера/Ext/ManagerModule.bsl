
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Записывает данные документы в регистр сведений ДанныеВнутреннихДокументов
//
// Параметры:
//  Ссылка					 - ДокументСсылка - 
//  ДополнительныеСвойства	 - Структура - содержит по ключу ТаблицыДляДвижений структуру
//  										имеющую ключ ТаблицаРеестрДокументов (ТаблицаЗначений)
//  Отказ					 - Булево - 
//
Процедура ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаТоваров = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОбразцыТоваровУДилера;
	
	СкладОбразцов = Справочники.Склады.НайтиПоРеквизиту("ВидСклада",Перечисления.ВидыСкладов.Образцы);
	
	Если Ссылка.СкладОтправитель = СкладОбразцов Или Ссылка.СкладПолучатель = СкладОбразцов Тогда
		//Если ТаблицаТоваров.Количество > 0 Тогда
			УстановитьПривилегированныйРежим(Истина);
			
			Если Ссылка.СкладОтправитель = СкладОбразцов Тогда
				ВидДвижения = ВидДвиженияНакопления.Расход;
			Иначе 
				ВидДвижения = ВидДвиженияНакопления.Приход;
			КонецЕсли;	
			
			Набор = РегистрыНакопления.ОбразцыТоваровУДилера.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Ссылка);
			Набор.Прочитать();
			
			Для Каждого Строка Из ТаблицаТоваров Цикл
				// добавление новых записей
				Движение = Набор.Добавить();
				Движение.ВидДвижения = ВидДвижения;			
				Движение.Подразделение = Строка.Подразделение;
				Движение.Дилер = Строка.Дилеры;
				Движение.СкладОтправитель =  Строка.СкладОтправитель;
				Движение.СкладПолучатель = Строка.СкладПолучатель;
				Движение.Номенклатура = Строка.Номенклатура;
				Движение.Количество = Строка.Количество;
				Движение.Период = Ссылка.Дата;
				Движение.Регистратор =  Ссылка;
			КонецЦикла;
			
			Набор.Записать(Истина);
			УстановитьПривилегированныйРежим(Ложь);
			
		//КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
