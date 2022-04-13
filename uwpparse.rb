=begin

# Purpose

Traveller UWP Parse application to dump a human readable encyclopedia for a planet based on the UWP

# References

We're using the cepheus definitions for planets and world types

# General operation

Intent of the program is to feed in a file in SEC column-delimited format, break apart the chunks into the 
different respective fields, then take each bit and, from a list of keyed values, export out a makrkdown 
text file describing the system

# Usage

call this file with the argument of the input file name - relative path in same directory

it is assumed the filename has a "." in it (.txt, .md, .sec, etc)

it is assumed the file is in the same directory and has no slashes/dots/etc

it is assumed we're using CT or Cepheus classifications, not T5


# THINGS TO ADD
 - file checking and rename via argv including full paths
 - existing file safety and auto-rename
 - pull subsector names?


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
save_tempname = filename.split(".")
save_filename = "#{save_tempname.first}_almanac.md"         # use with add_to_file(save_filename,outputblock)


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


def add_to_file(outfile,outputblock)
    puts outputblock
    File.open(outfile, "a+") do |file|
        file.puts(outputblock)
end
      
end

def write_starport_class(port_class)
    port_classes = {
        "A" => "Excellent quality installation. Refined fuel available. Annual maintenance overhaul available. Shipyard capable of constructing starships and non-starships present.",
        "B" => "Good quality installation. Refined fuel available. Annual maintenance overhaul available. Shipyard capable of constructing non-starships present.",
        "C" => "Routine quality installation. Only unrefined fuel available. Reasonable repair facilities present.",
        "D" => "Poor quality installation. Only unrefined fuel available. No repair or shipyard facilities present.",
        "E" => "Frontier Installation. Essentially a marked spot of bedrock with no fuel, facilities, or bases present.",
        "X" => "No starport, or any provisions made for ship landings"
    }

    return "> **Starport Class:** #{port_class} - #{port_classes[port_class]}\n> \n"
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

    return "> **Planet size:** Code:#{planet_size}, roughly #{planet_sizes[planet_size][0]} with a gravity of #{planet_sizes[planet_size][1]}g, considered a  #{planet_sizes[planet_size][2]} world.\n> \n"
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

    line_01 = "> **Planet atmosphere:** Code:#{planet_atmo}"
    line_02 = "> - Type: #{planet_atmos[planet_atmo][0]}"
    line_03 = "> - Pressure: #{planet_atmos[planet_atmo][1]}"
    line_04 = "> - Survival gear required: #{planet_atmos[planet_atmo][2]}"

    return "> #{line_01}\n> #{line_02}\n> #{line_03}\n> #{line_04}\n> \n"
end    

def write_planet_hydro(planet_hydro)
    planet_hydros = {
        "0" => ["0-5%","Desert world"],
        "1" => ["6-15%","Dry world"],
        "2" => ["16-25%","A few small seas"],
        "3" => ["26-35%","Small seas and oceans",],
        "4" => ["36-45%","Wet world"],
        "5" => ["46-55%","Large oceans"],
        "6" => ["56-65%","Large oceans"],
        "7" => ["66-75","Earthlike, many large oceans"],
        "8" => ["76-85%","Water world"],
        "9" => ["86-95%","Only a few small islands and archipelagos"],
        "A" => ["96-100%","Almost entirely water"]
    }

    return "> **Hydrographics** code:#{planet_hydro} - PLanet is #{planet_hydros[planet_hydro][0]} water. #{planet_hydros[planet_hydro][1]}\n> \n"
end    

def write_planet_pop(planet_pop, planet_pop_modifier)
    planet_pops = {
        "0" => [0,0],
        "1" => [10,1],
        "2" => [100,2],
        "3" => [1000,3],
        "4" => [10000,4],
        "5" => [100000,5],
        "6" => [1000000,6],
        "7" => [10000000,7],
        "8" => [100000000,8],
        "9" => [1000000000,9],
        "A" => [10000000000,10]
    }

    return "> **Population** code:#{planet_pop} mod #{planet_pop_modifier} - Approximately: #{planet_pops[planet_pop][0]*planet_pops[planet_pop_modifier][1]}\n> \n"
end    



def write_planet_govt(planet_govt)
    planet_govts = {
        "0" => "None",
        "1" => "Company/Corporation",
        "2" => "Participating Democracy",
        "3" => "Self-perpetuating Oligarchy",
        "4" => "Representative Democracy",
        "5" => "Fuedal Technocracy",
        "6" => "Captive Government",
        "7" => "Balkanization",
        "8" => "Civil Service Bureaucracy",
        "9" => "Impersonal Bureaucracy",
        "A" => "Charismatic Dictator",
        "B" => "Non-charismatic Leader",
        "C" => "Charismatic Oligarchy",
        "D" => "Religious Dictatorship",
        "E" => "Religious Autocracy",
        "F" => "Totalitarian Oligarchy"
    }

    return "> **Overall government type** code:#{planet_govt} - #{planet_govts[planet_govt]}\n> \n"

