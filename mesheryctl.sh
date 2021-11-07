#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

declare -A adapters
adapters["istio"]=meshery-istio:10000
adapters["linkerd"]=meshery-linkerd:10001
adapters["consul"]=meshery-consul:10002
adapters["octarine"]=meshery-octarine:10003
adapters["nsm"]=meshery-nsm:10004
adapters["network_service_mesh"]=meshery-nsm:10004
adapters["kuma"]=meshery-kuma:10007
adapters["cpx"]=meshery-cpx:10008
adapters["osm"]=meshery-osm:10009
adapters["open_service_mesh"]=meshery-osm:10009
adapters["traefik-mesh"]=meshery-traefik-mesh:10006
adapters["traefik_mesh"]=meshery-traefik-mesh:10006

main() {

	local pattern_filename=pat.yml
	local service_mesh="istio"
	

	parse_command_line "$@"

	
	

		shortName=$(echo ${adapters["$service_mesh"]} | cut -d '-' -f2 | cut -d ':' -f1)
		
		docker network connect bridge meshery_meshery_1
		docker network connect minikube meshery_meshery_1
		docker network connect bridge meshery_meshery-"$shortName"_1
		docker network connect minikube meshery_meshery-"$shortName"_1

		mesheryctl system config minikube -t ~/auth.json
		docker ps
		mesheryctl pattern apply --file https://raw.githubusercontent.com/service-mesh-patterns/service-mesh-patterns/master/samples/IstioFilterPattern.yaml -t ~/auth.json

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