class ErrorLog
  def self.print(*args)
    p *args
  end
end

class LispEvaluator
  class ChainHash
    def initialize hash,*args
      @hash=hash
      @chain=[hash]
      args.each_with_object hash.keys do |hash,keys|
        defkeys=hash.keys-keys
        unless defkeys.empty?
          keys.push *defkeys
          @chain.push hash
        end
      end
    end
    def next hash={}
      ChainHash.new hash,*chain
    end
    def []= key,value
      @hash[key]=value
    end
    def chain
      @chain
    end
    def length
      @chain.size
    end
    def [] key
      @chain.each do |hash|
        return hash[key] if hash.has_key? key
      end
      throw "undefined local variable or method `#{key}"
    end
    def update key,value
      hash=@chain.find do |hash| hash.has_key? key end
      if hash
        hash[key]=value
      else
        @hash[key]=value
      end
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
  class TailCall
    def initialize code,hash
      @code=code
      @hash=hash
    end
    def code
      @code
    end
    def hash
      @hash
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
      while true
        if code.class==::Symbol
          return hash[code]
        elsif code.class==Tree
          func=(run code.name,hash)
          ::ErrorLog.print hash.hash,code if func.nil?
          val=func.call hash,*code.args
          return val if val.class!=TailCall
          code=val.code
          hash=val.hash
        else
          return code
        end
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
    hash=ChainHash.new globals,hash.clone
    code=@codeparser.instance_eval(&block)
    val=run code,hash
    val.class==Quote ? val.unquote : val
  end

  def lisplambda hash,argument_list,code
    block=->(arghash,*args){
      hash=hash.next
      argument_list.zip(args).each{ |key,code|
        hash[key]=run code,arghash
      }
      TailCall.new code,hash
    }
    def block.arity= x
      @arity=x
    end
    def block.arity
      @arity
    end
    block.arity=argument_list.size
    block
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
