package pkg;
    
    // define the Common width that is to be used in the project
    localparam int DATA_WIDTH = 32;
    localparam int ADDR_WIDTH = 32;

    // create dimentions for matrix that can be reused
    localparam int MATRIX_WIDTH = 3;
    typedef logic [DATA_WIDTH-1:0] matrix_t [MATRIX_WIDTH-1:0][MATRIX_WIDTH-1:0];

        

endpackage