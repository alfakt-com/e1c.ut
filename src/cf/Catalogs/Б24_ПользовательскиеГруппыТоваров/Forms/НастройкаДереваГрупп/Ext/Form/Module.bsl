﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.ДеревоГрупп) тогда
		
		НовыйОбъект = Справочники.Б24_ПользовательскиеГруппыТоваров.СоздатьЭлемент();
		НовыйОбъект.Наименование = Параметры.Наименование;
		НовыйОбъект.Записать();
		Инфоблок = НовыйОбъект.Ссылка;
		
	Иначе
		Инфоблок = Параметры.ДеревоГрупп;	
	КонецЕсли;
	
	
	ПользовательскоеДерево.Параметры.УстановитьЗначениеПараметра("НашаГруппа"	, Инфоблок);
	Номенклатура.Параметры.УстановитьЗначениеПараметра("НашаГруппа"				, Инфоблок);
	Номенклатура.Параметры.УстановитьЗначениеПараметра("НеОтображать"			, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
			
	Оповестить("ДеревоГрупп", Инфоблок);

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДобавитьВДерево(Команда)
	
	Если Элементы.ПользовательскоеДерево.ТекущиеДанные = НеОпределено Тогда
		ПоказатьОповещениеПользователя("Строка дерева должна быть выбрана.");
		Возврат;
	КонецЕсли;
	
	лВыделенныеСтроки = Элементы.Номенклатура.ВыделенныеСтроки; 
	
	ДобавитьТоварВРазделСервер(Элементы.ПользовательскоеДерево.ТекущиеДанные.Ссылка, лВыделенныеСтроки);
	
	Элементы.ПользовательскоеДерево.Обновить();
	Элементы.Товары.Обновить();
	Элементы.Номенклатура.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьТоварВРазделСервер(Раздел, ВыделенныеТовары)
	
	РазделОбъект = Раздел.ПолучитьОбъект();
	
	Для Каждого ТекНоменклатура Из ВыделенныеТовары Цикл
	
		Если НЕ ЗначениеЗаполнено(ТекНоменклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НоменклатураОтбор.Количество() > 0 Тогда
			Если НоменклатураОтбор.НайтиПоЗначению(ТекНоменклатура) = НеОпределено Тогда
				Сообщить("Номенклатура """ + ТекНоменклатура + """ не соответствует отбору.");
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Раздел = ТоварУжеВыбран(ТекНоменклатура);
		
		Если Раздел <> "" тогда
			Сообщить("Товар уже указан в разделе '"+Раздел+"'");
			Продолжить;
		КонецЕсли;
		
		Если НЕ РазделОбъект.Товары.Найти(ТекНоменклатура) = НеОпределено Тогда
			Продолжить;
		КонецЕсли;
		
		РазделОбъект.Товары.Добавить().Номенклатура = ТекНоменклатура;
		
	КонецЦикла;

	РазделОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Функция ТоварУжеВыбран(Товар)
	
	Результат = "";
	
	ЗапросГрупп = Новый Запрос;
	ЗапросГрупп.УстановитьПараметр("Инфоблок", Инфоблок); 
	
	ЗапросГрупп.Текст = "ВЫБРАТЬ
	                    |	Б24_ПользовательскиеГруппыТоваровТоваровТовары.Номенклатура КАК Номенклатура,
	                    |	Б24_ПользовательскиеГруппыТоваровТоваровТовары.Номенклатура.ЭтоГруппа КАК ЭтоГруппа,
	                    |	Б24_ПользовательскиеГруппыТоваровТоваровТовары.Ссылка.Наименование КАК НаименованиеРаздела
	                    |ИЗ
	                    |	Справочник.Б24_ПользовательскиеГруппыТоваров.Товары КАК Б24_ПользовательскиеГруппыТоваровТоваровТовары
	                    |ГДЕ
	                    |	Б24_ПользовательскиеГруппыТоваровТоваровТовары.Ссылка В ИЕРАРХИИ(&Инфоблок)";
	
	ВыборкаГрупп = ЗапросГрупп.Выполнить().Выбрать();
	
	МенеджерВременныхТаблиц = новый МенеджерВременныхТаблиц;
	
	ЗапросТоваров = Новый Запрос;
	ЗапросТоваров.УстановитьПараметр("Товар", Товар);
	ЗапросТоваров.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗапросТоваров.Текст = "ВЫБРАТЬ
	                      |	Номенклатура.Ссылка КАК Номенклатура
	                      |ПОМЕСТИТЬ ВремНоменклатура
	                      |ИЗ
	                      |	Справочник.Номенклатура КАК Номенклатура
	                      |ГДЕ
	                      |	Номенклатура.Ссылка = &Товар
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	Номенклатура";	
	ЗапросТоваров.Выполнить();
	
	ЗапросТоваров = Новый Запрос;
	ЗапросТоваров.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Пока ВыборкаГрупп.Следующий() Цикл
		
		Если ВыборкаГрупп.ЭтоГруппа = Истина тогда
			ЗапросТоваров.Текст = 
			"ВЫБРАТЬ
			|	ВремНоменклатура.Номенклатура
			|ИЗ
			|	ВремНоменклатура КАК ВремНоменклатура
			|ГДЕ
			|	ВремНоменклатура.Номенклатура В ИЕРАРХИИ(&Группа)";
			ЗапросТоваров.УстановитьПараметр("Группа", ВыборкаГрупп.Номенклатура);
		Иначе
			ЗапросТоваров.Текст = 
			"ВЫБРАТЬ
			|	ВремНоменклатура.Номенклатура
			|ИЗ
			|	ВремНоменклатура КАК ВремНоменклатура
			|ГДЕ
			|	ВремНоменклатура.Номенклатура = &Номенклатура";
			ЗапросТоваров.УстановитьПараметр("Номенклатура", ВыборкаГрупп.Номенклатура);
		КонецЕсли;
		
		ВыполненныйЗапрос = ЗапросТоваров.Выполнить();
		Если ВыполненныйЗапрос.Пустой() Тогда
			Продолжить;
		КонецЕсли;
		
		Результат = ВыборкаГрупп.НаименованиеРаздела;  
		Прервать;
		
	КонецЦикла;
	
	Возврат	Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура КомандаУдалитьИзДерева(Команда)
	
	Если Элементы.Товары.ТекущиеДанные = НеОпределено Тогда
		ПоказатьОповещениеПользователя("Удаляемый товар раздела должен быть выбран.");
		Возврат;
	КонецЕсли;
	
	ВыделенныеТовары = Элементы.Товары.ВыделенныеСтроки;	
	
	Для Каждого ТекИндекс Из ВыделенныеТовары Цикл
		
		лТовар = Элементы.Товары.ДанныеСтроки(ТекИндекс).Товар;
		
		УдалитьТоварИзРазделаСервер(Элементы.ПользовательскоеДерево.ТекущиеДанные.Ссылка, лТовар);
	
	КонецЦикла;
	
	Элементы.ПользовательскоеДерево.Обновить();
	Элементы.Товары.Обновить();
	Элементы.Номенклатура.Обновить();
	
КонецПроцедуры

Процедура УдалитьТоварИзРазделаСервер(Раздел, пТовар)
	
	РазделОбъект = Раздел.ПолучитьОбъект();
	
	НайденнаяСтрока = РазделОбъект.Товары.Найти(пТовар);
	
	Если НайденнаяСтрока <> Неопределено Тогда
		
		РазделОбъект.Товары.Удалить(РазделОбъект.Товары.Индекс(НайденнаяСтрока));
		
	КонецЕсли;
	
	РазделОбъект.Записать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Функция ПоказатьВхождениеВГруппыНаСервере(Товар)
	
	Результат = "";
	
	мНоменлатуры = Новый Массив;
	
	ДобавитьРодителяНоменклатурыРекурсивно(мНоменлатуры, Товар);	
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Б24_ПользовательскиеГруппыТоваровТовары.Ссылка КАК Раздел
	|ИЗ
	|	Справочник.Б24_ПользовательскиеГруппыТоваров.Товары КАК Б24_ПользовательскиеГруппыТоваровТовары
	|ГДЕ
	|	Б24_ПользовательскиеГруппыТоваровТовары.Номенклатура В(&СписокНоменлатуры)
	|	И Б24_ПользовательскиеГруппыТоваровТовары.Ссылка В ИЕРАРХИИ(&Инфоблок)";
	
	Запрос.УстановитьПараметр("Инфоблок", Инфоблок);
	Запрос.УстановитьПараметр("СписокНоменлатуры", мНоменлатуры);
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	
	Пока Выборка.Следующий() Цикл
		
		Результат = Результат + Выборка.Раздел + Символы.ПС;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВхождениеВГруппы(Команда)
	
	
	Если Элементы.Номенклатура.ТекущиеДанные = НеОпределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя("Номенклатура входит в разделы",,ПоказатьВхождениеВГруппыНаСервере(Элементы.Номенклатура.ТекущиеДанные.Ссылка));
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРодителяНоменклатурыРекурсивно(МассивНоменклатуры, Товар)
	
	МассивНоменклатуры.Добавить(Товар);
	
	Если ЗначениеЗаполнено(Товар.Родитель) тогда
		ДобавитьРодителяНоменклатурыРекурсивно(МассивНоменклатуры, Товар.Родитель);	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура КомандаЭкспортВФайл(Команда)
		
	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопросаОСохраненииДерева", ЭтаФорма, Параметры), "С пользовательскими разделами выгружать номенклатуру?", РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОСохраненииДерева(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьДерево(Истина);	
	Иначе
		СохранитьДерево();	
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьДерево(ВыгружатьНоменклатуру = Ложь)

	АдресДоДерева = СохранитьДеревоНаСервере(ВыгружатьНоменклатуру);
		
	ПолучитьФайл(АдресДоДерева,  Строка(Инфоблок)+ ".xml", Истина);
	
КонецПроцедуры

&НаСервере
Функция СохранитьДеревоНаСервере(ВыгружатьНоменклатуру)
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла();
	
	СтрокаXML = "";
	ПолучитьXMLСервер(СтрокаXML, ВыгружатьНоменклатуру);
	
	ФайлXML = Новый ТекстовыйДокумент;
	ФайлXML.УстановитьТекст(СтрокаXML);
	ФайлXML.Записать(ПутьКФайлу);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлу);
	
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
КонецФункции

&НаСервере
Процедура ПолучитьXMLСервер(СтрокаXML, ВыгружатьНоменклатуру)

	ОбъектXML = Новый ЗаписьXML();
	ОбъектXML.УстановитьСтроку("UTF-8");
	ОбъектXML.ЗаписатьОбъявлениеXML();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Б24_ПользовательскиеГруппыТоваров.Ссылка КАК Ссылка,
	               |	Б24_ПользовательскиеГруппыТоваров.ПометкаУдаления КАК ПометкаУдаления,
	               |	Б24_ПользовательскиеГруппыТоваров.Родитель КАК Родитель,
	               |	Б24_ПользовательскиеГруппыТоваров.Родитель.ИдентификаторРаздела КАК ИдРодителя,
	               |	Б24_ПользовательскиеГруппыТоваров.Наименование КАК Наименование,
	               |	Б24_ПользовательскиеГруппыТоваров.ИдентификаторРаздела КАК ИдентификаторРаздела,
	               |	Б24_ПользовательскиеГруппыТоваров.Товары.(
	               |		Номенклатура КАК Номенклатура
	               |	) КАК Товары,
	               |	Б24_ПользовательскиеГруппыТоваров.Инфоблок КАК Инфоблок
	               |ИЗ
	               |	Справочник.Б24_ПользовательскиеГруппыТоваров КАК Б24_ПользовательскиеГруппыТоваров
	               |ГДЕ
	               |	Б24_ПользовательскиеГруппыТоваров.Ссылка В ИЕРАРХИИ(&Инфоблок)
	               |	И Б24_ПользовательскиеГруппыТоваров.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Инфоблок",Инфоблок);
	
	Выборка	= Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ОбъектXML.ЗаписатьНачалоЭлемента("Разделы");
	
		Пока Выборка.Следующий() Цикл
			
			ОбъектXML.ЗаписатьНачалоЭлемента("Раздел");
			
				ОбъектXML.ЗаписатьНачалоЭлемента("Ид");
				ОбъектXML.ЗаписатьТекст(Выборка.ИдентификаторРаздела);
				ОбъектXML.ЗаписатьКонецЭлемента();
				
				ОбъектXML.ЗаписатьНачалоЭлемента("Наименование");
				ОбъектXML.ЗаписатьТекст(Выборка.Наименование); // По схеме
				ОбъектXML.ЗаписатьКонецЭлемента();
				
				ОбъектXML.ЗаписатьНачалоЭлемента("ЭтоИнфоблок");
				ОбъектXML.ЗаписатьТекст(XMLСтрока(Выборка.Инфоблок)); 
				ОбъектXML.ЗаписатьКонецЭлемента();
				
				ОбъектXML.ЗаписатьНачалоЭлемента("ИдРодителя");
				ОбъектXML.ЗаписатьТекст(XMLСтрока(Выборка.ИдРодителя)); 
				ОбъектXML.ЗаписатьКонецЭлемента();
				
				лТовары = Выборка.Товары.выгрузить();
				Если лТовары.Количество() > 0 И ВыгружатьНоменклатуру тогда
					
					ОбъектXML.ЗаписатьНачалоЭлемента("Номенклатура");
			
						Для Каждого ТекЭлемент из лТовары Цикл
							ОбъектXML.ЗаписатьНачалоЭлемента("ЭлементНоменклатуры");
								ОбъектXML.ЗаписатьТекст(XMLСтрока(ТекЭлемент.Номенклатура));	
							ОбъектXML.ЗаписатьКонецЭлемента();
						КонецЦикла;
					ОбъектXML.ЗаписатьКонецЭлемента();
					
				КонецЕсли;
			ОбъектXML.ЗаписатьКонецЭлемента();
				
		КонецЦикла;
		
	ОбъектXML.ЗаписатьКонецЭлемента();
	
	СтрокаXML = ОбъектXML.Закрыть();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


&НаКлиенте
Процедура КомандаИмпортИзФайла(Команда)
	
	Если Элементы.ПользовательскоеДерево.ТекущиеДанные <> Неопределено тогда
	
		ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопросаОИмпортеДерева", ЭтаФорма, Параметры), "Дерево групп будет очищено и загружено из файла. Продолжить?", РежимДиалогаВопрос.ДаНет);

	Иначе
		ЗагрузитьДерево();  	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОИмпортеДерева(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда      
		ЗагрузитьДерево();
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьИнформациюОИнфоблоке()
	
	Выборка = Справочники.Б24_ПользовательскиеГруппыТоваров.Выбрать(Инфоблок);
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Ссылка <> Инфоблок тогда
			Выборка.ПолучитьОбъект().Удалить();	
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДерево()
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл";
	Диалог.МножественныйВыбор = Ложь;
	//Диалог.Фильтр = "(*.xml)|*.xml";
	Диалог.ПроверятьСуществованиеФайла = Истина;
	
	ОбработкаОкончанияЗагрузки = Новый ОписаниеОповещения("Обработчик_Завершения_Загрузки", ЭтаФорма, Диалог); 

	НачатьПомещениеФайла(ОбработкаОкончанияЗагрузки, , Диалог, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Обработчик_Завершения_Загрузки(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		 Обработчик_Завершения_ЗагрузкиСервер(Адрес, ВыбранноеИмяФайла); 
		
		Элементы.ПользовательскоеДерево.Обновить();
		Элементы.Товары.Обновить();
		Элементы.Номенклатура.Обновить();
		
	Иначе
		Сообщить("Файл не был указан.");
	КонецЕсли 
	
КонецПроцедуры

&НаСервере
Процедура Обработчик_Завершения_ЗагрузкиСервер(Адрес, ИмяФайла = "") 
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Б24_ОбщегоНазначенияСервер.ПолучитьРасширениеФайлаПоНаименованию(ИмяФайла));
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Адрес);	
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
	
	ТекстXML = Новый ТекстовыйДокумент;
	ТекстXML.Прочитать(ИмяВременногоФайла);
	СтрокаXML = ТекстXML.ПолучитьТекст();
	
	РазобратьЗагрузитьXMLСервер(СтрокаXML);
	
	УдалитьФайлы(ИмяВременногоФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДеревоЗавершение(МассивФайлов,ДополнительныеПараметры) Экспорт
	
	Если МассивФайлов<>Неопределено Тогда
		
		ИмяФайла=МассивФайлов.Получить(0);
		
		СтрокаXML = "";
		
		ТекстXML = Новый ТекстовыйДокумент;
		ТекстXML.Прочитать(ИмяФайла);
		СтрокаXML = ТекстXML.ПолучитьТекст();
		
		РазобратьЗагрузитьXMLСервер(СтрокаXML);
		
		Элементы.ПользовательскоеДерево.Обновить();
		Элементы.Товары.Обновить();
		Элементы.Номенклатура.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазобратьЗагрузитьXMLСервер(СтрокаXML)

	ЧтениеXML = Новый ЧтениеXML;
	
	Попытка
		ЧтениеXML.УстановитьСтроку(СтрокаXML);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	ТзнДанных = Новый ТаблицаЗначений;
	ТзнДанных.Колонки.Добавить("Ид");	
	ТзнДанных.Колонки.Добавить("Наименование");	
	ТзнДанных.Колонки.Добавить("ИдРодителя");	
	ТзнДанных.Колонки.Добавить("ЭтоИнфоблок");	
	ТзнДанных.Колонки.Добавить("Товары");	
	
	лЭтоРазделы			= Ложь;
	лЭтоИд 				= Ложь;
	лЭтоИдРодителя		= Ложь;
	лЭтоНаименование	= Ложь;
	лЭтоИнфоблок		= Ложь;
	лЭтоНоменклатура	= Ложь;
	
	Пока ЧтениеXML.Прочитать() Цикл
			
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Разделы" тогда
			лЭтоРазделы = Истина;
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Разделы" тогда
			лЭтоРазделы = Ложь;
		КонецЕсли;
		
		Если лЭтоРазделы тогда

			Если ЧтениеXML.ТипУзла 	= ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Раздел" тогда
				СтруктураСтр 	= Новый Структура("Ид, Наименование, ЭтоИнфоблок, ИдРодителя");
				мНоменклатура 	= новый Массив;
			КонецЕсли;
			
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Ид" тогда
					лЭтоИд 				= Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "ИдРодителя" тогда
					лЭтоИдРодителя 		= Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Наименование" тогда
					лЭтоНаименование 	= Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "ЭтоИнфоблок" тогда
					лЭтоИнфоблок 		= Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "ЭлементНоменклатуры" тогда
					лЭтоНоменклатура 	= Истина;
				КонецЕсли;
				
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Ид" тогда
					лЭтоИд 				= Ложь;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "ИдРодителя" тогда
					лЭтоИдРодителя 		= Ложь;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Наименование" тогда
					лЭтоНаименование 	= Ложь;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "ЭтоИнфоблок" тогда
					лЭтоИнфоблок 		= Ложь;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "ЭлементНоменклатуры" тогда
					лЭтоНоменклатура 	= Ложь;
				КонецЕсли;
				
				
				Если лЭтоНаименование И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.Наименование = ЧтениеXML.Значение;
				КонецЕсли;
				
				Если лЭтоИд И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.Ид = ЧтениеXML.Значение;
				КонецЕсли;
				
				Если лЭтоИдРодителя И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.ИдРодителя = ЧтениеXML.Значение;
				КонецЕсли;
				
				Если лЭтоИнфоблок И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.ЭтоИнфоблок = XMLЗначение(Тип("Булево") , ЧтениеXML.Значение);
				КонецЕсли;
				
				Если лЭтоНоменклатура И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					мНоменклатура.Добавить(ЧтениеXML.Значение);
				КонецЕсли;
				
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Раздел" тогда
				
				НовСтр = ТзнДанных.Добавить();
				НовСтр.Ид 			= СтруктураСтр.Ид;
				НовСтр.ИдРодителя 	= СтруктураСтр.ИдРодителя;
				НовСтр.Наименование = СтруктураСтр.Наименование;
				НовСтр.ЭтоИнфоблок 	= СтруктураСтр.ЭтоИнфоблок;
				НовСтр.Товары		= мНоменклатура;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	УдалитьИнформациюОИнфоблоке();
	
	ИдИмпортируемогоИнфоблока = "";
	Для каждого ТекСтрока из ТзнДанных Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Ид) тогда
			
			лОбъект = Инфоблок.ПолучитьОбъект();
			ИдИмпортируемогоИнфоблока = ТекСтрока.Ид; 
			
			лОбъект.Товары.Очистить(); 			
			Для каждого ТекТовар из ТекСтрока.Товары Цикл
				лОбъект.Товары.Добавить().Номенклатура = XMLЗначение(Тип("СправочникСсылка.Номенклатура") , ТекТовар);
			КонецЦикла;
			
			лОбъект.Записать();
			
		Иначе
			
			НовыйЭлемент = Справочники.Б24_ПользовательскиеГруппыТоваров.СоздатьЭлемент();
			НовыйЭлемент.Наименование 			= ТекСтрока.Наименование;
			НовыйЭлемент.ИдентификаторРаздела 	= ТекСтрока.Ид;
			
			Если ИдИмпортируемогоИнфоблока = ТекСтрока.ИдРодителя ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.ИдРодителя) тогда
				НовыйЭлемент.Родитель	= Инфоблок;
			Иначе                                                 
				НовыйЭлемент.Родитель	= ПолучитьРодителяПоИд(ТекСтрока.ИдРодителя);
			КонецЕсли;
			
			Для каждого ТекТовар из ТекСтрока.Товары Цикл
				НовыйЭлемент.Товары.Добавить().Номенклатура = XMLЗначение(Тип("СправочникСсылка.Номенклатура") , ТекТовар);
			КонецЦикла;
			
			НовыйЭлемент.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	ЧтениеXML.Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРодителяПоИд(ИдРодителя)
	
	Результат = Справочники.Б24_ПользовательскиеГруппыТоваров.ПустаяСсылка();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Б24_ПользовательскиеГруппыТоваров.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Б24_ПользовательскиеГруппыТоваров КАК Б24_ПользовательскиеГруппыТоваров
	               |ГДЕ
	               |	Б24_ПользовательскиеГруппыТоваров.Ссылка В ИЕРАРХИИ(&Инфоблок)
	               |	И Б24_ПользовательскиеГруппыТоваров.ИдентификаторРаздела = &ИдРодителя";
	Запрос.УстановитьПараметр("Инфоблок", Инфоблок);
	Запрос.УстановитьПараметр("ИдРодителя", ИдРодителя);
	Выборка =  Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат = Выборка.Ссылка; 
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура КомандаВывестиНоменклатуруВОтчет(Команда)
	
	ВременныйТабличныйДокумент = Новый ТабличныйДокумент;
	
	
	СформироватьОтчетПоНоменклатуре(ВременныйТабличныйДокумент);
	
	ВременныйТабличныйДокумент.Показать();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетПоНоменклатуре(ВременныйТабличныйДокумент)
	
	Макет = Справочники.Б24_ПользовательскиеГруппыТоваров.ПолучитьМакет("ОтчетПоНоменклатуреДерева");
	
	ОбластьШапка= Макет.ПолучитьОбласть("Шапка");                                                                                                                                                                                                                                                                                                                                                
	ВременныйТабличныйДокумент.Вывести(ОбластьШапка);
	
	ВременныйТабличныйДокумент.НачатьАвтогруппировкуСтрок();	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Б24_ПользовательскиеГруппыТоваров.Ссылка КАК Раздел
	|ИЗ
	|	Справочник.Б24_ПользовательскиеГруппыТоваров КАК Б24_ПользовательскиеГруппыТоваров
	|ГДЕ
	|	Б24_ПользовательскиеГруппыТоваров.Ссылка В ИЕРАРХИИ(&Инфоблок)";
	Запрос.УстановитьПараметр("Инфоблок", Инфоблок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьТела= Макет.ПолучитьОбласть("Тело");  
		
		ОбластьТела.Параметры.Группа = Строка(?(Выборка.Раздел = Инфоблок, "Корневой раздел", Выборка.Раздел));
		ВременныйТабличныйДокумент.Вывести(ОбластьТела, 0, "Разделы");
		
		ДобавитьНоменклатуруРазделаВОтчет(Макет, ВременныйТабличныйДокумент, Выборка.Раздел);
		
	КонецЦикла;
       ВременныйТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();	
КонецПроцедуры

Процедура ДобавитьНоменклатуруРазделаВОтчет(Макет, ВременныйТабличныйДокумент, Раздел);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка КАК Товар
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.Ссылка В ИЕРАРХИИ(&МаасивТоваров)
	               |	И Номенклатура.ЭтоГруппа = ЛОЖЬ";
	Запрос.УстановитьПараметр("МаасивТоваров", Раздел.Товары.ВыгрузитьКолонку("Номенклатура"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьТела= Макет.ПолучитьОбласть("Тело1");                                                                                                                                                                                                                                                                                                                                                
		ОбластьТела.Параметры.Номенклатура = Строка(Выборка.Товар);
		ВременныйТабличныйДокумент.Вывести(ОбластьТела, 1, "Товары", Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтмечатьВыделенныеТовары(Команда)
	Элементы.НоменклатураОтмечатьВыделенныеТовары.Пометка = НЕ Элементы.НоменклатураОтмечатьВыделенныеТовары.Пометка;
	
	Номенклатура.Параметры.УстановитьЗначениеПараметра("НеОтображать"	, НЕ Элементы.НоменклатураОтмечатьВыделенныеТовары.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательскоеДеревоПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные <> Неопределено тогда
		Если ЭтоПредопределенныйЭлемент(Элемент.ТекущиеДанные.Ссылка) тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЭтоПредопределенныйЭлемент(пОбъект)
	
	Возврат пОбъект.Предопределенный;
	
КонецФункции


#КонецОбласти
