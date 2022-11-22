
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Координаты") Тогда
		Координаты = Параметры.Координаты;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВывестиНаКарту();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиНаКарту()

	СтраницаХТМЛ = "<!DOCTYPE html>
					|<html xmlns='http://www.w3.org/1999/xhtml'>
					|<head>
					|    <title>Примеры. Определение координат.</title>
					|    <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
				//	|	 <meta http-equiv='X-UA-Compatible' content='IE=9' >
					|	 <script src='https://api-maps.yandex.ru/2.1/?lang=ru_RU&apikey=4acca7a3-e53f-4747-8c63-b23ba52fd465' type='text/javascript'></script>
					|	 <script type='text/javascript'>
					|			ymaps.ready(function() {
					|			var myPlacemark, 
					|			myMap = new ymaps.Map(document.getElementById('map'), {
					|					center: [51.150370521615116,71.41726169262692],
					|					zoom: 12,
					|				}, {
					|					searchControlProvider: 'yandex#search'
					|				});
					|			myPlacemark = createPlacemark([51.150370521615116,71.41726169262692]);
					|			myMap.geoObjects.add(myPlacemark);
					|			// Слушаем событие окончания перетаскивания на метке.
					|			myPlacemark.events.add('dragend', function () {
					|				getAddress(myPlacemark.geometry.getCoordinates());
					|			});
					|			getAddress([51.150370521615116,71.41726169262692]);
					|			
					|		    myMap.cursors.push('arrow');
					|			// Слушаем клик на карте.
					|			myMap.events.add('click', function (e) {
					|				var coords = e.get('coords');
					|				// Если метка уже создана – просто передвигаем ее.
					|				if (myPlacemark) {
					|					myPlacemark.geometry.setCoordinates(coords);
					|				}
					|				// Если нет – создаем.
					|				else {
					|					myPlacemark = createPlacemark(coords);
					|					myMap.geoObjects.add(myPlacemark);
					|					// Слушаем событие окончания перетаскивания на метке.
					|					myPlacemark.events.add('dragend', function () {
					|						getAddress(myPlacemark.geometry.getCoordinates());
					|					});
					|				}
					|				getAddress(coords);
					|			});
					|			// Создание метки.
					|			function createPlacemark(coords) {
					|				return new ymaps.Placemark(coords, {
					|					iconCaption: 'поиск...'
					|				}, {
					|					preset: 'islands#redDotIconWithCaption',
					|					draggable: true
					|				});
					|			}
					|			// Определяем адрес по координатам (обратное геокодирование).
					|			function getAddress(coords) {
					|				myPlacemark.properties.set('iconCaption', 'поиск...');
					|				ymaps.geocode(coords).then(function (res) {
					|					var firstGeoObject = res.geoObjects.get(0);
					|					myPlacemark.properties
					|						.set({
					|							iconCaption: firstGeoObject.properties.get('name'),
					|							balloonContent: firstGeoObject.properties.get('text')
					|						});
					|					document.getElementById('BufferData').innerHTML = '[' + coords + '] ' + myPlacemark.properties.get('balloonContent');
					|				});
					|			}
					|		});
					|		function ExecCommand()
					|			    {
					|			        code = document.getElementById('ExtCommand').innerHTML;
					|			        result = '' + eval(code);
					|			        document.getElementById('BufferData').innerHTML = result;
					|			    }
					|	</script>
					|</head>
					|<body>
					| 	<div id='map' style='width: 1024px; height: 768px'></div>
					|	<input type=button style='display:none' id='SendEvent' onclick = 'ExecCommand()' />
					|	<div id='ExtCommand' style='display:none'>extcommand</div>
					|	<div id='EventName' style='display:none'>js_event</div>
					|	<div id='BufferData' style='display:none'>js_result</div>
					|</body>
					|</html>";
	Если ЗначениеЗаполнено(Координаты) Тогда
		СтраницаХТМЛ = СтрЗаменить(СтраницаХТМЛ, "[51.150370521615116,71.41726169262692]", Координаты);
		СтраницаХТМЛ = СтрЗаменить(СтраницаХТМЛ, "zoom: 12", "zoom: 14");
	КонецЕсли;				
					
КонецПроцедуры

&НаКлиенте
Процедура Вывести(Команда)
	ВывестиНаКарту();
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ПараметрыВозврата = Новый Структура("Координаты, Адрес");
    Результат = Элементы.СтраницаХТМЛ.Документ.getElementById("BufferData").innerHTML;	
	поз = СтрНайти(Результат,"]");
	ПараметрыВозврата.Координаты = Сред(Результат,0,поз);
	ПараметрыВозврата.Адрес = Сред(Результат,поз+2);
	Закрыть(ПараметрыВозврата);
	//Адрес = ПараметрыВозврата.Адрес;
	//Координаты = ПараметрыВозврата.Координаты;
КонецПроцедуры
