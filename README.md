rubyhogelisp
============

lisp-like language inside ruby

sample1

    require './lisp/lisp.rb'
    Lisp(num:5) do
      (p (define (fact :n),(cond (eq :n,0),1,(mult :n,(fact (sub :n,1))))),(fact :num))
    end

sample2

    require './lisp/lisp.rb'
    require 'tweetstream'
    Lisp do
      (progn\
        (send TweetStream,(configure),:config,
          (progn\
            (assign :config,(consumer_key 'MI')),
            (assign :config,(consumer_secret 'NA')),
            (assign :config,(oauth_token 'MI')),
            (assign :config,(oauth_token_secret 'KE'))
          )
        ),
        (send TweetStream,(userstream),:status,
          (progn\
            (print (send (send :status,user),name),"\n"),
            (print (send :status,(text)),"\n\n")
          )
        )
      )
    end

