
Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("PATH", ".", 
				"Путь к папке со объединяемыми файлами")
				.ТСтрока()
				.Обязательный(Ложь);
				
	Команда.Опция("old", "ParentConfigurations_old.bin", 
				"Путь к старому файлу ParentConfigurations*.bin (текущие настройки)")
				.ТСтрока();
				
	Команда.Опция("new", "ParentConfigurations_new.bin", 
				"Путь к новому файлу ParentConfigurations*.bin (файл из нового релиза)")
				.ТСтрока();
				
	Команда.Опция("out", "ParentConfigurations_merge.bin", 
				"Путь к результату мержа (файл new c перенесенными из old настройками)")
				.ТСтрока();
				
КонецПроцедуры

// Выполняет логику команды
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Лог = ПараметрыПриложения.Лог();

	ПутьККаталогу      = Команда.ЗначениеАргумента("PATH");
	СтарыйФайл         = Команда.ЗначениеОпции("old");
	НовыйФайл     	   = Команда.ЗначениеОпции("new");
	РезультирующийФайл = Команда.ЗначениеОпции("out");
	
	УстановитьТекущийКаталог(ПутьККаталогу);

	Конвертер = Новый Конвертер();
	ТаблицаПоддержки = Конвертер.ПолучитьТаблицуОбъектовНаПоддержке(СтарыйФайл);
	ТаблицаПоддержки.Индексы.Добавить("Имя");
	ТаблицаПоддержки.Индексы.Добавить("ГУИД");

	ТекстНовогоФайла = ОбщегоНазначения.ПрочитатьФайлВТекст(НовыйФайл);
	Если СтрЧислоСтрок(ТекстСодержимогоФайла) = 1 Тогда
		НовыйСконвертированныйФайл = ПолучитьИмяВременногоФайла();
		Конвертор.ВыполнитьКонвертацию(Новый Метаданные(), НовыйФайл, НовыйСконвертированныйФайл, Ложь);
		РазрешитьСопоставлятьПоИменам = Ложь;
	Иначе
		НовыйСконвертированныйФайл = НовыйФайл;
		РазрешитьСопоставлятьПоИменам = Истина;
	КонецЕсли;

	ТекстСодержимогоФайла = ОбщегоНазначения.ПрочитатьФайлВТекст(НовыйСконвертированныйФайл);

	РВ_ПарныеГуиды = Новый РегулярноеВыражение("(\d,-?\d),(\w{8}-\w{4}-\w{4}-\w{4}-\w{12}), #(.*)");
	РВ_РазныеГуиды = Новый РегулярноеВыражение("(\d,-?\d),(\w{8}-\w{4}-\w{4}-\w{4}-\w{12},\w{8}-\w{4}-\w{4}-\w{4}-\w{12}), #(.*)");
	МассивСтрок = СтрРазделить(ТекстСодержимогоФайла, Символы.ПС);
	Для каждого Стр Из МассивСтрок Цикл
		Совпадения1 = РВ_ПарныеГуиды.НайтиСовпадения(Стр);
		Если Совпадения1.Количество() Тогда
			СтрТаблицы = Таблица.Добавить();
			СтрТаблицы.Режим = Совпадения1[0].Группы[1].Значение;
			СтрТаблицы.ГУИД  = Совпадения1[0].Группы[2].Значение;
			СтрТаблицы.Имя   = СокрЛП(Совпадения1[0].Группы[3].Значение);
		Иначе
			Совпадения2 = РВ_РазныеГуиды.НайтиСовпадения(Стр);
			Если Совпадения2.Количество() Тогда
				СтрТаблицы = Таблица.Добавить();
				СтрТаблицы.Режим = Совпадения1[0].Группы[1].Значение;
				СтрТаблицы.ГУИД  = Совпадения1[0].Группы[2].Значение;
				СтрТаблицы.Имя   = СокрЛП(Совпадения1[0].Группы[3].Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;


	ИмяВременногоРезультирующегоФайла = ПолучитьИмяВременногоФайла();



КонецПроцедуры

