resource "aws_iam_role" "lambda_role" {
  name = "terraform_aws_lambda_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
#IAM POLICY for lambda 

resource "aws_iam_policy" "aws_iam_policy_lambda" {
    name = "terraform_aws_iam_policy_for_lambda"
    path = "/"
    description = "AWS IAM Policy for lambda role"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#
resource "aws_iam_role_policy_attachment" "attach_policy_to_iam_role"{
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.aws_iam_policy_lambda.arn
}

resource "aws_lambda_function" "terraform_lambda_function"{
    filename = "${path.module}/python/hello-python.zip"
    function_name = "oluwafemi_lambda_function"
    role = aws_iam_role.lambda_role.arn 
    handler = "hello-python.lambda_handler"
    runtime = "python3.8"
    depends_on = [aws_iam_role_policy_attachment.attach_policy_to_iam_role]

}

