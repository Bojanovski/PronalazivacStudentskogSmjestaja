

(deffacts startup
  (animal dog)
  (animal duck)
  (animal haddock))

  
(defrule list-animals
  (animal ?name)
  =>
  (printout t ?name " found" crlf))


(defrule duck
  (animal duck)
  =>
  (assert (sound-is quack))
  (printout t "it's a duck" crlf))
  
  