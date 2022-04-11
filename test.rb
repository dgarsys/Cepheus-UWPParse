
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



# ---------------------------------------------------CURRENT-------------
# https://www.rubyguides.com/ruby-tutorial/working-with-ruby-collections/ 
# https://www.geeksforgeeks.org/ruby-class-object/?ref=lbp
