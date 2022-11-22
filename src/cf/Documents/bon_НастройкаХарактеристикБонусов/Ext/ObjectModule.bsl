﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	#Область Виртуальные_Таблицы
	
	///+++ Таб. Настройки "Бонусов"
	ТабНастрБон = Новый ТаблицаЗначений;	
	ТабНастрБон.Колонки.Добавить("Активен",,"Активен");
	ТабНастрБон.Колонки.Добавить("ДатаНач",,"ДатаНач");
	ТабНастрБон.Колонки.Добавить("ДатаКон",,"ДатаКон");
	ТабНастрБон.Колонки.Добавить("Приоритет",,"Приоритет");
	ТабНастрБон.Колонки.Добавить("мчт_Подразделение",,"мчт_Подразделение");
	ТабНастрБон.Колонки.Добавить("ХарактеристикаБонусов",,"ХарактеристикаБонусов");
	ТабНастрБон.Колонки.Добавить("НастройкаЗаНаличку",,"НастройкаЗаНаличку");
	ТабНастрБон.Колонки.Добавить("ПроцентБонусов",,"ПроцентБонусов");
	ТабНастрБон.Колонки.Добавить("ОгранПоНомЗаНал",,"ОгранПоНомЗаНал");
	ТабНастрБон.Колонки.Добавить("ОгранПоНомГруппЗаНал",,"ОгранПоНомГруппЗаНал");
	ТабНастрБон.Колонки.Добавить("ОгранПоЦенГрупЗаНал",,"ОгранПоЦенГрупЗаНал");
	ТабНастрБон.Колонки.Добавить("НастройкаВКредит",,"НастройкаВКредит");
	ТабНастрБон.Колонки.Добавить("ПроцентБонусовВКредит",,"ПроцентБонусовВКредит");
	ТабНастрБон.Колонки.Добавить("НаКонкретнуюПРограммуКред",,"НаКонкретнуюПРограммуКред");
	ТабНастрБон.Колонки.Добавить("КредитнаяПрограмма",,"КредитнаяПрограмма");
	ТабНастрБон.Колонки.Добавить("ОгранПоНомВКред",,"ОгранПоНомВКред");
	ТабНастрБон.Колонки.Добавить("ОгранПоНомГруппВКред",,"ОгранПоНомГруппВКред");
	ТабНастрБон.Колонки.Добавить("ОгранПоЦенГрупВКред",,"ОгранПоЦенГрупВКред");
	ТабНастрБон.Колонки.Добавить("ПрименятьДляВидаОплатВЗаказе",,"ПрименятьДляВидаОплатВЗаказе");
	ТабНастрБон.Колонки.Добавить("ИсточникПродажи",,"ИсточникПродажи");
	///--- Таб. Настройки "Бонусов"
	
	///+++ Таб. Настройки "Бонусов"
	ТабНастрБон1 = Новый ТаблицаЗначений;	
	ТабНастрБон1.Колонки.Добавить("Активен",,"Активен");
	ТабНастрБон1.Колонки.Добавить("ДатаНач",,"ДатаНач");
	ТабНастрБон1.Колонки.Добавить("ДатаКон",,"ДатаКон");
	ТабНастрБон1.Колонки.Добавить("Приоритет",,"Приоритет");
	ТабНастрБон1.Колонки.Добавить("мчт_Подразделение",,"мчт_Подразделение");
	ТабНастрБон1.Колонки.Добавить("ХарактеристикаБонусов",,"ХарактеристикаБонусов");
	ТабНастрБон1.Колонки.Добавить("НастройкаЗаНаличку",,"НастройкаЗаНаличку");
	ТабНастрБон1.Колонки.Добавить("ПроцентБонусов",,"ПроцентБонусов");
	ТабНастрБон1.Колонки.Добавить("ОгранПоНомЗаНал",,"ОгранПоНомЗаНал");
	ТабНастрБон1.Колонки.Добавить("ОгранПоНомГруппЗаНал",,"ОгранПоНомГруппЗаНал");
	ТабНастрБон1.Колонки.Добавить("ОгранПоЦенГрупЗаНал",,"ОгранПоЦенГрупЗаНал");
	ТабНастрБон1.Колонки.Добавить("НастройкаВКредит",,"НастройкаВКредит");
	ТабНастрБон1.Колонки.Добавить("ПроцентБонусовВКредит",,"ПроцентБонусовВКредит");
	ТабНастрБон1.Колонки.Добавить("НаКонкретнуюПРограммуКред",,"НаКонкретнуюПРограммуКред");
	ТабНастрБон1.Колонки.Добавить("КредитнаяПрограмма",,"КредитнаяПрограмма");
	ТабНастрБон1.Колонки.Добавить("ОгранПоНомВКред",,"ОгранПоНомВКред");
	ТабНастрБон1.Колонки.Добавить("ОгранПоНомГруппВКред",,"ОгранПоНомГруппВКред");
	ТабНастрБон1.Колонки.Добавить("ОгранПоЦенГрупВКред",,"ОгранПоЦенГрупВКред");
	ТабНастрБон1.Колонки.Добавить("ПрименятьДляВидаОплатВЗаказе",,"ПрименятьДляВидаОплатВЗаказе");
	ТабНастрБон1.Колонки.Добавить("ИсточникПродажи",,"ИсточникПродажи");
	///--- Таб. Настройки "Бонусов"
	
	///+++ Таб. Настройки "Бонусов"
	ТабНастрБон2 = Новый ТаблицаЗначений;	
	ТабНастрБон2.Колонки.Добавить("Активен",,"Активен");
	ТабНастрБон2.Колонки.Добавить("ДатаНач",,"ДатаНач");
	ТабНастрБон2.Колонки.Добавить("ДатаКон",,"ДатаКон");
	ТабНастрБон2.Колонки.Добавить("Приоритет",,"Приоритет");
	ТабНастрБон2.Колонки.Добавить("мчт_Подразделение",,"мчт_Подразделение");
	ТабНастрБон2.Колонки.Добавить("ХарактеристикаБонусов",,"ХарактеристикаБонусов");
	ТабНастрБон2.Колонки.Добавить("НастройкаЗаНаличку",,"НастройкаЗаНаличку");
	ТабНастрБон2.Колонки.Добавить("ПроцентБонусов",,"ПроцентБонусов");
	ТабНастрБон2.Колонки.Добавить("ОгранПоНомЗаНал",,"ОгранПоНомЗаНал");
	ТабНастрБон2.Колонки.Добавить("ОгранПоНомГруппЗаНал",,"ОгранПоНомГруппЗаНал");
	ТабНастрБон2.Колонки.Добавить("ОгранПоЦенГрупЗаНал",,"ОгранПоЦенГрупЗаНал");
	ТабНастрБон2.Колонки.Добавить("НастройкаВКредит",,"НастройкаВКредит");
	ТабНастрБон2.Колонки.Добавить("ПроцентБонусовВКредит",,"ПроцентБонусовВКредит");
	ТабНастрБон2.Колонки.Добавить("НаКонкретнуюПРограммуКред",,"НаКонкретнуюПРограммуКред");
	ТабНастрБон2.Колонки.Добавить("КредитнаяПрограмма",,"КредитнаяПрограмма");
	ТабНастрБон2.Колонки.Добавить("ОгранПоНомВКред",,"ОгранПоНомВКред");
	ТабНастрБон2.Колонки.Добавить("ОгранПоНомГруппВКред",,"ОгранПоНомГруппВКред");
	ТабНастрБон2.Колонки.Добавить("ОгранПоЦенГрупВКред",,"ОгранПоЦенГрупВКред");
	ТабНастрБон2.Колонки.Добавить("ПрименятьДляВидаОплатВЗаказе",,"ПрименятьДляВидаОплатВЗаказе");
	ТабНастрБон2.Колонки.Добавить("ИсточникПродажи",,"ИсточникПродажи");
	///--- Таб. Настройки "Бонусов"
	
	///+++ Таб. Настройки "Начисления" и "Списания"
	ТабНастрСписНачис = Новый ТаблицаЗначений;	
	ТабНастрСписНачис.Колонки.Добавить("Характеристика",,"Характеристика");
	ТабНастрСписНачис.Колонки.Добавить("Номенклотура",,"Номенклотура");
	ТабНастрСписНачис.Колонки.Добавить("НомГруппа",,"НомГруппа");
	ТабНастрСписНачис.Колонки.Добавить("ЦенГруппа",,"ЦенГруппа");
	ТабНастрСписНачис.Колонки.Добавить("Кредит",,"Кредит");
	ТабНастрСписНачис.Колонки.Добавить("Наличка",,"Наличка");
	ТабНастрСписНачис.Колонки.Добавить("Начислять",,"Начислять");
	ТабНастрСписНачис.Колонки.Добавить("Списывать",,"Списывать");
	ТабНастрСписНачис.Колонки.Добавить("ПоГруппе",,"ПоГруппе");
	ТабНастрСписНачис.Колонки.Добавить("ПоНоменклотуре",,"ПоНоменклотуре");
	ТабНастрСписНачис.Колонки.Добавить("ПоЦенГруппе",,"ПоЦенГруппе");
	///--- Таб. Настройки "Начисления" и "Списания"
	
	///+++ Таб. Исключений
	ТабИсключ = Новый ТаблицаЗначений;	
	ТабИсключ.Колонки.Добавить("Характеристика",,"Характеристика");
	ТабИсключ.Колонки.Добавить("Номенклотура",,"Номенклотура");
	ТабИсключ.Колонки.Добавить("НомГруппа",,"НомГруппа");
	ТабИсключ.Колонки.Добавить("ПоЦенГруппаВПоГруппа",,"ПоЦенГруппаВПоГруппа");
	ТабИсключ.Колонки.Добавить("ЦенГруппа",,"ЦенГруппа");
	ТабИсключ.Колонки.Добавить("Кредит",,"Кредит");
	ТабИсключ.Колонки.Добавить("Наличка",,"Наличка");
	ТабИсключ.Колонки.Добавить("Начислять",,"Начислять");
	ТабИсключ.Колонки.Добавить("Списывать",,"Списывать");
	ТабИсключ.Колонки.Добавить("ПоНоменклотуре",,"ПоНоменклотуре");
	ТабИсключ.Колонки.Добавить("ПоГруппе",,"ПоГруппе");
	ТабИсключ.Колонки.Добавить("ПоЦенГруппеВПоГруппе",,"ПоЦенГруппеВПоГруппе");
	ТабИсключ.Колонки.Добавить("ПоЦенГруппе",,"ПоЦенГруппе");
	ТабИсключ.Колонки.Добавить("ИсключИзСуммыДок",,"ИсключИзСуммыДок");
	///--- Таб. Исключений
	
	#КонецОбласти
	
	#Область Данные_в_Регистр_bon_НастройкаБонусов
	
	Если ДействующиеСтруктурныеЕдиницы.Количество() > 0 Тогда  
		Для Каждого Подраз Из ДействующиеСтруктурныеЕдиницы Цикл 
			НовСтр = ТабНастрБон.Добавить();
			НовСтр.Активен = Истина;
			НовСтр.ДатаНач = ЭтотОбъект.ДатаДействияНач;
			НовСтр.ДатаКон = ЭтотОбъект.ДатаДействияКон;
			НовСтр.мчт_Подразделение =  Подраз.ПодразделениеОрганизации; 
			НовСтр.Приоритет = ЭтотОбъект.Приоритет;
			НовСтр.ХарактеристикаБонусов = ЭтотОбъект.Характеристика;
			Если ЭтотОбъект.Дата <= КонецДня('20200618') Тогда
				НовСтр.ПрименятьДляВидаОплатВЗаказе = ЭтотОбъект.ПрименятьДляВидаОплатВЗаказе;
			КонецЕсли;
			Если ЭтотОбъект.ПродажаЗаНал = Истина Тогда  
				НовСтр.НастройкаЗаНаличку 	= ЭтотОбъект.ПродажаЗаНал;
				НовСтр.ПроцентБонусов 		= ЭтотОбъект.ПроцентНал;
				НовСтр.ОгранПоНомЗаНал		= ЭтотОбъект.ПоНоменклотуре_Нал;
				НовСтр.ОгранПоНомГруппЗаНал = ЭтотОбъект.ПоНомГруппе_Нал;	
				НовСтр.ОгранПоЦенГрупЗаНал  = ЭтотОбъект.ПоЦенГруппе_Нал;
			КонецЕсли;			
			Если ЭтотОбъект.ПродажаВКредит = Истина Тогда  
				НовСтр.НастройкаВКредит 		= ЭтотОбъект.ПродажаВКредит;
				НовСтр.ПроцентБонусовВКредит	= ЭтотОбъект.ПроцентКредит;
				Если ЭтотОбъект.НаКредПрог = Истина Тогда
					НовСтр.НаКонкретнуюПРограммуКред = ЭтотОбъект.НаКредПрог;
					НовСтр.КредитнаяПрограмма = ЭтотОбъект.ОграничениеПоКредитнымПрограммам[0].КредитнаяПрограмма;
				КонецЕсли;	
				НовСтр.ОгранПоНомВКред			= ЭтотОбъект.ПоНоменклотуре_Кред;
				НовСтр.ОгранПоНомГруппВКред 	= ЭтотОбъект.ПоНомГруппе_Кред;	
				НовСтр.ОгранПоЦенГрупВКред  	= ЭтотОбъект.ПоЦенГруппе_Кред;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	///
	НаборЗаписей = РегистрыСведений.bon_НастройкаБонусов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументЗап.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Записать(); 
	
	ТабРез = Неопределено;
	Если ТабНастрБон.Количество() > 0 тогда	
		ТабРез = ТабНастрБон;
	ИначеЕсли ТабНастрБон1.Количество() > 0 Тогда
		ТабРез = ТабНастрБон1;	
	ИначеЕсли ТабНастрБон2.Количество() > 0 Тогда
		ТабРез = ТабНастрБон2;		
	КонецЕсли;
	
	Если ТабРез <> Неопределено Тогда
		Для Каждого ПерВиртТаб Из ТабРез Цикл 
			Если Не ПроверканаСовпаденияДействующий(ПерВиртТаб) Тогда
				МенеджерЗаписи = РегистрыСведений.bon_НастройкаБонусов.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Период						= ЭтотОбъект.Дата;
				МенеджерЗаписи.ДокументЗап                  = ЭтотОбъект.Ссылка;
				МенеджерЗаписи.Активен						= ПерВиртТаб.Активен;
				МенеджерЗаписи.ВидНастройки					= ВидНастроек;
				
				МенеджерЗаписи.Каскад_СуммаС				= ЭтотОбъект.Каскад_СуммаС;
				МенеджерЗаписи.Каскад_СуммаДо				= ЭтотОбъект.Каскад_СуммаДо;
				
				МенеджерЗаписи.ДатаНач                  	= ПерВиртТаб.ДатаНач;
				МенеджерЗаписи.ДатаКон                  	= ПерВиртТаб.ДатаКон;
				МенеджерЗаписи.Приоритет                  	= ПерВиртТаб.Приоритет;			
				МенеджерЗаписи.Подразделение        		= ПерВиртТаб.мчт_Подразделение;
				МенеджерЗаписи.ХарактеристикаБонусов    	= ПерВиртТаб.ХарактеристикаБонусов;
				МенеджерЗаписи.НастройкаЗаНаличку      		= ПерВиртТаб.НастройкаЗаНаличку;
				МенеджерЗаписи.ПроцентБонусов           	= ПерВиртТаб.ПроцентБонусов;
				МенеджерЗаписи.ОгранПоНомЗаНал          	= ПерВиртТаб.ОгранПоНомЗаНал;
				МенеджерЗаписи.ОгранПоНомГруппЗаНал     	= ПерВиртТаб.ОгранПоНомГруппЗаНал;
				МенеджерЗаписи.ОгранПоЦенГрупЗаНал      	= ПерВиртТаб.ОгранПоЦенГрупЗаНал;
				МенеджерЗаписи.НастройкаВКредит         	= ПерВиртТаб.НастройкаВКредит;
				МенеджерЗаписи.ПроцентБонусовВКредит    	= ПерВиртТаб.ПроцентБонусовВКредит;
				МенеджерЗаписи.НаКонкретнуюПРограммуКред	= ПерВиртТаб.НаКонкретнуюПРограммуКред;
				МенеджерЗаписи.КредитнаяПрограмма       	= ПерВиртТаб.КредитнаяПрограмма;
				МенеджерЗаписи.ОгранПоНомВКред         		= ПерВиртТаб.ОгранПоНомВКред;
				МенеджерЗаписи.ОгранПоНомГруппВКред     	= ПерВиртТаб.ОгранПоНомГруппВКред;
				МенеджерЗаписи.ОгранПоЦенГрупВКред      	= ПерВиртТаб.ОгранПоЦенГрупВКред;
				МенеджерЗаписи.Пользователь 				= ПользователиКлиентСервер.АвторизованныйПользователь();	
				МенеджерЗаписи.Записать();
			Иначе 
				Отказ = Истина;
				Сообщить("Имеются пересечения Настроек по : "+ПерВиртТаб.мчт_Подразделение);
				Сообщить("Отказ в провидении!!!");
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Данные_о_Начислении_Списании_Исключении_Каскада
	
	#Область Данные_о_Начислении	
	////Наличка Начислять
	Если ЭтотОбъект.ПродажаЗаНал = Истина Тогда
		Если ЭтотОбъект.ПоНоменклотуре_Нал = Истина Тогда 
			Для Каждого НомНал из Нач_Номенклотура_Нал Цикл 
				НовСтрСН = ТабНастрСписНачис.Добавить();
				НовСтрСН.Наличка = Истина;
				НовСтрСН.Начислять = Истина;
				НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;
				НовСтрСН.Номенклотура = НомНал.Номенклотура;
				НовСтрСН.ПоНоменклотуре = Истина;
			КонецЦикла;			
		КонецЕсли;
		
		Если ЭтотОбъект.ПоНомГруппе_Нал = Истина Тогда 
			Если ЭтотОбъект.ПоЦенГруппе_Нал = Ложь Тогда 
				Для Каждого НомГруп из Нач_НоменкГруппы_Нал Цикл
					НовСтрСН = ТабНастрСписНачис.Добавить();
					НовСтрСН.Наличка = Истина;
					НовСтрСН.Начислять = Истина;
					НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
					НовСтрСН.НомГруппа = НомГруп.НомГрупп;
					НовСтрСН.ПоГруппе = Истина;
				КонецЦикла;
			ИначеЕсли ЭтотОбъект.ПоЦенГруппе_Нал = Истина Тогда 
				Для Каждого НомГЦ из Нач_ЦеновГруппа_Нал Цикл
					Для Каждого НомГ из Нач_НоменкГруппы_Нал Цикл
						НовСтрСН = ТабНастрСписНачис.Добавить();
						НовСтрСН.Наличка = Истина;
						НовСтрСН.Начислять = Истина;
						НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;						
						НовСтрСН.НомГруппа = НомГ.НомГрупп;
						НовСтрСН.ПоГруппе = Истина;
						НовСтрСН.ЦенГруппа = НомГЦ.ЦенГрупп;
						НовСтрСН.ПоЦенГруппе = Истина;
					КонецЦикла;
				КонецЦикла;	
			КонецЕсли;
		Иначе 
			Если ЭтотОбъект.ПоЦенГруппе_Нал = Истина Тогда 
				Для Каждого НомГЦ из Нач_ЦеновГруппа_Нал Цикл
					НовСтрСН = ТабНастрСписНачис.Добавить();
					НовСтрСН.Наличка = Истина;
					НовСтрСН.Начислять = Истина;
					НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;						
					НовСтрСН.ЦенГруппа = НомГЦ.ЦенГрупп;
					НовСтрСН.ПоЦенГруппе = Истина;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	#КонецОбласти
	
	#Область Данные_о_Списании	
	///Запись на момент списания бонусов действие
	Если ЭтотОбъект.НастройкаСписания = Истина Тогда 
		Если ЭтотОбъект.Спис_Номенклотуре = Истина Тогда 
			Для Каждого НомСпис из Спис_Номенклотура Цикл 
				НовСтрСН = ТабНастрСписНачис.Добавить();
				НовСтрСН.Наличка = Истина;
				НовСтрСН.Списывать = Истина;
				НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;
				НовСтрСН.Номенклотура = НомСпис.Номенклотура;
				НовСтрСН.ПоНоменклотуре = Истина;
			КонецЦикла;		
		КонецЕсли;	
		Если ЭтотОбъект.Спис_НомГруппе = Истина Тогда 
			Если ЭтотОбъект.Спис_ЦенГруппе = Ложь Тогда
				Для Каждого НомГрупСпис из Спис_НоменкГруппы Цикл
					НовСтрСН = ТабНастрСписНачис.Добавить();
					НовСтрСН.Наличка = Истина;
					НовСтрСН.Списывать = Истина;
					НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
					НовСтрСН.НомГруппа = НомГрупСпис.НомГрупп;
					НовСтрСН.ПоГруппе = Истина;
				КонецЦикла;	
			ИначеЕсли ЭтотОбъект.Спис_ЦенГруппе = Истина Тогда
				Для Каждого НомГЦСпис из Спис_ЦеновГруппа Цикл
					Для Каждого НомГСпис из Спис_НоменкГруппы Цикл
						НовСтрСН = ТабНастрСписНачис.Добавить();
						НовСтрСН.Наличка = Истина;
						НовСтрСН.Списывать = Истина;
						НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;						
						НовСтрСН.НомГруппа = НомГСпис.НомГрупп;
						НовСтрСН.ПоГруппе = Истина;
						НовСтрСН.ЦенГруппа = НомГЦСпис.ЦенГрупп;
						НовСтрСН.ПоЦенГруппе = Истина;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
		Иначе 
			Если ЭтотОбъект.Спис_ЦенГруппе = Истина Тогда
				Для Каждого НомГЦСпис из Спис_ЦеновГруппа Цикл
					НовСтрСН = ТабНастрСписНачис.Добавить();
					НовСтрСН.Наличка = Истина;
					НовСтрСН.Списывать = Истина;
					НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;						
					НовСтрСН.ЦенГруппа = НомГЦСпис.ЦенГрупп;
					НовСтрСН.ПоЦенГруппе = Истина;
				КонецЦикла;					
			КонецЕсли;			
		КонецЕсли;	
	КонецЕсли;
	#КонецОбласти
	
	#Область Данные_о_Каскадных_бонусах	
	///+++ Указание "Каскада"
	Если ЭтотОбъект.ВидНастроек = Перечисления.bon_Выды_Настроек.Каскадные Тогда
		
		//Таблица "ТабНастрСписНачис"		
		Если ЭтотОбъект.Каскад_Номенклотуре_На = Истина Тогда
			Для Каждого НомНал из Каскад_на_Сумму_по_Номенклотуре Цикл 
				НовСтрСН 				= ТабНастрСписНачис.Добавить();
				НовСтрСН.Начислять 		= Истина;
				НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;
				НовСтрСН.Номенклотура 	= НомНал.Номенклотура;
				НовСтрСН.ПоНоменклотуре = Истина;
			КонецЦикла;		
		КонецЕсли;
		
		Если ЭтотОбъект.Каскад_НомГруппе_На = Истина Тогда
			Для Каждого НомГруп из Каскад_на_Сумму_по_НоменкГруппы Цикл
				НовСтрСН 				= ТабНастрСписНачис.Добавить();
				НовСтрСН.Начислять 		= Истина;
				НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
				НовСтрСН.НомГруппа 		= НомГруп.НомГрупп;
				НовСтрСН.ПоГруппе 		= Истина;
				
				Если ЭтотОбъект.Каскад_ЦенГруппы_в_НомГруппе_На = Истина  Тогда 
					НовСтрСН.ПоЦенГруппаВПоГруппа		= НомГруп.ЦенГрупп;
					НовСтрСН.ПоЦенГруппеВПоГруппе 		= Истина;	
				Иначе
					НовСтрСН.ПоЦенГруппеВПоГруппе 		= Ложь;				
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		
		Если ЭтотОбъект.Каскад_ЦенГруппе_На = Истина Тогда
			Для Каждого НомГЦ из Каскад_на_Сумму_по_ЦеновГруппа Цикл
				НовСтрСН 				= ТабНастрСписНачис.Добавить();
				НовСтрСН.Начислять 		= Истина;
				НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;						
				НовСтрСН.ЦенГруппа 		= НомГЦ.ЦенГрупп;
				НовСтрСН.ПоЦенГруппе 	= Истина;
			КонецЦикла;	
		КонецЕсли;
		
		
		///+++Исключение
		Если ЭтотОбъект.Каскад_Исключить_Из_Документа = Истина Тогда
			//Таблица "ТабИсключ"
			
			///Исключение по Номенклотуре
			Если ЭтотОбъект.Каскад_Номенклотуре_Исключ = Истина Тогда 
				Для Каждого НомНал из Каскад_Иск_на_Сумму_по_Номенклотуре Цикл 
					НовСтрСН 					= ТабИсключ.Добавить();
					НовСтрСН.Начислять 			= Истина;
					НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;
					НовСтрСН.Номенклотура 		= НомНал.Номенклотура;
					НовСтрСН.ПоНоменклотуре 	= Истина;
					НовСтрСН.ИсключИзСуммыДок 	= Истина;
					
				КонецЦикла;			
			КонецЕсли;
			
			///Исключение по Номенклотурной Группе и Ценновой если она включена
			Если ЭтотОбъект.Каскад_НомГруппе_Исключ = Истина Тогда 
				Для Каждого НомГруп из Каскад_Иск_на_Сумму_по_НоменкГруппы Цикл
					НовСтрСН 				= ТабИсключ.Добавить();
					НовСтрСН.Начислять 		= Истина;
					НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
					НовСтрСН.НомГруппа 		= НомГруп.НомГрупп;
					НовСтрСН.ПоГруппе 		= Истина;
					НовСтрСН.ИсключИзСуммыДок 	= Истина;
					
					Если ЭтотОбъект.Каскад_ЦенГруппы_в_НомГруппе_Исключ = Истина и ЗначениеЗаполнено(НомГруп.ЦенГрупп) Тогда 
						НовСтрСН.ПоЦенГруппаВПоГруппа	= НомГруп.ЦенГрупп;
						НовСтрСН.ПоЦенГруппеВПоГруппе 	= Истина;	
					Иначе
						НовСтрСН.ПоЦенГруппеВПоГруппе 	= Ложь;				
					КонецЕсли;
					
				КонецЦикла;
			КонецЕсли;		
			
			///Исключение по ЦенГруппе
			Если ЭтотОбъект.Каскад_ЦенГруппе_Исключ = Истина Тогда 
				Для Каждого НомГЦ из Каскад_Иск_на_Сумму_по_ЦеновГруппа Цикл
					НовСтрСН 					= ТабИсключ.Добавить();
					НовСтрСН.Начислять 			= Истина;
					НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;						
					НовСтрСН.ЦенГруппа 			= НомГЦ.ЦенГрупп;
					НовСтрСН.ПоЦенГруппе 		= Истина;
					НовСтрСН.ИсключИзСуммыДок 	= Истина;
				КонецЦикла;
			КонецЕсли;	
		КонецЕсли;		
		///---Исключение
	КонецЕсли;
	///--- Указание "Каскада"
	#КонецОбласти
	
	///+++Исключение при "Начислении" и "Списание"
	Если ЭтотОбъект.НастройкаИсключения = Истина Тогда 		
		ЗаполнитьТабИсключение(ТабИсключ);	
	КонецЕсли;
	///---Исключение при "Начислении" и "Списание"
	#КонецОбласти	
	
