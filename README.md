# meta-uthp Layer

This README file contains information on the contents of the meta-uthp layer.

Please see the corresponding sections below for details.

## Dependencies

The meta-uthp layer depends on the following layers:

- **URI**: core  
  **branch**: scarthgap

- **URI**: meta-openembedded/meta-python 
  **branch**: scarthgap

- **URI**: meta-python2
  **branch**: master / close to scarthgap

- **URI**: networking-layer (meta-openembedded/meta-networking)
  **branch**: scarthgap

- **URI**: jupyter-layer
  **branch**: master / close to scarthgap

- **URI**: arm-toolchain  
  **branch**: scarthgap

- **URI**: meta-arm  
  **branch**: scarthgap

- **URI**: meta-ti-bsp  
  **branch**: scarthgap

- **URI**: meta-ti-extras  
  **branch**: scarthgap

## From scratch:

```shell
mkdir <workspace>
cd <workspace>
```
Download the uthp-setup-dev-env.sh script:
```shell
wget https://github.com/SystemsCyber/meta-uthp/raw/scarthgap/uthp-setup-dev-env.sh
```
Run it:
```shell
chmod +x uthp-setup-dev-env.sh
./uthp-setup-dev-env.sh
```
After it has run, you'll need to source oe-init-build-env:
```shell
source Yocto/oe-init-build-env
```
We use a custom patch so run this and wait for it to complete:
```shell
devtool modify linux-bb.org
```
Then you can build the image:
```shell
bitbake core-image
```
> DO NOT MODIFY ANYTHING while the build is running. It will take a while to complete for the first time. Maybe go get a coffee or something:
```shell
tmux new-session -d -s core-image 'bitbake core-image'
```
After the image is complete, you can flash it to your device from 'deploy-ti/images/uthp/core-image-uthp.rootfs.wic.xz' with your favorite flashing tool (tested with balenaEtcher).

Any issues can be reported to the layer maintainer as of 8/16/2024: beersc@colostate.edu
---
