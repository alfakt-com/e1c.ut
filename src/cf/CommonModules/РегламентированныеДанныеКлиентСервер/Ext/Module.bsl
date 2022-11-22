﻿#Область ПрограммныйИнтерфейс

// Проверяет соответствие ИНН требованиям.
//
// Параметры:
//  ИНН                - Строка - проверяемый индивидуальный номер налогоплательщика.
//  ЭтоЮридическоеЛицо - Булево - признак, является ли владелец ИНН юридическим лицом.
//  ТекстСообщения     - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция ИННСоответствуетТребованиям(Знач ИНН, ЭтоЮридическоеЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ИНН      = СокрЛП(ИНН);
	ДлинаИНН = СтрДлина(ИНН);

	Если ЭтоЮридическоеЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца БИН/ИИН.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ИНН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'БИН/ИИН должен состоять только из цифр.'");
	КонецЕсли;

	Если  ЭтоЮридическоеЛицо И ДлинаИНН <> 12 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'БИН юридического лица должен состоять из 12 цифр.'");
	ИначеЕсли НЕ ЭтоЮридическоеЛицо И ДлинаИНН <> 12 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'ИИН физического лица должен состоять из 12 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда
	// а12 = (а1*b1+а2*b2+а3*b3+а4*b4+а5*b5+а6*b6+а7*b7+а8*b8+а9*b9+a10*b10+a11*b11) mod 11
		
		ПодстрокаИН11 = Лев(ИНН,11);        // копируем первые 11 символов
		КонтрольноеЗначение = Прав(ИНН, 1); // контрольная сумма ИИН/БИН
		
		// Разряд ИИН: 1 2 3 4 5 6 7 8 9 10 11
		// Вес разряда: 1 2 3 4 5 6 7 8 9 10 11
		
		СуммаРазрядов = 1 * Сред(ИНН, 1, 1) + 2 * Сред(ИНН, 2, 1) +
		3 * Сред(ИНН, 3, 1) + 4 * Сред(ИНН, 4, 1) +
		5 * Сред(ИНН, 5, 1) + 6 * Сред(ИНН, 6, 1) +
		7 * Сред(ИНН, 7, 1) + 8 * Сред(ИНН, 8, 1) +
		9 * Сред(ИНН, 9, 1) + 10 * Сред(ИНН, 10, 1) + 11 * Сред(ИНН, 11, 1);
		ВычисленноеКонтрольноеЗначение = СуммаРазрядов - Цел(СуммаРазрядов / 11) * 11; // mod - остаток от деления Суммы разрядов на 11.
		
		Если ВычисленноеКонтрольноеЗначение = 10 Тогда
			
			// Разряд ИИН: 1 2 3 4 5 6 7 8 9 10 11 
			// Вес разряда: 3 4 5 6 7 8 9 10 11 1 2
			
			СуммаРазрядов = 3 * Сред(ИНН, 1, 1) + 4 * Сред(ИНН, 2, 1) +
			5 * Сред(ИНН, 3, 1) + 6 * Сред(ИНН, 4, 1) +
			7 * Сред(ИНН, 5, 1) + 8 * Сред(ИНН, 6, 1) +
			9 * Сред(ИНН, 7, 1) + 10 * Сред(ИНН, 8, 1) +
			11 * Сред(ИНН, 9, 1) + 1 * Сред(ИНН, 10, 1) + 2 * Сред(ИНН, 11, 1);
			ВычисленноеКонтрольноеЗначение = СуммаРазрядов - Цел(СуммаРазрядов / 11) * 11;   
			
		КонецЕсли;
		
		Если ВычисленноеКонтрольноеЗначение <> Число(КонтрольноеЗначение) Тогда
			
			СоответствуетТребованиям = Ложь;
			ТекстСообщения = НСтр("ru = 'Контрольное число для ИИН / БИН не совпадает с рассчитанным.'");
			
		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие КПП требованиям.
