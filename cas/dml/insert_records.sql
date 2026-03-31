insert into cas.tclient_details (cli_num,pol_num,cli_nm,cli_id ) 
values ('000003', '8000000003', 'Testing C', '15000003');

insert into cas.tpolicys (pol_num,prem_amt,pmt_mode)
values ('8000000003', 236, 12);


-- update cas.tclient_details set cli_id = '15000001' where cli_num = '000001';
-- update cas.tclient_details set cli_id = '15000002' where cli_num = '000002';
