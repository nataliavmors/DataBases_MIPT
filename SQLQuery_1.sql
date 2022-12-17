/* 
задание1
*/
/* 
номер 2
*/
SELECT 
    fullname, salesRub, sales, companyName, itemName
FROM 
    distributor.singleSales 
WHERE 
    branchName='Москва' AND dateId BETWEEN '2014-03-01' AND '2014-03-31'

/* 
номер 3
*/
SELECT 
    MIN(salesRub) as min_sales_Rub, 
    MAX(salesRub) as max_sales_Rub, 
    MIN(sales) as min_sales, 
    MAX(sales) as max_sales
FROM distributor.singleSales

/* 
номер 4
*/
SELECT
    fullname
FROM
    distributor.singleSales
WHERE
    branchName='Москва'
AND
    sales=(SELECT MAX(sales) as SALES FROM distributor.singleSales WHERE MONTH(dateId)=1)

/* 
номер 5
*/
SELECT
    COUNT(DISTINCT checkId) as 'количество чеков' 
FROM 
    distributor.sales
GO

/* 
номер 6
*/
WITH 
    RESULT(Summ,checkId) AS (SELECT SUM(salesRub) as Summ, checkId as checkId FROM distributor.sales GROUP BY checkId) 
SELECT 
    COUNT(DISTINCT checkId) as 'кол-во уникальных чеков с суммой продажи > 10т.р.' 
FROM   
    RESULT 
WHERE 
    Summ>=10000

/* 
номер 7 
*/
WITH   
    RESULT(checkId,Num) AS (SELECT checkId, COUNT(DISTINCT itemId) as Num FROM distributor.sales GROUP BY checkId)
SELECT 
    TOP (1)*
FROM 
    RESULT
ORDER BY
    Num DESC

/* 
номер 8
*/
SELECT
    *
FROM
    distributor.singleSales
WHERE
    branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31'
ORDER BY
    salesRub DESC
GO

/*
номер 9
*/
SElECT 
    * 
FROM
    distributor.singleSales
WHERE
    branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31' 
ORDER BY 
    sales DESC

/*
номер 10
*/
SElECT 
    * 
FROM
    distributor.singleSales
WHERE
    branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31' AND fullname IS NOT NULL
ORDER BY 
    fullname ASC

/*
номер 11
*/
SElECT 
    * 
FROM
    distributor.singleSales
WHERE
    branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31' AND fullname IS NOT NULL
ORDER BY 
    fullname ASC, salesRub DESC

/*
номер 12
*/
SELECT 
    TOP (1)*
FROM 
    distributor.singleSales
