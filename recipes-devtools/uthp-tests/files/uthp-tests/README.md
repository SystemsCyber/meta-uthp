# Welcome to the UTHP test suite

The UTHP team put together a set of pytests to test the Yocto build of the UTHP (Ultimate TrucK Hacking Platform) image. The tests are located in the `uthp-tests` directory, and are run on the target device after the image has been flashed to the eMMC (embedded MultiMediaCard).

## Prerequisites

### 1. Connect the UTHP to the network and power it on

### 2. SSH into the UTHP

```bash
ssh root@192.168.7.2
```
> Don't worry, the root user will be locked, and the UTHP user will be added after the device has been flashed.

### 3. Generate the 'Production-Ready' image (i.e. the image that will be flashed to the eMMC)

```bash
sudo emmc-flasher
```

Now you are ready to take the tests for a spin! Remove the SD card from the UTHP and power cycle the device.

## Running the tests

### 1. Set up the physcial testing space

Start by plugging in the two battery chargers. Turn on both red safety switches on both the Cascadia and the Brake Board. After turning on the Cascadia switch on the back side, key on. The brake board serves a J1708 network, and the Cascadia provides CAN/J1939. Plug in the blue DSUB-15 from the brake board to the UTHP. Plug in the green Deutsch 9-pin connector to the black Deutsch-9 pin conector on the UTHP. Now the testbench is ready to go!

### 2. SSH into the UTHP

```bash
ssh uthp@192.168.7.2
```
> Password: 'UTHP-R1-XXXX' (where 'XXXX' is the last 4 digits of the UTHP serial number). This will be changed after tests are run.

### 3. Run the tests

```bash
cd uthp-tests
```

Take a look at the Makefile to see the available targets:

```bash
cat Makefile
```
Let's run the core tests:

```bash
make core-test
```
and the PLC tests:

```bash
make plc-test
```
And after we have achieved success, we can submit the image as production-ready:

1. Save the test results:

> Note: Test results should be saved to the UTHP github repo: https://github.com/SystemsCyber/UTHP/tree/main/Testing/Software/assets/logs

```bash
scp -r uthp@192.168.7.2:/home/uthp/uthp-tests/logs <destination>
```

and then copy the remote test results from your local machine as well. Save these results to the UTHP github repo, with the coreresponding UTHP serial number. An example of where and how to save the results can be found [here](https://github.com/SystemsCyber/UTHP/tree/main/Testing/Software/assets/logs).

*Note: the following destroys all results on the UTHP, so make sure to save them first!*

```bash
make production-ready
```

## Troubleshooting

If you encounter any issues, send the logs to the UTHP layer maintainer:

```bash
beersc@colostate.edu
```

## Reset the UTHP tests

If you need to reset the UTHP tests, you can do so by running the following command:

```bash
make reset
```
or if running remote tests:

```bash
make reset-remote
```
