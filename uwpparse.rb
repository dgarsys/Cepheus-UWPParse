=begin

# Purpose

Traveller UWP Parse application to dump a human readable encyclopedia for a planet based on the UWP

# References

We're using the cepheus definitions for planets and world types

# General operation

Intent of the program is to feed in a file in SEC column-delimited format, break apart the chunks into the 
different respective fields, then take each bit and, from a list of keyed values, export out a makrkdown 
text file describing the system

Sample regex from : https://travellermap.com/doc/fileformats

^
( \s*       (?<Name>       .*                            ) )
( \s*       (?<Hex>        \d\d\d\d                      ) )
( \s{1,2}   (?<UWP>        [ABCDEX][0-9A-Z]{6}-[0-9A-Z]  ) )
( \s{1,2}   (?<Base>       [A-Z1-9* ]                    ) )
( \s{1,2}   (?<Remarks>    .{10,}?                       ) )
( \s+       (?<Zone>       [GARBFU]                      ) )?
( \s{1,2}   (?<PBG>        \d[0-9A-F][0-9A-F]            ) )
( \s{1,2}   (?<Allegiance> (\w\w\b|\w-|--)               ) )
( \s*       (?<Stars>      .*?                           ) )
\s*$

evolved: 

^\s*(?<Name>.*)\s*(?<Hex>\d\d\d\d)\s{1,3}(?<UWP>[ABCDEX][0-9A-Z]{6}-[0-9A-Z])\s{1,2}(?<Base>[A-Z1-9*\s])\s{1,2}(?<Remarks>.{10,}?)\s+(?<Zone>[GARBFU\s])\s{1,2}(?<PBG>\d[0-9A-F][0-9A-F])\s{1,2}(?<Allegiance>\w\w\b|\w-|--)\s*$

tested at : https://regexr.com/
tested at : https://rubular.com/

Planielaia    1017 A668675-7  N Ag Ni Ri        A  224 Gt

Broken up as : 

planet_format = %r{
    ^                                       # beginning of line
    \s*                                     # zero or more opening spaces
    (?<Name>.*)                             # match zero or more of any character for name as <name>
    \s*                                     # match zero or more whitespace characters
    (?<Hex>\d\d\d\d)                        # match four digits as <hex>
    \s{1,3}                                 # match up to three separator spaces
    (?<UWP>[ABCDEX][0-9A-Z]{6}-[0-9A-Z])    # match [ABCDEX] as starbase type, 6-code pseudohex, dash, and tech level as <uwp>
    \s{1,2}                                 # match potential spaces before base type
    (?<Base>[A-Z1-9*\s])                    # match single character OR space as <Base>
    \s{1,2}                                 # match potential spaces before remarks
    (?<Remarks>.{10,}?)                     # match minimum of 10 of any characters including space 
    \s+                                     # match any remaining spaces
    (?<Zone>[GARBFU\s])                     # match zone type letter or space as <zone>
    \s{1,2}                                 # match spaces before PBG
    (?<PBG>\d[0-9A-F][0-9A-F])              # match number followed by two letters for <pbg>
    \s{1,2}                                 # match 1 or 2 spaces before allegiance codes
    (?<Allegiance>\w\w\b|\w-|--)            # match possible allegiane (no spaces) as <Allegiance>
    \s*
    $
}x


=end

# SETUP

filename = ARGV.first

PLANET_FORMAT_REGEX = %r{
    ^                                       # beginning of line
    \s*                                     # zero or more opening spaces
    (?<Name>.*)                             # match zero or more of any character for name as <name>
    \s*                                     # match zero or more whitespace characters
    (?<Hex>\d\d\d\d)                        # match four digits as <hex>
    \s{1,3}                                 # match up to three separator spaces
    (?<UWP>[ABCDEX][0-9A-Z]{6}-[0-9A-Z])    # match [ABCDEX] as starbase type, 6-code pseudohex, dash, and tech level as <uwp>
    \s{1,2}                                 # match potential spaces before base type
    (?<Base>[A-Z1-9*\s])                    # match single character OR space as <Base>
    \s{1,2}                                 # match potential spaces before remarks
    (?<Remarks>.{10,}?)                     # match minimum of 10 of any characters including space 
    \s+                                     # match any remaining spaces
    (?<Zone>[GARBFU\s])                     # match zone type letter or space as <zone>
    \s{1,2}                                 # match spaces before PBG
    (?<PBG>\d[0-9A-F][0-9A-F])              # match number followed by two letters for <pbg>
    \s{1,2}                                 # match 1 or 2 spaces before allegiance codes
    (?<Allegiance>\w\w\b|\w-|--)            # match possible allegiane (no spaces) as <Allegiance>
    \s*
    $
}x

# METHODS

# CLASSES

# MAIN

#File.foreach(filename).with_index do |line, line_num|
File.foreach(filename).with_index do |line, line_num|
        # trial for output
    puts "#{line_num}:  #{line}"

    # ignore lines starting with "#"  - use pure regex to pick apart the SEC file
    # ignore whitespace/ empty lines    
    # if line is full and NOT "noformat"

 end
