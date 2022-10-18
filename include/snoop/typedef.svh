// Copyright (c) 2019 ETH Zurich, University of Bologna
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

// Macros to define SNOOP Channel and Request/Response Structs

`ifndef SNOOP_TYPEDEF_SVH_
`define SNOOP_TYPEDEF_SVH_

// Usage Example:
// `SNOOP_TYPEDEF_AC_CHAN_T(snoop_ac_t, snoop_addr_t)
// 'SNOOP_TYPEDEF_CD_CHAN_T(snoop_cd_t, snoop_data_t)              
// `SNOOP_TYPEDEF_REQ_T(snoop_req_t, snoop_ac_t)
// `SNOOP_TYPEDEF_RESP_T(snoop_resp_t, snoop_cd_t, snoop_cr_t)
`define SNOOP_TYPEDEF_AC_CHAN_T(ac_chan_t, addr_t)              \
  typedef struct packed {                                       \
    addr_t                addr;                                 \
    snoop_pkg::acsnoop_t  acsnoop;                              \
    snoop_pkg::acprot_t   acprot;                               \
  } ac_chan_t;
`define SNOOP_TYPEDEF_CD_CHAN_T(cd_chan_t, data_t)              \
  typedef struct packed {                                       \
    data_t                data;                                 \
    logic                 last;                                 \
  } cd_chan_t;
`define SNOOP_TYPEDEF_CR_CHAN_T(cr_chan_t)                      \
  typedef struct packed {                                       \
    snoop_pkg::resp_t     resp;                                 \
  } cr_chan_t;
`define SNOOP_TYPEDEF_REQ_T(req_t, ac_chan_t)      \
  typedef struct packed {                                       \
    logic     ac_valid;                                         \
    logic     cd_ready;                                         \
    ac_chan_t ac;                                               \
    logic     cr_ready;                                         \
  } req_t;
`define SNOOP_TYPEDEF_RESP_T(resp_t, cd_chan_t, cr_chan_t)      \
  typedef struct packed {                                       \
    logic     ac_ready;                                         \
    logic     cd_valid;                                         \
    cd_chan_t cd;                                               \
    logic     cr_valid;                                         \
    cr_chan_t cr;                                               \
  } resp_t;
////////////////////////////////////////////////////////////////////////////////////////////////////

// Usage Example:
// `SNOOP_TYPEDEF_ALL(snoop, addr_t, data_t)
//
// This defines `snoop_req_t` and `snoop_resp_t` request/response structs as well as `snoop_ac_chan_t`,
// `snoop_cd_chan_t` and `snoop_cr_chan_t` channel structs.
`define SNOOP_TYPEDEF_ALL(__name, __addr_t __data_t)                  \
  `SNOOP_TYPEDEF_AC_CHAN_T(__name``_aw_chan_t, __addr_t)              \
  `SNOOP_TYPEDEF_CR_CHAN_T(__name``_cr_chan_t)                        \
  `SNOOP_TYPEDEF_REQ_T(__name``_req_t, __name``_ac_chan_t)            \
  `SNOOP_TYPEDEF_RESP_T(__name``_resp_t, __name``_cd_chan_t, __name``_cr_chan_t)
////////////////////////////////////////////////////////////////////////////////////////////////////

`endif
