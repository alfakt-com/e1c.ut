﻿
////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму разбора банковской выписки.
//
// Параметры:
//   СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение с выпиской банка.
//
Процедура РазобратьВыпискуБанка(СообщениеОбмена) Экспорт
	
	ДенежныеСредстваВызовСервера.РазобратьВыпискуБанка(СообщениеОбмена);
	
КонецПроцедуры


#КонецОбласти
