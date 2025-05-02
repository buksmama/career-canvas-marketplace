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

;; Modify an existing organization profile
(define-public (modify-organization-profile 
    (corporate-name (string-ascii 100))
    (industry-category (string-ascii 50))
    (location-region (string-ascii 100)))
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? organization-registry account-owner))
        )
        ;; Verify profile existence
        (if (is-some existing-profile)
            (begin
                ;; Validate mandatory information completeness
                (if (or (is-eq corporate-name "")
                        (is-eq industry-category "")
                        (is-eq location-region ""))
                    (err ERR-INVALID-LOCATION)
                    (begin
                        ;; Update the organization profile
                        (map-set organization-registry account-owner
                            {
                                corporate-name: corporate-name,
                                industry-category: industry-category,
                                location-region: location-region
                            }
                        )
                        (ok "Organization profile successfully modified.")
                    )
                )
            )
            (err ERR-ENTITY-MISSING)
        )
    )
)

;; Delete an existing organization profile
(define-public (deactivate-organization-profile)
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? organization-registry account-owner))
        )
        ;; Verify profile existence
        (if (is-some existing-profile)
            (begin
                ;; Remove the organization profile
                (map-delete organization-registry account-owner)
                (ok "Organization profile successfully deactivated.")
            )
            (err ERR-ENTITY-MISSING)
        )
    )
)


;; ===============================================================
;; CONTRIBUTOR PROFILE MANAGEMENT
;; ===============================================================

;; Establish a new contributor profile in the ecosystem
(define-public (register-contributor-profile 
    (identity-name (string-ascii 100))
    (specializations (list 10 (string-ascii 50)))
    (location-region (string-ascii 100))
    (professional-history (string-ascii 500)))
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? contributor-directory account-owner))
        )
        ;; Verify profile uniqueness
        (if (is-none existing-profile)
            (begin
                ;; Validate mandatory information completeness
                (if (or (is-eq identity-name "")
                        (is-eq location-region "")
                        (is-eq (len specializations) u0)
                        (is-eq professional-history ""))
                    (err ERR-INVALID-HISTORY)
                    (begin
                        ;; Persist the new contributor profile
                        (map-set contributor-directory account-owner
                            {
                                identity-name: identity-name,
                                specializations: specializations,
                                location-region: location-region,
                                professional-history: professional-history
                            }
                        )
                        (ok "Contributor profile successfully registered.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing contributor profile
(define-public (modify-contributor-profile 
    (identity-name (string-ascii 100))
    (specializations (list 10 (string-ascii 50)))
    (location-region (string-ascii 100))
    (professional-history (string-ascii 500)))
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? contributor-directory account-owner))
        )
        ;; Verify profile existence
        (if (is-some existing-profile)
            (begin
                ;; Validate mandatory information completeness
                (if (or (is-eq identity-name "")
                        (is-eq location-region "")
                        (is-eq (len specializations) u0)
                        (is-eq professional-history ""))
                    (err ERR-INVALID-HISTORY)
                    (begin
                        ;; Update the contributor profile
                        (map-set contributor-directory account-owner
                            {
                                identity-name: identity-name,
                                specializations: specializations,
                                location-region: location-region,
                                professional-history: professional-history
                            }
                        )
                        (ok "Contributor profile successfully modified.")
                    )
                )
            )
            (err ERR-ENTITY-MISSING)
        )
    )
)

;; ===============================================================
;; POSITION LISTING MANAGEMENT
;; ===============================================================

;; Create a new position listing in the ecosystem
(define-public (publish-position-listing 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location-region (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))
    (let
        (
            (account-owner tx-sender)
            (existing-listing (map-get? position-listings account-owner))
        )
        ;; Verify listing uniqueness
        (if (is-none existing-listing)
            (begin
                ;; Validate mandatory information completeness
                (if (or (is-eq title "")
                        (is-eq description "")
                        (is-eq location-region "")
                        (is-eq (len requirements) u0))
                    (err ERR-INVALID-POSITION)
                    (begin
                        ;; Persist the new position listing
                        (map-set position-listings account-owner
                            {
                                title: title,
                                description: description,
                                publisher: account-owner,
                                location-region: location-region,
                                requirements: requirements
                            }
                        )
                        (ok "Position listing successfully published.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing position listing
(define-public (update-position-listing 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location-region (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))
    (let
        (
            (account-owner tx-sender)
            (existing-listing (map-get? position-listings account-owner))
        )
        ;; Verify listing existence
        (if (is-some existing-listing)
            (begin
                ;; Validate mandatory information completeness
                (if (or (is-eq title "")
                        (is-eq description "")
                        (is-eq location-region "")
                        (is-eq (len requirements) u0))
                    (err ERR-INVALID-POSITION)
                    (begin
                        ;; Update the position listing
                        (map-set position-listings account-owner
                            {
                                title: title,
                                description: description,
                                publisher: account-owner,
                                location-region: location-region,
                                requirements: requirements
                            }
                        )
                        (ok "Position listing successfully updated.")
                    )
                )
            )
            (err ERR-ENTITY-MISSING)
        )
    )
)

;; Delete an existing position listing
(define-public (withdraw-position-listing)
    (let
        (
            (account-owner tx-sender)
            (existing-listing (map-get? position-listings account-owner))
        )
        ;; Verify listing existence
        (if (is-some existing-listing)
            (begin
                ;; Remove the position listing
                (map-delete position-listings account-owner)
                (ok "Position listing successfully withdrawn.")
            )
            (err ERR-ENTITY-MISSING)
        )
    )
)

