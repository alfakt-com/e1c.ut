#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии("ОткрытиеФормыРедактирования"));
	ИменаСохраняемыхРеквизитов = Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии("СохранениеРезультатов");
	
	НастроитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если АвтоматическиГенерироватьСерии Тогда
		
		Если Не ИспользоватьДатуПроизводстваСерии
			И Не ИспользоватьПроизводителяЕГАИССерии
			И Не ИспользоватьСправку2ЕГАИССерии Тогда
			
			ТекстСообщения = НСтр("ru = 'Автоматическая генарация серий возможна по реквизитам: ""Дата производства"", ""Производитель (ЕГАИС)"", ""Справка 2 (ЕГАИС)"". Включите использование одного из этих реквизитов.'");
			ПоказатьПредупреждение(,ТекстСообщения);
			
			Возврат;
		КонецЕсли;
		
	Иначе
		Если Не ИспользоватьНомерСерии
			И Не ИспользоватьСрокГодностиСерии
			И Не ИспользоватьНомерКИЗГИСМСерии
			И Не ИспользоватьДатуПроизводстваСерии
			И Не ИспользоватьПроизводителяЕГАИССерии
			И Не ИспользоватьСправку2ЕГАИССерии Тогда
			
			ТекстСообщения = НСтр("ru = 'Не выполнена настройка использования реквизитов серии.'");
			ПоказатьПредупреждение(,ТекстСообщения);
			
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Результат = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ИспользоватьСрокГодностиСерииПриИзменении(Элемент)
	ИспользоватьДатуПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуПроизводстваСерииПриИзменении(Элемент)
	ИспользоватьДатуПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИспользованияСерийПриИзменении(Элемент)
	ЭтоЭкземпляр = (НастройкаИспользованияСерий = ПредопределенноеЗначение("Перечисление.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара"));
	
	Если ЭтоЭкземпляр Тогда
		ИспользоватьНомерСерии     = Не КиЗГИСМ;
		ИспользоватьRFIDМеткиСерии = ПродукцияМаркируемаяДляГИСМ
									Или КиЗГИСМ; 
	Иначе
		ИспользоватьRFIDМеткиСерии = Ложь;
	КонецЕсли;
	
	НастроитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиГенерироватьСерииПриИзменении(Элемент)
	ИспользоватьНомерСерии = Ложь;
	НастроитьФорму();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИспользоватьДатуПриИзменении()
	
	Если (ИспользоватьСрокГодностиСерии
		Или ИспользоватьДатуПроизводстваСерии) Тогда 
		
		Если Не ЗначениеЗаполнено(ТочностьУказанияСрокаГодностиСерии) Тогда
			ТочностьУказанияСрокаГодностиСерии = ПредопределенноеЗначение("Перечисление.ТочностиУказанияСрокаГодности.СТочностьюДоДней");
		КонецЕсли;
	Иначе
		ТочностьУказанияСрокаГодностиСерии = ПредопределенноеЗначение("Перечисление.ТочностиУказанияСрокаГодности.ПустаяСсылка");
	КонецЕсли;
	
	НастроитьФорму();

КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	Элементы.ИспользоватьНомерКИЗГИСМСерии.Видимость = ПродукцияМаркируемаяДляГИСМ
														Или КиЗГИСМ;
		
	Элементы.ИспользоватьНомерСерии.Доступность = Не (НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара
													Или ПродукцияМаркируемаяДляГИСМ
													Или КиЗГИСМ)
													И Не АвтоматическиГенерироватьСерии;
		
	Элементы.ИспользоватьСрокГодностиСерии.Доступность     = Не КиЗГИСМ;
	Элементы.ИспользоватьДатуПроизводстваСерии.Доступность = Не КиЗГИСМ;
	
	Элементы.НастройкаИспользованияСерий.Доступность = Не (ПродукцияМаркируемаяДляГИСМ
															Или КиЗГИСМ)
														И Не АлкогольнаяПродукция;
	
	Элементы.ТочностьУказанияСрокаГодностиСерии.Доступность = ИспользоватьСрокГодностиСерии
																Или ИспользоватьДатуПроизводстваСерии;
	
	Элементы.ИспользоватьRFIDМетки.Видимость = (НастройкаИспользованияСерий
													= Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара);
	
	Элементы.ИспользоватьRFIDМетки.Доступность = Не ПродукцияМаркируемаяДляГИСМ
													И Не КиЗГИСМ;
	
	Элементы.АвтоматическиГенерироватьСерии.Видимость      = АлкогольнаяПродукция;
	Элементы.ИспользоватьПроизводителяЕГАИССерии.Видимость = АлкогольнаяПродукция;
	Элементы.ИспользоватьСправку2ЕГАИССерии.Видимость      = АлкогольнаяПродукция;
	
КонецПроцедуры

#КонецОбласти
