#!/bin/sh
#
# git-crypt-unlock - Work around a bug in git-crypt.
# 
# This will unlock the repo even though git-crypt can't do it. May not be
# as secure as git-crypt's correct implementation would be.

umask 077
for FILE in `find .git-crypt/keys/default -type f`; do
  if gpg --pinentry-mode=loopback --decrypt < $FILE > git-crypt-symmetric-key; then
    git-crypt unlock git-crypt-symmetric-key
    rm -f git-crypt-symmetric-key
    exit 0
  fi
done
