/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �NHEST040  � Autor � Alexandre R. Bento    � Data � 02.01.03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Gatilho que Verifica se existe o almoxarifado               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �New Hubner                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Atualiz. �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#Include "rwmake.ch"
                        
User Function Nhest044()

	Public lFlag    := .F.

	SX5->(DbSetOrder(1))
	SX5->(DbSeek(xFilial("SX5")+"ZA")) // Tabela de valida��o de Almoxarifados
	While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZA"

	   If SX5->X5_CHAVE == M->D3_LOCAL
	      lFlag := .T. //Flag de Controle                                                      
 
	   Endif
   
	   SX5->(DbSkip())
	Enddo

	If !lFlag  // Usuario sem permiss�o para cadastrar o Grupo
	   MsgBox("Almoxarifado nao Existe, Favor Utilizar um Almoxarifado Valido","Atencao","STOP")
	   Return(" ")
	Endif                   

Return
               
