#lang racket/base

(require (for-syntax racket/base)
         racket/format
         racket/match
         racket/path
         racket/port
         racket/runtime-path
         racket/system)

(define-runtime-path linter-tests
  (build-path "tests" "lint"))

(for ([filename (directory-list linter-tests)]
      #:when (bytes=? (path-get-extension filename) #".rkt"))
  (define-values (in out) (make-pipe))
  (define filepath (build-path linter-tests filename))

  (match-define (list _ _ _ _ control)
    (process*/ports out #f out (find-executable-path "raco") "konmari" "lint" filepath))
  (control 'wait)

  (close-output-port out)
  (define command-output (port->lines in))
  (define expected-output (call-with-input-file (~a filepath ".out") port->lines))

  (unless (equal? command-output expected-output)
    (displayln filename)
    (exit 1)))