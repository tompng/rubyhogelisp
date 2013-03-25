class LispEvaluator
  define_lisp_methods do
    methods[:assign]=->(hash,obj,method){
      rbobj=run(obj,hash)
      name=method.name
      rbobj.send name.to_s+'=',run(method.args[0],hash)
    }
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
    methods[:setq]=->(hash,key,value){
      hash.update key,run(value,hash)
    }
    methods[:defq]=->(hash,key){
      hash[key]=nil
    }
    methods[:progn]=->(hash,*args){
      val=nil
      args.each do |arg|
        val=run arg,hash
      end
      val
    }
    methods[:cond]=->(hash,a,b,c){
      if run a,hash
        run b,hash
      else
        run c,hash
      end
    }
    methods[:cons]=->(hash,a,b){
      a=run(a,hash)
      b=run(b,hash)
      a=a.unquote if a.class==Quote
      b=b.unquote if b.class==Quote
      Quote.new Tree.new a,b
    }
    methods[:car]=->(hash,t){
      tree=run(t,hash)
      tree=tree.unquote if tree.class==Quote
      if tree.left
        Quote.new tree.left
      end
    }
    methods[:cdr]=->(hash,t){
      tree=run(t,hash)
      tree=tree.unquote if tree.class==Quote
      if tree.right
        Quote.new tree.right
      end
    }
    methods[:quote]=->(hash,t){
      Quote.new t
    }
    methods[:eval]=->(hash,code){
      run(run(code,hash).unquote,hash)
    }
    methods[:mod]=->(hash,a,b){
      run(a,hash)%run(b,hash)
    }
    methods[:eq]=->(hash,a,b){
      run(a,hash)==run(b,hash)
    }
    methods[:mult]=->(hash,a,b){
      run(a,hash)*run(b,hash)
    }
    methods[:div]=->(hash,a,b){
      run(a,hash)/run(b,hash)
    }
    methods[:sub]=->(hash,a,b){
      run(a,hash)-run(b,hash)
    }
    methods[:add]=->(hash,a,b){
      run(a,hash)+run(b,hash)
    }
    methods[:lt]=->(hash,a,b){
      run(a,hash)<run(b,hash)
    }
    methods[:le]=->(hash,a,b){
      run(a,hash)>run(b,hash)
    }
    methods[:atom]=->(hash,a){
      run(a,hash).class!=Tree
    }
    methods[:p]=->(hash,*a){
      p *a.map{|x|run x,hash}
    }
  end
end