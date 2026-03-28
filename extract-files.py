#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.file import File

from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
    lib_fixup_remove,
    lib_fixup_remove_arch_suffix,
    lib_fixup_vendorcompat,    
    libs_clang_rt_ubsan,
    libs_proto_3_9_1,

)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)


namespace_imports = [
   'hardware/qcom-caf/wlan',
   'hardware/xiaomi',
   'vendor/qcom/opensource/dataservices',
 ]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

blob_fixups: blob_fixups_user_type = {
	'vendor/etc/init/android.hardware.gnss-aidl-service-qti.rc': blob_fixup()
       .regex_replace(' vendor_ssgtzd', ''),
               
    ('vendor/bin/hw/android.hardware.security.keymint-service-qti', 'vendor/lib64/libqtikeymint.so'): blob_fixup()
        .add_needed('android.hardware.security.rkp-V3-ndk.so'),
   
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup()
        .add_needed('libhidlbase_shim.so'),
        
    'vendor/lib64/libqcodec2_core.so' : blob_fixup()
        .add_needed('libcodec2_shim.so'),
        
        (
        'vendor/lib64/libqc2audio_hwaudiocodec.so',
        'vendor/lib64/hw/displayfeature.default.so',
    ): blob_fixup()
        .replace_needed(
            'libstagefright_foundation.so',
            'libstagefright_foundation-v33.so',
            ),
}

module = ExtractUtilsModule(
    'creek_gsi',
    'xiaomi',
     blob_fixups=blob_fixups,
     lib_fixups=lib_fixups,
     namespace_imports=namespace_imports,
  #    check_elf=False,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
