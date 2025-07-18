// Модуль для управления якорями и алиасами в YAML

Перем Якоря; // Соответствие для хранения якорей

// Инициализация менеджера якорей
Процедура Инициализировать() Экспорт
	Якоря = Новый Соответствие;
КонецПроцедуры

// Очистка всех якорей
Процедура Очистить() Экспорт
	Якоря.Очистить();
КонецПроцедуры

// Сохранение значения под якорем
//
// Параметры:
//   ИмяЯкоря - Строка - имя якоря
//   Значение - Произвольный - значение для сохранения
//
Процедура СохранитьЯкорь(ИмяЯкоря, Значение) Экспорт
	Якоря.Вставить(ИмяЯкоря, Значение);
КонецПроцедуры

// Получение значения по якорю
//
// Параметры:
//   ИмяЯкоря - Строка - имя якоря
//
// Возвращаемое значение:
//   Произвольный - значение якоря или Неопределено, если якорь не найден
//
Функция ПолучитьЗначениеЯкоря(ИмяЯкоря) Экспорт
	Возврат Якоря.Получить(ИмяЯкоря);
КонецФункции

// Проверка существования якоря
//
// Параметры:
//   ИмяЯкоря - Строка - имя якоря
//
// Возвращаемое значение:
//   Булево - Истина, если якорь существует
//
Функция ЯкорьСуществует(ИмяЯкоря) Экспорт
	Возврат НЕ Якоря.Получить(ИмяЯкоря) = Неопределено;
КонецФункции

// Извлечение имени якоря из строки (для &anchor)
//
// Параметры:
//   Строка - Строка - строка с определением якоря
//
// Возвращаемое значение:
//   Строка - имя якоря или пустая строка, если якорь не найден
//
Функция ИзвлечьИмяЯкоряИлиАлиаса(Строка) Экспорт
	
	Строка = СокрЛП(Строка);
	Позиция = 1;
	Попытка
		Если не Лев(Строка, 1) = "&" И Не Лев(Строка, 1) = "*" Тогда
			Возврат "";
		КонецЕсли;
	
		// Извлекаем имя якоря (до пробела или до конца строки)
		НачалоИмени = Позиция + 1;
		КонецИмени = СтрДлина(Строка);
		
		Для Позиция = НачалоИмени По КонецИмени Цикл
			Символ = Сред(Строка, Позиция, 1);
			Если Символ = " " ИЛИ Символ = Символы.Таб Тогда
				КонецИмени = Позиция - 1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Сред(Строка, НачалоИмени, КонецИмени - НачалоИмени + 1);
	Исключение
		Возврат "";
		// Если произошла ошибка, возвращаем пустую строку
	КонецПопытки;
	
КонецФункции

// Удаление определения якоря из строки
//
// Параметры:
//   Строка - Строка - строка с определением якоря
//
// Возвращаемое значение:
//   Строка - строка без определения якоря
//
Функция УдалитьОпределениеЯкоря(Строка) Экспорт
	ПозицияЯкоря = СтрНайти(Строка, "&");
	Если ПозицияЯкоря = 0 Тогда
		Возврат Строка;
	КонецЕсли;
	
	// Находим конец имени якоря
	КонецИмени = СтрДлина(Строка);
	Для Позиция = ПозицияЯкоря + 1 По СтрДлина(Строка) Цикл
		Символ = Сред(Строка, Позиция, 1);
		Если Символ = " " ИЛИ Символ = Символы.Таб ИЛИ Символ = ":" Тогда
			КонецИмени = Позиция - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Удаляем определение якоря из строки
	ЧастьДо = Лев(Строка, ПозицияЯкоря - 1);
	ЧастьПосле = Сред(Строка, КонецИмени + 1);
	
	Возврат СокрЛП(ЧастьДо + ЧастьПосле);
КонецФункции
