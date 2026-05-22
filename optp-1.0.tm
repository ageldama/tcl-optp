
namespace eval optp {
    namespace export Parser

    oo::class create Parser {
        variable argv0 [info script]
        variable argv  {}
        variable opt_list {}
        variable parsed {}
        variable output

        constructor {args} {
            my variable opt_list argv0 argv output
            set opt_list [dict getdef $args options {}]
            set argv0 [dict getdef $args argv0 [info script]]
            set argv [dict getdef $args argv {}]
            set output [dict getdef $args output stderr]
        }

        method fill_defaults {} {
            set results {}
            my variable opt_list
            dict for {oname opt} $opt_list {
                dict set results $oname [dict getdef $opt default ""]
            }

            my variable parsed
            set parsed $results
        }

        method parse {} {
            my fill_defaults

            my variable parsed
            my variable argv
            for {set idx 0} {$idx < [llength $argv]} {incr idx} {
                set curr [lindex $argv $idx]

                my variable opt_list
                dict for {oname opt} $opt_list {
                    set alts [dict getdef $opt alts {}]
                    set type [dict getdef $opt type flag]

                    if {[string equal $oname $curr] \
                            || [lsearch -exact $alts $curr] > -1} {
                        switch -- $type {
                            "flag" {
                                dict set parsed $oname 1
                            }

                            "arg1" {
                                incr idx
                                dict set parsed $oname [lindex $argv $idx]
                            }

                            "args" {
                                incr idx
                                dict lappend parsed $oname [lindex $argv $idx]
                            }

                            default {
                                error "Unsupported 'type'=${type}"
                            }
                        }
                    }
                }
            }
        }

        method get {key} {
            my variable parsed
            return [dict get $parsed {*}$key]
        }

        method dump {} {
            my variable parsed
            return $parsed
        }

        method show_usage {} {
            my variable argv0
            my variable opt_list
            my variable output
            puts $output "*** $argv0 ***\n"
            dict for {oname opt} $opt_list {
                switch -- [dict get $opt type] {
                    "arg1" {
                        puts -nonewline $output "<ARG1> ${oname}\n"
                    }

                    "args" {
                        puts -nonewline $output "<ARGS> ${oname}\n"
                    }

                    "flag" - default {
                        puts -nonewline $output "<FLAG> ${oname}\n"
                    }
                }

                if {[dict exists $opt alts]} {
                    puts -nonewline $output "\t(Aliases: [dict get $opt alts])\n"
                }

                if {[dict exists $opt default]} {
                    puts -nonewline $output "\t(Default: [dict get $opt default])\n"
                }

                if {[dict exists $opt desc]} {
                    puts -nonewline $output "\t[dict get $opt desc]\n"
                }

                puts $output "\n"
            }
        }
    }
}

package provide optp 1.0

# Local variables:
# mode: tcl
# End:
