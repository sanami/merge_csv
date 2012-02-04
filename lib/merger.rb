# encoding: UTF-8
require File.dirname(__FILE__) + '/config.rb'
require 'field_constants.rb'

class Merger
  attr_accessor :merge_data

  def initialize
    @merge_data = {}
    #@limit = 100
  end

  def process_main(main_name)
    count = 0
    CSV.foreach(main_name, :headers => true, :encoding => 'UTF-8') do |cell|
      yield cell
      count += 1
      #break if count == @limit
    end
  end

  def load_merge(merge_name)
    CSV.foreach(merge_name, :headers => true, :encoding => 'UTF-8') do |cell|
      id = cell['ID1']
      puts @merge_data[id], cell, '---' if @merge_data.has_key?(id) && @merge_data[id] != cell
      @merge_data[id] = cell
    end
    puts "Loaded #{@merge_data.size} from #{merge_name}"
  end

  def mark_as_used(merge_cell)
    merge_cell['__used__'] = true
  end

  def is_used?(merge_cell)
    merge_cell['__used__'] == true
  end

  def run(params)
    pp params
    raise "Bad params" unless params[:main_name] && params[:result_name]

    # Saved result
    result_csv = CSV.open(params[:result_name], "wb")
    apply_count = 0
    count = 0

    # Main data
    process_main(params[:main_name]) do |cell|
      result_csv << cell.headers if count == 0

      id = cell['Id']
      if @merge_data.has_key? id
        yield cell, @merge_data[id]

        # To find not merged
        mark_as_used(@merge_data[id])
        apply_count += 1
      end

      result_csv << cell
      count += 1
    end
    result_csv.close

    # Warnings
    puts "Not merged:"
    @merge_data.each do |id, merge_cell|
      unless is_used?(merge_cell)
        puts "\t#{id}"
      end
    end

    puts "Merged #{apply_count} rows"
    puts "Saved #{count} to #{File.absolute_path params[:result_name]}"
  end
end
