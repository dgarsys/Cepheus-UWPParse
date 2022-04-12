filename = ARGV.first

txt = open(filename)

puts "Here's your file #{filename}: \n ---------------------------------------"
puts txt.read
puts

puts "Try again but use foreach loop: \n ---------------------------------------"
File.foreach(filename).with_index do |line, line_num|
    puts "#{line_num}: #{line}"
 end
 

# print "Type the filename again: "
# file_again = $stdin.gets.chomp

# txt_again = open(file_again)

# print txt_again.read