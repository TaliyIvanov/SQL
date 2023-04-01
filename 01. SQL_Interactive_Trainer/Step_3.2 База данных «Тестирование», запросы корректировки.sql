
/*3.2 База данных «Тестирование», запросы корректировки*/

USE test;

/*Step_3.2.2 - В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». 
Установить текущую дату в качестве даты выполнения попытки.*/
/*Решение: - Прописывают запрос на вставку данных из двух таблиц
Джойню данные таблицы 
И через запрос где Имя студента такое и имя предмета такое
далее выбирают все из Attempt
Пока еще полноценно все не понимаю, иду больше по наитию и подглядываю в комментарии */

INSERT INTO attempt(student_id, subject_id, date_attempt)
SELECT student_id, subject_id, NOW()
FROM attempt
	INNER JOIN student USING(student_id)
    INNER JOIN subject USING(subject_id)
WHERE name_student LIKE 'Баранов Павел' AND name_subject LIKE 'Основы баз данных';

SELECT * FROM attempt;

/*Step_3.2.3 - Случайным образом выбрать три вопроса по дисциплине, тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing. 
id последней попытки получить как максимальное значение id из таблицы attempt.*/

/*В данном задании модифицируем запрос из шага 3.1.7 на отбор трех "рандомных" вопросов  
Добавляем их в таблицу тестинг
меняем условие отбора, с вложенным запросов, равным максимальному id в таблице attemp*/

INSERT INTO testing(attempt_id, question_id)
        SELECT attempt_id, question_id
        FROM question
        JOIN attempt USING(subject_id)
        WHERE attempt_id =(SELECT MAX(attempt_id)
                           FROM attempt)
        ORDER BY rand()
        LIMIT 3;
        
SELECT * FROM testing;


/*Step_3.2.4 - Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.  
Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. 
Результат округлить до целого.

 Будем считать, что мы знаем id попытки,  для которой вычисляется результат, в нашем случае это 8. В таблицу testing занесены следующие ответы пользователя: 22 - 19, 23 - 17, 24 - 22*/
 
 /*Для начала занесу в тестинг необходимые значения, чтобы я мог корректно работать с данной таблицей */
 
 UPDATE testing
 SET answer_id = 19
 WHERE testing_id = 22;
 UPDATE testing
 SET answer_id = 17
 WHERE testing_id = 23;
  UPDATE testing
 SET answer_id = 22
 WHERE testing_id = 24;
 SELECT * FROM testing;
 
 /*Теперь пора приступить к решению задачи
 1 - обновляем таблицу attempt 
 2 - устанавливаем необходимое значение, через вложенный запрос, помним, что мы знаем answer_id = 8*/
 
UPDATE attempt
SET result = (SELECT ROUND(SUM(is_correct)/3*100, 0)
            FROM answer 
            INNER JOIN testing USING(answer_id)
            WHERE attempt_id = 8)
WHERE attempt_id = 8;

SELECT * FROM attempt;
 
 
 
 /*Step_3.2.5 - Вы - хакер, жадный до сертификатов степика. Вы увидели структуру базы данных и решили себе сразу так заполучить ещё три  сертификата. (Сдача теста на 100 балов означает для вас новый сертификат).
 Ваша задача:
1. Добавьте себя любимого (любимую) в таблицу студентов.
2. Вставьте в таблицу attempt:
 2.1  свой student_id,
 2.2  все три предмета  которые вы якобы сдали.
 2.3  случайную дату для каждой попытки, такую чтобы дата рассчитывалась как: (сегодняшний день - случайное число дней от 1 до 12) . К примеру, если сегодня 15 января, дата сдачи любого вашего теста была от 3 до 15 января, выбранная случайным образом. Ибо система распознает жуликов, которые получают все три сертификата в один день.
 2.4 В результат воткните себе 100 балов, чтобы все ботаны, кавказцы и евреи  обзавидовались, а ваша мамка расцвела от гордости за своего ребёнка. 
Примечания:
п.2.2  - используйте функцию CROSS JOIN, вставляйте только SELECTOM вставлять словом values - ниже вашего достоинства.
п. 2.3 - вычитать дату можно функцией */

INSERT INTO student (name_student)
VALUES ('Павлов Виталий');
INSERT INTO attempt (student_id, subject_id, date_attempt, result)
    SELECT G.student_id, G.subject_id, DATE_ADD(NOW(), interval rand()*-10 DAY), 100
FROM
    (SELECT student_id, subject_id 
     FROM student 
     CROSS JOIN subject 
     WHERE student_id = (
                     SELECT student_id 
                     FROM student 
                     WHERE name_student = 'Павлов Виталий'))G;
SELECT * FROM attempt;



/*Step_3.2.4 - Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing, которая создавалась следующим запросом:

CREATE TABLE testing (
    testing_id INT PRIMARY KEY AUTO_INCREMENT, 
    attempt_id INT, 
    question_id INT, 
    answer_id INT,
    FOREIGN KEY (attempt_id)  REFERENCES attempt (attempt_id) ON DELETE CASCADE
);*/

/*Решение:
обычный запрос удаления из таблицы аттемпт по дате 
единственная загвоздка - это корректно указать дату 
из таблицы тестинг все удаляется автоматически, т.к. она создавалась каскадным удалением через внешний ключ */

DELETE FROM attempt
WHERE date_attempt <  '2020-05-01';

SELECT * FROM attempt;

SELECT * FROM testing;