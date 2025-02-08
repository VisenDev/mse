#!/usr/bin/wish

wm title . "Gear Solver"

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

frame .config

label .config.min-label -text "Min spokes:"
entry .config.min-gear
label .config.max-label -text "Max spokes:"
entry .config.max-gear
grid .config.min-label .config.min-gear -padx 5 -pady 5
grid .config.max-label .config.max-gear -padx 5 -pady 5

grid .config


bind .config <KeyRelease> [puts "hi"]
