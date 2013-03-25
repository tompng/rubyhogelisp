class LispEvaluator
  class ChainHash
    def initialize parent=nil,hash={}
      @parent=parent
      @hash=hash
    end
    def []= key,value
      @hash[key]=value
    end
    def parent
      @parent
    end
    def hash
      @hash
    end
    def [] key
      if @hash.has_key? key
        @hash[key]
      else
        @parent[key]
      end
    end
    def has_key?
      return true if @hash.has_key?
      @parent.has_key if @parent
    end
    def update key,value
      target=self
      while target.class==ChainHash
        if target.hash.has_key? key
          target[key]=value
          return
        end
        target=target.parent
      end
      self[key]=value
    end
  end
  class Quote
    def initialize obj
      @obj=obj
    end
    def unquote
      @obj
    end
    def inspect
      @obj.inspect
    end
    def to_a
      unquote.to_a
    end
  end
  class Tree
    def initialize a,b
      @left=a
      @right=b
    end
    def left
      @left
    end
    def right
      @right
    end
    def name
      left
    end
    def args
      if right.nil?
        []
      else
        [right.left,*right.args]
      end
    end
    def !
      Quote.new self
    end
    def inspect
      if list?
        "("+as_list.map(&:inspect).join(", ")+")"
      else
        to_a.inspect
      end
    end
    def as_list
      if right.class==Tree
        [left,*right.as_list]
      else
        [left]
      end
    end
    def to_a
      [
        left.class==Tree ? left.to_a : left,
        right.class==Tree ? right.to_a : right
      ]
    end
    def list?
      right.nil?||(right.class==Tree&&right.list?)
    end
    def self.list *args
      if args.empty?
        nil
      else
        Tree.new args[0],list(*args[1..-1])
      end
    end
  end
  class CodeParser < BasicObject

    def Q code
      Quote.new code
    end

    def L *args
      Tree.list *args
    end

    def D a,b
      Tree.new a,b
    end

    def method_missing name,*args
      Tree.list name,*args
    end

    def run code,hash
      if code.class==::Symbol
        hash[code]
      elsif code.class==Tree
        (run code.name,hash).call hash,*code.args
      else
        code
      end
    end
  end
  def initialize
    @codeparser=CodeParser.new
  end
  def globals
    @globals||={}
  end
  def define_globals(&block)
    self.instance_eval &block
  end

  def run(code,hash)
    @codeparser.run code,hash
  end
  def exec(main,hash,&block)
    globals[:main]=main
    hash=ChainHash.new(hash,globals)
    code=@codeparser.instance_eval(&block)
    val=run code,hash
    val.class==Quote ? val.unquote : val
  end

  def self.lispevaluator
    @lispevaluator||=LispEvaluator.new
  end

  def self.exec(main,hash,&block)
    lispevaluator.exec(main,hash,&block)
  end

  def self.define_globals(&block)
    lispevaluator.define_globals(&block)
  end
end

def Lisp(hash={},&block)
  LispEvaluator.exec(self,hash,&block)
end
