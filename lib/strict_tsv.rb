#!/usr/bin/env ruby

# Parses a Tab-delimited file
# Based off of http://stackoverflow.com/questions/4404787/whats-the-best-way-to-parse-a-tab-delimited-file-in-ruby
class StrictTsv
    
    attr_reader :filepath
    
    def initialize(filepath)
        @filepath = filepath
    end
    
    def parse
        open(filepath) do |f|
            headers = f.gets.strip.split("\t")
            f.each do |line|
                fields = Hash[headers.zip(line.chomp.split("\t"))]
                yield fields
            end
        end
    end
    
end

