

variable "secret_names" {
  type    = list(string)
  default = ["driive", "confluence", "jira"]
}

variable "recovery_duration_in_days" {
  type    = number
  default = 0
}

variable "tags" {
  type    = map(string)
  default = {}
}

# variable "service_account_json" {
#   type    = string
#   default = <<JSON
# {
#   "type": "service_account",
#   "project_id": "adex-chat",
#   "private_key_id": "bdc3e7128fadsgsdgsgefgsfga4071c0d9"
# }
# JSON
# }

variable "secrets_map" {
  type = map(object({
    endpoint = string
  }))
  default = {
    driive = {
      endpoint = <<JSON
{
  "type": "service_account",
  "project_id": "adex-chat",
  "private_key_id": "bdc3e7128fadsgsdgsgefgsfga4071c0d9"
}
JSON
    },
    confluence = {
      endpoint             = "https://endpoint2.com"
    },
    jira = {
      endpoint             = "https://endpoint1.com"
    },
  }
}