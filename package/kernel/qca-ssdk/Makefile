include $(TOPDIR)/rules.mk

PKG_NAME:=qca-ssdk
PKG_RELEASE:=2

PKG_SOURCE_URL:=https://git.codelinaro.org/clo/qsdk/oss/lklm/qca-ssdk.git
PKG_SOURCE_PROTO:=git
ifeq ($(CONFIG_TARGET_ipq806x), y)
PKG_SOURCE_DATE:=2022-09-12
PKG_SOURCE_VERSION:=628b22bc3d5ee81414b75ab3de6a255c82754dec
PKG_MIRROR_HASH:=b44105ee7f27a4893c375c7839f3b0808fb762781a9bf511d133e6b7085a3233
PATCH_DIR:=patches_ipq806x
else
PKG_SOURCE_DATE:=2024-04-17
PKG_SOURCE_VERSION:=3d060f7ad70d087f6b0452abe79ab6d042e8cd53
PKG_MIRROR_HASH:=6f5e390b294e699491584094f5d7eb941de6237ad8c5320191e9e306fbcd8eb5
endif

PKG_FLAGS:=nonshared
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-lto

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/qca-ssdk
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Network Devices
  TITLE:=Qualcom SSDK switch driver
  DEPENDS:=@(TARGET_qualcommax)
ifeq ($(CONFIG_TARGET_ipq806x), y)
  FILES:=$(PKG_BUILD_DIR)/build/bin/qca-ssdk.ko
else
  FILES:=$(PKG_BUILD_DIR)/qca-ssdk.ko
endif
  AUTOLOAD:=$(call AutoLoad,30,qca-ssdk)
endef

define KernelPackage/qca-ssdk/Description
  Driver for Qualcomm Atheros switches.
endef

GCC_VERSION=$(shell echo "$(CONFIG_GCC_VERSION)" | sed 's/[^0-9.]*\([0-9.]*\).*/\1/')

LNX_CONFIG_OPTS = LNX_MAKEOPTS='$(KERNEL_MAKEOPTS)' PRJ_PATH=$(PKG_BUILD_DIR) MODULE_TYPE=KSLIB modules

MAKE_FLAGS+= \
	TARGET_NAME=$(CONFIG_TARGET_NAME) \
	TOOL_PATH=$(firstword $(TOOLCHAIN_BIN_DIRS)) \
	SYS_PATH=$(LINUX_DIR) \
	TOOLPREFIX=$(TARGET_CROSS) \
	KVER=$(LINUX_VERSION) \
	ARCH=$(LINUX_KARCH) \
	TARGET_SUFFIX=$(CONFIG_TARGET_SUFFIX) \
	GCC_VERSION=$(GCC_VERSION) \
	EXTRA_CFLAGS="-Wno-enum-conversion -fno-stack-protector -I$(STAGING_DIR)/usr/include" \
	SoC=$(CONFIG_TARGET_SUBTARGET) \
	SHELL="$(BASH)" \
	PTP_FEATURE=disable \
	ISISC_ENABLE=disable IN_QCA803X_PHY=FALSE \
	$(LNX_CONFIG_OPTS)

ifeq ($(CONFIG_TARGET_ipq806x), y)
    MAKE_FLAGS+= \
		CHIP_TYPE=NONHK_CHIP SWCONFIG_FEATURE=enable \
		IN_MALIBU_PHY=TRUE IN_QCA808X_PHY=TRUE
else ifeq ($(CONFIG_TARGET_SUBTARGET), "ipq807x")
    MAKE_FLAGS+= \
		CHIP_TYPE=HPPE IN_MALIBU_PHY=FALSE \
		SWCONFIG_FEATURE=disable IN_QCA808X_PHY=FALSE
else ifeq ($(CONFIG_TARGET_SUBTARGET), "ipq60xx")
    MAKE_FLAGS+= \
		CHIP_TYPE=CPPE IN_MALIBU_PHY=FALSE \
		SWCONFIG_FEATURE=disable IN_QCA808X_PHY=FALSE
endif


define Build/Compile
	+$(MAKE) $(PKG_JOBS) $(MAKE_FLAGS) -C $(PKG_BUILD_DIR) $(LNX_CONFIG_OPTS)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/qca-ssdk
	$(INSTALL_DIR) $(1)/usr/include/qca-ssdk/api
	$(INSTALL_DIR) $(1)/usr/include/qca-ssdk/ref
	$(INSTALL_DIR) $(1)/usr/include/qca-ssdk/fal
	$(INSTALL_DIR) $(1)/usr/include/qca-ssdk/sal
	$(INSTALL_DIR) $(1)/usr/include/qca-ssdk/init
	$(CP) -rf $(PKG_BUILD_DIR)/include/api/sw_ioctl.h $(1)/usr/include/qca-ssdk/api
	if [ -f $(PKG_BUILD_DIR)/include/ref/ref_vsi.h ]; then \
	$(CP) -rf $(PKG_BUILD_DIR)/include/ref/ref_vsi.h $(1)/usr/include/qca-ssdk/ref/; \
	fi
	if [ -f $(PKG_BUILD_DIR)/include/ref/ref_fdb.h ]; then \
	$(CP) -rf $(PKG_BUILD_DIR)/include/ref/ref_fdb.h $(1)/usr/include/qca-ssdk/ref/; \
	fi
	if [ -f $(PKG_BUILD_DIR)/include/ref/ref_port_ctrl.h ]; then \
	$(CP) -rf $(PKG_BUILD_DIR)/include/ref/ref_port_ctrl.h $(1)/usr/include/qca-ssdk/ref/; \
	fi
	if [ -f $(PKG_BUILD_DIR)/include/init/ssdk_init.h ]; then \
	$(CP) -rf $(PKG_BUILD_DIR)/include/init/ssdk_init.h $(1)/usr/include/qca-ssdk/init/; \
	fi
	if [ -f $(PKG_BUILD_DIR)/include/init/ssdk_netlink.h ]; then \
	$(CP) -rf $(PKG_BUILD_DIR)/include/init/ssdk_netlink.h $(1)/usr/include/qca-ssdk/init/; \
	fi
	$(CP) -rf $(PKG_BUILD_DIR)/include/fal $(1)/usr/include/qca-ssdk
	$(CP) -rf $(PKG_BUILD_DIR)/include/common/*.h $(1)/usr/include/qca-ssdk
	$(CP) -rf $(PKG_BUILD_DIR)/include/sal/os/linux/*.h $(1)/usr/include/qca-ssdk
	$(CP) -rf $(PKG_BUILD_DIR)/include/sal/os/*.h $(1)/usr/include/qca-ssdk

endef

$(eval $(call KernelPackage,qca-ssdk))
