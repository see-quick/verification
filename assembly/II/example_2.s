  #include "aoaa.inc"

                .data
    leftOp:     .dword    0xf0f0f0f
    rightOp1:   .dword    0xf0f0f0f0
    rightOp2:   .dword    0x12345678
    result:     .dword    0
    saveLR:     .dword    0


    titleStr:    .asciz   "Ou yeah we continue..."

    fmtStr1:     .asciz   "%lx AND %lx = %lx\n"
    fmtStr2:     .asciz   "%lx OR  %lx = %lx\n"
    fmtStr3:     .asciz   "%lx XOR %lx = %lx\n"
    fmtStr4:     .asciz   "NOT %lx = %lx\n"


.text
  .align     2   // Make code word-aligned.
  .extern    printf

.global getTitle

getTitle:
 
  lea x0, titleStr
  ret 

.global asmMain


asmMain:

  sub sp, sp, 64
  lea x0, saveLR
  str lr, [x0]

  lea x0, leftOp
  ldr x1, [x0]
  lea x0, rightOp1
  ldr x2, [x0]
  and x3, x1, x2
  lea x0, result
  str x3, [x0]
    
  lea x0, fmtStr1
  vparm2 leftOp
  vparm3 rightOp1
  vparm4 result
  bl      printf

  lea     x0, leftOp
  ldr     x1, [x0]
  lea     x0, rightOp1
  ldr     x2, [x0]
  orr     x3, x1, x2  // Compute left OR right.
  lea     x0, result
  str     x3, [x0]

  lea     x0, fmtStr2 // Print result.
  vparm2  leftOp
  vparm3  rightOp1
  vparm4  result
  bl      printf
  
  lea     x0, leftOp
  ldr     x1, [x0]
  mvn     w1, w1      // W1 = not W1 (32 bits)
  lea     x0, result
  str     x1, [x0]

            lea     x0, fmtStr4 // Print result.
            vparm2  leftOp
            vparm3  result
            bl      printf

            lea     x0, rightOp1
            ldr     x1, [x0]
            mvn     w1, w1      // W1 = not W1 (32 bits)
            lea     x0, result
            str     x1, [x0]

            lea     x0, fmtStr4 // Print result.
            vparm2  rightOp1
            vparm3  result
            bl      printf

            lea     x0, rightOp2
            ldr     x1, [x0]
            mvn     w1, w1      // W1 = not W1
            lea     x0, result
            str     x1, [x0]

            lea     x0, fmtStr4 // Print result.
            vparm2  rightOp2
            vparm3  result
            bl      printf

  add sp, sp, #64

  lea x0, saveLR
  ldr lr, [x0]
  ret 
