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

# METHODS / FUNCTIONS

def write_starport_class(port_class)
    port_classes = {
        "A" => "Excellent quality installation. Refined fuel available. Annual maintenance overhaul available. Shipyard capable of constructing starships and non-starships present.",
        "B" => "Good quality installation. Refined fuel available. Annual maintenance overhaul available. Shipyard capable of constructing non-starships present.",
        "C" => "Routine quality installation. Only unrefined fuel available. Reasonable repair facilities present.",
        "D" => "Poor quality installation. Only unrefined fuel available. No repair or shipyard facilities present.",
        "E" => "Frontier Installation. Essentially a marked spot of bedrock with no fuel, facilities, or bases present.",
        "X" => "No starport, or any provisions made for ship landings"
    }

    puts "> **Starport Class:** #{port_class} - #{port_classes[port_class]}"
end    

def write_planet_size(planet_size)
    planet_sizes = {
        "0" => ["800 km or less (typically an asteroid)","0.00","low-gravity"],
        "1" => ["1,600 km","0.05","low-gravity"],
        "2" => ["3,200 km","0.15","low-gravity"],
        "3" => ["4,800 km","0.25","low-gravity"],
        "4" => ["6,400 km","0.35","low-gravity"],
        "5" => ["8,000 km","0.45","low-gravity"],
        "6" => ["9,600 km","0.7","low-gravity"],
        "7" => ["11,200 km","0.9","normal gravity"],
        "8" => ["12,800 km","1.0","normal gravity"],
        "9" => ["14,400 km","1.25","high-gravity"],
        "A" => ["16,000","1.4","high-gravity"]
    }

    puts "> **Planet size:** Code:#{planet_size}, roughly #{planet_sizes[planet_size][0]} with a gravity of #{planet_sizes[planet_size][1]}g, considered a  #{planet_sizes[planet_size][2]} world"
end    

def write_planet_atmo(planet_atmo)
    planet_atmos = {
        "0" => ["none","0.00","vacc suit"],
        "1" => ["trace","0.001 to 0.09","vacc suit"],
        "2" => ["very thin, tainted","0.1 to 0.42","respirator, filter"],
        "3" => ["very thin","0.1 to 0.42","respirator"],
        "4" => ["thin, tainted","0.43 to 0.7","filter"],
        "5" => ["thin","0.43 to 0.7","none"],
        "6" => ["standard","0.71-1.49","none"],
        "7" => ["standard,tainted","0.71-1.49","filter"],
        "8" => ["dense","1.5 to 2.49","none"],
        "9" => ["dense, tainted","1.5 to 2.49","filter"],
        "A" => ["exotic","varies","air supply"],
        "B" => ["corrosive","varies","vacc suit"],
        "C" => ["insidious","varies","vacc suit"],
        "D" => ["dense, high","2.5+","none"],
        "E" => ["thin, low","0.5 or less","none"],
        "F" => ["unusual","varies","varies"]
    }

    puts "> **Planet atmosphere:** Code:#{planet_atmo}"
    puts "> - Type: #{planet_atmos[planet_atmo][0]}"
    puts "> - Pressure: #{planet_atmos[planet_atmo][1]}"
    puts "> - Survival gear required: #{planet_atmos[planet_atmo][2]}"
end    






def write_bases(base_type)
    base_types = {
        "none" => "No bases present.",
        "A" => "Naval and Scout bases are present.",
        "G" => "Scout base or outpost is present. There are rumors of a pirate base.",
        "N" => "Naval base is present.",
        "P" => "Believed a pirate bse is present.",
        "S" => "A scout base or outpost is present"
    }

    puts "**Bases Present:** #{base_type} : #{base_types[base_type]}"
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
            puts "`#{line.rstrip}`"
            puts
            puts "**Hex map grid:** #{system_hex}"
            puts
            puts "**UWWP/UPP:** #{system_uwp}"
            puts
            ## remaining UWP Values
            #starport
            write_starport_class(uwp_starport)
            puts "> "
            # size
            write_planet_size(uwp_size)
            puts "> "
            #atmosphere
            write_planet_atmo(uwp_atmo)
            puts "> "
            # water / hydrographic percentage

            # population

            # government

            #law level

            #tech level

            puts
            # Bases present
            write_bases(system_base)

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
