/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE245 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Trava calculo de ferias.                                   ���
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


User Function Nhgpe245()

	SetPrvt("_cMvGpem030,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpem030 := Alltrim(GETMV("MV_GPEM030")) 
	
	If Alltrim(_cMvGpem030) == 'N'
		GPEM030()	
 
	Else
		MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Ferias","STOP")
	
	Endif	
		 				
Return(.T.)

// Rua alvaro maravalhas, 594 - CIC - PARQUE DO SOFTWARE