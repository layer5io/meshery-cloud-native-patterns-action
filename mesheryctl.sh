#!/usr/bin/env bash

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")


main() {
	curl -LO https://raw.githubusercontent.com/service-mesh-patterns/service-mesh-patterns/master/samples/IstioFilterPattern.yaml

	local pattern_filename=pat.yml
	

	parse_command_line "$@"

	if [ -z "$pattern_name" ]
	then
		docker network connect bridge meshery_meshery_1
		docker network connect minikube meshery_meshery_1
		docker network connect bridge meshery_meshery-"$shortName"_1
		docker network connect minikube meshery_meshery-"$shortName"_1

		mesheryctl system config minikube -t ~/auth.json
		mesheryctl pattern apply --file https://raw.githubusercontent.com/sayantan1413/ci-tests/master/istio_install.yml -t ~/auth.json

            

		 

	fi
}

parse_command_line() {
	while :
	do
		case "${1:-}" in
			--pattern-filename)
				if [[ -n "${2:-}" ]]; then
					pattern_filename=$2
					shift
				else
					echo "ERROR: '--pattern-filename' cannot be empty." >&2
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