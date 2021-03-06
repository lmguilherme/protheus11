#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAC012  � Autor � Handerso Duarte    � Data �  11/02/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de An�lise Cr�tica Comercial                      ���
���          � Tabela ZC1                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � WHB MP10 R 1.2 MSSQL                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAC012 ()
Local aCores := {{"	ZC1_STAREV	.AND. Empty(ZC1_STATUS)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revis�o ou aprovacao
                 {"	!ZC1_STAREV"						       ,"BR_PRETO" },;                //Revis�o obsoleta
                 {"ZC1_STATUS=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC1_STATUS=='N'"						      ,"DISABLE" }}                //Reprovado

Local aUser	 	    := {}   
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persist�ncias forem conclu�das com �xito.
Private cCadastro 	:=	"Cadastro de An�lise Cr�tica Comercial"
Private cCargo		:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart		:=	"{"+Getmv("WHB_DPTO")+"}"
Private aCargo		:=	&cCargo   //Cagos autorizados a aprovar e geras revis�es
Private aDepart		:=	&cDepart//Departamentos autorizados a aprovar e geras revis�es

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC012A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC012A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC012A (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC012A (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC012A (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR009"	,0,8},;        		     
        		     {"Legenda		","U_PPAC012H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC1"

dbSelectArea("ZC1")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC012H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC012A (nOpc) 
Local nRecNo	:=	IIF(nOpc<>3,ZC1->(RecNo()),0)
Local lFlag		:=	.T. 
Local aUser	 	    := {}     
Local cAprovAnt		:= ""
Local cStaRevAnt	:= "" 
Local nRecNoAnt		:= '' 
lRet := ''
Do Case
	Case nOpc == 3 //Inclusao
		AxInclui( cString,,,,,,"U_PPAC012B  ("+AllTrim(Str(nOpc))+")",,,)
		  
	Case nOpc == 4 //Alteracao    
		If Empty(ZC1->ZC1_STATUS) .AND. ZC1->ZC1_STAREV
			AxAltera(cString,,nOpc,,,,,"U_PPAC012B  ("+AllTrim(Str(nOpc))+")",,,) 
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Altera��o"	
			cTexto		:=	"O registro n�o pode ser alterado, pois j� foi aprovado/reprovado ou � uma revis�o obsoleta"
		EndIf
		  
	Case nOpc == 5 //Excluir 
		lFlag		:=	.F.
		cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Exclus�o"	
		cTexto		:=	"N�o � permitido efetuar exclus�o dos Registros."
		
	Case nOpc == 6 //Gerar revis�o
		If !Empty(ZC1->ZC1_STATUS) .AND. ZC1->ZC1_STAREV  
			
			DBSelectArea("ZC1")
			ZC1->(DBgoto(nRecNo))    
			cAprovAnt	:= ZC1->ZC1_STATUS
			cStaRevAnt	:= ZC1->ZC1_STAREV
			nRecNoAnt	:= nRecNo
				
			nRecNo		:=	sfGerRev(nRecNo,nOpc)
			If nRecNo<>0
				DBSelectArea("ZC1")
				ZC1->(DBgoto(nRecNo))
				lRet := AxAltera(cString,,4,,,,,"U_PPAC012B  ("+AllTrim(Str(nOpc))+")",,,)
				If lRet = 3
				
					RecLock("ZC1",.F.) 
						DbDelete()
					ZC1->(MsUnLock())
					
					ZC1->(DBGoTo(nRecNoAnt))    
					RecLock("ZC1",.F.) 
						ZC1->ZC1_STATUS	:= cAprovAnt
						ZC1->ZC1_STAREV := cStaRevAnt
					ZC1->(MsUnLock())
			
				EndIf 
			EndIf
		Else
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Gerar Revis�o"	
			cTexto		:=	"O registro n�o pode ser alterado, pois n�o foi aprovado/reprovado ou � uma revis�o obsoleta."		
		EndIf		
	Case nOpc == 7 //Aprovar/Reprovar
		If Empty(ZC1->ZC1_STATUS) .AND. ZC1->ZC1_STAREV
			sfAprovar (nRecNo,nOpc)//7	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro n�o pode ser alterado, pois j� foi aprovado/reprovado ou � uma revis�o obsoleta."							
		EndIf	
		
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+")"
		cTexto:="Opera��o n�o configurada."
				
EndCase
If !lFlag
	MsgAlert(cTexto,cTitulo)			
EndIf
Return (lRet)
//==========================Fim da Incluis�o de Registros==========================================
//==========================Valida��o para Grava��o================================================
User Function PPAC012B (nOpc)
Local lRet		:=	.T.
Local aArea		:=	ZC1->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC1->(REcNo()),0)
Local cMensagem	:=	"H� um documento pendente para an�lise."
Local cEMail	:=	""
cTitulo	:=	""	
cTexto	:=	""

Do Case
	Case nOpc == 3 //Inclusao 
		DBselectArea("ZC1")
		ZC1->(DBSetOrder(1))//ZC1_FILIAL, ZC1_ACC, ZC1_REV, R_E_C_N_O_, D_E_L_E_T_
		If !ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)))
			ZC1->(DBSetOrder(6))//ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET
			If !ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)))
				lRet:=.T.
			Else
				lRet:=.F.
				cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
				cTexto:="J� existe registro com o mesmo Produto e Projeto. Verifique "+ZC1->ZC1_ACC+" Revis�o "+ZC1->ZC1_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="J� existe registro com a mesma numera��o de controle e revis�o. Verifique "+ZC1->ZC1_ACC+" Revis�o "+ZC1->ZC1_REV
		EndIf
		If lRet .AND. M->ZC1_RESTRI=="1" .AND. Empty(M->ZC1_QUAL)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Incluir"
			cTexto:="Se campo LOCAL RESTR.(ZC1_RESTRI) for sim, ent�o � necess�rio informar o campo Qual (ZC1_QUAL)"								
		EndIf 
		If lRet .AND. M->ZC1_CUSTO=="1" .AND. Empty(M->ZC1_RELATA)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Incluir"
			cTexto:="Se campo CUSTO(ZC1_CUSTO) for sim, ent�o � necess�rio informar o campo RELATAR (ZC1_RELATA)"								
		EndIf		
		If lRet .AND. M->ZC1_CONDFO=="4" .AND. Empty(M->ZC1_OUTROS)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo COND. FORNEC (ZC1_CONDFO) for igual a OUTROS, ent�o � necess�rio informar o campo OUTROS QUAL? (ZC1_OUTROS)"								
		EndIf		
		If lRet .AND. M->ZC1_DOC=="1" .AND. (M->ZC1_ANOS)==0
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo SUJEITO DOC. (ZC1_DOC) for igual a SIM, ent�o � necess�rio informar o campo QTOS ANOS? (ZC1_ANOS)"								
		EndIf		

		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_NOVADT)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL for igual a NAO, ent�o � necess�rio informar o campo NOVO NIVEL"								
		EndIf		
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_ALTER)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL (ZC1_DESNIV) for igual a NAO, ent�o � necess�rio informar o campo QUAIS (ZC1_ALTER)"								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situa��o Pendente "+cCadastro,M->ZC1_ACC,M->ZC1_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situa��o Pendente "+cCadastro+" "+M->ZC1_ACC ,cEMail,"",)
			EndIf		
		EndIf
		
	Case nOpc == 4 //Altera�ao
		DBselectArea("ZC1") 
		ZC1->(DBSetOrder(1))//ZC1_FILIAL, ZC1_ACC, ZC1_REV, R_E_C_N_O_, D_E_L_E_T_
		ZC1->(DBGotop())		
		If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)))
			Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_ACC+ZC1_REV)==(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)) .AND. lRet
				If ZC1->(RecNo())<>nRecNo  
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC1->(DBSkip())
			EndDo
			If lRet
				ZC1->(DBSetOrder(6))//ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET
				ZC1->(DBGotop())				
				If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)))
					Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)==(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)) .AND. lRet
						If ZC1->(RecNo())<>nRecNo .AND. ZC1->ZC1_ACC<>M->ZC1_ACC
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC1->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
						cTexto:="J� existe registro com o mesmo Produto e Projeto. Verifique "+ZC1->ZC1_ACC+" Revis�o "+ZC1->ZC1_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
				cTexto:="J� existe registro com a mesma numera��o de controle e revis�o. Verifique "+ZC1->ZC1_ACC+" Revis�o "+ZC1->ZC1_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="N�o h� registro a ser alterado. Erro na opera��o de Altera��o."
		EndIf 
		If lRet .AND. M->ZC1_RESTRI=="1" .AND. Empty(M->ZC1_QUAL)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="Se campo LOCAL RESTR.(ZC1_RESTRI) for sim, ent�o � necess�rio informar o campo Qual (ZC1_QUAL)"								
		EndIf		
		If lRet .AND. M->ZC1_CONDFO=="4" .AND. Empty(M->ZC1_OUTROS)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="Se campo COND. FORNEC (ZC1_CONDFO) for igual a OUTROS, ent�o � necess�rio informar o campo OUTROS QUAL? (ZC1_OUTROS)"								
		EndIf
		If lRet .AND. M->ZC1_CUSTO=="1" .AND. Empty(M->ZC1_RELATA)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Altera��o"
			cTexto:="Se campo CUSTO(ZC1_CUSTO) for sim, ent�o � necess�rio informar o campo RELATAR (ZC1_RELATA)"								
		EndIf		
		If lRet .AND. M->ZC1_DOC=="1" .AND. (M->ZC1_ANOS)==0
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="Se campo SUJEITO DOC. (ZC1_DOC) for igual a SIM, ent�o � necess�rio informar o campo QTOS ANOS? (ZC1_ANOS)"								
		EndIf
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_NOVADT)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="Se campo MESMO NIVEL for igual a NAO, ent�o � necess�rio informar o campo NOVO NIVEL"								
		EndIf			
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_ALTER)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL (ZC1_DESNIV) for igual a NAO, ent�o � necess�rio informar o campo QUAIS (ZC1_ALTER)"								
		EndIf		 
		
	Case nOpc == 6 //Gerar Revis�o
		DBselectArea("ZC1") 
		ZC1->(DBSetOrder(1))//ZC1_FILIAL+ZC1_ACC+ZC1_REV
		ZC1->(DBGotop())		
		If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)))
			Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_ACC+ZC1_REV)==(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)) .AND. lRet
				If ZC1->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC1->(DBSkip())
			EndDo
			If lRet
				ZC1->(DBSetOrder(6))//ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET
				ZC1->(DBGotop())				
				If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)))
					Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)==(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)) .AND. lRet
						If ZC1->(RecNo())<>nRecNo .AND. M->ZC1_ACC<>ZC1->ZC1_ACC
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC1->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
						cTexto:="J� existe registro com o mesma Pe�a e Projeto. Verifique "+ZC1->ZC1_ACC+" Revis�o "+ZC1->ZC1_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
				cTexto:="J� existe registro com a mesma numera��o de controle e revis�o. Verifique "+ZC1->ZC1_ACC+" Revis�o "+ZC1->ZC1_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="N�o h� registro a ser alterado. Erro na opera��o de Altera��o."
		EndIf
		If lRet .AND. Empty(M->ZC1_MOTIVO)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="� necess�rio informar o movito da revis�o."								
		EndIf
		If lRet .AND. M->ZC1_RESTRI=="1" .AND. Empty(M->ZC1_QUAL)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Gera Revis�o"
			cTexto:="Se campo LOCAL RESTR.(ZC1_RESTRI) for sim, ent�o � necess�rio informar o campo Qual (ZC1_QUAL)"								
		EndIf		
		If lRet .AND. M->ZC1_CONDFO=="4" .AND. Empty(M->ZC1_OUTROS)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="Se campo COND. FORNEC (ZC1_CONDFO) for igual a OUTROS, ent�o � necess�rio informar o campo OUTROS QUAL? (ZC1_OUTROS)"								
		EndIf		
		If lRet .AND. M->ZC1_DOC=="1" .AND. (M->ZC1_ANOS)==0
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="Se campo SUJEITO DOC. (ZC1_DOC) for igual a SIM, ent�o � necess�rio informar o campo QTOS ANOS? (ZC1_ANOS)"								
		EndIf
		If lRet .AND. M->ZC1_CUSTO=="1" .AND. Empty(M->ZC1_RELATA)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Gera Revis�o"
			cTexto:="Se campo CUSTO(ZC1_CUSTO) for sim, ent�o � necess�rio informar o campo RELATAR (ZC1_RELATA)"								
		EndIf
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_NOVADT)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="Se campo MESMO NIVEL for igual a NAO, ent�o � necess�rio informar o campo NOVO NIVEL)"								
		EndIf			
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_ALTER)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL (ZC1_DESNIV) for igual a NAO, ent�o � necess�rio informar o campo QUAIS (ZC1_ALTER)"								
		EndIf	
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situa��o Pendente "+cCadastro,M->ZC1_ACC,M->ZC1_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situa��o Pendente "+cCadastro+" "+M->ZC1_ACC ,cEMail,"",)
			EndIf		
		EndIf						
		
	OtherWise	
		lRet:=.F.
		cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")"
		cTexto:="Opera��o n�o configurada."
