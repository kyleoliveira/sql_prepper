#!/usr/bin/env ruby
require_relative '../lib/sql_prepper'

$stderr.sync = true
require 'optparse'

# == Default Options ==
mode = nil
in_file = nil
out_file = nil
table  = nil
pk    = []

# == Parse arguments ==
ARGV.options do |opts|
  opts.banner = 'Usage: sql_prepper.rb [options]...'
  opts.on('-i', '--input=val',
          'The input file name', String) do |val|
    in_file = val
  end
  opts.on('-o', '--output=val',
          'The output file name', String) do |val|
    out_file = val
  end
  opts.on('-m', '--mode=val',
          "The SQL operation to perform. Supported operations: #{BullshitFile::supported_modes}", String) do |val|
    mode = val.to_sym
  end
  opts.on('-t', '--table=val',
          'The name of the table to perform the operation on', String) do |val|
    table = val
  end
  opts.on('-p', '--pk x,y,z',
          'The primary keys to use for the UPDATE operation.', Array) do |val|
    pk = val
  end
  opts.on('-v', '--verbose',
          'Increases verbosity') do
    $VERBOSE = true
  end
  opts.on_tail('-h', '--help',
               'Displays help') do
    puts opts
    exit
  end
  opts.parse!
end


# == Do it to it ==

raise ArgumentError, 'Mode is required!' if (mode.nil? || mode.empty?)
raise ArgumentError, "Mode is unsupported! Given: #{mode} Acceptable: #{BullshitFile::supported_modes}" if (mode.nil? || mode.empty?)
raise ArgumentError, 'Bullshit file is required!' if (in_file.nil? || in_file.empty?)
raise ArgumentError, 'Table is required!' if (table.nil? || table.empty?)
raise ArgumentError, 'Primary key column names are required when performing an update!' if ((mode == :update) && (pk.nil? || pk.empty?))


bs = BullshitFile.new in_file, mode, table, pk

$stdout.reopen(out_file, 'w')
$stdout.sync = true

# Print out the header
bs.header

# Loop through the file and spit out the lines
bs.read_file

# Print the footer
bs.footer

$stderr.reopen($stdout)
