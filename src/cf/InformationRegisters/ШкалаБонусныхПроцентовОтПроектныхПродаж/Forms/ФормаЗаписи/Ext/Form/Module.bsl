
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.ВидБонуса.Пустая() тогда
		Запись.ВидБонуса = Перечисления.ВидыБонусов.Проектные;
	КонецЕсли;
		
КонецПроцедуры
