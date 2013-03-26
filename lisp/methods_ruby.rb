class LispEvaluator
  define_globals do
    globals[:send]=->(hash,obj,method,*blockargs){
      rbobj=run(obj,hash)
      name=method.name
      args=method.args.map{|m|run(m,hash)}
      if blockargs.empty?
        rbobj.send(name,*args)
      else
        code=blockargs.pop
        block=->(*args){
          h=hash.next
          blockargs.zip(args).each{|key,val|
            h[key]=run(val,hash)
          }
          run(code,h)
        }
        def block.arity=(x)
          arity=x
        end
        def block.arity
          arity
        end
        block.arity=blockargs.size
        rbobj.send(name,*args,&block)
      end
    }
    globals[:assign]=->(hash,obj,method){
      rbobj=run(obj,hash)
      name=method.name
      rbobj.send name.to_s+'=',run(method.args[0],hash)
    }
  end
end