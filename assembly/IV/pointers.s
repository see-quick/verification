#include "../aoaa.inc"

          .section  .rodata, ""
ttlStr:   .asciz    "Pointer which points to pointer and the that guy points to another byte... :D"
fmtStr:   .ascii    "pb's value is %p\n"
          .asciz    "*pb's value is %d\n"
        
          .data
bb:       .byte     0
          .byte     1, 2, 3, 4, 5, 6, 7
        
pb        =         bb+2     // Address of "2" in bb
pbVar:   .dword     pb
pbValue: .word      0
        
        .text
        .align      2
        .extern     printf



         .global    getTitle
getTitle:
         lea        x0, ttlStr
         ret

       
        .global     asmMain
asmMain:
        sub     sp, sp, #64     // Reserve space on stack
        str     lr, [sp, #56]   // Save return address

        lea     x0, pbVar       // Get pbVar
        ldr     x0, [x0]
        ldrb    w0, [x0]        // Fetch data at *pbVar
        lea     x1, pbValue     // Save in pbValue for now
        str     w0, [x1]

        lea     x0, fmtStr
        vparm2  pbVar
        vparm3  pbValue
        bl      printf
        
        ldr     lr, [sp, #56]   // Restore return address
        add     sp, sp, #64
        ret     //Returns to caller
        
