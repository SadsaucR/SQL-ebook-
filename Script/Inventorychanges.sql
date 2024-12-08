DROP PROCEDURE IF EXISTS Inventorychanges;
GO

CREATE PROCEDURE Inventorychanges
    @bid INT,                        
    @cname NVARCHAR(50),             
    @transactionType NVARCHAR(50),   
    @tquantity INT,                  
    @remarks NVARCHAR(50)            
AS
BEGIN
    DECLARE @wid INT;           -- �ܮwID
    DECLARE @quantity INT;      -- ��e�w�s�q
    DECLARE @trade_id INT;      -- ���ID
    DECLARE @transactionDate DATETIME2(7) = GETDATE();
    -- �ھ� bid �d����y�O�_�s�b
    IF NOT EXISTS (SELECT 1 FROM bookinfo WHERE bid = @bid)
    BEGIN
        -- ���y���s�b�A��^���~�T��
        SELECT '�ѥ����s�b' AS status;
        RETURN;
    END

    -- �ھڮ��yID�d�߭ܮwID�M�w�s�q
    SELECT TOP 1 @wid = wid, @quantity = quantity 
    FROM inventory 
    WHERE bid = @bid;

    -- �P�_����ƶq�O�_�j��s
    IF @tquantity <= 0
    BEGIN
        SELECT '�U��ƶq���i���s' AS status;
        RETURN;
    END

    -- �p�G�w�s�����A�h��֮w�s�q
    IF @quantity >= @tquantity
    BEGIN
        -- ��s�w�s�A��֮w�s�q
        UPDATE inventory
        SET quantity = @quantity - @tquantity, setdate = GETDATE()
        WHERE bid = @bid AND wid = @wid;

        -- ��ʥͦ� trade_id
        SELECT @trade_id = ISNULL(MAX(trade_id), 0) + 1 FROM trade;

        -- ���J����O��
        INSERT INTO trade (trade_id, bid, cname, transactionType, tquantity, transactionDate, remarks)
        VALUES (@trade_id, @bid, @cname, @transactionType, @tquantity, @transactionDate, @remarks);

        -- ��ܮw�s��s���\
        SELECT '��������A�w�s�ƶq�w���' AS status;
    END
    ELSE
    BEGIN
        -- �w�s�����A�L�k�������
        SELECT '�w�s�����A�L�k�������' AS status;
    END
END    