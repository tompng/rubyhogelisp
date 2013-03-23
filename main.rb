require './lisp.rb'
require 'tweetstream'
twitter_token={
  CONSUMER_KEY:'hoge',
  CONSUMER_SECRET:'piyo',
  OAUTH_TOKEN:'foo',
  OAUTH_TOKEN_SECRET:'bar'
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


# Lisp do (cons 1,2) end
# Lisp do !(cond (eq :x,0),"zero","nonzero") end
# Lisp do (cdr (cons 1,(cons 2,(cons 3,(cons 4,nil))))) end
# Lisp do (cond true,(cond false,(cons 1,2),(cons 3,4)),(cons 5,6)) end
# Lisp do
# (progn\
#   (defun :fact,:x,(cond (eq :x,0),1,(mult :x,(fact (minus :x,1))))),
#   (defun :abs,:x,(cond (lt :x,0),(minus 0,:x),:x)),
#   (defun :sqrtrec,:x,:y,:d,
#     (cond (lt :d,0.0000001),
#       :y,
#       (cond (lt (mult :y,:y),:x),
#         (sqrtrec :x,(add :y,:d),(mult :d,0.5)),
#         (sqrtrec :x,(minus :y,:d),(mult :d,0.5))
#       )
#     )
#   )
# )
# end
# Lisp do
# (progn\
#   (defun :sqrt,:x,(sqrtrec :x,:x,:x)),
#   (defun :square,(mult :x,:x)),
#   (fact 5),
#   (eval !(fact 5)),
#   (defun :list_len,:list,(cond :list,(add 1,(list_len (cdr :list))),0)),
#   (list_len !L(hoge,1,2,3)),
#   (eval !(fact 5)),
#   (eval !D(:fact,D(4,nil))),
#   (send "hogehoge",(split 'o')),
#   (setq :arr,[0,1,2,3,4,5,6,7,8,9]),
#   (send :arr,(select),:x,(eq (mod :x,2),0)),
#   (send :main,(p (sqrt 2)))
# )
# end
