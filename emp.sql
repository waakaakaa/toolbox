/*
emp员工表(empno员工号/ename员工姓名/job工作/mgr上级编号/hiredate受雇日期/sal薪金/comm佣金/deptno部门编号) 

dept部门表(deptno部门编号/dname部门名称/loc地点) 

工资 ＝ 薪金 ＋ 佣金 
*/

CREATE TABLE DEPT
(DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
DNAME VARCHAR2(14),
LOC VARCHAR2(13)
);

CREATE TABLE EMP
(EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
ENAME VARCHAR2(10),
JOB VARCHAR2(9),
MGR NUMBER(4),
HIREDATE DATE,
SAL NUMBER(7,2),
COMM NUMBER(7,2),
DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,to_date('13-JUL-87','dd-mm-rr')-85,3000,NULL,20);
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,to_date('13-JUL-87', 'dd-mm-rr')-51,1100,NULL,20);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);

CREATE TABLE BONUS
(ENAME VARCHAR2(10)    ,
JOB VARCHAR2(9)  ,
SAL NUMBER,
COMM NUMBER
);

CREATE TABLE SALGRADE
(GRADE NUMBER,
LOSAL NUMBER,
HISAL NUMBER );

INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;


/*
1．列出至少有一个员工的所有部门。 
2．列出薪金比“SMITH”多的所有员工。 
3．列出所有员工的姓名及其直接上级的姓名。 
4．列出受雇日期早于其直接上级的所有员工。 
5．列出部门名称和这些部门的员工信息，同时列出那些没有员工的部门。 
6．列出所有“CLERK”（办事员）的姓名及其部门名称。 
7．列出最低薪金大于1500的各种工作。 
8．列出在部门“SALES”（销售部）工作的员工的姓名，假定不知道销售部的部门编号。 
9．列出薪金高于公司平均薪金的所有员工。 
10．列出与“SCOTT”从事相同工作的所有员工。 
11．列出薪金等于部门30中员工的薪金的所有员工的姓名和薪金。 
12．列出薪金高于在部门30工作的所有员工的薪金的员工姓名和薪金。 
13．列出在每个部门工作的员工数量、平均工资和平均服务期限。 
14．列出所有员工的姓名、部门名称和工资。 
15．列出所有部门的详细信息和部门人数。 
16．列出各种工作的最低工资。 
17．列出各个部门的MANAGER（经理）的最低薪金。 
18．列出所有员工的年工资,按年薪从低到高排序。
19.列出经理人的名字.
20.不用组函数,求出薪水的最大值
*/


--解答：

--1．列出至少有一个员工的所有部门。(两个表联合查询，及group by...having的用法)
select dname from dept where deptno in(select deptno from emp group by deptno having count(*)>1);

--2．列出薪金比“SMITH”多的所有员工。(经典的自连接查询)
select ename from emp where sal>(select sal from emp where ename like'SMITH');

--3．列出所有员工的姓名及其直接上级的姓名。(多次对自己查询,为表的取个别名，内部查询可以像对象一样引用外部的对象的字段，这里引用与编程中的作用域相似，即与{}类比)
--方法一:
select ename,(select ename from emp where empno in(a.mgr)) from emp a ;
--方法二:
select e1.ename ,e2.ename from emp e1 left join emp e2 on e1.mgr=e2.empno;

--4．列出受雇日期早于其直接上级的所有员工。(同上,日期可直接拿来比较)
select ename from emp a where HIREDATE<(select HIREDATE from emp where empno in(a.mgr));
SQL> select e1.ename emp,e1.hiredate ,e2.ename mgr,e2.hiredate from emp e1 join emp e2 on e1.mgr=e2.empno and e1.hiredate < e2.hiredate;

EMP        HIREDATE    MGR        HIREDATE
---------- ----------- ---------- -----------
SMITH      1980-12-17 FORD       1981-12-3
ALLEN      1981-2-20   BLAKE      1981-5-1
WARD       1981-2-22   BLAKE      1981-5-1
JONES      1981-4-2    KING       1981-11-17
BLAKE      1981-5-1    KING       1981-11-17
CLARK      1981-6-9    KING       1981-11-17

6 rows selected

