
;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (multislot coded-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display "Molim odgovorite na sljedeca pitanja.")
                    (relation-asserted start)
                    (state initial)
                    (valid-answers "u redu")
                    (coded-answers 1))))

;;;***************
;;;* QUERY RULES *
;;;***************
  
(defrule getVrstaSmjestaja ""
	(logical (start 1))
	=>  
    (assert (UI-state (display "Odaberite vrstu smjestaja:")
                (relation-asserted vrsta)
                (response No)
                (valid-answers "studentski dom" "studentski ucenicki dom" "privatni" "nije vazno")
                (coded-answers 100 200 300 10000))))
                
(defrule getCijenaSmjestaja ""
	(logical (start 1))
	=>
	(assert (UI-state (display "Cijena smjestaja:")
                (relation-asserted cijena)
                (response No)
                (valid-answers "niska" "srednja" "visoka" "ogromna" "nije vazno")
                (coded-answers 200 400 1000 1500 10000))))                    

(defrule StudentSInvaliditetom ""
	(logical (start 1))
    =>
    (assert (UI-state (display "Soba je osposobljena za studente sa invaliditetom?")
                (relation-asserted studinval)
                (response No)
                (valid-answers "da" "ne")
                (coded-answers 1 0))))                    

(defrule getVelicinaSobe ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Odaberite velicinu sobe:")
                (relation-asserted velicina)
                (response No)
                (valid-answers "mala" "srednja" "velika" "ogromna" "nije vazno")
                (coded-answers 100 200 300 400 10000))))                 
                
(defrule getKupaonica ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Kupaonica:")
                (relation-asserted kupaonica)
                (response No)
                (valid-answers "zajednicka" "vlastita" "nije vazno")
                (coded-answers 100 200 10000))))                    
                
(defrule getKuhinja ""
	(logical (start 1))
	=>          
    (assert (UI-state (display "Kuhinja:")
                (relation-asserted kuhinja)
                (response No)
                (valid-answers "zajednicka" "vlastita" "nije vazno")
                (coded-answers 100 200 10000))))  

(defrule getNamjestenjeProstora ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Namjestaj i uredjenje prostora:")
                (relation-asserted namjestenost)
                (response No)
                (valid-answers "staro" "srednje" "novo" "luksuzno" "nije vazno")
                (coded-answers 100 200 300 400 10000))))  

(defrule getBlizinaMenze ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Blizina studentske menze:")
                (relation-asserted menza)
                (response No)
                (valid-answers "integrirano" "blizu" "udaljeno" "daleko" "nije vazno")
                (coded-answers 100 200 300 400 10000))))  

(defrule getBlizinaPraonice ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Blizina praonice:")
                (relation-asserted praonica)
                (response No)
                (valid-answers "integrirano" "blizu" "udaljeno" "daleko" "nije vazno")
                (coded-answers 100 200 300 400 10000))))      

(defrule getTrgovina ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Blizina trgovine:")
                (relation-asserted trgovina)
                (response No)
                (valid-answers "blizu" "udaljeno" "daleko")
                (coded-answers 100 200 300))))   

(defrule getSport ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Sport i teretana:")
                (relation-asserted sport)
                (response No)
                (valid-answers "integrirano" "blizu" "udaljeno" "daleko")
                (coded-answers 100 200 300 400))))       

(defrule getBrojStanara ""
	(logical (start 1))
	=>
    (assert (UI-state (display "Broj stanara:")
                (relation-asserted stanari)
                (response No)
                (valid-answers "jedan" "dvoje" "troje ili vise" "nije vazno")
                (coded-answers 100 200 300 10000))))       
 
;;;****************
;;;* DECISION RULES *
;;;****************
                     
(defrule no-repairs ""
   (declare (salience -10))
   (logical (UI-state (id ?id)))
   (state-list (current ?id))
   =>
   (assert (UI-state (display "Ne postoji odgovarajuci smjestaj.")
                     (state final))))
   
;;; Studentski dom Stjepan Radic k1-1
(defrule stjepanradick11 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (>= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (>= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija 1 Vrsta 1")
                     (state final))))
                     
;;; Studentski dom Stjepan Radic k1-2
(defrule stjepanradick12 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (>= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija 1 Vrsta 2")
                     (state final))))  
                     
;;; Studentski dom Stjepan Radic k3-1
(defrule stjepanradick31 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (>= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija 3 Vrsta 1")
                     (state final))))  

;;; Studentski dom Stjepan Radic k3-2
(defrule stjepanradick32 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 400 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (>= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija 3 Vrsta 2")
                     (state final))))  

;;; Studentski dom Stjepan Radic k5
(defrule stjepanradick5 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 400 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija 5")
                     (state final))))  

;;; Studentski dom Stjepan Radic i1
(defrule stjepanradici1 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 1 ?stinv))
   (velicina ?vel)
   (or (test (= 300 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija i1")
                     (state final))))  

;;; Studentski dom Stjepan Radic i2
(defrule stjepanradici1 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 1 ?stinv))
   (velicina ?vel)
   (or (test (= 300 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Stjepan Radic Kategorija i2")
                     (state final))))  

;;; Studentski dom Cvjetno naselje k2-11
(defrule cvjetnonaseljek211 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Cvjetno naselje Kategorija k2-11")
                     (state final))))  

;;; Studentski dom Cvjetno naselje k2-12
(defrule cvjetnonaseljek212 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Cvjetno naselje Kategorija k2-12")
                     (state final))))  

