ad_page_contract {
} {
    {__new_p 0}
}

set title "#mmplayer-portlet.Manage_MMPlayer#"
set context [list $title]

set community_id [dotlrn_community::get_community_id]
set url ""
set xtitle ""
set comment ""
set enabled_p "t"
set dcommunity_id [db_string do_select "select community_id from mmplayer_items where community_id = :community_id" -default "-1"]
if {$dcommunity_id == -1} {
  db_dml do_insert "insert into mmplayer_items (url, title, comment, enabled_p, community_id) 
                    values (:url, :xtitle, :comment, :enabled_p, :community_id)"
}
               
ad_form -name select_item -form {
    {url:text,optional {label "#mmplayer.url#"} {html { size 50 maxlength 1000}}}
    {xtitle:text,optional {label "#mmplayer.title#"} {html { size 50 maxlength 200}}}    
    {comment:text,optional {label "#mmplayer.comment#"} {html { size 100 maxlength 500}}}
    {enabled_p:boolean(radio),optional {label "#mmplayer.enabled#"} {options {{Si t} {No f}}} {value "t"}}
    {width:integer,optional {label "#mmplayer.width#"} {html { size 5 maxlength 5}}}
    {height:integer,optional {label "#mmplayer.height#"} {html { size 5 maxlength 5}}}    
    {begin_date:date,to_sql(linear_date),from_sql(sql_date),optional
       {label "[_ mmplayer.begin_date]"}
       {format "MONTH DD YYYY HH24 MI SS"}
       {help}
       }
    {end_date:date,to_sql(linear_date),from_sql(sql_date),optional
       {label "[_ mmplayer.end_date]"}
       {format "MONTH DD YYYY HH24 MI SS"}
       {help}
       }       
    {submit:text(submit) {label "[_ mmplayer.ok]"}}
} -on_request {
    db_1row do_select { select * from mmplayer_items where community_id = :community_id }
    set begin_date [template::util::date::from_ansi $begin_date "YYYY-MM-DD HH24:MI:SS"]    
    set end_date [template::util::date::from_ansi $end_date "YYYY-MM-DD HH24:MI:SS"]        
} -edit_request {
    db_1row do_select { select * from mmplayer_items where community_id = :community_id }
    set begin_date [template::util::date::from_ansi $begin_date "YYYY-MM-DD HH24:MI:SS"]    
    set end_date [template::util::date::from_ansi $end_date "YYYY-MM-DD HH24:MI:SS"]        
} -new_data {
} -edit_data {
    db_dml do_update "update mmplayer_items 
                      set url= :url, title= :xtitle, comment= :comment, enabled_p= :enabled_p, width= :width, height= :height, 
                          begin_date= (select to_date(:begin_date,'YYYY-MM-DD HH24:MI:SS') from dual),
                          end_date= (select to_date(:end_date,'YYYY-MM-DD HH24:MI:SS') from dual)
                      where community_id = :community_id"
} -after_submit {
    ad_returnredirect "../../one-community-admin"
    ad_script_abort
}

        
