use `stepik`;


/*Step_1.1.7 - Сформулируйте SQL запрос для создания таблицы book, занесите  его в окно кода (расположено ниже)  и отправьте на проверку (кнопка Отправить).*/
CREATE TABLE `book` (
`book_id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(50),
`author` VARCHAR(30),
`price` DECIMAL(8,2),
`amount` INT);


/*Step_1.1.8 - Занесите новую строку в таблицу book (текстовые значения (тип VARCHAR) заключать либо в двойные, либо в одинарные кавычки):*/
INSERT INTO `book`(title, author, price, amount)
VALUES ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);
INSERT INTO `book`(title, author, price, amount)
VALUES ('Белая гвардия', 'Булгаков М.А.', 540.50, 5);
INSERT INTO `book`(title, author, price, amount)
VALUES ('Идиот','Достоевский Ф.М.',460.00,10);
INSERT INTO `book`(title, author, price, amount)
VALUES ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);

/*Повторение команд*/
SELECT * FROM `book`;

INSERT INTO `book`(title, author, price, amount)
VALUES ('Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15);

SELECT * FROM `book`;

SELECT author, title, price FROM `book`;

SELECT title AS Название, author AS Автор FROM `book`;

SELECT title, amount, amount*1.65 AS pack FROM `book`;

SELECT title, author, amount, ROUND(price*0.7, 2) AS new_price FROM `book`;

SELECT author, title, ROUND(IF(author = 'Булгаков М.А.', price*1.1, IF(author = 'Есенин С.А.', price*0.95, price*1)),2) AS new_price
FROM `book`;

SELECT * FROM `book`
WHERE amount > 4;

SELECT title, author, price FROM `book`
WHERE price > 600 AND (author = 'Булгаков М.А.' OR author = 'Есенин С.А.');

SELECT title, author, price, amount FROM `book`
WHERE (price < 500 OR price > 600) AND price*amount >= 5000;

SELECT title, amount FROM `book`
WHERE amount BETWEEN 5 AND 14;

SELECT title, author FROM `book`
WHERE (price BETWEEN 540.50 AND 800) AND (amount IN (2,3,5,7));

SELECT author, title
FROM `book`
WHERE amount BETWEEN 2 AND 14
ORDER BY author DESC, title;


SELECT title
FROM `book`
WHERE title LIKE '_____';

select * from `book`;

SELECT title, author
FROM `book`
WHERE title LIKE '_% _%' AND author LIKE '%С.%'
ORDER BY title;



