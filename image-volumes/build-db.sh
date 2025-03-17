repo="localhost:5001/stealthybox/nix-db"
tag="$1"

docker build . \
  --build-context "context=/nix/var/nix/db" \
  -t "${repo}:${tag}"

