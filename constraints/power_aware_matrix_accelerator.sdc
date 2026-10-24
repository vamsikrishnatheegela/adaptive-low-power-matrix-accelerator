# Initial interface timing assumptions for the 50 MHz portfolio target.
# Review these budgets against the intended system interface before signoff.
create_clock -name core_clk -period 20.000 [get_ports clk]
set_clock_uncertainty 0.200 [get_clocks core_clk]
set_clock_transition 0.100 [get_clocks core_clk]

set_input_transition 0.100 [get_ports {reset_n start a00 a01 a10 a11 b00 b01 b10 b11 sleep_request wake_request idle_count[*] requested_operating_point[*] power_good dvfs_ack}]
set_input_delay -clock core_clk -max 2.000 [get_ports {start a00 a01 a10 a11 b00 b01 b10 b11 sleep_request wake_request idle_count[*] requested_operating_point[*] power_good dvfs_ack}]
set_input_delay -clock core_clk -min 0.200 [get_ports {start a00 a01 a10 a11 b00 b01 b10 b11 sleep_request wake_request idle_count[*] requested_operating_point[*] power_good dvfs_ack}]

set_output_delay -clock core_clk -max 2.000 [all_outputs]
set_output_delay -clock core_clk -min 0.000 [all_outputs]
set_load 0.050 [all_outputs]

# reset_n is asynchronous reset; no false path is applied here so reset
# recovery/removal checks are not silently suppressed.
