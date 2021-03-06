/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA105MNU �Autor  �Jo�o Felipe da Rosa � Data �  02/08/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � LOCALIZA��O : Function MatA105()                           ���
���          � utilizado para inserir novas opcoes no array aRotina       ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
  

/* 
	Altera��o:
	Foi alterado o layout do comprovante para ser impresso na impressora de modelo Bematech MP 4200 TH .
*/
User Function MTA105MNU()

	aRotina[6] := {"Imprimir","U_M105IMP2()",0,2,0,nil}

Return

User Function M105IMP2()
Private oFnt1   := TFont():New("Arial"		,,08,,.F.,,,,,.F.)
Private oFnt2   := TFont():New("Arial"		,,11,,.T.,,,,,.F.) 
Private oFnt3   := TFont():New("Arial"		,,09,,.T.,,,,,.F.) 
Private oFnt4   := TFont():New("Arial"		,,13,,.T.,,,,,.F.) 
Private cNum    := SCP->CP_NUM
Private oPrn 	  := tMSPrinter():New("Protheus")
Private nAlt  := 20
Private nLar  := 5

	If !UPPER(FunName()) $ "MATA105" .or. !MsgYesNo("Possui impressora t�rmica ? ")
		U_M105IMPAN()
		return
	EndIf

oPrn:Setup()
oPrn:StartPage()
Cabecalho()
SB1->(DbSetOrder(1) )

While SCP->(!Eof() ) .and. SCP->CP_NUM == cNum

	aSaldo := CalcEst(SCP->CP_PRODUTO,SCP->CP_LOCAL,date()+1)
    SB1->(DbSeek(xFilial("SB1") + SCP->CP_PRODUTO )) 

	oPrn:Say(nAlt + 400,nLar,Alltrim(SCP->CP_PRODUTO),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 250,Alltrim(Substr(SCP->CP_DESCRI,1,10)),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 490,alltrim(Str(SCP->CP_QUANT)),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 610,alltrim(str(aSaldo[1]-SCP->CP_QUANT)),oFnt1)
	oPrn:Say(nAlt + 400,nLar + 730,Alltrim(SB1->B1_LOCAFIS),oFnt1)
	
	// Adicionado em 11/03/14
	oPrn:Say(nAlt + 435,nLar,Alltrim(SCP->CP_CC),oFnt1)

	SCP->(DbSkip() )
	//nAlt += 50
	nAlt += 100
EndDo

RodapeMTA()

oPrn:EndPage()
oPrn:End()
oPrn:Print()
Return(.T.)

Static Function Cabecalho()
Private _cLocaliz := ""
oPrn:Say(nAlt,nLar - 10,"WHB COMPONENTES AUTOMOTIVOS",oFnt4)
oPrn:Say(nAlt + 40,nLar,"Requisi��o ao almoxarifado: Comprovante ", oFnt2)
oPrn:Say(nAlt + 70,nLar,"------------------------------------------------------------------------------------------",oFnt3)
	
SB1->(DbSetOrder(1) )
SB1->(DbSeek(xFilial("SB1") + Alltrim(SCP->CP_PRODUTO) ))

oPrn:Say(nAlt + 105,nLar,"Documento:",oFnt1)
oPrn:Say(nAlt + 100,nLar + 200,Alltrim(SCP->CP_NUM),oFnt2)

oPrn:Say(nAlt + 118,nLar + 460,"Local: " ,oFnt1)
oPrn:Say(nAlt + 105,nLar + 550,SCP->CP_LOCAL,oFnt2)

oPrn:Say(nAlt + 165,nLar,"Emiss�o:",oFnt1)
oPrn:Say(nAlt + 160,nLar + 200,DTOC(SCP->CP_EMISSAO),oFnt2)

oPrn:Say(nAlt + 225,nLar,"Solicitante:",oFnt1)
oPrn:Say(nAlt + 220,nLar + 200,Alltrim(SCP->CP_SOLICIT),oFnt2)

oPrn:Say(nAlt + 270,nLar,"------------------------------------------------------------------------------------------",oFnt3)

oPrn:Say(nAlt + 300,nLar,"C�d.",oFnt3)
oPrn:Say(nAlt + 300,nLar + 250,"Descri��o",oFnt3)
oPrn:Say(nAlt + 300,nLar + 490,"Sol",oFnt3)
oPrn:Say(nAlt + 300,nLar + 610,"Sld.",oFnt3)
oPrn:Say(nAlt + 300,nLar + 720,"End.",oFnt3)

oPrn:Say(nAlt + 330,nLar,"------------------------------------------------------------------------------------------",oFnt3)
Return

Static Function RodapeMTA()
_cEmpr := "Empresa:" + Alltrim(SM0->M0_NOME) + "/Filial:" + Alltrim(SM0->M0_FILIAL)

