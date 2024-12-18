#!/bin/bash
tofu state rm module.custom_cluster.rancher2_cluster_v2.custom_cluster_vsphere
tofu state rm rancher2_auth_config_activedirectory.activedirectory
for i in $(tofu state list | grep ^module\.rancher\.) ; do tofu state rm $i ; done
tofu destroy -auto-approve