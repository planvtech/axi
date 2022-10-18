// Copyright (c) 2014-2018 ETH Zurich, University of Bologna
// Copyright (c) 2022 PlanV GmbH
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable lAC
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
`define __SNOOP_TO_AC(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)       \
  __opt_as __lhs``__lhs_sep``addr      = __rhs``__rhs_sep``addr;          \
  __opt_as __lhs``__lhs_sep``acsnoop   = __rhs``__rhs_sep``acsnoop;       \
  __opt_as __lhs``__lhs_sep``acprot    = __rhs``__rhs_sep``acprot;          
`define __SNOOP_TO_CD(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)       \
  __opt_as __lhs``__lhs_sep``data   = __rhs``__rhs_sep``data;             \
  __opt_as __lhs``__lhs_sep``last   = __rhs``__rhs_sep``last;           
`define __SNOOP_TO_CR(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)       \
  __opt_as __lhs``__lhs_sep``resp   = __rhs``__rhs_sep``resp;     
`define __SNOOP_TO_REQ(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)      \
  `__SNOOP_TO_AC(__opt_as, __lhs.ac, __lhs_sep, __rhs.ac, __rhs_sep)      \
  __opt_as __lhs.ac_valid = __rhs.ac_valid;                               \
  __opt_as __lhs.cd_ready = __rhs.cd_ready;                               \
  __opt_as __lhs.cr_ready = __rhs.cr_ready;
`define __SNOOP_TO_RESP(__opt_as, __lhs, __lhs_sep, __rhs, __rhs_sep)     \
  __opt_as __lhs.ac_ready = __rhs.ac_ready;                               \
  __opt_as __lhs.cd_valid = __rhs.cd_valid;                               \
  `__SNOOP_TO_CD(__opt_as, __lhs.cd, __lhs_sep, __rhs.cd, __rhs_sep)      \
  __opt_as __lhs.cr_valid = __rhs.cr_valid;                               \
  `__SNOOP_TO_CR(__opt_as, __lhs.cr, __lhs_sep, __rhs.cr, __rhs_sep)
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Assigning one SNOOP+ATOP interface to another, as if you would do `assign slv = mst;`
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
// `SNOOP_ASSIGN_Cd(dst, src)
`define SNOOP_ASSIGN_AC(dst, src)               \
  `__SNOOP_TO_AC(assign, dst.ac, _, src.ac, _)  \
  assign dst.ac_valid = src.ac_valid;         \
  assign src.ac_ready = dst.ac_ready;
`define SNOOP_ASSIGN_CD(dst, src)                \
  `__SNOOP_TO_CD(assign, dst.cd, _, src.cd, _)     \
  assign dst.cd_valid  = src.cd_valid;          \
  assign src.cd_ready  = dst.cd_ready;
`define SNOOP_ASSIGN_CR(dst, src)                \
  `__SNOOP_TO_CR(assign, dst.cr, _, src.cr, _)     \
  assign dst.cr_valid  = src.cr_valid;          \
  assign src.cr_ready  = dst.cr_ready;  
`define SNOOP_ASSIGN(slv, mst)  \
  `SNOOP_ASSIGN_AC(slv, mst)    \
  `SNOOP_ASSIGN_CD(slv, mst)    \
  `SNOOP_ASSIGN_CR(slv, mst)    
////////////////////////////////////////////////////////////////////////////////////////////////////
// The channel assignment `SNOOP_ASSIGN_MONITOR(mon_dv, snoop_if)` assigns all signals from `snoop_if`
// to the `mon_dv` interface.
//
// Usage Example:
// `SNOOP_ASSIGN_MONITOR(mon_dv, snoop_if)
`define SNOOP_ASSIGN_MONITOR(mon_dv, snoop_if)          \
  `__SNOOP_TO_AC(assign, mon_dv.ac, _, snoop_if.aw, _)  \
  assign mon_dv.ac_valid  = snoop_if.ac_valid;        \
  assign mon_dv.ac_ready  = snoop_if.ac_ready;        \
  `__SNOOP_TO_CD(assign, mon_dv.cd, _, snoop_if.cd, _)     \
  assign mon_dv.cd_valid   = snoop_if.cd_valid;         \
  assign mon_dv.cd_ready   = snoop_if.cd_ready;         \
  `__SNOOP_TO_CR(assign, mon_dv.cr, _, snoop_if.cr, _)     \
  assign mon_dv.cr_valid   = snoop_if.cr_valid;         

