#lang racket
(require "teachpacks/evren-teachpack.rkt")

(define BACKGROUND (bitmap "imaj/olimpus.png"))
(define oyun-bitti (bitmap "imaj/end screen.png"))
(define kazandın-bitti (bitmap "imaj/kazandınekran.png"))
(define tutorial (bitmap "imaj/tutorial.png"))


(define FRAME-RATE 60)
 
(check-expect false false)

;; STRUCT v - vektör
;; x : sayı - x koordinatı
;; y : sayı - y koordinatı
(STRUCT v (x y))

(ÖRNEK (not (= 1 2)) true)
;; v+ - vektör toplama
(define (v+ v1 v2)
                (v(+ (v-x v1) (v-x v2))
                  (+ (v-y v1) (v-y v2))))
           
;;
(ÖRNEK(v+ (v 1 2) (v 3 4)) (v 4 6))
;(ÖRNEK ....)

(define (v- v1 v2)
                (v (- (v-x v1) (v-x v2))
                  (- (v-y v1) (v-y v2))))


;;
(ÖRNEK(v- (v 1 2) (v 3 4)) (v -2 -2))

;; v* - vektör sayıyla çarpma
;; 
;;
;(ÖRNEK ....)
;(ÖRNEK ....)

;; v. - vektör dot çarpma
(define (v. v1 v2)
  (+ (* (v-x v1) (v-x v2))
        (* (v-y v1) (v-y v2))))
       
;;
(ÖRNEK(v. (v 3 5) (v 4 5))  37)
;(ÖRNEK ....)

;; v-mag - vektör uzunluğu
(define (v-mag v1 v2)
  (sqrt(+(sqr (- (v-x v1) (v-x v2)))
       (sqr (- (v-y v1) (v-y v2))))))
;;
(ÖRNEK(v-mag (v 5 5) (v 1 2)) 5)
(ÖRNEK(v-mag (v 1 2) (v 5 5)) 5)
;(ÖRNEK ....)

(define( v-scale v1 v2)
     (v (* (v-x v1) (v-x v2))
        (* (v-y v1) (v-y v2))))