#Область Данные_в_Регистр_bon_Наст_Нач_и_Спис_Бонусов_ПоНоменклотуре
	///+++ Заполнения регистра по Настройки "Начисления" и "Списания"
	////Удоляем записи
	НаборЗаписей = РегистрыСведений.bon_Наст_Нач_и_Спис_Бонусов_ПоНоменклотуре.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументЗап.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Записать();
	
	НаборЗаписей = РегистрыСведений.bon_Наст_Нач_и_Спис_Бонусов_ПоНоменклотуре.СоздатьНаборЗаписей(); 
	НаборЗаписей.Отбор.ДокументЗап.Установить(Ссылка); 
	Для Каждого ЗапНастрСН Из ТабНастрСписНачис Цикл 
		НоваяЗапись = НаборЗаписей.Добавить(); 
		НоваяЗапись.Период			= ЭтотОбъект.Дата;
		НоваяЗапись.ДокументЗап     = ЭтотОбъект.Ссылка;
		
		НоваяЗапись.ВидНастройки    = ВидНастроек;
		НоваяЗапись.Каскад_СуммаС   = ЭтотОбъект.Каскад_СуммаС;
		НоваяЗапись.Каскад_СуммаДо  = ЭтотОбъект.Каскад_СуммаДо;
		
		НоваяЗапись.Характеристика	= ЗапНастрСН.Характеристика;
		НоваяЗапись.Номенклотура    = ЗапНастрСН.Номенклотура;
		НоваяЗапись.НомГруппа       = ЗапНастрСН.НомГруппа;
		НоваяЗапись.ЦенГруппа    	= ЗапНастрСН.ЦенГруппа;
		НоваяЗапись.Кредит      	= ЗапНастрСН.Кредит;
		НоваяЗапись.Наличка         = ЗапНастрСН.Наличка;
		
		НоваяЗапись.Начислять       = ЗапНастрСН.Начислять;
		НоваяЗапись.Списывать     	= ЗапНастрСН.Списывать;
		НоваяЗапись.ПоГруппе      	= ЗапНастрСН.ПоГруппе;
		НоваяЗапись.ПоНоменклотуре  = ЗапНастрСН.ПоНоменклотуре;
		НоваяЗапись.ПоЦенГруппе    	= ЗапНастрСН.ПоЦенГруппе;
		
		НоваяЗапись.Пользователь 	= ПользователиКлиентСервер.АвторизованныйПользователь();	
	КонецЦикла; 
	НаборЗаписей.Записать();  
	///--- Заполнения регистра по Настройки "Начисления" и "Списания"
