
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Поставщик", ПараметрКоманды);
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПоискПоОтборам", ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
