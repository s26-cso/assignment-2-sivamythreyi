.section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost
make_node:
addi sp,sp,-16
sd ra,8(sp)
sw a0,4(sp) #saves input val in a0 onto stack
 
li a0,24
call malloc  #allocates 24 bytes and pointer returned is a0
lw t0,4(sp)
sw t0,0(a0)
sd x0,8(a0)
sd x0,16(a0)  # node val ,left = null ,right = null
ld ra,8(sp)
addi sp,sp,16
ret # restore and return pointer

insert:
addi sp,sp,-32
sd ra,16(sp)
sd s0,8(sp)
sd s1,0(sp)  #saves return addr,root val
mv s0,a0
mv s1,a1  #s0 is root,s1 = val
beq s0,x0,insert_new  #if null create new node
lw t0,0(s0) #t0 = root->val
blt s1,t0,insert_left
ld t1,16(s0)
mv a0,t1
mv a1,s1
call insert  #checks if val is less than root's val left or else right
sd a0,16(s0)
mv a0,s0
j insert_done
insert_left:
ld t1,8(s0)
mv a0,t1
mv a1,s1
call insert
sd a0,8(s0)
mv a0,s0
j insert_done

insert_new:
mv a0,s1
call make_node
insert_done:
ld ra,16(sp)
ld s0,8(sp)
ld s1,0(sp)
addi sp,sp,32
ret #restore registers

get:
addi sp,sp,-32
sd ra,16(sp)
sd s0,8(sp)
sd s1,0(sp)

mv s0,a0
mv s1,a1
beq s0,x0,get_null

lw t0,0(s0)
beq t0,s1,get_found
blt s1,t0,get_left
ld  t1,16(s0)
mv a0,t1
mv a1,s1
call get
j get_done

get_left:
ld t1,8(s0)
mv a0,t1
mv a1,s1
call get
j get_done
get_found:
mv a0,s0
j get_done

get_null:
li a0,0
get_done:
ld ra,16(sp)
ld s0,8(sp)
ld s1,0(sp)
addi sp,sp,32
ret

getAtMost:
addi sp,sp,-32
sd ra,24(sp)
sd s0,16(sp)
sd s1,8(sp)
sd s2,0(sp)
mv s1,a0
mv s0,a1
li s2,-1

atmost_loop:
beq s0,x0,atmost_done
lw t0,0(s0)
ble t0,s1,atmost_take
ld t1,8(s0)
mv s0,t1
j atmost_loop
atmost_take:
mv s2,t0
ld t1,16(s0)
mv s0,t1
j atmost_loop
atmost_done:
mv a0,s2
ld ra,24(sp)
ld s0,16(sp)
ld s1,8(sp)
ld s2,0(sp)
addi sp,sp,32
ret
