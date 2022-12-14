
&НаСервере
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ВидДокумента = Перечисления.bon_УсловиеМаркентиговойАктивности.ПоСчетчикуИКрастности Тогда
		ПоСчетчикуИКрастностиОперация();		
	ИначеЕсли ВидДокумента = Перечисления.bon_УсловиеМаркентиговойАктивности.СкидкаНаТовар Тогда
		СкидкаНаТоварОперация();
	ИначеЕсли ВидДокумента = Перечисления.bon_УсловиеМаркентиговойАктивности.КаскадныеСкидки Тогда 
		КаскадныеСкидкиОперация();	
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПоСчетчикуИКрастностиОперация()
	
	///Запись зданных в регистр для счетчика и кратности
	Если ПоКратности = Истина или ПоСчетчику = Истина или ПоСумме = Истина Тогда 
		Движения.bon_УсловиеСчетчикаКратности.Записывать = Истина;
		Движения.bon_УсловиеСчетчикаКратности.Очистить();
		Для Каждого стрТЧ Из ДействующиеСтруктурныеЕдиницы Цикл
			Движение = Движения.bon_УсловиеСчетчикаКратности.Добавить();
			Движение.Организация 				= стрТЧ.Организация;
			Движение.ПодразделениеОрганизации 	= стрТЧ.ПодразделениеОрганизации;
			Движение.МаркетинговаяАкция 		= Ссылка;	
			Движение.ПериодДействияНачало 		= ПериодДействияНачало;
			Движение.ПериодДействияКонец 		= ПериодДействияКонец;	
			Если ПоСчетчику = Истина Тогда
				Движение.ПоСчетчику 			= ПоСчетчику;
				Движение.ЗначениеИскомСчетчик 	= ЗначениеИскомСчетчик;
				Движение.УсловиеСчетчика 		= УсловиеСчетчика;
			Иначе 
				Движение.ПоСчетчику 			= ПоСчетчику;
			КонецЕсли;
			Если ПоКратности = Истина Тогда 
				Движение.ПоКратности 			= ПоКратности;
				Движение.Кратность 				= Кратность;
				Движение.КолКратности 			= КолКратности;
			Иначе 
				Движение.ПоКратности 			= ПоКратности;
			КонецЕсли;
			Если ПоСумме = Истина Тогда 
				Движение.ПоСумме 				= ПоСумме;
				Движение.Сумма 					= Сумма;
				Движение.УсловиеСуммы 			= УсловиеСуммы;
			Иначе 
				Движение.ПоСумме 				= ПоСумме;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Движения.bon_УсловиеСчетчикаКратности.Записать();
	
	
	// Движения по bon_ВыдаваемыеЦенности
	Движения.bon_ВыдаваемыеЦенности.Записывать = Истина;
	Движения.bon_ВыдаваемыеЦенности.Очистить();
	
	Если ТипЦенности = Перечисления.bon_ТипЦенности.ПроцентБонусов Тогда
		Движение = Движения.bon_ВыдаваемыеЦенности.Добавить();
		Движение.Период				= Дата;
		Движение.МаркетинговойАкции = Ссылка;
		Движение.ТипЦенности 		= ТипЦенности;
		Движение.Приоритет 			= Приоритет;	
		Движение.НомерВарианта 		= Число(1);
		Движение.Значение 			= ПроцентБонусов;	
	ИначеЕсли ТипЦенности = Перечисления.bon_ТипЦенности.ФиксированныеБонусы Тогда
		Движение = Движения.bon_ВыдаваемыеЦенности.Добавить();
		Движение.Период				= Дата;
		Движение.МаркетинговойАкции = Ссылка;
		Движение.ТипЦенности 		= ТипЦенности;
		Движение.Приоритет 			= Приоритет;	
		Движение.НомерВарианта 		= Число(1);
		Движение.Значение 			= БонусыФикс;		
	ИначеЕсли ТипЦенности = Перечисления.bon_ТипЦенности.Подарок Тогда	
		Для каждого Значение Из ПредоставляемаяЦенностьПодарок Цикл	
			Движение = Движения.bon_ВыдаваемыеЦенности.Добавить();
			Движение.Период				= Дата;
			Движение.МаркетинговойАкции = Ссылка;
			Движение.ТипЦенности 		= ТипЦенности;
			Движение.Приоритет 			= Приоритет;	
			Движение.НомерВарианта 		= Значение.НомерСтроки;
			Движение.Значение 			= Значение.Подарок;			
		КонецЦикла; 
	КонецЕсли;
	Движения.bon_ВыдаваемыеЦенности.Записать();
	