////////////////////////////////////////////////////////////////////////////////////////////////////
// Setting an interface from channel or request/response structs inside a process.
//
// The channel macros `SNOOP_SET_FROM_XX(snoop_if, xx_struct)` set the payload signals of the `snoop_if`
// interface from the signals in `xx_struct`.  They do not set the handshake signals.
// The request macro `SNOOP_SET_FROM_REQ(snoop_if, req_struct)` sets all request channels (AC)
// and the request-side handshake signals (AC valid, CD and CR ready) of the `snoop_if`
// interface from the signals in `req_struct`.
// The response macro `SNOOP_SET_FROM_RESP(snoop_if, resp_struct)` sets both response channels (CD and CR)
// and the response-side handshake signals (CD and CR valid, AC ready) of the `snoop_if`
// interface from the signals in `resp_struct`.
//
// Usage Example:
// always_comb begin
//   `SNOOP_SET_FROM_REQ(my_if, my_req_struct)
// end
`define SNOOP_SET_FROM_AW(snoop_if, ac_struct)      `__SNOOP_TO_AC(, snoop_if.ac, _, ac_struct, .)
`define SNOOP_SET_FROM_AR(snoop_if, cd_struct)      `__SNOOP_TO_CD(, snoop_if.cd, _, cd_struct, .)
`define SNOOP_SET_FROM_R(snoop_if, cr_struct)        `__SNOOP_TO_CR(, snoop_if.cr, _, cr_struct, .)
`define SNOOP_SET_FROM_REQ(snoop_if, req_struct)    `__SNOOP_TO_REQ(, snoop_if, _, req_struct, .)
`define SNOOP_SET_FROM_RESP(snoop_if, resp_struct)  `__SNOOP_TO_RESP(, snoop_if, _, resp_struct, .)
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Assigning an interface from channel or request/response structs outside a process.
//
// The channel macros `SNOOP_ASSIGN_FROM_XX(snoop_if, xx_struct)` assign the payload signals of the
// `snoop_if` interface from the signals in `xx_struct`.  They do not assign the handshake signals.
// The request macro `SNOOP_ASSIGN_FROM_REQ(snoop_if, req_struct)` assigns all request channels (AC) 
// and the request-side handshake signals (AC valid and CD and CR ready) of the `snoop_if` interface 
// from the signals in `req_struct`.The response macro `SNOOP_ASSIGN_FROM_RESP(snoop_if, resp_struct)`
// assigns both response channels (CD and CR) and the response-side handshake signals (CD and CR valid 
// and AC ready) of the `snoop_if` interface from the signals in `resp_struct`.
//
// Usage Example:
// `SNOOP_ASSIGN_FROM_REQ(my_if, my_req_struct)
`define SNOOP_ASSIGN_FROM_AW(snoop_if, ac_struct)     `__SNOOP_TO_AC(assign, snoop_if.ac, _, ac_struct, .)
`define SNOOP_ASSIGN_FROM_AR(snoop_if, cd_struct)     `__SNOOP_TO_CD(assign, snoop_if.cd, _, cd_struct, .)
`define SNOOP_ASSIGN_FROM_R(snoop_if, cr_struct)       `__SNOOP_TO_CR(assign, snoop_if.cr, _, cr_struct, .)
`define SNOOP_ASSIGN_FROM_REQ(snoop_if, req_struct)   `__SNOOP_TO_REQ(assign, snoop_if, _, req_struct, .)
`define SNOOP_ASSIGN_FROM_RESP(snoop_if, resp_struct) `__SNOOP_TO_RESP(assign, snoop_if, _, resp_struct, .)
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Setting channel or request/response structs from an interface inside a process.
//
// The channel macros `SNOOP_SET_TO_XX(xx_struct, snoop_if)` set the signals of `xx_struct` to the
// payload signals of that channel in the `snoop_if` interface.  They do not set the handshake
// signals.
// The request macro `SNOOP_SET_TO_REQ(snoop_if, req_struct)` sets all signals of `req_struct` (i.e.,
// request channel (AC) payload and request-side handshake signals (AC valid and
// CD and CR ready)) to the signals in the `snoop_if` interface.
// The response macro `SNOOP_SET_TO_RESP(snoop_if, resp_struct)` sets all signals of `resp_struct`
// (i.e., response channel (CD and CR) payload and response-side handshake signals (CD and CR valid and
// AC ready)) to the signals in the `snoop_if` interface.
//
// Usage Example:
// always_comb begin
//   `SNOOP_SET_TO_REQ(my_req_struct, my_if)
// end
`define SNOOP_SET_TO_AW(ac_struct, snoop_if)     `__SNOOP_TO_AC(, ac_struct, ., snoop_if.ac, _)
`define SNOOP_SET_TO_AR(cd_struct, snoop_if)     `__SNOOP_TO_CD(, cd_struct, ., snoop_if.cd, _)
`define SNOOP_SET_TO_R(cr_struct, snoop_if)       `__SNOOP_TO_CR(, cr_struct, ., snoop_if.cr, _)
`define SNOOP_SET_TO_REQ(req_struct, snoop_if)   `__SNOOP_TO_REQ(, req_struct, ., snoop_if, _)
`define SNOOP_SET_TO_RESP(resp_struct, snoop_if) `__SNOOP_TO_RESP(, resp_struct, ., snoop_if, _)
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Assigning channel or request/response structs from an interface outside a process.
//
// The channel macros `SNOOP_ASSIGN_TO_XX(xx_struct, snoop_if)` assign the signals of `xx_struct` to the
// payload signals of that channel in the `snoop_if` interface.  They do not assign the handshake
// signals.
// The request macro `SNOOP_ASSIGN_TO_REQ(snoop_if, req_struct)` assigns all signals of `req_struct`
// (i.e., request channel (AC) payload and request-side handshake signals (AC valid and CD and CR ready)) 
// to the signals in the `snoop_if` interface.
// The response macro `SNOOP_ASSIGN_TO_RESP(snoop_if, resp_struct)` assigns all signals of `resp_struct`
// (i.e., response channel (CD and CR) payload and response-side handshake signals (CD and CR valid and
// AC ready)) to the signals in the `snoop_if` interface.
//
// Usage Example:
// `SNOOP_ASSIGN_TO_REQ(my_req_struct, my_if)
`define SNOOP_ASSIGN_TO_AW(aw_struct, snoop_if)     `__SNOOP_TO_AW(assign, aw_struct, ., snoop_if.aw, _)
`define SNOOP_ASSIGN_TO_AR(ar_struct, snoop_if)     `__SNOOP_TO_AR(assign, ar_struct, ., snoop_if.ar, _)
`define SNOOP_ASSIGN_TO_R(r_struct, snoop_if)       `__SNOOP_TO_R(assign, r_struct, ., snoop_if.r, _)
`define SNOOP_ASSIGN_TO_REQ(req_struct, snoop_if)   `__SNOOP_TO_REQ(assign, req_struct, ., snoop_if, _)
`define SNOOP_ASSIGN_TO_RESP(resp_struct, snoop_if) `__SNOOP_TO_RESP(assign, resp_struct, ., snoop_if, _)
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Setting channel or request/response structs from another struct inside a process.
//
// The channel macros `SNOOP_SET_XX_STRUCT(lhs, rhs)` set the fields of the `lhs` channel struct to
// the fields of the `rhs` channel struct.  They do not set the handshake signals, which are not
// part of channel structs.
// The request macro `SNOOP_SET_REQ_STRUCT(lhs, rhs)` sets all fields of the `lhs` request struct to
// the fields of the `rhs` request struct.  This includes all request channel (AC) payload
// and request-side handshake signals (AC valid and CD and CR ready).
// The response macro `SNOOP_SET_RESP_STRUCT(lhs, rhs)` sets all fields of the `lhs` response struct
// to the fields of the `rhs` response struct.  This includes all response channel (CD and CR) payload
// and response-side handshake signals (CD and CR valid and AC ready).
//
// Usage Example:
// always_comb begin
//   `SNOOP_SET_S_REQ_STRUCT(my_req_struct, another_req_struct)
// end
`define SNOOP_SET_AC_STRUCT(lhs, rhs)     `__SNOOP_TO_AC(, lhs, ., rhs, .)
`define SNOOP_SET_CD_STRUCT(lhs, rhs)     `__SNOOP_TO_CD(, lhs, ., rhs, .)
`define SNOOP_SET_CR_STRUCT(lhs, rhs)       `__SNOOP_TO_CR(, lhs, ., rhs, .)
`define SNOOP_SET_REQ_STRUCT(lhs, rhs)   `__SNOOP_TO_REQ(, lhs, ., rhs, .)
`define SNOOP_SET_RESP_STRUCT(lhs, rhs) `__SNOOP_TO_RESP(, lhs, ., rhs, .)
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Assigning channel or request/response structs from another struct outside a process.
//
// The channel macros `SNOOP_ASSIGN_XX_STRUCT(lhs, rhs)` assign the fields of the `lhs` channel struct
// to the fields of the `rhs` channel struct.  They do not assign the handshake signals, which are
// not part of the channel structs.
// The request macro `SNOOP_ASSIGN_REQ_STRUCT(lhs, rhs)` assigns all fields of the `lhs` request
// struct to the fields of the `rhs` request struct.  This includes all request channel (AW, W, AR)
// payload and request-side handshake signals (AC valid and CD and CR ready).
// The response macro `SNOOP_ASSIGN_RESP_STRUCT(lhs, rhs)` assigns all fields of the `lhs` response
// struct to the fields of the `rhs` response struct.  This includes all response channel (CD and CR)
// payload and response-side handshake signals (CD and CR valid and AC ready).
//
// Usage Example:
// `SNOOP_ASSIGN_REQ_STRUCT(my_req_struct, another_req_struct)
`define SNOOP_ASSIGN_AC_STRUCT(lhs, rhs)     `__SNOOP_TO_AC(assign, lhs, ., rhs, .)
`define SNOOP_ASSIGN_CD_STRUCT(lhs, rhs)     `__SNOOP_TO_CD(assign, lhs, ., rhs, .)
`define SNOOP_ASSIGN_CR_STRUCT(lhs, rhs)       `__SNOOP_TO_CR(assign, lhs, ., rhs, .)
`define SNOOP_ASSIGN_REQ_STRUCT(lhs, rhs)   `__SNOOP_TO_REQ(assign, lhs, ., rhs, .)
`define SNOOP_ASSIGN_RESP_STRUCT(lhs, rhs) `__SNOOP_TO_RESP(assign, lhs, ., rhs, .)
////////////////////////////////////////////////////////////////////////////////////////////////////



`endif