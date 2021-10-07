
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

interface branch_target_buffer_if;
    import dp_types_pkg::*; 
    import cpu_types_pkg::*; 

    branch_pred_instr_t rsel, wsel; 
    branch_pred_frame_t rdat, wdat; 
    logic wen, phit; 


    modport btb (
        input rsel, wsel, wen, wdat, phit, 
        output rdat
    ); 

    modport tb (
        output rsel, wsel, wen, wdat, phit, 
        input rdat
    ); 

    
endinterface