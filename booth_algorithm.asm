.data
num1: .word 5		# numero Q
num2: .word 32		# numero M

HIGH: .asciiz "HIGH (decimal): "
LOW: .asciiz "\nLOW (decimal): "

.text
lw $s1, num2			# numero M

li $s2, 0			# HIGH
li $t0, 0 			# bit Q-1
li $t2, 0			# navegar pelo loop
li $t3, 32			# limite do loop

lw $s3, num1			# define o LOW como Q

sll $t1, $s3, 31		# pega primeira posicao de Q
srl $t1, $t1, 31

LOOP:	
	bne $t1, $t0, DEFINEOPERACAO	# verifica se a primeira posicao de Q com Q-1 sao iguais
	
	j REPETICAO
	
	
DEFINEOPERACAO:	
	bne $t1, 1, SOMA
	
	sub $s2, $s2, $s1	# subtracao: A = A - M
	j REPETICAO

SOMA:
	add $s2, $s2, $s1	# soma: A = A + M
	j REPETICAO

REPETICAO:
	srl $t4, $s2, 31	# pega o ultimo bit de A
	sll $t4, $t4, 31
	
	sll $t5, $s2, 31	# pega o primeiro bit de A
	
	and $t0, $s3, 1		# salva o primeiro bit de Q em Q-1
	srl $s2, $s2, 1		# shift pra direita de A
	or $s2, $s2, $t4	# adiciona ultimo bit de A a ultima posicao de A apos o shift
	
	srl $s3, $s3, 1		# shift pra direita de Q
	or $s3, $s3, $t5	# soma o primeiro bit de A em Q
	
	sll $t1, $s3, 31	# pega primeira posicao de Q
	srl $t1, $t1, 31
	
	add $t2, $t2, 1
	bne $t2, $t3, LOOP
	
	j Exit

Exit:	
	la $a0, HIGH
	add $v0, $0, 4
	syscall
	
	add $a0, $0, $s2
	add $v0, $0, 1
	syscall
	
	la $a0, LOW
	add $v0, $0, 4
	syscall
	
	add $a0, $0, $s3
	add $v0, $0, 1
	syscall
	
