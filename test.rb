#---------------------------------------------------------------------------------
# The following distributes incoming arguments to exactly three variables
=begin

first, second, third = ARGV

For just one argument:
user_name = ARGV.first # gets the first argument


NOTE: if using arguments via ARGV, you need to use <<<  $stdin.gets.chomp >>> 
instead of gets.chomp to force the program to use standard input interactively
with the user instead of confusing it re: user interactive vs ARGV input

=end

# "puts" prints to command line


# Types of variable
# ---------------------------
# global variable       $apple
# instance variable     @apple
# class variable        @@apple
# constant              APPLE
#

# BEGIN {} 
# used to declare code that runs before main run

# END {}
# ditto but at end

# REMARKS AND COMMENTS
# obviously "#"

# Also:

=begin
 Block comments
 with multipl lines   
=end

=begin
==================KEY WORDS

BEGIN	do	next	then
END	else	nil	true
alias	elsif	not	undef
and	end	or	unless
begin	ensure	redo	until
case	for	retry	while
break	false	rescue	when
def	in	self	__FILE__
class	if	return	while

=end

# Example of feeding variables into text output. 
=begin
puts "Hello #{name}, our records tell us that you're #{age} years old!"
=end



#!!!!! Note that we need to know how to break up / regex / parse a line of text from a file

# Example?
=begin

File.foreach(filename).with_index do |line, line_num|
   puts "#{line_num}: #{line}"
end


=end




# Ruby program to illustrate the defining
# and calling of method

#!/usr/bin/ruby


# ------------------------------------------Methods

# Here geeks is the method name
def geeks(geekInput1="Darius", geekInput2)

    # statements to be displayed
    puts "Welcome #{geekInput1} to GFG portal for #{geekInput2} years."
    
# keyword to end method
end



# calling of the method
geeks "Dan","30"


# Ruby program to illustrate the method
# that takes variables number of arguments

# - ------------------------------variable ARGUMENTS
# defining method geeks that can
# take any number of arguments
def geeks2 (*var)
	
    # to display the total number of parameters
    puts "Number of parameters is: #{var.length}"
        
    # using for loop
    for i in 0...var.length
        puts "Parameters are: #{var[i]}"
    end
end
    
# calling method by passing
# variable number of arguments
geeks2 "GFG", "G4G"
geeks2 "GeeksforGeeks"
    



# ------------------------------------------RETURNS
### Return statement in Methods: Return statement used to returns one or more values. By default, a method always returns the last statement that was evaluated in the body of the method. ‘return’ keyword is used to return the statements.

### Example:

# Ruby program to illustrate method return statement
  
  
# num is the method name
def num
    # variables of method
    a = 10
    b = 39
    
    sum = a + b
    
    # return the value of the sum
    return sum
end
  
# calling of num method
puts
puts "The return result is: #{num}"
puts



# Function Defs
# this one is like your scripts with ARGV
def print_two(*args)
    arg1, arg2 = args
    puts "arg1: #{arg1}, arg2: #{arg2}"
  end
  
  # ok, that *args is actually pointless, we can just do this
  def print_two_again(arg1, arg2)
    puts "arg1: #{arg1}, arg2: #{arg2}"
  end
  
  # this just takes one argument
  def print_one(arg1)
    puts "arg1: #{arg1}"
  end
  
  # this one takes no arguments
  def print_none()
    puts "I got nothin'."
  end
  
  
  print_two("Zed","Shaw")
  print_two_again("Zed","Shaw")
  print_one("First!")
  print_none()



# IF syntax
if cars > people
    puts "We should take the cars."
  elsif cars < people
    puts "We should not take the cars."
  else
    puts "We can't decide."
  end




# FOR LOOP---------------------
the_count = [1, 2, 3, 4, 5]
fruits = ['apples', 'oranges', 'pears', 'apricots']
change = [1, 'pennies', 2, 'dimes', 3, 'quarters']

# this first kind of for-loop goes through a list
# in a more traditional style found in other languages
for number in the_count
  puts "This is count #{number}"
end

# same as above, but in a more Ruby style
# this and the next one are the preferred 
# way Ruby for-loops are written
fruits.each do |fruit|
  puts "A fruit of type: #{fruit}"
end

# also we can go through mixed lists too
# note this is yet another style, exactly like above
# but a different syntax (way to write it).
change.each {|i| puts "I got #{i}" }

# we can also build lists, first start with an empty one
elements = []

# then use the range operator to do 0 to 5 counts
(0..5).each do |i|
  puts "adding #{i} to the list."
  # pushes the i variable on the *end* of the list
  elements.push(i)
end

# now we can print them out too
elements.each {|i| puts "Element was: #{i}" }








# ---------------------------------------------------CURRENT-------------
# https://www.rubyguides.com/ruby-tutorial/working-with-ruby-collections/ 
# https://www.geeksforgeeks.org/ruby-class-object/?ref=lbp
