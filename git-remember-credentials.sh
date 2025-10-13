#!/bin/bash
set -e

git config --global credential.helper store
echo "✅ Git HTTPS credentials will now be remembered after first login."
