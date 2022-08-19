baseboard_inaugural_stack_bashrc() {
  local cfg cfgd

  cfgd="/mnt/host/source/src/overlays/baseboard-inaugural/${CATEGORY}/${PN}"
  for cfg in ${PN} ${P} ${PF} ; do
    cfg="${cfgd}/${cfg}.bashrc"
    [[ -f ${cfg} ]] && . "${cfg}"
  done

  export BASEBOARD_INAUGURAL_BASHRC_FILESDIR="${cfgd}/files"
}

baseboard_inaugural_stack_bashrc
