#!/bin/sh -e

# shellcheck disable=SC2002
version="$(cat plugin.yaml | grep "version" | cut -d ' ' -f 2)"
os=$(uname | tr '[:upper:]' '[:lower:]')

if ! [ -f "_dist/helm-spray-${os}-amd64.tar.gz" ]; then
  echo "Building spray v${version} for ${os}..."
  make dist_${os}
fi

echo "installing spray v${version} for ${os}..."

mkdir -p "bin"
mkdir -p "releases/v${version}"

tar xzf "_dist/helm-spray-${os}-amd64.tar.gz" -C "releases/v${version}"
if [ "${os}" = "linux" ] || [ "${os}" = "darwin" ] ; then
    cp "releases/v${version}/bin/helm-spray" "bin/helm-spray"
else
    cp "releases/v${version}/bin/helm-spray.exe" "bin/helm-spray.exe"
fi
cp "releases/v${version}/plugin.yaml" .
cp "releases/v${version}/README.md" .
cp "releases/v${version}/LICENSE" .
