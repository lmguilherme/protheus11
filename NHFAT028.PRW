/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFAT028  � Autor � Jo�o Felipe            Data � 06/03/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ALTERA VALOR DO SEGURO DAS NFS                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Faturamento WHB                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    

User Function nhfat028()

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Produtos")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
			{ "Visualizacao"	,"AxVisual" 	, 0 , 2},;
			{ "Altera"   		,"U_ffat028()"  , 0 , 5}}

mBrowse( 6, 1,22,75,"SF1",,,,,,)
Return

User Function fFAT028()

IF !EMPTY(SF1->F1_VLRSEG)
	_nVlrSeg := SF1->F1_VLRSEG
ELSE
	_nVlrSeg := 0
ENDIF

	Define MsDialog oDialog Title OemToAnsi("Notas Fiscais") From 000,000 To 140,250 Pixel 
	

	@ 005,005 Say "NF: " + SF1->F1_DOC Size 040,8 
	@ 020,005 Say "Serie: " + SF1->F1_SERIE Size 040,8 	
	@ 035,005 Say "Vlr Seguro: " Size 040,8
	@ 035,040 Get _nVlrSeg Picture "@e 999,999,999.99 " Size 50,8
	
	@ 052,055 BMPBUTTON TYPE 01 ACTION fOk()
	@ 052,089 BMPBUTTON TYPE 02 ACTION fEnd() 
	
	Activate MsDialog oDialog Center 

Return

Static Function fOK()
	
   	RecLock("SF1",.F.)
   		SF1->F1_VLRSEG := _nVlrSeg
   	MsUnlock("SF1")

	Close(oDialog)
Return

Static Function fEnd() 

   	Close(oDialog) 
   	lDialog := .T.

Return



                                           
