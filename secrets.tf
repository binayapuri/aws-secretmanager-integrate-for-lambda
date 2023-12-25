

# Secrets Manager Secret
resource "aws_secretsmanager_secret" "secrets" {
  for_each                = toset(var.secret_names)
  name                    = each.value
  description             = "Secret for ${each.value}"
  recovery_window_in_days = var.recovery_duration_in_days

  tags = merge(var.tags, {
    Name = each.value
  })
}

# Secrets Manager Secret Versions
resource "aws_secretsmanager_secret_version" "dereh" {
  for_each          = var.secrets_map
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string     = jsonencode(each.value)
  
}




# IAM Role Policy
resource "aws_iam_role_policy" "secrets_manager_policy" {
  name = "secrets_manager_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for secret_version in [
        aws_secretsmanager_secret_version.dereh["driive"],  // Access specific secret versions
        aws_secretsmanager_secret_version.dereh["confluence"],
        aws_secretsmanager_secret_version.dereh["jira"],
      ] : {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = secret_version.arn,
      }
    ]
  })
}
