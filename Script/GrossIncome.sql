ALTER PROCEDURE [dbo].[GrossIncome]
AS
BEGIN
    
    SELECT 
        '年度' AS report_type, 
        Q AS '期間',
        SUM(CASE 
                WHEN MONTH(u.birthday) = MONTH(GETDATE()) THEN total * 0.8  -- 如果是當月生日，給 8 折
                ELSE total 
            END) AS '總金額'
    FROM (
        SELECT 
            DATEPART(YEAR, transactionDate) AS Q, 
            SUM(trade.tquantity * bookinfo.price) AS total,
            u.birthday
        FROM bookinfo
        JOIN trade ON bookinfo.bid = trade.bid
        JOIN userinfo u ON trade.cname = u.cname
        GROUP BY DATEPART(YEAR, transactionDate), u.birthday
    ) AS u
    GROUP BY Q

    UNION ALL 

    -- 計算季度收入
    SELECT 
        '季度' AS report_type, 
        Q AS '期間',
        SUM(CASE 
                WHEN MONTH(u.birthday) = MONTH(GETDATE()) THEN total * 0.8  -- 如果是當月生日，給 8 折
                ELSE total 
            END) AS '總金額'
    FROM (
        SELECT 
            DATEPART(QUARTER, transactionDate) AS Q, 
            SUM(trade.tquantity * bookinfo.price) AS total,
            u.birthday
        FROM bookinfo
        JOIN trade ON bookinfo.bid = trade.bid
        JOIN userinfo u ON trade.cname = u.cname
        WHERE DATEPART(YEAR, transactionDate) = 2024
        GROUP BY DATEPART(QUARTER, transactionDate), u.birthday
        UNION ALL
        SELECT 1, 0, NULL
        UNION ALL
        SELECT 2, 0, NULL
        UNION ALL
        SELECT 3, 0, NULL
        UNION ALL
        SELECT 4, 0, NULL
    ) AS u
    GROUP BY Q
    ORDER BY report_type,期間  -- 按照報表類型和期間排序
END


exec GrossIncome