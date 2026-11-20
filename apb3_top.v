module apb3_top(

    input wire PCLK,
    input wire PRESETn,

    output wire [31:0] PRDATA,
    output wire PREADY,
    output wire PSLVERR

);
wire [31:0] PADDR;
wire PSEL;
wire PENABLE;
wire PWRITE;
wire [31:0] PWDATA;
apb3_master master_inst (

    .PCLK(PCLK),
    .PRESETn(PRESETn),

    .PADDR(PADDR),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR)

);
apb3_slave slave_inst (

    .PCLK(PCLK),
    .PRESETn(PRESETn),

    .PADDR(PADDR),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR)

);

endmodule