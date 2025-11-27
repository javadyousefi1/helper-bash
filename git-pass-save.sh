#!/bin/bash

# Enable permanent Git credential storing
git config --global credential.helper store

echo "Credential helper 'store' enabled successfully."
echo "Next time you run git pull, enter your username & token ONCE."
