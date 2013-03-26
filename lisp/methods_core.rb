class LispEvaluator
  define_globals do
    globals[:define]=->(hash,func,code){
      hash[func.name]=lisplambda(hash,func.args,code)
    }
    globals[:lambda]=->(hash,*args){
      code=args.pop
      argument_list=args
      lisplambda(hash,argument_list,code)
    }
    globals[:let]=->(hash,*args){
      code=args.pop
      hash=hash.next
      (args.size/2).times do |i|
        key,valcode=args[2*i,2]
        hash[key]=run valcode,hash
      end
      TailCall.new code,hash
    }
    globals[:set]=->(hash,*args){
      (args.size/2).times do |i|
        key,code=args[2*i,2]
        hash.update key,run(code,hash)
      end
      nil
    }
    globals[:progn]=->(hash,*args){
      last=args.pop
      args.each do |arg|
        val=run arg,hash
      end
      TailCall.new last,hash
    }
    globals[:ifelse]=->(hash,a,b,c){
      if run a,hash
        TailCall.new b,hash
      else
        TailCall.new c,hash
      end
    }
    globals[:eval]=->(hash,code){
      TailCall.new run(code,hash).unquote,hash
    }
    globals[:eq]=->(hash,a,b){
      run(a,hash)==run(b,hash)
    }
    globals[:p]=->(hash,*a){
      p *a.map{|x|run x,hash}
      nil
    }
    globals[:print]=->(hash,*a){
      print *a.map{|x|run x,hash}
      nil
    }
  end
end