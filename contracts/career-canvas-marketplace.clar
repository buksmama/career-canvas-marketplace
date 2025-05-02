;; Career Canvas Marketplace

;; ===============================================================
;; STORAGE DEFINITIONS
;; ===============================================================


;; Repository for available position listings
(define-map position-listings
    principal
    {
        title: (string-ascii 100),
        description: (string-ascii 500),
        publisher: principal,
        location-region: (string-ascii 100),
        requirements: (list 10 (string-ascii 50))
    }
)


;; Repository for commercial organization information
(define-map organization-registry
    principal
    {
        corporate-name: (string-ascii 100),
        industry-category: (string-ascii 50),
        location-region: (string-ascii 100)
    }
)

;; Repository for individual contributor information
(define-map contributor-directory
    principal
    {
        identity-name: (string-ascii 100),
        specializations: (list 10 (string-ascii 50)),
        location-region: (string-ascii 100),
        professional-history: (string-ascii 500)
    }
)

;; ===============================================================
;; ERROR CODE DEFINITIONS
;; ===============================================================

;; Standard error codes for operational feedback
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-POSITION (err u403))
(define-constant ERR-ENTITY-MISSING (err u404))
(define-constant ERR-INVALID-SPECIALIZATION (err u400))
(define-constant ERR-INVALID-LOCATION (err u401))
(define-constant ERR-INVALID-HISTORY (err u402))

;; ===============================================================
;; ORGANIZATION PROFILE MANAGEMENT
;; ===============================================================

;; Establish a new organization profile in the ecosystem
(define-public (register-organization-profile 
    (corporate-name (string-ascii 100))
    (industry-category (string-ascii 50))
    (location-region (string-ascii 100)))
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? organization-registry account-owner))
        )
        ;; Verify profile uniqueness
        (if (is-none existing-profile)
            (begin
                ;; Validate mandatory information completeness
                (if (or (is-eq corporate-name "")
                        (is-eq industry-category "")
                        (is-eq location-region ""))
                    (err ERR-INVALID-LOCATION)
                    (begin
                        ;; Persist the new organization profile
                        (map-set organization-registry account-owner
                            {
                                corporate-name: corporate-name,
                                industry-category: industry-category,
                                location-region: location-region
                            }
                        )
                        (ok "Organization profile successfully registered.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)
