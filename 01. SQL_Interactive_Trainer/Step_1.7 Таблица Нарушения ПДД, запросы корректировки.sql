USE `stepik`;

/*Step_1.7.1*/
/*Создаю таблицу `fine`*/
CREATE TABLE `fine`(
	fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2),
    date_violation DATE,
    date_payment DATE
    );

/*Вношу данные в таблицу `fine`*/    
INSERT INTO `fine` (name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES ('Баранов П.Е.', 'P523BT', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
       ('Абрамова К.А.', 'О111AB', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
       ('Яковлев Г.Р.', 'T330TT', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL),
       ('Баранов П.Е.', 'P523BT', 'Превышение скорости(от 40 до 60)', 500.00, '2020-01-12', '2020-01-17'),
       ('Абрамова К.А.', 'О111AB', 'Проезд на запрещающий сигнал', 1000.00, '2020-01-14', '2020-02-27'),
       ('Яковлев Г.Р.', 'T330TT', 'Превышение скорости(от 20 до 40)', 500.00, '2020-01-23', '2020-02-23'),
       ('Яковлев Г.Р.', 'M701AA', 'Превышение скорости(от 20 до 40)', NULL, '2020-01-12', NULL),
       ('Колесов С.П.', 'K892AX', 'Превышение скорости(от 20 до 40)', NULL, '2020-02-01', NULL);

/*Step_1.7.2 - Создаю таблицу traffic_violation, согласно задания*/       
CREATE TABLE traffic_violation
(
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    violation    VARCHAR(50),
    sum_fine     DECIMAL(8, 2)
);

/*Step_1.7.2 - Вношу данные в таблицу traffic_violation*/ 
INSERT INTO traffic_violation (violation, sum_fine)
VALUES ('Превышение скорости(от 20 до 40)', 500),
       ('Превышение скорости(от 40 до 60)', 1000),
       ('Проезд на запрещающий сигнал', 1000);
 
/*Step_1.7.3 - Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. 
При этом суммы заносить только в пустые поля столбца  sum_fine.
Таблица traffic_violationсоздана и заполнена.
Важно! Сравнение значения столбца с пустым значением осуществляется с помощью оператора IS NULL.*/

UPDATE fine f, traffic_violation tv
SET f.sum_fine = tv.sum_fine
WHERE (f.sum_fine is NULL) AND f.violation = tv.violation;

/*Step_1.7.5 Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило   два и более раз. 
При этом учитывать все нарушения, независимо от того оплачены они или нет. 
Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
Произвести группировку как в примере по имени, машине и штрафу
И через HAVING сравнить: посчитать через каунт количество нарушений и сравнить с 2*/

SELECT name, number_plate, violation
FROM `fine`
GROUP BY name, number_plate, violation
HAVING COUNT(violation) >= 2
ORDER BY name, number_plate, violation;

/*Step_1.7.6 В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 

Этот шаг необходимо дополнительно разобрать и понять!!!1111111111111111111111
Все я понель
1 - Повторяем запрос из предыдущего шага, дабы выбрать записи водителей с количество нарушений равным 2 и более по одному и тому же нарушению
2 - увеличиваем сумму штрафа тем, кто не оплатил данные штрафы, то есть значение в таблице по оплате IS NULL*/

UPDATE 
    fine f,
    (SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) > 1) q_in
SET f.sum_fine = f.sum_fine * 2
WHERE
    (f.name, f.number_plate, f.violation) = 
    (q_in.name, q_in.number_plate, q_in.violation) AND
    f.date_payment IS Null;

/*Step_1.7.7 Необходимо:
в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
1 - обновляем табличку fine
2 - заносим дату оплаты из f в p
3 - через IF прописываем условие, при котором сумма штрафа уменьшается, если разница дней меньше 20
4 - для тех штрафов, в которых у нас имя, номер , штраф и дата штрафа соответствуют в двух таблицах*/

UPDATE fine f, payment p
SET    f.date_payment = p.date_payment,
       f.sum_fine = IF(DATEDIFF(p.date_payment, f.date_violation) <= 20, f.sum_fine / 2, f.sum_fine)
WHERE (f.name, f.number_plate, f.violation, f.date_violation) = (p.name, p.number_plate, p.violation, p.date_violation);

/*Step_1.7.8 Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
здесь все просто и понятно
создаю таблицу
выбираю необходимые столбцы из fine, значения которых равны нулю, т.к. нуль = неоплаченный штраф*/

CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;