end


def write_planet_law(planet_law)
    planet_laws = {
        "0" => ["No law","No restrictions; candidate for Amber Zone status."],
        "1" => ["No law","Poison gas, explosives, undetectable weapons, weapons of mass destruction."],
        "2" => ["No law",     "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons)."],
        "3" => ["No law",     "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). Heavy weapons. ",],
        "4" => ["Medium law", "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). Heavy weapons. Light assault weapons and submachine guns. "],
        "5" => ["Medium law", "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). Heavy weapons. Light assault weapons and submachine guns. Personal concealable weapons."],
        "6" => ["Medium law", "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). All firearms except shotguns and stunners. Carrying weapons discouraged. "],
        "7" => ["High law",   "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). All firearms except stunners. Carrying weapons discouraged. "],
        "8" => ["High law",   "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). All firearms including stunners. All bladed weapons (generally not including knives). Carrying weapons discouraged. "],
        "9" => ["High law",   "Poison gas, explosives, undetectable weapons, weapons of mass destruction. Portable energy weapons (except ship-mounted weapons). Any weapons, even small knives, outside of one's residence. Candidate for Amber Zone status."],
        "A" => ["Extreme law","No weapons allowed at all. Candidate for Amber Zone status."],
        "B" => ["Extreme law","No weapons allowed at all. Candidate for Amber Zone status."],
        "C" => ["Extreme law","No weapons allowed at all. Candidate for Amber Zone status."],
        "D" => ["Extreme law","No weapons allowed at all. Candidate for Amber Zone status."],
        "E" => ["Extreme law","No weapons allowed at all. Candidate for Amber Zone status."],
        "F" => ["Extreme law","No weapons allowed at all. Candidate for Amber Zone status."]
    }

    return "> **Law Level** code:#{planet_law} - #{planet_laws[planet_law][0]}. Restrictions: #{planet_laws[planet_law][1]}\n> \n"
end    




# https://www.orffenspace.com/cepheus-srd/equipment.html
def write_planet_techlevel(planet_tech)
    planet_techs = {
        "0" => ["Primitive","No technology."],
        "1" => ["Primitive","Roughly on a par with Bronze or Iron age technology."],
        "2" => ["Primitive","Renaissance technology."],
        "3" => ["Primitive","Mass production allows for product standardization, bringing the germ of industrial revolution and steam power.",],
        "4" => ["Industrial","Transition to industrial revolution is complete, bringing plastics, radio and other such inventions."],
        "5" => ["Industrial","Widespread electrification, tele-communications and internal combustion."],
        "6" => ["Industrial","Development of fission power and more advanced computing."],
        "7" => ["Pre-stellar","Can reach orbit reliably and has telecommunications satellites."],
        "8" => ["Pre-stellar","Possible to reach other worlds in the same system, although terraforming or full colonization is not within the culture's capacity."],
        "9" => ["Pre-stellar","Development of gravity manipulation, which makes space travel vastly safer and faster; first steps into Jump Drive technology."],
        "A" => ["Early stellar","With the advent of Jump, nearby systems are opened up."],
        "B" => ["Early stellar", "The first primitive (non-creative) artificial intelligences become possible in the form of low autonomous interfaces, as computers begin to model synaptic networks."],
        "C" => ["Average Stellar","Weather control revolutionizes terraforming and agriculture."],
        "D" => ["Average Stellar","The battle dress appears on the battlefield in response to the new weapons. High autonomous interfaces allow computers to become self-actuating and self-teaching."],
        "E" => ["Average Stellar","Fusion weapons become man-portable."],
        "F" => ["High Stellar","Black globe generators suggest a new direction for defensive technologies, while the development of synthetic anagathics means that the human lifespan is now vastly increased."]
    }

    return "> **Tech Level:** Code:#{planet_tech} - #{planet_techs[planet_tech][0]} -  #{planet_techs[planet_tech][1]}\n> \n"
end


def write_bases(base_type)
    base_types = {
        "none" => "No bases present.",
        "A" => "Naval and Scout bases are present.",
        "G" => "Scout base or outpost is present. There are rumors of a pirate base.",
        "N" => "Naval base is present.",
        "P" => "Believed a pirate base is present.",
        "S" => "A scout base or outpost is present"
    }

    return "**Bases Present:** #{base_type} : #{base_types[base_type]}\n\n"
