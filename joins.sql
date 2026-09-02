use practice;
show tables;

select *from authors;
select *from books;

Insert into authors(author_id,first_name,last_name,birth_year)
Values
	(1,"Jane","Austen",1775),
    (2,"Feorge","Orwell",1983),
    (3,"Enrests","Hemingway",1899),
    (4,"Agatha","Christie",1890),
    (5,"J.K","Rowling",1965);
  
SELECT *
From authors
JOIN Books
on authors.author_id=books.author_id;


-- INNER JOIN and JOIN are same 
Select authors.author_id,authors.first_name,books.book_id,books.tittle
from authors
join Books
on authors.author_id= books.author_id;

-- How many books each author has written
Select authors.first_name as author_name,count(*) as book_count
from authors
join books
on authors.author_id=books.author_id
group by authors.author_id;

-- create table category 
Create table categores(
category_id INT PRIMARY KEY,
category_name VARCHAR(50));

alter table categores rename to categories;

INSERT INTO categories(category_id,category_name)
values 
	(1,"Fiction"),
    (2,"Classic"),
    (3,"Romance"),
    (4,"Political"),
    (5,"Mystery"),
    (6,"Adventure");

Select *from categories;

-- Bridge of two tables
Create table book_categories (
	book_id INT,
    category_id INT,
    PRIMARy KEY (book_id,category_id)
);

INSERT INTO book_categories (book_id, category_id)
VALUES 
    (101, 1), (101, 2), (101, 3), -- Pride and Prejudice: Fiction, Classic, Romance
    (102, 1), (102, 2), (102, 4), -- 1984: Fiction, Classic, Political
    (103, 1), (103, 2), (103, 4), -- Animal Farm: Fiction, Classic, Political
    (104, 1), (104, 2), (104, 6), -- The Old Man and the Sea: Fiction, Classic, Adventure
    (105, 1), (105, 5), -- Murder on the Orient Express: Fiction, Mystery
    (106, 1), (106, 5), -- Death on the Nile: Fiction, Mystery
    (107, 1), (107, 2), (107, 3), -- Emma: Fiction, Classic, Romance
    (108, 1), (108, 2), (108, 6); -- For Whom the Bell Tolls: Fiction, Classic, Adventure

-- Get books with their authors and categories

Select 
	   books.book_id,
	   books.tittle,
	   authors.first_name,
       authors.last_name,
       categories.category_name,
       count(*) AS category_count
FROM books
Join authors ON authors.author_id=books.author_id
JOIN book_categories AS bc ON books.book_id=bc.book_id
JOIN categories ON  categories.category_id=bc.category_id
order by categories.category_name asc;


Select 
       categories.category_name,
       count(*) AS category_count
FROM books
Join authors ON authors.author_id=books.author_id
JOIN book_categories AS bc ON books.book_id=bc.book_id
JOIN categories ON  categories.category_id=bc.category_id
Group by categories.category_name;

Select b.tittle,
	   a.first_name,
       a.last_name,
       group_concat(c.category_name)
FROM books b
Join authors a ON a.author_id=b.author_id
JOIN book_categories AS bc ON b.book_id=bc.book_id
JOIN categories c ON  c.category_id=bc.category_id
Group by b.book_id;


Select 
       group_concat(b.tittle),
       c.category_name
FROM books b
Join authors a ON a.author_id=b.author_id
JOIN book_categories AS bc ON b.book_id=bc.book_id
JOIN categories c ON  c.category_id=bc.category_id
Group by c.category_name;

-- Return books published before 1950 by authors born before 1900

select b.tittle, a.first_name From books b
join authors a ON a.author_id=b.author_id
			  AND b.publication_year<1950
              AND a.birth_year<1900;

show tables;

-- Return books published more than 70 year ago
SELECT b.tittle, a.last_name
FROM books b
INNER JOIN authors a
ON a.author_id = b.author_id
where year(curdate())-b.publication_year>=70;

/*
INNER JOIN excludes row with NULL values in the join columns. If you want to include row with NULL values, you would need to use LEFT JOIN or Right JOIN
*/

-- find author who have written more then one book 
SELECT a.first_name, count(*) AS book_count
From authors a
JOIN books b
on b.author_id=a.author_id
Group by a.author_id
HAVING count(*)>1;

SELECT *FROM books;










