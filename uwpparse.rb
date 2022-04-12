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

# !!!!!!! Make an ARGV
sector_name = "Outer Worlds"

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

def write_starport_classa(port_class)
    puts "**Starport Class:** #{port_class}"
    puts
end    

# CLASSES

# MAIN

puts "title:  Stellar Atlas for the #{sector_name} sector."
puts "-"*80

File.foreach(filename).with_index do |line, line_num|
        # trial for output
        # puts "#{line_num}:  #{line}"

        match = line.match(PLANET_FORMAT_REGEX)

        if match    
            # "unclean" values
            system_name = match['Name'].rstrip
            system_hex = match['Hex']
            system_uwp = match['UWP']
            system_base = match['Base'].gsub(/\s/,"none")

            # need to clear all-whitespace version first
            system_remarks_temp = match['Remarks'].gsub(/\s{10}/,"none")
            system_remarks = system_remarks_temp.rstrip
        
            system_zone = match['Zone'].gsub(/\s/,"none")
            system_pbg = match['PBG']
            system_ally = match['Allegiance']

            # need to further split UWP, remarks, and PBG
            pbg_pop = system_pbg[0]
            pbg_belts = system_pbg[1]
            pbg_gas_giants = system_pbg[2]

            system_remark_codes = system_remarks.split(' ')

            uwp_starport = system_uwp[0]
            uwp_size = system_uwp[1]
            uwp_atmo = system_uwp[2]
            uwp_hydro = system_uwp[3]
            uwp_pop = system_uwp[4]
            uwp_govt = system_uwp[5]
            uwp_law = system_uwp[6]
            uwp_tech = system_uwp[8]
            
            # now do text dump for each value
            #!!!!!!!! Later change to file dump
            
            # name - 
            puts "---------------- TEMP SEPATATOR -----------------"
            puts
            puts "# The #{system_name} system" 
            puts
            puts "*#{line}*"
            puts
            puts "**Hex map grid:** #{system_hex}"
            puts
            puts "**UWWP/UPP:*• #{system_uwp}"
            puts
            write_starport_classa(uwp_starport)

            # starport - 

            puts "It has base type : [#{system_base}]"
            puts
            puts "Applicable trade codes : \n"
            puts
             
            system_remark_codes.each() do |sys_code|
                puts "\t- [#{sys_code}]"
            end
            puts

            puts "System zone: [#{system_zone}]"
            puts
            puts "System PBG codes: [#{system_pbg}] with a pop multiplier of [#{pbg_pop}], [#{pbg_belts}] belt(s), and [#{pbg_gas_giants}] gas giant(s)"
            puts
            puts "System Alliances: [#{system_ally}]"
            puts

            ### Cleanup
            
        else
            puts "No valid entry on line index [ #{line_num} ]"

        end
 end
