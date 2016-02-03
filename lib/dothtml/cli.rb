require 'trollop'
require 'dothtml/dot_task'

module Dothtml
  class CLI
    VERSION_STRING = "dothtml #{Dothtml::VERSION}"

    COMMANDS = {
      "build" => {
        "usage"    => "build [dotfile]",
        "synopsis" => <<-EOS
Builds the specified dotfile (or all .dot files, if not specified)
into .svg and .html files.  This is the default command if nothing
is specified on the command line.
        EOS
      },
    }

    COMMAND_NAMES = COMMANDS.keys + %w(version help)
    DEFAULT_COMMAND = "build"

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def execute
      parse_global_options
      parse_command_options
      execute_command
    end

    private

    attr_accessor :command

    def parse_global_options
      global_synopsis_parts = COMMANDS.each_value.flat_map do |v|
        [indent(v["usage"], 1), indent(v["synopsis"], 2)]
      end
      global_synopsis = "\nCommands:\n#{global_synopsis_parts.join("\n")}".chomp

      Trollop.options(args) do
        version  VERSION_STRING
        usage    "<command> [command_options]"
        synopsis global_synopsis
        stop_on  COMMAND_NAMES
      end
    end

    def parse_command_options
      self.command = (args.shift || DEFAULT_COMMAND).downcase
      Trollop.die "invalid command, '#{command}'" unless COMMAND_NAMES.include?(command)
      return unless COMMANDS.key?(command)

      command_options  = COMMANDS[command]
      command_synopsis = "\n#{indent(command_options["synopsis"], 1)}".chomp

      Trollop.options(args) do
        version  VERSION_STRING
        usage    command_options["usage"]
        synopsis command_synopsis
      end
    end

    def indent(string, amount)
      prefix = "  " * amount
      string.lines.map { |l| "#{prefix}#{l}" }.join
    end

    #
    # Command handlers
    #

    def execute_command
      send("#{command}_command")
    end

    def build_command
      files =
        if args.empty?
          Dir.glob("*.dot").sort
        else
          args.select { |a| a.end_with?(".dot") }
        end

      DotTask.new.build(files)
    end

    def version_command
      puts VERSION_STRING
      exit 0
    end

    def help_command
      Trollop.educate
    end
  end
end
