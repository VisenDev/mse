#!/usr/bin/wish

#option add *tearOff 0
toplevel .win
menu .win.menubar
.win configure -menu .win.menubar

set m .win.menubar
menu $m.file
menu $m.edit
$m add cascade -menu $m.file -label File
$m add cascade -menu $m.edit -label Edit

$m.file add command -label "New" -command "newFile"	
$m.file add command -label "Open..." -command "openFile"
$m.file add command -label "Close" -command "closeFile"

$m.file add command -label "New" -command "newFile"	
$m.file add command -label "Open..." -command "openFile"
$m.file add command -label "Close" -command "closeFile"