#КонецОбласти

#Область Данные_в_Регистр_bon_Исключение_Бонусов
	//регистр New_Bonys_Исключение_Бонусов
	Движения.bon_Исключение_Бонусов.Записывать = Истина;
	Движения.bon_Исключение_Бонусов.Очистить();
	
	///+++ Заполнения регистра по "Исключению"
	Если ТабИсключ.Количество() > 0 тогда
		Для Каждого Строка Из ТабИсключ Цикл
			Движение = Движения.bon_Исключение_Бонусов.Добавить();
			Движение.Период 				= Дата;
			Движение.Характеристика 		= Характеристика;
			Движение.ВидНастройки			= ВидНастроек;
			Движение.Номенклотура 			= Строка.Номенклотура;
			Движение.НомГруппа				= Строка.НомГруппа;
			Движение.ПоЦенГруппаВПоГруппа 	= Строка.ПоЦенГруппаВПоГруппа;
			Движение.ЦенГруппа 				= Строка.ЦенГруппа;
			Движение.Кредит 				= Строка.Кредит;
			Движение.Наличка 				= Строка.Наличка;
			Движение.Начислять 				= Строка.Начислять;
			Движение.Списывать 				= Строка.Списывать;
			Движение.ПоНоменклотуре 		= Строка.ПоНоменклотуре;
			Движение.ПоГруппе 				= Строка.ПоГруппе;
			Движение.ПоЦенГруппеВПоГруппе 	= Строка.ПоЦенГруппеВПоГруппе;
			Движение.ПоЦенГруппе 			= Строка.ПоЦенГруппе;
			Движение.Пользователь 			= Автор;
			Движение.ИсключИзСуммыДок 		= Строка.ИсключИзСуммыДок;
		КонецЦикла;
	КонецЕсли;
	///--- Заполнения регистра по "Исключению"
