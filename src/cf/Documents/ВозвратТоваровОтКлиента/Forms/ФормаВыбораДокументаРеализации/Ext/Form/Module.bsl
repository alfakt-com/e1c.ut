
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ЗначениеПараметраЗаголовок;
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.ЗагрузитьЗначения(Параметры.СписокДокументов.ВыгрузитьЗначения());
	
	ТекущийДокумент = Документы.ОтчетОРозничныхПродажах.ПустаяСсылка();
	
	Заголовок = СтрЗаменить(Заголовок, "%КоличествоДокументов%", Список.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ОбработкаВыбора()
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	ПоказатьЗначение(,Элементы.Список.ТекущиеДанные.Значение);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработкаВыбора()
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора()
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		ОповеститьОВыборе(СтрокаТаблицы.Значение);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
