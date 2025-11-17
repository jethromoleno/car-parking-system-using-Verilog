`timescale 1ns/1ps
module car_parking_system(Fs, Bs, P4, P3, P2, P1, clk, reset, gLED, rLED, carCount);
    //Inputs
    input Fs; //front sensor
    input Bs; //back sensor
    input [3:0] P4, P3, P2, P1; // 4-digit password
    input clk;
    input reset;
    output wire gLED, rLED; // green LED & red LED
    output reg [3:0] carCount;

    //States
    parameter IDLE = 3'b000;
    parameter WAIT_FOR_PASSWORD = 3'b001;
    parameter DENIED_PASS = 3'b010;
    parameter ACCEPT_PASS = 3'b011;
    parameter STOP = 3'b100;

    //Registers
    reg [2:0] currState, nextState;
    reg gLamp, rLamp;

    //current State -> next State
    always @(posedge clk or negedge reset)
    begin
        if(~reset)
        begin
            currState = IDLE;
            carCount = 4'b0000;
        end
        else
            currState = nextState;
    end

    //Car counter
    always @(posedge Bs)
    begin
        carCount = carCount + 1;
    end

    //Next State
    always @(*)
    begin
        case(currState)
            IDLE:
            begin
                if(Fs == 1)
                begin
                    nextState = WAIT_FOR_PASSWORD;
                end
                else
                    nextState = IDLE;
            end
            WAIT_FOR_PASSWORD:
            begin
                if(countWait <= 3)
                    nextState = WAIT_FOR_PASSWORD;
                else
                begin
                    if((P4 == 4'b0001) && (P3 == 4'b0010) && (P2 == 4'b0011) && (P1 == 4'b0100))
                        nextState = ACCEPT_PASS;
                    else
                        nextState = DENIED_PASS;
                end
            end
            DENIED_PASS:
            begin
                if((P4 == 4'b0001) && (P3 == 4'b0010) && (P2 == 4'b0011) && (P1 == 4'b0100))
                    nextState = ACCEPT_PASS;
                else
                    nextState = DENIED_PASS;
            end
            ACCEPT_PASS:
            begin
                if(Fs == 1 && Bs == 1)
                    nextState = STOP;
                else if(Bs == 1)
                begin
                    nextState = IDLE;
                end
                else if((P4 == 4'b0001) && (P3 == 4'b0010) && (P2 == 4'b0011) && (P1 == 4'b0100))
                    nextState = ACCEPT_PASS;
                else
                    nextState = DENIED_PASS;
            end
            STOP:
            begin
                if((P4 == 4'b0001) && (P3 == 4'b0010) && (P2 == 4'b0011) && (P1 == 4'b0100))
                    nextState = ACCEPT_PASS;
                else
                    nextState = DENIED_PASS;
            end
            default: nextState = IDLE;
        endcase
    end

    //LED status dependent on the current State
    always @(posedge clk)
    begin
        case(currState)
            IDLE:
            begin
                gLamp = 1'b0;
                rLamp = 1'b0;
            end
            WAIT_FOR_PASSWORD:
            begin
                gLamp = 1'b0;
                rLamp = 1'b1;
            end
            DENIED_PASS:
            begin
                gLamp = 1'b0;
                rLamp = ~rLamp;
            end
            ACCEPT_PASS:
            begin
                gLamp = ~gLamp;
                rLamp = 1'b0;
            end
            STOP:
            begin
                gLamp = 1'b0;
                rLamp = ~rLamp;
            end
        endcase
    end
    assign gLED = gLamp;
    assign rLED = rLamp;
    
endmodule



