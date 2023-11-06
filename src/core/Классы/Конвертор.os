
Перем КаталогИсходников;
Перем СоответствиеИменID;

Процедура ПриСозданииОбъекта(Знач ПутьККаталогуИсходников) Экспорт
	
	КаталогИсходников = ПутьККаталогуИсходников;

	Если НЕ ЗначениеЗаполнено(КаталогИсходников) Тогда
		ВызватьИсключение "Каталог исходников не указал";
	КонецЕсли;
	Файл = Новый Файл(КаталогИсходников);
	Если НЕ Файл.Существует() Или НЕ Файл.ЭтоКаталог() Тогда
		ВызватьИсключение "Каталог исходников не существует: " + Файл.ПолноеИмя;
	КонецЕсли;

	СоответствиеИменID = Новый Соответствие();

КонецПроцедуры

Процедура ОпределитьИменаМетаданных(ПутьКФайлуДампа) Экспорт
	
	ТекстСодержимогоФайла = ОбщегоНазначения.ПрочитатьФайлВТекст(ПутьКФайлуДампа);

	// заполнение соотвествия ID -> Name 
	РВ = Новый РегулярноеВыражение("name=""(?<name>.+?)"" id=""(?<id>.+?)""");
	Совпадения = РВ.НайтиСовпадения(ТекстСодержимогоФайла);
	Для каждого Совпадение Из Совпадения Цикл
		СоответствиеИменID.Вставить(Совпадение.Группы.ПоИмени("id").Значение, Совпадение.Группы.ПоИмени("name").Значение);
	КонецЦикла;

КонецПроцедуры 

Функция ВыполнитьКонвертацию(Источник, Приемник) Экспорт
	
	// перенос строки после каждого ID объекта, удаление дублирования ID
	ТекстСодержимогоФайла = ОбщегоНазначения.ПрочитатьФайлВТекст(Источник);
	РВ = Новый РегулярноеВыражение("(\d,\d,)(\w{8}-\w{4}-\w{4}-\w{4}-\w{12},){2}");
	ТекстИзмененный = РВ.Заменить(ТекстСодержимогоФайла, Символы.ПС + "$1$2 #" + Символы.ПС);
	мТекстИзмененный = СтрРазделить(ТекстИзмененный, Символы.ПС, Ложь);
	
	СконвертированныйТекст = Новый Массив();

	// подстановка имен
	РВ = Новый РегулярноеВыражение("\d,\d,(\w{8}-\w{4}-\w{4}-\w{4}-\w{12}), #(.*)");

	Для Каждого Стр Из мТекстИзмененный Цикл
		
		Совпадения = РВ.НайтиСовпадения(Стр);
		Если Совпадения.Количество() Тогда

			Описание = Совпадения[0].Группы[2].Значение;
			Если ЗначениеЗаполнено(Описание) Тогда
				// Файл уже конвертирован
				Возврат Ложь;
			КонецЕсли;

			ID = Совпадения[0].Группы[1].Значение;
			ИмяМета = СоответствиеИменID[ID];
			Если ИмяМета = Неопределено Тогда
				ИмяМета = "";
			КонецЕсли;
			Стр = Стр + " " + ИмяМета;

		КонецЕсли;
		СконвертированныйТекст.Добавить(Стр);
	КонецЦикла;

	ОбщегоНазначения.ЗаписатьТекстВФайл(Приемник, СтрСоединить(СконвертированныйТекст, Символы.ПС));
	
	Возврат Истина;

КонецФункции

Функция ВыполнитьВосстановление(Источник, Приемник) Экспорт

	ЧтениеТекста = Новый ЧтениеТекста();
	ЧтениеТекста.Открыть(Источник, КодировкаТекста.UTF8);

	ВосстановленныйТекст = Новый Массив();
	ЕстьВосстановленныеСтроки = Ложь;

	// подстановка имен
	РВ = Новый РегулярноеВыражение("\d,\d,(\w{8}-\w{4}-\w{4}-\w{4}-\w{12},)( #.*)");
	Стр = ЧтениеТекста.ПрочитатьСтроку();
	Пока Стр <> Неопределено Цикл
		Совпадения = РВ.НайтиСовпадения(Стр);
		Если Совпадения.Количество() Тогда
			ID = Совпадения[0].Группы[1].Значение;
			ИмяМета = Совпадения[0].Группы[2].Значение;
			Стр = СтрЗаменить(Стр, ИмяМета, ID);
			ЕстьВосстановленныеСтроки = Истина;
		КонецЕсли;
		ВосстановленныйТекст.Добавить(Стр);
		Стр = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;

	ЧтениеТекста.Закрыть();

	Если ЕстьВосстановленныеСтроки Тогда
		ОбщегоНазначения.ЗаписатьТекстВФайл(Приемник, СтрСоединить(ВосстановленныйТекст, ""), КодировкаТекста.UTF8);
	КонецЕсли;

	Возврат ЕстьВосстановленныеСтроки;

КонецФункции