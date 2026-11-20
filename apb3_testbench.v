`timescale 1ns / 1ps

module apb3_testbench;

    reg PCLK;
    reg PRESETn;

    wire [31:0] PRDATA;
    wire PREADY;
    wire PSLVERR;

    integer i;
    integer errors;

    apb3_top uut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    // Test sequence
    initial begin

        PRESETn = 0;
        errors = 0;

        #20;
        PRESETn = 1;

        for (i = 0; i < 3; i = i + 1)
        begin
            wait (uut.PSEL == 1 &&
                  uut.PENABLE == 1 &&
                  uut.PWRITE == 0 &&
                  PREADY == 1);

            #1;

            $display("--------------------------------");
            $display("Transaction %0d", i + 1);
            $display("Address = %h", uut.PADDR);
            $display("Read Data = %d", PRDATA);

case (i)

    0: begin
        if (PRDATA == 32'd50 && PSLVERR == 1'b0)
            $display("TRANSACTION 1 PASSED");
        else begin
            $display("TRANSACTION 1 FAILED");
            errors = errors + 1;
        end
    end

    1: begin
        if (PRDATA == 32'd100 && PSLVERR == 1'b0)
            $display("TRANSACTION 2 PASSED");
        else begin
            $display("TRANSACTION 2 FAILED");
            errors = errors + 1;
        end
    end

    2: begin
        if (PSLVERR == 1'b1)
            $display("TRANSACTION 3 ERROR DETECTED SUCCESSFULLY");
        else begin
            $display("TRANSACTION 3 FAILED: ERROR NOT DETECTED");
            errors = errors + 1;
        end
    end

endcase
            wait (!(uut.PSEL == 1 &&
                    uut.PENABLE == 1 &&
                    uut.PWRITE == 0));

        end

        $display("--------------------------------");

        if (errors == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("--------------------------------");

        #10;
        $finish;

    end
    initial begin
        #500;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule