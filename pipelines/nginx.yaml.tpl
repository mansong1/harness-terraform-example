pipeline:
    name: nginx
    identifier: nginx
    projectIdentifier: ${project_id}
    orgIdentifier: ${org_id}
    storeType: ""
    remoteType: create
    tags: {}
    stages:
        - stage:
              name: Staging
              identifier: Staging
              description: ""
              type: Deployment
              spec:
                  serviceConfig:
                      serviceRef: ${service_id}
                      serviceDefinition:
                          spec:
                              variables: []
                              manifests:
                                  - manifest:
                                        identifier: nginx
                                        type: HelmChart
                                        spec:
                                            store:
                                                type: Http
                                                spec:
                                                    connectorRef: ${bitname_connector}
                                            chartName: nginx
                                            chartVersion: <+input>
                                            helmVersion: V3
                                            skipResourceVersioning: false
                          type: NativeHelm
                  infrastructure:
                      environmentRef: ${environment_id}
                      infrastructureDefinition:
                          type: KubernetesDirect
                          spec:
                              connectorRef: ${kubernetes_connector}
                              namespace: default
                              releaseName: release-<+INFRA_KEY>
                      allowSimultaneousDeployments: false
                  execution:
                      steps:
                          - step:
                                name: Helm Deployment
                                identifier: helmDeployment
                                type: HelmDeploy
                                timeout: 10m
                                spec:
                                    skipDryRun: false
                      rollbackSteps:
                          - step:
                                name: Helm Rollback
                                identifier: helmRollback
                                type: HelmRollback
                                timeout: 10m
                                spec: {}
              tags: {}
              failureStrategies:
                  - onFailure:
                        errors:
                            - AllErrors
                        action:
                            type: StageRollback