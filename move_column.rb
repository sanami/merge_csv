# In the excel database, I think we should transfer all the entries like the:
# ("biked" is the past tense of: bike) so that they appear under concept and not examples.
require 'pp'
require 'csv'
require_relative 'field_constants.rb'

unless ARGV.count == 2
	puts "ruby #{$0} MAIN_CSV RESULT_CSV"
	exit
end

main_name = ARGV[0]
result_name = ARGV[1]
pp ARGV

result_csv = CSV.open(result_name, "wb")

apply_count = 0
save_count = 0
rx_concept = /".+".+:.+/

CSV.foreach(main_name, :encoding => 'UTF-8') do |cell|
	if cell[J] =~ rx_concept # An example of how this word is used:
		puts cell[J]
		apply_count+=1
	end

	result_csv << cell
	save_count += 1
end
result_csv.close

puts "Saved #{save_count} to #{File.absolute_path result_name}"
puts "Applied #{apply_count}"
