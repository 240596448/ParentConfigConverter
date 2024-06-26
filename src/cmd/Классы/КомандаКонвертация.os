Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("SRC", ".", "Путь к каталогу исходников src")
				.ТСтрока()
				.Обязательный(Истина);

	Команда.Опция("dump", "ConfigDumpInfo.xml", 
				"Путь к файлу ConfigDumpInfo.xml внутри каталога исходников")
				.ТСтрока();
				
	Команда.Опция("orig in", "Ext/ParentConfigurations.bin", 
				"Относительный путь к файлу ParentConfigurations.bin внутри каталога исходников")
				.ТСтрока();
				
	Команда.Опция("mod out", "", 
				"Имя сконвертированного файла. Если не задано - перезаписывается исходный файл. (не используется совместно с опцией `backup`)")
				.ТСтрока();
				
	Команда.Опция("bak backup", Ложь, "Сохранять оригинальный файл в ParentConfigurations.bin.bak (не используется совместно с опцией `out`)")
				.Флаг();
				
КонецПроцедуры

// Выполняет логику команды
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Лог = ПараметрыПриложения.Лог();

	КаталогИсходников         = Команда.ЗначениеАргумента("SRC");
	ПутьКФайлуПоддержки       = Команда.ЗначениеОпции("file");
	ПутьКНовомуФайлуПоддержки = Команда.ЗначениеОпции("out");
	ПутьКФайлуДампа           = Команда.ЗначениеОпции("dump");
	СоздаватьБэкап            = Команда.ЗначениеОпции("backup");
	
	Если ЗначениеЗаполнено(ПутьКНовомуФайлуПоддержки)
		И СоздаватьБэкап = Истина Тогда
		Лог.Ошибка("Конвертация файла поддержки не выполнена. Опции `out` и `backup` не должны использоваться совместно.");
		Возврат;
	КонецЕсли;

	Файл = Новый Файл(КаталогИсходников);
	КаталогИсходников = Файл.ПолноеИмя;
	
	УстановитьТекущийКаталог(КаталогИсходников);
	
	Файл = Новый Файл(ПутьКФайлуПоддержки);
	Если Файл.Размер() < 20 Тогда
		Лог.Информация("Конвертация файла поддержки не выполнена. Вероятно конфигурация снята с поддержки.");
		Возврат;
	КонецЕсли;

	ИмяВременногоФайлаИсходный = ПолучитьИмяВременногоФайла();
	КопироватьФайл(ПутьКФайлуПоддержки, ИмяВременногоФайлаИсходный);

	ИмяВременногоФайлаЦелевой = ПолучитьИмяВременногоФайла();

	Конвертор = Новый Конвертор(КаталогИсходников);
	Конвертор.ОпределитьИменаМетаданных(ПутьКФайлуДампа);
	Ошибка = Конвертор.ВыполнитьКонвертацию(ИмяВременногоФайлаИсходный, ИмяВременногоФайлаЦелевой);
	
	Если НЕ ПустаяСтрока(Ошибка) Тогда
		УдалитьФайлы(ИмяВременногоФайлаИсходный);
		УдалитьФайлы(ИмяВременногоФайлаЦелевой);
		Лог.Предупреждение(Ошибка);
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ПутьКНовомуФайлуПоддержки) Тогда
		УдалитьФайлы(ПутьКНовомуФайлуПоддержки);
		ПереместитьФайл(ИмяВременногоФайлаЦелевой, ПутьКНовомуФайлуПоддержки);
		Лог.Информация("Выполнена конвертация файла поддержки %1 в файл %2", ПутьКФайлуПоддержки, ПутьКНовомуФайлуПоддержки);
	Иначе
		УдалитьФайлы(ПутьКФайлуПоддержки);
		ПереместитьФайл(ИмяВременногоФайлаЦелевой, ПутьКФайлуПоддержки);
		Лог.Информация("Выполнена конвертация файла поддержки %1", ПутьКФайлуПоддержки);
	КонецЕсли;
	
	Если СоздаватьБэкап Тогда
		ФайлПоддержки = Новый Файл(ПутьКФайлуПоддержки);
		ИмяФайлаПоддержки = ФайлПоддержки.Имя;
		ИмяФайлаБэкапа = ИмяФайлаПоддержки + ".bak";
		ПутьКФайлуБэкапа = ОбъединитьПути(ФайлПоддержки.Путь, ИмяФайлаБэкапа);
		УдалитьФайлы(ПутьКФайлуБэкапа);
		ПереместитьФайл(ИмяВременногоФайлаИсходный, ПутьКФайлуБэкапа);
		Лог.Информация("Исходный файл %1 переименован в %2", ИмяФайлаПоддержки, ИмяФайлаБэкапа);
	Иначе
		УдалитьФайлы(ИмяВременногоФайлаИсходный);
	КонецЕсли;

КонецПроцедуры

