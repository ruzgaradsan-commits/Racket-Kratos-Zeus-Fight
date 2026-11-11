#lang racket
; evren (ikinci hafta) teachpack
; otomatik inspect edilen STRUCT, ÖRNEK (yani check-expect ,ve structlerle çalışıyor)
; artı SES, yani play-sound

(require 2htdp/universe)
(require 2htdp/image)
(require (only-in racket/gui/base play-sound))
;(require rsound)
(require test-engine/racket-tests)

; *** SES doesn't work consistently across operating systems!
(provide STRUCT SES yut
         (all-from-out 2htdp/universe)
         (all-from-out 2htdp/image)
         (all-from-out test-engine/racket-tests)
         play-sound)
; ÖRNEK now defaults to exact comparisons *** Find a better solution
; ÖRNEK-YAKIN provides inexact comparisons *** Find a better solution
(provide ÖRNEK)
(provide ÖRNEK-YAKIN)
(provide sine cosine)

(define (sine angle-in-degrees)
  (sin (/ (* pi angle-in-degrees) 180)))

(define (cosine angle-in-degrees)
  (cos (/ (* pi angle-in-degrees) 180)))

(define (SES v s)
  (play-sound s true)
  v)

(define-syntax-rule (STRUCT id body)
  (struct id body  #:inspector (make-inspector (current-inspector))))

(define-syntax-rule (ÖRNEK-YAKIN a b)
  (check-within a b 0.001))

(define-syntax-rule (ÖRNEK a b)
  (check-expect a b))

(define (yut x)
  (display ""))


