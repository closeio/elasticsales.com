workflow "Deploy on push" {
  on = "push"
  resolves = ["Clear Cloudfront Cache"]
}

action "Upload to S3" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  secrets = [
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  args = "s3 cp . s3://elasticsales.com/ --recursive --exclude \".git/*\""
}

action "Clear Cloudfront Cache" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  args = "cloudfront create-invalidation --distribution-id E1C4KTRS0CIHOJ --paths '/*'"
  secrets = [
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  needs = ["Upload to S3"]
}
