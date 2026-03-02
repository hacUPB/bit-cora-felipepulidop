@16
M=11
@17
M=233
@18
M=23
@19
M=77
@20
M=112
@21
M=61
@22
M=67
@23
M=98
@24
M=900
@25
M=810

@sum
M=0

@j
M=0

@16
D=A
@p
M=D

(LOOP)
@j
D=M
@10
D=D-A
@END
D;JGE      

@p
A=M
D=M
@sum
M=M+D

@p
M=M+1

@j
M=M+1

@LOOP
0;JMP

(END)
@END
0;JMP
