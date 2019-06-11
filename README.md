# konmari

![a screenshot of konmari being used inside Emacs](media/screenshot.png)

<p align="center">
  <strong><em>warning: experimental software ahead</em></strong>
</p>

`konmari` performs surface-level linting with the intent of finding
issues as quickly as it can.  As such, it does not expand the programs
it lints.  It currently detects:

* missing and invalid #lang headers
* syntax errors
* unused identifiers (unless those identifiers are made up of underscores)
* shadowed identifiers
* malformed `if` and `let` expressions
* redefined identifiers via `define` and `define-values`
* redefined identifiers inside `let`
* identifiers that have been provided but not defined
* `cond` expressions without an `else` clause
* usages of `begin` and `let` inside an `if`

## Emacs/flycheck support

Add the following snippet to your `init.el` to define a Flycheck
checker for konmari:

``` emacs-lisp
(flycheck-define-checker racket-konmari
  "check racket source code using konmari"
  :command ("raco" "konmari" "lint" source)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ":error:" (message) line-end)
   (warning line-start (file-name) ":" line ":" column ":warning:" (message) line-end))
  :modes racket-mode)

(add-to-list 'flycheck-checkers 'racket-konmari)
```
