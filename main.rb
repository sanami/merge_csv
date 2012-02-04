require 'pp'
require 'csv'
require_relative 'field_constants.rb'

unless ARGV.count == 3
	puts "ruby #{$0} MAIN_CSV MERGE_CSV RESULT_CSV"
	exit
end

main_name = ARGV[0]
merge_name = ARGV[1]
result_name = ARGV[2]
pp ARGV

# Загрузить список обновлений
all_sounds = CSV.read(merge_name, :encoding => 'UTF-8')
count = 0
all_sounds = all_sounds.inject(Hash.new) do |memo, row|
	if row[0] && (!(row[1] =~ /DUP/i))
		memo[row[0]] = row[1]
		count+=1
		if row.size != 2
			puts "#{row.size}: #{row.join('|')}"
		end
	end
	memo
end
puts "Loaded #{count} from #{merge_name}"
#pp all_sounds

result_csv = CSV.open(result_name, "wb")

apply_count = 0
save_count = 0
CSV.foreach(main_name, :encoding => 'UTF-8') do |cell|
	sound = all_sounds[cell[J]] # An example of how this word is used:
	if sound
		# Вставить новое значение
		cell[G] = sound + '.mp3' # Listen to the example
		# Обновить время модификации
		cell[B] = Time.now.strftime '%Y-%m-%dT%H:%M:%S'
		apply_count+=1
	end
	result_csv << cell
	save_count += 1
end
result_csv.close

puts "Saved #{save_count} to #{File.absolute_path result_name}"
puts "Applied #{apply_count}"
