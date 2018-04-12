//------------------------------------------------------------
//   Copyright 2010 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------
//
// Class Description:
//
//
class spi_reg_test extends spi_test_base;

// UVM Factory Registration Macro
//
`uvm_component_utils(spi_reg_test)

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "spi_reg_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass: spi_reg_test

function spi_reg_test::new(string name = "spi_reg_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void spi_reg_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase

task spi_reg_test::run_phase(uvm_phase phase);
  register_test_vseq t_seq =  register_test_vseq::type_id::create("t_seq");
  phase.raise_objection(this, "spi_reg_test");

  t_seq.start(m_env.m_v_sqr);
  #100ns;
  phase.drop_objection(this, "spi_reg_test");
endtask: run_phase