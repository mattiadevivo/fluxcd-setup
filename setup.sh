#!/bin/bash
export TF_VAR_github_token=<github-token>
cd terraform/fluxcd-bootstrap
terraform init
terraform apply                                                                                                                                                                                                                                                      

