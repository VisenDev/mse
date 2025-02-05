#!/usr/bin/env tclsh

set builddir ".build"
set cfile "$builddir/out.c"
set exe "$builddir/out"
set src ccode.tcl

file mkdir $builddir
set csrc [exec tclsh $src]
set fd [open $cfile "w"]
puts $fd $csrc
close $fd
exec cc $cfile -o $exe
puts [exec $exe]
