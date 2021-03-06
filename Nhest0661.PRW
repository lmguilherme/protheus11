/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST066  �Autor  �Marcos R Roquitski  � Data �  18/01/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio de SC x PEDIDO em Aberto.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest066()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SC7"
    oRelato:cPerg    := "EST066"
	oRelato:cNomePrg := "NHEST066"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este relat�rio apresenta a posi��o das solicita��es "
	oRelato:cDesc2   := "de compra, pedidos de compra, pedidos em aberto e "
	oRelato:cDesc3   := "autoriza��o de entrega." 
	
	//tamanho        
	oRelato:cTamanho := "G"  //default "M"

	//titulo
	oRelato:cTitulo  := "POSI��O DE "

	aAdd(aPergs,{"Do  Produto ?"      ,"C",15,0,"G","","","","","","SB1",""})
	aAdd(aPergs,{"Ate Produto ?"      ,"C",15,0,"G","","","","","","SB1",""})
	aAdd(aPergs,{"Do  C.Custo ?"      ,"C", 6,0,"G","","","","","","CTT",""})
	aAdd(aPergs,{"Ate C.Custo ?"      ,"C", 6,0,"G","","","","","","CTT",""})
	aAdd(aPergs,{"Da  Emissao SC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Ate Emissao SC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Da  Emissao PC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Ate Emissao PC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Da  Data Entrega ?" ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Ate Data Entrega ?" ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Ponto de Pedido ?"  ,"N", 1,0,"C","Saldo maior","Saldo menor","Ambos","","","",""})	
	aAdd(aPergs,{"Lista ?"            ,"N", 1,0,"C","SC / PC","AE / PCA","","","","",""})
	aAdd(aPergs,{"Login ?"			  ,"C",14,0,"G","","","","","","QAA",""})
	aAdd(aPergs,{"Do Armaz�m ?"		  ,"C", 2,0,"G","","","","","","",""})
	aAdd(aPergs,{"At� Armaz�m ?"	  ,"C", 2,0,"G","","","","","","",""})


	oRelato:AjustaSx1(aPergs)
	
	//cabecalho      
	oRelato:cCabec1  := ""//Cod.             Descricao                                    Pedido       Qt.Pedido    Dt.Prev.     Codigo      Fornecedor                               SC       Emissao    Qtde na SC.   Estoque    P.Pedido   Seguranca"
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

