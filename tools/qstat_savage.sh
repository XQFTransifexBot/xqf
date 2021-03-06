#! /bin/sh

if [ "x${1}" = 'x' -o "x${1}" = 'x--help' ]
then
	printf 'Usage: %s -sam http://masterserver.savage.s2games.com/gamelist_full.dat\n' "${0}"
	exit
fi

if [ "x${2}" = 'x' ]
then
	printf 'missing argument for "%s"\n' "${1}"
	exit
fi

if [ "x${1}" != 'x-sam' ]
then
	printf 'unknown option "%s"\n' "${1}"
	exit
fi

url="${2}"

http_helper="wget -t 1 -T 20 -q -e robots=off --user-agent=XQF -O -"
server_type="SAS"
header="7e4103"

header_len="3"
data_start="5"
address_len="6"

alias get_response="${http_helper} ${url}"
alias get_header="get_response | od -N${header_len} -An -vtx1 | tr -d ' '"
alias get_data="get_response | dd bs=1 skip=${data_start} 2>/dev/null"

if [ "$(get_header)" = "${header}" ]
then
	data="$(get_data)"
	data_size="$(($(echo "${data}" | wc -c) / 6 * 6))"

	skip="0"
	while [ "${skip}" -lt "${data_size}" ]
	do
		ipv4_1="$(echo "${data}" | od -j${skip} -N1 -An -vtu1 | tr -d ' ')"
		ipv4_2="$(echo "${data}" | od -j$((${skip} + 1)) -N1 -An -vtu1 | tr -d ' ')"
		ipv4_3="$(echo "${data}" | od -j$((${skip} + 2)) -N1 -An -vtu1 | tr -d ' ')"
		ipv4_4="$(echo "${data}" | od -j$((${skip} + 3)) -N1 -An -vtu1 | tr -d ' ')"
		port="$(echo "${data}" | od -j$((${skip} + 4)) -N2 -An -vtu2 | tr -d ' ')"

		ipv4="${ipv4_1}.${ipv4_2}.${ipv4_3}.${ipv4_4}"
		server_address="${ipv4}:${port}"

		echo "${server_type} ${server_address}"

		skip="$((${skip} + ${address_len}))"
	done
fi

#EOF
