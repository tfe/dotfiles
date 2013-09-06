#!/usr/bin/ruby
require 'irb/ext/save-history'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:EVAL_HISTORY] = 200
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

IRB.conf[:PROMPT_MODE] = :SIMPLE

%w[rubygems utility_belt ap].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

begin
  # load wirble
  require 'wirble'

  # start wirble (with color)
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end


# Aliases
alias q exit

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end

def paste
  `pbpaste`
end

class Object
  
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
  
  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end

end

# http://codeidol.com/other/rubyckbk/Hashes/Building-a-Histogram/
module Enumerable
  def to_histogram
    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end
  def to_histogram_graph(char="#")
    histogram = self.to_histogram
    pairs = histogram.keys.collect { |x| [x, histogram[x]] }.sort
    largest_key_size = pairs.collect { |p| p[0].to_s.length }.max
    pairs.inject("") do |s,kv|
      puts "#{kv[0].to_s.ljust(largest_key_size)} |#{char*kv[1]}"
    end
  end
end


load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']