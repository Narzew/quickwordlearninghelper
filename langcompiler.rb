require 'zlib'
def make_zlib(x)
return Zlib::Deflate.deflate(x)
end
begin

print "Quick Word Learning Helper\n"
print "LANGUAGE EDITOR by NARZEW\n"
print "v 1.00\n"
print "by Narzew\n"
print "HTTP://WWW.HACKTUT.ORG\n"
print "Product is FREEWARE.\n"
print "All rights reserved.\n"

$make_default = false
$make_default = true if ARGV[0] == "default"

$lang2 = []
$lang_prefs = [
"Type the wordlist file.",
"Nice game!!!",
"Good! Answer is : ",
"Bad! Your answer is incorrect!\nThe good answer is : ",
"That\'s all !!!",
"Statistics :",
"Correct words : ",
"Bad words : ",
"Bad words : ",
"One time more?? [y/n]",
"Press Enter to exit.",
"File do not exist."
]

if $make_default == false
$count = 0
$lang_prefs.size.times{|x|
print "Type the definition of word \"#{$lang_prefs[$count]}\"\n"
data = gets.chomp!
$lang2 << data
$count += 1
}
end

$lang =[]
$lang2 = $lang_prefs if $make_default == true
$lang2.each{|x|
$lang << make_zlib(x)
}
file = File.open('lang.dat', 'wb')
Marshal.dump($lang, file)
file.close

print "Language file maked succesfully.\n"
print "Have a nice day.\n"
$stdin.gets

rescue => e

print "Fatal error! Error : \n#{e}\n"
print "Press Enter to exit."
$stdin.gets
exit
end
