#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOUGLAS   �Autor �DOUGLAS DOURADO � Data �  13/06/12       ���
�������������������������������������������������������������������������͹��
���Desc.     � RELAT�RIO STATUS DE SC'S           			              ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST201()

cString   := "STJ"
cDesc1    := "Este   relatorio   tem   como   objetivo  mostrar o status"
cDesc2    := "de solicita��es de compra."
cDesc3    := ""
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST201"
nLastKey  := 0
titulo    := "STATUS  DE  SOLICITA��O  DE  COMPRA  -  "// T�tulo do relat�rio
cabec1    := " SC         Item      Produto             Descri��o                               Quant     C.Custo     Grupo     Emiss�o      Aprovador     Status     Data Aprova��o" 
cabec2    := ""
cabec3    := "" 
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST201"  
_cPerg	  := "EST201"  


//--------------------------------------------------------------
// PERGUNTAS
//-------------------------------------------------------------- 
// mv_par01 "DE SC"
// mv_par02 "ATE SC"
// mv_par03 "DE PRODUTO"
// mv_par04 "ATE PRODUTO"
// mv_par05 "DE GRUPO"
// mv_par06 "ATE GRUPO" 
// mv_par07 "MOSTRAR SOMENTE SC:"  1 = PENDENTE  2 = APROVADA 3 = AMBOS
// mv_par08 "DE ARMAZEM"  -- OBS: Pergunta adicionada em 27/06/2012, a pedido do Luis Claras
// mv_par09 "ATE ARMAZEM" -- OBS: Pergunta adicionada em 27/06/2012, a pedido do Luis Claras
//--------------------------------------------------------------

Pergunte("EST201",.T.) // <-- Chama a fun��o respons�vel pela inicializa��o das "perguntas" do relat�rio, valor em "TRUE" for�a o usu�rio a entrar com os par�metros primeiro. 

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

//-- PROGRAMACAO

Processa( {|| Gerando()   },"Gerando Dados do Relat�rio...") 
Processa( {|| RptDetail()   },"Gerando Relat�rio...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando() // FUN��O RESPONSAVEL POR GERAR A QUERY
Local cQuery 

ProcRegua(2)

IncProc()    
    

    //------------------
    // MONTA A QUERY
    //------------------               
    
    cQuery := " SELECT C1_NUM, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_CC, B1_GRUPO, C1_EMISSAO, "   // RETIRAR O TOP 15 QUANDO FOR COMPILAR
    cQuery += " ZU_LOGIN, ZU_NIVEL , ZU_STATUS, ZU_DATAPR " 
    cQuery += " FROM " + RetSqlName("SC1") + " C1, " + RetSqlName("SB1") + " B1, " + RetSqlName("SZU") + " ZU "    
    cQuery += " WHERE C1_PRODUTO = B1_COD "
    cQuery += " AND C1_NUM = ZU_NUM "
    cQuery += " AND C1_ITEM = ZU_ITEM "    
    cQuery += " AND C1.C1_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA AS SC
    cQuery += " AND C1.C1_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA OS PRODUTOS
    cQuery += " AND B1.B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA OS GRUPOS 
    cQuery += " AND C1.C1_LOCAL BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA OS ARMAZENS (ADICIONADO EM 27/06/12)   
    cQuery += " AND C1.D_E_L_E_T_ = '' AND C1_FILIAL = '" +xFilial("SC1") + "' "
    cQuery += " AND ZU.D_E_L_E_T_ = '' AND ZU_FILIAL = '" +xFilial("SZU") + "' "
    cQuery += " AND ZU_ORIGEM = 'SC1' "
    cQuery += " AND C1_RESIDUO <> 'S' "
    cQuery += " AND ZU_STATUS <> 'C' " // Nao traz SC's Canceladas        
          
   
   // Mostrar Somente SC: ---------------------------------------
   DO CASE    
  
     CASE mv_par07 == 1
       cQuery += " AND ZU_STATUS = '' "
	 CASE mv_par07 == 2
 	   cQuery += " AND ZU_STATUS = 'A' " 
 	   	   
   ENDCASE
  //-------------------------------------------------------------
  
   cQuery += " ORDER BY C1_NUM, C1_ITEM, ZU_NIVEL "
        
   	//MemoWrit('C:\TEMP\NHEST201.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"  // Criando o ALIAS
	
	TRA1->(DbGoTop())    
	
	TcSetField("TRA1","ZU_DATAPR","D")  // Muda a data de string para date
	TcSetField("TRA1","C1_EMISSAO","D")  // Muda a data de string para date 
	
	IncProc()

Return

// MONTA O RELAT�RIO (F�SICO) ----------------------------------

Static Function RptDetail()  

Local _dData //Variavel que recebe a data que vai junto do T�tulo
Local _nSC 
Local _nItem 

ProcRegua(0)

_dData := Date()
                                         
Titulo += DtoC(_dData) // Coloca a data atual no t�tulo do relat�rio 

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) //Monta o Cabe�alho do Relat�rio 

//Escrevendo os dados no relat�rio -------------------------------------
While TRA1->(!Eof())
	

	If Prow() > 75  // Limite de linhas por p�gina
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) // <--  Se for maior que o limite, escreve um cabe�alho
	Endif  
	
    // Verifica se o item da SC contem mais de um aprovador -----
	
	If (_nSC == TRA1->C1_NUM .And. _nItem == TRA1->C1_ITEM)  
		@Prow()+1, 127 psay TRA1->ZU_LOGIN 
		@Prow()  , 145 psay TRA1->ZU_STATUS
		@Prow()  , 153 psay TRA1->ZU_DATAPR
	Else  
		@Prow()+1, 001 psay ''
		@Prow()+1, 001 psay TRA1->C1_NUM  // SC
		@Prow()  , 012 psay TRA1->C1_ITEM  
		@Prow()  , 022 psay TRA1->C1_PRODUTO
		@Prow()  , 042 psay TRA1->C1_DESCRI
		@Prow()  , 076 psay TRA1->C1_QUANT picture("@e 9,999,999.99")
		@Prow()  , 093 psay TRA1->C1_CC
		@Prow()  , 105 psay TRA1->B1_GRUPO
		@Prow()  , 114 psay TRA1->C1_EMISSAO
		@Prow()  , 128 psay TRA1->ZU_LOGIN	
		@Prow()  , 145 psay TRA1->ZU_STATUS
		@Prow()  , 153 psay TRA1->ZU_DATAPR		
	EndIf
	//----------------------------------------------------------  	
		
	_nSC := TRA1->C1_NUM
	_nItem := TRA1->C1_ITEM	
	
	TRA1->(DbSkip()) 	
	   	
EndDo
//------------------------------------------------------------------------

@Prow()+1, 000 PSAY __PrtThinLine() //  <--  Escreve uma linha fina na tela

					
TRA1->(DbCloseArea()) // Encerrando a ALIAS "TRA1" 
  

Return(nil)