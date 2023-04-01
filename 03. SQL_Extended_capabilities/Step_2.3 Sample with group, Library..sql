USE `LIBRARY`;

/*Step_2.3.2 - Вывести, сколько различных книг каждого жанра представлены в библиотеке. 
Также посчитать количество доступных экземпляров книг каждого жанра. 
Столбцы назвать Жанр, Количество_книг, Доступно_экземпляров. 
Информацию отсортировать по названию жанра в алфавитном порядке.  
Учитывать только те жанры, книги которых занесены в таблицу book.*/

SELECT genre_name Жанр, count(title) Количество_книг, SUM(available_numbers) Доступно_экземпляров
FROM genre g
    RIGHT JOIN book b ON g.genre_id=b.genre_id
GROUP BY genre_name
ORDER BY 1;

/*Step_2.3.2 - Вывести книги, которые написаны двумя и более авторами, вывести год издания и в каком издательстве они опубликованы. 
Столбцы назвать Название, Издательство, Год_издания. 
Информацию отсортировать по названию книги в обратном алфавитном порядке.*/

SELECT title Название, publisher_name Издательство, year_publication Год_издания
FROM book b
    INNER JOIN book_author ba ON b.book_id = ba.book_id
    INNER JOIN publisher p ON p.publisher_id = b.publisher_id
GROUP BY title, publisher_name, year_publication
HAVING COUNT(author_id) >= 2
ORDER BY 1 DESC;

/*Step_2.3.3 - Для каждого читателя посчитать, сколько книг он брал в библиотеке, дату его первого посещения библиотеки и дату его последнего посещения 
(это может быть дата, когда читатель последний раз брал книгу, или дата, когда читатель последний раз сдавал книгу). 
Столбцы назвать Читатель, Количество, Первое_посещение, Последнее_посещение. Информацию отсортировать по фамилии читателя в алфавитном порядке.
Пояснение. Информацию выводить только о тех читателях, которые брали книги в библиотеке.*/

SELECT
    reader_name Читатель, 
    COUNT(borrow_date) Количество,
    MIN(borrow_date) AS Первое_посещение,
    MAX(IF(return_date IS NOT NULL, return_date, borrow_date)) AS Последнее_посещение
FROM reader r
    RIGHT JOIN book_reader br ON r.reader_id = br.reader_id
GROUP BY reader_name
ORDER BY 1;

/*Step_2.3.4 - */
/*Step_2.3.5 - */
/*Step_2.3.6 - */
/*Step_2.3.7 - */
/*Step_2.3.8 - */
/*Step_2.3.9 - */
/*Step_2.3.10 - */