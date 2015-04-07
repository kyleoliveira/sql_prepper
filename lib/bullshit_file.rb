#!/usr/bin/env ruby

require_relative 'strict_tsv.rb'

# Converts a Tab-delimited file of database table insertions into a SQL file for Oracle.
class BullshitFile < StrictTsv

  attr_accessor :mode, :table, :primary_keys

  def initialize(filepath, query_mode, target_table, pk)
      super(filepath)
      @mode ||= query_mode
      @table ||= target_table
      @primary_keys ||= pk
  end

  class << self

    def supported_modes
      %w(insert update)
    end

    def fancify_cols(cols)
    cols.to_s.gsub(/[\[\]]/, '')
    end

    def update_str(line_hash)
      line_hash.to_a
               .to_s
               .gsub(/^[\[](.*)[\]]$/, '\1')
               .gsub(/[\[][\"]/, '\'')
               .gsub(/[\"], /, '\' = \'')
               .gsub(/[\]],/, '\',')
               .gsub(/[\]]$/, '\'')
               .gsub(/[\"]/, '')
    end

  end

  def format_line(line_hash)
    case @mode
      when :insert
        puts '  INSERT INTO'
        puts "    #{table} (#{self.class.fancify_cols(line_hash.keys) })".gsub(/[\"]/, '\'')
        puts "      VALUES (#{self.class.fancify_cols( line_hash.keys.collect{ |k| line_hash[k] } )})".gsub(/[\"]/, '\'')
      when :update
        puts "UPDATE #{table}"
        puts "  SET #{ self.class.update_str(line_hash.reject{|k, _| @primary_keys.any? { |pk| pk == k } }) }"
        print "  WHERE '#{@primary_keys.first}' = '#{line_hash[@primary_keys.first]}'"
        if @primary_keys.length > 1
          @primary_keys.rest.each do |k|
            print "\n  AND '#{k}' = '#{line_hash[k]}'"
          end
        end
        puts ';'
      else
        raise ArgumentError, "Supplied SQL mode (#{@mode}) is not supported!"
    end
  end

  def read_file
      parse{ |row| format_line(row) }
  end

  def header
      puts '-- KFS.....'
      puts '-- AUTHOR: Kyle Oliveira <kyle.oliveira@cornell.edu>'
      puts "-- DESC: Updates for the #{@table} table"
      puts
    case @mode
      when :insert
        puts 'INSERT ALL'
      else
    end
  end
  
  def footer
    case @mode
      when :insert
        puts 'SELECT 1 FROM dual;'
      else
    end
  end

end

