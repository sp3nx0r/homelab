#!/bin/bash

for i in {100..105}; do zfs destroy rpool/data/vm-$i-cloudinit; zfs destroy rpool/data/vm-$i-disk-0; done
for i in {100..105}; do qm stop $i; qm destroy $i; done
