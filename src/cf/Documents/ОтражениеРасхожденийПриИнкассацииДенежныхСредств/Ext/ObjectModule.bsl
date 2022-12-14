
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
		
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, "СтатьяДоходов, АналитикаДоходов", МассивНепроверяемыхРеквизитов, Отказ);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, "СтатьяРасходов, АналитикаРасходов", МассивНепроверяемыхРеквизитов, Отказ);
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
		ЗаполнитьПоРасходномуКассовомуОрдеру(ДанныеЗаполнения, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВПути(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьПоРасходномуКассовомуОрдеру(Знач ДокументОснование, ДанныеЗаполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Организация        КАК Организация,
	|	ДанныеДокумента.Подразделение      КАК Подразделение,
	|	ДанныеДокумента.Касса              КАК Касса,
	|	ДанныеДокумента.БанковскийСчет     КАК БанковскийСчет,
	|	ДанныеДокумента.Валюта             КАК Валюта,
	|	
	|	&Ссылка КАК РасходныйКассовыйОрдер,
	|	ПРЕДСТАВЛЕНИЕ(ДанныеДокумента.Ссылка) КАК Основание,
	|	
	|	ВЫБОР КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) > 0 ТОГДА
	|		ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0)
	|	КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) < 0 ТОГДА
	|		-ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК Сумма,
	|	
	|	ВЫБОР КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) < 0 ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств)
	|	КОНЕЦ КАК ХозяйственнаяОперация
	|	
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК ДанныеДокумента
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ДенежныеСредстваВПути.Остатки(, 
	|			ВидПереводаДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк)
	|		) КАК ДенежныеСредства
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = ДенежныеСредства.Получатель
	|		И ДанныеДокумента.Касса = ДенежныеСредства.Отправитель
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование); 
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется отражать расхождение при инкассации денежных средств на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		ДанныеЗаполнения = Новый Структура;
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			ДанныеЗаполнения.Вставить(Колонка.Имя);
		КонецЦикла;
	
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ПрочиеДоходы);
		Массив.Добавить(Движения.ПрочиеРасходы);
		Массив.Добавить(Движения.ПартииПрочихРасходов);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
