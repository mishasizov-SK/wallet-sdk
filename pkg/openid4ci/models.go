/*
Copyright Avast Software. All Rights Reserved.

SPDX-License-Identifier: Apache-2.0
*/

package openid4ci

// CredentialOffer represents the Credential Offer object as defined in
// https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0-11.html#section-4.1.1.
type CredentialOffer struct {
	CredentialIssuer string           `json:"credential_issuer,omitempty"`
	Credentials      []Credentials    `json:"credentials,omitempty"`
	Grants           map[string]Grant `json:"grants,omitempty"`
}

// Credentials represents the credential format and types in a Credential Offer.
type Credentials struct {
	Format string   `json:"format,omitempty"`
	Types  []string `json:"types,omitempty"`
}

// Grant represents the grant types that the credential issuer is prepared to process for the given credential offer.
type Grant struct {
	PreAuthorizedCode string `json:"pre-authorized_code,omitempty"`
	UserPINRequired   bool   `json:"user_pin_required,omitempty"`
}

// AuthorizeResult is the object returned from the Client.Authorize method.
// An empty/missing AuthorizationRedirectEndpoint indicates that the wallet is pre-authorized.
type AuthorizeResult struct {
	AuthorizationRedirectEndpoint string
	UserPINRequired               bool
}

// OpenIDConfig represent's an issuer's OpenID configuration.
type OpenIDConfig struct {
	AuthorizationEndpoint  string   `json:"authorization_endpoint,omitempty"`
	ResponseTypesSupported []string `json:"response_types_supported,omitempty"`
	TokenEndpoint          string   `json:"token_endpoint,omitempty"`
}

// CredentialRequestOpts represents the data (required and optional) that is used in the
// final step of the OpenID4CI flow, where the wallet requests the credential from the issuer.
type CredentialRequestOpts struct {
	UserPIN string
}

// CredentialResponse is the object returned from the Client.Callback method.
// It contains the issued credential and the credential's format.
// The credential must be JWT (or represented as a string somehow), or unmarshalling will not work correctly.
type CredentialResponse struct {
	Credential string `json:"credential,omitempty"` // Optional for deferred credential flow.
	Format     string `json:"format,omitempty"`
}

type tokenResponse struct {
	AccessToken     string `json:"access_token,omitempty"`
	TokenType       string `json:"token_type,omitempty"`
	ExpiresIn       int    `json:"expires_in,omitempty"`
	RefreshToken    string `json:"refresh_token,omitempty"`
	CNonce          string `json:"c_nonce,omitempty"`
	CNonceExpiresIn int    `json:"c_nonce_expires_in,omitempty"`
}

type credentialRequest struct {
	Types  []string `json:"types,omitempty"`
	Format string   `json:"format,omitempty"`
	Proof  proof    `json:"proof,omitempty"`
}

type proof struct {
	ProofType       string `json:"proof_type,omitempty"`
	JWT             string `json:"jwt,omitempty"`
	CNonce          string `json:"c_nonce,omitempty"`
	CNonceExpiresIn int    `json:"c_nonce_expires_in,omitempty"`
}
