package require http
package require tls
http::register https 443 [list ::tls::socket -tls1 1]   ;# "-tls1 1" is required since [POODLE]
http::config -useragent "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"
append texto_url "https://www.google.com/search?q=tiempo" [lindex $argv 0]

set s [http::geturl $texto_url]
set r [http::ncode $s]
if {$r eq 200} { 
 set d [http::data $s]
 puts $d            
}
