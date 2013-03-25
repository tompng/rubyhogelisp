class LispEvaluator
  define_globals do
    globals[:add]=->(hash,a,b){
      run(a,hash)+run(b,hash)
    }
    globals[:sub]=->(hash,a,b){
      run(a,hash)-run(b,hash)
    }
    globals[:mult]=->(hash,a,b){
      run(a,hash)*run(b,hash)
    }
    globals[:div]=->(hash,a,b){
      run(a,hash)/run(b,hash)
    }
    globals[:mod]=->(hash,a,b){
      run(a,hash)%run(b,hash)
    }
    globals[:lt]=->(hash,a,b){
      run(a,hash)<run(b,hash)
    }
    globals[:le]=->(hash,a,b){
      run(a,hash)>run(b,hash)
    }
  end
end