//���������������������Ŀ
//� FUNCAO DE IMPRESSAO �
//�����������������������
Static Function Imprime()
Local _lOk := .F.               

	If mv_par12==1
		oRelato:cCabec1  := "Cod.             Descricao                                    Pedido       Qt.Pedido    Dt.Prev.     Codigo      Fornecedor                               SC       Emissao    Qtde na SC.   Estoque    P.Pedido   Seguranca"
		Processa( {|| Gera1()   },"Gerando Dados para a Impressao")
	ElseIf mv_par12==2
		oRelato:cCabec1  := "Cod.             Descricao                                    A.E.         Saldo A.E.   Dt.Prev.     Codigo      Fornecedor                               PCA      Emissao     Saldo PCA    Estoque    P.Pedido   Seguranca"
		Processa( {|| Gera2()   },"Gerando Dados para a Impressao")
	EndIf

	ProcRegua(0)

	// imprime cabe�alho
	oRelato:Cabec()

	SB1->(dbSetOrder(1)) // FILIAL + COD
	SZU->(DbSetOrder(2))
	SA2->(DbSetOrder(1))
	DbSelectArea("TMP")
	dbgotop()
   
	While TMP1->(!eof())
    	If Prow() > 60
    		oRelato:Cabec()
    	EndIf

		//FILTRA POR PONTO DE PEDIDO    	
   		If mv_par11<>3 //diferente de ambos
			If SB2->(dbSeek(xFilial("SB2")+TMP1->B1_COD+TMP1->B1_LOCPAD))
			    If mv_par11==1 //saldo maior ou igual ao ponto de pedido
					If (SB2->B2_QATU-SB2->B2_QEMPSA) < TMP1->B1_EMIN
						TMP1->(dbSkip())
						Loop
					EndIf
			    ElseIf mv_par11==2 //saldo menor que o ponto de pedido
				    If (SB2->B2_QATU - SB2->B2_QEMPSA) >= TMP1->B1_EMIN
				    	TMP1->(dbSkip())
				    	Loop
				    EndIf
			    EndIF
			EndIf
		EndIf
    	
		If mv_par12==1 //SC / PC
			If TMP1->C1_PEDIDO <> ' ' .And. TMP1->C1_PEDIDO <> TMP1->C7_NUM  // SC Atendida
				TMP1->(DbSkip())
				Loop
			Endif
		EndIf
	    
		//filtro de Login usu�rio
		If !Empty(mv_par13)
			If mv_par13 <> TMP1->C1_SOLICIT
				TMP1->(DbSkip())
				Loop
			EndIf
		EndIf
		
		//filtro de armaz�m
		If TMP1->C1_LOCAL < mv_par14 .AND. TMP1->C1_LOCAL > mv_par15
			TMP1->(DbSkip())
			Loop
		EndIF	
	
		_lOk := .F. //aprovacao
		SZU->(DbSetOrder(2))
		SZU->(DbSeek(xFilial("SZU")+TMP1->C1_NUM+TMP1->C1_ITEM))
		While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMP1->C1_NUM+TMP1->C1_ITEM .AND. EMPTY(TMP1->C7_FORNECE)
			If SZU->ZU_STATUS == "C"
				_lOk := .T.
				Exit
			Endif
			SZU->(DbSkip())
		Enddo
	
		If _lOk
			DbSelectArea("TMP")
			TMP1->(DbSkip())
			Loop
		Endif

		@ Prow() +1, 001 Psay TMP1->B1_COD
		@ Prow()   , 017 Psay Substr(TMP1->C1_DESCRI,1,41)
		@ Prow()   , 062 Psay TMP1->C7_NUM 
		@ Prow()   , 069 Psay (TMP1->C7_QUANT - TMP1->C7_QUJE)   Picture "@E 999,999,999.99" //saldo pedido, ou saldo ae
		@ Prow()   , 087 Psay TMP1->C7_DATPRF //data prevista
		@ Prow()   , 101 Psay TMP1->C7_FORNECE
		@ Prow()   , 108 Psay TMP1->C7_LOJA
	
		If SA2->(DbSeek(xFilial("SA2")+TMP1->C7_FORNECE+TMP1->C7_LOJA),Found()) 
			@ Prow()   , 113 Psay Substr(SA2->A2_NOME,1,35) //desc fornecedor
		Endif
		@ Prow()   , 153 Psay Iif(Empty(TMP1->C7_NUM),TMP1->C1_NUM,Space(06)) //numero da sc
		@ Prow()   , 162 Psay Iif(Empty(TMP1->C7_NUM),TMP1->C1_EMISSAO,Ctod(Space(08))) //emissao da sc
	
	    
	    If Empty(TMP1->C7_NUM)
	    	If mv_par12==1
		    	@ Prow()   , 173 Psay TMP1->C1_QUANT Picture "@E 9999999.99" //quant sc
		    ElseIf mv_par12==2
		    	@ Prow()   , 173 Psay TMP1->C1_QUANT - TMP1->C1_QUJE Picture "@E 9999999.99" //saldo pca
		    EndIf
	    Endif	
	
		SB2->(dbSeek(xFilial("SB2")+TMP1->B1_COD+TMP1->B1_LOCPAD))
		@ Prow()   , 184 Psay (SB2->B2_QATU - SB2->B2_QEMPSA) Picture "@E 9999999.99" //estoque
	
		@ Prow()   , 196 Psay TMP1->B1_EMIN   Picture "@E 9999999.99"
		@ Prow()   , 208 Psay TMP1->B1_ESTSEG Picture "@E 9999999.99"

		TMP1->(dbSkip())
		
 	EndDo

	TMP1->(DbCloseArea())

Return

