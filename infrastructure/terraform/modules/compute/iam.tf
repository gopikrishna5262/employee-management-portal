resource "aws_iam_role" "app" {
  name = "${var.environment}-app-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy" "secrets" {
  name = "${var.environment}-secrets-read"
  role = aws_iam_role.app.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = var.db_secret_arn
    }]
  })
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.environment}-app-profile"
  role = aws_iam_role.app.name
}


data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "artifacts" {
  name = "${var.environment}-artifacts-read"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ListArtifactsBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = var.artifacts_bucket_arn
      },
      {
        Sid    = "ReadArtifacts"
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${var.artifacts_bucket_arn}/*"
      }
    ]
  })
}
