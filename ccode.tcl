proc out {str} {
    puts -nonewline $str
}

proc c-include {file} {
    puts "#include $file"
}

proc c-uint {name} {
    out "unsigned int"
}
proc c-int {name} 
    out "int"
}
proc c-bool {name} {
    out "int"
}
proc c-float {name} {
    out "float"
}

proc c-decl {args} {
}

proc c-body {args} {
    foreach arg $args {
        puts $arg
    }
}

proc c-fn {ret name arguments body} {
    puts -nonewline "$ret $name ("
    set comma 0
    foreach arg $arguments {
        if {$comma == 1} {
            puts -nonewline ", "
        }
        set comma 1
        puts -nonewline $arg
    }
    puts ") {"
    eval c-body $body
    puts "}"
}

proc c-main {args} {
    c-include <stdio.h>
    c-include <stdlib.h>
    puts ""
    puts "int main(void) {"
    foreach arg $args {
        puts -nonewline "    "
        eval $arg
    }
    puts "    return 0;"
    puts "}"
}

proc c-print {str} {
    puts "printf(\"%s\", \"$str\");"
}

c-fn int test {{int a} {char b} {bool c}} {
    hi
}

c-main {
    c-print "hello"
}
