#!/bin/sh

kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.2.0"
