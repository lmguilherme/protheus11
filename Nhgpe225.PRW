/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE225 �Autor  �Marcos R Roquitski  � Data �  22/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Trava lancamento mensal.                                   ���
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


User Function Nhgpe225()

	SetPrvt("_cMvGpes033,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpes033 := Alltrim(GETMV("MV_GPES033")) // Sequencial
	
	If Alltrim(_cMvGpes033) == 'N'
		GPEA320()	
 
	Else
		MsgBox("Rotina Bloqueada, favor entrar em contato com Administrador da Folha de Pagameto.","Bloqueio de Lancamentos","STOP")
	
	Endif	
		 				
Return(.T.)

