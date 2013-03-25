class LispEvaluator
  define_globals do
    globals[:list]=->(hash,*args){
      Quote.new Tree.list(*args.map{|x|run x,hash})
    }
    globals[:cons]=->(hash,a,b){
      a=run(a,hash)
      b=run(b,hash)
      a=a.unquote if a.class==Quote
      b=b.unquote if b.class==Quote
      Quote.new Tree.new a,b
    }
    globals[:car]=->(hash,t){
      tree=run(t,hash)
      tree=tree.unquote if tree.class==Quote
      if tree.left
        Quote.new tree.left
      end
    }
    globals[:cdr]=->(hash,t){
      tree=run(t,hash)
      tree=tree.unquote if tree.class==Quote
      if tree.right
        Quote.new tree.right
      end
    }
    globals[:quote]=->(hash,t){
      Quote.new t
    }
    globals[:atom]=->(hash,a){
      run(a,hash).class!=Tree
    }
  end
end