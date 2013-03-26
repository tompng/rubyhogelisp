require './lisp/lisp.rb'


Lisp do
(progn\
  (define (times_rec :n,:m,:func),
    (ifelse (eq :n,:m),
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
(progn\
  (let :x,20,
    (progn\
      (define (print20),(p :x)),
      (let :x,30,
        print20
      )
    )
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
  !(ifelse (eq :x,0),"zero","nonzero"),
  (quote (ifelse (eq :x,0),"zero","nonzero")),
  (cdr (cons 1,(cons 2,(cons 3,(cons 4,nil))))),
  (ifelse true,(ifelse false,(cons 1,2),(cons 3,4)),(cons 5,6))
)
end
Lisp(y:3) do p (let :x,(add 1,:y),(add :x,4)) end

Lisp do
(progn\
  (define (fact :x),(ifelse (eq :x,0),1,(mult :x,(fact (sub :x,1))))),
  (define (abs :x),(ifelse (lt :x,0),(sub 0,:x),:x)),
  (define (sqrtrec :x,:y),
    (let :next,(add :y,(div (sub (div :x,:y),:y),2.0)),
      (ifelse (le :y,:next),
        (sqrtrec :x,:next),
        :next
      )
    )
  ),
  (define (sqrt :x),(sqrtrec :x,:x))
)
end

Lisp do
(progn\
  (define (square :x),(mult :x,:x)),
  (define (list_len :list),(ifelse :list,(add 1,(list_len (cdr :list))),0)),
  (p\
    (fact 5),
    (eval !(fact 5)),
    (list_len !L(hoge,1,2,3)),
    (eval !(fact 5)),
    (eval !D(:fact,D(4,nil))),
    (send "hogehoge",(split 'o')),
    (progn\
      (let :arr,[0,1,2,3,4,5,6,7,8,9],
        (send :arr,(select),:x,(eq (mod :x,2),0))
      )
    )
  ),
  (p (square (sqrt 100000)))
)
end


