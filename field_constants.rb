##
# Константы, названия столбцов A-Z, AA-ZZ
def fields
	#('A'..'Z').each_with_index { |column, i| eval "#{column} = #{i}" } #p A, B, O

	s = 'A'
	n = 0
	while s != 'AA'
		#print s, ' '
		eval "#{s} = #{n}"

		s.succ!
		n += 1
	end

	#p A, B, Z, AA, ZZ
end

fields
