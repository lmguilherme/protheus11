/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST030 � Autor � Alexandre R. Bento    � Data � 06/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Limpa Flag das notas fiscais de entrada e saida (SF1/SF2)   ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � Depto Fiscal                                               ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SF1,SF2                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


#include "rwmake.ch"      


User Function Nhest030()   

   SetPrvt("cCadastro,aRotina,_aOp�oes,cAlias,cMsg,_nPos")
   _aOpcoes := {"Nota de Entrada","Nota de Saida"}
   _nPos    := 1  
   
   @ 100,050 To 300,370 Dialog DlgItem Title OemToAnsi("Limpa Flag de Contabiliza��o")
   @ 005,008 To 075,150                                     
   @ 020,020 Say OemToAnsi("Escolha uma Op��o")   Size 150,8
   @ 040,020 RADIO _aOpcoes VAR _nPos   

   @ 080,080 BMPBUTTON TYPE 01 ACTION fOK()
   @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgItem)
   Activate Dialog DlgItem Centered

Return


Static Function fOK()

   If _nPos == 1
      cMsg   := "Nota de entrada"
      cAlias := "SF1"
   Else
      cMsg := "Nota de Saida"   
      cAlias := "SF2"      
   Endif
   
   cCadastro := OemToAnsi(cMsg)
   aRotina := {{ "Pesquisa"   ,"Axpesqui",0,1},;
               { "Limpa Flag" ,'U_fLimpa()',0,2}}

   DbSelectArea(cAlias)
   (cAlias)->(DbSetOrder(1))
   DbGoTop()
	            
   mBrowse(06,01,22,75,cAlias,,)                           

Return

User Function fLimpa()

   RecLock(cAlias,.f.)
      If _nPos == 1
         SF1->F1_DTLANC := CtoD(" / / ")
      Else 
         SF2->F2_DTLANC := CtoD(" / / ")
      Endif   
   MsUnLock(cAlias)

Return