// Согласно приложению к приказу ФНС России от 29.06.2012 N ММВ-7-6/435@
// "Об утверждении Порядка и условий присвоения, применения, а также изменения
// идентификационного номера налогоплательщика".
//
// Параметры:
//  КПП            - Строка - проверяемый код причины постановки на учет.
//  ТекстСообщения - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция КППСоответствуетТребованиям(Знач КПП, ТекстСообщения) Экспорт

	Возврат Истина;
	
	Ошибки = Новый Массив;
	КПП = СокрЛП(КПП);
	
	Если СтрДлина(КПП) <> 9 Тогда
		Ошибки.Добавить(НСтр("ru = 'КПП должен состоять из 9 символов.'"));
	Иначе
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Лев(КПП, 4)) Тогда
			Ошибки.Добавить(НСтр("ru = 'Первые 4 символа КПП (код налогового органа) должны быть цифрами.'"));
		КонецЕсли;
		
		ДопустимыеСимволы = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		Для НомерСимвола = 5 По 6 Цикл
			Символ = Сред(КПП, НомерСимвола, 1);
			Если СтрНайти(ДопустимыеСимволы, Символ) = 0 Тогда
				Ошибки.Добавить(НСтр("ru = 'Символы 5-6 КПП (причина постановки на учет) должны быть цифрами и/или заглавными буквами латинского алфавита от A до Z.'"));
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Прав(КПП, 3)) Тогда
			Ошибки.Добавить(НСтр("ru = 'Последние 3 символа КПП (порядковый номер постановки на учет) должны быть цифрами.'"));
		КонецЕсли;
	КонецЕсли;
	
	ТекстСообщения = СтрСоединить(Ошибки, Символы.ПС);
	
	Возврат Ошибки.Количество() = 0;

КонецФункции

// Проверяет соответствие ОГРН требованиям.
//
// Параметры:
//  ОГРН               - Строка - проверяемый основной государственный регистрационный номер.
//  ЭтоЮридическоеЛицо - Булево - признак, является ли владелец ОГРН юридическим лицом.
//  ТекстСообщения     - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция ОГРНСоответствуетТребованиям(Знач ОГРН, ЭтоЮридическоеЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ОГРН = СокрЛП(ОГРН);
	ДлинаОГРН = СтрДлина(ОГРН);
	
	Если ЭтоЮридическоеЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца ОГРН.'");
		Возврат Ложь;
	КонецЕсли;

	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ОГРН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'ОГРН должен состоять только из цифр.'")
	КонецЕсли;

	Если ЭтоЮридическоеЛицо И ДлинаОГРН <> 13 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ОГРН юридического лица должен состоять из 13 цифр.'");
	ИначеЕсли НЕ ЭтоЮридическоеЛицо И ДлинаОГРН <> 15 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ОГРН физического лица должен состоять из 15 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда

		Если ЭтоЮридическоеЛицо Тогда

			КонтрольныйРазряд = Прав(Формат(Число(Лев(ОГРН, 12)) % 11, "ЧН=0; ЧГ=0"), 1);

			Если КонтрольныйРазряд <> Прав(ОГРН, 1) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ОГРН не совпадает с рассчитанным.'");
			КонецЕсли;

		Иначе

			КонтрольныйРазряд = Прав(Формат(Число(Лев(ОГРН, 14)) % 13, "ЧН=0; ЧГ=0"), 1);

			Если КонтрольныйРазряд <> Прав(ОГРН, 1) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ОГРН не совпадает с рассчитанным.'");
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие кода ОКПО требованиям стандартов.
//
// Параметры:
//  ПроверяемыйКод         - Строка - проверяемый код ОКПО;
//  ЭтоЮридическоеЛицо     - Булево - признак, является ли владелец кода ОКПО юридическим лицом;
//  ТекстСообщения         - Строка - текст сообщения о найденных ошибках в проверяемом коде ОКПО.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция КодПоОКПОСоответствуетТребованиям(Знач ПроверяемыйКод, ЭтоЮридическоеЛицо, ТекстСообщения = "") Экспорт
	
	ПроверяемыйКод = СокрЛП(ПроверяемыйКод);
	ТекстСообщения = "";
	ДлинаКода = СтрДлина(ПроверяемыйКод);

	Если ЭтоЮридическоеЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца кода ОКПО.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПроверяемыйКод) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО должен состоять только из цифр.'") + Символы.ПС;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = СокрЛП(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Если Не КодКлассификатораВерный(ПроверяемыйКод) Тогда
		ТекстСообщения = НСтр("ru = 'Контрольное число для кода по ОКПО не совпадает с рассчитанным.'");
		Возврат Ложь
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции 

