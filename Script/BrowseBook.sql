--�ŧi
drop procedure if exists BrowseBook
go

create procedure BrowseBook
--�ʧ@
as begin
	select bname as '�ѦW',type as '����',price as '����',status as '���A',wname as '�Ҧb�ܮw',setdate as '�̷s�@���J�w���' from bookinfo
	left join inventory
		on bookinfo.bid=inventory.bid
	left join warehouse
		on inventory.wid=warehouse.wid
end