(ÖRNEK(v-scale (v 1 2) (v 3 4)) (v 3 8))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hediye vektör çizim fonksiyonları
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;place-image/v
;; resim v sahne -> sahne
;; bir sahneye vectöre göre bir imaj yerleştir
;; template :
;; (define (place-image/v im v1 sahne)
;;  (... im ... (v-x v1) ... (v-y v1) ...)
(define test-circle (circle 10 "solid" "purple"))
(define test-square (square 100 "solid" "green"))

(ÖRNEK (place-image/v  test-circle (v 5 5) test-square)
       (place-image/align test-circle 5 5 "center" "center" test-square))
(ÖRNEK (place-image/v test-circle (v 3 8) test-square)
       (place-image/align test-circle 3 8 "center" "center" test-square))
(ÖRNEK (place-image/v test-circle (v 1 2) test-square)
       (place-image/align test-circle 1 2 "center" "center" test-square))
(ÖRNEK (place-image/v test-circle (v 2 8) test-square)
       (place-image/align test-circle 2 8 "center" "center" test-square))

(define (place-image/v im v1 sahne)
  (place-image/align im (v-x v1) (v-y v1) "center" "center"  sahne))

; place-line/v v v color görüntü -> görüntü
; v1'den v2'e giden bir çizgi arka imajına yerleştir
(ÖRNEK (place-line/v (v 2 3) (v 5 1) "red" test-square)
       (add-line test-square 2 3 5 1 "red")) 
;
(define (place-line/v v1 v2 renk arka)
  (add-line arka (v-x v1) (v-y v1) (v-x v2) (v-y v2) renk)) 

; place-text/v v metin sayı color görüntü -> görüntü
; v pozisyonda  verilen metni arka imajına yerleştir
(ÖRNEK (place-text/v (v 20 30) "Hello" 15 "red" test-square)
       (place-image/v (text "Hello" 15 "red") (v 20 30) test-square))
;
(define (place-text/v v metin size col arka)
  (place-image/v (text metin size col) v arka))


; STRUCT nesne
;; imaj : görüntü - nesnenin imajı
;; yer : v - nesnenin ekrandaki yeri
;; hız : v - nesnenin hızı
;; ivme : v - nesnenin ivmesi
(STRUCT nesne (imaj yer hız ivme))


(define (alttan-sek n)
  (cond

    ((> (v-y(nesne-yer n))
        (- (image-height BACKGROUND) (/ (image-height(nesne-imaj n))2)))
     (nesne
      (nesne-imaj n)
      (nesne-yer n)
      (v (v-x(nesne-hız n)) (* (v-y(nesne-hız n)) -1))
      (nesne-ivme n)
      ))
                 

    ((> (v-x(nesne-yer n))
        (- (image-width BACKGROUND) (/ (image-width(nesne-imaj n))2)));sağ ske
     (nesne
      (nesne-imaj n)
      (nesne-yer n)
      (v (* (v-x(nesne-hız n)) -1)  (v-y(nesne-hız n)) )
      (nesne-ivme n)
      ))


    ((< (v-x(nesne-yer n))
        (/ (image-width(nesne-imaj n))2));sol ske
     (nesne
      (nesne-imaj n)
      (nesne-yer n)
      (v (* (v-x(nesne-hız n)) -1)  (v-y(nesne-hız n)) )
      (nesne-ivme n)
      ))
                  
    ((< (v-y(nesne-yer n))
        (/ (image-height(nesne-imaj n))2))
     (nesne
      (nesne-imaj n)
      (nesne-yer n)
      (v (v-x(nesne-hız n)) (* (v-y(nesne-hız n)) -1))
      (nesne-ivme n)
      ))
    (else n)))


;(define (oyuncu-konumu n)
 ; (nesne-yer (evrn)))


-

; nesne-set-yer-y nesne sayı --> nesne
;nesneniin yerini değiştrimek

(define (nesne-set-yer-y n y)
  (nesne (nesne-imaj n)
         (v (v-x (nesne-yer n)) y)
         (nesne-hız n)
         (nesne-ivme n)))


  
;takip nesne y --> nesne
;oyuncu nesnesi y yerini y değerini kullanarak düşman nesnesin(nd)yerini y değeri günceller
;
(define (takipy nd p-v-yer)
  (nesne
   (nesne-imaj nd)
   (cond
      ((not(=  (v-y(nesne-yer p-v-yer))  (v-y(nesne-yer nd))))
       (v (v-x(nesne-yer nd)) (v-y(nesne-yer p-v-yer ))))
    
   (else (nesne-yer nd)))
  
    (nesne-hız nd)
    (nesne-ivme nd)))

;takip nesne x y --> nesne
;oyuncu nesnesini konumunun x y yerini kullanarak sarı-saldırı(nz) yerini x ve ydeğeri günceller
               

;düşman nesnesini kordinatlarını yerini kullanarak saldırıların(na yerini konum değeri günceller
;nesne x y --> nesne


; nesnenin kordinatının karakterin boyutunun yarısı  ile diğer nesnesnenin kordinatının karakterin boyutunun yarısını ile aynı ise true döner

;çarpıştı-mı?  vektör vektör --> boolean

    ;karkaterin enseye çarpıytığını bulmak için yazıldı art 20 de karakterin x ve y kordinatları orantısız olduğunan benzer hitboxu vermek için yazıldı

(define (çarpıştı-mı? t-v-yer p-v-yer)
  (<  (sqrt(+ 
          (sqr(- (v-x p-v-yer) (v-x t-v-yer ))) (sqr(- (v-y p-v-yer) (v-y t-v-yer))) ))110))


(define (parry-mı? p-v-yer t-v-yer)
  (< (sqrt(+ 
          (sqr(- (v-x p-v-yer) (v-x t-v-yer ))) (sqr(- (v-y p-v-yer) (v-y t-v-yer))) ))150))




    

;geri-dön nesne nesne vektör --> nesne    
;eğer tehlike oyuncu ile çarpışmış ize veya x kordinatı oyuncunun kordinatından küçük ise düşmana geri döner
;nç sarı saldırı nd düşman

(define (geri-dön nç nd no)
  (nesne
   (nesne-imaj nç)
   (cond
     ((or (çarpıştı-mı? (nesne-yer nç) (nesne-yer no)) (< (v-x(nesne-yer nç)) 0) (> (v-x(nesne-yer nç)) 1283) )      
      (v+ (nesne-yer nd) (v -120 0)))
   (else (nesne-yer nç)))
   (cond
     ((or (çarpıştı-mı? (nesne-yer nç) (nesne-yer nd)) (< (v-x(nesne-yer nç)) 0) (> (v-x(nesne-yer nç)) 1283) )      
      (v -10 0))
   (else (nesne-hız nç)))
   (nesne-ivme nç)))


 
   
               

(define (geri-dön-yeşil nç nd v-oyuncu-yer)
  (nesne
   (nesne-imaj nç)
   (cond
     ((or (çarpıştı-mı? (nesne-yer nç) v-oyuncu-yer) (< (v-x(nesne-yer nç)) 0))      
      (v+ (nesne-yer nd) (v -95 0)))
   (else (nesne-yer nç)))
   (nesne-hız nç)
   (nesne-ivme nç)))



(define (nesne-güncelle n)
    (alttan-sek(nesne-fizik-güncelle n)))

(define (nesne-takipy nd y)
  (takipy (nesne-fizik-güncelle nd ) y ))

(define (geri-dön-yeşil-güncelle ng nd v-oyuncu-yer)
  (geri-dön-yeşil (nesne-fizik-güncelle ng) nd v-oyuncu-yer))
   
(define (geri-dön-güncelle ng nd no)
  (geri-dön (nesne-fizik-güncelle ng) nd no))
;parry-güncelle nesne vektör --> nesne
;nt tehlike nesnesi p-v-yer oyuncu vektörü 


(define (genel-güncelle n nd no )
  (geri-dön(geri-dön(takipy(nesne-fizik-güncelle n) nd) nd no) nd no ))

(define (nesne-fizik-güncelle n)
  (nesne
   (nesne-imaj n)
   (v+ (nesne-yer  n)(nesne-hız n))
   (v+ (nesne-hız  n)(nesne-ivme n))
   (nesne-ivme n) )) 

(define (nesne-çiz n b)
  (place-image/v (nesne-imaj n) (nesne-yer n) b))

;; STRUCT evren (-oyununa göre değişecek)
;; arkaplanı : görüntü - oyun arka planı

;;



;STRUCT bitişevren (BACKGROUND))

(STRUCT evren (BACKGROUND oyuncu düşman mavi-saldırı sarı-saldırı yeşil-saldırı spartan-orb oyuncucan düşmancan))
; nesne--> nesne
;nk nesne kratos
(define (içeride nk)
  (nesne
   (nesne-imaj nk)
  (cond
     ((> (+ (v-x(nesne-yer nk)) (/ (image-width (nesne-imaj (evren-oyuncu yaradılış)))  2)) 1283)
      (v 1143 (v-y(nesne-yer nk))))
     
     ((> 0 (- (v-x(nesne-yer nk)) (/ (image-width (nesne-imaj (evren-oyuncu yaradılış))) 2)))
      (v 140 (v-y(nesne-yer nk))))
     
     ((> (+ (v-y(nesne-yer nk)) (/ (image-height (nesne-imaj (evren-oyuncu yaradılış))) 2)) 720)
      (v (v-x(nesne-yer nk)) 648))
     
     ((> 0 (- (v-y(nesne-yer nk)) (/ (image-height (nesne-imaj (evren-oyuncu yaradılış))) 2)))
      (v (v-x(nesne-yer nk)) 72))
  (else (nesne-yer nk)))
   (nesne-hız nk)
   (nesne-ivme nk)))


;nesne --> vektör
  ;nesne spartan orb
;(define (random-nokta n)
 ;  (nesne-fizik-güncelle n)))7