EndCase	

RestArea(aArea)
If !lRet
	MsgAlert(cTexto,cTitulo)	
EndIf
Return(lRet)
//==========================Fim da Valida��o para Grava��o=========================================
//==========================Gera revi�o ===========================================================
Static Function sfGerRev(nRecNo,nOpc)
Local 	lRet		:=	.F. 
Local	nRecNoAtu	:=	0 
Local 	nCont		:=	0 
Local   aUser	    := {}	
Local 	aAreaZC1	:=	ZC1->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC1->(DbStruct())
Private	cNomArq 	:=	""
 
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

dbSelectArea("ZC1")
ZC1->(DBGoTo(nRecNo)) 
dbSelectArea("TRB")
RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC1->&(aStru[nCont][1])
	Next nCont
	TRB->ZC1_REV	:=	sfRevisao (ZC1->ZC1_ACC)//Nova Revis�o
	TRB->ZC1_APPRO	:=  StoD(" / / ")
	TRB->ZC1_STATUS	:=	""
	TRB->ZC1_STAREV	:=	.T.		
	TRB->ZC1_MOTIVO	:=	""		
	TRB->ZC1_DTREV	:=	dDataBase		
TRB->(MsUnLock())

BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC1")
	ZC1->(dbSetOrder(1))//ZC1_FILIAL+ZC1_ACC+ZC1_REV
	If !ZC1->(DBSeek(xFilial("ZC1")+TRB->(ZC1_ACC+ZC1_REV)))
		lRet:=RecLock("ZC1",.T.)
			If lRet
				For nCont := 1 TO FCount() 	
					FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC1->ZC1_FILIAL := TRB->ZC1_FILIAL					
			EndIf
		nRecNoAtu:=ZC1->(RecNo())
		ZC1->(MsUnLock())  								
		
		dbSelectArea("ZC1") //Atualiza o registro como ves�o n�o atual
		ZC1->(DBGoTo(nRecNo)) 
		lRet:=RecLock("ZC1",.F.)
			If lRet 
				ZC1->ZC1_STAREV	:=	.F.
			EndIf	
		ZC1->(MsUnLock()) 				
						       
	Else
		lRet:=.F.
	EndIf 
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC012->PPAC012B->sfGerRev("+AllTrim(Str(nOpc))+") Revis�o"
		cTexto:="Erro ao gerar a revis�o, verifique se h� algum usu�rio realizado altera��es no registro"
	Else
		cTitulo:="TPPAC012->PPAC012B->sfGerRev("+AllTrim(Str(nOpc))+") Revis�o"
		cTexto:="Revis�o gerada com sucesso"			
	EndIf 
