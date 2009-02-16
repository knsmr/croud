require "strscan"

SYMS = {" " => 0, "(" => 1, ")" => 2, "_" => 3}

CLOUD_SHAPE = {"5b2" => "1", "582" => "2", "17a" => "3",
  "5fb2" => "4", "17fa" => "5"}

OPNUM = {11 => :push, 12 => :drop, 13 => :dup, 14 => :swap,
  21 => :roll, 22 => :swit, 23 => :rot, 24 => :slide, 25 => :exp,
  31 => :add, 32 => :sub, 33 => :mul, 34 => :div,
  41 => :setl, 42 => :jmpl, 43 => :zjmpl, 44 => :nzjmpl,
  51 => :puts, 52 => :gets, 53 => :putnum, 54 => :getnum}

module Croud
  class Parse

    def self.parse(src)
      new(src).parse
    end

    def initialize(src)
      @src = src.split(/\n/)
      @asm = ""
    end

    def parse
      nums = inst = ""
      
      while line = @src.shift
        next if line !~ /[\(\) _]/
        nums += lpair2num(line, @src.shift)
      end
      s = StringScanner.new(nums)
      while cld = s.scan(/0*([15][^2a]+[2a])/)  # each cloud
        if cld =~ /5(..)a/ # numeric literal
          inst += cld2num($1).to_s(16)
        else
          cld.delete!("0")
          inst += CLOUD_SHAPE[cld].to_s
        end
      end

      s = StringScanner.new(inst)
      while op = s.scan(/\d\d/)
        @asm += OPNUM[op.to_i].to_s
        if (op == "11") || (op == "41") || (op == "42") || (op == "43") || (op == "44") 
          n = s.scan(/[0-9a-f]/)
          @asm += ","
          @asm += n
        end
        @asm += "\n"
      end
      @asm
    end

    def lpair2num(*lines)
      ul,dl = *lines
      nums = ""
      
      ul.split(//).zip(dl.split(//)).each do |pair|
        nums += pair2num(*pair)
      end
      nums
    end

    def pair2num(*pair)
      u,d = *pair
      
      if (u =~ /[ \(\)_]/) && (u =~ /[ \(\)_]/)
        num = SYMS[u] * 4 + SYMS[d]
      else
        raise "parse error"
      end
      num.to_s(16)
    end

    def cld2num(s)
      s.gsub("0","00").gsub("c","10").gsub("3","01").gsub("f","11").to_i(2)
    end
  end
end

if $0 == __FILE__
#  puts Croud::Parse.parse(ARGF.read)
  src = <<EOS
()  ()  ( _) ()  ()  (__)  ()  ()  (_)  () 
(_) (_) (__) (_) (_) (  ) (_) (_) (__)  (_)
EOS
  puts Croud::Parse.parse(src)
end

=begin
Some rules:

 (
 ( = (( = 1 *4 + 1 = 5

 )
 _ = )_ = 2 * 4 + 3 = 11 = 0xb

 Therefore,

 ()
 (_)  1 :5b2
 
 ()
 ( )  2 :582
 
  ()
 (_)  3 :17a
 
 (_)
 (__) 4 :5fb2
 
  (_)
 (__) 5 :17fa

 Numerics

 ( _)
 (_ )  :53ca  -> 3c -> 01,10 -> 0x6

 ( _)
 (  )  :50ca -> 0c > 0,10 -> 0x3


=end

