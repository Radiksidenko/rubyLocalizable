#!/bin/bash
echo

cd "$(dirname "$0")"

mkdir "Localization"
ruby rubyResources/script.rb
