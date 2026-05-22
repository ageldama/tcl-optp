# tcl-optp


## Requirements

Tcl 9.0


## Features

* Easy commandline option specification
* Supports boolean flags, single/multiple arguments


## Installation

Just copy/link `optp-1.0.tm` file into your [`$TCL9_0_TM_PATH`](https://www.tcl-lang.org/man/tcl9.0/TclCmd/tm.html).



## Synopsis

```tcl
variable OPT_LIST \
    [list \
         "-s" [list type flag desc "Save Selection" default 0] \
         "-p" [list type flag desc "Print Selection" default 0] \
         "-S" [list type arg1 desc "SCRIPT DIRS (':'-separated)" default $SCRIPT_DIRS] \
         "-D" [list type arg1 desc "DB FILE" default $DB_FILE] \
         "-T" [list type arg1 desc "XTERM CMD" default $XTERM_CMD] \
         "-f" [list type argn desc "Additional Config Files" default {}] \
         "-P" [list type flag desc "Dump history/freqs and exit" default 0] \
         "-h" [list type flag alts [list "-help" "-?" "--help" "--?"] default {Show Usage/Help} default 0] \
        ]


package require optp

set optp [::optp::Parser new \
              argv0 $argv0 argv $argv \
              options $::options::OPT_LIST]

$optp parse
if {[$optp get -h]} {
    $optp show_usage
    exit -1
}
```
