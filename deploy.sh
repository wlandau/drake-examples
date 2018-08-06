#!/bin/sh
set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "will.landau@gmail.com"
git config --global user.name "wlandau"

make
git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git gh-pages
mv README.md gh-pages
ls *.zip > gh-pages/examples.md
mv *.zip gh-pages
cd gh-pages
git add --all *.md *.zip
git commit -m "Update example archives" || true
git push -q origin gh-pages
