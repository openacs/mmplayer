ad_library {

    Utility functions for MMPlayer Application
    
}

namespace eval mmplayer {}

ad_proc mmplayer_get_package_id {
    -community_id
} {
   Get the mmplayer package in the selected community 

    @param community_id
} {

    if {[info exist community_id] == 0} {
        set community_id [dotlrn_community::get_community_id]
    }
    db_1row get_mmplayer_package_id {}

    return $package_id
}

ad_proc -private mmplayer::now_plus_days { -ndays } {
} {
    set now [list]
    foreach v [clock format [clock seconds] -format "%Y %m %d %H %M %S"] {
      lappend now [template::util::leadingTrim $v]
    }

    set day [lindex $now 2]
    set month [lindex $now 1]
    set interval_def [template::util::date::defaultInterval day]
    for { set i [lindex $interval_def 0] }  { $i <= 15 }  { incr i 1 } {
      incr day
      if { [expr $day + $i] >= [lindex $interval_def 1] } {
      incr month 1
      set day 1
      }
}

    # replace the hour and minute values in the now list with new values
    set now [lreplace $now 2 2 $day]
    set now [lreplace $now 1 1 $month]

    # set default time
    set now [lreplace $now 3 3 23]
    set now [lreplace $now 4 4 59]
    set now [lreplace $now 5 5 59]

    return [eval template::util::date::create $now]
}



