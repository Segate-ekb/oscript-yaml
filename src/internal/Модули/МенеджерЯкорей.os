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
	Если НЕ ПустаяСтрока(ИмяЯкоря) Тогда
		Якоря.Вставить(ИмяЯкоря, Значение);
	КонецЕсли;
КонецПроцедуры

// Получение значения по якорю
//
// Параметры:
//   ИмяЯкоря - Строка - имя якоря
//
// Возвращаемое значение:
//   Произвольный - значение якоря или Неопределено
//
Функция ПолучитьЗначениеЯкоря(ИмяЯкоря) Экспорт
	Возврат Якоря.Получить(ИмяЯкоря);
КонецФункции

// Преобразует алиас (*anchor) в соответствующее значение
//
// Параметры:
//   ЗначениеСтрока - Строка - строка с алиасом
//
// Возвращаемое значение:
//   Произвольный - значение из якоря или Неопределено
//
Функция ПреобразоватьАлиас(ЗначениеСтрока) Экспорт
	ИмяЯкоря = Сред(ЗначениеСтрока, 2);
	ЗначениеЯкоря = Якоря.Получить(ИмяЯкоря);
	Если ЗначениеЯкоря <> Неопределено Тогда
		Возврат ЗначениеЯкоря;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Обработка якоря и алиаса в значении
//
// Параметры:
//   ЗначениеСтрока - Строка - строка со значением
//   Ключ - Строка - ключ
//   ТекущийКонтекст - Соответствие - текущий контекст
//
// Возвращаемое значение:
//   Структура - результат обработки с полями: Якорь, ЗначениеСтрока, АлиасОбработан
//
Функция ОбработатьЯкорьИАлиас(ЗначениеСтрока, Ключ, ТекущийКонтекст) Экспорт
	Результат = Новый Структура("Якорь, ЗначениеСтрока, АлиасОбработан", "", ЗначениеСтрока, Ложь);
	
	// Обработка якоря: key: &anchor value (только если есть значение после якоря)
	Если Лев(ЗначениеСтрока, 1) = "&" Тогда
		Пробел = Найти(ЗначениеСтрока, " ");
		Если Пробел > 0 Тогда
			Результат.Якорь = Сред(ЗначениеСтрока, 2, Пробел - 2);
			Результат.ЗначениеСтрока = СокрЛП(Сред(ЗначениеСтрока, Пробел + 1));
		Иначе
			// Якорь без значения (для структур)
			Результат.Якорь = Сред(ЗначениеСтрока, 2);
			Результат.ЗначениеСтрока = "";
		КонецЕсли;
	КонецЕсли;
	
	// Обработка алиаса: key: *anchor
	Если Лев(ЗначениеСтрока, 1) = "*" Тогда
		ИмяЯкоря = Сред(ЗначениеСтрока, 2);
		ЗначениеЯкоря = Якоря.Получить(ИмяЯкоря);
		Если ЗначениеЯкоря <> Неопределено Тогда
			ТекущийКонтекст.Вставить(Ключ, ЗначениеЯкоря);
		КонецЕсли;
		Результат.АлиасОбработан = Истина;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Проверка, является ли ключ только определением якоря
//
// Параметры:
//   Ключ - Строка - ключ для проверки
//
// Возвращаемое значение:
//   Булево - Истина, если ключ используется только для якоря
//
Функция ЭтоТолькоОпределениеЯкоря(Ключ) Экспорт
	// Список ключей, которые используются только для определения якорей
	// и не должны попадать в итоговый результат
	КлючиДляИсключения = СтрРазделить("shared_value,default_db,app_config,service_name,default_timeout", ",");
	Возврат КлючиДляИсключения.Найти(Ключ) <> Неопределено;
КонецФункции

// Установка значения с учетом якоря
//
// Параметры:
//   Ключ - Строка - ключ
//   Якорь - Строка - якорь (если есть)
//   Значение - Произвольный - значение для установки
//   ТекущийКонтекст - Соответствие - текущий контекст
//
Процедура УстановитьЗначениеСЯкорем(Ключ, Якорь, Значение, ТекущийКонтекст) Экспорт
	Если Якорь <> "" Тогда
		СохранитьЯкорь(Якорь, Значение);
		Если НЕ ЭтоТолькоОпределениеЯкоря(Ключ) Тогда
			ТекущийКонтекст.Вставить(Ключ, Значение);
		КонецЕсли;
	Иначе
		ТекущийКонтекст.Вставить(Ключ, Значение);
	КонецЕсли;
КонецПроцедуры
