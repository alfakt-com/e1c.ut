﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр БонусыДизайнеров 
	Движения.БонусыДизайнеров.Записывать = Истина;
	Для Каждого ТекСтрокаРасчеты Из Бонусы Цикл
		Движение = Движения.БонусыДизайнеров.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = ТекСтрокаРасчеты.Подразделение;
		Движение.Сотрудник = ТекСтрокаРасчеты.Сотрудник;
		Движение.ВидБонуса = ТекСтрокаРасчеты.ВидБонуса;
		Движение.Дизайнер = ТекСтрокаРасчеты.Дизайнер;
		Движение.КатегорияТовара = ТекСтрокаРасчеты.КатегорияТовара;
		Движение.Производитель = ТекСтрокаРасчеты.Производитель;
		Движение.Реализация = ТекСтрокаРасчеты.Реализация;
		Движение.СуммаБонусов = ТекСтрокаРасчеты.СуммаБонуса;
		Движение.СуммаВыручки = ТекСтрокаРасчеты.СуммаВыручки;
		Движение.СуммаСкидки = ТекСтрокаРасчеты.СуммаСкидки;
		Движение.БонусныйПроцент = ТекСтрокаРасчеты.БонусныйПроцент;
		Движение.Выплачено = Выплачено;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Автор.Пустая() тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры


