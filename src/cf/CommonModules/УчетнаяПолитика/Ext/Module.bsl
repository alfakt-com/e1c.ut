﻿#Область ПрограммныйИнтерфейс


// Параметры учетной политики по НДС

Функция ПлательщикНДС(Организация, Период) Экспорт

	Возврат УчетнаяПолитикаПереопределяемый.ПлательщикНДС(Организация, Период);

КонецФункции 

Функция ПрименяетсяОсвобождениеОтУплатыНДС(Организация, Период) Экспорт

	Результат = УчетнаяПолитикаПереопределяемый.ПрименяетсяОсвобождениеОтУплатыНДС(Организация, Период);

	Возврат Результат;	

КонецФункции

Функция ПравилоОтбораАвансовДляРегистрацииСчетовФактур(Организация, Период) Экспорт
	
	Возврат УчетнаяПолитикаПереопределяемый.ПравилоОтбораАвансовДляРегистрацииСчетовФактур(Организация, Период);
	
КонецФункции


#КонецОбласти

Функция ПрименяетсяУСН(Организация, Период) Экспорт

	Возврат УчетнаяПолитикаПереопределяемый.ПрименяетсяУСН(Организация, Период);

КонецФункции 

