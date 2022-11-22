﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("УправляемаяФорма") Тогда
			
		Если Источник.ИмяФормы = "Документ.СНТ.Форма.ФормаДокумента" Тогда
			
			СНТКлиент.ОбновитьДокументыСНТИзИСЭСФ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуЭСФ = ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуЭСФ, Источник.КлючУникальности);
			
			СНТКлиент.ОбновитьДокументыСНТИзИСЭСФ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
