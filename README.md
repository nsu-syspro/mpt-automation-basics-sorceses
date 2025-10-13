[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/_JQgFJ9m)
# Знакомство со средствами автоматизации сборки

<img alt="points bar" align="right" height="36" src="../../blob/badges/.github/badges/points-bar.svg" />

[![Automation](https://imgs.xkcd.com/comics/automation.png)](https://xkcd.com/1319/)

## Локальная проверка

Для локальной проверки ваших решений можно пользоваться следующей командой:
```console
$ bash .test/taskX/validate
```
где `X` - номер соответствующего задания.

## Задание №1 (3 балла)

В директории [src](/src) находится исходный код приложения `wordcount`, написанного на языке Си,
для подсчета количества слов в указанных файлах или во входном потоке `STDIN`.

Также в корне репозитория находится конфигурационный файл [config.json](/config.json), в котором указано
название приложения (которое может отличаться от названия исходного файла) и версия приложения.
Предполагается, что эти значения должны явно передаваться при компиляции приложения с помощью
[директивы препроцессора](https://gcc.gnu.org/onlinedocs/gcc/Preprocessor-Options.html) `-D`,
переопределяя тем самым объявления `NAME` и `VERSION` из [src/wordcount.c](/src/wordcount.c).

Требуется автоматизировать процесс сборки приложения с помощью системы сборки
[make](https://www.gnu.org/software/make/manual/make.html) с учетом следующих требований:

- Итоговый артефакт сборки (скомпилированное приложение) должен находиться в директории `build`
  и называться в соответствии со значением `name`, указанном в [config.json](/config.json);
- При компиляции приложения необходимо определить значения объявлений `NAME` и `VERSION`
  в соответствии со значениями `name` и `version`, указанными в [config.json](/config.json);
- При изменении исходного кода приложения или `config.json`, приложение должно перекомпилироваться;
- При отсутствии изменений, перекомпиляции не должно происходить;
- В качестве цели по умолчанию следует использовать
  [стандартную](https://www.gnu.org/software/make/manual/make.html#Standard-Targets) цель `all`;
- Также необходимо объявить цель `clean`, которая производит
  [очистку](https://www.gnu.org/software/make/manual/make.html#Cleanup) артефактов сборки.

> [!IMPORTANT]
>
> Для получения значений из `config.json` следует воспользоваться стандартной утилитой [jq](https://jqlang.org),
> которую можно установить следующей командой на Ubuntu:
> ```bash
> $ sudo apt install jq
> ```
> С помощью этой утилиты можно получить значения `name` и `version` следующими командами:
> ```bash
> $ jq -r .name config.json
> wordcount
> $ jq -r .version config.json
> 1.0.0
> ```

**Пример использования**

```console
$ make
...
$ ./build/wordcount
wordcount version 1.0.0
$ make
make: Nothing to be done for 'all'.
$ make clean
```

> [!TIP]
>
> Настоятельно рекомендуется ознакомиться со следующими главами из 
> из официальной [документации](https://www.gnu.org/software/make/manual/make.html):
> - [An Introduction to Makefiles](https://www.gnu.org/software/make/manual/make.html#Introduction)
> - [Writing Rules](https://www.gnu.org/software/make/manual/make.html#Introduction)

## Задание №2 (3 балла)

В директории [test](/test) находятся тесты с расширением `.txt` и ожидаемый вывод
с расширением `.expected` для приложения `wordcount`, собранного в предыдущем задании.

Требуется автоматизировать процесс тестирования приложения с помощью системы сборки
[make](https://www.gnu.org/software/make/manual/make.html) с учетом следующих требований:

- Необходимо проверить соответствие всех вывода приложения на всех тестах в директории [test](/test);
- В случае несоответствия вывода на каком-либо тесте, нужно вывести разницу ожидаемого вывода
  с полученным, и завершить тестирование с ошибкой;
- В случае успешного прохождения всех тестов, никакого вывода в консоль не должно происходить;
- Тестирование должно неявно вызывать сборку приложения, если она еще не произошла;
- Процедура тестирования не должна оставлять после себя никаких лишних файлов в репозитории или
  каким-либо образом изменять его содержимое;
- В качестве цели следует использовать
  [стандартную](https://www.gnu.org/software/make/manual/make.html#Standard-Targets) цель `check`.

**Пример использования**

```console
$ make
...
$ make check
```

> [!TIP]
>
> Рекомендуется ознакомиться со следующими разделами документации:
> - [Recipe Echoing](https://www.gnu.org/software/make/manual/make.html#Echoing)
> - [Functions for String Substitution and Analysis](https://www.gnu.org/software/make/manual/make.html#Text-Functions)

## Задание №3 (3 балла)

Для сборки и исполнения приложения может требоваться определенное окружение или зависимости.
В случае приложения `wordcount` его сборка требует установленной в системе утилиты [jq](https://jqlang.org)
для получения конфигурационных значений из `config.json`.

Требуется унифицировать окружение сборки и тестирования приложения `wordcount` с помощью
[Docker](https://www.docker.com).

Необходимо создать [Dockerfile](https://docs.docker.com/build/concepts/dockerfile/)
с учетом следующих требований:

- Сборка Docker-образа должна запускать тесты из предыдущего задания и заканчиваться ошибкой,
  если тесты не прошли;
- При запуске образа должно запускаться собранное приложение;
- В итоговом образе должно находиться полное содержимое репозитория;
- Рабочая директория в контейнере должна быть выставлена в корень репозитория.

**Пример использования**

```console
$ docker build --network host -t wordcount .
[+] Building ...
$ docker run --rm -i wordcount --version
wordcount version 1.0.0
```

## Задание №4 (1 балл)

Последним шагом является создание системы
[Continuous Integration](https://docs.github.com/en/actions/get-started/continuous-integration) (CI),
для автоматической верификации (сборки и тестирования) каждого изменения в репозитории приложения.

Требуется создать *workflow* в
[GitHub Actions](https://docs.github.com/en/actions/get-started/understand-github-actions),
который будет автоматически запускать сборку и тестирование приложения с помощью `make`
на каждый *push* и Pull request в `main` ветку.

> [!TIP]
>
> По умолчанию GitHub Actions исполняются на выделенной виртуальной машине,
> на которой установлены многие стандартные зависимости и системы сборки
> для различных языков программирования.
>
> В частности, там предустановлены все необходимые зависимости для сборки
> приложений на Си с помощью `make`, а также уже установлена утилита `jq`.
> Таким образом, в нашем случае для GitHub Actions не требуется производить
> сборку в Docker окружении, что значительно ускоряет сборку и тестирование.
