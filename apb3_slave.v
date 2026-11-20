module apb3_slave(

    input wire PCLK,
    input wire PRESETn,

    input wire [31:0] PADDR,
    input wire PSEL,
    input wire PENABLE,
    input wire PWRITE,
    input wire [31:0] PWDATA,

    output reg [31:0] PRDATA,
    output wire PREADY,
    output wire PSLVERR

);


reg [31:0] register_bank [0:3];


reg [1:0] wait_count;

assign PREADY = !(PSEL && PENABLE) || (wait_count >= 2);

assign PSLVERR = (PSEL && PENABLE && PREADY &&
                  (PADDR == 32'h0000000C));
always @(posedge PCLK or negedge PRESETn)
begin
    if (!PRESETn)
        wait_count <= 0;

    else if (PSEL && PENABLE)
    begin
        if (wait_count < 2)
            wait_count <= wait_count + 1'b1;
    end

    else
        wait_count <= 0;
end
integer i;

always @(posedge PCLK or negedge PRESETn)
begin
    if (!PRESETn)
    begin
        for (i = 0; i < 4; i = i + 1)
        begin
            register_bank[i] <= 32'b0;
        end
    end

    else if (PSEL && PENABLE && PWRITE && PREADY)
    begin
        register_bank[PADDR[3:2]] <= PWDATA;
    end
end
always @(*)
begin
    PRDATA = 32'b0;

    if (PSEL && PENABLE && !PWRITE)
    begin
        PRDATA = register_bank[PADDR[3:2]];
    end
end

endmodule