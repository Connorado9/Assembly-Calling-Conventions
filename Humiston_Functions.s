.text
.global sum_two
sum_two:
	subi    sp, sp, 12			# function prologue
    stw     ra, 8(sp)
    stw     r4, 4(sp)
    stw		r5, 0(sp)
    
	add		r2, r4, r5
    
    ldw     r5, 0(sp)			# function epilog
    ldw		r4, 4(sp)
    ldw		ra, 8(sp)
    addi	sp, sp, 12
    ret


.global op_three
op_three:
	subi    sp, sp, 12			# function prologue
    stw     ra, 12(sp)
    stw		r4, 8(sp)
    stw     r5, 4(sp)
    stw		r6, 0(sp)
	
	call 	op_two
	mov		r4, r2
    mov		r5, r6
    call	op_two
	
	ldw     r6, 0(sp)			# function epilogue
    ldw		r5, 4(sp)
    ldw		r4, 8(sp)
    ldw		ra, 12(sp)
    addi	sp, sp, 12
    ret


.global fibonacci
fibonacci:
	subi	sp, sp, 16			# allocate 16 bytes on the stack
    stw		ra, 12(sp)			
    stw		r6, 8(sp)

	# Base Case: n == 0
    beq		r4, r0, base_case0
    
    # Base Case: n == 1
    movi	r5, 1
    beq		r4, r5, base_case1
	
    # For n != 1,0
    # First Call: Subtract 1
    stw		r4, 4(sp)			# store n to the stack
    subi	r4, r4, 1			# n - 1
    call	fibonacci			# fibonacci(n-1)
    stw		r2, 0(sp)
    ldw		r4, 4(sp)			# restore n
    
    # Second Call: Subtract 2
    subi	r4, r4, 2			# n - 2
    call	fibonacci			# fibonacci(n-2) 
    mov		r6, r2				# move result of f(n-2) into r6
    ldw		r2, 0(sp)			# restore f(n-1)
    
    # Adding Final Results
    add		r2, r6, r2			# f(n-1) + f(n-2)
    ldw		r4, 4(sp)			# restore n
	br		fibonacci_exit		# can't just ret, need to deallocate

  base_case0:
	movi	r2, 0				# if (n == 0) return 0
    jmpi	fibonacci_exit
    
  base_case1:
  	movi	r2, 1				# if (n == 1) return 1
    jmpi	fibonacci_exit
    
  fibonacci_exit:
  	ldw		r6, 8(sp)
    ldw		ra, 12(sp)			# restore ra
    addi	sp, sp, 16			# deallocate ra/fp space
    ret
	