//������������������������������Ŀ
//� GERA OS DADOS PARA IMPRESSAO �
//��������������������������������
Static Function Gera1()                       

	ProcRegua(0)
	IncProc()
	
	cQuery := "SELECT B1.B1_COD, C7.C7_NUM, C7.C7_QUANT, C7.C7_QUJE, C7.C7_DATPRF, C7.C7_FORNECE, C7.C7_LOJA, "
	cQuery += " B1.B1_DESC,B1.B1_EMIN, B1.B1_LOCPAD, B1.B1_ESTSEG, 
	cQuery += " C1.C1_NUM, C1.C1_ITEM, C1.C1_EMISSAO, C1.C1_QUANT, C1.C1_DESCRI, C1.C1_PEDIDO"
	cQuery += " FROM "+RetSqlName("SC7")+" C7, "+RetSqlName("SC1")+" C1, "+RetSqlName("SB1")+" B1"
	cQuery += " WHERE C1.C1_NUM  *= C7.C7_NUMSC"
	cQuery += " AND C1.C1_ITEM   *= C7.C7_ITEMSC"
	cQuery += " AND C1.C1_PEDIDO *= C7.C7_NUM"
	cQuery += " AND C1.C1_PRODUTO = B1.B1_COD"
	cQuery += " AND C1.C1_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C1.C1_APROV  <> 'R'"  //nao pega quando estiver rejeitado
	cQuery += " AND C7.C7_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C7.C7_QUANT  <> C7.C7_QUJE"
	cQuery += " AND C7.C7_FILIAL  = '"+xFilial("SC7")+"' AND C7.D_E_L_E_T_ = ''"
	cQuery += " AND C1.C1_FILIAL  = '"+xFilial("SC1")+"' AND C1.D_E_L_E_T_ = ''"
	cQuery += " AND B1.B1_FILIAL  = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = ''"
	cQuery += " AND C1.C1_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND C1.C1_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND C1.C1_EMISSAO BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
	cQuery += " AND C7.C7_EMISSAO BETWEEN '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"'"	
	cQuery += " AND C7.C7_DATPRF  BETWEEN '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"
	
    TCQUERY cQuery NEW ALIAS "TMP1" 

	TcSetField("TMP1","C7_DATPRF" ,"D")  // Muda a data de digita�ao de string para date    
	TcSetField("TMP1","C1_EMISSAO","D")  // Muda a data de digita�ao de string para date    
	TcSetField("TMP1","C7_EMISSAO","D")  // Muda a data de digita�ao de string para date    

    DbSelectArea("TMP1")

Return

//������������������������������Ŀ
//� GERA OS DADOS PARA IMPRESSAO �
//��������������������������������
Static Function Gera2()

	ProcRegua(0)
	IncProc()
	
	cQuery := "SELECT B1.B1_COD, C7.C7_NUM, C7.C7_QUANT, C7.C7_QUJE, C7.C7_DATPRF, C7.C7_FORNECE, C7.C7_LOJA, "
	cQuery += " B1.B1_DESC,B1.B1_EMIN, B1.B1_LOCPAD, B1.B1_ESTSEG, 
	cQuery += " C3.C3_NUM AS C1_NUM, C3.C3_ITEM AS C1_ITEM, C3.C3_EMISSAO AS C1_EMISSAO, "
	cQuery += " C3.C3_QUANT AS C1_QUANT, C3.C3_QUJE AS C1_QUJE, C3.C3_DESCRI AS C1_DESCRI"
	cQuery += " FROM "+RetSqlName("SC7")+" C7, "+RetSqlName("SB1")+" B1,"+RetSqlName("SC3")+" C3"
	cQuery += " WHERE C3.C3_NUM *= C7.C7_NUMSC"
	cQuery += " AND C3.C3_ITEM  *= C7.C7_ITEMSC"
	cQuery += " AND C3.C3_PRODUTO = B1.B1_COD"
	cQuery += " AND C3.C3_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C7.C7_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C7.C7_QUANT  <> C7.C7_QUJE"
	cQuery += " AND C7.C7_TIPO = '2'"
	cQuery += " AND C7.C7_FILIAL  = '"+xFilial("SC7")+"' AND C7.D_E_L_E_T_ = ''"
	cQuery += " AND C3.C3_FILIAL  = '"+xFilial("SC3")+"' AND C3.D_E_L_E_T_ = ''"
	cQuery += " AND B1.B1_FILIAL  = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = ''"
	cQuery += " AND C3.C3_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND C7.C7_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND C7.C7_EMISSAO BETWEEN '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"'"	
	cQuery += " AND C7.C7_DATPRF  BETWEEN '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"
	
    TCQUERY cQuery NEW ALIAS "TMP1" 

//	MemoWrit('C:\TEMP\EST066.SQL',cQuery)        

	TcSetField("TMP1","C7_DATPRF" ,"D")  // Muda a data de digita�ao de string para date    
	TcSetField("TMP1","C7_EMISSAO","D")  // Muda a data de digita�ao de string para date    

    DbSelectArea("TMP1")

Return