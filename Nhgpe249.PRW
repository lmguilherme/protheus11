/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE249 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio de calculo de Rescisao.                           ���
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


User Function Nhgpe249()

	SetPrvt("_cMvGpem040,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpem040 := Alltrim(GETMV("MV_GPEM040")) 
	
	If Alltrim(_cMvGpem040) == 'N'
		GPEM040()
 
	Else
		MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Rescisao de Contrato","STOP")
	
	Endif	
		 				
Return(.T.)

// Rua alvaro maravalhas, 594 - CIC - PARQUE DO SOFTWARE