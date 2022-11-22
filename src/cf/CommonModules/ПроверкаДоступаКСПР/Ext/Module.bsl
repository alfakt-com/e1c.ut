﻿
/// Для чего на данный момент невозможно установить доступ по ролям так как с ролями бордак 
/// смысл в том что есть такойже регист если в него добамить методаные хотябы одну строчку то автоматом данные методанные становится для записи запрещены всем кроме пользователей внесены в регистр
/// как с ролями разберемся так можно убрать ПроверкаДоступаКСПР (модуль подписку и регистр свед.)



Процедура ПроверитД (Источник, Отказ) Экспорт
	Попытка
		Если Источник.ОбменДанными.Загрузка Тогда
			Возврат;
		КонецЕсли;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
						|	ПроверкаДоступаКСПР.Пользователь КАК Пользователь
						|ИЗ
						|	РегистрСведений.ПроверкаДоступаКСПР КАК ПроверкаДоступаКСПР
						|ГДЕ
						|	ПроверкаДоступаКСПР.Метаданные.Имя = &Имя";
		Запрос.УстановитьПараметр("Имя",Источник.Метаданные().Имя);
		Рез = Запрос.Выполнить().Выгрузить();
		Если Рез.Количество() = 0 Тогда
			Отказ = Ложь;
		Иначе
			Струк = Новый Структура;
			струк.Вставить("Пользователь",ПараметрыСеанса.ТекущийПользователь);
			Если Рез.НайтиСтроки(струк).Количество() > 0 тогда
				Отказ = Ложь;
			Иначе
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		//ТТ
		Если Отказ = Истина Тогда
			Сообщить("Отказано в доступе!");
		КонецЕсли;
	Исключение
	Конецпопытки
  
КонецПроцедуры