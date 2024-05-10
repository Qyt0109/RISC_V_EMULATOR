main:
    call target_function
    
    nop


target_function:
# push current return address (ra)
    addi sp, sp, 4             # Add 32 bit volume space in stack
    sw   ra, 0(sp)             # Store address word (32 bit) to stack

# call function
    call function

# pop stored return address (ra)
    lw   ra, 0(sp)             # Load address word (32 bit) from stack
    addi sp, sp, -4            # Remove 32 bit volume space in stack

    ret

function:
    ret