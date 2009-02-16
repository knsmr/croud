module Croud

  class Compiler

    def self.compile(asm)
      new(asm).compile
    end

    def initialize(asm)
      @asm = asm
      @inst = []
    end

    def compile
      @asm.split(/\n/).each do |line|
        op,num = line.split(/,/)
        case op
        when "push"   then @inst << :push << num.to_i(16)
        when "drop"   then @inst << :drop
        when "dup"    then @inst << :dup
        when "swap"   then @inst << :swap

        when "roll"   then @inst << :roll
        when "swit"   then @inst << :swit
        when "rot"    then @inst << :rot
        when "slide"  then @inst << :slide
        when "exp"    then @inst << :exp

        when "add"    then @inst << :add
        when "sub"    then @inst << :sub
        when "mul"    then @inst << :mul
        when "div"    then @inst << :div

        when "setl"   then @inst << :setl << num.to_i(16)
        when "jmpl"   then @inst << :jmpl << num.to_i(16)
        when "zjmpl"  then @inst << :zjmpl << num.to_i(16)
        when "nzjmpl" then @inst << :nzjmpl << num.to_i(16)

        when "puts"   then @inst << :puts
        when "putnum" then @inst << :putnum
        when "gets"   then @inst << :gets
        when "getnum" then @inst << :getnum

        end
      end
      @inst
    end
  end

end

if $0 == __FILE__
  asm = <<EOS
push,a
puts
setl,1
rot
exp
swit
EOS
  p Croud::Compiler.compile(asm)
end
