workflow "Upload to S3" {
  on = "push"
  resolves = ["Clear CDN Cache"]
}

action "GitHub Action for AWS" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  secrets = ["AWS_ACCESS_KEY_SECRET", "AWS_ACCESS_KEY_ID"]
  args = "s3 cp . s3://elasticsales.com/ --recursive --exclude \".git/*\""
}

action "Clear CDN Cache" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  needs = ["GitHub Action for AWS"]
  args = "cloudfront create-invalidation --distribution-id E1C4KTRS0CIHOJ --paths '/*'"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_ACCESS_KEY_SECRET"]
}
