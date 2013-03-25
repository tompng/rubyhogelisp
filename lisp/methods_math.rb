class LispEvaluator
  define_lisp_methods do
    methods[:add]=->(hash,a,b){
      run(a,hash)+run(b,hash)
    }
    methods[:sub]=->(hash,a,b){
      run(a,hash)-run(b,hash)
    }
    methods[:mult]=->(hash,a,b){
      run(a,hash)*run(b,hash)
    }
    methods[:div]=->(hash,a,b){
      run(a,hash)/run(b,hash)
    }
    methods[:mod]=->(hash,a,b){
      run(a,hash)%run(b,hash)
    }
    methods[:lt]=->(hash,a,b){
      run(a,hash)<run(b,hash)
    }
    methods[:le]=->(hash,a,b){
      run(a,hash)>run(b,hash)
    }
  end
end