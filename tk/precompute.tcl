proc main {} {
    set min 8
    set max [expr {256 * 256}]
    array set db {}

    for {set i $min} {$i < $max} {incr i} {
        for {set j $min} {$j < $max} {incr j} {
            if {[array get db $i$j] == ""} {
                array set db {$i$j [expr {double($i) / $j}]}
            } else {
                puts "$i $j already computed"
            }
            puts "$i / $j = [array get db $i$j]"
        }
    }
}

main

