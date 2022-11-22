﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра = "ТоварыНаСкладах";
	ПолноеИмяРегистра = "РегистрНакопления.ТоварыНаСкладах";
	
	СписокДокументов = Новый Массив;
	
	Для каждого ПолноеИмяДокумента Из СписокДокументов Цикл
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		ТекстЗапросаМеханизмаПроведения = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
		Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
			ТекстЗапросаМеханизмаПроведения, ПолноеИмяРегистра, ПолноеИмяДокумента);
		
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, "РегистрНакопления.ТоварыНаСкладах", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
