
namespace eval cgen {
    set indent-level 0
    proc indent {} {
        incr cgen::indent-level
    }

    proc unindent {} {
        incr cgen::indent-level -1
    }
    proc indentation {} {
        for {set i 0} {$i < ${cgen::indent-level}} {incr i} {
            puts -nonewline "    "
        }
    }
    proc out {str} {
        puts -nonewline $str
    }
    proc iout {str} {
        indentation
        out $str
    }
}

namespace eval stack {
    proc make {stk} {
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
}

# unknown
#proc unknown {cmd args} {
#    c-fncall $cmd {*}$args
#}


# c constructs
namespace eval c {
    proc fncall {name args} {
        cgen::out "${name}("
        set comma 0
        foreach arg $args {
            ::if {$comma == 1} {
               cgen::out ", "
            }
            set comma 1
            cgen::out $arg
        }
        cgen::out ");\n"
    }

    proc indent-fncall {name args} {
        cgen::indentation
        fncall $name {*}$args

    } 

    proc while {condition body} {
        cgen::indentation
        cgen::out "while ($condition)" 
        block $body
    }

    proc include {file} {
        cgen::out "#include $file\n\n"
    }

    proc fn-args {fn-args} {
        set arglist [split ${fn-args} ","]
        set comma 0
        cgen::out "("
        foreach arg $arglist {
            ::if {$comma == 1} {
                cgen::out ", "
            }
            set comma 1
            eval $arg
        }
        cgen::out ")"
    }

    proc fn {ret name args body} {
        uplevel 0 "proc $name {args} {cgen::out \"$name\(\$args\);\\n\"}"
        cgen::out "$ret $name"
        fn-args $args
        block $body
    }

    proc def-type {typename} {
        set template {
            proc T {name args} {
                ::if {[lindex $args 0] == "="} {
                    cgen::iout "T $name ${args};\n"
                } elseif {[llength $args] == 2} {
                    cgen::out "\n"
                    fn T $name [lindex $args 0] [lindex $args 1]
                } else {
                    cgen::iout "T $name"
                }
            }
        }
        uplevel 0 [string map "T $typename" $template]
        uplevel 0 [string map "T $typename*" $template]
        uplevel 0 [string map "T $typename**" $template]
        uplevel 0 [string map "T $typename***" $template]
        uplevel 0 [string map "T $typename****" $template]
    }

    def-type int
    def-type char 
    def-type void 
    def-type float
    def-type long
    def-type short

    #proc int {name args} {
    #    ::if {[lindex $args 0] == "="} {
    #        cgen::iout "int $name ${args};\n"
    #    } elseif {[llength $args] == 2} {
    #        cgen::out "\n"
    #        fn int $name [lindex $args 0] [lindex $args 1]
    #    } else {
    #        cgen::iout "int $name"
    #    }
    #}

    proc defer {statement} {
        upvar defers defers
        stack::push defers $statement
    }

    proc block {body} {
        stack::make defers 

        cgen::out "{\n"
        cgen::indent
        uplevel 0 $body

        foreach deferred $defers {
            eval $deferred
        }

        cgen::unindent
        cgen::indentation
        cgen::out "}\n"
    }

    proc if {condition body} {
        cgen::iout "if("
        cgen::out $condition
        cgen::out ")"
        block $body
    }

    proc return {value} {
        cgen::iout "return $value;\n"
    }

    proc printf {str} {
        cgen::iout "printf(\"$str\");\n"
    }
}

# test code

namespace eval c {
    include <stdio.h>
    include <stdlib.h>

    int sayhello {int times} {
        if {times < 0} {
            return 0
        }
        printf "hello"
        cgen::indentation
        sayhello times - 1
        return 0
    }


    int main {int argc, char** argv} {
        int hi = 1
        printf "hey\\n"
        cgen::indentation
        sayhello 5

        while {0} {
            printf {hello-false\n}
        }
        defer {printf {final-hi\n}}

        cgen::indentation
        block {
            defer {printf "deferred-hi\\n"}
            printf "world"
        }
    }
}
