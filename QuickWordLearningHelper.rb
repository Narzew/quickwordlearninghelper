require 'zlib'

module QWLH

	def self.make_zlib2(x)
		return Zlib::Inflate.inflate(x)
	end

	def self.load_language
		file = File.open('lang.ini')
		lange = file.read
		file.close
		file = File.open("Languages/" + lange + '.dat', 'rb')
		$lang = Marshal.load(file)
		file.close
		$lang2 = []
		$lang.each{|x|
		$lang2 << QWLH.make_zlib2(x)
		}
		$lang = $lang2
	rescue
		print "\n\nFail to load language file.\n"
		print "Press ENTER to close."
		$stdin.gets
		exit
	end

	def self.load_wordlist
		unless File.exist?("Wordlists/#{$wordlist}.dat")
				print "#{$lang[11]}\n"
				print "#{$lang[10]}\n"
				$stdin.gets
				exit
		end
		print "#{$lang[1]}\n"
		print "\n\n\n"
		file = File.open("Wordlists/#{$wordlist}.dat", 'rb')
		$wordlist = Marshal.load(file)
		print "**************************************************\n"
		print "***#{$lang[12]}***\n"
		print "**************************************************\n"
		$description = QWLH.make_zlib2($wordlist[0])
		$data = QWLH.make_zlib2($wordlist[1])
		$author = QWLH.make_zlib2($wordlist[2])
		$name = QWLH.make_zlib2($wordlist[3])
		print "#{$lang[13]}#{$name}\n"
		print "#{$lang[14]}#{$author}\n"
		print "#{$lang[15]}#{$description}\n"
		print "**************************************************\n"
		print "\n\n\n"
		file = File.open('w2.crbl', 'wb')
		file.write($data)
		file.close
		$flash = []
		card = Struct.new(:question, :answer)
		file = File.open("w2.crbl", "rb").each{ |line|
		if line =~ /(.*)\s{3,10}(.*)/
			$flash << card.new($1.strip, $2.strip)
		end
		}
		file.close
		File.delete('w2.crbl')
		$flash.replace($flash.sort_by { rand })
		$max = $flash.size
		$correct = 0
		$bad = 0
		$badwords = []
	rescue => e
	    print e
		print "\n\nFail to read wordlist file.\nPress ENTER to exit.\n"
		$stdin.gets
	end

	def self.begin_game
		until $flash.empty?
			drill = $flash.pop
			print "#{drill.question}? \n"
			guess = gets.chomp
			if guess.downcase == drill.answer.downcase
				print "\n\n#{$lang[2]}#{drill.answer}\n\n\n"
				$correct += 1
			else
				print "\n\n#{$lang[3]}#{drill.answer}\n\n\n"
				$bad += 1
				$badwords << [drill.question, drill.answer]
			end
		end
	end

	def self.show_statistics
	
		print "#{$lang[4]}\n"
	
		print "**************************************************\n"
		print "#{$lang[5]}\n"
		print "**************************************************\n"
		print "#{$lang[4]}\n"
		print "#{$lang[6]}#{$correct}/#{$max}\n"
		print "#{$lang[7]}#{$bad}\n"
		print "#{$lang[8]}"
		$badwords.each{|x|
		print "#{x}, "}
	end
end

begin
	print "Quick Word Learning Helper\n"
	print "v 2.0\n"
	print "by Narzew\n"
	print "HTTP://WWW.HACKTUT.ORG\n"
	print "Product is FREEWARE.\n"
	print "All rights reserved.\n"
	QWLH.load_language
	loop do
		print "#{$lang[0]}\n"
		$wordlist = gets.chomp!
		QWLH.load_wordlist
		QWLH.begin_game
		QWLH.show_statistics
		print "\n\n#{$lang[9]}\n"
		sdata = gets.chomp!
		unless sdata.downcase == 'y'
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
