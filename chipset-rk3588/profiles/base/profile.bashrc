filter_unsupported_gcc_flags() {
        local var flag flags=()
        for var in CFLAGS CXXFLAGS LDFLAGS; do
                for flag in ${!var}; do
                        if [[ ${flag} != "-Xcompiler" && \
                              ${flag} != "-Wl,--icf=all" && \
															${flag} != "-mfpu=crypto-neon-fp-armv8" && \
															${flag} != "-mfloat-abi=hard" && \
                              ${flag} != "--unwindlib=libunwind" ]]; then
                                flags+=("${flag}")
                        fi
                done
                export ${var}="${flags[*]}"
                flags=()
        done
}
