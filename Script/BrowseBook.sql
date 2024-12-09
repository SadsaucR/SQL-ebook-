--�ŧi
drop procedure if exists BrowseBook
go

create procedure BrowseBook
--�ʧ@
as begin
	select 
			bookinfo.bid as '�ѥ�ID',
			bname as '�ѦW',
			type as '����',
			price as '����',
			status as '���A',
			wname as '�Ҧb�ܮw',
			quantity as '�w�s�q',
			setdate as '�̷s�@���J�w���' 	
from bookinfo
	left join inventory
		on bookinfo.bid=inventory.bid
	left join warehouse
		on inventory.wid=warehouse.wid
end