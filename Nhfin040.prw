/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Nhfin040  � Autor � Marcos R. Roquitski   � Data � 07/06/04 ���
�������������������������������������������������������������������������Ĵ��  
���Descri��o �Browse para altreacao de naturezas.                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Financeiro                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
#include "rwmake.ch"  

User Function Nhfin040()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Contas a Pagar'

aRotina := {{ "Pesquisar"  ,"AxPesqui",0,1},;
            { "Altera"     ,'U_NhFin042()',0,2}}

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
DbGoTop()
            
mBrowse(,,,,"SE2",,"E2_SALDO<=0")                           

Return(nil)    
