/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFIN015 � Autor � Jose Roberto Gorski   � Data � 11/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Geracao de Titulos a Pagar e a Receber                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para New Hubner                                 ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ4,SE2,SE1                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function Nhfin015()

SetPrvt("_LFLAG,CCUSTO,")

Processa( {|| libera() } )

Return

Static Function Libera()

If !MsgBox ("Tem certeza que deseja gerar os titulos para os adiantamentos de viagem selecionados","Escolha","YESNO")
   Return
Endif

ProcRegua(SZ4->(RecCount()))

SZ4->(DbGoTop())
_lFlag := .f.
While SZ4->(!Eof())
	// Condicao para tratamento dos registros marcados
	If Marked("Z4_OK") .And. Empty(SZ4->Z4_CPCR)
		// Marca os Registros apontados
		_lFlag := .t.
	Else
		_lFlag := .f.
	Endif
	// Se Passou pelo Marked processa
	If _lFlag
		// Gerar Contas a Pagar
		Grava_Dados()// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>                     Execute(Grava_Dados)
	Endif

	DbSelectArea("SZ4")
	IncProc()
   SZ4->(DbSkip())
EndDo

SZ4->(DbGoTop())
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Grava_Dados Autor � Jose Roberto Gorski   � Data � 05/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Grava os Dados Preenchidos (SZ4,SE1,SE2)                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Grava_Dados
Static Function Grava_Dados()

// Gerar o Contas a pagar ou a receber dependendo do valor da final

SZ3->(DbSeek(xFilial("SZ3")+SZ4->Z4_NUM))

If SZ4->Z4_REMB > 0 // Gerar Contas a Pagar
   RecLock("SE2",.t.)
     SE2->E2_FILIAL  := xFilial("SE2")
     SE2->E2_PREFIXO := "REE"
     SE2->E2_NUM     := SZ4->Z4_NUM
     SE2->E2_PARCELA := "A"
     SE2->E2_TIPO    := "VL"                                            
     SE2->E2_NATUREZ := SZ3->Z3_NATUREZ
	   SE2->E2_MATR    := SZ3->Z3_MATR
     SE2->E2_FORNECE := "999999"
     SE2->E2_LOJA    := "01"
     SE2->E2_NOMFOR  := "ADIANTAMENTO DE VIAGEM"
     SE2->E2_EMISSAO := dDataBase
     SE2->E2_VENCTO  := dDataBase
     SE2->E2_VENCREA := dDataBase
     SE2->E2_VALOR   := SZ4->Z4_REMB
     SE2->E2_EMIS1   := dDataBase
     SE2->E2_HIST    := "Reemb." + SZ3->Z3_NUM + " P/" + SZ3->Z3_NOME
     SE2->E2_SALDO   := SZ4->Z4_REMB
     SE2->E2_VENCORI := dDataBase
     SE2->E2_MOEDA   := Val(SZ3->Z3_MOEDA)
     SE2->E2_RATEIO  := "N"
     SE2->E2_VLCRUZ  := SZ4->Z4_REMB
     SE2->E2_OCORREN := "01"
     SE2->E2_ORIGEM  := ""  
     SE2->E2_FLUXO   := "S"
     SE2->E2_DESDOBR := "N"
     SE2->E2_OBS     := "TITULO GERADO PELA ROTINA DE ACERTO DE VIAGEM"
     SE2->E2_CC      := SZ3->Z3_CC
     cCusto          := SZ3->Z3_CC
   MsUnLock("SE2")

ElseIf SZ4->Z4_RESTITU > 0 // Gerar Contas a Receber
   RecLock("SE1",.t.)
     SE1->E1_FILIAL  := xFilial("SE1")
     SE1->E1_PREFIXO := "ADT"
     SE1->E1_NUM     := SZ3->Z3_NUM
     SE1->E1_PARCELA := "A"
     SE1->E1_TIPO    := "VL"
     SE1->E1_NATUREZ := SZ3->Z3_NATUREZ
     SE1->E1_PORTADO := "" // Verificar com Vilela
     SE1->E1_AGEDEP  := "" // Verificar com Dercy
     SE1->E1_CLIENTE := "999999"
     SE1->E1_LOJA    := "01"
     SE1->E1_NOMCLI  := "ADT DE VIAGEM"
     SE1->E1_EMISSAO := dDataBase
     SE1->E1_VENCTO  := dDataBase
     SE1->E1_VENCREA := dDataBase
     SE1->E1_VALOR   := SZ4->Z4_RESTITU
  // SE1->E1_CC      := SZ3->Z3_CC  // VERIFICAR COM DERCY
  // SE1->E1_BAIXA   := VERIFICAR COM VILELA
  // SE1->E1_EMISS1  := VERIFICAR COM VILELA
  // SE1->E1_OBS     := "REST.N. " + SZ3->Z3_NUM + " PARA " + SZ3->Z3_NOME
     SE1->E1_HIST    := "REST.N. " + SZ3->Z3_NUM + " DO ADT DE VIAGEM"
     SE1->E1_SALDO   := SZ4->Z4_RESTITU
     SE1->E1_SITUACA := "0" 
     SE1->E1_VENCORI := dDataBase
     SE1->E1_MOEDA   := Val(SZ3->Z3_MOEDA)
     SE1->E1_FLUXO   := "S"
     SE1->E1_VLRREAL := SZ4->Z4_RESTITU
     cCusto          := SZ3->Z3_CC
   MsUnLock("SE1")
Endif

// Flag para evitar exclusao de adiantemantos com CP ou CR e Geracao dupla
RecLock("SZ4",.f.)
  SZ4->Z4_CPCR := "S"
MsUnLock("SZ4")

Return

