

set compiler [dict create \
    primitives [dict create \ int        [dict create value "int"          size 4 default "0"] \
        uint       [dict create value "unsigned int" size 4 default "0"] \
        bool       [dict create value "int"          size 4 default "0"] \
        float      [dict create value "float"        size 4 default "0"] \
        string     [dict create value "char *"       size 4 default {""}] \
    ] \
    defs [dict create] \
]
    

#puts $compiler


proc def {name args} {
    global compiler
    if {[dict exists $compiler defs $name] != 0} {
        error "$name is a constant and has already been defined"
    }
    dict set compiler defs $name $args
}

def asdf:int = 1
def hello:int = 1
def yaya:float = 1.0
def bip:bool = true
def world:void times:int = {
    print "hello"
    print times
}

puts $compiler

