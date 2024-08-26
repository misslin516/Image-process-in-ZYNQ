# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.Delay_cnt { PARAM_VALUE.Delay_cnt } {
	# Procedure called to update Delay_cnt when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Delay_cnt { PARAM_VALUE.Delay_cnt } {
	# Procedure called to validate Delay_cnt
	return true
}


proc update_MODELPARAM_VALUE.Delay_cnt { MODELPARAM_VALUE.Delay_cnt PARAM_VALUE.Delay_cnt } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Delay_cnt}] ${MODELPARAM_VALUE.Delay_cnt}
}

