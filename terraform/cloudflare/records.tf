resource "cloudflare_record" "keybase_proof" {
  name    = "securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["cloudflare_keybase_verification"]
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "email_security_spf" {
  name    = "securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "v=spf1 include:spf.improvmx.com ~all"
  type    = "TXT"
  ttl     = 1
}

import {
  to = cloudflare_record.improvmx_1
  id = "4544485b6794e04ffda8d171c4b85fbc/29eea6bcfee76ed25a33329b08b7a2b6"
}
resource "cloudflare_record" "improvmx_1" {
  name            = "securimancy.com"
  zone_id         = lookup(data.cloudflare_zones.domain.zones[0], "id")
  type            = "MX"
  ttl             = 1
  content         = "mx1.improvmx.com"
  priority        = 10
  allow_overwrite = false
}

resource "cloudflare_record" "improvmx_2" {
  name     = "securimancy.com"
  zone_id  = lookup(data.cloudflare_zones.domain.zones[0], "id")
  type     = "MX"
  ttl      = 1
  content  = "mx2.improvmx.com"
  priority = 20
}

# ImprovMX only supports DKIM records on paid plans
# resource "cloudflare_record" "email_security_dkim" {
#   name    = "*._domainkey"
#   zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
#   content = "v=DKIM1; p="
#   type    = "TXT"
#   ttl     = 1
# }

resource "cloudflare_record" "email_security_dmarc" {
  name    = "_dmarc"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "v=DMARC1; p=none; sp=reject; adkim=r; aspf=s;"
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "sendgrid_redirect" {
  name    = "em7278.securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "u24729611.wl112.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "sendgrid_domainkey_1" {
  name    = "s1._domainkey.securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "s1.domainkey.u24729611.wl112.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "sendgrid_domainkey_2" {
  name    = "s2._domainkey.securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "s2.domainkey.u24729611.wl112.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "bluesky" {
  name    = "_atproto"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "did=did:plc:6quh2ha5tx62idt72tdtms3e"
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "github_pages" {
  name    = "_github-pages-challenge-sp3nx0r"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = "ad440997b4fb7b298e7d2f940f9295"
  type    = "TXT"
  ttl     = 1
}
