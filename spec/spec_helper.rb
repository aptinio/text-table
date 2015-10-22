$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'text-table'
require 'rspec'
require 'rspec/autorun'

def deindent(table)
  table.gsub(/^\s*/, '')
end

def decolor(table)
  table.gsub(/\033\[[^m]+m/, '')
end

TERMINAL_COLOR = {
  :black =>   0,
  :red =>     1,
  :green =>   2,
  :yellow =>  3,
  :blue =>    4,
  :magenta => 5,
  :cyan =>    6,
  :white =>   7
}

def colorize(text, foreground = nil, background = nil)
  codes = [ ]
  codes << 30 + TERMINAL_COLOR[foreground] if foreground
  codes << 40 + TERMINAL_COLOR[background] if background
  "\x1b[#{codes.join(';')}m#{text}\x1b[0m"
end