// Проверяет номер страхового свидетельства на соответствие требованиям ПФР.
//
// Параметры:
//  СтраховойНомер - Строка - страховой номер ПФР. Строка должна быть ведена по шаблону "999-999-999 99".
//  ТекстСообщения - Строка - текст сообщения об ошибке ввода страхового номера.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция СтраховойНомерПФРСоответствуетТребованиям(Знач СтраховойНомер, ТекстСообщения) Экспорт
	
	ТекстСообщения = "";
	
	СтрокаЦифр = СтрЗаменить(СтраховойНомер, "-", "");
	СтрокаЦифр = СтрЗаменить(СтрокаЦифр, " ", "");
	
	Если ПустаяСтрока(СтрокаЦифр) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер не заполнен'");
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(СтрокаЦифр) < 11 Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер задан неполностью'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаЦифр) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер должен состоять только из цифр.'");
		Возврат Ложь;
	КонецЕсли;
	
	КонтрольноеЧисло = Число(Прав(СтрокаЦифр, 2));
	
	Если Число(Лев(СтрокаЦифр, 9)) > 1001998 Тогда
		Всего = 0;
		Для Сч = 1 По 9 Цикл
			Всего = Всего + Число(Сред(СтрокаЦифр, 10 - Сч, 1)) * Сч;
		КонецЦикла;
		Остаток = Всего % 101;
		Остаток = ?(Остаток = 100, 0, Остаток);
		Если Остаток <> КонтрольноеЧисло Тогда
			ТекстСообщения = ТекстСообщения + НСтр("ru = 'Контрольное число для страхового номера не совпадает с рассчитанным.'");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Проверка контрольного ключа в номере лицевого счета (9-й разряд номера счета),
// алгоритм установлен документом:
// "ПОРЯДОК РАСЧЕТА КОНТРОЛЬНОГО КЛЮЧА В НОМЕРЕ ЛИЦЕВОГО СЧЕТА"
// (утв. ЦБ РФ 08.09.1997 N 515).
//
// Параметры:
//  НомерСчета - Строка - номер банковского счета.
//  БИК - Строка - БИК банка в котором открыт счет.
//  ЭтоБанк - Булево - если Истина, то проверяется банковский счет, иначе проверяется как счет РКЦ 
//                     (у РКЦ корреспондентский счет не заполняется).
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция КонтрольныйКлючЛицевогоСчетаСоответствуетТребованиям(НомерСчета, БИК, ЭтоБанк = Истина)Экспорт
	
	НомерСчетаСтрока = СокрЛП(НомерСчета);
	
	// При наличии алфавитного значения в 6-ом разряде лицевого 
	// счета (в случае использования клиринговой валюты) данный символ 
	// заменяется на соответствующую цифру:
	Разряд6 = Сред(НомерСчетаСтрока, 6, 1); 
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Разряд6) Тогда
		АлфавитныеЗначения6гоРазряда = СтрРазделить("А,В,С,Е,Н,К,М,Р,Т,Х", ",", Ложь);
		Цифра = АлфавитныеЗначения6гоРазряда.Найти(Разряд6);	
		Если Цифра = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		Разряд6 = Строка(Цифра);
	КонецЕсли;
	
	// Для расчета контрольного ключа используется совокупность двух 
	// реквизитов - условного номера РКЦ (если лицевой счет открыт в РКЦ) 
	// или кредитной организации (если лицевой счет открыт в кредитной 
	// организации) и номера лицевого счета.
	Если ЭтоБанк Тогда
		УсловныйНомерКО = Прав(БИК, 3);
	Иначе
		УсловныйНомерКО = "0" + Сред(БИК, 5, 2 );
	КонецЕсли;
	
	НомерСчетаСтрока = УсловныйНомерКО + Лев(НомерСчетаСтрока,5) + Разряд6 + Сред(НомерСчетаСтрока, 7);
	
	Если СтрДлина(НомерСчетаСтрока) <> 23 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерСчетаСтрока) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВесовыеКоэффициенты = "71371371371371371371371";
	КонтрольнаяСумма = 0;
	Для Разряд = 1 По 23 Цикл
		Произведение = Число(Сред(НомерСчетаСтрока, Разряд, 1)) * Число(Сред(ВесовыеКоэффициенты, Разряд, 1));
		МладшийРазряд = Число(Прав(Строка(Произведение), 1));
		КонтрольнаяСумма = КонтрольнаяСумма + МладшийРазряд;
	КонецЦикла;
	
	// При получении суммы, кратной 10 (младший разряд равен 0), значение 
	// контрольного ключа считается верным.
	
	Возврат Прав(Строка(КонтрольнаяСумма), 1) = "0";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет правильность кода по контрольному числу (последняя цифра в коде).
