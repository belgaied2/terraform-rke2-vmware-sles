output "rancher_url" {
  value = rancher2_bootstrap.admin.url 
  description = "value of rancher url"
}

output "rancher_token" {
  value = rancher2_bootstrap.admin.token
  description = "value of rancher token"
}