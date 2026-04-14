.section .data
filename:
    .asciz "input.txt"
yes:
   .asciz "Yes\n"
no:
   .asciz "No\n"
   .section .bss
left_byte:
    .space 1
right_byte:
    .space 1          
    .section .text
    .global main
            

main:
addi sp, sp, -48
sd ra, 32(sp)
sd s0, 24(sp)
sd s1, 16(sp)
sd s2, 8(sp)
sd s3, 0(sp)
  la a0,filename
  li a1,0
  call open  #now a0 contains file descriptor
  mv s0,a0
  mv a0,s0
  li a1,0  #to get the size
  li a2,2
  call lseek
  mv  s1,a0 #s1 has the file size
  li s2,0
  addi s3,s1,-1  #left and right pointer
  loop:
  bge s2,s3,print_yes
  mv a0,s0
  mv a1,s2
  li a2,0
  call lseek  #going to left pointer 
  mv a0,s0
  la a1, left_byte
  li a2,1
  call read # reading the element and stored in memory
  mv a0,s0
  mv a1,s3
  li a2,0
  call lseek  #going to right pointer
  mv a0,s0
  la a1,right_byte
  li a2,1
  call read  #reading the element and stored in memory

  la t0,left_byte
  lb t1,0(t0)   #loading them to registers
  la t0,right_byte
  lb t2,0(t0)

  bne t1,t2,print_no
  addi s2,s2,1
  addi s3,s3,-1
  j loop

print_yes:
  la a0,yes
  call printf
  j done
print_no:
  la a0,no
  call printf

done:
mv a0,s0
call close
 li a0,0
 ld ra, 32(sp)
ld s0, 24(sp)
ld s1, 16(sp)
ld s2, 8(sp)
ld s3, 0(sp)
addi sp, sp, 48
 ret   



   