//
// ПР 50.1.024-2005 «Основные положения и порядок проведения работ по разработке, ведению и применению общероссийских
// классификаторов», приложение В.
//
// Контрольное число рассчитывается следующим образом:
// 1. Разрядам кода в общероссийском классификаторе, начиная со старшего разряда, присваивается набор весов,
// соответствующий натуральному ряду чисел от 1 до 10. Если разрядность кода больше 10, то набор весов повторяется.
// 2. Каждая цифра кода умножается на вес разряда и вычисляется сумма полученных произведений.
// 3. Контрольное число для кода представляет собой остаток от деления полученной суммы на модуль «11».
// 4. Контрольное число должно иметь один разряд, значение которого находится в пределах от 0 до 9.
// Если получается остаток, равный 10, то для обеспечения одноразрядного контрольного числа необходимо провести
// повторный расчет, применяя вторую последовательность весов, сдвинутую на два разряда влево (3, 4, 5,…). Если в
// случае повторного расчета остаток от деления вновь сохраняется равным 10, то значение контрольного числа
// проставляется равным «0».
//
// Параметры:
//  ПроверяемыйКод - Строка - код для проверки.
//
// Возвращаемое значение:
//  Булево - Истина, если верный.
//
Функция КодКлассификатораВерный(ПроверяемыйКод)
	
	//По ГК РК  02 -99 п.4.4 Проверяем только первые 8 цифр
	ПроверяемыйКод = Лев(ПроверяемыйКод,8);
	
	СуммаПроизведений = 0;
	Для Позиция = 1 По СтрДлина(ПроверяемыйКод)-1 Цикл
		Цифра = Число(Сред(ПроверяемыйКод, Позиция, 1));
		Вес = (Позиция - 1) % 10 + 1;
		СуммаПроизведений = СуммаПроизведений + Цифра * Вес;
	КонецЦикла;

	КонтрольнаяЦифра = СуммаПроизведений % 11;
	Если КонтрольнаяЦифра = 10 Тогда
		СуммаПроизведений = 0;
		Для Позиция = 1 По СтрДлина(ПроверяемыйКод)-1 Цикл
			Цифра = Число(Сред(ПроверяемыйКод, Позиция, 1));
			Вес = (Позиция + 1) % 10 + 1;
			СуммаПроизведений = СуммаПроизведений + Цифра * Вес;
		КонецЦикла;
		КонтрольнаяЦифра = СуммаПроизведений % 11;
	КонецЕсли;
	
	КонтрольнаяЦифра = КонтрольнаяЦифра % 10;
	
	Возврат Строка(КонтрольнаяЦифра) = Прав(ПроверяемыйКод, 1);

КонецФункции

#КонецОбласти


