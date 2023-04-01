USE `stepik`;

SELECT title, author, price, amount
FROM `book`
WHERE price = (SELECT MIN(price) FROM `book`);

/*Step 1.4.2 - Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе. 
Информацию вывести в отсортированном по убыванию цены виде. 
Среднее вычислить как среднее по цене книги.*/
SELECT author, title,  price
FROM `book`
WHERE price <= (SELECT AVG(price) FROM `book`)
ORDER BY price DESC;

/*Step 1.4.3 - Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе не более чем на 150 рублей в отсортированном по возрастанию цены виде.*/
SELECT author, title,  price
FROM `book`
WHERE (price - (
SELECT MIN(price) 
FROM `book`) <= 150)
ORDER BY price;

SELECT title, author, amount, price
FROM book
WHERE author IN (
        SELECT author 
        FROM book 
        GROUP BY author 
        HAVING SUM(amount) >= 12
      );

/*Step 1.4.4 - Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.*/      
SELECT title, author, amount, price
FROM book
WHERE amount IN (
	SELECT amount
    FROM `book`
    GROUP BY amount
	HAVING COUNT(amount) = 1
    );

/*Запрос всей инфы о книгах, количество которых меньше самого МЕНЬШЕГО среднего количества книг у каждого автора*/    
SELECT title, author, amount, price
FROM book
WHERE amount < ALL (
        SELECT AVG(amount) 
        FROM book 
        GROUP BY author 
      );
      
/*Запрос всей инфы о книгах, количество которых меньше самого БОЛЬШЕГО среднего количества книг у каждого автора*/
SELECT title, author, amount, price
FROM book
WHERE amount < ANY (
        SELECT AVG(amount) 
        FROM book 
        GROUP BY author 
      );

/*Step 1.4.5 - Вывести информацию о книгах(автор, название, цена), цена которых меньше самой  БОЛЬШОЙ из МИНИМАЛЬНЫХ цен, вычисленных для каждого автора.
РЕШЕНИЕ:
необходимо использовать amount < ANY (10, 12) эквивалентно amount < 12 со вложенным запросом, в котором я вычисляю минимальные цены, группируя по автору*/ 

SELECT title, author, amount, price
FROM book
WHERE price < ANY (
	SELECT MIN(price)
    FROM `book`
    GROUP BY author
    );
    
/*Вывести информацию о книгах, количество экземпляров которых отличается от среднего количества экземпляров книг на складе более чем на 3,  
а также указать среднее значение количества экземпляров книг.*/

SELECT title, author, amount, FLOOR((SELECT AVG(amount) FROM book)) AS Среднее_количество 
FROM book
WHERE abs(amount - (SELECT AVG(amount) FROM book)) >3;

/*Step 1.4.6 - Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество экземпляров каждой книги, равное значению 
самого БОЛЬШОГО количества экземпляров одной книги на складе. 
Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. 
Последнему столбцу присвоить имя Заказ. 
В результат не включать книги, которые заказывать не нужно.*/

SELECT title, author, amount, (SELECT MAX(amount) FROM book) - amount AS Заказ
FROM book
WHERE amount < (SELECT MAX(amount) FROM book);

/*Step 1.4.7 - Подсчитать какая сколько каждая книга приносит в % 
1 - Необходимо вычислить выручку
2 - вычислить % каждой книги от это выручки*/

/*ШАГ 1 - вычисление всей выручки*/
SELECT SUM(price*amount) AS Выручка
FROM `book`;

/*ШАГ 2 - % каждой книги от выручки*/
SELECT title, author, amount, FLOOR(((price * amount*100)/(
	SELECT SUM(price*amount)
	FROM `book`))) AS Процент_от_выручки
FROM `book`;

