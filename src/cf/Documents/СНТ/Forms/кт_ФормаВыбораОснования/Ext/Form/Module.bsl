#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	 ОбработкаВыбораЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоступленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработкаВыбораЗначения();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораЗначения()
	
	МассивДокументов = Новый Массив;
	
	ТаблицаДокументов = Элементы.ДокументыПоступления;
	
	Для каждого ИндексСтроки Из ТаблицаДокументов.ВыделенныеСтроки Цикл
		
		МассивДокументов.Добавить(ИндексСтроки);
	
	КонецЦикла; 
	
	ОповеститьОВыборе(МассивДокументов);
	
КонецПроцедуры

#КонецОбласти