
set user_id [ad_conn user_id]
db_multirow communities select_communities { *SQL* } 

