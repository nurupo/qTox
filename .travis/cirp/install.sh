#!/usr/bin/env bash

# Install verifying the hash

# Get Python >=3.5
if [ "$TRAVIS_OS_NAME" == "osx" ]
then
  brew update

  # make sha256sum available
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

  brew upgrade python || true

  python --version || true
  python3 --version || true
  pyenv versions || true

  cd .
  cd "$(mktemp -d)"
  virtualenv env -p python3
  set +u
  source env/bin/activate
  set -u
  cd -
else
  python --version || true
  python3 --version || true
  pyenv versions || true

  pyenv global 3.6
fi

pip install --upgrade pip

check_sha256()
{
  if ! ( echo "$1  $2" | sha256sum -c --status - )
  then
    echo "Error: sha256 of $2 doesn't match the known one."
    echo "Expected: $1  $2"
    echo -n "Got: "
    sha256sum "$2"
    exit 1
  else
    echo "sha256 matches the expected one: $1"
  fi
}

# Don't install again if already installed.
# OSX keeps re-installing it tough, as it uses a temp per-script virtualenv.
if ! pip list --format=columns | grep '^ci-release-publisher '
then
  cd .
  cd "$(mktemp -d)"
  VERSION="0.2.0a1"
  FILENAME="ci_release_publisher-$VERSION-py3-none-any.whl"
  HASH="bbf821a90ff6bb537b76ca629ee1f4f64c2f785550ac09ad715a97234c481ccd"
  pip download ci_release_publisher==$VERSION
  check_sha256 "$HASH" "$FILENAME"
  pip install --no-index --find-links "$PWD" "$FILENAME"
  cd -
fi
