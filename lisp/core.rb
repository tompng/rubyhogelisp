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
        "("+[name,*args].map(&:inspect).join(",")+")"
      else
        "["+left.inspect+","+right.inspect+"]"
      end
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
    def initialize methods
      @methods=methods
    end
    def defun name,*args
      code=args.pop
      argument_list=args
      @methods[name]=->(hash,*args){
        hash=ChainHash.new hash
        argument_list.zip(args).each{ |key,code|
          hash[key]=run code,hash
        }
        run code,hash
      }
      true
    end

    def quote code
      Quote.new code
    end

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
        @methods[code.name].call hash,*code.args
      else
        code
      end
    end
  end
  def initialize
    @methods={ }
    @codeparser=CodeParser.new @methods
  end
  def methods
    @methods
  end
  def define_lisp_methods(&block)
    self.instance_eval &block
  end

  def run(code,hash)
    @codeparser.run code,hash
  end
  def exec(hash,&block)
    run(@codeparser.instance_eval(&block),hash)
  end

  def self.lispevaluator
    @lispevaluator||=LispEvaluator.new
  end
  def self.globalvars
    @globalvars||={}
  end

  def self.exec(main,hash,&block)
    globalvars[:main]=main
    lispevaluator.exec(ChainHash.new(hash,globalvars),&block)
  end

  def self.define_lisp_methods(&block)
    lispevaluator.define_lisp_methods(&block)
  end
end

def Lisp(hash={},&block)
  LispEvaluator.exec(self,hash,&block)
end
