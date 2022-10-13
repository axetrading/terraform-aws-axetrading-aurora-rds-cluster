{
   "Version": "2008-10-17",
   "Id": "Default Policy for KMS Key",
   "Statement": [
   {
      "Sid":"Allow Root User full permissions to the KMS Key",
      "Effect": "Allow",
      "Principal": {
         "AWS": [ 
            "arn:aws:iam::${account_id}:root"
         ]
      },
      "Action": "kms:*",
      "Resource" : "*"
   }
   %{ if principals != [] }
   ,{
      "Sid": "Allow access to Secret for all principals in the account that are authorized to use Secret",
      "Effect": "Allow",
      "Principal": {
          "AWS": ${jsonencode(principals)}
      },
      "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey"
      ],
      "Resource": "*"
   }
   %{endif}
  ]
}