#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

main() {

	local provider_token=
	local PLATFORM=docker
	local service_mesh_adapter=

	parse_command_line "$@"

	echo "Checking if a k8s cluster exits..."
	if kubectl config current-context
	then
		echo "Cluster found"
	else
		printf "Cluster not found. \nCreating one...\n"
		create_k8s_cluster
		echo "Cluster created successfully!"
	fi

	if [[ -z $provider_token ]]
	then
		printf "Token not provided.\n Using local provider..."
		echo '{ "meshery-provider": "None", "token": null }' | jq -c '.token = ""'> ~/auth.json
	else
		echo '{ "meshery-provider": "Meshery", "token": null }' | jq -c '.token = "'$provider_token'"' > ~/auth.json
	fi

	kubectl config view --minify --flatten > ~/minified_config
	mv ~/minified_config ~/.kube/config

	curl -L https://git.io/meshery | DEPLOY_MESHERY=false bash -

	mesheryctl system context create new-context --adapters $service_mesh_adapter --platform docker --url http://localhost:9081 --set --yes

	mesheryctl system start --yes

	sleep 30
}

create_k8s_cluster() {
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
	sudo apt update -y
	sudo apt install conntrack
	minikube version
	minikube start --driver=docker --kubernetes-version=v1.20.7
	sleep 40
}

wait_for_docker() {
	while :
	do
		if docker version -f '{{.Server.Version}} - {{.Client.Version}}'
		then
			break
		else
			sleep 5
		fi
	done
}

meshery_config() {
	mkdir ~/.meshery
	config='{"contexts":{"local":{"endpoint":"http://localhost:9081","token":"Default","platform":"docker","adapters":[],"channel":"stable","version":"latest"}},"current-context":"local","tokens":[{"location":"auth.json","name":"Default"}]}'

	echo $config | yq e '."contexts"."local"."adapters"[0]="'$1'"' -P - > ~/.meshery/config.yaml

	cat ~/.meshery/config.yaml
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
					PLATFORM=$2
					shift
				else
					echo "ERROR: '-p|--platform' cannot be empty." >&2
					exit 1
				fi
				;;
			--service-mesh)
				if [[ -n "${2:-}" ]]; then
					service_mesh_adapter=meshery-$2
					shift
				else
					echo "ERROR: '--service-mesh' cannot be empty." >&2
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