END TRANSACTION 

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC1)
lTudoOK:=lRet
Return(nRecNoAtu)
//==========================Fim Gera revis�o======================================== 
//===============================Aprova��o de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC1	:=	ZC1->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC1->ZC1_STATUS) .OR. AllTrim(ZC1->ZC1_STATUS)=="N" ) .AND. ZC1->ZC1_STAREV//S� poder� ser aprovado caso o pedido que ainda n�o esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
	  aUser := PswRet() // Retorna vetor com informa��es do usu�rio
	EndIf
	
	DBSelectArea("QAA") 
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))
		Do While QAA->(!EoF()) .AND. QAA->QAA_LOGIN==aUser[1][2] .AND. lFlag
			If QAA->QAA_TPUSR=="1" .AND. !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN))) .AND. QAA->QAA_STATUS=="1";
				 .AND. QAA->QAA_LOGIN==aUser[1][2] .AND. (dDataBase>=QAA->QAA_INICIO .AND. (dDataBase<=QAA->QAA_FIM .OR. Empty(DtoS(QAA->QAA_FIM))));
				.AND. QAA->QAA_RECMAI=="1" .AND. !Empty(QAA->QAA_EMAIL) 
				
				lFlag:=.F.
				If !APMsgNoYes("Aprovar o Registro","Aprovar?")
					Processa({||sfAprvRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL)}) //Reprovar
				Else
					Processa({||sfAprvRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)})	//Aprovar		
				EndIf		
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usu�rio sem permiss�o para aprovar o documento.","TPPAC012->PPAC012A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")
	EndIf
