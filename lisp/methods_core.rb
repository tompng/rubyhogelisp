class LispEvaluator
  define_globals do
    globals[:defun]=->(hash,name,*args){
      code=args.pop
      argument_list=args
      hash[name]=->(hash,*args){
        hash=ChainHash.new hash
        argument_list.zip(args).each{ |key,code|
          hash[key]=run code,hash
        }
        run code,hash
      }
      true
    }

    globals[:setq]=->(hash,key,value){
      hash.update key,run(value,hash)
    }
    globals[:defq]=->(hash,key){
      hash[key]=nil
    }
    globals[:progn]=->(hash,*args){
      val=nil
      args.each do |arg|
        val=run arg,hash
      end
      val
    }
    globals[:cond]=->(hash,a,b,c){
      if run a,hash
        run b,hash
      else
        run c,hash
      end
    }
    globals[:eval]=->(hash,code){
      run(run(code,hash).unquote,hash)
    }
    globals[:eq]=->(hash,a,b){
      run(a,hash)==run(b,hash)
    }
    globals[:p]=->(hash,*a){
      p *a.map{|x|run x,hash}
    }
  end
end