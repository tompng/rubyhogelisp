class LispEvaluator
  define_lisp_methods do
    methods[:send]=->(hash,obj,method,*blockargs){
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
          arity=x
        end
        def outerblock.arity
          arity
        end
        outerblock.arity=blockargs.size
        rbobj.send(name,*args,&outerblock)
      end
    }
    methods[:assign]=->(hash,obj,method){
      rbobj=run(obj,hash)
      name=method.name
      rbobj.send name.to_s+'=',run(method.args[0],hash)
    }
  end
end