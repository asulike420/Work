//----------------------------------------------------------------------
//   Copyright 2012 Mentor Graphics Corporation
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
//----------------------------------------------------------------------

package uart_vseq_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_agent_pkg::*;
import uart_agent_pkg::*;
import modem_agent_pkg::*;
import uart_reg_pkg::*;
import uart_env_pkg::*;

import host_if_seq_pkg::*;
import uart_seq_pkg::*;

`include "uart_vseq_base.svh"
`include "basic_reg_vseq.svh"
`include "word_format_poll_vseq.svh"
`include "modem_poll_test_vseq.svh"
`include "word_format_int_vseq.svh"
`include "modem_int_test_vseq.svh"
`include "rx_errors_int_vseq.svh"

endpackage: uart_vseq_pkg