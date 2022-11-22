﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЭтотОбъект.Заголовок = Параметры.Заголовок;

	ШаблонТекста = 
		"
		|<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">
		|<html>
		|	<head>
		|		<style type=""text/css"">
		|			/* Основные параметры текста */
		|			body {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-size: 10pt; /* Размер основного шрифта в пунктах */
		|			}
		|
		|			/* Блок заголовка 1 уровня */
		|			h1 {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 150%; /* Размер основного шрифта в процентах */
		|				margin-left: 0em;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок заголовка 2 уровня */
		|			h2 {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 140%; /* Размер основного шрифта в процентах */
		|				margin-left: 0.5em;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок заголовка 3 уровня */
		|			h3 {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 130%; /* Размер основного шрифта в процентах */
		|				margin-left: 2em;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок заголовка 4 уровня */
		|			h4 {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 120%; /* Размер основного шрифта в процентах */
		|				margin-left: 2.5em;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок заголовка 5 уровня */
		|			h5 {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 120%; /* Размер основного шрифта в процентах */
		|				margin-left: 3em;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок заголовка 6 уровня */
		|			h6 {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 120%; /* Размер основного шрифта в процентах */
		|				margin-left: 3.5em;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок Длинная цитата */
		|			blockquote {
		|				font-family: monospace; /* Семейство шрифтов */
		|				font-style: normal;
		|				color: #808080;
		|				background-color: #F0F0DA;
		|			}
		|
		|			/* Блок Короткая цитата */
		|			q {
		|				font-family: monospace; /* Семейство шрифтов */
		|				font-style: normal;
		|				color: #808080;
		|				background-color: #F0F0DA;
		|			}
		|
		|			/* Блок Источник цитаты */
		|			cite {
		|				font-family: monospace; /* Семейство шрифтов */
		|				font-style: normal;
		|				color: #808080;
		|				background-color: #F0F0DA;
		|			}
		|
		|			/* Блок Ввод с клавиатуры */
		|			kbd {
		|				font-family: monospace; /* Семейство шрифтов */
		|				background-color: #E6E6E6;
		|				border-width:thin;
		|				border-style: outset;
		|				border-color: #FFFBF0;
		|				padding-left: 2px;
		|				padding-right: 4px; 
		|			}
		|
		|			/* Блок Программный код */
		|			code {
		|				font-family: monospace; /* Семейство шрифтов */
		|				color: #3366FF;
		|				background-color: #FFFFD5;
		|			}
		|
		|			/* Блок Акцентированный текст */
		|			em {
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bolder;
		|			}
		|
		|			/* Блок Акцентированный текст, приоритет */
		|			em.priority {
		|				font-family: Arial; /* Семейство шрифтов */
		|				color: red;
		|			}
		|
		|			/* Блок Акцентированный текст, иконка приоритета */
		|			em.priority_icon {
		|				font-family: Arial; /* Семейство шрифтов */
		|				color: red;
		|			}
		|
		|			/* Цвет неактуальной новости */
		|			div.outofdate{
		|				font-family: Arial; /* Семейство шрифтов */
		|				color: grey;
		|			}
		|
		|			/* Цвет актуальной новости */
		|			div.actual{
		|				font-family: Arial; /* Семейство шрифтов */
		|				color: black;
		|			}
		|
		|			/* Блок информации о важности или актуальности */
		|			div#importanceData{
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				font-style: normal;
		|				font-size: 8pt; /* Размер основного шрифта в пунктах */
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок информации Весь текст новости */
		|			div#newsData{
		|				font-family: Arial; /* Семейство шрифтов */
		|			}
		|
		|			/* Блок информации Заголовок */
		|			div#newsHeader{
		|				font-family: Arial; /* Семейство шрифтов */
		|				font-weight: bold;
		|				margin-bottom: 0.5em;
		|			}
		|
		|			/* Блок информации Только текст новости */
		|			div#newsText{
		|				font-family: Arial; /* Семейство шрифтов */
		|			}
		|
		|			/* Блок информации о категориях */
		|			div#newsCategories{
		|				font-family: Arial; /* Семейство шрифтов */
		|				color: grey;
		|				font-style: italic;
		|				font-size: 8pt; /* Размер основного шрифта в пунктах */
		|				margin-top: 1em;
		|			}
		|
		|			/* Блок информации о простых категориях */
		|			div#newsCategoriesSimple{
		|			}
		|
		|			/* Блок информации о категориях интервалы версий */
		|			div#newsCategoriesVersions{
		|			}
		|
		|			/* Блок информации ссылка на полный текст новости */
		|			div#newsHyperlink{
		|				font-family: Arial; /* Семейство шрифтов */
		|				margin-top: 2em;
		|			}
		|
		|			/* Гиперссылка, не посещенная */
		|			a:link {
		|			}
		|
		|			/* Гиперссылка, посещенная */
		|			a:visited {
		|			}
		|
		|			/* Гиперссылка при наведении курсора мыши */
		|			a:hover {
		|				background: #B8D7EB;
		|			}
		|
		|			/* Класс для всех горизонтальных линий */
		|			hr {
		|				color: #C8C8C8;
		|			}
		|
		|			/* Класс для скрытия блоков текста */
		|			.hidden {
		|				display: none;
		|			}
		|
		|			/* Здесь можно вставить свои стили */
		|
		|		</style>
		|	</head>
		|	<body>
		|		%ТекстХТМЛ%
		|	</body>
		|</html>";

	ЭтотОбъект.ТекстХТМЛ = СтрЗаменить(ШаблонТекста, "%ТекстХТМЛ%", Параметры.ТекстХТМЛ);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	ТипСписокЗначений = Тип("СписокЗначений");
	ТипСтрока = Тип("Строка");

	СтандартнаяОбработка = Ложь;
	ПродолжитьОбработку = Ложь;

	Если (ДанныеСобытия.Anchor <> Неопределено) Тогда
		НавигационнаяСсылка = ДанныеСобытия.Href; // ДанныеСобытия.Anchor.nameProp
		Если (ТипЗнч(НавигационнаяСсылка) = ТипСтрока) Тогда

			Если (ПустаяСтрока(НавигационнаяСсылка)) Тогда
				// Для "якорей", например <a id="aa1"/> или <a name="aa2"/>.
				ПродолжитьОбработку  = Ложь;
				СтандартнаяОбработка = Истина;
			ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("mailto:")) = 1) Тогда // Специальная ссылка типа "mailto:"
				ПродолжитьОбработку  = Ложь;
				СтандартнаяОбработка = Истина;
			ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("javascript:")) = 1) Тогда // Специальная ссылка типа "javascript:"
				ПродолжитьОбработку  = Ложь;
				СтандартнаяОбработка = Истина;
			ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1) Тогда // http:// или https://
				ПродолжитьОбработку  = Истина;
			ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1c://")) = 1) Тогда
				ПродолжитьОбработку  = Истина;
			ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1cib/")) = 1) Тогда
				ПродолжитьОбработку  = Истина;
			Иначе
				// Ссылки вроде:
				//  <a href="#aa1">Перейти внутри новости...</a>
				// автоматически преобразуются к
				//  <a href="e1c://filev/e/Data/News1C/#aaa1">Перейти внутри новости...</a>.
				// Переходы внутри новости по якорям невозможны, поэтому не давать обрабатывать такие ссылки, чтобы не было ошибок.
				Если (ТипЗнч(ДанныеСобытия.Anchor.nodeName) = ТипСтрока)
						И (ВРег(ДанныеСобытия.Anchor.nodeName) = ВРег("a")) Тогда
					Если (ТипЗнч(ДанныеСобытия.Anchor.nameProp) = ТипСтрока)
							И (СтрНайти(ВРег(ДанныеСобытия.Anchor.nameProp), "#") = 1) Тогда
						ПродолжитьОбработку = Ложь;
						СтандартнаяОбработка = Истина;
					Иначе
						ПродолжитьОбработку = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ПродолжитьОбработку = Истина;
		КонецЕсли;
	ИначеЕсли (ДанныеСобытия.Element <> Неопределено) Тогда
		Если (ВРег(ДанныеСобытия.Element.tagName) = ВРег("area")) Тогда
			НавигационнаяСсылка = ДанныеСобытия.Element.Href;
			ПродолжитьОбработку = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ПродолжитьОбработку = Истина Тогда
		Если (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1) Тогда
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
			СтандартнаяОбработка = Ложь;
		ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1c://")) = 1) Тогда
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
			СтандартнаяОбработка = Ложь;
		ИначеЕсли (СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1cib/")) = 1) Тогда
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
			СтандартнаяОбработка = Ложь;
		Иначе
			СтандартнаяОбработка = Ложь;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Неизвестная ссылка: %1'"),
				НавигационнаяСсылка);
			ПоказатьПредупреждение(
				, // ОписаниеОповещенияОЗавершении
				ТекстСообщения,
				0,
				НСтр("ru='Ошибка'")); 
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

