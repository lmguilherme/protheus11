/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE046  �Autor  �Marcos R. Roquitski � Data �  13/05/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra funcionarios com o matricula inferior a 900000.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function  Nhgpe046()

DbSelectArea("SRA")
Set Filter to Substr(SRA->RA_MAT,1,1) == "0"
SRA->(DbGotop())

GPEM040() // Rescisao           

Set Filter to
SRA->(DbGotop())

Return(nil)