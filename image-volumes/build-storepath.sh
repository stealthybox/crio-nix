repo="localhost:5001/stealthybox/nix-store"
storepath="$1"

dir="/nix/store/${storepath}"
if [ ! -d "${dir}" ]; then
  echo "${dir}" is not a directory.
  exit 2
fi

cat << EOF > "/tmp/config-${storepath}.json"
{"store-path": "${dir}"}
EOF
cd "${dir}" && oras push \
  --config "/tmp/config-${storepath}.json:application/vnd.oci.image.config.v1+json" \
  "${repo}:${storepath}" \
  .
