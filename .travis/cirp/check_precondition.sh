#!/usr/bin/env bash

if [ ! -z "$TRAVIS_PULL_REQUEST" ] && [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  echo "Skipping publishing in a Pull Request"
  exit 0
fi
