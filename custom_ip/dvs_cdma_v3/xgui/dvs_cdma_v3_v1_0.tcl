# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MAX_LIFE_COUNT" -parent ${Page_0}


}

proc update_PARAM_VALUE.LIFE_ONE { PARAM_VALUE.LIFE_ONE } {
	# Procedure called to update LIFE_ONE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIFE_ONE { PARAM_VALUE.LIFE_ONE } {
	# Procedure called to validate LIFE_ONE
	return true
}

proc update_PARAM_VALUE.LIFE_ZERO { PARAM_VALUE.LIFE_ZERO } {
	# Procedure called to update LIFE_ZERO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIFE_ZERO { PARAM_VALUE.LIFE_ZERO } {
	# Procedure called to validate LIFE_ZERO
	return true
}

proc update_PARAM_VALUE.MAX_LIFE_COUNT { PARAM_VALUE.MAX_LIFE_COUNT } {
	# Procedure called to update MAX_LIFE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_LIFE_COUNT { PARAM_VALUE.MAX_LIFE_COUNT } {
	# Procedure called to validate MAX_LIFE_COUNT
	return true
}


proc update_MODELPARAM_VALUE.MAX_LIFE_COUNT { MODELPARAM_VALUE.MAX_LIFE_COUNT PARAM_VALUE.MAX_LIFE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_LIFE_COUNT}] ${MODELPARAM_VALUE.MAX_LIFE_COUNT}
}

proc update_MODELPARAM_VALUE.LIFE_ZERO { MODELPARAM_VALUE.LIFE_ZERO PARAM_VALUE.LIFE_ZERO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIFE_ZERO}] ${MODELPARAM_VALUE.LIFE_ZERO}
}

proc update_MODELPARAM_VALUE.LIFE_ONE { MODELPARAM_VALUE.LIFE_ONE PARAM_VALUE.LIFE_ONE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIFE_ONE}] ${MODELPARAM_VALUE.LIFE_ONE}
}

