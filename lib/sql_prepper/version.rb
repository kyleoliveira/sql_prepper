require_relative '../bullshit_file.rb'

module SQLPrepper

  class << self

    # The current version number
    VERSION = 1.0

    # @param [Hash] selected_options The options selected
    def parse_opts(selected_options)
      ARGV.options do |opts|
        opts.banner = 'Usage: sql_prepper.rb [options]...'
        opts.on('-i', '--input=val',
                'The input file name', String) do |val|
          selected_options[:in_file] = val
        end
        opts.on('-o', '--output=val',
                'The output file name', String) do |val|
          selected_options[:out_file] = val
        end
        opts.on('-m', '--mode=val',
                "The SQL operation to perform. Supported operations: #{BullshitFile::supported_modes}", String) do |val|
          selected_options[:mode] = val.to_sym
        end
        opts.on('-t', '--table=val',
                'The name of the table to perform the operation on', String) do |val|
          selected_options[:table] = val
        end
        opts.on('-j', '--jira=val',
                'The JIRA number', String) do |val|
          selected_options[:jira] = val
        end
        opts.on('-n', '--version-number',
                'Add a version number (insert only)') do
          selected_options[:version_number] = true
        end
        opts.on('-p', '--pk x,y,z',
                'The primary keys to use for the UPDATE operation.', Array) do |val|
          selected_options[:pk] = val
        end
        opts.on('-g', '--guids x,y,z',
                'Columns that are not defined and should be set by sys_guid().', Array) do |val|
          selected_options[:guid_cols] = val
        end
        opts.on('-v', '--verbose',
                'Increases verbosity') do
          $VERBOSE = true
        end
        opts.on('-e', '--ignore-empty',
                "Ignore empty column entries during an UPDATE operation. Default: #{selected_options[:ignore_empty]}") do
          selected_options[:ignore_empty] = true
        end
        opts.on_tail('-h', '--help',
                     'Displays help') do
          puts opts
          exit
        end
        opts.parse!
      end

      verify_opts(selected_options)
    end

    # @param [Hash] options The options selected
    def verify_opts(options)
      raise ArgumentError, 'Mode is required!' if (options[:mode].nil? || options[:mode].empty?)
      raise ArgumentError, "Mode is unsupported! Given: #{options[:mode]} Acceptable: #{BullshitFile::supported_modes}" if (options[:mode].nil? || options[:mode].empty?)
      raise ArgumentError, 'Bullshit file is required!' if (options[:in_file].nil? || options[:in_file].empty?)
      raise ArgumentError, 'Table is required!' if (options[:table].nil? || options[:table].empty?)
      raise ArgumentError, 'Primary key column names are required when performing an update!' if ((options[:mode] == :update) && (options[:pk].nil? || options[:pk].empty?))
    end

  end
end
