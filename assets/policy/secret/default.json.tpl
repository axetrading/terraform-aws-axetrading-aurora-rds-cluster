{
    "Version" : "2012-10-17",
    "Id"      : "Default Policy for Secret",
    "Statement" : [
      {
        "Effect"   : "Allow",
        "Action"   : "secretsmanager:*",
        "Resource" : "*",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${account_id}:root"
          ]
        }
      }
    ]
  }