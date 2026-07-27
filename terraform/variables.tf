variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "ses_from_address" {
  description = "Verified SES sender email address"
  type        = string
}

variable "ses_to_address" {
  description = "Recipient email address for job digests"
  type        = string
}

variable "orchestrator_weekday_schedule" {
  description = "EventBridge cron expression for the Orchestrator Lambda on weekdays"
  type        = string
  default     = "cron(0 8-18/2 ? * MON-FRI *)" # every 2 hrs, 8am-6pm UTC, Mon-Fri
}

variable "orchestrator_weekend_schedule" {
  description = "EventBridge cron expression for the Orchestrator Lambda on weekends"
  type        = string
  default     = "cron(0 8 ? * SAT-SUN *)" # once at 8am UTC, Sat-Sun
}

variable "notifier_weekday_schedule" {
  description = "EventBridge cron expression for the Notifier Lambda on weekdays (30 min after orchestrator)"
  type        = string
  default     = "cron(30 8-18/2 ? * MON-FRI *)"
}

variable "notifier_weekend_schedule" {
  description = "EventBridge cron expression for the Notifier Lambda on weekends (30 min after orchestrator)"
  type        = string
  default     = "cron(30 8 ? * SAT-SUN *)"
}

variable "lookback_minutes" {
  description = "Minutes the Notifier looks back when querying for new jobs"
  type        = number
  default     = 60
}

variable "builtin_location" {
  description = "Location substring to additionally keep for the Built In (builtin.com) ATS backend; blank disables it (remote-only)"
  type        = string
  default     = ""
}

variable "builtin_work_type" {
  description = "Work-type keyword to keep for the Built In ATS backend (remote, hybrid, office, any, or any literal substring)"
  type        = string
  default     = "remote"
}

variable "location" {
  description = "Location substring to additionally keep for every ATS backend except builtin; blank disables it (remote-only). Independent of builtin_location"
  type        = string
  default     = ""
}

variable "work_type" {
  description = "Work-type keyword to keep for every ATS backend except builtin (remote, hybrid, office, any, or any literal substring). Independent of builtin_work_type"
  type        = string
  default     = "remote"
}

variable "lambda_timeout_seconds" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 300
}

variable "lambda_memory_mb" {
  description = "Lambda function memory in MB (orchestrator and notifier)"
  type        = number
  default     = 512
}

variable "worker_memory_mb" {
  description = "Worker Lambda memory in MB"
  type        = number
  default     = 512
}
