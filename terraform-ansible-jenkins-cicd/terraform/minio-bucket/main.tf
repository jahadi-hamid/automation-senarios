
resource "minio_s3_bucket" "paste" {
  bucket = "paste"
  acl    = "public"
}