WHERE 
    salesRub=(SELECT MAX(salesRub) FROM distributor.singleSales WHERE branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31') 

/*
номер 13 (не уверена что от меня этого хотели)
*/
SELECT 
    checkId, salesRub
FROM 
    distributor.singleSales
WHERE 
    salesRub=(SELECT MAX(salesRub) FROM distributor.singleSales WHERE branchName = 'Екатеринбург' AND dateId BETWEEN '2014-01-01' AND '2014-01-31') 

/*
номер 14
*/
SELECT
    checkId AS 'Номер чека',
    itemId AS 'Артикул товара',
    dateId AS 'Дата',
    sales AS 'Продажи',
    salesRub AS 'Продажи в рублях',
    branchName AS 'Город',
    region AS 'Регион',
    sizeBranch AS 'Размер склада',
    fullname AS 'Менеджер',
    companyName AS 'Компания',
    itemName AS 'Наименование товара',
    brand AS 'Брэнд',
    category AS 'Категория'


FROM
    distributor.singleSales
WHERE 
   branchName = 'Екатеринбург' AND dateId BETWEEN '2014-01-01' AND '2014-01-31' 

/*
номер 15
*/
SELECT 
    COUNT(DISTINCT fullname) AS 'Количество менеджеров'
FROM
    distributor.singleSales
WHERE
    branchName = 'Екатеринбург' AND dateId BETWEEN '2014-01-01' AND '2014-01-31'

/*
номер 16
*/
SELECT 
    COUNT(DISTINCT companyName ) AS 'Количество клиентов'
FROM
    distributor.singleSales
WHERE
    branchName = 'Екатеринбург' AND dateId BETWEEN '2014-01-01' AND '2014-01-31'

/*
номер 17
*/
SELECT 
    fullname AS 'Менеджер', COUNT(DISTINCT companyName ) AS 'Количество клиентов'
FROM
    distributor.singleSales
WHERE
    branchName = 'Екатеринбург' AND dateId BETWEEN '2014-01-01' AND '2014-01-31'
GROUP BY 
    fullname
GO

/*
номер 18
*/
SELECT 
    branchName AS 'Город',
    COUNT(DISTINCT companyName)/COUNT(DISTINCT fullname) as 'Среднее количество клиентов на менеджера филиала'
FROM 
    distributor.singleSales
GROUP BY 
    branchName
ORDER BY
    branchName ASC

/*
номер 19
*/
SELECT 
    branchName AS 'Город',
    COUNT(DISTINCT companyName ) as 'Было обслужено клиентов'
FROM 
    distributor.singleSales
WHERE dateId BETWEEN '2014-01-01' AND '2014-01-31'
GROUP BY 
    branchName
ORDER BY
   COUNT(DISTINCT companyName )  DESC

/*
номер 20
*/
WITH 
    mngrs(checks, branch, manager) AS (SELECT COUNT(checkId),branchName,fullname FROM distributor.singleSales GROUP BY branchName, fullname )
SELECT
    branch AS 'Город',
    manager AS 'Менеджер',
    checks AS 'Количество сделок'
FROM
    mngrs
WHERE
    checks IN (SELECT MAX(checks) FROM mngrs GROUP BY branch)
ORDER BY
    checks DESC

/*
номер 21
*/
WITH 
    mngrs(sales, branch, manager) AS (
    SELECT SUM(salesRub),branchName,fullname 
    FROM distributor.singleSales 
    WHERE dateId BETWEEN '2014-05-01' AND '2014-05-31'  
    GROUP BY branchName, fullname 
    )
SELECT
    branch AS 'Город',
    manager AS 'Менеджер',
    ROUND(sales,0) AS 'Максимальная выручка'
FROM
    mngrs
WHERE
    sales IN (SELECT MAX(sales) FROM mngrs GROUP BY branch)
ORDER BY
    sales DESC

/*
номер 22
*/
WITH 
    mngr(sales, check_, manager) AS (
    SELECT SUM(salesRub), checkId, fullname 
    FROM distributor.singleSales   
    GROUP BY checkId, fullname 
    )
SELECT
    manager AS 'Менеджер',
    AVG(sales) AS 'Cредний чек'
FROM
    mngr
GROUP BY
    manager
ORDER BY
    manager

/*
номер 23
*/
WITH 
    mngr(sales, check_,branch) AS (
    SELECT SUM(salesRub), checkId, branchName
    FROM distributor.singleSales   
    GROUP BY checkId, branchName
    )
SELECT
    branch AS 'Город',
    AVG(sales) AS 'Cредний чек'
FROM
    mngr
GROUP BY
    branch
ORDER BY
    branch
/*
ИЛИ ?? (результаты несколько отличаются)
*/

SELECT
    branchName,
    avg(salesRub)
FROM
    distributor.sales
INNER JOIN
    distributor.branch
    ON (branch.branchId = sales.branchId)
GROUP BY
    branch.branchId,
    branchName
ORDER BY
    branchName

/*
номер 24
*/
WITH 
    mngr_branch(sales, manager,branch) AS (
    SELECT SUM(salesRub), fullname, branchName
    FROM distributor.singleSales   
    GROUP BY fullname, branchName
    )
SELECT
    branch AS 'Филиал',
    manager AS 'Менеджер',
    avg(sales) AS 'Средний чек'
FROM 
    mngr_branch
WHERE manager IS NOT NULL AND branch IS NOT NULL
GROUP BY
    branch, manager
ORDER BY
    branch, avg(sales) DESC

/*
номер 25
*/
SELECT
    companyName
FROM
    distributor.company
WHERE
    companyName LIKE 'ОOО %'

/*
номер 26 (?)
*/
SELECT 
    temp1.companyName AS 'Название компании',
    AVG(temp2.salesRub) AS 'Средний размер чека'
FROM
   distributor.company temp1
INNER JOIN 
    distributor.sales temp2
ON 
    temp1.companyId=temp2.companyId
WHERE
    temp1.companyName LIKE '%ак'
GROUP BY
    temp1.companyName
GO


/*
номер 28
*/
SELECT  
    comp_item.company AS 'Компания',
    AVG(item) AS 'Cреднее кол-во артикулов в чеке'
FROM 
    (SELECT COUNT(itemId) as item, 
            checkId,
            companyName as company
     FROM distributor.singleSales 
     WHERE branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31' AND companyName IS NOT NULL
     GROUP BY checkId,companyName ) as comp_item
GROUP BY 
    comp_item.company 
ORDER BY
    comp_item.company 

/*
номер 29
*/
SELECT  
    mngr_item.manager AS 'Менеджер',
    AVG(item) AS 'Cреднее кол-во артикулов в чеке'
FROM 
    (SELECT COUNT(itemId) as item, 
            checkId,
            fullname as manager
     FROM distributor.singleSales 
     WHERE branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31' AND fullname IS NOT NULL
     GROUP BY checkId,fullname ) as mngr_item
GROUP BY 
    mngr_item.manager
ORDER BY
    mngr_item.manager

/*
номер 30
*/
SELECT  
    mngr_sum.manager AS 'Менеджер',
    ROUND(mngr_sum.sales,0) AS 'Продали на сумму'
FROM 
    (SELECT SUM(salesRub) as sales, 
            fullname as manager
     FROM distributor.singleSales 
     WHERE branchName = 'Москва' AND dateId BETWEEN '2014-05-01' AND '2014-05-31' AND fullname IS NOT NULL
     GROUP BY fullname ) as mngr_sum
WHERE 
    ROUND(mngr_sum.sales,0)>2000000
GROUP BY 
    mngr_sum.manager, mngr_sum.sales
ORDER BY
    mngr_sum.manager

/*
номер 35 ???
*/
SELECT 
    temp1.companyName AS 'Название компании',
    temp2.av_tr AS 'Среднее по тразакции',
    AVG(temp2.ch) AS 'Среднее количество чеков'
FROM
   distributor.company temp1
INNER JOIN (
    SELECT  AVG(salesRub) as av_tr,
            COUNT(checkId) as ch,
            companyId as company
    FROM    distributor.sales
    GROUP BY companyId, checkId
            ) as temp2
ON 
    temp1.companyId=temp2.company
GROUP BY 
    temp1.companyName,
    temp2.av_tr
/*
все хуйня пошла по новой
*/
SELECT  company AS 'Название компании',
        AVG(B.checks) as 'Среднее количество чеков'
FROM (
    SELECT COUNT(A.ch) as checks
    FROM (
        SELECT AVG(salesRub) as 'Среднее по тразакции' ,
               companyName as company,
               checkId as ch
        FROM distributor.singleSales
        GROUP BY companyName,checkId
        ) as A
    ) as B

/*
итог -  пока не работает 35.
*/