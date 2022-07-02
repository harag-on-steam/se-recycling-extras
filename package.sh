#!/usr/bin/sh
version_tag=$1
git archive --prefix se-recycling-extras/ -o se-recycling-extras_${version_tag}.zip ${version_tag}

