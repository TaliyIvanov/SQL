/*Создаю БД, необходимую для дальнейшего прохождения курса*/

CREATE schema enrollee;
USE enrollee;

CREATE TABLE department (
    `department_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name_department` VARCHAR(30)
);
INSERT INTO department (`department_id`, `name_department`)
VALUES (1, 'Инженерная школа'), (2, 'Школа естественных наук');

CREATE TABLE subject (
    `subject_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name_subject` VARCHAR(30)
);
INSERT INTO subject (`subject_id`, `name_subject`)
VALUES (1, 'Русский язык'), (2, 'Математика'), (3, 'Физика'), (4, 'Информатика');

CREATE TABLE program (
    `program_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name_program` VARCHAR(50),
    `department_id` INT,
    `plan` INT,
    FOREIGN KEY (`department_id`) REFERENCES `department`(`department_id`) ON DELETE CASCADE
);
INSERT INTO program (`program_id`, `name_program`, `department_id`, `plan`)
VALUES (1, 'Прикладная математика и информатика', 2, 2),
(2, 'Математика и компьютерные науки', 2, 1),
(3, 'Прикладная механика', 1, 2),
(4, 'Мехатроника и робототехника', 1, 3);

CREATE TABLE enrollee (
    `enrollee_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name_enrollee` VARCHAR(50)
);
INSERT INTO enrollee (`enrollee_id`, `name_enrollee`)
VALUES (1, 'Баранов Павел'), (2, 'Абрамова Катя'), (3, 'Семенов Иван'),
(4, 'Яковлева Галина'), (5, 'Попов Илья'), (6, 'Степанова Дарья');

CREATE TABLE achievement (
    `achievement_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name_achievement` VARCHAR(30),
    `bonus` INT
);
INSERT INTO achievement (`achievement_id`, `name_achievement`, `bonus`)
VALUES (1, 'Золотая медаль', 5), (2, 'Серебряная медаль', 3),
    (3, 'Золотой значок ГТО', 3),(4, 'Серебряный значок ГТО', 1);

CREATE TABLE enrollee_achievement (
    `enrollee_achiev_id` INT PRIMARY KEY AUTO_INCREMENT,
    `enrollee_id` INT,
    `achievement_id` INT,
    FOREIGN KEY (`enrollee_id`) REFERENCES `enrollee`(`enrollee_id`) ON DELETE CASCADE,
    FOREIGN KEY (`achievement_id`) REFERENCES `achievement`(`achievement_id`) ON DELETE CASCADE
);
INSERT INTO enrollee_achievement (`enrollee_achiev_id`, `enrollee_id`, `achievement_id`)
VALUES (1, 1, 2), (2, 1, 3), (3, 3, 1), (4, 4, 4), (5, 5, 1),(6, 5, 3);

CREATE TABLE program_subject (
    `program_subject_id` INT PRIMARY KEY AUTO_INCREMENT,
    `program_id` INT,
    `subject_id` INT,
    `min_result` INT,
    FOREIGN KEY (`program_id`) REFERENCES `program`(`program_id`)  ON DELETE CASCADE,
    FOREIGN KEY (`subject_id`) REFERENCES `subject`(`subject_id`) ON DELETE CASCADE
);
INSERT INTO program_subject (`program_subject_id`, `program_id`, `subject_id`, `min_result`)
VALUES (1, 1, 1, 40),(2, 1, 2, 50), (3, 1, 4, 60), (4, 2, 1, 30),
       (5, 2, 2, 50),(6, 2, 4, 60), (7, 3, 1, 30),(8, 3, 2, 45),
       (9, 3, 3, 45),(10, 4, 1, 40), (11, 4, 2, 45), (12, 4, 3, 45);

