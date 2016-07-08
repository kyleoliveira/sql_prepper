#!/usr/bin/env ruby
require_relative '../lib/sql_prepper'

$stderr.sync = true
require 'optparse'

# == Default Options ==
options = {
  mode: nil,
  in_file: nil,
  out_file: nil,
  table: nil,
  ignore_empty: false,
  pk: [],
  guid_cols: [],
  jira: nil,
  version_number: nil
}
SQLPrepper::parse_opts(options)

# == Do it to it ==

bs = BullshitFile.new options[:in_file], options[:mode], options[:table], options[:pk], options[:ignore_empty], options[:guid_cols], options[:jira], options[:version_number]

$stdout.reopen(options[:out_file], 'w')
$stdout.sync = true

# Print out the header
bs.header

# Loop through the file and spit out the lines
bs.read_file

# Print the footer
bs.footer

$stderr.reopen($stdout)
