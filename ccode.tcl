# utilities
set indent-level 0
proc indent {} {
    global indent-level
    incr indent-level
}

proc unindent {} {
    global indent-level
    incr indent-level -1
}
proc indentation {} {
    global indent-level
    for {set i 0} {$i < ${indent-level}} {incr i} {
        puts -nonewline "    "
    }
}
proc out {str} {
    puts -nonewline $str
}


proc stack {stk} {
    uplevel 1 "set $stk {}"
}

proc push {stk args} {
    uplevel 1 "lappend $stk $args"
}

proc pop {name} {
    upvar $name stk 
    set tmp [lindex $stk end]
    set stk [lreplace $stk end end]
    set tmp
}

# unknown
proc unknown {cmd args} {
    indentation
    c-fncall $cmd {*}$args
}


# c constructs
proc c-fncall {name args} {
    out "${name}("
    set comma 0
    foreach arg $args {
        if {$comma == 1} {
           out ", "
        }
        set comma 1
        puts -nonewline $arg
    }
    out ");\n"
}

proc c-include {file} {
    out "#include $file\n"
}

proc c-fn-args {fn-args} {
    set arglist [split ${fn-args} ","]
    set comma 0
    out "("
    foreach arg $arglist {
        if {$comma == 1} {
            out ", "
        }
        set comma 1
        eval $arg
    }
    out ")"
}

proc c-fn {ret name args body} {
    out "$ret $name"
    c-fn-args $args
    c-block $body

}

proc c-int {name args} {
    if {[lindex $args 0] == "="} {
        indentation
        out "int $name ${args};\n"
    } elseif {[llength $args] == 2} {
        indentation
        c-fn int $name [lindex $args 0] [lindex $args 1]
    } else {
        indentation
        out "int $name"
    }
}

proc c-defer {statement} {
    upvar defers defers
    push defers $statement
}

proc c-block {body} {
    stack defers 

    indentation
    out "{\n"
    indent
    uplevel 0 $body

    foreach deferred $defers {
        eval $deferred
    }

    unindent
    indentation
    out "}\n"
}

proc c-if {condition body} {
    out "if("
    out $condition
    out ")"
    c-block $body
}

proc c-return {value} {
    out "return $value;"
}

# test code

c-include <stdio.h>
c-include <stdlib.h>

c-int sayhello {c-int times} {
    c-if {times < 0} {
        c-return 0
    }
    printf {"hello"}
    sayhello {times - 1}
    c-return 0
}

c-int main {c-int a, c-int b} {
    c-int hi = 1
    printf {"hey\n"}
    sayhello 5

    c-defer {printf "\"final-hi\\n\""}

    c-block {
        c-defer {printf "\"deferred-hi\\n\""}
        printf "\"world\""
    }
}

