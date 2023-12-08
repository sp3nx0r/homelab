resource "cloudflare_record" "keybase_proof" {
  name    = "securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = data.sops_file.cloudflare_secrets.data["cloudflare_keybase_verification"]
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "email_security_spf" {
  name    = "securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "v=spf1 -all"
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "email_security_dkim" {
  name    = "*._domainkey"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "v=DKIM1; p="
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "email_security_dmarc" {
  name    = "_dmarc"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "sendgrid_redirect" {
  name    = "em7278.securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "u24729611.wl112.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "sendgrid_domainkey_1" {
  name    = "s1._domainkey.securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "s1.domainkey.u24729611.wl112.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "sendgrid_domainkey_2" {
  name    = "s2._domainkey.securimancy.com"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "s2.domainkey.u24729611.wl112.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
}
