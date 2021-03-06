/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �NHFAT004  � Autor � Jose Roberto Gorski     � Data � 08/08/00 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Conferencia das Contas Contabeis das NF's de Ent���
���������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
���Arquivos  � SX1 - SA1 - SA2 - SD1 - SE2 - SF3 - CT1                      ���
���Utilizados�                                                              ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
���Alterado  �Alexandre R. Bento 22/09/06                                   ���
���          �Alexandre R. Bento 11/10/06                                   ���
�������������������������������������������������������������������������������
/*/


#include "rwmake.ch"       

User Function Nhfat004()   

SetPrvt("CBTXT,CBCONT,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,LCONTINUA,NLASTKEY,NCONTA,NVALOR")
SetPrvt("NIPI,NICM,FINANC,FISCAL,TAMANHO,CPERG")
SetPrvt("WNREL,LI,M_PAG,PASSOU,CSTRING,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,ACONTA,NOME,LOJA,CLIENTE")
SetPrvt("NF,SERIE,DATA,NLINHA,_CDOC,_NREG")
SetPrvt("CODCONTA,IPI,ICM,VALOR,TOTAL,I,_cCGC,_cSped")
SetPrvt("CONTARED,J,")
SetPrvt("_nValc,_nBaseic,_nValic,_nIsenIc,_nOutric,_nBaseIp,_nValip,_nIsenIP,_nOutrIp")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,nTipo,nLimite,_nCont,_cNota")

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Data                              �
//� mv_par02             // Ate a Data                           �
//����������������������������������������������������������������     
_cNota   :=" "
_nCont   :=0
_nValc   :=0
_nBaseic :=0
_nValic  :=0
_nIsenIc :=0
_nOutric :=0
_nBaseIp :=0
_nValip  :=0
_nIsenIP :=0
_nOutrIp :=0
cbtxt    := " "
cbcont   := 0
titulo   :=PADC("Conferencia de Contas - Entrada",74)
cDesc1   :=PADC("Emissao do Relatorio de Conferencia das Contas Contabeis das NF's",74)
cDesc2   :=PADC("de Entrada de acordo com a configuracao do usuario.",74)
cDesc3   := ""
aReturn  :={ "Especial", 1,"Administracao", 1, 2, 1, " ", 1}
nomeprog :="NHFAT004"
lContinua:= .T.
nLastkey := 0
nConta   := 1
nValor   := 2
nIPI     := 3
nICM     := 4
FINANC   := .F.
FISCAL   := .F.
Tamanho  := "G"


CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="M"
limite :=132
cRodaTxt := ""
cString  := "SF3"
nTipo    := 0
nPag     := 1


  
//���������������������������������������������������������������������������͸
//�   Salva a Integridade dos dados de Entrada                                �
//���������������������������������������������������������������������������;
  
cPerg    := "FAT004"
wnrel    := "FAT004"    // NOME DEFAULT DO RELATORIO EM DISCO
li       := 80
m_pag    := 1
passou   := 1

  
Pergunte(cPerg,.F.)
  
cString  := "SD1"
 
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+      AJUSTE DOS PARAMETROS DA IMPRESSAO VIA FUNCAO SETPRINT              +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
 
If nLastkey == 27
   Return
EndIf

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+           ACEITA PARAMETROS E FAZ AJUSTES NECESSARIOS                    +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SetDefault(aReturn,cString)

If nLastKey == 27
   Return
EndIf

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+             VARIAVEIS UTILIZADAS NA BARRA DE STATUS                      +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

RptStatus({||RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> RptStatus({||Execute(RptDetail)})
Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Jose Roberto Gorski     � Data � 08/08/00 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Corpo do Relatorio                                           ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
���Arquivos  � SX1 - SA1 - SA2 - SD1 - SE2 - SF3 - CT1                      ���
���Utilizados�                                                              ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
   

Static Function RptDetail()

SA1->(DbSetOrder(1))  // Codigo
SA2->(DbSetOrder(1))  // Codigo
SD1->(DbSetOrder(13))  // Data Digitacao + Documento
SE2->(DbSetOrder(6))
SF3->(DbSetOrder(4))  // Codigo
SF4->(DbSetOrder(1))  // filial + TES
CT1->(DbSetOrder(1))  // Plano de Contas
SD1->(DbGoTop())

//@ 01,00 Psay &cCompac // +Repli("*",132)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
SD1->(DbSeeK(xFilial("SD1")+DTOS(mv_par01),.t.))

WHILE !SD1->(EOF()) .AND. DtoS(SD1->D1_DTDIGIT) <= DtoS(mv_par02) .And. lContinua

  If SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA <> _cNota
     _cNota := SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
     _nCont += 1   // controle de numero de notas
  Endif 
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   //+              VERIFICA SE HOUVE INTERRUPCAO PELO OPERADOR             +
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    /*/
      IF lAbortPrint
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      ENDIF
    /*/
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   //+                        IMPRESSAO DOS DADOS                           +
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   
   aConta:={}
  
   IF li > 52
     Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
///      @  002,001 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------"
//      @  003,001 PSAY "                                             CONFERENCIA DAS CONTAS"
//      @  003,080 PSAY "Data : "+DTOC(Date())
//      @  004,001 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------"
      li := 6
   ENDIF
   
   IF SD1->D1_TIPO != "B"
      SA2->(DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
      NOME  := SubStr(SA2->A2_NREDUZ,1,20)
      LOJA  := SA2->A2_LOJA
      _cCGC := SA2->A2_CGC     
      _cSped:= SA2->A2_EMITNFE      
   ELSE
      SA1->(DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
      NOME  := SA1->A1_NREDUZ
      LOJA  := SA1->A1_LOJA
      _cCGC := SA1->A1_CGC      
      _cSped:= SA1->A1_EMITNFE
   ENDIF   
   FINANC := SE2->(DbSeek(xFilial("SE2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC))
   FISCAL := SF3->(DbSeek(xFilial("SF3")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC+SD1->D1_SERIE))
   @ li,002 PSAY "Data : "+DTOC(SD1->D1_DTDIGIT)
   @ li,020 PSAY "Nota : "+SD1->D1_DOC
   @ li,037 PSAY "Serie : "+SD1->D1_SERIE
   @ li,050 PSAY "Fornecedor : "+NOME
   @ li,088 PSAY "CGC : "+_cCGC
   @ li,110 PSAY "CFO : "+SD1->D1_CF
   SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
   @ li,122 PSAY "Gera:" + SF4->F4_CONTAB
   @ li,135 PSAY "Sped:" + _cSped
   
   li := li + 1
   CLIENTE := SD1->D1_FORNECE
   LOJA    := SD1->D1_LOJA
   NF      := SD1->D1_DOC
   SERIE   := SD1->D1_SERIE
   DATA    := SD1->D1_DTDIGIT
   WHILE !SD1->(EOF()) .AND. SD1->D1_FORNECE == CLIENTE .AND. SD1->D1_LOJA == LOJA .AND. SD1->D1_DTDIGIT == DATA .AND. SD1->D1_DOC == NF .AND. SERIE == SD1->D1_SERIE
      
      @ li,002 PSAY SD1->D1_COD
      @ li,018 PSAY SubStr(SD1->D1_DESCRI,1,15)
      @ li,038 PSAY SD1->D1_TES
      IF CT1->(DbSeek(xFilial("CT1")+SD1->D1_CONTA))
          @ li,044 PSAY CT1->CT1_CONTA  //SI1->I1_RES
      ELSE
          @ li,044 PSAY SD1->D1_CONTA
      ENDIF
      nLinha := aScan(aConta,{|aLinha|aLinha[nConta]==SD1->D1_CONTA})
      IF nLinha==0
         aAdd(aConta,{SD1->D1_CONTA, 0, 0, 0})
         nLinha := Len(aConta)
      ENDIF   
      aConta[nLinha][nValor] := aConta[nLinha][nValor] + SD1->D1_TOTAL
      aConta[nLinha][nIPI]   := aConta[nLinha][nIPI] + SD1->D1_VALIPI
      aConta[nLinha][nICM]   := aConta[nLinha][nICM] + SD1->D1_VALICM
      @ li,058 PSAY SD1->D1_CC
      @ li,065 PSAY SD1->D1_TOTAL PICTURE "@E 999,999,999.99"
      IF SD1->D1_VALICM != 0
         @ li,080 PSAY SD1->D1_VALICM PICTURE "@E 999,999,999.99"
      ENDIF
      IF SD1->D1_VALIPI != 0
         @ li,100 PSAY SD1->D1_VALIPI PICTURE "@E 99,999.99"
      ENDIF   
      @ li, 120 PSAY SD1->D1_QUANT PICTURE "@E 99,999.99"
      li := li + 1
      // _cDoc   := SD1->D1_DOC   
      _nReg := SD1->(Recno())
      SD1->(DbSkip())
   END
   IF SD1->(EOF())
      // SD1->(DbSeek(xFilial("SD1")+DTOS(DATA)+_cDoc))
      SD1->(DbGoTo(_nReg))
   ENDIF
   IF !SD1->(EOF())
      CLIENTE := SD1->D1_FORNECE
      LOJA    := SD1->D1_LOJA
      // SD1->(DbSeek(xFilial("SD1")+DTOS(DATA)+_cDoc))
      SD1->(DbGoTo(_nReg))
      IF SD1->D1_TIPO != "B"
         CODCONTA := SA2->A2_CONTA+SA2->A2_COD
      ELSE   
         CODCONTA := SD1->D1_FORNECE
      ENDIF   
      IPI := ICM := VALOR := TOTAL := 0
      @ li,002 PSAY "Debito : "
      FOR I := 1 TO Len(aConta)
         IPI   := IPI + aConta[I][nIPI]
         ICM   := ICM + aConta[I][nICM]
         CONTARED := aConta[I][nConta]
         VALOR := aConta[I][nValor] - aConta[I][nICM]
         CT1->(DbSeek(xFilial("CT1")+CONTARED))
         @ li,015 PSAY CT1->CT1_RES
         @ li,029 PSAY VALOR PICTURE "@E 999,999,999.99"
         IF I == 1
            @ li,045 PSAY "Credito : "
            @ li,059 PSAY CODCONTA
            FOR J := 1 TO Len(aConta)
               TOTAL := TOTAL + aConta[J][nValor]
            NEXT
            @ li,090 PSAY TOTAL PICTURE "@E 999,999,999.99"
         ENDIF
         li := li + 1
      NEXT
      IF IPI != 0
      
         // Colocar a Conta Correta para IPI
         @ li,015 PSAY "0T10"
         @ li,025 PSAY IPI PICTURE "@E 999,999,999.99"
         li := li + 1
      ENDIF
      IF ICM != 0
         // Colocar a Conta correta para ICM
         @ li,015 PSAY "0T8"
         @ li,025 PSAY ICM PICTURE "@E 999,999,999.99"
         
      ENDIF
      li := li + 1
      VALOR := TOTAL - ICM
//******************************************
      SF1->(DbSetOrder(1))                                      
      SF1->(DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
      
    //li := li + 1
      @  li,002 PSAY "Vlr.IRRF:" 
      @  li,011 PSAY Transform(SF1->F1_IRRF, "@E 999,999.99")
      @  li,023 PSAY "Vlr.ISS:"
      @  li,034 PSAY Transform(SF1->F1_ISS, "@E 999,999.99")            
      @  li,046 PSAY "Vlr.INSS:" 
      @  li,056 PSAY Transform(SF1->F1_INSS, "@E 999,999.99")      
      @  li,070 PSAY "Vlr.PIS :"
      @  li,080 PSAY Transform(SF1->F1_VALPIS,"@E 999,999.99")            
      @  li,092 PSAY "Vlr.CSLL:" 
      @  li,102 PSAY Transform(SF1->F1_VALCSLL,"@E 999,999.99")            
      @  li,114 PSAY "Vlr.COFINS:"
      @  li,125 PSAY Transform(SF1->F1_VALCOFI,"@E 999,999.99")                  
      li := li + 1

//******************************************
     IF li > 52
        Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
        li := 6
     ENDIF

      
      IF FINANC
         li := li + 1
         @  li,002 PSAY "FINANCEIRO"
         li := li + 1
         @  li,002 PSAY " NUMERO  PREFIXO  PARCELA  VENCIMENTO REAL          VALOR          NATUREZA"
         li := li + 1
         WHILE !SE2->(EOF()) .AND. SE2->E2_NUM == SD1->D1_DOC .AND. SE2->E2_PREFIXO == SD1->D1_SERIE .AND. SE2->E2_FORNECE == SD1->D1_FORNECE .AND. SE2->E2_LOJA == SD1->D1_LOJA
            @  li,004 PSAY SE2->E2_NUM
            @  li,013 PSAY SE2->E2_PREFIXO
            @  li,023 PSAY SE2->E2_PARCELA
            @  li,033 PSAY SE2->E2_VENCREA
            @  li,045 PSAY SE2->E2_VALOR PICTURE "@E 999,999,999.99"
            @  li,069 PSAY SE2->E2_NATUREZ
            li := li + 1
            SE2->(DbSkip())
         END      
      ENDIF
      IF FISCAL
         _nValc   :=0
		 _nBaseic :=0
	     _nValic  :=0
		 _nIsenIc :=0
	     _nOutric :=0
		 _nBaseIp :=0
		 _nValip  :=0
		 _nIsenIP :=0
		 _nOutrIp :=0

         While !SF3->(EOF()) .AND. SF3->F3_NFISCAL == SD1->D1_DOC .AND. SF3->F3_SERIE == SD1->D1_SERIE .AND. SF3->F3_CLIEFOR == SD1->D1_FORNECE .AND. SF3->F3_LOJA == SD1->D1_LOJA

            _nValc   += SF3->F3_VALCONT 
            _nBaseic += SF3->F3_BASEICM 
            _nValic  += SF3->F3_VALICM 
            _nIsenIc += SF3->F3_ISENICM 
            _nOutric += SF3->F3_OUTRICM 
            _nBaseIp += SF3->F3_BASEIPI 
            _nValip  += SF3->F3_VALIPI 
            _nIsenIP += SF3->F3_ISENIPI
            _nOutrIp += SF3->F3_OUTRIPI 
            SF3->(DbSkip())
         ENDDO 
            li := li + 1
            @  li,002 PSAY "FISCAL"
            li := li + 1
            @  li,002 PSAY " VALOR CONTABIL : "
            @  li,023 PSAY _nValc PICTURE "@E 999,999,999.99"
            li := li + 1
            @  li,002 PSAY " BASE DO ICM     VALOR ICM       ISENTAS         OUTRAS  "
            li := li + 1
            @  li,001 PSAY _nBaseic PICTURE "@E 999,999,999.99"
            @  li,015 PSAY _nValic PICTURE "@E 999,999,999.99"
            @  li,030 PSAY _nIsenIc PICTURE "@E 999,999,999.99"
            @  li,046 PSAY _nOutric PICTURE "@E 999,999,999.99"
            li := li + 1
            @  li,002 PSAY " BASE DO IPI     VALOR IPI       ISENTAS         OUTRAS  "
            li := li + 1
            @  li,001 PSAY _nBaseIp PICTURE "@E 999,999,999.99"
            @  li,015 PSAY _nValip PICTURE "@E 999,999,999.99"
            @  li,030 PSAY _nIsenIP PICTURE "@E 999,999,999.99"
            @  li,046 PSAY _nOutrIp PICTURE "@E 999,999,999.99"
            li := li + 1
      ENDIF
     @ Prow() + 1, 001 Psay __PrtThinLine() 
//      @  li,001 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------"
      li := li + 1
      SD1->(DbSkip())
    //li := li + 1
   ENDIF
END                                         
If _nCont > 0
   @ Prow() + 1, 001 Psay " Total de Notas Impressas : " + Transform(_nCont,"@E 999999")
   @ Prow() + 1, 001 Psay __PrtThinLine()    
Endif   



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+                        RESTAURA TELAS E SET'S                            +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Set Device To Screen
     
If aReturn[5]==1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
EndIf

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+                  LIBERA RELATORIO PARA SPOOL DA REDE                     +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

MS_FLUSH()

Return