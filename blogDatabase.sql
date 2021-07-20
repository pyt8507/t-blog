create database blogDatabase;
use blogDatabase;
create table user(userid int not null auto_increment,
	username char(30) not null,
	password varchar(30) character set utf8,
	role char(20) character set gb2312,
	registertime datetime,
	birthday date,
	gender char(5) character set gb2312,
	email char(25),
	phone char(20),
	primary key(userid));

create table article(id int not null auto_increment,
	title varchar(100),
	userid int,
	post_time datetime,
	open_read char(15),
	open_comment char(15),
	keywords char(30),
	content varchar(10000),
	primary key(id),
	foreign key(userid) references user(userid) on delete cascade);

create table comment(id int not null auto_increment,
	articleId int,
	userid int,
	comment_time datetime,
	comment_content varchar(200),
	primary key(id),
	foreign key(articleId) references article(id) on delete cascade,
	foreign key(userid) references user(userid) on delete cascade);

create table subscribe(id int,
	userid int,
	primary key(id,userid),
	foreign key(id) references article(id) on delete cascade,
	foreign key(userid) references user(userid) on delete cascade);