drop procedure if exists restock
go
create procedure restock
	@bid int,
	@q int   --�W�[���ƶq
as                                                                                                
begin
	update inventory set quantity = quantity + @q where bid = @bid
	update inventory set setdate = getdate() where bid = @bid
	
end