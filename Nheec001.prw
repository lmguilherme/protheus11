/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEEC001  �Autor  �Marcos R Roquitski  � Data �  28/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza transportadora no cadastro de clientes, para toda ���
���          � digitacao no campo EE7_TRANSP.                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"   

User Function NHEEC001()

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + M->EE7_IMPORT + M->EE7_IMLOJA))
If SA1->(Found())
	RecLock("SA1",.F.)
	SA1->A1_TRANSP := M->EE7_TRANSP
	Msunlock("SA1")
Endif

RETURN(.T.)
