module lcd_core (
    input  clki,
    output led1,
    output led2,
    output led3,
    output led4,
    output led5
);

    SB_GB clk_gb (
        .USER_SIGNAL_TO_GLOBAL_BUFFER(clki),
        .GLOBAL_BUFFER_OUTPUT(clk)
    );

    i2c_master
UUT (
    .clk(clk),
    .rst(rst),
    .s_axis_cmd_address(s_axis_cmd_address),
    .s_axis_cmd_start(s_axis_cmd_start),
    .s_axis_cmd_read(s_axis_cmd_read),
    .s_axis_cmd_write(s_axis_cmd_write),
    .s_axis_cmd_write_multiple(s_axis_cmd_write_multiple),
    .s_axis_cmd_stop(s_axis_cmd_stop),
    .s_axis_cmd_valid(s_axis_cmd_valid),
    .s_axis_cmd_ready(s_axis_cmd_ready),
    .s_axis_data_tdata(s_axis_data_tdata),
    .s_axis_data_tvalid(s_axis_data_tvalid),
    .s_axis_data_tready(s_axis_data_tready),
    .s_axis_data_tlast(s_axis_data_tlast),
    .m_axis_data_tdata(m_axis_data_tdata),
    .m_axis_data_tvalid(m_axis_data_tvalid),
    .m_axis_data_tready(m_axis_data_tready),
    .m_axis_data_tlast(m_axis_data_tlast),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .busy(busy),
    .bus_control(bus_control),
    .bus_active(bus_active),
    .missed_ack(missed_ack),
    .prescale(prescale),
    .stop_on_idle(stop_on_idle)
);


endmodule