oPrn:Say(nAlt + 460,nLar ,"------------------------------------------------------------------------------------------",oFnt3)
oPrn:Say(nAlt + 510,nLar,_cEmpr,oFnt3)
oPrn:Say(nAlt + 570,nLar + 100,"Recebi os itens acima em perfeito ",oFnt3)
oPrn:Say(nAlt + 640,nLar + 100,"estado e nas quantidades indicadas. ",oFnt3)
oPrn:Say(nAlt + 760,nLar,"Recebido por:_____________________________",oFnt3)
oPrn:Say(nAlt + 840,nLar,"Ass:_____________________________",oFnt3)
oPrn:Say(nAlt + 900,nLar + 120,"Data de Impress�o: " + DTOC(Date() ) + "  "  + time() ,oFnt3)
oPrn:Say(nAlt + 980,nLar,"------------------------------------------------------------------------------------------",oFnt3)

Return

// ROTINAS ANTIGAS //////////////

User Function M105IMPAN()

//������������������������������������������������������������������������Ŀ
//�Define Variaveis                                                        �
//��������������������������������������������������������������������������
Local Titulo  := "Posicao das Solicitacoes ao Almox."  // Titulo do Relatorio
Local cDesc1  := "  Este relatorio lista a posicao das SA's de acordo com os para-"  // Descricao 1
Local cDesc2  := "metros selecionados."  // Descricao 2
Local cDesc3  := ""  // Descricao 3
Local cString := "SCP"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .T. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T. // Habilita/Desabilita o Filtro
Local wnrel   := "MATR105"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "MATR105"  // nome do programa

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
//Private cPerg   := "MTR105"  // Pergunta do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //###
//[1] Reservado para Formulario
//[2] Reservado para N� de Vias
//[3] Destinatario
//[4] Formato => 1-Comprimido 2-Normal
//[5] Midia   => 1-Disco 2-Impressora
//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
//[7] Expressao do Filtro
//[8] Ordem a ser selecionada
//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//������������������������������������������������������������������������Ŀ
//�Envia para a SetPrinter                                                 �
//��������������������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,'',@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| A105ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

dbSelectArea(cString)
dbClearFilter()
dbSetOrder(1)
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �A105ImpDet� Autor �  Edson Maricate       � Data �02.12.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime a linha detalhe do Relatorio.                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Matr105                                                    ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function A105ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local li      := 100 // Contador de Linhas
Local lImp    := .F. // Indica se algo foi impresso
Local cbCont  := 0   // Numero de Registros Processados
Local aRetCQ
Local cbText  := ""  // Mensagem do Rodape
Local cNum    := SCP->CP_NUM
Local cCabec1 := "Numero  Item  Codigo             Descricao                          Localiz          Emissao            Quantidade              Saldo        Qtd.Entregue           Requisicao         Centro de Custo      Solicitante"
Local cCabec2:=  ""      
//                123456   12   123456789012345    123456789012345678901234567890                    99/99/9999         9.999.999,99     999.999.999,99      999.999.999,99            123456789            901234567890       1234567890
//                0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                                                                                                                                                                       
dbSelectArea(cString)
SetRegua(0)
dbSetOrder(1)
dbSeek(xFilial("SCP")+SCP->CP_NUM)

While !Eof() .And. xFilial()==SCP->CP_FILIAL .And. SCP->CP_NUM == cNum
	lImp := .T.

	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit	
	EndIf

	If ( li > 60 )
		li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,If(aReturn[4]==1,15,18))
		li++
	Endif

	aRetCQ := ca100RetCQ(SCP->CP_NUM,SCP->CP_ITEM)
	@ li,000 PSay SCP->CP_NUM
	@ li,009 PSay SCP->CP_ITEM
	@ li,014 PSay SCP->CP_PRODUTO
	@ li,033 PSay Pad(SCP->CP_DESCRI, 30)
	@ li,068 PSay SCP->CP_LOCALIZ
	@ li,085 PSay SCP->CP_EMISSAO
	@ li,102 PSay SCP->CP_QUANT	Picture PesqPict("SCP","CP_QUANT")
	@ li,121 PSay aRetCQ[1]		Picture PesqPict("SCP","CP_QUANT")
	@ li,141 PSay aRetCQ[7] 	Picture PesqPict("SCP","CP_QUANT")
	@ li,If(cPaisLoc$"BRA",165,146) PSay aRetCQ[6]
	@ li,178 PSay Padl(Alltrim(SCP->CP_CC),20)
	@ li,204 PSay SCP->CP_SOLICIT
	
	li++
	dbSelectArea(cString)
	dbSkip()
	cbCont++
	IncRegua()
EndDo

If ( lImp )
	Roda(cbCont,cbText,Tamanho)
EndIf
	
Return(.T.)