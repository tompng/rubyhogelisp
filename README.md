rubyhogelisp
============

lisp-like language in ruby

sample1

    require './lisp/lisp.rb'
    Lisp(num:5) do
      (p (define (fact :n),(ifelse (eq :n,0),1,(mult :n,(fact (sub :n,1))))),(fact :num))
    end

sample2

    require './lisp/lisp.rb'
    require 'sinatra'
    Lisp do
      (let :x,1,
        (call (get '/'),
          (progn\
            (set :x,(add :x,1)),
            (send (list (call params),:x),(to_s))
          )
        )
      )
    end

sample3
    
    (define (func :arg1,:arg2),(lisp_code))

    sleep 3
    (call (sleep 3))

    self.foo="bar"
    (assign (foo "bar"))

    hoge.qwerty=3
    (assign :hoge,(querty 3))

    hoge.piyo x,y do |a,b| lispcode end
    (send :hoge (piyo :x,:y),:a,:b,(lispcode))

