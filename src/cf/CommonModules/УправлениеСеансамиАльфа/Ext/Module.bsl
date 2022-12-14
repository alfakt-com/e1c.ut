
#Область ПрограммныйИнтерфейс

Функция ТребуетсяОграничитьКоличествоОдновременныхСеансов() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОграничениеКоличестваСеансов") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЕстьПравоЗапускаБолееОдногоСеанса() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СеансыТекущегоПользователя = ПолучитьСеансыТекущегоПользователя();
	
	Если СеансыТекущегоПользователя.Количество() < 2 Тогда
		Возврат Ложь;		
	КонецЕсли;
	
	Возврат Истина;	
	
КонецФункции

Функция ЕстьПравоЗапускаБолееОдногоСеанса()
	
	ИмяСвойства_РазрешитьОткрытиеНесколькихСеансов = "кт_ЗапускатьНесколькоСеансов";
	
	ИменаПолучаемыхСвойств = Новый Массив;
	ИменаПолучаемыхСвойств.Добавить(ИмяСвойства_РазрешитьОткрытиеНесколькихСеансов);
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ЗначенияСвойствПользователя = УправлениеСвойствами.ЗначенияСвойств(ТекущийПользователь, , , ИменаПолучаемыхСвойств);
	
	Если ЗначенияСвойствПользователя.Количество() > 0
		И ЗначенияСвойствПользователя[0].Значение = Истина Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьСеансыТекущегоПользователя()
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	
	СеансыТекущегоПользователя = Новый Массив;
	
	Для Каждого Сеанс Из СеансыИнформационнойБазы Цикл
		
		Если Сеанс.Пользователь.УникальныйИдентификатор <> ТекущийПользователь.УникальныйИдентификатор Тогда
			Продолжить;
		КонецЕсли;
		
		// Фоновые и прочие сервисные сеансы не учитываем
		Если Сеанс.ИмяПриложения <> "1CV8"
			И Сеанс.ИмяПриложения <> "1CV8C"
			И Сеанс.ИмяПриложения <> "WebClient" Тогда
			Продолжить;
		КонецЕсли;
		
		СеансыТекущегоПользователя.Добавить(Сеанс);
		
	КонецЦикла;
	
	Возврат СеансыТекущегоПользователя;
	
КонецФункции

#КонецОбласти