# Meshery - Service Mesh Patterns GitHub Action

GitHub Action to deploy [Service Mesh Patterns](https://layer5.io/learn/service-mesh-books/service-mesh-patterns) on CI/CD pipelines.

## Learn More

- [Functionality: Service Mesh Patterns](https://docs.meshery.io/functionality/pattern-management)
- [Configuring your Deployment with Patterns, Filters and Applications](https://docs.meshery.io/guides/configuration-management#configuring-your-deployment-with-patterns-filters-and-applicatio)

## Supported Service Meshes

Meshery supports 10 different service meshes.

<details>
  <summary><strong>See all Supported Service Meshes</strong></summary>
<div class="container flex">
  <div class="text editable">
    <p>Service mesh adapters provision, configure, and manage their respective service meshes.
      <table class="adapters">
        <thead style="display:none;">
          <th>Status</th>
          <th>Adapter</th>
        </thead>
        <tbody>
        <tr>
          <td rowspan="9" class="stable-adapters">stable</td>
        </tr>
        <tr>
          <td><a href="https://github.com/layer5io/meshery-istio">
            <img src='https://docs.meshery.io/assets/img/service-meshes/istio.svg' alt='Meshery Adapter for Istio Service Mesh' align="middle" hspace="10px" vspace="5px" height="30px" > Meshery adapter for Istio</a>
          </td>
        </tr>
        <tr>
          <td><a href="https://github.com/layer5io/meshery-linkerd">
            <img src='https://docs.meshery.io/assets/img/service-meshes/linkerd.svg' alt='Linkerd' align="middle" hspace="5px" vspace="5px" height="30px" width="30px"> Meshery adapter for Linkerd</a>
          </td>
        </tr>
        <tr>
          <td><a href="https://github.com/layer5io/meshery-consul">
            <img src='https://docs.meshery.io/assets/img/service-meshes/consul.svg' alt='Consul Connect' align="middle" hspace="5px" vspace="5px" height="30px" width="30px"> Meshery adapter for Consul</a>
          </td>
        </tr>
        <tr>
          <td><a href="https://github.com/layer5io/meshery-octarine">
            <img src='https://docs.meshery.io/assets/img/service-meshes/octarine.svg' alt='Octarine Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Octarine</a>
          </td>
        </tr>
        <tr>
          <td><a href="https://github.com/layer5io/meshery-nsm">
            <img src='https://docs.meshery.io/assets/img/service-meshes/nsm.svg' alt='Network Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Network Service Mesh</a>
          </td>
        </tr>
         <tr>
           <td><a href="https://github.com/layer5io/meshery-kuma">
             <img src='https://docs.meshery.io/assets/img/service-meshes/kuma.svg' alt='Kuma Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Kuma</a>
           </td>
        </tr>
          <tr>
          <td><a href="https://github.com/layer5io/meshery-osm">
            <img src='https://docs.meshery.io/assets/img/service-meshes/osm.svg' alt='Open Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Open Service Mesh</a>
          </td>
        </tr>
        <tr><td colspan="2" class="stable-adapters"></td></tr>
        <tr>
          <td rowspan="5" class="beta-adapters">beta</td>
        </tr>
         <tr>
          <td><a href="https://github.com/layer5io/meshery-cpx">
            <img src='https://docs.meshery.io/assets/img/service-meshes/citrix.svg' alt='Citrix CPX Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Citrix CPX</a>
          </td>
        </tr>
        <tr>
          <td><a href="https://github.com/layer5io/meshery-traefik-mesh">
            <img src='https://docs.meshery.io/assets/img/service-meshes/traefik-mesh.svg' alt='Traefik Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Traefik Mesh</a>
          </td>
        </tr>
           <tr>
          <td><a href="https://github.com/meshery/meshery-nginx-sm">
            <img src='https://docs.meshery.io/assets/img/service-meshes/nginx-sm.svg' alt='NGINX Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for NGINX Service Mesh</a>
          </td>
        </tr>
        <tr><td colspan="2" class="beta-adapters"></td></tr>
        <tr>
          <td rowspan="3" class="alpha-adapters">alpha</td>
        </tr>
        <tr>
          <td><a href="https://github.com/meshery/meshery-tanzu-sm">
            <img src='https://docs.meshery.io/assets/img/service-meshes/tanzu.svg' alt='Tanzu Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for Tanzu SM</a>
          </td>
        </tr>
        <tr>
          <td><a href="https://github.com/meshery/meshery-app-mesh">
            <img src='https://docs.meshery.io/assets/img/service-meshes/app-mesh.svg' alt='AWS App Mesh Service Mesh' align="middle" hspace="5px" vspace="5px" height="30px" width="30px">Meshery adapter for App Mesh</a>
          </td>
        </tr>
        <tr><td colspan="2" class="alpha-adapters"></td></tr>
        </tbody>
    </table>
  </p>
</div>
 </details>

## Usage

See [action.yml](action.yml)

Users can define pattern files and store it in a remote location and pass the URL to the action or directly keep the file in the `.github` folder and reference it by file name.

### Sample Configurations

#### Deploying a pattern with URL

```yaml
name: Apply Service Mesh Pattern with Meshery
on:
  workflow_dispatch:
    inputs:
      provider_token:
        description: "Provider token to use"
        required: false
      platform:
        description: "Platform to deploy Meshery to"
        required: false
      pattern_url:
        description: "URL of the pattern to be deployed"
        required: false
      pattern_file:
        description: "Name of the pattern file relative to the .github folder"
        required: false

jobs:
  apply-pattern-file:
    name: Meshery Pattern Apply 
    runs-on: ubuntu-latest
    steps:
      - name: Setup Kubernetes
        uses: manusa/actions-setup-minikube@v2.4.1
        with:
          minikube version: 'v1.23.2'
          kubernetes version: 'v1.22.2'
          driver: docker

      - name: Apply Pattern
        uses: layer5io/mesheryctl-service-mesh-patterns-action@master
        with:
          provider_token: ${{ github.event.inputs.provider_token }}
          platform: ${{ github.event.inputs.platform }}
          pattern_url: ${{ github.event.inputs.pattern_url }}
```

### Sample Pattern File

```yaml
name: ImageHubRateLimit
version: 0.0.1
services:
  generic-istio-filter:
    type: EnvoyFilterIstio
    namespace: istio-test
    settings:
      configPatches:
        - applyTo: HTTP_FILTER
          match:
            context: SIDECAR_INBOUND
            proxy:
              proxyVersion: '^1\.9.*'
            listener:
              portNumber: 9091
              filterChain:
                filter:
                  name: envoy.http_connection_manager
                  subFilter:
                    name: envoy.router
          patch:
            operation: INSERT_BEFORE
            value:
              name: envoy.filter.http.wasm
              config_discovery:
                config_source:
                  ads: {}
                  initial_fetch_timeout: 0s
                type_urls: ["type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm"]
      workloadSelector:
        labels:
          app: api
          version: v1

  ratelimit-filter:
    type: EnvoyFilterIstio
    namespace: istio-test
    settings:
      configPatches:
        - applyTo: EXTENSION_CONFIG
          match:
            context: SIDECAR_INBOUND
          patch:
            operation: ADD
            value:
              name: envoy.filter.http.wasm
              typed_config:
                "@type": type.googleapis.com/udpa.type.v1.TypedStruct
                type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
                value:
                  config:
                    configuration:
                      "@type": type.googleapis.com/google.protobuf.StringValue
                      value: "rate_limit_filter"
                    root_id: "rate_limit_filter"
                    vm_config:
                      code:
                        remote:
                          http_uri:
                            uri: https://github.com/layer5io/image-hub/raw/master/rate-limit-filter/pkg/rate_limit_filter_bg.wasm
                          
                      runtime: envoy.wasm.runtime.v8
                      vm_id: rate_limit_filter
                      configuration:
                        "@type": type.googleapis.com/google.protobuf.StringValue
                        value: "WwogIHsKICAgICJuYW1lIjogIi9wdWxsIiwKICAgICJydWxlIjp7CiAgICAgICJydWxlVHlwZSI6ICJyYXRlLWxpbWl0ZXIiLAogICAgICAicGFyYW1ldGVycyI6WwogICAgICAgIHsiaWRlbnRpZmllciI6ICJFbnRlcnByaXNlIiwgImxpbWl0IjogMTAwMH0sCiAgICAgICAgeyJpZGVudGlmaWVyIjogIlRlYW0iLCAibGltaXQiOiAxMDB9LAogICAgICAgIHsiaWRlbnRpZmllciI6ICJQZXJzb25hbCIsICJsaW1pdCI6IDEwfQogICAgICBdCiAgICB9CiAgfSwKICB7CiAgICAibmFtZSI6ICIvYXV0aCIsCiAgICAicnVsZSI6ewogICAgICAicnVsZVR5cGUiOiAibm9uZSIKICAgIH0KICB9LAogIHsKICAgICJuYW1lIjogIi9zaWdudXAiLAogICAgInJ1bGUiOnsKICAgICAgInJ1bGVUeXBlIjogIm5vbmUiCiAgICB9CiAgfSwKICB7CiAgICAibmFtZSI6ICIvdXBncmFkZSIsCiAgICAicnVsZSI6ewogICAgICAicnVsZVR5cGUiOiAibm9uZSIKICAgIH0KICB9Cl0="
                      allow_precompiled: true
      workloadSelector:
        labels:
          app: api
          version: v1
    dependsOn:
      - generic-istio-filter
```

## Join the Community!

<a name="contributing"></a><a name="community"></a>
Our projects are community-built and welcome collaboration. 👍 Be sure to see the <a href="https://docs.google.com/document/d/17OPtDE_rdnPQxmk2Kauhm3GwXF1R5dZ3Cj8qZLKdo5E/edit">Layer5 Community Welcome Guide</a> for a tour of resources available to you and jump into our <a href="http://slack.layer5.io">Slack</a>!

<p style="clear:both;">
<a href ="https://layer5.io/community/meshmates"><img alt="MeshMates" src=".github/readme/images/Layer5-MeshMentors-1.png" style="margin-right:10px; margin-bottom:15px;" width="28%" align="left"/></a>
<h3>Find your MeshMate</h3>

<p>MeshMates are experienced Layer5 community members, who will help you learn your way around, discover live projects and expand your community network. 
Become a <b>Meshtee</b> today!</p>

Find out more on the <a href="https://layer5.io/community">Layer5 community</a>. <br />
<br /><br /><br /><br />
</p>

<div>&nbsp;</div>

<a href="https://slack.meshery.io">

<picture align="right">
  <source media="(prefers-color-scheme: dark)" srcset=".github/readme/images//slack-dark-128.png"  width="110px" align="right" style="margin-left:10px;margin-top:10px;">
  <source media="(prefers-color-scheme: light)" srcset=".github/readme/images//slack-128.png" width="110px" align="right" style="margin-left:10px;padding-top:5px;">
  <img alt="Shows an illustrated light mode meshery logo in light color mode and a dark mode meshery logo dark color mode." src=".github/readme/images//slack-128.png" width="110px" align="right" style="margin-left:10px;padding-top:13px;">
</picture>
</a>


<a href="https://meshery.io/community"><img alt="Layer5 Cloud Native Community" src=".github/readme/images//community.svg" style="margin-right:8px;padding-top:5px;" width="140px" align="left" /></a>

<p>
✔️ <em><strong>Join</strong></em> any or all of the weekly meetings on <a href="https://calendar.google.com/calendar/b/1?cid=bGF5ZXI1LmlvX2VoMmFhOWRwZjFnNDBlbHZvYzc2MmpucGhzQGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20">community calendar</a>.<br />
✔️ <em><strong>Watch</strong></em> community <a href="https://www.youtube.com/playlist?list=PL3A-A6hPO2IMPPqVjuzgqNU5xwnFFn3n0">meeting recordings</a>.<br />
✔️ <em><strong>Access</strong></em> the <a href="https://drive.google.com/drive/u/4/folders/0ABH8aabN4WAKUk9PVA">Community Drive</a> by completing a community <a href="https://layer5.io/newcomer">Member Form</a>.<br />
✔️ <em><strong>Discuss</strong></em> in the <a href="https://discuss.layer5.io">Community Forum</a>.<br />

</p>
<p align="center">
<i>Not sure where to start?</i> Grab an open issue with the <a href="https://github.com/issues?q=is%3Aopen+is%3Aissue+archived%3Afalse+org%3Alayer5io+org%3Ameshery+org%3Aservice-mesh-performance+org%3Aservice-mesh-patterns+label%3A%22help+wanted%22+">help-wanted label</a>.</p>
