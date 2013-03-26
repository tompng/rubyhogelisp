require './lisp/lisp.rb'


Lisp do (define (inf1 :x),(progn 1,(inf2 1,2))) end
Lisp do (define (inf2 :y,:z),(inf1 1)) end

Lisp do
(progn\
  (define (times_rec :n,:m,:func),
    (cond (eq :n,:m),
      nil,
      (progn (func :n),(times_rec (add :n,1),:m,:func))
    )
  ),
  (define (times :n,:func),
    (times_rec 0,:n,:func)
  )
)
end

Lisp do
(times 100,
  (lambda :i,
    (p :i)
  )
)
end


Lisp do 
(p\
  (cons 1,2),
  !(cond (eq :x,0),"zero","nonzero"),
  (quote (cond (eq :x,0),"zero","nonzero")),
  (cdr (cons 1,(cons 2,(cons 3,(cons 4,nil))))),
  (cond true,(cond false,(cons 1,2),(cons 3,4)),(cons 5,6))
)
end
Lisp do
(progn\
  (define (fact :x),(cond (eq :x,0),1,(mult :x,(fact (sub :x,1))))),
  (define (abs :x),(cond (lt :x,0),(sub 0,:x),:x)),
  (define (sqrtrec :x,:y,:n),
    (cond (eq :n,0),
      :y,
      (sqrtrec :x,(add :y,(div (sub (div :x,:y),:y),2.0)),(sub :n,1))
    )
  ),
  (define (sqrt :x),(sqrtrec :x,:x,10))
)
end
Lisp do (p (sqrt 2)) end
Lisp do
(progn\
  (define (square :x),(mult :x,:x)),
  (define (list_len :list),(cond :list,(add 1,(list_len (cdr :list))),0)),
  (p\
    (fact 5),
    (eval !(fact 5)),
    (list_len !L(hoge,1,2,3)),
    (eval !(fact 5)),
    (eval !D(:fact,D(4,nil))),
    (send "hogehoge",(split 'o')),
    (progn\
      (setq :arr,[0,1,2,3,4,5,6,7,8,9]),
      (send :arr,(select),:x,(eq (mod :x,2),0))
    )
  ),
  (p (sqrt 2))
)
end


