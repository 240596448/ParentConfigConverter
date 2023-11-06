Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("SRC", "", "Путь к каталогу исходников src/")
				.ТСтрока()
				.Обязательный(Истина);

	Команда.Опция("file", "Ext/ParentConfigurations.bin", 
				"Относительный путь к файлу ParentConfigurations.bin внутри каталога исходников")
				.ТСтрока();
				
	Команда.Опция("dump", "ConfigDumpInfo.xml", 
				"Путь к файлу ConfigDumpInfo.xml внутри каталога исходников")
				.ТСтрока();
				
	Команда.Опция("bak backup", Ложь, "Сохранять оригинальный файл в ParentConfigurations.bin.bak")
				.Флаг();
				
КонецПроцедуры

// Выполняет логику команды
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Лог = ПараметрыПриложения.Лог();

	КаталогИсходников   = Команда.ЗначениеАргумента("SRC");
	ПутьКФайлуПоддержки = Команда.ЗначениеОпции("file");
	ПутьКФайлуДампа     = Команда.ЗначениеОпции("dump");
	СоздаватьБэкап      = Команда.ЗначениеОпции("backup");
	
	УстановитьТекущийКаталог(КаталогИсходников);
	
	Файл = Новый Файл(ПутьКФайлуПоддержки);
	Если Файл.Размер() < 100 Тогда
		Лог.Информация("Конвертация файла поддержки не выполнена. Вероятно конфигурация снята с поддержки.");
		Возврат;
	КонецЕсли;

	ИмяВременногоФайлаИсходный = ПолучитьИмяВременногоФайла();
	КопироватьФайл(ПутьКФайлуПоддержки, ИмяВременногоФайлаИсходный);

	ИмяВременногоФайлаЦелевой = ПолучитьИмяВременногоФайла();

	Конвертор = Новый Конвертор(КаталогИсходников);
	Конвертор.ОпределитьИменаМетаданных(ПутьКФайлуДампа);
	Успех = Конвертор.ВыполнитьКонвертацию(ИмяВременногоФайлаИсходный, ИмяВременногоФайлаЦелевой);
	
	Если НЕ Успех Тогда
		УдалитьФайлы(ИмяВременногоФайлаИсходный);
		УдалитьФайлы(ИмяВременногоФайлаЦелевой);
		Лог.Предупреждение("Конвертация файла поддержки не выполнена. Файл уже сконвентирован.");
		Возврат;
	КонецЕсли;

	УдалитьФайлы(ПутьКФайлуПоддержки);
	ПереместитьФайл(ИмяВременногоФайлаЦелевой, ПутьКФайлуПоддержки);

	Лог.Информация("Выполнена конвертация файла поддержки %1", ПутьКФайлуПоддержки);
	Если СоздаватьБэкап Тогда
		ФайлПоддержки = Новый Файл(ПутьКФайлуПоддержки);
		ИмяФайлаПоддержки = ФайлПоддержки.Имя;
		ИмяФайлаБэкапа = ИмяФайлаПоддержки + ".bak";
		ПустьКФайлуБэкапа = ОбъединитьПути(ФайлПоддержки.Путь, ИмяФайлаБэкапа);
		УдалитьФайлы(ПустьКФайлуБэкапа);
		ПереместитьФайл(ИмяВременногоФайлаИсходный, ПустьКФайлуБэкапа);
		Лог.Информация("Исходный файл %1 переименован в %2", ИмяФайлаПоддержки, ИмяФайлаБэкапа);
	Иначе
		УдалитьФайлы(ИмяВременногоФайлаИсходный);
	КонецЕсли;

КонецПроцедуры

