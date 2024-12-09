DROP PROCEDURE IF EXISTS Inventorychanges;
GO

CREATE PROCEDURE Inventorychanges
    @cname NVARCHAR(50),              -- �Ȥ�W��
    @transactionType NVARCHAR(50),     -- �������
    @remarks NVARCHAR(50),             -- �Ƶ�
    @bid INT,                          -- ���yID�]�浧��ơ^
    @tquantity INT                     -- ����ƶq�]�浧��ơ^
AS
BEGIN
    DECLARE @wid INT;                -- �ܮwID
    DECLARE @quantity INT;           -- ��e�w�s�q
    DECLARE @price MONEY;            -- ���y���
    DECLARE @total MONEY;            -- �p��᪺�`���B
    DECLARE @transactionDate DATETIME2(7) = GETDATE(); -- ������
    DECLARE @birthday_discount INT = 0;  -- �ͤ��u�f�аO�A0 ��ܨS���A1 ��ܦ�

    -- �ھ� bid �d����y�O�_�s�b
    IF NOT EXISTS (SELECT 1 FROM bookinfo WHERE bid = @bid)
    BEGIN
        -- ���y���s�b�A��^���~�T��
        SELECT '�ѥ����s�b�Abid=' + CAST(@bid AS NVARCHAR(50)) AS status;
        RETURN;
    END

    -- �ھڮ��yID�d�߭ܮwID�B�w�s�q�H�ή��y����
    SELECT TOP 1 @wid = wid, @quantity = quantity, @price = price
    FROM inventory
    JOIN bookinfo ON bookinfo.bid = inventory.bid
    WHERE inventory.bid = @bid;

    -- �P�_����ƶq�O�_�j��s
    IF @tquantity <= 0
    BEGIN
        SELECT '�U��ƶq���i���s�Abid=' + CAST(@bid AS NVARCHAR(50)) AS status;
        RETURN;
    END

    -- �P�_�O�_�����ͤ�
    IF EXISTS (SELECT 1 FROM userinfo WHERE cname = @cname AND MONTH(birthday) = MONTH(GETDATE()))
    BEGIN
        SET @birthday_discount = 1;  -- �p�G�O���ͤ�A�]�m�����ͤ��u�f
    END

    -- �p���`���B�A�ͤ��u�f8��
    SET @total = @price * @tquantity;
    IF @birthday_discount = 1
    BEGIN
        SET @total = @total * 0.8;  -- �ͤ��u�f�A�� 8 ��
    END

   
    IF @quantity >= @tquantity
    BEGIN
        -- ��s�w�s��֮w�s�q
        UPDATE inventory
        SET quantity = @quantity - @tquantity, setdate = GETDATE()
        WHERE bid = @bid AND wid = @wid;

        -- ��ʥͦ� trade_id
        DECLARE @trade_id INT;
        SELECT @trade_id = ISNULL(MAX(trade_id), 0) + 1 FROM trade;

        -- �p��᪺�`���B
        INSERT INTO trade (trade_id, bid, cname, transactionType, tquantity, transactionDate, remarks, total)
        VALUES (@trade_id, @bid, @cname, @transactionType, @tquantity, @transactionDate, @remarks, @total);

        -- ��ܥ�����A�A�]�A����B����ƶq�B�`���B�M�w�s
        SELECT 
            '��������Abid=' + CAST(@bid AS NVARCHAR(50)) + 
            ', tquantity=' + CAST(@tquantity AS NVARCHAR(50)) +
            ', ���=' + CAST(@price AS NVARCHAR(50)) +
            ', �`���B=' + CAST(@total AS NVARCHAR(50)) +
            ', �w�s�ƶq�� ' + CAST(quantity AS NVARCHAR(50)) AS status
        FROM inventory
        WHERE bid = @bid AND wid = @wid;

    END
    ELSE
    BEGIN
        -- �w�s�����A�L�k�������
        SELECT '�w�s�����Abid=' + CAST(@bid AS NVARCHAR(50)) AS status;
    END
END


EXEC Inventorychanges 
    @bid = 3,                       -- ���yID
    @cname = '�Ȥ�1',                -- �Ȥ�W��
    @transactionType = '�H�Υd',     -- �������
    @tquantity = 1,                  -- ����ƶq
    @remarks = '';                   -- �Ƶ��]�i��^



