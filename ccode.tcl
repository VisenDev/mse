
namespace eval cgen {
    set indent-level 0
    set indent-paused 0
    proc indent {} {
        incr ::cgen::indent-level
    }
    proc unindent {} {
        incr ::cgen::indent-level -1
    }
    proc indentation {} {
        if {${::cgen::indent-paused} == 0} {
            for {set i 0} {$i < ${::cgen::indent-level}} {incr i} {
                puts -nonewline "    "
            }
        }
    }
    proc out {str} {
        indentation
        puts -nonewline $str
    }
    proc pause-indent {} {
        set ::cgen::indent-paused 1
    }
    proc unpause-indent {} {
        set ::cgen::indent-paused 0
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
        cgen::out "while ($condition) {\n" 
        block $body
        cgen::out "}\n"
    }

    proc include {file} {
        cgen::out "#include $file\n\n"
    }

    proc fn-args {fn-args} {
        set arglist [split ${fn-args} ","]
        set comma 0
        cgen::pause-indent
        cgen::out "("
        foreach arg $arglist {
            ::if {$comma == 1} {
                cgen::out ", "
            }
            set comma 1
            eval $arg
        }
        cgen::out ")"
        cgen::unpause-indent
    }

    proc fn {ret name args body} {
        uplevel 0 "proc $name {args} {cgen::out \"$name\(\$args\);\\n\"}"
        cgen::out "$ret $name"
        fn-args $args
        ::if {$body == {}} {
            cgen::out ";\n"
        } else {
            cgen::out "{\n"
            block $body
            cgen::out "}\n"
        }
    }

    proc def-type {typename} {
        set template {
            proc T {name args} {
                # initialization operation
                ::if {[lindex $args 0] == "="} {

                    cgen::out "T $name ${args};\n"
                
                # function prototype/definition
                } elseif {[llength $args] != 0} {
                    cgen::out "\n"
                    fn T $name [lindex $args 0] [lindex $args 1]

                # parameter declaraction
                } else {
                    cgen::out "T $name"
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
    def-type size_t
    def-type short

    #proc int {name args} {
    #    ::if {[lindex $args 0] == "="} {
    #        cgen::out "int $name ${args};\n"
    #    } elseif {[llength $args] == 2} {
    #        cgen::out "\n"
    #        fn int $name [lindex $args 0] [lindex $args 1]
    #    } else {
    #        cgen::out "int $name"
    #    }
    #}

    proc defer {statement} {
        upvar defers defers
        stack::push defers $statement
    }

    proc block {body} {
        stack::make defers 

        cgen::indent
        uplevel 0 $body

        foreach deferred [lreverse $defers] {
            eval $deferred
        }

        cgen::unindent
    }

    proc if {condition body} {

        cgen::out "if("

        cgen::pause-indent
        cgen::out $condition
        cgen::out ") {\n"
        cgen::unpause-indent

        block $body
        cgen::out "}\n"
    }

    proc return {value} {
        cgen::out "return $value;\n"
    }

    proc printf {str} {
        cgen::out "printf(\"$str\");\n"
    }
}

# test code

namespace eval c {
    include <stdio.h>
    include <stdlib.h>

    void* malloc {size_t bytes}
    void free {void* mem}

    int sayhello {int times} {
        if {times < 0} {
            return 0
        }
        printf "hello"
        sayhello times - 1
        return 0
    }


    int main {int argc, char** argv} {
        int hi = 1
        printf "hey\\n"
        sayhello 5
        int* myvar = malloc(400)
        defer {free myvar}

        defer {
            while {hi < 10} {
                printf {hello-false\n}
                cgen::out "hi += 1;\n"
            }
        }
        defer {printf {final-hi\n}}

        block {
            defer {printf "deferred-hi\\n"}
            printf "world"
        }
    }
}
