# helm-starter

Cross helm plugin for managing [helm starters](https://helm.sh/docs/developing_charts/#chart-starter-packs). Helm starters
are used by the `helm create` command to customize the default chart.

Example helm starters:

* <https://github.com/salesforce/helm-starter-istio>
* <https://github.com/sitewards/helm-chart>

## Installation

```sh
> helm plugin install https://github.com/Hakob/helm-starter.git
```

## Usage

* `helm starter fetch GITURL`: Clones a bare helm starter repo into `$HELM_HOME/starters`
* `helm starter list`: Lists all the starters in `$HELM_HOME/starters`
* `helm starter update NAME`: Refresh an installed Helm starter
* `helm starter delete NAME`: Delete `name` from `$HELM_HOME/starters`
* `helm starter inspect NAME`: Print out a starter's readme
* `helm starter --help`: print help

To use a starter, run:

```sh
> helm create CHART_NAME --starter STARTER_NAME
```

## Example

```sh
> helm starter fetch https://github.com/salesforce/helm-starter-istio.git
> helm create banana-service --starter helm-starter-istio
```

## Important Notes

Windows version is currently under maintenance. [See](https://github.com/helm/helm/blob/14d0c13e9eefff5b4a1b511cf50643529692ec94/cmd/helm/plugin.go#L58)
