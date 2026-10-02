`timescale 1ns/1ns
`include "Smooth_Blinky_360.sv"

module Smooth_Blinky_360_tb;

    // in/out
    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    localparam int SIM_DUTY_MAX     = 10;
    localparam int SIM_PWM_INTERVAL = 20;

    top #(
        .DUTY_MAX(SIM_DUTY_MAX),
        .PWM_INTERVAL(SIM_PWM_INTERVAL)
    ) uut (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("Smooth_Blinky_360.vcd");
        $dumpvars(0, Smooth_Blinky_360_tb);

        #(SIM_DUTY_MAX * SIM_PWM_INTERVAL * 6 * 10);

        $display("Test Complete");
        $finish;
    end

endmodule