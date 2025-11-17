`timescale 1ns / 1ps
module test_carparkingsystem;
    //Inputs
    reg Fs;
    reg Bs;
    reg [3:0] P4, P3, P2, P1;
    reg clk;
    reg reset;
    wire gLED, rLED;
    wire [3:0] carCount;

    car_parking_system uut(.Fs(Fs), .Bs(Bs), .P4(P4), .P3(P3), .P2(P2), .P1(P1), .clk(clk), .reset(reset), .gLED(gLED), .rLED(rLED))

    //initialize clock
    initial begin
    clk = 0l
    forever #10 clk = ~clk;
    end
    
    //initialize variables
    initial begin
    reset = 0;
    Fs = 0;
    Bs = 0;
    P4 = 0;
    P3 = 0;
    P2 = 0;
    P1 = 0;
    #100;

    //stimulus
    reset =1; #20;
    //car 1 enter
    Fs = 1; #100; P4 = 4'b0001; P3 = 4'b0010; P2 = 4'b0011; P1 = 4'b0100; #100;
    Fs = 0; Bs = 1;#100;
    //car 1 park
    Bs = 0; #100;
    //car 2 enter
    Fs = 1; #100;
    //car 2 input password
    P4 = 4'b0001; P3 = 4'b0010; P2 = 4'b0011; P1 = 4'b0100; #100;
    //car 2 park, car 3 triggered front sensor
    Bs = 1; Fs = 1; #100;
    Bs = 0; #100;
    //car 3 input password
    P4 = 4'b0000; P3 = 4'b0010; P2 = 4'b0000; P1 = 4'b0100; #100;
    P4 = 4'b0001; P3 = 4'b0010; P2 = 4'b0011; P1 = 4'b0100; #100;
    Fs = 0; #100;
    Bs = 1; #100;
    //car 3 park
    Bs = 0; #100;
    //car 4 enter
    Fs = 1; #100;
    P4 = 4'b0001; P3 = 4'b0010; P2 = 4'b0011; P1 = 4'b0100; #100;
    Bs = 1; #100;
    //car 4 park
    Fs = 0; #100;
    Bs = 0; #100;
    end
    
endmodule