#КонецОбласти
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	НаборЗаписей = РегистрыСведений.bon_НастройкаБонусов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументЗап.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Записать(); 
	
	НаборЗаписей = РегистрыСведений.bon_Наст_Нач_и_Спис_Бонусов_ПоНоменклотуре.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументЗап.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Записать();
		
КонецПроцедуры

Функция ПроверканаСовпаденияДействующий(ПерВиртТаб)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	bon_НастройкаБонусов.Подразделение КАК Подразделение,
	|	bon_НастройкаБонусов.ДатаНач КАК ДатаНач,
	|	bon_НастройкаБонусов.ДатаКон КАК ДатаКон,
	|	bon_НастройкаБонусов.ХарактеристикаБонусов КАК ХарактеристикаБонусов,
	|	bon_НастройкаБонусов.ДокументЗап КАК ДокументЗап,
	|	bon_НастройкаБонусов.ВидНастройки КАК ВидНастройки
	|ИЗ
	|	РегистрСведений.bon_НастройкаБонусов КАК bon_НастройкаБонусов
	|ГДЕ
	|	bon_НастройкаБонусов.Подразделение = &Подразделение
	//|	И bon_НастройкаБонусов.ДатаКон МЕЖДУ &ДаНач И &ДаКонКон
	|	И bon_НастройкаБонусов.ВидНастройки = &ВидНастройки
	|
	|СГРУППИРОВАТЬ ПО
	|	bon_НастройкаБонусов.Подразделение,
	|	bon_НастройкаБонусов.ДатаНач,
	|	bon_НастройкаБонусов.ДатаКон,
	|	bon_НастройкаБонусов.ХарактеристикаБонусов,
	|	bon_НастройкаБонусов.ДокументЗап,
	|	bon_НастройкаБонусов.ВидНастройки";
	Запрос.УстановитьПараметр("Подразделение", ПерВиртТаб.мчт_Подразделение);
	Запрос.УстановитьПараметр("ВидНастройки",  ВидНастроек);
	//Запрос.УстановитьПараметр("ДаНач", 		   ПерВиртТаб.ДатаНач);
	//Запрос.УстановитьПараметр("ДаКонКон", 	   ПерВиртТаб.ДатаКон);
	
	Рез = Запрос.Выполнить().Выгрузить();
	
	Если Рез.Количество() > 0 Тогда
		Для Каждого СтрРез Из Рез Цикл 
			Если СтрРез.ДатаНач >= ПерВиртТаб.ДатаНач и СтрРез.ДатаНач <= ПерВиртТаб.ДатаКон или
				 СтрРез.ДатаКон >= ПерВиртТаб.ДатаНач и СтрРез.ДатаКон <= ПерВиртТаб.ДатаКон или
				 СтрРез.ДатаНач <= ПерВиртТаб.ДатаКон и СтрРез.ДатаКон >= ПерВиртТаб.ДатаНач или 
				 СтрРез.ДатаНач >= ПерВиртТаб.ДатаНач и СтрРез.ДатаКон <= ПерВиртТаб.ДатаКон Тогда
				Возврат Истина;	 
			КонецЕсли;
		КонецЦикла;		
	Иначе 
		Возврат Ложь;	
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


