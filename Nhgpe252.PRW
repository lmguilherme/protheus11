/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE252 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio de calculo ferias coletivas/programadas           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch" 
#include "Font.ch" 
#include "Colors.ch" 


User Function Nhgpe252()

	If MsgBox("Bloquea Rotina de Calculo de ** FERIAS COLETIVAS/PROGRAMADAS ?.","Bloqueio de Lancamentos","YESNO")

		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM060"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "S"
			MsUnlock("SX6")

			Alert("** FERIAS COLETIVAS/PROGRAMADAS,  BLOQUEADA para manutencao.")	
		Else
			Alert("Parametro MV_GPEM060 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
	
	Else
	
		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM060"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "N"
			MsUnlock("SX6")

			Alert("** FERIAS COLETIVAS/PROGRAMADAS,  LIBERADA para manutencao.")

		Else

			Alert("Parametro MV_GPEM060 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
		
	Endif
	
Return