CREATE TABLE program_enrollee (
    `program_enrollee_id` INT PRIMARY KEY AUTO_INCREMENT,
    `program_id` INT,
    `enrollee_id` INT,
    FOREIGN KEY (`program_id`) REFERENCES `program`(`program_id`) ON DELETE CASCADE,
    FOREIGN KEY (`enrollee_id`) REFERENCES enrollee(`enrollee_id`) ON DELETE CASCADE
);
INSERT INTO program_enrollee (`program_enrollee_id`, `program_id`, `enrollee_id`)
VALUES (1, 3, 1), (2, 4, 1), (3, 1, 1), (4, 2, 2), (5, 1, 2),
       (6, 1, 3), (7, 2, 3), (8, 4, 3), (9, 3, 4), (10, 3, 5),
       (11, 4, 5), (12, 2, 6), (13, 3, 6), (14, 4, 6);

CREATE TABLE enrollee_subject (
    `enrollee_subject_id` INT PRIMARY KEY AUTO_INCREMENT,
    `enrollee_id` INT,
    `subject_id` INT,
    `result` INT,
    FOREIGN KEY (`enrollee_id`) REFERENCES `enrollee`(`enrollee_id`) ON DELETE CASCADE,
    FOREIGN KEY (`subject_id`) REFERENCES `subject`(`subject_id`) ON DELETE CASCADE
);
INSERT INTO enrollee_subject (`enrollee_subject_id`, `enrollee_id`, `subject_id`, `result`)
VALUES (1, 1, 1, 68), (2, 1, 2, 70), (3, 1, 3, 41), (4, 1, 4, 75), (5, 2, 1, 75), (6, 2, 2, 70),
       (7, 2, 4, 81), (8, 3, 1, 85), (9, 3, 2, 67), (10, 3, 3, 90), (11, 3, 4, 78), (12, 4, 1, 82),
       (13, 4, 2, 86), (14, 4, 3, 70), (15, 5, 1, 65), (16, 5, 2, 67), (17, 5, 3, 60),
       (18, 6, 1, 90), (19, 6, 2, 92), (20, 6, 3, 88), (21, 6, 4, 94);

/*Step_3.3.2 - Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде.*/       
SELECT name_enrollee
FROM program_enrollee
	INNER JOIN enrollee USING(enrollee_id)
    INNER JOIN program USING(program_id)
WHERE name_program LIKE 'Мехатроника и робототехника'
ORDER BY name_enrollee;

/*Step_3.3.3 - Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». 
Программы отсортировать в обратном алфавитном порядке.*/

SELECT name_program
FROM program_subject
	INNER JOIN subject USING(subject_id)
    INNER JOIN program USING(program_id)
WHERE name_subject LIKE 'Информатика'
ORDER BY name_program DESC;

/*Step_3.3.4 - Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ. 
Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее. 
Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить до одного знака после запятой.*/

SELECT name_subject, COUNT(enrollee_id) AS Количество, MAX(result) AS Максимум, MIN(result) AS Минимум , ROUND(AVG(result), 1) AS Среднее
FROM subject
	INNER JOIN enrollee_subject USING(subject_id)
GROUP BY name_subject
ORDER BY name_subject;

/*Step_3.3.5 - Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. 
Программы вывести в отсортированном по алфавиту виде.*/
/*Сначала мержу таблички левым джойном 
далее группирую по наименованию программы
и задаю условия отбора Having >= 40*/
SELECT name_program
FROM program p
	LEFT JOIN program_subject ps ON p.program_id = ps.program_id
GROUP BY name_program
HAVING MIN(min_result) >= 40
ORDER BY name_program;

/*Step_3.3.6 - Вывести образовательные программы, которые имеют самый большой план набора,  вместе с этой величиной.*/
/*Решаем данную задачу с помощью вложенного запроса в отборе*/

SELECT name_program, plan
FROM program
WHERE plan = (SELECT MAX(plan)
	FROM program
    );
    
/*Step_3.3.7 - Посчитать, сколько дополнительных баллов получит каждый абитуриент. 
Столбец с дополнительными баллами назвать Бонус. 
Информацию вывести в отсортированном по фамилиям виде.*/
/*Соединяю таблицы, запрос выполняю с помощью группировки по фамилиям абитуриентов и подсчете суммы доп баллов.*/

SELECT name_enrollee, IFNULL(SUM(bonus), 0) AS Бонус
FROM enrollee
    LEFT JOIN enrollee_achievement USING(enrollee_id)
    LEFT JOIN achievement USING(achievement_id)
