resource "aws_iam_role" "role" {
  name = "LambdaWriteAndReadToDBRole"

  assume_role_policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    POLICY
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBPolicy"
  description = "Permissions to write, read, and scan DynamoDB table"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "WriteAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "${aws_dynamodb_table.jobs.arn}"
    },
    {
      "Sid": "ReadAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.jobs.arn}"
    },
    {
      "Sid": "DynamoDBAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:Scan"
      ],
      "Resource": "${aws_dynamodb_table.jobs.arn}"
    },
    {
      "Sid": "WriteAccessContentDatabase",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "${aws_dynamodb_table.content_database.arn}"
    },
    {
      "Sid": "ReadAccessContentDatabase",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.content_database.arn}"
    },
    {
      "Sid": "WriteAccessCountersTable",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "${aws_dynamodb_table.counters.arn}"
    },
    {
      "Sid": "ReadAccessCountersTable",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.counters.arn}"
    },
    {
      "Sid": "UpdateAccessCountersTable",
      "Effect": "Allow",
      "Action": [
        "dynamodb:UpdateItem"
      ],
      "Resource": "${aws_dynamodb_table.counters.arn}"
    },
    {
        "Sid": "DynamoDBStreamAccess",
        "Effect": "Allow",
        "Action": [
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams"
        ],
        "Resource": "${aws_dynamodb_table.jobs.stream_arn}"
    },
    {
    "Sid": "ScanAccess",
    "Effect": "Allow",
    "Action": [
      "dynamodb:Scan"
      ],
      "Resource": "${aws_dynamodb_table.jobs.arn}"
    }

  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "dynamodb_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "lambda-dynamodb-policy"
  role   = aws_iam_role.role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ],
      "Resource": "${aws_dynamodb_table.jobs.arn}/stream/*"
    }
  ]
}
POLICY
}



output "iamRole" {
  value = aws_iam_policy.dynamodb_policy.policy
  sensitive = false
}