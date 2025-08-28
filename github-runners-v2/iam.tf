resource "aws_iam_role" "runners_ec2_role" {
  name = "${var.environment}-${var.prefix}-runners-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.runners_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "read_pat" {
  name = "${var.environment}-${var.prefix}-read-github-pat"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "ReadSSMParam",
        Effect: "Allow",
        Action: ["ssm:GetParameter"],
        Resource: "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.github_pat_ssm_parameter_name}"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "attach_read_pat" {
  role       = aws_iam_role.runners_ec2_role.name
  policy_arn = aws_iam_policy.read_pat.arn
}

resource "aws_iam_instance_profile" "runners_ec2_profile" {
  name = "${var.environment}-${var.prefix}-runners-ec2-profile"
  role = aws_iam_role.runners_ec2_role.name
}