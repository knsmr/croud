module Croud

  class Stack
    
    def initialize(n=2)
      @stc = []
      n.times do
        @stc << []
      end
      @cur = 0
    end
    
    def stc
      @stc[@cur]
    end
    
    def switch
      @stc[@cur], @stc[@cur + 1] = @stc[@cur + 1], @stc[@cur]
    end

    def expand
      @stc << []
    end
    
    def slide
      @stc[@cur + 1] << @stc[@cur].pop
    end

    def rotate
      @stc << @stc.shift
    end

  end

end

