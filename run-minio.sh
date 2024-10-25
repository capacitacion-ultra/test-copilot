docker run -d \
  --name minio \
  -p 34567:9001 \
  -p 9000:9000 \
  -v ~/minio-data:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=UrbiEtOrbi1_" \
 minio/minio server /data --console-address ":9001"