;;;;;;;;;;;;;;;;;;;;;;
;imaj nesne --> imaj
;oyuncunun canı (oc) 0 ın altoına düşerse arkaplanın üstüne oyun vitti yazısı gelsin (bg background)

(define(evren-başladı-mı?) false)

(define (evren-güncelle e)
  (evren
   (evren-BACKGROUND e)
   (nesne-fizik-güncelle(içeride(evren-oyuncu e)))
   (nesne-takipy (evren-düşman e) (evren-oyuncu e))
   (geri-dön-güncelle (evren-mavi-saldırı e) (evren-düşman e) (evren-oyuncu e))
   (genel-güncelle (evren-sarı-saldırı e) (evren-düşman e) (evren-oyuncu e))
                                       
   (nesne-güncelle(geri-dön-yeşil-güncelle (evren-yeşil-saldırı e) (evren-düşman e) (nesne-yer (evren-oyuncu e))))
   (cond
     ((çarpıştı-mı? (nesne-yer(evren-spartan-orb e)) (nesne-yer(evren-oyuncu e)))
      (nesne
       (scale 0.3 (bitmap "imaj/rage orb.png"))
       (v (random 30 1000) (random 30 600))
       (v 0 0) 
       (v 0 0 )
       ))
    (else (evren-spartan-orb e)))
      
   
   (cond
    
     ((çarpıştı-mı? (nesne-yer(evren-mavi-saldırı e)) (nesne-yer(evren-oyuncu e)))
      (- (evren-oyuncucan e) 100))
     ((or(çarpıştı-mı? (nesne-yer(evren-sarı-saldırı e)) (nesne-yer(evren-oyuncu e)))
         (çarpıştı-mı? (nesne-yer(evren-yeşil-saldırı e)) (nesne-yer(evren-oyuncu e))))
      (- (evren-oyuncucan e) 50))

     ((çarpıştı-mı? (nesne-yer(evren-spartan-orb e)) (nesne-yer(evren-oyuncu e)))
      (+ (evren-oyuncucan e) 20))
    (else (evren-oyuncucan e)))
   
   (cond
     ((çarpıştı-mı? (nesne-yer(evren-sarı-saldırı e)) (nesne-yer(evren-düşman e)))
      (- (evren-düşmancan e) 50))
          
   (else (evren-düşmancan e)))))
   