#Область Расчеты_и_Заполнения_Таблиц

Функция ЗаполнитьТабИсключение(ТабИсключ)
		
	////Исключение "Наличка Начисление"
	Если ЭтотОбъект.Исключ_Нач_Нал = Истина Тогда
		ТабИсключ_Нач_Нал = Новый ТаблицаЗначений;	
		ТабИсключ_Нач_Нал.Колонки.Добавить("Характеристика",		,"Характеристика");
		ТабИсключ_Нач_Нал.Колонки.Добавить("Наличка",				,"Наличка");
		ТабИсключ_Нач_Нал.Колонки.Добавить("Начислять",				,"Начислять");
		ТабИсключ_Нач_Нал.Колонки.Добавить("Номенклотура",			,"Номенклотура");
		ТабИсключ_Нач_Нал.Колонки.Добавить("ПоНоменклотуре",		,"ПоНоменклотуре");	
		ТабИсключ_Нач_Нал.Колонки.Добавить("НомГруппа",				,"НомГруппа");
		ТабИсключ_Нач_Нал.Колонки.Добавить("ПоЦенГруппаВПоГруппа",	,"ПоЦенГруппаВПоГруппа");
		ТабИсключ_Нач_Нал.Колонки.Добавить("ЦенГруппа",				,"ЦенГруппа");		
		ТабИсключ_Нач_Нал.Колонки.Добавить("Кредит",				,"Кредит");
		ТабИсключ_Нач_Нал.Колонки.Добавить("Списывать",				,"Списывать");	
		ТабИсключ_Нач_Нал.Колонки.Добавить("ПоГруппе",				,"ПоГруппе");
		ТабИсключ_Нач_Нал.Колонки.Добавить("ПоЦенГруппеВПоГруппе",	,"ПоЦенГруппеВПоГруппе");
		ТабИсключ_Нач_Нал.Колонки.Добавить("ПоЦенГруппе",			,"ПоЦенГруппе");	

		МеханизмРесчетаЗаполнения_Нач_Нал(ТабИсключ_Нач_Нал);		
	КонецЕсли;
	
	////Исключение "Наличка Списываем"
	Если ЭтотОбъект.Исключ_Спис_Нал = Истина Тогда
		ТабИсключ_Спис_Нал = Новый ТаблицаЗначений;	
		ТабИсключ_Спис_Нал.Колонки.Добавить("Характеристика",		,"Характеристика");
		ТабИсключ_Спис_Нал.Колонки.Добавить("Наличка",				,"Наличка");
		ТабИсключ_Спис_Нал.Колонки.Добавить("Начислять",			,"Начислять");
		ТабИсключ_Спис_Нал.Колонки.Добавить("Номенклотура",			,"Номенклотура");
		ТабИсключ_Спис_Нал.Колонки.Добавить("ПоНоменклотуре",		,"ПоНоменклотуре");	
		ТабИсключ_Спис_Нал.Колонки.Добавить("НомГруппа",			,"НомГруппа");
		ТабИсключ_Спис_Нал.Колонки.Добавить("ПоЦенГруппаВПоГруппа",	,"ПоЦенГруппаВПоГруппа");
		ТабИсключ_Спис_Нал.Колонки.Добавить("ЦенГруппа",			,"ЦенГруппа");		
		ТабИсключ_Спис_Нал.Колонки.Добавить("Кредит",				,"Кредит");
		ТабИсключ_Спис_Нал.Колонки.Добавить("Списывать",			,"Списывать");	
		ТабИсключ_Спис_Нал.Колонки.Добавить("ПоГруппе",				,"ПоГруппе");
		ТабИсключ_Спис_Нал.Колонки.Добавить("ПоЦенГруппеВПоГруппе",	,"ПоЦенГруппеВПоГруппе");
		ТабИсключ_Спис_Нал.Колонки.Добавить("ПоЦенГруппе",			,"ПоЦенГруппе");	

		МеханизмРесчетаЗаполнения_Спис_Нал(ТабИсключ_Спис_Нал);		
	КонецЕсли;
	
	////Исключение "Кредит Начисление"
	//Если ЭтотОбъект.Исключ_Нач_Кред = Истина Тогда
	//	ТабИсключ_Нач_Кред = Новый ТаблицаЗначений;	
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("Характеристика",		,"Характеристика");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("Наличка",				,"Наличка");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("Начислять",			,"Начислять");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("Номенклотура",			,"Номенклотура");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("ПоНоменклотуре",		,"ПоНоменклотуре");	
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("НомГруппа",			,"НомГруппа");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("ПоЦенГруппаВПоГруппа",	,"ПоЦенГруппаВПоГруппа");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("ЦенГруппа",			,"ЦенГруппа");		
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("Кредит",				,"Кредит");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("Списывать",			,"Списывать");	
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("ПоГруппе",				,"ПоГруппе");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("ПоЦенГруппеВПоГруппе",	,"ПоЦенГруппеВПоГруппе");
	//	ТабИсключ_Нач_Кред.Колонки.Добавить("ПоЦенГруппе",			,"ПоЦенГруппе");		
	//	
	//	
	//	Если Иключ_Нач_Кред_Аналогично_Нач_Нал = Ложь Тогда
	//		МеханизмРесчетаЗаполнения_Нач_Кред(ТабИсключ_Нач_Кред);
	//	Иначе 
	//		Если ТабИсключ_Нач_Нал.Количество() > 0 Тогда
	//			Для каждого СтрокаТЗ Из ТабИсключ_Нач_Нал Цикл
	//				Строка = ТабИсключ_Нач_Кред.Добавить();
	//				ЗаполнитьЗначенияСвойств(Строка, СтрокаТЗ);
	//				Строка.Наличка 	= Ложь;
	//				Строка.Кредит 	= Истина;
	//			КонецЦикла;	
	//		Иначе
	//			//Вывесть сообщение что нету настроек исключения при начисления	
	//			вроар=1;	
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
	////Исключение "Кредит Списываем"
	//Если ЭтотОбъект.Исключ_Спис_Кредит = Истина Тогда
	//	ТабИсключ_Спис_Кред = Новый ТаблицаЗначений;	
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("Характеристика",		 ,"Характеристика");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("Наличка",				 ,"Наличка");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("Начислять",			 ,"Начислять");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("Номенклотура",		 ,"Номенклотура");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("ПоНоменклотуре",		 ,"ПоНоменклотуре");	
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("НомГруппа",			 ,"НомГруппа");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("ПоЦенГруппаВПоГруппа", ,"ПоЦенГруппаВПоГруппа");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("ЦенГруппа",			 ,"ЦенГруппа");		
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("Кредит",				 ,"Кредит");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("Списывать",			 ,"Списывать");	
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("ПоГруппе",			 ,"ПоГруппе");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("ПоЦенГруппеВПоГруппе", ,"ПоЦенГруппеВПоГруппе");
	//	ТабИсключ_Спис_Кред.Колонки.Добавить("ПоЦенГруппе",			 ,"ПоЦенГруппе");		

	//	Если Иключ_Спис_Кредит_Аналогично_Спис_Нал = Ложь Тогда
	//		МеханизмРесчетаЗаполнения_Спис_Кред(ТабИсключ_Спис_Кред);
	//	Иначе 
	//		Если ТабИсключ_Спис_Нал.Количество() > 0 Тогда
	//			Для каждого СтрокаТЗ Из ТабИсключ_Спис_Нал Цикл
	//				Строка = ТабИсключ_Спис_Кред.Добавить();
	//				ЗаполнитьЗначенияСвойств(Строка, СтрокаТЗ);
	//				Строка.Наличка 	= Ложь;
	//				Строка.Кредит 	= Истина;
	//			КонецЦикла;	
	//		Иначе
	//			//Вывесть сообщение что нету настроек исключения при начисления	
	//			вроар=1;	
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;

	Если ТабИсключ_Нач_Нал <> Неопределено и  ТабИсключ_Нач_Нал.Количество() > 0 Тогда
		Для каждого СтрокаТЗ Из ТабИсключ_Нач_Нал Цикл
			Строка = ТабИсключ.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаТЗ);
		КонецЦикла;
	КонецЕсли;
	
	Если ТабИсключ_Спис_Нал <> Неопределено и ТабИсключ_Спис_Нал.Количество() > 0 Тогда
		Для каждого СтрокаТЗ Из ТабИсключ_Спис_Нал Цикл
			Строка = ТабИсключ.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаТЗ);
		КонецЦикла;
	КонецЕсли;
	
	//Если ТабИсключ_Нач_Кред <> Неопределено и ТабИсключ_Нач_Кред.Количество() > 0 Тогда
	//	Для каждого СтрокаТЗ Из ТабИсключ_Нач_Кред Цикл
	//		Строка = ТабИсключ.Добавить();
	//		ЗаполнитьЗначенияСвойств(Строка, СтрокаТЗ);
	//	КонецЦикла;
	//КонецЕсли;
	
	//Если ТабИсключ_Спис_Кред <> Неопределено и ТабИсключ_Спис_Кред.Количество() > 0 Тогда
	//	Для каждого СтрокаТЗ Из ТабИсключ_Спис_Кред Цикл
	//		Строка = ТабИсключ.Добавить();
	//		ЗаполнитьЗначенияСвойств(Строка, СтрокаТЗ);
	//	КонецЦикла;
	//КонецЕсли;	
		