Else
	MsgAlert("S� poder� ser Aprovado/Reprovado caso o registro que ainda n�o esteja aprovado ou que seja uma revis�o atualizada",;
			"TPPAC012->PPAC012A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC1)

Return ()
//==========================Fim da Aprova��o de Registros==========================================
//================================APROVA��O OU REPROVA��O DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC1	:= 	ZC1->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cACC	:=	""
Local cREV	:=	""
dbSelectArea("ZC1")
ZC1->(DBSetOrder(1)) //ZC1_FILIAL,ZC1_ACC,ZC1_REV
ZC1->(DBGoTo(nRecNo))
cACC	:=	ZC1->ZC1_ACC
cREV	:=	ZC1->ZC1_REV   
BEGIN TRANSACTION
	Do Case
		Case	ZC1->ZC1_RESP==cMatr
			If ZC1->(DBSeek(xFilial("ZC1")+cACC+cREV))
				lFlag:=RecLock("ZC1",.F.)
					ZC1->ZC1_APPRO		:=dDataBase		
					If nOpc==7  //Aprova��o
						ZC1->ZC1_STATUS		:="S"
					ElseIf nOpc==8//Reprova��o 
						ZC1->ZC1_STATUS		:="N"
					EndIf					
				ZC1->(MsUnLock())
			Else 
				lFlag:=.F.
				cTexto:="O Registro n�o encontrado. Erro na opera��o"
				cTitulo:="TPPAC012->PPAC012A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"
			EndIf 
			 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usu�rio n�o faz parte do documento. A opera��o n�o proder� ser gravada."
			cTitulo:="TPPAC012->PPAC012A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"
			
	EndCase
	
	If  !lFlag  //Desfaz a transa��o se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	MsgStop(cTexto,cTitulo)
EndIf

If lFlag .AND. nOpc==8//Reprova��o 		
	While Empty(cMensagem)	 
		Alert('O preenchimento da Justificativa de Reprova��o � obrigatorio!')	
		cMensagem:=sfJustif ( )	//chamada da tela de justificativa
	EndDo				
	
	//Grava na tabela de justificativas
	dbSelectArea("ZC1")
	ZC1->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC1->ZC1_ACC
		ZCC->ZCC_REV	:=	ZC1->ZC1_REV			
		ZCC->ZCC_TABELA	:=	"ZC1"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
	//Chamada da func�o do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprova��o "+cCadastro,ZC1->ZC1_ACC,ZC1->ZC1_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprova��o "+cCadastro+" "+ZC1->ZC1_ACC ,cEMail,"",)})
	EndIf	
EndIf
If lFlag .AND. nOpc==7//Aprovado
	cMensagem:="O registro da Rotina "+cCadastro+" Numero de Controle "+ZC1->ZC1_ACC+"-"+ZC1->ZC1_REV+" foi aprovado."
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
	//Chamada da func�o do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Registro Aprovado"+cCadastro,ZC1->ZC1_ACC,ZC1->ZC1_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Registro Aprovado"+cCadastro+" "+ZC1->ZC1_ACC ,cEMail,"",)})
	EndIf	
EndIf

RestArea(aAreaZC1)
Return( )
//========================FIM DA  APROVA��O OU REPROVA��O =========================================
//================================REVIS�O =========================================================
Static Function sfRevisao (cACC)
Local cRet		:=	""
Local aAreaZC1	:=	ZC1->(GetArea())
DBSelectArea("ZC1")
ZC1->(DBGoTop())
ZC1->(DBSetOrder(1))//ZC1_FILIAL+ZC1_ACC+ZC1_REV
If ZC1->(DBSeek(xFilial("ZC1")+cACC))
	Do While ZC1->(!EoF()) .AND. (ZC1->(ZC1_FILIAL+ZC1_ACC)) == ;
			  (xFilial("ZC1")+(cACC))
		cRet:=ZC1->ZC1_REV			 					
		ZC1->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revis�o
RestArea(aAreaZC1)
Return (cRet)
//================================FIM DA REVIS�O ================================================== 
//================================JUSTIFICATIVA DA REPROVA��O======================================
Static Function sfJustif ( )

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private cGetTexto  := ""

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgEmail","oGetTexto","oBtnEnviar","oGetMemo")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlgEmail  := MSDialog():New( 168,253,451,948,"Justificativa da Reprova��o",,,.F.,,,,,,.T.,,,.T. )
//oGetTexto  := TGet():New( 020,004,{|u| If(PCount()>0,cGetTexto:=u,cGetTexto)},oDlgEmail,336,114,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTexto",,)
@ 020,004 GET cGetTexto MEMO SIZE 336,114 OF oDlgEmail PIXEL HSCROLL
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||IIF(Empty(AllTrim(cGetTexto)),,oDlgEmail:End())},037,012,,,,.T.,,"",,,,.F. )