(define (evren-çiz e)
  
   (cond
     ((< (evren-oyuncucan e) 0)
     (place-image/v oyun-bitti (v 640 360) BACKGROUND))
     ((< (evren-düşmancan e) 0)
     (place-image/v kazandın-bitti (v 640 360) BACKGROUND))
     ((= (evren-oyuncucan e) 350)
     (place-image/v tutorial (v 640 360) BACKGROUND))


   (else 
 
  (place-text/v (v 85 60) "[𝓗𝓔𝓐𝓛𝓣𝓗]" 30 "red"
  (place-text/v (v 1150 60) "[𝓩𝓔𝓤𝓢 𝓗𝓔𝓐𝓛𝓣𝓗]" 30 "white"
  (place-text/v (v 1150 90) (number->string (evren-düşmancan e)) 30 "white"
  (place-text/v (v 70 90) (number->string (evren-oyuncucan e)) 30 "red"
           
   (nesne-çiz (evren-oyuncu e)
             (nesne-çiz (evren-düşman e)
                        (nesne-çiz (evren-mavi-saldırı e)
                                   (nesne-çiz (evren-sarı-saldırı e)
                                               (nesne-çiz(evren-yeşil-saldırı e)
                                                (nesne-çiz (evren-spartan-orb e)
                                                 (evren-BACKGROUND e))))))))))))))
                
  

;(ÖRNEK(evren-çiz(example-evren)))
; evren string --> evre

;hareket-ediyor-mu? string ---> boolean 
  
;hareket etme tuşlarına bvasılırsa true versin
  

  

 ;evren tuş basılan tuşa göre oyuncunun konumunu değiştirir burada y kordinat
;evren string --> evren


 ;oyuncu-tuş nesne string ---> nesne
