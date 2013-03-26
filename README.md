rubyhogelisp
============

lisp-like language inside ruby

sample1

    require './lisp/lisp.rb'
    Lisp do
      (p (define (fact :n),(cond (eq :n,0),1,(mult :n,(fact (sub :n,1))))),(fact 5))
    end

sample2

    require './lisp/lisp.rb'
    require 'tweetstream'
    twitter_token={
      :CONSUMER_KEY       => 'MI',
      :CONSUMER_SECRET    => 'NA',
      :OAUTH_TOKEN        => 'MI',
      :OAUTH_TOKEN_SECRET => 'KE'
    }
    Lisp twitter_token do
      (progn\
        (send TweetStream,(configure),:config,
          (progn\
            (assign :config,(consumer_key :CONSUMER_KEY)),
            (assign :config,(consumer_secret :CONSUMER_SECRET)),
            (assign :config,(oauth_token :OAUTH_TOKEN)),
            (assign :config,(oauth_token_secret :OAUTH_TOKEN_SECRET))
          )
        ),
        (send TweetStream,(userstream),:status,
          (progn\
            (send :main,(print (send (send :status,user),name))),
            (send :main,(print " \n ")),
            (send :main,(print (send :status,(text)))),
            (send :main,(print "\n\n"))
          )
        )
      )
    end