--5．列出部门名称和这些部门的员工信息，同时列出那些没有员工的部门(以emp表为主，左连接查询)
select dname,emp.* from dept left join emp on dept.deptno=emp.deptno;

--6．列出所有“CLERK”（办事员）的姓名及其部门名称。(域，注意())
select ename,(select dname from dept where deptno in(a.deptno)) as dname from emp a where JOB like'CLERK';
select e.ename,d.dname,d.loc from emp e join dept d on e.deptno=d.deptno and e.job like 'CLERK';

--7．列出最低薪金大于1500的各种工作。
select job from emp where sal>1500;

--8．列出在部门“SALES”（销售部）工作的员工的姓名，假定不知道销售部的部门编号。(经典的两个表连接)
select ename from emp where deptno=(select deptno from dept where dname like'SALES');

--9．列出薪金高于公司平均薪金的所有员工。(反复查自己)
select ename from emp where sal>( select avg( sal) from emp);

--10．列出与“SCOTT”从事相同工作的所有员工。(排除自己)
select ename from emp where job in(select job from emp where ename like'SCOTT') and ename!='SCOTT' ;

--11．列出薪金等于部门30中员工的薪金的所有员工的姓名和薪金。(any的用法，且排挤)
select ename,sal from emp where sal=any(select sal from emp where deptno=30) and deptno!=30;
select ename,sal from emp where sal in(select sal from emp where deptno=30) and deptno!=30;

--12．列出薪金高于在部门30工作的所有员工的薪金的员工姓名和薪金。(max的用法)
select sal,ename from emp where sal>(select max(sal) from emp where deptno=30);

--13．列出在每个(每个是关键字,对此group by)部门工作的员工数量、平均工资和平均服务期限。(经典的group by用法)
**select deptno,count(*),avg(a.sal),avg(sysdate-HIREDATE) from emp a group by deptno;
select deptno,count(*),avg(a.sal),avg(to_number(to_char(sysdate,'yyyy'),'9999')-to_number(to_char(HIREDATE,'yyyy'),'9999')) from emp a group by deptno;

--14．列出所有员工的姓名、部门名称和工资.(经典的两个表的连接查询，用具体的名称替换一个表中的主键的id (解决很多人在实际运用中会遇到的不能绑定多列的问题)，也可用where来查询 ,与题5比较)
select ename,sal,(select dname from dept a where a.deptno=b.deptno)as dname from emp b;
select ename,dname,sal from emp join dept on emp.deptno=dept.deptno;

--15．列出所有部门的详细信息和部门人数。(因为是*，将显示dept和后面临时表b的全部字段(注意:不只是dept的字段,注意*号))
select * from dept a left join (select deptno,count(*) from emp group by deptno) b on a.deptno=b.deptno ;
select d.*,c from (select * from dept)d left join (select count(*) c ,deptno from emp group by deptno) e on e.deptno=d.deptno;

--16．列出各种(与每个同义(参看题13))工作的最低工资。
select job,min(sal) from emp group by job ;

--17．列出各个部门的MANAGER（经理,经理唯一，不用group by）的最低薪金。
select min(sal) from emp where job like'MANAGER';
--(因为MANAGER是值不是字段，所以不能用小写)

--18．列出所有员工的年工资,按年薪从低到高排序。(nvl:空转化函数)
SQL> select ename,sal*12+nvl(comm,0) anuual_sal from emp order by anuual_sal asc;

ENAME      ANUUAL_SAL
---------- ----------
SMITH           19200
JAMES           22800
ADAMS           26400
CLARK           29424
WARD            30500
MILLER          31236
MARTIN          31400
BLAKE           34200
JONES           35700
TURNER          36000
SCOTT           36000
FORD            36000
ALLEN           38700
KING            60024

--19,列出经理人的名字(雇员的empno出现在mgr列中的是经理人)
SQL> select ename from emp where empno in(select distinct mgr from emp);

ENAME
----------
JONES
BLAKE
CLARK
SCOTT
KING
FORD

6 rows selected

--20.不用组函数,求出薪水的最大值
SQL> select ename,sal from emp where sal not in(select distinct e1.sal from emp e1 join emp e2 on e1.sal<e2.sal);
