DROP PROCEDURE IF EXISTS ApplyBirthdayDiscount
GO

CREATE PROCEDURE ApplyBirthdayDiscount
    @cname NVARCHAR(50)          
AS
BEGIN
    DECLARE @price MONEY
    DECLARE @discounted_price MONEY
    DECLARE @book_name NVARCHAR(50)
    DECLARE @tquantity INT
    DECLARE @birthday_discount INT  -- �ͤ��u�f�аO
    DECLARE @password NVARCHAR(50)
    DECLARE @hashed_password VARBINARY(64)
    DECLARE @query_time DATETIME2(7)

    -- ����d�߮ɶ�
    SET @query_time = GETDATE()

    -- �d�ߥΤ᪺�ͤ����A�ýT�{�O�_�����
    IF EXISTS (SELECT 1 FROM userinfo WHERE cname = @cname AND MONTH(birthday) = MONTH(GETDATE()))
    BEGIN
        -- �]�w�ͤ��u�f�аO�� 1
        SET @birthday_discount = 1
    END
    ELSE
    BEGIN
        -- �]�w�ͤ��u�f�аO�� 0
        SET @birthday_discount = 0
    END

    -- �d�ߥΤ᪺�K�X�A�Y�K�X�� NULL �Ϊŭȫh�ϥ� cellphone �@���w�]�K�X
    SELECT @password = 
           CASE 
               WHEN password IS NULL OR password = '' THEN cellphone  -- ��K�X�� NULL �ΪšA�ϥ� cellphone �@���w�]�K�X
               ELSE password 
           END
    FROM userinfo
    WHERE cname = @cname

    -- �T�O�K�X�ܼƤ��� NULL�A�Y�� NULL �ΪšA�j��]�� cellphone
    IF @password IS NULL OR @password = ''
    BEGIN
        SET @password = (SELECT cellphone FROM userinfo WHERE cname = @cname)
    END

    -- �N�K�X�i�� hash �B�z
    SET @hashed_password = HASHBYTES('SHA2_512', CONVERT(VARBINARY(50), @password))

    -- ��s�Τ᪺�K�X��쬰���ƱK�X
    UPDATE userinfo
    SET password = CONVERT(VARCHAR(128), @hashed_password, 2) 
    WHERE cname = @cname

	ALTER TABLE userinfo
	DROP COLUMN cellphone;

    -- �d�߸ӫȤ�Ҧ����ʶR��ơA��ܨC��������Ӥ��`�M
    SELECT t.cname, 
           t.transactionDate, 
           b.bname AS book_name, 
           b.price AS unit_price,
           t.tquantity AS quantity, 
           b.price * t.tquantity AS total_price, 
           -- �p�G�O���ͤ�A�����馩
           CASE 
               WHEN MONTH(u.birthday) = MONTH(GETDATE()) THEN b.price * t.tquantity * 0.8 
               ELSE b.price * t.tquantity 
           END AS discounted_price,
           @query_time AS query_time,  -- �X�֬d�߮ɶ�
           @birthday_discount AS birthday_discount  -- ��ܥͤ��u�f�аO
    FROM trade t
    JOIN bookinfo b ON t.bid = b.bid
    JOIN userinfo u ON t.cname = u.cname
    WHERE t.cname = @cname
    ORDER BY t.transactionDate DESC  -- ��ܩҦ�����ë�����Ƨ�

    -- �p��ӫȤ᪺�`�ʶR�ƶq�B�`���B�M�`�馩���B
    SELECT t.cname, 
           SUM(t.tquantity) AS total_quantity, 
           SUM(b.price * t.tquantity) AS total_amount,
           SUM(CASE 
               WHEN MONTH(u.birthday) = MONTH(GETDATE()) THEN b.price * t.tquantity * 0.8 
               ELSE b.price * t.tquantity 
           END) AS total_discounted_amount,  
           @query_time AS query_time, 
           @birthday_discount AS birthday_discount 
    FROM trade t
    JOIN bookinfo b ON t.bid = b.bid
    JOIN userinfo u ON t.cname = u.cname
    WHERE t.cname = @cname
    GROUP BY t.cname
    ORDER BY t.cname  
END