end    

def format_trade_codes(trade_codes)

    trade_types = {                             #see T5 book 3 page 26 for more options - may also want to expand population parser
        "none" => "No bases present. ",
        "Ag" => "Agricultural. ",
        "As" => "Asteroid. ",
        "Ba" => "barren. ",
        "De" => "Desert. ",
        "Fl" => "Fluid Oceans (Atmo A+). ",
        "Ga" => "Garden. ",
        "Hi" => "High Population. ",
        "Ht" => "High Technology. ",
        "Ic" => "Ice-capped. ",
        "In" => "Industrial. ",
        "Lo" => "Low Population. ",
        "Lt" => "Low Technology. ",
        "Ni" => "Non Industrial. ",
        "Po" => "Poor. ",
        "Ri" => "Rich. ",
        "Wa" => "Water world. ",
        "Va" => "Vacuum. "
    }



    line_01 = "**Applicable trade codes:** "

     
    trade_codes.each() do |sys_code|
        line_01 = line_01 + trade_types[sys_code]
    end
    line_01 = line_01 + "\n\n"

    return line_01
end

# CLASSES

# MAIN

# Output headers to stdout and file
#---------------------------------------------------------------------
 
add_to_file(save_filename,"title:  Stellar Atlas for the #{sector_name} sector.\n\n")

out_line = "-"*80 + "\n\n"
add_to_file(save_filename,out_line)

# Read input file to parse and process results
File.foreach(filename).with_index do |line, line_num|
        # trial for output
        # puts "#{line_num}:  #{line}"

        match = line.match(PLANET_FORMAT_REGEX)         # check if the line is a valid planet description line

        if match                                        # if it matches, it's a real line! Pull the values
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

            add_to_file(save_filename,"---------\n\n")                          # Output separator for each system
            add_to_file(save_filename,"## The #{system_name} system\n\n")       # Output System Name as header2 (header 1 will be added for subsectors)
            add_to_file(save_filename,"`#{line.rstrip}`\n\n")                   # Output full system UWP line as code block
            add_to_file(save_filename,"**Hex map grid:** #{system_hex}\n\n")    # output hex map grid coordinate
            add_to_file(save_filename,"**UWWP/UPP:** #{system_uwp}\n\n")        # output UWP code

            ## Elaborate on UWP Values
            #starport
            add_to_file(save_filename,write_starport_class(uwp_starport))       # output the text description of the starport class and follower line

            # size
            add_to_file(save_filename,write_planet_size(uwp_size))              # output the text description of the planet size and follower line

            #atmosphere
            add_to_file(save_filename,write_planet_atmo(uwp_atmo))              # output the text description of the planet atmosphere and follower line

            # water / hydrographic percentage
            add_to_file(save_filename,write_planet_hydro(uwp_hydro))            # output the text description of the planet hydrographics and follower line

            # population
            add_to_file(save_filename,write_planet_pop(uwp_pop, pbg_pop))       # output the text description of the planet population including multiplier

            # government
            add_to_file(save_filename,write_planet_govt(uwp_govt))              # output the text description of the planet government and follower line

            #law level
            add_to_file(save_filename,write_planet_law(uwp_law))                # output the text description of the planet law level

            #tech level
            add_to_file(save_filename,write_planet_techlevel(uwp_tech))         # output the text description of the planet tech level
 
            # Bases present
            add_to_file(save_filename,write_bases(system_base))                 # output the text description of system bases

            # trade codes
            add_to_file(save_filename,format_trade_codes(system_remark_codes))  # output the text description of trade codes

            

# -----------------------------------REMAINING TO ENTER BEFORE dump to file and maybe sort
=begin       
            system_zone = match['Zone'].gsub(/\s/,"none")
            pbg_belts = system_pbg[1]
            pbg_gas_giants = system_pbg[2]

            system_ally = match['Allegiance']
=end


            puts "System zone: [#{system_zone}]"
            puts
            puts "System PBG codes: [#{system_pbg}] with a pop multiplier of [#{pbg_pop}], [#{pbg_belts}] belt(s), and [#{pbg_gas_giants}] gas giant(s)"
            puts
            puts "System Alliances: [#{system_ally}]"
            puts

            ### Cleanup
            
        else    # does not match as a valid UWP line - throw a warning
            add_to_file(save_filename,"Not recognized as valid entry on line index [ #{line_num} ]\n\n")
            add_to_file(save_filename,"`#{line}`")
        end
 end
