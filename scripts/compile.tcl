# This script was generated automatically by bender.
set ROOT "/home/abdul/culsans/modules/axi"

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/clk_rst_gen.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/rand_id_queue.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/rand_stream_mst.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/rand_synch_holdable_driver.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/rand_verif_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/signal_highlighter.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/sim_timeout.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/stream_watchdog.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/rand_synch_driver.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/src/rand_stream_slv.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/common_verification-c01de0543fd8fd3d/test/tb_clk_rst_gen.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/rtl/tc_sram.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/rtl/tc_clk.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/cluster_pwr_cells.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/generic_memory.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/generic_rom.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/pad_functional.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/pulp_buffer.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/pulp_pwr_cells.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/tc_pwr.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/test/tb_tc_sram.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/pulp_clock_gating_async.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/cluster_clk_cells.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-ae557b51ad05fa34/src/deprecated/pulp_clk_cells.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/binary_to_gray.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cb_filter_pkg.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cc_onehot.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cf_math_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/clk_int_div.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/delta_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/ecc_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/edge_propagator_tx.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/exp_backoff.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/fifo_v3.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/gray_to_binary.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/isochronous_4phase_handshake.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/isochronous_spill_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/lfsr.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/lfsr_16bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/lfsr_8bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/mv_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/onehot_to_bin.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/plru_tree.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/popcount.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/rr_arb_tree.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/rstgen_bypass.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/serial_deglitch.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/shift_reg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/spill_register_flushable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_demux.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_fork.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_intf.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_join.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_mux.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_throttle.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/sub_per_hash.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/sync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/sync_wedge.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/unread.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_reset_ctrlr_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/addr_decode_napot.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_2phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_4phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/addr_decode.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cb_filter.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_fifo_2phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/ecc_decode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/ecc_encode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/edge_detect.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/lzc.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/max_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/rstgen.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/spill_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_delay.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_fifo.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_fork_dynamic.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_reset_ctrlr.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_fifo_gray.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/fall_through_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/id_queue.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_to_mem.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_arbiter_flushable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_fifo_optimal_wrap.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_xbar.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_fifo_gray_clearable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/cdc_2phase_clearable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_arbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/stream_omega_net.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/sram.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/addr_decode_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/cb_filter_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/cdc_2phase_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/cdc_2phase_clearable_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/cdc_fifo_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/cdc_fifo_clearable_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/fifo_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/graycode_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/id_queue_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/popcount_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/rr_arb_tree_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/stream_test.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/stream_register_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/stream_to_mem_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/sub_per_hash_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/isochronous_crossing_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/stream_omega_net_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/stream_xbar_tb.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/test/clk_int_div_tb.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/clock_divider_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/clk_div.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/find_first_one.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/generic_LFSR_8bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/generic_fifo.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/prioarbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/pulp_sync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/pulp_sync_wedge.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/rrarbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/clock_divider.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/fifo_v2.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/deprecated/fifo_v1.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/edge_propagator_ack.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/edge_propagator.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/src/edge_propagator_rx.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    -lint -pedanticerrors \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/src/axi_pkg.sv" \
    "$ROOT/src/ace_pkg.sv" \
    "$ROOT/src/axi_intf.sv" \
    "$ROOT/src/ace_intf.sv" \
    "$ROOT/src/axi_atop_filter.sv" \
    "$ROOT/src/axi_burst_splitter.sv" \
    "$ROOT/src/axi_cdc_dst.sv" \
    "$ROOT/src/axi_cdc_src.sv" \
    "$ROOT/src/axi_cut.sv" \
    "$ROOT/src/axi_delayer.sv" \
    "$ROOT/src/axi_demux.sv" \
    "$ROOT/src/axi_dw_downsizer.sv" \
    "$ROOT/src/axi_dw_upsizer.sv" \
    "$ROOT/src/axi_fifo.sv" \
    "$ROOT/src/axi_id_remap.sv" \
    "$ROOT/src/axi_id_prepend.sv" \
    "$ROOT/src/axi_isolate.sv" \
    "$ROOT/src/axi_join.sv" \
    "$ROOT/src/axi_lite_demux.sv" \
    "$ROOT/src/axi_lite_join.sv" \
    "$ROOT/src/axi_lite_lfsr.sv" \
    "$ROOT/src/axi_lite_mailbox.sv" \
    "$ROOT/src/axi_lite_mux.sv" \
    "$ROOT/src/axi_lite_regs.sv" \
    "$ROOT/src/axi_lite_to_apb.sv" \
    "$ROOT/src/axi_lite_to_axi.sv" \
    "$ROOT/src/axi_modify_address.sv" \
    "$ROOT/src/axi_mux.sv" \
    "$ROOT/src/axi_serializer.sv" \
    "$ROOT/src/axi_throttle.sv" \
    "$ROOT/src/axi_to_mem.sv" \
    "$ROOT/src/axi_cdc.sv" \
    "$ROOT/src/axi_err_slv.sv" \
    "$ROOT/src/axi_dw_converter.sv" \
    "$ROOT/src/axi_id_serialize.sv" \
    "$ROOT/src/axi_lfsr.sv" \
    "$ROOT/src/axi_multicut.sv" \
    "$ROOT/src/axi_to_axi_lite.sv" \
    "$ROOT/src/axi_to_mem_banked.sv" \
    "$ROOT/src/axi_to_mem_interleaved.sv" \
    "$ROOT/src/axi_to_mem_split.sv" \
    "$ROOT/src/ace_trs_dec.sv" \
    "$ROOT/src/axi_iw_converter.sv" \
    "$ROOT/src/axi_lite_xbar.sv" \
    "$ROOT/src/axi_xbar.sv" \
    "$ROOT/src/ace_xbar.sv" \
    "$ROOT/src/ace_ccu_top.sv" \
    "$ROOT/src/axi_xp.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "$ROOT/src/axi_dumper.sv" \
    "$ROOT/src/axi_sim_mem.sv" \
    "$ROOT/src/axi_test.sv" \
    "$ROOT/src/ace_test.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -svinputport=compat \
    -override_timescale 1ns/1ps \
    -suppress 2583 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6cf4f25bc9fd0d82/include" \
    "+incdir+$ROOT/include" \
    "$ROOT/test/tb_axi_dw_pkg.sv" \
    "$ROOT/test/tb_axi_xbar_pkg.sv" \
    "$ROOT/test/tb_ace_xbar_pkg.sv" \
    "$ROOT/test/tb_axi_addr_test.sv" \
    "$ROOT/test/tb_axi_atop_filter.sv" \
    "$ROOT/test/tb_axi_cdc.sv" \
    "$ROOT/test/tb_axi_delayer.sv" \
    "$ROOT/test/tb_axi_dw_downsizer.sv" \
    "$ROOT/test/tb_axi_dw_upsizer.sv" \
    "$ROOT/test/tb_axi_fifo.sv" \
    "$ROOT/test/tb_axi_isolate.sv" \
    "$ROOT/test/tb_axi_lite_mailbox.sv" \
    "$ROOT/test/tb_axi_lite_regs.sv" \
    "$ROOT/test/tb_axi_iw_converter.sv" \
    "$ROOT/test/tb_axi_lite_to_apb.sv" \
    "$ROOT/test/tb_axi_lite_to_axi.sv" \
    "$ROOT/test/tb_axi_lite_xbar.sv" \
    "$ROOT/test/tb_axi_modify_address.sv" \
    "$ROOT/test/tb_axi_serializer.sv" \
    "$ROOT/test/tb_axi_sim_mem.sv" \
    "$ROOT/test/tb_axi_to_axi_lite.sv" \
    "$ROOT/test/tb_axi_to_mem_banked.sv" \
    "$ROOT/test/tb_axi_xbar.sv" \
    "$ROOT/test/tb_ace_xbar.sv" \
    "$ROOT/test/tb_ace_ccu_top.sv"
}]} {return 1}
return 0
