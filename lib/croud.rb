require 'croud/parse'
require 'croud/compiler'
require 'croud/vm'

module Croud
  
  def self.run(src)
    asm = Croud::Parse.parse(src)
    inst = Croud::Compiler.compile(asm)
    Croud::VM.run(inst)
  end

end
