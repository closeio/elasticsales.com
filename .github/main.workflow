workflow "Deploy on push" {
  on = "push"
  resolves = ["Clear Cloudfront Cache"]
}

action "Filter for master branch" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "branch master"
}

action "Upload to S3" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  secrets = [
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  args = "s3 cp . s3://elasticsales.com/ --recursive --exclude \".git/*\""
  needs = ["Filter for master branch"]
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
