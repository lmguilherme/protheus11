#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhgp15()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CATENCAO,_CDESCPROC,_CSIMNAO,_CDIALOG,_CTITLE,_CPROCESSA")
SetPrvt("LEND,_CPATH,_CALIAS,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � RHGP15   � Autor �  Geandr� G. Oliveira  � Data � 08.10.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿍ackup New Hubner                                           낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

_cAtencao  := 'Aten놹o' 

_cDescProc := "Verificando Arquivos ..."

_cSimNao := 'sim' + Space(25) + 'nao'
_cDialog := 'Backup'
_cTitle  := 'Montar Backup ???'
@ 000, 000 TO 140,200 DIALOG oDlg1 TITLE _cDialog      
@ 005, 005 TO 068,095 TITLE _cTitle
@ 035, 015 bmpButton TYPE 03 ACTION _Verifica() // Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> @ 035, 015 bmpButton TYPE 03 ACTION Execute(_Verifica) 
@ 035, 060 bmpButton TYPE 02 ACTION Close(oDlg1) 
@ 053, 025 say _cSimNao
ACTIVATE DIALOG oDlg1 CENTERED         
Return


// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function _Verifica
Static Function _Verifica()
   _cProcessa := 'Processando Backup'
   lEnd := .F.
   ProcGPE({|lEnd|f_Gera()},_cProcessa) // Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    ProcGPE({|lEnd|Execute(f_Gera)},_cProcessa) 
Return


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � f_Gera   � Autor �  Geandr� G. Oliveira  � Data � 27.09.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿒era Arquivo Temporario                                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿚bjetivos:쿒era arquivo temporario             .                       낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function f_Gera
Static Function f_Gera()
   
   Close(oDlg1) 
   DbSelectArea("SX2")
   SX2->(DbGoTop())
   _cPath  := 'C:' +  AllTrim(SX2->X2_PATH) 
   DbSelectArea("SX2")
   GPProcRegua(SX2->(RecCount()))        
   SX2->(DbGoTop())
   While SX2->(!Eof())
      If SubStr(AllTrim(SX2->X2_CHAVE),1,2) == 'SR'
         If AllTrim(SX2->X2_CHAVE) == "SR5"
            SX2->(DbSkip())
            Loop
         EndIf
         _cAlias := AllTrim(SX2->X2_CHAVE)
         _cPath  := 'C:' +  AllTrim(SX2->X2_PATH) + AllTrim(SX2->X2_ARQUIVO)
         DbSelectArea(_cAlias)
         DbSetOrder(1)
         Copy to  &_cPath
         GPIncProc(SX2->X2_CHAVE+" - "+AllTrim(SX2->X2_NOME) + ' ' + _cPath)         
      EndIf
      SX2->(DbSkip())
   End
   
Return

