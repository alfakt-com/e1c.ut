﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("УправляемаяФорма") Тогда
		
		Если Источник.ИмяФормы = "Справочник.ВиртуальныеСклады.Форма.ФормаЭлемента" Тогда
			
			ВСКлиент.ОбновитьВиртуальныеСкладыИзВС(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуЭСФ = ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуЭСФ, Источник.КлючУникальности);
			
			ВСКлиент.ОбновитьВиртуальныеСкладыИзВС(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры
