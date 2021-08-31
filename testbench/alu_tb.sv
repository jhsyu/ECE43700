`include "cpu_types_pkg.vh"
`include "alu_if.vh"

`timescale 1 ns / 1 ns
import cpu_types_pkg::*; 


module alu_tb; 

    alu_if aluif();
    test PROG(
        .tbif(aluif)
    ); 

    `ifndef MAPPED
        alu DUT (aluif); 
    `else
        alu DUT (
            .\aluif.port_a (aluif.port_a), 
            .\aluif.port_b (aluif.port_b),
            .\aluif.port_o (aluif.port_o), 
            .\aluif.aluop (aluif.aluop), 
            .\aluif.n (aluif.n), 
            .\aluif.z (aluif.z),
            .\aluif.v (aluif.v)
        );
    `endif

endmodule



program test(
    alu_if.tb tbif
);
    logic ERR = 1'b0;
    task check_output(
        input real_input,
        input expected_output
    );
        assert (real_input == expected_output)
            else begin
                ERR = 1'b1; 
                $error("Wrong output port. expecting %d, but read %d", expected_output, real_input);
            end
    endtask

    task check_flags(
        input logic [2:0] flags //{n,z,v}
    );
        assert (tbif.n == flags[2])
            else $error("Wrong Negative flag. ");
        assert (tbif.z == flags[1])
            else $error("Wrong Zero flag. ");
        assert (tbif.v == flags[0])
            else $error("Wrong Overflow flag. ");
    endtask

    word_t input_a []; 
    word_t input_b []; 
    logic [2:0] expected_flags []; 
    initial begin
        static int test_case_num = 0;
        input_a = '{
            1,          // {n,z,v} = 3'b000
            0,          // {n,z,v} = 3'b100
            2,          // {n,z,v} = 3'b010
            'h7fffffff  // {n,z,v} = 3'b101
        }; 
        input_b = '{
            1, 
            'hffffffff, 
            'hfffffffe, 
            'h7fffffff
        }; 
        expected_flags = {
            3'b000, 
            3'b100, 
            3'b010, 
            3'b101
        }; 

        
        tbif.aluop = ALU_SLL; // default is ALU_SLL. 
        // test case 1: ADD
        tbif.aluop = ALU_ADD; 
        for (int i=0; i<4; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = input_b[i]; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_a + tbif.port_b)); 
            check_flags(expected_flags[i]);
        end
        test_case_num ++;
        // test case 2: SUB
        tbif.aluop = ALU_SUB; 
        for (int i=0; i<4; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = 0 - input_b[i]; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_a + tbif.port_b)); 
            check_flags(expected_flags[i]);
        end

        // test case 3: SLL
        test_case_num ++; 
        tbif.aluop = ALU_SLL; 
        input_b = '{
            0, 
            1, 
            word_t'(-1), 
            'hffff
        }; 
        input_a = '{
            1, 
            0, 
            $unsigned(31), 
            $unsigned(16)
        }; 
        for (int i=0; i<4; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = input_b[i]; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_b << $unsigned(tbif.port_a[4:0]))); 
        end

        // test case 4: SRL
        test_case_num ++;
        tbif.aluop = ALU_SRL; 
        input_b = '{
            0, 
            1, 
            word_t'(-1), 
            'hffff0000
        }; 
        input_a = '{
            1, 
            0, 
            $unsigned(31), 
            $unsigned(16)
        }; 
        for (int i=0; i<4; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = input_b[i]; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_b >> $unsigned(tbif.port_a[4:0]))); 
        end

        // test case 5: AND
        test_case_num ++;
        tbif.aluop = ALU_AND; 
        input_a = '{
            0, 
            'hffffffff
        }; 
        for (int i=0; i<2; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = 'hffff0000; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_a & tbif.port_b)); 
        end

        // test case 6: OR
        test_case_num ++;
        tbif.aluop = ALU_OR; 
        input_a = '{
            0, 
            'hffffffff
        }; 
        for (int i=0; i<2; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = 'hffff0000; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_a | tbif.port_b)); 
        end

        // test case 7: NOR
        test_case_num ++;
        tbif.aluop = ALU_NOR; 
        input_a = '{
            0, 
            'hffffffff
        }; 
        for (int i=0; i<2; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = 'hffff0000; 
            #(10); 
            check_output(tbif.port_o, word_t'(~(tbif.port_a | tbif.port_b))); 
        end

        // test case 8: XOR
        test_case_num ++;
        tbif.aluop = ALU_XOR; 
        input_a = '{
            0, 
            'hffffffff
        }; 
        for (int i=0; i<2; ++i) begin
            tbif.port_a = input_a[i]; 
            tbif.port_b = 'hffff0000; 
            #(10); 
            check_output(tbif.port_o, word_t'(tbif.port_a ^ tbif.port_b)); 
        end

        // test case 9: SLT
        test_case_num ++;
        tbif.aluop = ALU_SLT; 
        input_a = '{
            word_t'(-1), 
            word_t'(0), 
            word_t'(-1)
        }; 
        input_b = input_a; 
        for (int i=0; i<3; ++i) begin
            tbif.port_a = input_a[i]; 
            for (int j=0; j<3; ++j) begin
                tbif.port_b = input_b[j]; 
                #(10); 
                check_output(tbif.port_o, word_t'($signed(tbif.port_a) < $signed(tbif.port_b))); 
            end
        end
        // test case 10: SLTU
        test_case_num ++;
        tbif.aluop = ALU_SLTU; 
        input_a = '{
            word_t'(-1), 
            word_t'(0), 
            word_t'(-1)
        }; 
        input_b = input_a; 
        for (int i=0; i<3; ++i) begin
            tbif.port_a = input_a[i]; 
            for (int j=0; j<3; ++j) begin
                tbif.port_b = input_b[j]; 
                #(10); 
                check_output(tbif.port_o, word_t'($unsigned(tbif.port_a) < $unsigned(tbif.port_b))); 
            end
        end
        #(5);
        if (ERR) begin
            $display("ERROR exist."); 
        end
    end

endprogram


