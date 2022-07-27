## foundation-rk3588

![Logo badge](https://img.shields.io/endpoint?url=https://logo-badge-without-release-image-0lnvd7unef6z.runkit.sh) 

A "**foundation**" in openFyde is where we keep reusable and shared assets, they usually form a foundational layer to a family of hardware devices. 

Often a foundation is made towards a family or a specific model of SoC, all devices in openFyde having this (family of) SoC will then be able to inherit from this foundation.

This repository has the foundation for the RK3588 SoC.


<br>

## Contents

We store packages that are reused across multiple hardware devices that share similarities in a foundation. Specifically, this usually includes `chipset` and `baseboard`:

 - a `chipset` is a special overlay that consists of necessary configuration scripts and required packages for the corresponding SoC itself. This usually includes media codecs (under media-libs), Mali GPU User-Space drivers and necessary Linux kernel patches.
 - a `baseboard` is a special overlay that has most of the common packages needed for all openFyde devices as well as a family of devices sharing similar design principles. For example, `baseboard-rockpi4` contains software packages needed for openFyde under all Rock Pi 4 variants (Rock Pi 4B, Rock Pi 4C Plus and etc.).

 <br>

###### Copyright (c) 2022 Fyde Innovations and the openFyde Authors. Distributed under the license specified in the root directory of this repository.
