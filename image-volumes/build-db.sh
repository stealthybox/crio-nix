repo="ghcr.io/stealthybox/nix-db"
tag="$1"

dir="/nix/var/nix/db"
if [ ! -d "${dir}" ]; then
  echo "${dir}" is not a directory.
  exit 2
fi

cat << EOF > "/tmp/config-${tag}.json"
{"nix-db-sha256": "$(sha256sum /nix/var/nix/db/db.sqlite)"}
EOF
cd "${dir}" && sudo $(which oras) push \
  --config "/tmp/config-${tag}.json:application/vnd.oci.image.config.v1+json" \
  "${repo}:${tag}" \
  .
