repo="localhost:5001/stealthybox/nix-store"
storepath="$1"

docker build . \
  --build-context "context=/nix/store/${storepath}" \
  -t "${repo}:${storepath}"