GROUP BY name_enrollee    
ORDER BY name_enrollee ASC;

/*Step_3.3.8 - Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений деленное на количество мест по плану), 
округленный до 2-х знаков после запятой. В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы, 
план набора абитуриентов на образовательную программу (plan), 
количество поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса.*/
/*Решение: \
1 - Делаю запрос необходимых столбцов с округлением "конкурса"
2 - Джойню необходимые таблицы. Через вложенный запрос добавляю необходимые столбцы из таблицы program_enrollee
3 - Сортирую*/
SELECT name_department, name_program, plan, Количество, ROUND(Количество/plan, 2) AS Конкурс
FROM department
    INNER JOIN program USING(department_id)
    INNER JOIN 
            (SELECT program_id, COUNT(enrollee_id) AS Количество
            FROM  program_enrollee
            GROUP BY program_id) AS temp USING(program_id)
ORDER BY Конкурс DESC;

/*Step_3.3.9 - Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» в отсортированном по названию программ виде.
Пояснение: Сначала отберите все  программы, для которых определены Математика или Информатика, а потом, сгруппировав результат, отберите те программы, у которых количество отобранных дисциплин ровно две.*/
/*Решение:
1- выбираю столбцец с название программы
2- джойню необходимые таблицы
3- отбираю до группировки только те программы, на которые необходмы нужные предметы
4- Группирую и отбираю уже только те программы, на которые нужны ТОЛЬКО Математика и Информатика
5- Сортировка*/
SELECT name_program
FROM program
        INNER JOIN program_subject USING(program_id)
        INNER JOIN subject USING(subject_id)
WHERE name_subject IN ("Информатика", "Математика")
GROUP BY name_program
HAVING COUNT(name_program) = 2
ORDER BY name_program ASC;

/*Step_3.3.10 - Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, по результатам ЕГЭ. 
В результат включить название образовательной программы, фамилию и имя абитуриента, а также столбец с суммой баллов, который назвать itog. 
Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде.
Пояснение:
При описании соединения таблиц можно использовать схему enrollee →program_enrollee→program →program_subject →subject →enrollee_subject. 
Следующей для соединения идет таблица enrollee , но она уже в списке есть. 
Поэтому для последнего соединения subject →enrollee_subject нужно использовать дополнительное условие связи между enrollee_subject и enrollee*/
/*Решение: 
1 - выбираю необходимые столбцы
2 - джойню таблицы согласно пояснения
3 - выполняю группировку, по дисциплине, затем по программе
4 - сортирую*/
SELECT program.name_program, enrollee.name_enrollee, sum(enrollee_subject.result) as itog
FROM enrollee
    INNER JOIN program_enrollee USING(enrollee_id)
    INNER JOIN program USING(program_id)
    INNER JOIN program_subject USING(program_id)
    INNER JOIN subject USING(subject_id)
    INNER JOIN enrollee_subject ON subject.subject_id = enrollee_subject.subject_id AND enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY name_enrollee, name_program
ORDER BY name_program ASC, itog DESC;


/*Step_3.3.11 - Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее. 
Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым для поступления на эту образовательную программу, меньше минимального балла. 
Информацию вывести в отсортированном сначала по программам, а потом по фамилиям абитуриентов виде.
Например, Баранов Павел по «Физике» набрал 41 балл, а  для образовательной программы «Прикладная механика» минимальный балл по этому предмету определен в 45 баллов. 
Следовательно, абитуриент на данную программу не может поступить.*/
/*Решение:
1 - Выбираю необходимые столбцы
2 - Джойню все необходимые таблицы
3 - Отбираю только тех студентов, чей результат меньше минимального.
4 - группирую
5 - сортирую*/

SELECT name_program, name_enrollee
FROM enrollee
    INNER JOIN program_enrollee USING(enrollee_id)
    INNER JOIN program USING(program_id)
    INNER JOIN program_subject USING(program_id)
    INNER JOIN enrollee_subject USING(subject_id,enrollee_id)
WHERE result < min_result
GROUP BY 1, 2
ORDER BY 1, 2;

