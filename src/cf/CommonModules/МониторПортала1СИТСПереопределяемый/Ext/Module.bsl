﻿
#Область ПрограммныйИнтерфейс

// Определяет общие параметры функциональности Монитора Портала 1С:ИТС.
//
// Параметры:
//	ПараметрыМонитора - Структура - общие параметры Монитора:
//		* ИспользоватьОтображениеПриНачалеРаботы - Булево - управляет использованием
//			отображения Монитора при начале работы программы. Истина - использовать,
//			Ложь - не использовать. Значение по умолчанию - Истина;
//
Процедура ПриОпределенииОбщихПараметровМонитора(ПараметрыМонитора) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при создании формы Монитора Портала 1С:ИТС.
// Используется для создания собственных реквизитов и элементов формы.
//
// Параметры:
//	Форма - УправляемаяФорма - форма Монитора. В форме доступны для использования:
//		- реквизит ДополнительныеПараметры с типом Произвольный - реквизит может
//			быть использован для хранения собственных параметров в контексте формы
//			без необходимости реализации отдельных реквизитов;
//		- метод "Подключаемый_ОбработатьКоманду" - процедура-обработчик,
//			которую необходимо назначать при добавлении новых команд формы Монитора
//			в качестве значения свойства Действие объекта КомандаФормы. Обработка
//			действия реализуется в методе
//			МониторПортала1СИТСКлиентПереопределяемый.ОбработатьКомандуВФормеМонитора();
//		- метод "Подключаемый_ДекорацияНажатие" - процедура-обработчик, которую
//			необходимо назначать при добавлении новых декораций формы в качестве значения
//			параметра Действие при вызове метода УстановитьДействие("Нажатие", <Действие>)
//			объекта ДекорацияФормы. Обработка действия выполняется в методе
//			МониторПортала1СИТСКлиентПереопределяемый.ПриНажатииДекорацииВФормеМонитора();
//		- метод "Подключаемый_ОбработатьНавигационнуюСсылку" - процедура-обработчик, которую
//			необходимо назначать при добавлении новых декораций формы в качестве значения
//			параметра Действие при вызове метода УстановитьДействие("ОбработкаНавигационнойСсылки", <Действие>)
//			объекта ДекорацияФормы. Обработка действия выполняется в методе
//			МониторПортала1СИТСКлиентПереопределяемый.ОбработатьНавигационнуюСсылкуВФормеМонитора();
//		- метод "Подключаемый_ОбработатьОжидание" - процедура-обработчик, которую необходимо использовать
//			для реализации собственного обработчика ожидания посредством вызова метода
//			ПодключитьОбработчикОжидания("Подключаемый_ОбработатьОжидание", <Интервал>, <Однократно>) формы
//			Монитора. Тело обработчика реализуется в методе
//			МониторПортала1СИТСКлиентПереопределяемый.ПриВыполненииОбработчикаОжиданияВФормеМонитора();
//		- группа формы Элементы.ГруппаСодержимое - все новые элементы формы необходимо размещать
//			внутри данной группы перед/после элементов:
//			- Элементы.ГруппаВыполнениеУсловийСопровождения;
//			- Элементы.ГруппаСервисы1С;
//			- Элементы.ГруппаОбновлениеПрограммы;
//			- Элементы.ГруппаСмТакже;
//	ПараметрыСоздания - Структура - параметры создания формы Монитора:
//		* СсылкиСмТакже - ТаблицаЗначений - список ссылок, отображаемых в разделе "См. также".
//		Колонки:
//			** Ссылка - Строка - ссылка для перехода. Ссылки, отличающиеся от шаблонов "http://*",
//				"https://*", "mailto:*" передаются для обработки в метод
//				МониторПортала1СИТСКлиентПереопределяемый.ОбработатьНавигационнуюСсылкуВФормеМонитора();
//			** Заголовок - Строка - заголовок ссылки;
//			** Колонка - Число - номер колонки, в которой должна быть отображена ссылка.
//				Допустимые значения: 1 - левая колонка, 2 - правая колонка;
//				Значение по умолчанию - 1.
//
Процедура ПриСозданииФормыМонитора(Форма, ПараметрыСоздания) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед началом получения данных в форме Монитора в контексте сервера.
// Описание формы Монитора см. в методе ПриСозданииФормыМонитора, параметр Форма.
//
// Параметры:
//	Форма - УправляемаяФорма - форма Монитора;
//	ПараметрыПолученияДополнительныхДанных - Произвольный - в параметре возвращаются
//		параметры получения дополнительных данных для обработке в методе
//		ПриПолученииДополнительныхДанныхМонитора();
//		Может быть использовано для исключения повторного получения
//		полученных ранее данных.
//
Процедура ПередПолучениемДанныхМонитора(Форма, ПараметрыПолученияДополнительныхДанных) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при получении данных Монитора Портала 1С:ИТС для получения дополнительных
// данных Монитора, которые могут быть обработаны в методе ОтобразитьДополнительныеДанныеМонитора().
// Метод вызывается в фоновом задании, результаты возвращаются в форму Монитора через временное
// хранилище (должны быть доступны для помещения во временное хранилище).
// Описание формы Монитора см. в методе ПриСозданииФормыМонитора().
//
// Параметры:
//	ДополнительныеДанные - Произвольный - в параметре возвращаются данные для
//		отображения в форме Монитора;
//	ПараметрыПолученияДополнительныхДанных - Произвольный - параметры получения дополнительных данных,
//		полученные в методе ПриОпределенииПараметровПолученияДополнительныхДанныхМонитора();
//
Процедура ПриПолученииДополнительныхДанныхМонитора(ДополнительныеДанные, ПараметрыПолученияДополнительныхДанных) Экспорт
	
	
	
КонецПроцедуры

// Вызывается для отображения дополнительных данных Монитора, полученных в методе
// ПриПолученииДополнительныхДанныхМонитора().
// Описание формы Монитора см. в методе ПриСозданииФормыМонитора, параметр Форма.
//
// Параметры:
//	Форма - УправляемаяФорма - форма Монитора;
//	ДополнительныеДанные - Произвольный - дополнительные данные, полученные в методе
//		ПриПолученииДополнительныхДанныхМонитора().
//
Процедура ОтобразитьДополнительныеДанныеМонитора(Форма, ДополнительныеДанные) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
