# Dynamodb Table
resource "aws_dynamodb_table" "challenge_sprint_table" {
    name                = "user_infos"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "user_id"
    attribute {
        name            = "user_id"
        type            = "N"
    }
}

# DynamoDB Endpoint
resource "aws_vpc_endpoint" "dynamodb_Endpoint" {
    vpc_id              = aws_vpc.vpc.id
    service_name        = "com.amazonaws.us-east-1.dynamodb"
    vpc_endpoint_type   = "Gateway"
    route_table_ids     = [aws_route_table.private.id]
    policy              = jsonencode({
        "Version"       : "2012-10-17",
        "Statement"     : [
            {
                "Effect"    : "Allow",
                "Principal" : "*",
                "Action"    : "*",
                "Resource"  : "*"
            }
        ]
    })
}