#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

# Short names
declare -A meshName
meshName["open_service_mesh"]=osm
meshName["traefik_mesh"]=traefik-mesh
meshName["network_service_mesh"]=nsm

main() {
	local INPUT_SERVICE_MESH="istio"
	get_dependencies

	setupArgs=()
	if [[ -n "${INPUT_PROVIDER_TOKEN:-}" ]]; then
		setupArgs+=(--provider-token ${INPUT_PROVIDER_TOKEN})
	fi

	if [[ -n "${INPUT_PLATFORM:-}" ]]; then
		setupArgs+=(--platform ${INPUT_PLATFORM})
	fi

	if [[ -n "${INPUT_SERVICE_MESH:-}" ]]; then
		meshNameLower=`echo $INPUT_SERVICE_MESH  | tr -d '"' | tr '[:upper:]' '[:lower:]'`
		if [ $meshNameLower = "open_service_mesh" ] || [ $meshNameLower = "traefik_mesh" ] || [ $meshNameLower = "network_service_mesh" ]
		then
			serviceMeshAbb=${meshName["$meshNameLower"]}
		else
			serviceMeshAbb=$meshNameLower
		fi
		setupArgs+=(--service-mesh ${serviceMeshAbb})
	fi

	bash "$SCRIPT_DIR/meshery.sh" "${setupArgs[@]}"

	commandArgs=()
	if [[ -n "${INPUT_PATTERN_FILENAME:-}" ]]; then
		commandArgs=(--pattern-filename ${INPUT_PATTERN_FILENAME})
	fi

	if [[ -n "${INPUT_PATTERN_NAME:-}" ]]; then
		commandArgs=(--pattern-name ${INPUT_PATTERN_NAME})
	fi

	if [[ -n "${INPUT_SERVICE_MESH:-}" ]]; then
		commandArgs+=(--service-mesh ${meshNameLower})
	fi

	bash "$SCRIPT_DIR/mesheryctl.sh" "${commandArgs[@]}"
}

get_dependencies() {
	sudo wget https://github.com/mikefarah/yq/releases/download/v4.10.0/yq_linux_amd64 -O /usr/bin/yq --quiet
	sudo chmod +x /usr/bin/yq
}

main