oDlgEmail:Activate(,,,.T.)
Return (cGetTexto)
//================================FIM DA REPROVA��O================================================ 
//================================TEXTO JUSTIFICATIVA =============================================
Static Function sfTexto(cTitulo,cNum,cRev,cMatr,cTexto)
Local cHTML		:=	""
Local nCont		:=	0
Local cLinhaObs	:=	""
cHTML	+='<html >'
cHTML	+='<head>'
cHTML	+='<style type="text/css">'
cHTML	+='<!--'
cHTML	+='.style1 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 24px;'
cHTML	+='}'
cHTML	+='.style2 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 14px;'
cHTML	+='}'
cHTML	+='.style3 {font-family: Arial, Helvetica, sans-serif}'
cHTML	+='.style5 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 12px;'
cHTML	+='}'
cHTML	+='.style8 {font-family: Arial, Helvetica, sans-serif; font-size: 10px; }'
cHTML	+='-->'
cHTML	+='</style></head>'

cHTML	+='<body>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><div align="center"><strong><span class="style1">'+cTitulo+' '+cNum+'-'+cRev+'</span></strong></div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="497"><strong><span class="style2">Justificativa:</span></strong></td>'
cHTML	+='  </tr>'
cHTML	+='  <tr>'
cHTML	+='    <td height="142"><div align="left">'
		For nCont := 1 to MLCount( cTexto , 90 )
			cLinhaObs	:=Memoline( cTexto ,90, nCont )
			cHTML	+='      <p class="style3">'+cLinhaObs+'</p>'	  	       		
		Next nCont 
cHTML	+='      <p class="style3">&nbsp;</p>'
cHTML	+='    </div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="508" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="115" class="style5">Respons�vel</td>'
cHTML	+='    <td width="377"><span class="style5">'+Posicione("QAA",1,xFilial("QAA")+cMatr,"QAA_NOME")+' </span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><span class="style8">Mensagem autom�tica do sistema Protheus. Favor n�o responder</span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='</body>'
cHTML	+='</html>'
Return(cHTML)

//================================FIM DO TEXTO JUSTIFICATIVA =============================================