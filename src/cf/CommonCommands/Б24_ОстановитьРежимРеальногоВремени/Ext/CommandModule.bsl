
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработкаКомандыСервер();
	
КонецПроцедуры

&НаСервере	
Процедура ОбработкаКомандыСервер()
	
	Если Б24_ОбщегоНазначенияСервер.ПолучитьПараметрыСоединения().Тип = "Файл" ИЛИ Б24_ОбщегоНазначенияПовтИсп.БазаИспользуетсяВМоделиСервиса() тогда
		
		Б24_СинхронизацияВызовСервера.СохранениеСтатусаВыполненияЗагрузкиВРежимеРеальногоВремениВФайлеСервер(Ложь);
		
		Сообщить("Зависший клиент станет активным в течении минуты.");
		
	Иначе
		
		Б24_СинхронизацияВызовСервера.СохранениеСтатусаВыполненияЗагрузкиВРежимеРеальногоВремениВФайлеСервер(Ложь);
		
		НаименованиеФоновогоЗадания = Б24_СинхронизацияВызовСервера.ПолучитьНазваниеФоновогоЗаданияЗагрузкиВРежимеРеальногоВремени();
		
		мФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый структура("Наименование", НаименованиеФоновогоЗадания));
		
		Для каждого ТекЭлемент из мФоновыеЗадания Цикл
			
			Если ТекЭлемент.Конец = Неопределено тогда
				
				ТекЭлемент.Отменить();
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры
