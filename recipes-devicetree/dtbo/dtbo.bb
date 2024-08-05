# Add custom device trees overlays for the uthp here
# or kernel-devicetree
inherit devicetree
COMPATIBLE_MACHINE = "uthp"
SRC_URI:append = " file://MCP251xFD-SPI.dts"