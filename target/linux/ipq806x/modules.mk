define KernelPackage/phy-qcom-ipq806x-usb
  TITLE:=Qualcomm IPQ806x DWC3 USB PHY driver
  DEPENDS:=@TARGET_ipq806x
  KCONFIG:= CONFIG_PHY_QCOM_IPQ806X_USB
  FILES:= \
    $(LINUX_DIR)/drivers/phy/qualcomm/phy-qcom-ipq806x-usb.ko
  AUTOLOAD:=$(call AutoLoad,45,phy-qcom-ipq806x-usb,1)
  $(call AddDepends/usb)
endef

define KernelPackage/phy-qcom-ipq806x-usb/description
 This driver provides support for the integrated DesignWare
 USB3 IP Core within the QCOM SoCs.
endef

$(eval $(call KernelPackage,phy-qcom-ipq806x-usb))


define KernelPackage/sound-soc-ipq8064-storm
  TITLE:=Qualcomm IPQ8064 SoC support for Google Storm
  DEPENDS:=@TARGET_ipq806x +kmod-sound-soc-core
  KCONFIG:=\
	CONFIG_IPQ_LCC_806X \
	CONFIG_SND_SOC_QCOM \
	CONFIG_SND_SOC_STORM \
	CONFIG_SND_SOC_APQ8016_SBC=n \
	CONFIG_SND_SOC_SC7180=n
  FILES:=\
	$(LINUX_DIR)/drivers/clk/qcom/lcc-ipq806x.ko \
	$(LINUX_DIR)/sound/soc/codecs/snd-soc-max98357a.ko \
	$(LINUX_DIR)/sound/soc/qcom/snd-soc-lpass-cpu.ko \
	$(LINUX_DIR)/sound/soc/qcom/snd-soc-lpass-ipq806x.ko \
	$(LINUX_DIR)/sound/soc/qcom/snd-soc-lpass-platform.ko \
	$(LINUX_DIR)/sound/soc/qcom/snd-soc-storm.ko
  AUTOLOAD:=$(call AutoProbe,lcc-ipq806x \
	snd-soc-max98357a snd-soc-lpass-ipq806x snd-soc-storm)
  $(call AddDepends/sound)
endef

define KernelPackage/sound-soc-ipq8064-storm/description
 Provides sound support for the Google Storm platform, with a Qualcomm IPQ8064
 SoC.
endef

$(eval $(call KernelPackage,sound-soc-ipq8064-storm))


define KernelPackage/stmmac
  SUBMENU:=Network Devices
  TITLE:=STMicroelectronics Multi-Gigabit Ethernet driver
  DEPENDS:=+kmod-phylink
  KCONFIG:= \
	CONFIG_PHYLINK=y \
	CONFIG_STMMAC_ETH \
	CONFIG_STMMAC_PLATFORM \
	CONFIG_STMMAC_SELFTESTS=n
  FILES:= \
	$(LINUX_DIR)/drivers/net/ethernet/stmicro/stmmac/stmmac.ko \
	$(LINUX_DIR)/drivers/net/ethernet/stmicro/stmmac/stmmac-platform.ko
  AUTOLOAD:=$(call AutoLoad,10,stmmac)
endef

define KernelPackage/stmmac/description
  Driver for the Ethernet IPs built around a Synopsys IP Core.
endef

$(eval $(call KernelPackage,stmmac))


define KernelPackage/dwmac-ipq806x
  SUBMENU:=Network Devices
  TITLE:=IPQ806x dwmac support
  DEPENDS:=+kmod-stmmac
  KCONFIG:=CONFIG_DWMAC_IPQ806X
  FILES:=$(LINUX_DIR)/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.ko
  AUTOLOAD:=$(call AutoLoad,15,dwmac-ipq806x)
endef

define KernelPackage/dwmac-ipq806x/description
  Support for Ethernet controller on IPQ806x SoC.
endef

$(eval $(call KernelPackage,dwmac-ipq806x))
