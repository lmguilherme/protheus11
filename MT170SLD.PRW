/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT170SLD   �Autor �Jo�o Felipe         � Data �  14/02/2008���
�������������������������������������������������������������������������͹��
���Desc.     � 							                                  ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������͹��
���Array: O par�metro tem a seguinte estrutura:                           ���
���{nSaldo,SB2->B2_COD,SB2->B2_LOCAL}                                     ���
���nSaldo -> Saldo calculado pelo sistema                                 ���
���SB2->B2_COD -> C�dido do produto                                       ���
���SB2->B2_LOCAL -> Armaz�m do produto                                    ���
���Retorno                                           					  ���
�������������������������������������������������������������������������ͼ��
���LOCALIZA��O   : Localizado na fun��o A170Point  (Gera��o  das  		  ���
���solicita��es  de  compra).								              ���
���EM QUE PONTO : � executado dentro do la�o onde  � feito o c�lculo  do  ���
���saldo  do  produto                                                     ���
���de todos os almoxarifados. O resultado do c�lculo do saldo � guardado  ���
���na vari�vel nSaldo.                                                    ���
���O ponto de entrada � executado ap�s a  atualiza��o  desta  vari�vel,   ���
���produto  a  produto 					                                  ���
���(todos os almoxarifados) .                                             ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "topconn.ch"

User Function MT170SLD( )

Local nQuant:= PARAMIXB[1]
Local cProd := PARAMIXB[2]
Local cLocal:= PARAMIXB[3]
Local nNewSaldo := nQuant
Local B2Reg := SB2->(RecNo()) //Guarda o registro do SB2


If GetMv('MV_REAFI')

	//Se for ferramenta NOVA
	If Substr(cProd,1,4)$"FE01/FE02/FE03"
	
		//Verifica o saldo da FE REAFIADA no SB2
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2")+"FE05"+Substr(cProd,5,7))
			While "FE05"+Substr(cProd,5,7)$SB2->B2_COD
				If SB2->B2_LOCAL <> '50' //descarta o almox 50 -> antigo preset
					nNewSaldo += SB2->B2_QATU
				EndIf
				SB2->(DbSkip())
			EndDo
			
		EndIf
	EndIf
	
EndIf

SB2->(DbGoTo(B2Reg))//Volta o registro do SB2

Return (nNewSaldo)



