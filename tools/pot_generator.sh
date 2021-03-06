#! /bin/sh

#
# This script automatically updates translation template from the source code of XQF
#

if [ "x${1}" = 'x-h' -o "x${1}" = 'x--help' -o "x${1}" = 'x' ]
then
	echo "Usage: ${0} [XQF's source root directory]"
	exit
fi
		
POT="${1}/po/xqf.pot"
VERSION="$(git describe --abbrev=0 --tags)"

find "${1}" -name '*.c' -o -name '*.ui' -o -name 'xqf.desktop.in' \
	| sort \
	| xgettext \
		--from-code='UTF-8' \
		--package-name='XQF' \
		--copyright-holder='XQF Team' \
		--msgid-bugs-address='https://github.com/xqf/xqf/issues' \
		--no-location \
		--package-version="${VERSION}" \
		-o "${POT}" \
		-k'_' \
		-k'N_' \
		-f -

#EOF
