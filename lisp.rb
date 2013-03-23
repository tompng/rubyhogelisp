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
    @methods[:assign]=->(hash,obj,method){
      rbobj=run(obj,hash)
      name=method.name
      rbobj.send name.to_s+'=',run(method.args[0],hash)
    }
    @methods[:send]=->(hash,obj,method,*blockargs){
      rbobj=run(obj,hash)
      name=method.name
      args=method.args.map{|m|run(m,hash)}
      if blockargs.empty?
        rbobj.send(name,*args)
      else
        code=blockargs.pop
        block=->(*args){
          h=ChainHash.new hash
          blockargs.zip(args).each{|key,val|
            h[key]=run(val,hash)
          }
          run(code,h)
        }
        outerblock=->(*args){
          block.call *args
        }
        def outerblock.arity=(x)
          @arity=x
        end
        def outerblock.arity
          @arity
        end
        outerblock.arity=blockargs.size
        rbobj.send(name,*args,&outerblock)
      end
    }
    @methods[:setq]=->(hash,key,value){
      hash.update key,run(value,hash)
    }
    @methods[:defq]=->(hash,key){
      hash[key]=nil
    }
    @methods[:progn]=->(hash,*args){
      val=nil
      args.each do |arg|
        val=run arg,hash
      end
      val
    }
    @methods[:cond]=->(hash,a,b,c){
      if run a,hash
        run b,hash
      else
        run c,hash
      end
    }
    @methods[:cons]=->(hash,a,b){
      a=run(a,hash)
      b=run(b,hash)
      a=a.unquote if a.class==Quote
      b=b.unquote if b.class==Quote
      Quote.new Tree.new a,b
    }
    @methods[:car]=->(hash,t){
      tree=run(t,hash)
      tree=tree.unquote if tree.class==Quote
      if tree.left
        Quote.new tree.left
      end
    }
    @methods[:cdr]=->(hash,t){
      tree=run(t,hash)
      tree=tree.unquote if tree.class==Quote
      if tree.right
        Quote.new tree.right
      end
    }
    @methods[:eval]=->(hash,code){
      run(run(code,hash).unquote,hash)
    }
    @methods[:mod]=->(hash,a,b){
      run(a,hash)%run(b,hash)
    }
    @methods[:eq]=->(hash,a,b){
      run(a,hash)==run(b,hash)
    }
    @methods[:mult]=->(hash,a,b){
      run(a,hash)*run(b,hash)
    }
    @methods[:minus]=->(hash,a,b){
      run(a,hash)-run(b,hash)
    }
    @methods[:add]=->(hash,a,b){
      run(a,hash)+run(b,hash)
    }
    @methods[:lt]=->(hash,a,b){
      run(a,hash)<run(b,hash)
    }
    @methods[:le]=->(hash,a,b){
      run(a,hash)>run(b,hash)
    }
  end
  def run(code,hash)
    @codeparser.run code,hash
  end
  def exec(hash,&block)
    run(@codeparser.instance_eval(&block),hash)
  end
  def self.exec(main,hash,&block)
    @lispevaluator||=LispEvaluator.new
    @globalvars||={}
    @globalvars[:main]=main
    @lispevaluator.exec(ChainHash.new(hash,@globalvars),&block)
  end
end

def Lisp(hash={},&block)
  p LispEvaluator.exec(self,hash,&block)
end
