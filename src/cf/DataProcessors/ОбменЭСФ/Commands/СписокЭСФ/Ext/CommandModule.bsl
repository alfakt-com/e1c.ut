﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды[0]) = ЭСФКлиентСерверПереопределяемый.ТипДокументСсылкаСчетФактураВыданный() Тогда
		НаправлениеЭСФ = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Исходящий");	
	Иначе
		НаправлениеЭСФ = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Входящий");	
	КонецЕсли;
	
	ЭСФКлиент.СписокЭСФ(НаправлениеЭСФ);
	
КонецПроцедуры
