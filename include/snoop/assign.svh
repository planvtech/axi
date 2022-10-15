// Copyright (c) 2014-2018 ETH Zurich, University of Bologna
// Copyright (c) 2022 PlanV GmbH
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//

// Macros to assign SNOOP Interfaces and Structs

`ifndef SNOOP_ASSIGN_SVH_
`define SNOOP_ASSIGN_SVH_

////////////////////////////////////////////////////////////////////////////////////////////////////
// Internal implementation for assigning one SNOOP struct or interface to another struct or interface.
// The path to the signals on each side is defined by the `__sep*` arguments.  The `__opt_as`
// argument allows to use this standalone (with `__opt_as = assign`) or in assignments inside
// processes (with `__opt_as` void).
`define __SNOOP_TO_AC(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)         \
  __opt_as __lhs``__lhs_sep``addr       =   __rhs``__rhs_sep``addr;         \
  __opt_as __lhs``__lhs_sep``acsnoop    =   __rhs``__rhs_sep``acsnoop;      \
  __opt_as __lhs``__lhs_sep``acprot     =   __rhs``__rhs_sep``acprot;   
`define __SNOOP_TO_CR(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)         \
  __opt_as __lhs``__lhs_sep``resp       =   __rhs``__rhs_sep``resp;         \
`define __SNOOP_TO_CD(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)         \
  __opt_as __lhs``__lhs_sep``data       =   __rhs``__rhs_sep``data;         \
  __opt_as __lhs``__lhs_sep``last       =   __rhs``__rhs_sep``last;       
`define __SNOOP_TO_REQ(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)        \
  __opt_as __lhs.cr_ready               =   __rhs.cr_ready;                 \
  __opt_as __lhs.cd_ready               =   __rhs.cd_ready;                 \
  `__SNOOP_TO_AC(__opt_as, __lhs.ac, __lhs_sep, __rhs.ac, __rhs_sep)        \
  __opt_as __lhs.ac_valid               =   __rhs.ac_valid;                 \
`define __SNOOP_TO_RESP(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)       \
  __opt_as __lhs.ac_ready               =   __rhs.ac_ready;                 \
  `__SNOOP_TO_CR(__opt_as, __lhs.cr, __lhs_sep, __rhs.cr, __rhs_sep)        \
  __opt_as __lhs.cr_valid               =   __rhs.cr_valid;                 \
  `__SNOOP_TO_CD(__opt_as, __lhs.cd, __lhs_sep, __rhs.cd, __rhs_sep)        \
  __opt_as __lhs.cd_valid               =   __rhs.cr_valid;                  
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Assigning one AXI4+ATOP interface to another, as if you would do `assign slv = mst;`
//
// The channel assignments `SNOOP_ASSIGN_XX(dst, src)` assign all payload and the valid signal of the
// `XX` channel from the `src` to the `dst` interface and they assign the ready signal from the
// `src` to the `dst` interface.
// The interface assignment `SNOOP_ASSIGN(dst, src)` assigns all channels including handshakes as if
// `src` was the master of `dst`.
//
// Usage Example:
// `SNOOP_ASSIGN(slv, mst)
// `SNOOP_ASSIGN_AC(dst, src)
// `SNOOP_ASSIGN_R(dst, src)
`define SNOOP_ASSIGN_AC(dst, src)               \
  `__SNOOP_TO_AC(assign, dst.ac, _, src.ac, _)  \
  assign dst.ac_valid = src.ac_valid;           \
  assign src.ac_ready = dst.ac_ready;

`define SNOOP_ASSIGN_CR(dst, src)               \
  `__SNOOP_TO_CR(assign, dst.cr, _, src.cr, _)  \
  assign dst.cr_valid = src.cr_valid;           \
  assign src.cr_ready = dst.cr_ready;
`define SNOOP_ASSIGN_CD(dst, src)               \
  `__SNOOP_TO_CD(assign, dst.cd, _, src.cd, _)  \
  assign dst.cd_valid  = src.cd_valid;          \
  assign src.cd_ready  = dst.cd_ready;
`define SNOOP_ASSIGN(slv, mst)  \                                       
  `SNOOP_ASSIGN_AC(mst, slv)    \
  `SNOOP_ASSIGN_CR(mst, slv)    \
  `SNOOP_ASSIGN_CD(mst, slv);

`endif
