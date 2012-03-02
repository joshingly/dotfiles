#!/bin/bash

# from http://twitter.com/#!/garybernhardt/status/174224326642507776
(set -e && find . -name '.git' -type d | while read p; do (cd $(dirname $p) && git gc); done)
