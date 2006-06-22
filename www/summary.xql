<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_communities">
        <querytext>
            select dotlrn_communities_all.*,
                   dotlrn_community__url(dotlrn_communities_all.community_id) as url,
                   mmp.title as mmptitle,
                   mmp.comment as comment,
                   (select to_date(mmp.begin_date,'YYYY-MM-DD HH24:MI:SS') from dual) as bd,
                   (select to_date(mmp.end_date,'YYYY-MM-DD HH24:MI:SS') from dual) as ed
            from dotlrn_communities_all,
                 dotlrn_member_rels_approved,
                 mmplayer_items as mmp
            where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
                  and dotlrn_member_rels_approved.user_id = :user_id
                  and archived_p = 'f'
                  and mmp.community_id = dotlrn_communities_all.community_id
                  and mmp.enabled_p = 't'
                  and mmp.begin_date <= now () 
                  and mmp.end_date >= now ()
        </querytext>
    </fullquery>

</queryset>
