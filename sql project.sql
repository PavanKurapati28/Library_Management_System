create database library_Management;
use library_Management;

select * from authors;

desc authors;

-- adding primary key and auto increment to the authors table 

alter table authors
add column book_authors_AuthorID int not null auto_increment,
add primary key (book_authors_AuthorID); 

select * from publisher;

-- adding primary key to publisher table 

alter table publisher
modify column publisher_PublisherName varchar(255) not null,
add primary key (publisher_PublisherName);

alter table publisher drop primary key;

desc publisher;

select * from books;

-- changing column name 

alter table books
change column ï»¿book_BookID book_BookID int;

desc books;

-- adding primary key to books table

alter table books 
add primary key(book_BookID);

select * from `book copies`;

-- adding primary key to the book copies table 

alter table `book copies`
add column book_copies_CopiesID int not null auto_increment,
add primary key (book_copies_CopiesID);

desc `book copies`;

select * from borrower;

-- adding primary key to the borrower table

alter table borrower
add primary key(borrower_CardNo);

desc borrower;

select * from `book loans`;

-- adding primary key to the book loans table 

alter table `book loans`
add column book_loan_loanID int not null auto_increment,
add primary key (book_loan_loanID);

desc `book loans`;

select * from `library branch`;

-- adding primary key to the library branch table

alter table `library branch`
add column library_branch_BranchID int not null auto_increment,
add primary key (library_branch_BranchID);

desc `library branch`;

-- creating foreign key to auhtors table book_authors_BookID column to books table book_BookID column 

alter table authors
add constraint fk_1
foreign key (book_authors_BookID)
references books(book_BookID)
on delete cascade
on update cascade;

desc authors;

-- changing column name

alter table authors
change column ï»¿book_authors_BookID book_authors_BookID int;

select * from authors;

-- creating foreign key to books table book_PublisherName column and publisher table publisher_PublisherName column

alter table books
add constraint fk_2
foreign key(book_PublisherName)
references publisher(publisher_PublisherName)
on delete cascade
on update cascade;


select * from publisher;
desc publisher;

select * from books;
desc books;

-- changing column datat type to varchar

alter table books
modify column book_PublisherName varchar(255);

-- changing column data type to varchar

alter table publisher
modify column publisher_PublisherName varchar(255);

-- creating foreign key for book copies table book_copies_BookID column and books table book_BookID column 


alter table `book copies`
add constraint fk_3
foreign key(book_copies_BookID)
references books(book_BookID)
on delete cascade
on update cascade;

select * from `book copies`;
select * from books;

-- changing column name 

alter table `book copies`
change column ï»¿book_copies_BookID book_copies_BookID int;

-- creating foreign key for book copies table book_copies_BranchID column and library branch table library_branch_BranchID column


alter table `book copies`
add constraint fk_4
foreign key(book_copies_BranchID)
references `library branch`(library_branch_BranchID)
on delete cascade
on update cascade;

select * from `library branch`;

-- creating foreign key for book loans table book_loans_BookID column and books table book_BookID column

alter table `book loans`
add constraint fk_5
foreign key(book_loans_BookID)
references books(book_BookID)
on delete cascade
on update cascade;

select * from `book loans`;

-- changing column name

alter table `book loans`
change column ï»¿book_loans_BookID book_loans_BookID int;

-- creating foreign key for book loans table book_loans_BranchID column and library branch table  library_branch_BranchID column

alter table `book loans`
add constraint fk_6
foreign key (book_loans_BranchID)
references `library branch`(library_branch_BranchID)
on delete cascade;


select * from `library branch`;

-- creating foreign key for book loans table book_loans_CardNo column  and borrower table borrower column

alter table `book loans`
add constraint fk_7
foreign key(book_loans_CardNo)
references borrower(borrower_CardNo)
on delete cascade
on update cascade;

-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

select * from `book copies`;
select * from `library branch`;
select * from books;

select count(book_copies_No_Of_Copies) AS Total_Copies
from `book copies` bc
join books b on bc.book_copies_BookID = b.book_BookID
join `library branch` lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = 'The Lost Tribe'
and lb.library_branch_BranchName = 'Sharpstown';

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select * from `library branch`;


select lb.library_branch_BranchName, count(book_copies_No_Of_Copies) as Total_Copies
from `book copies` bc
join books b on bc.book_copies_BookID = b.book_BookID
join `library branch` lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where b.book_Title = 'The Lost Tribe'
group by lb.library_branch_BranchName;

-- Retrieve the names of all borrowers who do not have any books checked out.

select br.borrower_BorrowerName
from borrower br
left join `book loans` bl on br.borrower_CardNo = bl.book_loans_CardNo
where bl.book_loans_CardNo is null;

-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address

select * from books;
select * from `book loans`;
select * from `library branch`;

select b1.book_title, b2.borrower_BorrowerName,b2. borrower_BorrowerAddress from `library branch` as l1 join 
`book loans` as b on b.book_loans_BranchID=l1.library_branch_BranchID
join books as b1 on b1.book_Bookid=b.book_loans_BookID join borrower as b2 on b.book_loans_CardNo=b2.borrower_CardNo
where l1.library_branch_BranchName="Sharpstown" and b.book_loans_DueDate="2/3/18";

-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch

select * from `book loans`;
select * from `library branch`;

select lb.library_branch_BranchName, count(bl.book_loan_loanID) as Total_Books_Loaned
from `library branch` lb
left join `book loans` bl on lb.library_branch_BranchID = bl.book_loans_BranchID
group by lb.library_branch_BranchName;

-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out

select br.borrower_BorrowerName, br.borrower_BorrowerAddress, count(bl.book_loan_LoanID) as Books_Checked_Out
from borrower br
join `book loans` bl on br.borrower_CardNo = bl.book_loans_CardNo
group by br.borrower_CardNo, br.borrower_BorrowerName, br.borrower_BorrowerAddress
having count(bl.book_loan_LoanID) > 5;

-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select b.book_Title, bc.book_copies_No_Of_Copies
from authors a
inner join books b on a.book_authors_BookID = b.book_BookID
inner join `book copies` bc on b.book_BookID = bc.book_copies_BookID
inner join `library branch` lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where a.book_authors_AuthorName = 'Stephen King'
and lb.library_branch_BranchName = 'Central';









