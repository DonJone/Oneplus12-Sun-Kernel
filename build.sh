mkdir kernel_workspace && cd kernel_workspace
repo init -u https://github.com/RealJohnGalt/opsm8650_kernel_manifest.git -b kplatform -m default.xml --depth=1
repo sync
git clone https://github.com/TheWildJames/kernel_patches.git
git clone https://gitlab.com/simonpunk/susfs4ksu -b gki-android14-6.1 --depth=1 susfs
#git clone https://github.com/TheWildJames/kernel_patches.git
#git clone https://gitlab.com/simonpunk/susfs4ksu -b gki-android15-6.6 --depth=1 susfs
rm -rf /home/don/kernel_workspace/kernel_platform/common/android/abi_gki_protected_exports_*
cd ~/kernel_workspace/kernel_platform/
KERNEL_REPO=$(pwd)
cd common
curl -LSs "https://raw.githubusercontent.com/ShirkNeko/SukiSU-Ultra/main/kernel/setup.sh" | bash -s susfs-dev
rm ~/kernel_workspace/kernel_platform/msm-kernel/android/abi_gki_protected_exports_*
sed -i 's/ -dirty//g' ~/kernel_workspace/kernel_platform/common/scripts/setlocalversion
sed -i 's/ -dirty//g' ~/kernel_workspace/kernel_platform/msm-kernel/scripts/setlocalversion
cd ~/kernel_workspace/susfs
cp ./kernel_patches/50_add_susfs_in_gki-android14-6.1.patch $KERNEL_REPO/common/
#cp ./kernel_patches/50_add_susfs_in_gki-android15-6.6.patch $KERNEL_REPO/common/
cp ./kernel_patches/fs/* $KERNEL_REPO/common/fs/
cp ./kernel_patches/include/linux/* $KERNEL_REPO/common/include/linux/
cd $KERNEL_REPO/common
patch -p1 < 50_add_susfs_in_gki-android14-6.1.patch
#patch -p1 < 50_add_susfs_in_gki-android15-6.6.patch
cp ../../SukiSU_patch/69_hide_stuff.patch ./
patch -p1 -F 3 < 69_hide_stuff.patch
cp ../../SukiSU_patch/hooks/new_hooks.patch ./
patch -p1 -F 3 < new_hooks.patch

#zram
cp -r ../SukiSU_patch/other/lz4k/include/linux/* ./common/include/linux
cp -r ../SukiSU_patch/other/lz4k/lib/* ./common/lib
cp -r ../SukiSU_patch/other/lz4k/crypto/* ./common/crypto
cp ../../SukiSU_patch/other/lz4k_patch/6.1/lz4kd.patch ./
patch -p1 -F 3 < lz4kd.patch || true


cd ../
echo "CONFIG_KSU=y" >> ./common/arch/arm64/configs/gki_defconfig
echo "CONFIG_KPM=y" >> ./common/arch/arecho "CONFIG_KSU_SUSFS_SUS_SU=n" >> ./common/arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SUS_SU=n" >> ./common/arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_MANUAL_HOOK=y" >> ./common/arch/arm64/configs/gki_defconfig

          echo "CONFIG_KSU_SUSFS=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_PATH=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_MOUNT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_KSTAT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_TRY_UMOUNT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SPOOF_UNAME=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_ENABLE_LOG=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y" >> ./common/arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_OPEN_REDIRECT=y" >> ./common/arch/arm64/configs/gki_defconfig
sed -i 's/check_defconfig//' ./common/build.config.gki
sed -i '$s|echo "\$res"|echo "\A15-Sun-Kim.Jongun"|' ./common/scripts/setlocalversion
sed -i "/stable_scmversion_cmd/s/-maybe-dirty//g" ./build/kernel/kleaf/impl/stamp.bzl
cd ../
./kernel_platform/oplus/build/oplus_build_kernel.sh pineapple gki
#./kernel_platform/oplus/build/oplus_build_kernel.sh sun gki

