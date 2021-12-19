#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

main() {

	local provider_token=
	local meshery_platform=

	parse_command_line "$@"

	if [[ -z $provider_token ]]
	then
		printf "Token not provided.\n Using local provider..."
		echo '{ "meshery-provider": "None", "token": null }' | jq -c '.token = ""'> ~/auth.json
	else
		echo '{ "meshery-provider": "Meshery", "token": null }' | jq -c '.token = "'$provider_token'"' > ~/auth.json
	fi

	kubectl config view --minify --flatten > ~/minified_config
	mv ~/minified_config ~/.kube/config

	curl -L https://git.io/meshery | PLATFORM=$meshery_platform bash -

	sleep 30
}

parse_command_line() {
	while :
	do
		case "${1:-}" in
			-t|--provider-token)
				if [[ -n "${2:-}" ]]; then
					provider_token=$2
					shift
				else
					echo "ERROR: '-t|--provider_token' cannot be empty." >&2
					exit 1
				fi
				;;
			-p|--platform)
				if [[ -n "${2:-}" ]]; then
					meshery_platform=$2
					shift
				else
					echo "ERROR: '-p|--platform' cannot be empty." >&2
					exit 1
				fi
				;;
			*)
				break
				;;
		esac
		shift
	done
}

main "$@"