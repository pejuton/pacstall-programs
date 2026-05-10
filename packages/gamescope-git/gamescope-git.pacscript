pkgname="gamescope-git"
pkgdesc="Micro-compositor for game scaling"
gives="gamescope"
provides=("${gives}")
conflicts=("${gives}")
repology=("project: ${gives}")
arch=(x86_64)
pkgver="3.16.23"
url='https://github.com/ValveSoftware/gamescope/'
source=(
  "https://github.com/ValveSoftware/gamescope.git"
  "https://salsa.debian.org/games-team/gamescope/-/raw/debian/latest/debian/patches/0001_remove-forcefallback.patch"
  "https://salsa.debian.org/games-team/gamescope/-/raw/debian/latest/debian/patches/0002_remove-forced-versions.patch"
  "https://salsa.debian.org/games-team/gamescope/-/raw/debian/latest/debian/patches/0003_make_layer_lib_private.patch"
  "https://salsa.debian.org/games-team/gamescope/-/raw/debian/latest/debian/patches/0004_use_system_spirv_headers.patch"
  "https://salsa.debian.org/games-team/gamescope/-/raw/debian/latest/debian/patches/0006_use_system_wlroots_headers.patch"
  "https://salsa.debian.org/games-team/gamescope/-/raw/debian/latest/debian/patches/0007_fix_build.patch"
  "PR-2066_do_proper_wayland_teardown_cleaning_up_listeners_and_fds.patch::https://patch-diff.githubusercontent.com/raw/ValveSoftware/gamescope/pull/2066.patch"
)
sha256sums=(
  "SKIP"
  "a9f9397d61933362c1033463fce91ff9e3be3a91a6cf5ea8fc4e75b2f199af5b"
  "10f08060480e15ce57498fd657308391df624b7c3b8ef0ca6f55f3b15751c45d"
  "4396fd29b551aebdbc10c205602d0beb9275a35b0e8dab0ea709de69aac75faa"
  "68999b79721f9507f0d43b18ebbe4e75b665a77b036e6c8da3d209c6f1d9a288"
  "62e04ee36a8c71e28e9752866804ead713fef67a07a3f7ed257e9942180ec734"
  "6fd308a6ee4537f4e68213f2d79c5059e2abeaac2bc8b1ddcd95bd9bba1cfd61"
  "1f67d8fd8cb0c903d996ae1eeeb8dfab50a5a93d54a6a1048473ccd533a8f024"
)
depends=(
  "xwayland"
  "libavif16"
  "libc6"
  "libcap2"
  "libdecor-0-0"
  "libdisplay-info3>=0.3.0"
  "libdrm2"
  "libeis1"
  "libgcc-s1"
  "libinput10"
  "libliftoff0>=0.5.0"
  "libluajit-5.1-2"
  "libopenvr-api2"
  "libpipewire-0.3-0t64"
  "libpixman-1-0"
  "libsdl2-2.0-0"
  "libstdc++6"
  "libsystemd0"
  "libudev1"
  "libwayland-client0"
  "libwayland-server0"
  "libwlroots-0.19"
  "libx11-6"
  "libx11-xcb1"
  "libxcb1"
  "libxcomposite1"
  "libxcursor1"
  "libxdamage1"
  "libxext6"
  "libxfixes3"
  "libxi6"
  "libxkbcommon0"
  "libxmu6"
  "libxrender1"
  "libxres1"
  "libxtst6"
  "libxxf86vm1"
)
makedepends=(
  "cmake"
  "glslang-tools"
  "hwdata"
  "libavif-dev"
  "libbenchmark-dev"
  "libcap-dev"
  "libdisplay-info-dev"
  "libdrm-dev"
  "libeis-dev"
  "libglm-dev"
  "libinput-dev"
  "libliftoff-dev>=0.5.0"
  "libluajit-5.1-dev"
  "libopenvr-dev>=2.7"
  "libpipewire-0.3-dev"
  "libpixman-1-dev"
  "libsdl2-dev"
  "libseat-dev"
  "libstb-dev"
  "libudev-dev"
  "libvulkan-dev"
  "libwayland-dev"
  "libwlroots-0.19-dev"
  "libx11-dev"
  "libx11-xcb-dev"
  "libxcb-composite0-dev"
  "libxcb-dri3-dev"
  "libxcb-errors-dev"
  "libxcb-ewmh-dev"
  "libxcb-icccm4-dev"
  "libxcb-image0-dev"
  "libxcb-present-dev"
  "libxcb-render-util0-dev"
  "libxcb-render0-dev"
  "libxcb-res0-dev"
  "libxcb-shm0-dev"
  "libxcb-xfixes0-dev"
  "libxcb-xinput-dev"
  "libxcb1-dev"
  "libxcomposite-dev"
  "libxdamage-dev"
  "libxext-dev"
  "libxfixes-dev"
  "libxkbcommon-dev"
  "libxmu-dev"
  "libxrender-dev"
  "libxres-dev"
  "libxtst-dev"
  "libxxf86vm-dev"
  "meson"
  "pkgconf"
  "spirv-headers"
  "vkroots-headers>=0~202404300106git5106d8a"
  "wayland-protocols"
  "xwayland"
)
maintainer=("pejuton <pejuton@proton.me>")
license=('BSD-2-Clause')
external_connection=true

prepare() {
  cd "${gives}"

  for patch in "${srcdir}"/*.patch; do
    patch -p1 < "${patch}"
  done
}

build() {
  cd "${gives}"

  meson setup build/ \
    -Dpipewire=enabled \
    -Drt_cap=enabled \
    -Ddrm_backend=enabled \
    -Dsdl2_backend=enabled \
    -Davif_screenshots=enabled \
    -Dinput_emulation=enabled \
    -Denable_gamescope=true \
    -Denable_gamescope_wsi_layer=true \
    -Denable_openvr_support=true \
    -Dbenchmark=enabled \
    -Dforce_fallback_for=[] \
    --buildtype=release

  ninja -C build/ -j"${NCPU}"
}

package() {
  cd "${gives}"

  meson install -C build/ --skip-subprojects --destdir="${pkgdir}"

  install -vDm 644 LICENSE -t "${pkgdir}/usr/share/licenses/${gives}/"
}
