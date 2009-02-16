require 'croud/stack'

module Croud

  class VM

    def self.run(inst)
      new(inst).run
    end

    def initialize(inst)
      @inst = inst
      @label = {}
    end

    def mk_jump_table
      @inst.each_with_index do |op, i|
        @label[@inst[i + 1]] = i if op == :setl
      end
    end

    def run
      self.mk_jump_table
      pc = 0
      s = Croud::Stack.new
      while pc < @inst.size
        op = @inst[pc]

        case op
        when :push
          pc += 1
          num = @inst[pc]
          s.stc << num
        when :drop
          s.stc.pop
        when :dup
          s.stc << s.stc.last
        when :swap
          x, y = s.stc.pop, s.stc.pop
          s.stc << x << y
        when :roll
          s.stc << s.stc.delete_at(-3)
        when :swit
          s.switch
        when :rot
          s.rotate
        when :slide
          s.slide
        when :exp
          s.expand
        when :add
          s.stc << s.stc.pop + s.stc.pop
        when :sub
          y, x = s.stc.pop, s.stc.pop
          s.stc << x - y
        when :mul
          s.stc << s.stc.pop * s.stc.pop
        when :div
          y, x = s.stc.pop, s.stc.pop
          s.stc << x / y
        when :jmpl
          pc = @label[@inst[pc + 1]]
        when :zjmpl
          pc = @label[@inst[pc + 1]] if s.stc.last == 0
        when :nzjmpl
          pc = @label[@inst[pc + 1]] if s.stc.last != 0
        when :puts
          print s.stc.last.chr
        when :gets
          s.stc << $stdin.gets.chomp!
        when :putnum
          print s.stc.last
          puts
        when :getnum
          s.stc << $stdin.gets.chomp!.to_i
        end
        pc += 1
      end
    end
  end
end

if $0 == __FILE__
  Croud::VM.run([:push,72,:push,73,:swap,:puts,:drop,:puts])
  puts
end
