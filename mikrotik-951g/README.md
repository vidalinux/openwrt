# ar934x NAND subpage-write fix (OpenWrt contribution)

Fixes the NAND rootfs mount failure / boot loop on ath79 boards that use the
AR934x NAND controller with software ECC (`ar934x-nand`), e.g. MikroTik
RB951G-2HnD.

## Files

- `0000-cover-letter.patch` — series description (send along with the patches)
- `0001-mtd-rawnand-ar934x-disable-subpage-writes-for-2048-b.patch`
- `0002-ath79-meraki-mr18-keep-the-vendor-subpage-write-layo.patch`
- `0003-ath79-mikrotik-write-NAND-kernel-images-with-kernel2.patch`

Generated against tag `v25.12.5` (they also apply, with fuzz, to 24.10; the
driver code is identical).

## Verify locally

```sh
git clone -b v25.12.5 --depth=1 https://github.com/openwrt/openwrt.git
cd openwrt
git am /path/to/0001-*.patch /path/to/0002-*.patch /path/to/0003-*.patch
```

## Summary of the bug

The AR934x controller cannot write subpages, but for software ECC the driver
advertised subpage support, so UBI created a subpage layout (VID header offset
512). That layout is not reliably writable, so the rootfs failed to mount on
the next boot. Disabling subpage writes makes UBI use VID header offset 2048.
Because yafut relies on subpage writes, the MikroTik NAND kernel image is
written with `kernel2minor` + `nandwrite` again (patch 3).
