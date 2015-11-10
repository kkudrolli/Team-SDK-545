
################################################################
# This is a generated script based on design: weights_layer_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source weights_layer_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7vx485tffg1761-2
#    set_property BOARD_PART xilinx.com:vc707:part0:1.2 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name weights_layer_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set BRAM_PORTA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA ]
  set BRAM_PORTA1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA1 ]
  set BRAM_PORTA2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA2 ]
  set BRAM_PORTA3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA3 ]
  set BRAM_PORTA4 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA4 ]
  set BRAM_PORTA5 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA5 ]
  set BRAM_PORTA6 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA6 ]
  set BRAM_PORTA7 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA7 ]
  set BRAM_PORTA8 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA8 ]
  set BRAM_PORTA9 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA9 ]

  # Create ports

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_0 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_0.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_0

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_1 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_1.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_1

  # Create instance: blk_mem_gen_2, and set properties
  set blk_mem_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_2 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_2.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_2

  # Create instance: blk_mem_gen_3, and set properties
  set blk_mem_gen_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_3 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_3.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_3

  # Create instance: blk_mem_gen_4, and set properties
  set blk_mem_gen_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_4 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_4.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_4

  # Create instance: blk_mem_gen_5, and set properties
  set blk_mem_gen_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_5 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_5.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_5

  # Create instance: blk_mem_gen_6, and set properties
  set blk_mem_gen_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_6 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_6.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_6

  # Create instance: blk_mem_gen_7, and set properties
  set blk_mem_gen_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_7 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_7.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_7

  # Create instance: blk_mem_gen_8, and set properties
  set blk_mem_gen_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_8 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_8.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_8

  # Create instance: blk_mem_gen_9, and set properties
  set blk_mem_gen_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_9 ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Coe_File {../../../1_9.coe} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Fill_Remaining_Memory_Locations {true} CONFIG.Load_Init_File {true} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Remaining_Memory_Locations {deadbeef} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {128} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_9

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTA_1 [get_bd_intf_ports BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_2 [get_bd_intf_ports BRAM_PORTA1] [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_3 [get_bd_intf_ports BRAM_PORTA2] [get_bd_intf_pins blk_mem_gen_2/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_4 [get_bd_intf_ports BRAM_PORTA3] [get_bd_intf_pins blk_mem_gen_3/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_5 [get_bd_intf_ports BRAM_PORTA4] [get_bd_intf_pins blk_mem_gen_4/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_6 [get_bd_intf_ports BRAM_PORTA5] [get_bd_intf_pins blk_mem_gen_5/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_7 [get_bd_intf_ports BRAM_PORTA6] [get_bd_intf_pins blk_mem_gen_6/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_8 [get_bd_intf_ports BRAM_PORTA7] [get_bd_intf_pins blk_mem_gen_7/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_9 [get_bd_intf_ports BRAM_PORTA8] [get_bd_intf_pins blk_mem_gen_8/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_10 [get_bd_intf_ports BRAM_PORTA9] [get_bd_intf_pins blk_mem_gen_9/BRAM_PORTA]

  # Create port connections

  # Create address segments
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


