package spmem_pkj;

  // thes values are constants, regardless of DataWidth
  typedef enum logic [1:0] {
    OP_BYTE  = 2'b00, //  8 bits, 1 byte
    OP_HALF  = 2'b01, // 16 bits, 2 bytes
    OP_WORD  = 2'b10, // 32 bits, 4 bytes
    OP_DWORD = 2'b11  // 64 bits, 8 bytes
  } rwop_e;

  localparam byte unsigned AddrWidth = 32, DataWidth = 64;

  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
endpackage