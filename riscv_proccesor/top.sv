
module top(
    input logic       clk,
    input logic      reset
    );

    logic           instruction_valid;
    logic [31:0]    instruction_addr;
    logic [31:0]    instruction_read;
    logic           instruction_ready;
    logic           instruction_ack;

    logic           data_read_valid;
    logic           data_write_valid;
    logic [31:0]    data_addr;
    logic [31:0]    data_read;
    logic [31:0]    data_write;
    logic [3:0]     data_write_byte;
    logic           data_ready;
    logic           data_ack;

    // You can adjust these however you like, but here are some suggested pins for your processor
    riscv32 core #(.reset_pc(32'h00010000)              // On reset, set the PC to this value
        ) (
        .clk(clk),
        .reset(reset),
        
        .instruction_valid(instruction_valid),          // instruction fetch?
        .instruction_addr(instruction_addr),            // instruction fetch address?
        .instruction_read(instruction_read),            // data returned from memory
        .instruction_ready(instruction_ready),          // data returned is valid this clock cycle
        .instruction_ack(instruction_ack),              // request for fetch ack'ed

        .data_read_valid(data_read_valid),              // do read?
        .data_write_valid(data_write_valid),            // do write?
        .data_addr(data_addr),                          // address
        .data_read(data_read),                          // data read back from memory
        .data_write(data_write),                        // data to be written to memory
        .data_write_byte(data_write_byte),              // which bytes of the data should be written
        .data_ready(data_ready),                        // data memory has finished R/W this cycle
        .data_ack(data_ack),                            // data memory acks the R/W request
        );

    // memory

    memory#(.WIDTH(32),
            .ADDR(4)
    ) instr_mem (
        .clk(clk),
        .reset(reset),
        .read(data_read_valid),
        .write(data_write_valid),
        .addr(data_addr),
        .data(data_read),
        .wdata(data_write),
        .wstrb(data_write_byte),
        .ready(data_ready),
        .ack(data_ack)
    );

    // memory dmem
    memory #(.WIDTH(32),
            .ADDR(4)
    ) dmem (
        .clk(clk),
        .reset(reset),
        .read(data_read_valid),
        .write(data_write_valid),
        .addr(data_addr),
        .data(data_read),
        .wdata(data_write),
        .wstrb(data_write_byte),
        .ready(data_ready),
        .ack(data_ack)
    );


endmodule