# encoding: UTF-8
require 'spec_helper'
require 'merger.rb'

describe Merger do
  #subject do
  #  Merger.new :main_file => fixtures('1')
  #end
  let(:main_file) { fixture('keywords-10-29.csv') }
  let(:merge_file) { fixture('20111209.csv') }
  let(:merge_file2) { fixture('20120203.csv') }
  let(:result_file) { ROOT('tmp/merge_result.csv') }

  it "should load merge file" do
    subject.load_merge merge_file
    subject.merge_data.should_not be_empty
  end

  it "should process main file" do
    ok = false
    subject.process_main(main_file) do |cell|
      pp cell
      cell[A].should == cell['Date de création']
      ok = true
      break
    end
    ok.should == true
  end

  def set(cell, field, value, silent = false)
    if cell[field] != value
      puts cell[field], value, '---' unless silent
      cell[field] = value
    end
  end

  it "should run" do
    ok = false

    # Data to merge
    subject.load_merge merge_file
    subject.load_merge merge_file2

    subject.run :main_name => main_file, :result_name => result_file do |cell, merge|
      #pp cell, merge
      #pp cell.headers
      #pp merge.headers

      set cell, H, merge["keyword"]
      #set cell, F, merge["grammar, context"]
      set cell, M, merge["An example of how this word is used:"]
      set cell, L, merge["French"], true
      set cell, N, merge["French translation/meaning of the English example"]

      # Modification time
      cell[B] = Time.now.strftime '%Y-%m-%dT%H:%M:%S'

      ok = true
    end
    ok.should == true
  end

end

