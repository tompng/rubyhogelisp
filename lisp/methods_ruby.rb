class LispEvaluator
  define_globals do
    def rb_call_for hash,obj,method,*blockargs
      rbobj=run(obj,hash)
      name=method.name
      args=method.args.map{|m|run(m,hash)}
      if blockargs.empty?
        rbobj.send(name,*args)
      else
        code=blockargs.pop
        evaluator=self
        block=->(*args){
          h=hash.next
          blockargs.zip(args).each{|key,val|
            h[key]=run(val,hash)
          }
          h[:self]=self
          evaluator.run(code,h)
        }
        def block.arity=(x)
          @arity=x
        end
        def block.arity
          @arity
        end
        block.arity=blockargs.size
        rbobj.send(name,*args,&block)
      end
    end
    globals[:send]=->(hash,obj,method,*blockargs){
      rb_call_for hash,obj,method,*blockargs
    }
    globals[:call]=->(hash,method,*blockargs){
      rb_call_for hash,:self,method,*blockargs
    }
    globals[:assign]=->(hash,*args){
      case args.size
      when 1 then
       obj=:self
       method=args.first
      when 2 then
        obj,method=args
      else
        throw 'argument error'
      end
      rbobj=run(obj,hash)
      name=method.name
      rbobj.send name.to_s+'=',run(method.args[0],hash)
    }
  end
end