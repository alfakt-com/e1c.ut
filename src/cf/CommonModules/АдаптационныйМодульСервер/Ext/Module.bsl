﻿Функция ПолучитьСтруктуруКонвертацииУпаковок(Номенклатура, КлассификаторБазовойЕдИзм, КлассифкаторЦелевойЕдИзм) Экспорт
	СтруктураКонвертации = Новый Структура;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	УпаковкиНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	                      |	УпаковкиНоменклатуры.Коэффициент КАК Коэффициент
	                      |ИЗ
	                      |	Справочник.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	                      |ГДЕ
	                      |	УпаковкиНоменклатуры.Владелец = &Владелец
	                      |	И (УпаковкиНоменклатуры.ЕдиницаИзмерения = &КлассификаторБазовойЕдИзм
	                      |			ИЛИ УпаковкиНоменклатуры.ЕдиницаИзмерения = &КлассифкаторЦелевойЕдИзм)
	                      |	И НЕ УпаковкиНоменклатуры.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Владелец", Номенклатура.Ссылка);
	Запрос.УстановитьПараметр("КлассификаторБазовойЕдИзм", КлассификаторБазовойЕдИзм);
	Запрос.УстановитьПараметр("КлассифкаторЦелевойЕдИзм", КлассифкаторЦелевойЕдИзм);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда 
		ВыборкаЗапроса = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			Если ВыборкаЗапроса.ЕдиницаИзмерения = КлассификаторБазовойЕдИзм Тогда
				СтруктураКонвертации.Вставить("КоэффициентБазовойЕдИзм", ВыборкаЗапроса.Коэффициент);
			ИначеЕсли ВыборкаЗапроса.ЕдиницаИзмерения = КлассифкаторЦелевойЕдИзм Тогда 
				СтруктураКонвертации.Вставить("КоэффициентЦелевойЕдИзм", ВыборкаЗапроса.Коэффициент);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураКонвертации;
КонецФункции

Процедура ПровестиПроцедуруКонтроляЦелостностиРегистров(Параметры, АдресХранилища) Экспорт 
	ФайлОбработки = Новый Файл(КаталогПрограммы() + "КомпонентаКонтроляЦелостности.epf");
	
	Если ФайлОбработки.Существует() Тогда
		ОбработкаКонтроля = ВнешниеОбработки.Создать(ФайлОбработки.ПолноеИмя, Ложь);
		ОбработкаКонтроля.ВыполнитьСводныйКонтрольРегистров(Параметры, АдресХранилища);
	Иначе
		ПоместитьВоВременноеХранилище("Файл обработки не существует", АдресХранилища);
	КонецЕсли;
КонецПроцедуры