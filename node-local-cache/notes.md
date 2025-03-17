# Container is copy on write
- mount host://opt/read-only-nix to container://mnt/nix


## Goal
1. single cache
2. construct a writable version inside the CoW

1. get a store generated
    1. easiest is to use hostPath and build it
2. 


# Needs
- kubectl
- eksctl
- k9s
- kubectx
