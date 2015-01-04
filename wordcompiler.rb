require 'zlib'
begin

print "Quick Word Learning Helper\n"
print "WORD COMPILER by NARZEW\n"
print "v 1.00\n"
print "by Narzew\n"
print "HTTP://WWW.HACKTUT.ORG\n"
print "Product is FREEWARE.\n"
print "All rights reserved.\n"

print "Type the words file name you want to compile.\n"
$wordfile = gets.chomp!
print "\nType the destination file.\n"
$destination = gets.chomp!
print "\nType the wordlist description.\n"
$description = gets.chomp!

print "\n\n\nCompilling...\n"

file = File.open($wordfile, 'rb')
data = file.read
file.close
$wordlist = [Zlib::Deflate.deflate($description,9), Zlib::Deflate.deflate(data,9)]
file = File.open($destination, 'wb')
Marshal.dump($wordlist, file)
file.close

print "\nSuccesfully Compiled Words!!!\n"
print "\nPress Enter to close\n"
$stdin.gets
exit

rescue => e

print "Fatal error! Error : \n#{e}\n"
print "Press Enter to exit."
$stdin.gets
exit
end
