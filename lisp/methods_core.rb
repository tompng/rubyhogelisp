class LispEvaluator
  define_globals do
    globals[:define]=->(hash,func,code){
      argument_list=func.args
      hash[func.name]=->(arghash,*args){
        hash2=ChainHash.new hash
        argument_list.zip(args).each{ |key,code|
          hash2[key]=run code,arghash
        }
        hash2.compact!
        TailCall.new code,hash2
      }
      true
    }
    globals[:lambda]=->(hash,*args){
      code=args.pop
      argument_list=args
      ->(arghash,*args){
        hash=ChainHash.new hash
        argument_list.zip(args).each{ |key,code|
          hash[key]=run code,arghash
        }
        TailCall.new code,hash
      }
    }
    globals[:let]=->(hash,*args){
      code=args.pop
      hash=ChainHash.new hash
      (args.size/2).times do |i|
        key,valcode=args[2*i,2]
        hash[key]=run valcode,hash
      end
      TailCall.new code,hash
    }
    globals[:vars_dump]=->(hash,*args){
      p hash.hash
      nil
    }
    globals[:progn]=->(hash,*args){
      last=args.pop
      args.each do |arg|
        val=run arg,hash
      end
      TailCall.new last,hash
    }
    globals[:cond]=->(hash,a,b,c){
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
  end
end