module apb3_master(

    input wire PCLK,
    input wire PRESETn,

    output reg [31:0] PADDR,
    output reg PSEL,
    output reg PENABLE,
    output reg PWRITE,
    output reg [31:0] PWDATA,

    input wire [31:0] PRDATA,
    input wire PREADY,
    input wire PSLVERR

);
parameter IDLE        = 3'b000;
parameter WRITE_SETUP = 3'b001;
parameter WRITE_ACCESS= 3'b010;
parameter READ_SETUP  = 3'b011;
parameter READ_ACCESS = 3'b100;
parameter DONE        = 3'b101;

reg [2:0] state;
reg [1:0] transaction;
initial begin
    $monitor("Time=%0t State=%b PADDR=%h PWDATA=%d PRDATA=%d PSEL=%b PENABLE=%b PWRITE=%b",
             $time, state, PADDR, PWDATA, PRDATA, PSEL, PENABLE, PWRITE);
end
always @(posedge PCLK or negedge PRESETn)
begin
    if (!PRESETn)
begin
    state <= IDLE;
    transaction <= 0;
end

    else
    begin
        case (state)

            IDLE:
                state <= WRITE_SETUP;

            WRITE_SETUP:
                state <= WRITE_ACCESS;

            WRITE_ACCESS:
                if (PREADY)
                    state <= READ_SETUP;

            READ_SETUP:
                state <= READ_ACCESS;

            READ_ACCESS:
    if (PREADY)
    begin
        if (transaction == 2)
            state <= DONE;
        else
        begin
            transaction <= transaction + 1'b1;
            state <= WRITE_SETUP;
        end
    end

            DONE:
                state <= DONE;

            default:
                state <= IDLE;

        endcase
    end
end
always @(*)
begin
    PADDR   = 32'b0;
    PSEL    = 1'b0;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;
    PWDATA  = 32'b0;

    case (state)

        WRITE_SETUP, WRITE_ACCESS:
begin
    PSEL   = 1'b1;
    PWRITE = 1'b1;

    case (transaction)

        0: begin
            PADDR  = 32'h00000008;
            PWDATA = 32'd50;
        end

        1: begin
            PADDR  = 32'h00000004;
            PWDATA = 32'd100;
        end

        2: begin
            PADDR  = 32'h0000000C;
            PWDATA = 32'd25;
        end

    endcase
end

        READ_SETUP, READ_ACCESS:
begin
    PSEL   = 1'b1;
    PWRITE = 1'b0;

    case (transaction)

        0: PADDR = 32'h00000008;

        1: PADDR = 32'h00000004;

        2: PADDR = 32'h0000000C;

    endcase
end

        default:
        begin
        end

    endcase

    if (state == WRITE_ACCESS || state == READ_ACCESS)
        PENABLE = 1'b1;

end

endmodule