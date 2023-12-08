
resource "cloudflare_ruleset" "default" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_firewall_custom"
  zone_id = cloudflare_zone.domain.id

  # Bots
  rules {
    action      = "block"
    description = "Firewall rule to block bots determined by CF"
    enabled     = true
    expression  = "(cf.client.bot)"
  }

  # Block threats less than Medium
  rules {
    action      = "block"
    description = "Firewall rule to block medium threats"
    enabled     = true
    expression  = "(cf.threat_score gt 14)"
  }

  # GeoIP blocking
  rules {
    action      = "block"
    description = "Firewall rule to block all countries except US"
    enabled     = true
    expression  = "(ip.geoip.country ne \"US\")"
  }
}
