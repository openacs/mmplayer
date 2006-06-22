
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

set URL_PLAYER_FLV "/media/player_flv.swf"
set URL_PLAYER_MP3 "/media/dewplayer.swf"
set URL_LOGO "/media/uvlogo2.jpg"
set apptype ""

if {[exists_and_not_null community_id]} {
  set res [db_0or1row do_select { select *,
                                    (select to_date(begin_date,'YYYY-MM-DD HH24:MI:SS') from dual) as bd, 
                                    (select to_date(end_date,'YYYY-MM-DD HH24:MI:SS') from dual) as ed
                                  from mmplayer_items 
                                  where community_id = :community_id
                                        and begin_date <= now ()
                                        and end_date >= now ()}]
  if {$res == 1} {
    set ext [string toupper [file extension $url]]
    if {[string first "http://www.youtube.com/" $url] == 0} {
      #http://www.youtube.com/v/cN7SNjVCOG4
      set ext ".YOUTUBE"
    } elseif {[string first "http://video.google.com/" $url] == 0} {
      #http://video.google.com/
      set ext ".GOOGLE"
    } elseif {[string first "mms://" $url] == 0} {
      #mms://147.156.41.66/IN-bib_regla-eng
      set ext ".MMS"
    }    

    if {$enabled_p eq "t"} {
      switch -glob $ext {      
        ".FLV" {
           set apptype "application/x-shockwave-flash"
           set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                     <OBJECT type=\"$apptype\" data=\"$URL_PLAYER_FLV\" width=\"$width\" height=\"$height\">
                       <PARAM name=\"movie\" value=\"$URL_PLAYER_FLV\" />
                       <PARAM name=\"FlashVars\" 
                              value=\"flv=$url&amp;width=$width&amp;height=$height&amp;startimage=$URL_LOGO&amp;margin=0&amp;showtime=1&amp;bgcolor=ff0000&amp;playercolor=ff0000&amp;loadingcolor=ff0000\" />
                     </OBJECT>
                     <BR>$comment</CENTER>"
        }                                   
        ".RM" {
          set apptype "audio/x-pn-realaudio-plugin"
          set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                      <OBJECT id=\"realplayer\" classid=\"clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA\" width=\"$width\" height=\"$height\">
                        <PARAM name=\"src\" value=\"$url\" />
                        <PARAM name=\"autostart\" value=\"false\" />
                        <PARAM name=\"controls\" value=\"imagewindow,controlpanel\" />
                        <EMBED src=\"$url\" width=\"$width\" height=\"$height\" autostart=\"false\" controls=\"imagewindow,controlpanel\" 
                               type=\"$apptype\">
                        </EMBED>
                      </OBJECT>
                      <BR>$comment</CENTER>"      
         }      
        ".AAC" -                              
        ".MOV" {
          set apptype ""
          set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                      <OBJECT classid=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\" width=\"$width\" height=\"$height\" codebase=\"http://www.apple.com/qtactivex/qtplugin.cab\">
                        <PARAM name=\"qtsrc\" value=\"$url\" />
                        <PARAM name=\"autoplay\" value=\"false\" />
                        <PARAM name=\"controller\" value=\"true\" />
                        <PARAM name=\"kioskmode\" value=\"true\" />
                        <PARAM name=\"qtsrcdontusebrowser\" value=\"true\" />
                        <PARAM name=\"src\" value=\"$url\" />
                        <EMBED src=\"$url\" width=\"$width\" height=\"$height\" autoplay=\"false\"></EMBED>
                      </OBJECT>
                      <BR>$comment</CENTER>"      
         }
        ".MMS" {
          set apptype "application/x-mplayer2"
          set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                      <OBJECT src=\"$url\" srctype=\"$apptype\" width=\"$width\" height=\"$height\">
                        <EMBED type=\"$apptype\" src=\"$url\" width=\"$width\" height=\"$height\" 
                               ShowControls=\"1\" ShowDisplay=\"0\" ShowStatusBar=\"0\" Name=\"MediaPlayer\"
                               pluginspage=\"http://www.microsoft.com/windows/windowsmedia/download/\">
                        </EMBED>
                      </OBJECT>
                      <BR>$comment</CENTER>"      
         }
        ".WMA" -
        ".WMV" {
            set apptype "application/x-oleobject"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                       <OBJECT id=\"winplayer\" classid=\"clsid:6BF52A52-394A-11d3-B153-00C04F79FAA6\" 
                               width=\"$width\" height=\"$height\" type=\"$apptype\">
                         <PARAM name=\"url\" value=\"$url\" />
                         <PARAM name=\"autostart\" value=\"-1\" />
                         <PARAM name=\"uiMode\" value=\"full\" />
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" autostart=\"-1\" uiMode=\"full\" 
                                type=\"$apptype\" pluginspage=\"http://www.microsoft.com/Windows/MediaPlayer/\">
                         </EMBED>
                       </OBJECT>
                       <BR>$comment</CENTER>"      
         }                                   
        ".MP3" {
            set apptype "application/x-shockwave-flash"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                       <OBJECT type=\"$apptype\" data=\"$URL_PLAYER_MP3?son=$url&autoplay=0\" width=\"$width\" height=\"$height\">
                         <PARAM name=\"movie\" value=\"$URL_PLAYER_MP3?son=$url&autoplay=0\" /> 
                       </OBJECT>
                       <BR>$comment</CENTER>"      
         }                                   
        ".AVI" {
            set apptype ""
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT classid=\"CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95\" width=\"$width\" height=\"$height\">
                         <PARAM name=\"filename\" value=\"$url\" />
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" autostart=\"false\">
                         </EMBED>
                       </OBJECT>
                       <BR>$comment</CENTER>"
         } 
        ".MPEG" - 
        ".MPG" {
            set apptype "video/mpeg"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT src=\"$url\" srctype=\"$apptype\" width=\"$width\" height=\"$height\">
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\"></EMBED>                       
                       </OBJECT>
                       <BR>$comment</CENTER>"
         }          
        ".PDF" {
            set apptype "application/pdf"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT src=\"$url\" srctype=\"$apptype\" width=\"$width\" height=\"$height\">
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" type=\"$apptype\"></EMBED>
                       </OBJECT>
                       <BR>$comment</CENTER>"
         }
        ".SWF" {
            set apptype "application/x-shockwave-flash"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT width=\"$width\" height=\"$height\">
                         <PARAM name=\"movie\" value=\"$url\" />
                         <PARAM name=\"play\" value=\"true\" />
                         <PARAM name=\"showcontrols\" value=\"1\" />
                         <PARAM name=\"quality\" value=\"high\" />
                         <PARAM name=\"menu\" value=\"true\" />
                         <PARAM name=\"wmode\" value=\"transparent\">
                         <PARAM name=\"pluginurl\" value=\"http://www.macromedia.com/go/getflashplayer\">
                         <EMBED src=\"$url\"
                                type=\"$apptype\"
                                play=\"true\"
                                quality=\"high\" 
                                menu=\"true\"
                                pluginspage=\"http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash\"
                                width=\"$width\" 
                                height=\"$height\">
                         </EMBED>
                       </OBJECT>
                       <BR>$comment</CENTER>"
         } 
        ".CLASS" {
            set apptype "application/x-java-applet"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT src=\"$url\" srctype=\"$apptype\">
                         <PARAM name=\"height\" value=\"$height\" valuetype=\"data\" />
                         <PARAM name=\"width\" value=\"$width\" valuetype=\"data\" />
                         This user agent cannot process a java applet.
                       </OBJECT>                             
                       <BR>$comment</CENTER>"
        }
        ".HTM" - 
        ".HTML" {
            set apptype "text/html"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                         <IFRAME src=\"$url\" width=\"$width\" height=\"$height\"></IFRAME>
                       <BR>$comment</CENTER>"
         }                  
        ".PNG" -
        ".GIF" -
        ".JPG" -
        ".JPEG" {
            set apptype "image/jpeg"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                         <IMG src=\"$url\" width=\"$width\" height=\"$height\">
                       <BR>$comment</CENTER>"      
        }
        ".RTF" -
        ".DOC" {
            set apptype "application/msword"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT DATA=\"$url\" TYPE=\"$apptype\"> 
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" TYPE=\"$apptype\"></EMBED>
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }                    
        ".PPT" -
        ".PPS" {
            set apptype "application/vnd.ms-powerpoint"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT classid=\"clsid:98de59a0-d175-11cd-a7bd-00006b827d94\" TYPE=\"$apptype\" width=\"$width\" height=\"$height\" data=\"$url\"> 
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" TYPE=\"$apptype\"></EMBED>
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }                  
        ".PS" -
        ".EPS" {
            set apptype "application/postscript"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT TYPE=\"$apptype\" width=\"$width\" height=\"$height\" data=\"$url\"> 
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" TYPE=\"$apptype\"></EMBED>
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }                           
        ".XLS" {
            set apptype "application/vnd.ms-excel"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT TYPE=\"$apptype\" width=\"$width\" height=\"$height\" data=\"$url\"> 
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" TYPE=\"$apptype\"></EMBED>
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }                           
        ".VRML" {
            set apptype "model/vrml"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT TYPE=\"$apptype\" width=\"$width\" height=\"$height\" data=\"$url\"> 
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" TYPE=\"$apptype\"></EMBED>
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }         
        ".YOUTUBE" {
            set apptype "application/x-shockwave-flash"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT width=\"$width\" height=\"$height\"> 
                         <PARAM name=\"movie\" value=\"$url\" />
                         <EMBED src=\"$url\" width=\"$width\" height=\"$height\" type=\"$apptype\"></EMBED>
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }                  
        ".GOOGLE" {
            set apptype "application/x-shockwave-flash"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>
                       <OBJECT width=\"$width\" height=\"$height\"> 
                         <PARAM name=\"movie\" value=\"$url\" />
                         <EMBED style=\"width:$width px; height:$height px;\"
                                id=\"VideoPlayback\" align=\"middle\"
                                type=\"$apptype\"
                                allowScriptAccess=\"sameDomain\" 
                                quality=\"best\" 
                                bgcolor=\"#ffffff\" 
                                scale=\"noScale\" 
                                wmode=\"window\" 
                                salign=\"TL\"  
                                FlashVars=\"playerMode=embedded\"                                 
                                src=\"$url\">
                       </OBJECT>  
                       <BR>$comment</CENTER>"
         }                           
      default {
            set apptype "image/jpeg"
            set xhtml "<CENTER><BR><B><U>$title</U></B><BR><BR>    
                         <BR>Invalid resource to display<BR>
                         <IMG src=\"$URL_LOGO\" width=\"$width\" height=\"$height\">
                       <BR>$comment</CENTER>"      
        }
      }
    } else {
      #MEDIA NOT ENABLED  
      set xhtml ""
    }
  } else {
     set xhtml "No media"     
  }    
} else {
  #WE MUST SHOW THE RESSUMEN OF ALL CLASSES HERE
  set xhtml "RESUMEN"
}




        
