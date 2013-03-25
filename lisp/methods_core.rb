class LispEvaluator
  define_lisp_methods do
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
    methods[:list]=->(hash,*args){
      Quote.new Tree.list(*args.map{|x|run x,hash})
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
    methods[:eq]=->(hash,a,b){
      run(a,hash)==run(b,hash)
    }
    methods[:atom]=->(hash,a){
      run(a,hash).class!=Tree
    }
    methods[:p]=->(hash,*a){
      p *a.map{|x|run x,hash}
    }
  end
end