resource "cloudflare_account" "main" {
  name              = "Personal Account"
  type              = "standard"
  enforce_twofactor = false
}
