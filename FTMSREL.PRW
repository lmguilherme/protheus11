/*                                     
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FTMSREL  � Autor � Alexandre R. Bento      Data � 11/08/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada p/ chamar a base de conhecimento          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � WHB         	                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

USER FUNCTION FTMSREL()

Local aEntidade:={}

AAdd( aEntidade, { "ZAO", { "ZAO_NUM"   } , { || ZAO->ZAO_DESCLI } } ) //NHPCP013
AAdd( aEntidade, { "ZBI", { "ZBI_NUM"   } , { || ZBI->ZBI_ITEM   } } ) //NHEST139
AAdd( aEntidade, { "ZDP", { "ZDP_COD"   } , { || ZDP->ZDP_COD+ZDP->ZDP_LETRA   } } ) //NHMNT049
AAdd( aEntidade, { "ZDN", { "ZDN_ORDEM" } , { || ZDN->ZDN_COD    } } ) //NHMNT050
AAdd( aEntidade, { "ZBO", { "ZBO_ORDEM" } , { || ZBO->ZBO_DISP+ZBO->ZBO_LETRA  } } ) //NHMNT042
AAdd( aEntidade, { "ZBN", { "ZBN_COD"   } , { || ZBN->ZBN_DESC   } } ) //NHMNT041              
aAdd( aEntidade, { "ZDU", { "ZDU_NUM"   } , { || ZDU->ZDU_OBS    } } ) //NHPCP028

RETURN aEntidade

