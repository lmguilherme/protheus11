#include 'fivewin.ch'
#include 'topconn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST117  �Autor �Alexandre R. Bento  � Data �  28/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � relatorio de utiliza�ao de ferramentas         			  ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque Custos/preset                                      ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST117()   

SetPrvt("_aGrupo,_cCodUsr,aCols")

cString   := "SB1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo o Mostrar a  ")
cDesc2    := OemToAnsi("Utiliza��o de Ferramentas")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST117"
nLastKey  := 0
titulo    := OemToAnsi("CONTROLE DE UTILIZA��O DE FERRAMENTAS ")                
cabec1    := " Codigo           Descricao                            Utiliza��o1      Utiliza��o2        Utiliza��o3"
cabec2    := "Do Codigo : " + mv_par01 + " ate " + mv_par01
cCancel   := "***** CANCELADO PELO OPERADOR *****"     
nTipo    := 1
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST117"
_cPerg    := "EST117" 


Pergunte(_cPerg,.T.) 
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))  
aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2] 
cFilterUser := aReturn[7]


cabec2    := "Do Codigo : "  + mv_par01 + " a " + mv_par02
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.t.,'P')

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif


Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

//TR3->(DbCloseArea()) 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()

		cQuery := " SELECT B1_COD,B1_DESC,B1_UTILIZ1,B1_UTILIZ2,B1_UTILIZ3"
		cQuery += " FROM " + RetSqlName('SB1') + " B1"
		cQuery += " WHERE B1.B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
  		cQuery += " AND B1.D_E_L_E_T_ = ''"
//MemoWrit('C:\TEMP\NHEST117.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'
		If	!USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
Return

Static Function RptDetail()  
Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    
DbSelectArea('TRA1')
While TRA1->( ! Eof() )
 	@ Prow()+1 , 001 Psay TRA1->B1_COD
 	@ Prow()   , 017 Psay TRA1->B1_DESC
 	@ Prow()   , 055 Psay TRA1->B1_UTILIZ1
 	@ Prow()   , 072 Psay TRA1->B1_UTILIZ2 	
 	@ Prow()   , 090 Psay TRA1->B1_UTILIZ3
 	 	
    TRA1->(DbSkip())
    
    if Prow() > 70                                                                   
	    Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    
	endif
end
@ Prow()+1,000 PSAY __PrtThinLine() 
Return(nil)