(define (oyuncu-tuş kar t)
  (nesne
   (nesne-imaj kar)
   (nesne-yer kar)
 
    (cond
     
     ((string=? t "up")
      (v 0 -10))
     
     ((string=? t "down")
      (v 0 10))
     
     ((string=? t "left")
      
     (v -10 0))
    
     ((string=? t "right")
     (v 10 0))
      
 (else (nesne-hız kar)))     
   (nesne-ivme kar)))

;parry nesne vektör --> nesne
;tn tehlike nesne p-v-yer oyuncu vektör t-v-yer


;parry-tuş nesne nesne string --> nesne
;sn sarı saldırı , no oyuncu , t tuş ---> sarı saldırı

(define (parry-tuş sn no t)
  (nesne
   (nesne-imaj sn)
   (nesne-yer sn)
   (cond
     ((and(parry-mı? (nesne-yer no) (nesne-yer sn)) (string=? t "f"))
      (SES 0 "ses/parrysound.wav") (v 15 0))
       
   (else (nesne-hız sn)))
   
   (nesne-ivme sn)
   ))

(define (geç oc t)
  (cond
       ((string=? t "R")
        (- oc 1))
   (else oc)))

;evren-tuş evren string ---> evren
(define (evren-tuş e t )
  (cond
    ((< (evren-oyuncucan e) 0)
    (cond
     ((string=? t "H")
      yaradılış )
     (else e)))
   (else 

    (evren
    
      (evren-BACKGROUND e)
      (nesne-fizik-güncelle(oyuncu-tuş(evren-oyuncu e) t) )
      (evren-düşman e)
      (evren-mavi-saldırı e)
      (nesne-fizik-güncelle(parry-tuş (evren-sarı-saldırı e) (evren-oyuncu e) t))
      (evren-yeşil-saldırı e)
      (evren-spartan-orb e)
      (geç(evren-oyuncucan e) t)
      (evren-düşmancan e)))))

   

(define yaradılış (evren BACKGROUND
                         (nesne(scale 0.2 (bitmap "imaj/kartos.png"))(v 100 400)(v 0 0)(v 0 0))                         
                         (nesne(scale 0.2 (bitmap "imaj/zeus1.png"))(v 1200 205)(v 0 0)(v 0 0))                  
                         (nesne(scale 0.24 (bitmap "imaj/mavi yıldırım.png"))(v 1300 205)(v -20 0)(v 0 0))
                         (nesne(scale 0.24 (bitmap "imaj/sarıyıldırım.png"))(v 1300 100)(v -10 0)(v 0 0))
                         (nesne(scale 0.24 (bitmap "imaj/yeşil yıldırım.png"))(v 1200 205)(v -10 -10)(v 0 0))
                         (nesne(scale 0.3 (bitmap "imaj/rage orb.png"))(v 300 150)(v 0 0)(v 0 0))
                         350
                         1001)) ;(/evren/ses/arkaplanmüzik.wav")(SES 0 "/evren/ses/yoursonhasreturned.wav")


  
                                 

;(ÖRNEK (SES 0 "ses/bark.wav") 0)
;(ÖRNEK false false)
;; SES herhangbirşey ses-dosyası-metin -> herhangibirşey
;; birinci paramatresini aynen dönsürüyor, sesi çalarak
;(ÖRNEK (SES 0 "ses/arkaplanmüzik.wav") 0)
;(ÖRNEK false false)
(test)
(define (oyun-bitti-mi? e)
    (<= (evren-oyuncucan e) 0))
;;;;;;;parrybolduğu eyre koy ses;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sabit kod bundan sonra                               ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(define (go) (yut (big-bang yaradılışa
(define (go)
  ;(begin (SES 0 "/evren/ses/arkaplanmüzik.wav")(SES 0 "/evren/ses/yoursonhasreturned.wav")
         (yut (big-bang yaradılış
                (on-tick evren-güncelle (/ 1 FRAME-RATE))
                (on-draw evren-çiz)
                (on-key evren-tuş)
                ;(cond
                 ; ((oyun-bitti-mi?)(SES 0 "/evren/ses/sonar.wav")))
                )))

