#!/usr/bin/wish


#menu $m.file
#menu $m.edit
#$m add cascade -menu $m.file -label File
#$m add cascade -menu $m.edit -label Edit

#$m.file add command -label "New" -command "newFile"	
#$m.file add command -label "Open..." -command "openFile"
#$m.file add command -label "Close" -command "closeFile"
#
#$m.file add command -label "New" -command "newFile"	
#$m.file add command -label "Open..." -command "openFile"
#$m.file add command -label "Close" -command "closeFile"
#wm title . "Gear Solver"

#frame .content -width 200 -height 200 -borderwidth 10
#frame .content2 -width 200 -height 200 -borderwidth 10
#
#label .content2.txt -text hello-from-frame-2
#pack .content2.txt
#
#set txt FooBarBipBap
#button .content.hi -textvar txt -command {set txt [list $txt [.content.min-gear get]]}
#grid .content.hi
#
#button .content.quit -text quit -command {exit} -foreground red
#pack .content.quit
#
    #menu .header
    #button .header.quit -text Quit -command {exit}
    #button .header.sayhi -text sayhi -command {puts hi}
#    .header post 100 100 



#frame .config

#label .config.min-label -text "Min spokes:"
#entry .config.min-gear
#label .config.max-label -text "Max spokes:"
#entry .config.max-gear
#grid .config.min-label .config.min-gear -padx 5 -pady 5
#grid .config.max-label .config.max-gear -padx 5 -pady 5


#grid .config


#bind .config <KeyRelease> {puts "hi"}

#puts [.max.entry get]




proc integerEntryHighlighting {name min max} {
    set num [$name get]
    if {[string is integer $num] && [expr {$num >= $min && $num <= $max}]} {
        $name configure -fg black
    } else {
        $name configure -fg red 
    }
}

proc integerEntry {name label {default 100} {min 0} {max 255}} {
    frame $name

    label $name.label -text $label
    entry $name.entry -validate all -validatecommand {regexp {^[-+.0-9]*$} %P}
    $name.entry insert 0 $default
    grid $name.label $name.entry -padx 5 -pady 5
    bind $name.entry <KeyRelease> "integerEntryHighlighting $name.entry $min $max" 

    grid $name
}

proc main {} {
    wm title . "Gear Solver"

    menu .menubar
    .menubar add command -label Quit -command {exit}
    . configure -menu .menubar

    integerEntry .max "Max Spokes" 60
    integerEntry .min "Min Spokes" 20
}

main

