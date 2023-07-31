resource "aws_dynamodb_table" "content_database" {
  name         = "content_database"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "content_id"

  attribute {
    name = "content_id"
    type = "S"
  }

  attribute {
    name = "content_file"
    type = "S"
  }

  global_secondary_index {
    name               = "content_file_index"
    hash_key           = "content_file"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}

resource "aws_dynamodb_table" "jobs" {
  name         = "jobs_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "job_id"

  attribute {
    name = "job_id"
    type = "N"
  }

  attribute {
    name = "job_type"
    type = "S"
  }

  attribute {
    name = "file_content"
    type = "S"
  }

  global_secondary_index {
    name               = "file_content_index"
    hash_key           = "file_content"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "job_type_index"
    hash_key           = "job_type"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"
}

resource "aws_dynamodb_table" "counters" {
  name           = "counters"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "table_name"
  range_key      = "attribute_name"

  attribute {
    name = "table_name"
    type = "S"
  }

  attribute {
    name = "attribute_name"
    type = "S"
  }

  attribute {
    name = "counter_value"
    type = "N"
  }

  global_secondary_index {
    name               = "counter_index"
    hash_key           = "counter_value"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}
