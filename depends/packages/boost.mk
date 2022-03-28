package=boost
$(package)_version=1.77.0
$(package)_download_path=https://boostorg.jfrog.io/artifactory/main/release/$($(package)_version)/source/
$(package)_file_name=boost_$(subst .,_,$($(package)_version)).tar.bz2
$(package)_sha256_hash=fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854

define $(package)_set_vars
$(package)_config_opts_release=variant=release
$(package)_config_opts_debug=variant=debug
$(package)_config_opts=--layout=tagged --build-type=complete --user-config=user-config.jam
$(package)_config_opts+=threading=multi link=static -sNO_COMPRESSION=1
$(package)_config_opts_linux=target-os=linux threadapi=pthread runtime-link=static
$(package)_config_opts_darwin=target-os=darwin runtime-link=static
$(package)_config_opts_mingw32=target-os=windows binary-format=pe threadapi=win32 runtime-link=static
$(package)_config_opts_x86_64=architecture=x86 address-model=64
$(package)_config_opts_i686=architecture=x86 address-model=32
$(package)_config_opts_aarch64=address-model=64
$(package)_config_opts_armv7a=address-model=32
$(package)_config_opts_i686_android=address-model=32
$(package)_config_opts_aarch64_android=address-model=64
$(package)_config_opts_x86_64_android=address-model=64
$(package)_config_opts_armv7a_android=address-model=32
ifneq (,$(findstring clang,$($(package)_cxx)))
$(package)_toolset_$(host_os)=clang
else
$(package)_toolset_$(host_os)=gcc
endif
$(package)_config_libraries=filesystem,system,thread,test
$(package)_cxxflags=-std=c++17 -fvisibility=hidden
$(package)_cxxflags_linux=-fPIC
$(package)_cxxflags_android=-fPIC
endef

# Fix unused variable in boost_process, can be removed after upgrading to 1.72
define $(package)_preprocess_cmds
  sed -i.old "s/int ret_sig = 0;//" boost/process/detail/posix/wait_group.hpp && \
  echo "using $($(package)_toolset_$(host_os)) : : $($(package)_cxx) : <cflags>\"$($(package)_cflags)\" <cxxflags>\"$($(package)_cxxflags)\" <compileflags>\"$($(package)_cppflags)\" <linkflags>\"$($(package)_ldflags)\" <archiver>\"$($(package)_ar)\" <striper>\"$(host_STRIP)\"  <ranlib>\"$(host_RANLIB)\" <rc>\"$(host_WINDRES)\" : ;" > user-config.jam
endef

define $(package)_config_cmds
  ./bootstrap.sh --without-icu --with-libraries=$($(package)_config_libraries) --with-toolset=$($(package)_toolset_$(host_os))
endef

define $(package)_build_cmds
  ./b2 -d2 -j2 -d1 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) toolset=$($(package)_toolset_$(host_os)) stage
endef

define $(package)_stage_cmds
  ./b2 -d0 -j4 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) toolset=$($(package)_toolset_$(host_os)) install
endef
