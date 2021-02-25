#!/bin/sh

# create repository
cd projects
git init test.ga
cd test.ga

echo new >a
git add a
git commit -am 'add'

git remote add origin /tmp/test.ga
git clone --mirror . /tmp/test.ga
git push

git checkout -b junk
echo hi >b

git add b
git commit -am 'add'

git push origin junk
ga master junk

cd ..
rm -rf test.ga /tmp/test.ga
