;; Manufacturer Verification Contract
;; Validates legitimate device producers

(define-data-var admin principal tx-sender)

;; Map to store verified manufacturers
(define-map manufacturers principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-REGISTERED u101)
(define-constant ERR-NOT-FOUND u102)

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Add a new manufacturer
(define-public (register-manufacturer (manufacturer-address principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? manufacturers manufacturer-address)) (err ERR-ALREADY-REGISTERED))
    (ok (map-set manufacturers manufacturer-address true))))

;; Remove a manufacturer
(define-public (remove-manufacturer (manufacturer-address principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-some (map-get? manufacturers manufacturer-address)) (err ERR-NOT-FOUND))
    (ok (map-delete manufacturers manufacturer-address))))

;; Check if a manufacturer is verified
(define-read-only (is-verified-manufacturer (manufacturer-address principal))
  (default-to false (map-get? manufacturers manufacturer-address)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (ok (var-set admin new-admin))))
