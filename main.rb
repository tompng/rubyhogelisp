require './lisp/lisp.rb'

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
  (defun :fact,:x,(cond (eq :x,0),1,(mult :x,(fact (sub :x,1))))),
  (defun :abs,:x,(cond (lt :x,0),(sub 0,:x),:x)),
  (defun :sqrtrec,:x,:y,:n,
    (cond (eq :n,0),
      :y,
      (sqrtrec :x,(add :y,(div (sub (div :x,:y),:y),2.0)),(sub :n,1))
    )
  ),
  (defun :sqrt,:x,(sqrtrec :x,:x,10))
)
end
Lisp do
(progn\
  (defun :square,(mult :x,:x)),
  (defun :list_len,:list,(cond :list,(add 1,(list_len (cdr :list))),0)),
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