;;; Studentski dom Cvjetno naselje k2-21
(defrule cvjetnonaseljek221 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Cvjetno naselje Kategorija k2-21")
                     (state final))))  

;;; Studentski dom Cvjetno naselje k2-22
(defrule cvjetnonaseljek222 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Cvjetno naselje Kategorija k2-22")
                     (state final))))  

;;; Studentski dom Cvjetno naselje i1
(defrule cvjetnonaseljei1 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 1 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Cvjetno naselje Kategorija i1")
                     (state final))))  

;;; Studentski dom Cvjetno naselje i2
(defrule cvjetnonaseljei2 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 1 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Cvjetno naselje Kategorija i2")
                     (state final))))  

;;; Studentski dom Ante Starcevic k5-1
(defrule antestarcevick51 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 400 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Ante Starcevic Kategorija k5-1")
                     (state final))))  

;;; Studentski dom Ante Starcevic k5-2
(defrule antestarcevick52 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 400 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Ante Starcevic Kategorija k5-2")
                     (state final))))  

;;; Studentski dom Ante Starcevic i1-1
(defrule antestarcevici11 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 400 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 1 ?stinv))
   (velicina ?vel)
   (or (test (<= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Ante Starcevic Kategorija i1-1")
                     (state final))))  

;;; Studentski dom Ante Starcevic i1-2
(defrule antestarcevici12 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 400 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 1 ?stinv))
   (velicina ?vel)
   (or (test (<= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Ante Starcevic Kategorija i1-2")
                     (state final))))  

;;; Studentski dom Lascina k6-1
(defrule lascinak61 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 200 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (<= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Lascina Kategorija k6-1")
                     (state final))))  

;;; Studentski dom Lascina k6-2
(defrule lascinak62 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 200 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (<= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (<= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Lascina Kategorija k6-2")
                     (state final))))  

;;; Studentski dom Lascina k7
(defrule lascinak7 ""
   (vrsta ?vrst)
   (or (test (= 100 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 200 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (<= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 100 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 100 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Studentski dom Lascina Kategorija k7")
                     (state final))))  

;;; Ucenicki/Studentski dom Novi Zagreb
(defrule novizagreb ""
   (vrsta ?vrst)
   (or (test (= 200 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (<= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 300 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Ucenicki/Studentski dom Novi Zagreb")
                     (state final))))  

;;; Ucenicki/Studentski dom Franje Bucara k1
(defrule franjebucarak1 ""
   (vrsta ?vrst)
   (or (test (= 200 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (<= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 300 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Ucenicki/Studentski dom Franje Bucara Kategorija 1")
                     (state final))))  

;;; Ucenicki/Studentski dom Franje Bucara k2
(defrule franjebucarak2 ""
   (vrsta ?vrst)
   (or (test (= 200 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1000 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 300 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Ucenicki/Studentski dom Franje Bucara Kategorija 2")
                     (state final))))  

;;; Privatni smjestaj sobe Maksimir
(defrule sobemaksimir ""
   (vrsta ?vrst)
   (or (test (= 300 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1500 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 300 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 300 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: privatni Sobe Maksimir ")
                     (state final))))  

;;; Mali studentski dom Crnomerec 1
(defrule crnomerec1 ""
   (vrsta ?vrst)
   (or (test (= 300 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1500 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 300 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Mali studentski dom Crnomerec 1 ")
                     (state final))))  

;;; Mali studentski dom Crnomerec 2
(defrule crnomerec2 ""
   (vrsta ?vrst)
   (or (test (= 300 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1500 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 300 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 100 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 300 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 300 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 200 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: Mali studentski dom Crnomerec 2 ")
                     (state final))))  

;;; Privatni smjestaj sobe Savica
(defrule savica ""
   (vrsta ?vrst)
   (or (test (= 300 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1500 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 100 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 200 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 200 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: privatni Sobe Savica ")
                     (state final))))  

;;; Privatni smjestaj sobe Trg bana Josipa Jelacica
(defrule trgjosipajelacica ""
   (vrsta ?vrst)
   (or (test (= 300 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1500 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 300 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 200 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 300 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: privatni Sobe Trg bana Josipa Jelacica ")
                     (state final))))  

;;; Privatni smjestaj sobe Vrbik
(defrule vrbik ""
   (vrsta ?vrst)
   (or (test (= 300 ?vrst)) (test (<= 10000 ?vrst)) )
   (cijena ?cije)
   (or (test (>= 1500 ?cije)) (test (<= 10000 ?cije)) )
   (studinval ?stinv) (test (= 0 ?stinv))
   (velicina ?vel)
   (or (test (= 200 ?vel)) (test (<= 10000 ?vel)) )
   (kupaonica ?kup)
   (or (test (= 100 ?kup)) (test (<= 10000 ?kup)) )
   (kuhinja ?kuh)
   (or (test (= 200 ?kuh)) (test (<= 10000 ?kuh)) )
   (namjestenost ?namj)
   (or (test (= 200 ?namj)) (test (<= 10000 ?namj)) )
   (menza ?menz)
   (or (test (>= 200 ?menz)) (test (<= 10000 ?menz)) )
   (praonica ?prao)
   (or (test (= 100 ?prao)) (test (<= 10000 ?prao)) )
   (trgovina ?trg)
   (test (= 100 ?trg))
   (sport ?spor)
   (test (= 100 ?spor))
   (stanari ?stan)
   (test (= 100 ?stan))
   =>
   (assert (UI-state (display "Smjestaj: privatni Sobe Vrbik ")
                     (state final))))  
   
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
