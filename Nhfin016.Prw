/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFIN016 � Autor � Jose Roberto Gorski   � Data � 12/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Tela de Liberacao de Exclusao para Acerto de Viagem        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para a New Hubner                               ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ3,SZ4                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Alterac. �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


#include "rwmake.ch"      

User Function nhfin016()   


SetPrvt("CCADASTRO,AROTINA,")


cCadastro := 'Exclusao do Acerto de Viagem'
aRotina := {{ "Pesquisa","AxPesqui"                        , 0 , 1},;
            { "Visual"  ,"AxVisual"                        , 0 , 2},;
            { "Excluir",'ExecBlock("NHFIN017",.f.,.f.,01)', 0 , 3}}

mBrowse(06,01,22,75,"SZ4",,"Z4_CPCR=='S'")
Return