КонецФункции

Функция МеханизмРесчетаЗаполнения_Нач_Нал(ТаБДабов)
	
	///Исключение по Номенклотуре
	Если ЭтотОбъект.Иключ_Номенклотуре_Нач_Нал = Истина Тогда 
		Для Каждого НомНал из Иключ_Номенклотура_Нач_Нал Цикл 
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Наличка 			= Истина;
			НовСтрСН.Начислять 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;
			НовСтрСН.Номенклотура 		= НомНал.Номенклотура;
			НовСтрСН.ПоНоменклотуре 	= Истина;
		КонецЦикла;			
	КонецЕсли;
	
	///Исключение по Номенклотурной Группе и Ценновой если она включена
	Если ЭтотОбъект.Иключ_НомГруппе_Нач_Нал = Истина Тогда 
		Для Каждого НомГруп из Иключ_НоменкГруппы_Нач_Нал Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Наличка 		= Истина;
			НовСтрСН.Начислять 		= Истина;
			НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
			НовСтрСН.НомГруппа 		= НомГруп.НомГрупп;
			НовСтрСН.ПоГруппе 		= Истина;
			
			Если ЭтотОбъект.Иключ_Вкл_ЦенГруппе_Нач_Нал = Истина и ЗначениеЗаполнено(НомГруп.ЦенГрупп) Тогда 
				НовСтрСН.ПоЦенГруппаВПоГруппа		= НомГруп.ЦенГрупп;
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Истина;	
			Иначе
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Ложь;				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;		
				
	///Исключение по ЦенГруппе
	Если ЭтотОбъект.Иключ_ЦенГруппе_Нач_Нал = Истина Тогда 
		Для Каждого НомГЦ из Иключ_ЦеновГруппа_Нач_Нал Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Наличка 			= Истина;
			НовСтрСН.Начислять 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;						
			НовСтрСН.ЦенГруппа 			= НомГЦ.ЦенГрупп;
			НовСтрСН.ПоЦенГруппе 		= Истина;
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция МеханизмРесчетаЗаполнения_Спис_Нал(ТаБДабов)
		
	///Исключение по Номенклотуре
	Если ЭтотОбъект.Иключ_Номенклотуре_Спис_Нал = Истина Тогда 
		Для Каждого НомНал из Иключ_Номенклотура_Спис_Нал Цикл 
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Наличка 			= Истина;
			НовСтрСН.Списывать 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;
			НовСтрСН.Номенклотура 		= НомНал.Номенклотура;
			НовСтрСН.ПоНоменклотуре 	= Истина;
		КонецЦикла;			
	КонецЕсли;
	
	///Исключение по Номенклотурной Группе и Ценновой если она включена
	Если ЭтотОбъект.Иключ_НомГруппе_Спис_Нал = Истина Тогда 
		Для Каждого НомГруп из Иключ_НоменкГруппы_Спис_Нал Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Наличка 		= Истина;
			НовСтрСН.Списывать 		= Истина;
			НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
			НовСтрСН.НомГруппа 		= НомГруп.НомГрупп;
			НовСтрСН.ПоГруппе 		= Истина;
			
			Если ЭтотОбъект.Иключ_Вкл_ЦенГруппе_Спис_Нал = Истина  и ЗначениеЗаполнено(НомГруп.ЦенГрупп) Тогда 
				НовСтрСН.ПоЦенГруппаВПоГруппа		= НомГруп.ЦенГрупп;
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Истина;	
			Иначе
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Ложь;	
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;		
				
	///Исключение по ЦенГруппе
	Если ЭтотОбъект.Иключ_ЦенГруппе_Спис_Нал = Истина Тогда 
		Для Каждого НомГЦ из Иключ_ЦеновГруппа_Спис_Нал Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Наличка 			= Истина;
			НовСтрСН.Списывать 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;						
			НовСтрСН.ЦенГруппа 			= НомГЦ.ЦенГрупп;
			НовСтрСН.ПоЦенГруппе 		= Истина;
		КонецЦикла;
	КонецЕсли;
		