КонецПроцедуры

&НаСервере
Процедура СкидкаНаТоварОперация()
	
	Движения.bon_СкидкиНаТовар.Записывать = Истина;
	Движения.bon_СкидкиНаТовар.Очистить();

	Для Каждого стрТЧ Из ДействующиеСтруктурныеЕдиницы Цикл
		Для Каждого ТекСтрокаСкидкиНаТовар Из СкидкиНаТовар Цикл
			Движение = Движения.bon_СкидкиНаТовар.Добавить();
			Движение.Приоритет				= Приоритет;
			Движение.Подразделение 			= стрТЧ.ПодразделениеОрганизации;
			Движение.ДатаНач 				= ПериодДействияНачало;
			Движение.ДатаКон 				= ПериодДействияКонец;
			Движение.Номенклотура 			= ТекСтрокаСкидкиНаТовар.Номенклатура;
			
			Если ТекСтрокаСкидкиНаТовар.НомГруппа = Истина Тогда
				Движение.НомГруппа 				= Строка(ТекСтрокаСкидкиНаТовар.Номенклатура);
				Движение.ЭтоНомГруппа			= Истина;
			КонецЕсли;
			
			Движение.ВидЦены 				= ВидЦены;
			Движение.ВидСкидкиНаценкиТовара = ВидСкидкиНаценкиТовара;
			Если ВидСкидкиНаценкиТовара = Перечисления.bon_ВидСкидкиНаценкиТовара.Процент Тогда
				Движение.Процент 				= ПроцентСкидкиНаценки;
				Движение.СпецЦена 				= Число(0);
			ИначеЕсли ВидСкидкиНаценкиТовара = Перечисления.bon_ВидСкидкиНаценкиТовара.Сумма Тогда
				Движение.Процент 				= Число(0);
				Движение.СпецЦена 				= ТекСтрокаСкидкиНаТовар.ИтогЦена;				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Движения.bon_СкидкиНаТовар.Записать();
	
КонецПроцедуры

&НаСервере
Процедура КаскадныеСкидкиОперация()
	
	Движения.bon_КаскадныеСкидки.Записывать = Истина;
	Движения.bon_КаскадныеСкидки.Очистить();
	
	Для Каждого стрТЧ Из ДействующиеСтруктурныеЕдиницы Цикл
		Для Каждого ТекСтрокаСкидкиНаТовар Из КаскадныеСкидкиТаб Цикл
			Движение = Движения.bon_КаскадныеСкидки.Добавить();
			Движение.Приоритет				= Приоритет;
			Движение.Подразделение 			= стрТЧ.ПодразделениеОрганизации;
			Движение.ДатаНач 				= ПериодДействияНачало;
			Движение.ДатаКон 				= ПериодДействияКонец;
			
			Движение.ПозицияВЗаказе			= ТекСтрокаСкидкиНаТовар.ПозицияВЗаказе;
			Движение.Процент 				= ТекСтрокаСкидкиНаТовар.ПроцентСкидки;
			Движение.НомПоз 				= ТекСтрокаСкидкиНаТовар.НомерСтроки;
		КонецЦикла;
	КонецЦикла;
	
	Движения.bon_КаскадныеСкидки.Записать();
	
КонецПроцедуры

