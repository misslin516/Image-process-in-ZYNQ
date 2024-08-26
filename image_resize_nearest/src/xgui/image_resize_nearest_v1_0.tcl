# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "Delay_para" -parent ${Page_0}


}

proc update_PARAM_VALUE.Delay_para { PARAM_VALUE.Delay_para } {
	# Procedure called to update Delay_para when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Delay_para { PARAM_VALUE.Delay_para } {
	# Procedure called to validate Delay_para
	return true
}


proc update_MODELPARAM_VALUE.Delay_para { MODELPARAM_VALUE.Delay_para PARAM_VALUE.Delay_para } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Delay_para}] ${MODELPARAM_VALUE.Delay_para}
}

