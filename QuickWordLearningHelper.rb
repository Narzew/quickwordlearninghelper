require 'zlib'
$version = "3.00"
$reldate = "02.01.2013"

def stc
		QWLH.sep_line
end

module QWLH

	def self.make_zlib(x)
		return Zlib::Deflate.deflate(x,9)
	end
	def self.make_zlib2(x)
		return Zlib::Inflate.inflate(x)
	end
	
	def self.sep_line
		print "========================================================\n"
	end
	
	def self.rank_1
		stc
		print "#{$lang[26]} 1 #{$lang[27]} F\n"
		print "#{$lang[20]}\n"
		stc
	end
	def self.rank_2
		stc
		print "#{lang[26]} 2 #{$lang[27]} E\n"
		print "#{$lang[21]}\n"
		stc
	end
	def self.rank_3
		stc
		print "#{$lang[26]} 3 #{$lang[27]} D\n"
		print "#{$lang[22]}\n"
		stc
	end
	def self.rank_4
		stc
		print "#{$lang[26]} 4 #{$lang[27]} C\n"
		print "#{$lang[23]}\n"
		stc
	end
	def self.rank_5
		stc
		print "#{$lang[26]} 5 #{$lang[27]} B\n"
		print "#{$lang[24]}\n"
		stc
	end
	def self.rank_6
		stc
		print "#{$lang[26]} 6 #{$lang[27]} A\n"
		print "#{$lang[25]}\n"
		stc
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
		print "\n\n"
		stc
		print "Fail to load language file.\n"
		print "Press ENTER to close.\n"
		stc
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
		print "#{$lang[30]} [y/n]\n"
		$reversed2 = gets.chomp
		$reversed = false
		case $reversed2.to_s.downcase
		when 'y' then $reversed = true
		when 'yes' then $reversed = true
		when 'n' then $reversed = false
		when 'no' then $reversed = false
		else
			$reversed = false
		end
		print "\n\n\n"
		file = File.open('w2.crbl', 'wb')
		file.write($data)
		file.close
		$flash = []
		card = Struct.new(:question, :answer)
		file = File.open("w2.crbl", "rb").each{ |line|
		if line =~ /(.*)\s{3,10}(.*)/
			if $reversed == false
				$flash << card.new($1.strip, $2.strip)
			else
				$flash << card.new($2.strip, $1.strip)
			end
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
		stc
	    print e
		print "\n\n#{$lang[19]}\n#{$lang[10]}\n"
		stc
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
	
		stc
		print "#{$lang[4]}\n"
		stc
		print "**************************************************\n"
		print "#{$lang[5]}\n"
		print "**************************************************\n"
		print "#{$lang[4]}\n"
		$percents = ((($correct.to_f/$max.to_f)*100).to_i)
		print "#{$lang[16]}:#{$percents} %\n"
		print "#{$lang[6]}#{$correct}/#{$max}\n"
		if $bad >= 1
			stc
			print "#{$lang[7]}#{$bad}\n"
			print "#{$lang[8]}\n"
			$badwords.each{|x|
				print "#{x[0]} => #{x[1]}\n"
			}
			stc
		else
			stc
			print "#{$lang[17]}\n#{$lang[18]}\n"
			stc
		end
		case ($percents%101).to_i
		when 0..30
			QWLH.rank_1
		when 31..50
			QWLH.rank_2
		when 51..74
			QWLH.rank_3
		when 75..90
			QWLH.rank_4
		when 91..99
			QWLH.rank_5
		when 100
			QWLH.rank_6
		end
	end
	
	def self.run_helper
		loop do
			stc
			print "#{$lang[0]}\n"
			stc
			$wordlist = gets.chomp!
			QWLH.load_wordlist
			QWLH.begin_game
			QWLH.show_statistics
			stc
			print "\n"
			stc
			print "#{$lang[9]}\n"
			stc
			sdata = gets.chomp!
			unless sdata.downcase == 'y' or sdata.downcase == 'yes'
				break
			else
				print "\n\n\n\n\n\n\n"
			end
		end
		stc
		print "#{$lang[10]}\n"
		stc
		$stdin.gets
		exit
	end
	
	def self.run_wordlist_compiler
		stc
		print "Quick Word Learning Helper\n"
		print "WORD COMPILER by NARZEW\n"
		print "v #{$version}\n"
		print "Released #{$reldate}\n"
		print "by Narzew\n"
		print "Product is FREEWARE.\n"
		print "All rights reserved.\n"
		stc
		
		stc
		print "#{$lang[31]}\n"
		stc
		$wordfile = gets.chomp!
		stc
		print "#{$lang[32]}\n"
		stc
		$destination = gets.chomp!
		stc
		print "#{$lang[33]}\n"
		stc
		$name = gets.chomp!
		stc
		print "#{$lang[34]}\n"
		stc
		$author = gets.chomp!
		stc
		print "#{$lang[35]}\n"
		stc
		$description = gets.chomp!
		print "\n\n\n"
		stc
		print "#{$lang[36]}\n"
		stc
		print "\n\n"
		$stdin.gets
		
		$time = Time.now
		stc
		print "#{$lang[37]}\n"
		stc
		
		file = File.open($wordfile, 'rb')
		data = file.read
		file.close
		$wordlist = [Zlib::Deflate.deflate($description,9),
			Zlib::Deflate.deflate(data,9),
			Zlib::Deflate.deflate($author),
			Zlib::Deflate.deflate($name)
		]
		file = File.open($destination, 'wb')
		Marshal.dump($wordlist, file)
		file.close
		stc
		print "#{$lang[38]}\n#{$lang[10]}\n"
		stc
		$stdin.gets
		exit
	end
	
	def self.run_language_editor
		stc
		print "Quick Word Learning Helper\n"
		print "LANGUAGE EDITOR by NARZEW\n"
		print "v #{$version}\n"
		print "Released #{$reldate}\n"
		print "by Narzew\n"
		print "Product is FREEWARE.\n"
		print "All rights reserved.\n"
		stc
		
		$make_default = false
		stc
		print "#{$lang[39]} [y/n]?\n"
		stc
		x = gets.chomp!.to_s
		case x.downcase
		when 'y' then $make_default = true
		when 'yes' then $make_default = true
		when 'n' then $make_default = false
		when 'no' then $make_default = false
		end
		
		$lang2 = []
		$lang_prefs = [
			"Type the wordlist file.", # 0
			"Nice game!!!", # 1
			"Good! Answer is : ", # 2 
			"Bad! Your answer is incorrect!\nThe good answer is : ", # 3
			"That\'s all !!!", # 4
			"Statistics :", # 5
			"Correct words : ", # 6
			"Bad words : ", # 7
			"Bad written words : ", # 8
			"One time more?? [y/n]", # 9
			"Press Enter to exit.", # 10
			"File do not exist.", # 11
			"Wordlist Information", # 12
			"Name : ", # 13
			"Author : ", # 14
			"Description : ", # 15
			"Correctness : ", # 16
			"All words are correct!!!", # 17
			"Congratulations!!!", # 18
			"Fail to read wordlist file.", # 19
			"Very bad!\nTrain more to get better result.", # 20
			"Bad!\nTrain more to get better result next time.", # 21
			"Average! Your result is average.\nMaybe next time you get better result?", # 22
			"Good!\nYour result is good.\nYou were learned topic, and you can now proceed to next lesson.", # 23
			"Very Good!\nYou get great results! You can be proud of yourself.", # 24
			"Perfect!\nIncredible! You get all 100 % of good choices.\nYou perfectly learned material.\nCongratulations!\nYou can be proud of yourself.", # 25
			"Your rank is ", # 26
			"or", # 27
			"Invalid mode.", # 28
			"Input it again.", # 29
			"Run reversed wordlist?", # 30
			"Type the words file name you want to compile.", # 31
			"Type the destination file.", # 32
			"Type the wordlist name.", # 33
			"Type the wordlist author.", # 34
			"Type the wordlist description.", # 35
			"Press ENTER to start compilation.", # 36
			"Compilling...", # 37
			"Collection succesfully compiled.", # 38
			"Make default?", # 39
			"Type the definition of word", # 40
			"Language file made succesfully.", # 41
			"Have a nice day.", # 42
			"Select mode to run.", # 43
			"run Quick Word Learning Helper", # 44
			"run Wordlist Compiler", # 45
			"run Language Editor", # 46
			"Fatal error!", # 47
			"Error :" # 48
		]
		
		if $make_default == false
			$count = 0
			$lang_prefs.size.times{|x|
				stc
				print "#{$lang[40]} \##{$count+1} \"#{$lang_prefs[$count]}\"\n"
				stc
				data = gets.chomp!
				$lang2 << data
				$count += 1
			}
		end
		
		$lang =[]
		$lang2 = $lang_prefs if $make_default == true
		$lang2.each{|x|
			$lang << QWLH.make_zlib(x)
		}
		file = File.open('lang.dat', 'wb')
		Marshal.dump($lang, file)
		file.close
		QWLH.load_language
		stc
		print "#{$lang[41]}\n#{$lang[42]}\n"
		stc
		$stdin.gets
		exit
	end
	
end

begin
	stc
	print "Quick Word Learning Helper\n"
	print "v #{$version}\n"
	print "Released #{$reldate}\n"
	print "by Narzew\n"
	print "Product is FREEWARE.\n"
	print "All rights reserved.\n"
	stc
	QWLH.load_language
	loop do
		stc
		print "#{$lang[43]}\n0 - #{$lang[44]}\n1 - #{$lang[45]}\n2 - #{$lang[46]}\n"
		stc
		$mode = gets.chomp!.to_i
		case $mode
		when 0 then QWLH.run_helper
		when 1 then QWLH.run_wordlist_compiler
		when 2 then QWLH.run_language_editor
		else
			stc
			print "#{$lang[28]}\n#{$lang[29]}\n"
			stc
		end
	end
	
rescue => e
	stc
	print "#{$lang[47]} #{$lang[48]} \n#{e}\n"
	print "#{$lang[10]}.\n"
	stc
	$stdin.gets
	exit
end