require 'zlib'
def make_zlib2(x)
return Zlib::Inflate.inflate(x)
end

begin

print "Quick Word Learning Helper\n"
print "v 1.00\n"
print "by Narzew\n"
print "HTTP://WWW.HACKTUT.ORG\n"
print "Product is FREEWARE.\n"
print "All rights reserved.\n"

file = File.open('lang.dat', 'rb')
$lang = Marshal.load(file)
file.close
$lang2 = []
$lang.each{|x|
$lang2 << make_zlib2(x)
}
$lang = $lang2

print "#{$lang[0]}\n"
$wordlist = gets.chomp!

unless File.exist?("Wordlists/#{$wordlist}.dat")
print "#{$lang[11]}\n"
print "#{$lang[10]}\n"
$stdin.gets
exit
end

loop do

print "#{$lang[1]}\n"

print "\n\n\n"

file = File.open("Wordlists/#{$wordlist}.dat", 'rb')
$wordlist = Marshal.load(file)
print make_zlib2($wordlist[0])
print "\n\n\n"
file = File.open('w2.crbl', 'wb')
file.write(make_zlib2($wordlist[1]))
file.close
flash = []
card = Struct.new(:question, :answer)
File.open("w2.crbl", "rb").each { |line|
if line =~ /(.*)\s{3,10}(.*)/
flash << card.new($1.strip, $2.strip)
end
}
File.delete('w2.crbl')
flash.replace(flash.sort_by { rand })
$max = flash.size
$correct = 0
$bad = 0
$badwords = []
until flash.empty?
drill = flash.pop
print "#{drill.question}? \n"
guess = gets.chomp
if guess.downcase == drill.answer.downcase
print "\n\n#{$lang[2]}#{drill.answer}\n\n\n"
$correct += 1
else
print "\n\n#{$lang[3]}#{drill.answer}\n\n\n"
$bad += 1
$badwords << drill.question
end
end

print "$#{$lang[4]}\n#{$lang[5]}\n"
print "#{$lang[6]}#{$correct}/#{$max}\n"
print "#{$lang[7]}#{$bad}\n"
print "#{$lang[8]}"
$badwords.each{|x|
print "#{x}, "}

print "\n\n#{$lang[9]}\n"
data = gets.chomp!
unless data.downcase == 'y'
break
else
print "\n\n\n\n\n\n\n"
end

end

print "#{$lang[10]}"
$stdin.gets
exit

rescue => e

print "Fatal error! Error : \n#{e}\n"
print "Press Enter to exit."
$stdin.gets
exit
end
