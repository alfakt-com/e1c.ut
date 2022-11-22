﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("УправляемаяФорма") Тогда
			
		Если Источник.ИмяФормы = "Документ.ЭлектронныйДокументВС.Форма.ФормаДокумента" Тогда
			
			ВСКлиент.ОбновитьДокументыУТТНИзВС(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуЭСФ = ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуЭСФ, Источник.КлючУникальности);
			
			ВСКлиент.ОбновитьДокументыУТТНИзВС(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

