# Что это?
Инструментарий для версионирования файла `ParentConfigurations.bin`


### Объекты снятые с подержки
```sh
grep ^[^0],0, src/Ext/ParentConfigurations.bin | perl -pe 's/,\w{8}-\w{4}-\w{4}-\w{4}-\w{12},//'
```
