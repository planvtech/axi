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


//! ACE Package
/// Contains all necessary type definitions, constants, and generally useful functions.
package ace_pkg;

   /// Support for snoop channels
   typedef logic [3:0] arsnoop_t;
   typedef logic [2:0] awsnoop_t;
   typedef logic [1:0] bar_t;
   typedef logic [1:0] domain_t;
   typedef logic [0:0] awunique_t;
   typedef logic [3:0] rresp_t;
   typedef logic       snoop_trs_t;

endpackage