КонецФункции

Функция МеханизмРесчетаЗаполнения_Нач_Кред(ТаБДабов)
	
	///Исключение по Номенклотуре
	Если ЭтотОбъект.Иключ_Номенклотуре_Нач_Кред = Истина Тогда 
		Для Каждого НомНал из ЭтотОбъект.Иключ_Номенклотура_Нач_Кред Цикл 
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Кредит 			= Истина;
			НовСтрСН.Начислять 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;
			НовСтрСН.Номенклотура 		= НомНал.Номенклотура;
			НовСтрСН.ПоНоменклотуре 	= Истина;
		КонецЦикла;			
	КонецЕсли;
	
	///Исключение по Номенклотурной Группе и Ценновой если она включена
	Если ЭтотОбъект.Иключ_НомГруппе_Нач_Кред = Истина Тогда 
		Для Каждого НомГруп из ЭтотОбъект.Иключ_НоменкГруппы_Нач_Кред Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Кредит 		= Истина;
			НовСтрСН.Начислять 		= Истина;
			НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
			НовСтрСН.НомГруппа 		= НомГруп.НомГрупп;
			НовСтрСН.ПоГруппе 		= Истина;
			Если ЭтотОбъект.Иключ_Вкл_ЦенГруппе_Нач_Кред = Истина  и ЗначениеЗаполнено(НомГруп.ЦенГрупп) Тогда 
				НовСтрСН.ПоЦенГруппаВПоГруппа		= НомГруп.ЦенГрупп;
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Истина;	
			Иначе
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Ложь;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;		
				
	///Исключение по ЦенГруппе
	Если ЭтотОбъект.Иключ_ЦенГруппе_Нач_Кред = Истина Тогда 
		Для Каждого НомГЦ из ЭтотОбъект.Иключ_ЦеновГруппа_Нач_Кред Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Кредит 			= Истина;
			НовСтрСН.Начислять 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;						
			НовСтрСН.ЦенГруппа 			= НомГЦ.ЦенГрупп;
			НовСтрСН.ПоЦенГруппе 		= Истина;
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция МеханизмРесчетаЗаполнения_Спис_Кред(ТаБДабов)
		
	///Исключение по Номенклотуре
	Если ЭтотОбъект.Иключ_Номенклотуре_Спис_Кредит = Истина Тогда 
		Для Каждого НомНал из ЭтотОбъект.Иключ_Номенклотура_Спис_Кредит Цикл 
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Кредит 			= Истина;
			НовСтрСН.Списывать 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;
			НовСтрСН.Номенклотура 		= НомНал.Номенклотура;
			НовСтрСН.ПоНоменклотуре 	= Истина;
		КонецЦикла;			
	КонецЕсли;
	
	///Исключение по Номенклотурной Группе и Ценновой если она включена
	Если ЭтотОбъект.Иключ_НомГруппе_Спис_Кредит = Истина Тогда 
		Для Каждого НомГруп из ЭтотОбъект.Иключ_НоменкГруппы_Спис_Кредит Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Кредит 		= Истина;
			НовСтрСН.Списывать 		= Истина;
			НовСтрСН.Характеристика = ЭтотОбъект.Характеристика;					
			НовСтрСН.НомГруппа 		= НомГруп.НомГрупп;
			НовСтрСН.ПоГруппе 		= Истина;
			
			Если ЭтотОбъект.Иключ_Вкл_ЦенГруппе_Спис_Кредит = Истина  и ЗначениеЗаполнено(НомГруп.ЦенГрупп) Тогда 
				НовСтрСН.ПоЦенГруппаВПоГруппа		= НомГруп.ЦенГрупп;
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Истина;
			Иначе
				НовСтрСН.ПоЦенГруппеВПоГруппе 		= Ложь;				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;		
				
	///Исключение по ЦенГруппе
	Если ЭтотОбъект.Иключ_ЦенГруппе_Спис_Кредит = Истина Тогда 
		Для Каждого НомГЦ из ЭтотОбъект.Иключ_ЦеновГруппа_Спис_Кредит Цикл
			НовСтрСН = ТаБДабов.Добавить();
			НовСтрСН.Кредит 			= Истина;
			НовСтрСН.Списывать 			= Истина;
			НовСтрСН.Характеристика 	= ЭтотОбъект.Характеристика;						
			НовСтрСН.ЦенГруппа 			= НомГЦ.ЦенГрупп;
			НовСтрСН.ПоЦенГруппе 		= Истина;
		КонецЦикла;
	КонецЕсли;
		
КонецФункции

#КонецОбласти








