// Go about the color wheel blinking an rgb LED using pwm to do so smoothly.

module top (
    input  logic clk, 
    // output logic LED    
    output logic RGB_R = 1'b1,
    output logic RGB_G = 1'b1,
    output logic RGB_B = 1'b1
);

    // Ceiling for duty cycle
    parameter int DUTY_MAX = 1000;
    logic [$clog2(DUTY_MAX) - 1:0] duty_count = 0;

    // How often to up ramp count
    parameter int PWM_INTERVAL = 2000;
    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_count = 0;

    // Used to control color brightness
    logic [$clog2(DUTY_MAX) - 1:0] ramp_count = 0;
    logic [2:0] color_idx = 3'd0;

    always_ff @(posedge clk) begin
        if (duty_count == DUTY_MAX -1) begin
            duty_count <= 0;
        end
        else begin
            duty_count <= duty_count + 1'b1;
        end
        if (pwm_count == PWM_INTERVAL - 1) begin
            pwm_count <= 0;
            if (ramp_count == DUTY_MAX - 1) begin
                ramp_count <= 0;
                if (color_idx == 3'd5) begin  // If end of cycle, loop back to Red
                    color_idx <= 3'd0;
                end
                else begin // Otherwise, move to the next color
                    color_idx <= color_idx + 3'd1;
                end
            end
            else begin
                ramp_count <= ramp_count + 1'b1;
            end
        end
        else begin
            pwm_count <= pwm_count + 1'b1;
        end

        case (color_idx)
            3'd0: begin // Red
                RGB_R <= 0;
                RGB_G <= (duty_count >= ramp_count);
                RGB_B <= 1;
            end
            3'd1: begin // Yellow
                RGB_R <= (duty_count < ramp_count);
                RGB_G <= 0;
                RGB_B <= 1;
            end
            3'd2: begin // Green
                RGB_R <= 1;
                RGB_G <= 0;
                RGB_B <= (duty_count >= ramp_count);
            end
            3'd3: begin // Cyan
                RGB_R <= 1;
                RGB_G <= (duty_count < ramp_count);
                RGB_B <= 0;
            end
            3'd4: begin // Blue
                RGB_R <= (duty_count >= ramp_count);
                RGB_G <= 1;
                RGB_B <= 0;
            end
            3'd5: begin // Magenta
                RGB_R <= 0;
                RGB_G <= 1;
                RGB_B <= (duty_count < ramp_count);
            end
            default: begin
                RGB_R <= 1;
                RGB_G <= 1;
                RGB_B <= 1;
            end
        endcase
    end

endmodule