#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function rh001()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CCONTA,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    퀁h001     � Autor 쿘arco A.Fagundes       � Data � 04.04.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿌tualizacao de Contas da Folha de pagamento                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      쿙ew Hubner                                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

SI3->(DbGoTop())


While SI3->(!Eof())

         // Determina o Centro de Custo
         If SubStr(SI3->I3_CUSTO,1,1) == "1"
            _cConta := "40107001"
         ElseIf AllTrim(SI3->I3_CUSTO) == "770001"
             _cConta := "40106001"
         ElseIf AllTrim(SI3->I3_CUSTO) == "770006"
             _cConta := "40106001"
         ElseIf SubStr(SI3->I3_CUSTO,1,1) == "7"
             _cConta := "40108001"
         ElseIf AllTrim(SI3->I3_CUSTO) == "880001"
             _cConta := "30401001"
         ElseIf SubStr(SI3->I3_CUSTO,1,1) == "8"            
             _cConta := "30401002"
         Endif
         
         RecLock("SI3",.f.)
            SI3->I3_CONTNH := _cConta
         MsUnLock("SI3")
      
      SI3->(DbSkip())
EndDo
MsgBox("Terminou")
Return
