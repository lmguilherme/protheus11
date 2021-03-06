/*          
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFAT017 �Autor  � Alexandre R. Bento    � Data � 14/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera o arquivo de Aviso de Embarque p/ Randon              ���
���          � Layout do arquivo conforme modelo 004 versao 15            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Faturamento                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "Ap5mail.ch"
#INCLUDE "TOPCONN.CH"

User Function NHFAT017()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,x ")   
SetPrvt("_cArqITP,_cArqAE1,_cArqNF2,_cArqAE2,_cArqAE4,_cArqAE3,_cArqTE1,_cArqFTP,cDtaHor ")
SetPrvt("_aITP,_aAE1,_aNF2,_caAE2,_aAE4,_aAE3,_aFTP,_aTE1, _aDBF,nAux,cCod,nFTP,cIPI,cICM,cDesc")
SetPrvt("aRotina,cCadastro,_cCliente,_cLoja,_cPlanta")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cNome,_aFile,_cEdi,_cCam")

Private cPerg := "FAT017"                                
nPbruto :=  0
_cArqDBF:=SPACE(12) 
_cArqFTP:=SPACE(12) 
_cArqITP:=SPACE(12)                                                           
_cArqAE1:=SPACE(12) 
_cArqNF2:=SPACE(12) 
_cArqAE2:=SPACE(12) 
_cArqAE4:=SPACE(12) 
_cArqAE3:=SPACE(12) 
_cArqTE1:=SPACE(12) 
cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := 'Erro ao se conectar no servidor: ' 
CRLF := chr(13)+chr(10)   // PULA LINHA  
cMSG := ""        
_lEmb   := .F. //verifica se gerou o aviso de embarque                                   
_cNotas :=SPACE(200) 
_cNome  := UsrFullName(__cUserID)
_aFile  := {}

///////////**************************                        

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Da Nota ?                                    �
//� mv_par02     // Ate a Nota ?                                 �
//����������������������������������������������������������������

cNovaLinha := Chr(13) + Chr(10)
_cEdi      := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam      := "MAS"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
             // "V:\mdicom\Parceiro\WHBCOMP\Out\VLK"

cARQEXP    := _cEDI + _cCam            
While File(cARQEXP)        
   _cCam   := SUBS(_cCam,1,7) +  StrZero(Val(SUBS(_cCam,8,1))+1,1)+".TXT" 
   cARQEXP := _cEDI + _cCam
Enddo


//AjustaSx1()

If Pergunte(cPerg,.T.)
	Processa({|| Gerando() }, "Gerando Aviso de Embarque para Master")
EndIf

//Close TMP

If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
   fErase(_cArqITP)  
   fErase(_cArqAE1)
   fErase(_cArqAE2)
   fErase(_cArqAE3)
   fErase(_cArqAE4)
   fErase(_cArqTE1)
   fErase(_cArqNF2)
   fErase(_cArqFTP)
  
Endif   

//Manda e-mail de confirma��o da gera��o do aviso de embarque da volks
If _lEmb //verifica se gerou o aviso de embarque                                   
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

     cMsg += '<html>' + CRLF
	 cMsg += '<head>' + CRLF
	 cMsg += '<title> E X E M P L O </title>' + CRLF
	 cMsg += '</head>' + CRLF
     cMsg += ' <P><IMG SRC="WHBL.BMP" ALIGN=BOTTOM><b><font size="5" face="Times New Roman">'+CRLF+'          Aviso de Embarque</font></b></P>'+ CRLF	 
	 cMsg += '<b><font size="3" face="Arial"> Email Enviado Atraves do Sistema AP11</font></b>' + CRLF+CRLF
	 cMsg += '<font size="2" face="Arial">Aviso de Embarque Enviado para Master as '+time() +' na data: '+Dtoc(ddatabase)+'</font>' + CRLF
     cMsg += CRLF	 
     cMsg += '<font size="2" face="Arial"> Notas enviadas  '+CRLF
     cMsg += _cNotas+'</font>' + CRLF	 
     cMsg += CRLF	 
     cMsg += CRLF	 
     cMsg += '<font size="2" face="Arial"> Aviso de Embarque Gerado Por '+_cNome+'</font>' + CRLF	 
	 cMsg += '</body>' + CRLF
	 cMsg += '</html>' + CRLF
  	    	              

     a_email = 'lista-fiscal@whbbrasil.com.br'
      //a_email = 'douglassd@whbbrasil.com.br'
     _aFile := { "\SigaAdv\WHBL.BMP" }
	 If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT '***** AVISO DE EMBARQUE PARA MASTER ***** ';
		BODY cMsg;                      
        ATTACHMENT _aFile[1];		
		RESULT lEnviado
	    If !lEnviado
			Get mail error cMensagem
		  	   Alert(cMensagem)
    	EndIf                             
	 else
		Alert("Erro ao se conectar no servidor: " + cServer)		
	 Endif
	
Endif

Return

Static Function Gerando()
   
   cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,B1.B1_POSIPI,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI," 
   cQuery += "D2.D2_SERIE,D2.D2_ITEM,D2.D2_TOTAL,D2.D2_TES,D2.D2_CF,D2.D2_VALICM,D2.D2_VALIPI,D2.D2_UM,D2.D2_IPI,D2.D2_PRCVEN,D2.D2_PICM,D2.D2_BASEICM,D2.D2_DESC,D2.D2_DESCON,"
   cQuery += "A7.A7_CLIENTE,A7.A7_LOJA,A7.A7_PRODUTO,A7.A7_PCCLI,A7.A7_CODCLI,F4.F4_TEXTO"
   cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1, " + RetSqlName( 'SA7' ) +" A7 ," + RetSqlName( 'SF4' ) +" F4 " 
   cQuery += " WHERE B1.B1_FILIAL = '" + xFilial("SB1")+ "' "
   cQuery += " AND C5.C5_FILIAL = '" + xFilial("SC5")+ "' "
   cQuery += " AND C6.C6_FILIAL = '" + xFilial("SC6")+ "' "
   cQuery += " AND F4.F4_FILIAL = '" + xFilial("SF4")+ "' "     
   cQuery += " AND D2.D2_FILIAL = '" + xFilial("SD2")+ "' "   
   cQuery += " AND A7.A7_FILIAL = '" + xFilial("SA7")+ "' "   
   cQuery += " AND D2.D2_EMISSAO BETWEEN '" + DTOS(Mv_par01) + "' AND '" + DTOS(Mv_par02) + "' " 
   cQuery += " AND D2.D2_CLIENTE= '000003' AND D2.D2_LOJA= '01' " 
   cQuery += " AND D2.D2_TES = F4.F4_CODIGO"
   cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE AND D2.D2_TES IN ('576')"
   cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE AND D2.D2_TIPO = 'N' "
   cQuery += " AND D2.D2_CLIENTE = A7.A7_CLIENTE AND D2.D2_LOJA = A7.A7_LOJA"
   cQuery += " AND C6.C6_ITEM = D2.D2_ITEMPV "
   cQuery += " AND B1.B1_COD = D2.D2_COD AND A7.A7_PRODUTO = D2.D2_COD"      
   cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ = ' ' " 
   cQuery += " AND F4. D_E_L_E_T_ = ' ' AND A7. D_E_L_E_T_ = ' '" 
   cQuery += " ORDER BY D2.D2_DOC ASC"    
                                                     
MemoWrit('C:\TEMP\fat017.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")


TMP->(DBGotop())            
If Empty(TMP->D2_DOC)
   Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
   TMP->(DbCloseArea())
   Return
Endif

cARQ  := FCreate(cARQEXP) // Cria o arquivo para receber informacoes somente se existir informa�oes   

// Alterado para USer function em 26/11/2013 p/ atender o nhest021
U_fCriaDBF()  // Cria arquivos temporarios de aviso de embarque para volks
  
While !TMP->(EOF())
   RecLock("XDBF",.T.)
   XDBF->Nota    := TMP->D2_DOC
   XDBF->Serie   := TMP->D2_SERIE
   XDBF->Dta     := Subs(TMP->D2_EMISSAO,7,2)+"/"+Subs(TMP->D2_EMISSAO,5,2)+"/"+Subs(TMP->D2_EMISSAO,1,4)
   XDBF->Prodcli := TMP->A7_CODCLI
   XDBF->Prodwhb := TMP->D2_COD
   XDBF->Total   := TMP->D2_TOTAL
                    //Transform(TMP->D2_TOTAL,"@e 999,999,999,999.99")
   MsUnlock("XDBF")
     
   TMP->(DbSkip())
Enddo

cMarca  := GetMark()
aCampos := {}   

Aadd(aCampos,{"OK"        ,"C", "  "             ,"@!"})
Aadd(aCampos,{"NOTA"      ,"C", "Nota"           ,"@!"})
Aadd(aCampos,{"SERIE"     ,"C", "Serie"          ,"@!"})
Aadd(aCampos,{"DTA"       ,"C", "Data"           ,"@!"})
Aadd(aCampos,{"PRODCLI"   ,"C", "Prod. Cliente"  ,"@!"})
Aadd(aCampos,{"PRODWHB"   ,"C", "Prod. WHB"      ,"@!"})
Aadd(aCampos,{"TOTAL"     ,"N", "Total"          ,"@e 999,999,999,999.99"})
Aadd(aCampos,{"ESPACO"    ,"C", "  "             ,"@!"})

XDBF->(DbGoTop())
cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarca()', 0 , 4 },;
             {"Desmarca Tudo" ,'U_fDesmarca()', 0 , 1 },;
             {"Legenda"       ,'U_fLegenda()', 0 , 1 } }

MarkBrow("XDBF","OK" ,"XDBF->OK",aCampos,,cMarca)

//Static Function fGera()

ProcRegua(TMP->(RecCount()))

TMP->(DbGoTop())
XDBF->(DbGoTop())
nFTP := 1
_lEmb := .F. //verifica se gerou o aviso de embarque                                                                      
While !TMP->(eof()) .And. !XDBF->(eof())     

   
   If !EMPTY(XDBF->OK)
      
	  IncProc("Gerando Aviso de Embarque")

      //---------------  SEGMENTO AE1v5 - COMPLEMENTO DADOS DA NF 	                   
       _lEmb := .T. //verifica se gerou o aviso de embarque                                                                      
       _cNotas := ALLTRIM(_cNotas) +" "+ TMP->D2_DOC + CRLF                 
	   RecLock("AE1",.T.)               
	   AE1->IdentSeg   := "AE1"
	   AE1->NumNF      := SUBS(TMP->D2_DOC,4,6)
	   AE1->SerNF      := Space(02) // Subs(TMP->D2_SERIE,1,2)
	   AE1->DataNF     := Subs(TMP->D2_EMISSAO,3,6)
	   AE1->QItNf      := StrZero(Val(TMP->D2_ITEM),3)                             
	   AE1->VlToNF     := StrZero(TMP->D2_TOTAL,17,2)
	   AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
  	   AE1->VlToNF     := Stuff(AE1->VlToNF,1,0,"0")  // Insere o primeiro caracter
	   AE1->QCDec      := "0"  // QTDE de casas decimais
	   AE1->CFO        := TMP->D2_CF
	   AE1->VlToICM    := StrZero(TMP->D2_VALICM,17,2)
	   AE1->VlToICM    := Stuff(AE1->VlToICM,AT(".",AE1->VlToICM),1,"") //elimina o ponto
  	   AE1->VlToICM    := Stuff(AE1->VlToICM,1,0,"0")  // Insere o primeiro caracter
	   AE1->DataVen    := Subs(Dtos(dDatabase+7),3,6)
	   AE1->EspNF      := Iif(Alltrim(TMP->D2_TES) == "576","02","00")
  	   AE1->VlIPI      := StrZero(TMP->D2_VALIPI,17,2)
	   AE1->VlIPI      := Stuff(AE1->VlIPI,AT(".",AE1->VlIPI),1,"") //elimina o ponto
  	   AE1->VlIPI      := Stuff(AE1->VlIPI,1,0,"0")  // Insere o primeiro caracter
  	   AE1->CodFabEn   := Space(03)
	   AE1->DataPrNF   := Iif((Val(Time())+14) > 24,Subs(Dtos(dDatabase+1),3,6),Subs(Dtos(dDatabase),3,6)) // verificar
	   AE1->IdentPer   := "0000"

	   AE1->DescNat    := Subs(TMP->F4_TEXTO,1,15)
   	   AE1->DataEmb    := Subs(TMP->D2_EMISSAO,3,6)                                    
   	  // AE1->VlToNF     := Stuff(AE1->VlToNF,AT(".",AE1->VlToNF),1,"") //elimina o ponto
//   	   alert(" hora  "+Subs(time(),1,5))
	   AE1->HoraSai    := Stuff(Subs(time(),1,5),AT(":",Subs(time(),1,5)),1,"") //elimina o ponto
//	   alert ( " hora certa  " + AE1->HoraSai)
	   AE1->Espaco     := Space(03)
	   MsUnlock("AE1")

       FWrite(cArq,(AE1->(IdentSeg+NumNF+SerNF+DataNF+QItNf+VlToNF+QCDec+CFO+VlToICM+DataVen+EspNF+VlIPI+CodFabEn+DataPrNF+IdentPer+DescNat+DataEmb+VlToNF+Espaco)+cNovaLinha))    
       nFTP += 1  //Controle de qtde de segmentos
       
//---------------- SEGMENTO AE2v5 - DADOS DO ITEM                         
    
      // Retira os espacos do codigo do produto
       cCod := TMP->A7_CODCLI //Codigo da amarracao prod x cliente
       nAux := AT(" ",cCod)
       While nAux <> 0
       
          cCod := Stuff(cCod,nAux,1,"")   
          nAux := AT(" ",cCod)
           
       Enddo

	   Reclock("AE2",.T.)
	   AE2->IdentSeg    := "AE2"
	   AE2->NumItNF     := StrZero(Val(TMP->D2_ITEM),3)                             
	   AE2->NumPed      := TMP->A7_PCCLI           
	  // AE2->CodItem     := Subs(Alltrim(cCod),1,3)+Space(03)+Subs(Alltrim(cCod),4,6)+Space(01)+Subs(Alltrim(cCod),10,10)	   
	   AE2->CodItem     := cCod  //TMP->A7_CODCLI
  	   AE2->QINF        := StrZero(TMP->D2_QUANT,9,0)
	   AE2->UnMedNF     := TMP->D2_UM
	   AE2->CodClasF    := TMP->B1_POSIPI
       cIPI             := StrZero(TMP->D2_IPI,4,2)
	   AE2->AliIPI      := Stuff(cIPI,AT(".",cIPI),1,"") //elimina o ponto
  	   AE2->VlItem      := StrZero(TMP->D2_PRCVEN,12,5)
	   AE2->VlItem      := Stuff(AE2->VlItem,AT(".",AE2->VlItem),1,"") //elimina o ponto
  	   AE2->VlItem      := Stuff(AE2->VlItem,1,0,"0")  // Insere o primeiro caracter
	   AE2->QItEst      := StrZero(TMP->D2_QUANT,9,0)
	   AE2->UnMedEs     := TMP->D2_UM
	   AE2->QtUniCom    := StrZero(TMP->D2_QUANT,9,0)
	   AE2->UnMedCo     := TMP->D2_UM
	   AE2->CodTpFo     := "P"  // P= Producao
  	   cDesc             := StrZero(TMP->D2_DESC,4,2)
	   AE2->QtPerDe     := Stuff(cDesc,AT(".",cDesc),1,"") //elimina o ponto
  	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter	   
  	   AE2->VlToDes     := StrZero(TMP->D2_DESCON,11,2)
	   AE2->VlToDes     := Stuff(AE2->VlToDes,AT(".",AE2->VlToDes),1,"") //elimina o ponto
  	   AE2->VlToDes     := Stuff(AE2->VlToDes,1,0,"0")  // Insere o primeiro caracter
  	   AE2->QtPerDes    := "0000"   
	   AE2->Espaco      := Space(01)    	   
	   MsUnlock("AE2")

       FWrite(cArq,(AE2->(IdentSeg+NumItNF+NumPed+CodItem+QINF+UnMedNF+CodClasF+AliIPI+VlItem+QItEst+UnMedEs+QtUniCom+UnMedCo+CodTpFo+QtPerDe+VlToDes+QtPerDes+Espaco)+cNovaLinha))      
       nFTP += 1  //Controle de qtde de segmentos

//-------------  SEGMENTO AE4v5 - DADOS COMPLEMENTARES DO ITEM                  


	   RecLock("AE4",.T.)             
	   AE4->IdentSeg  := "AE4"
  	   cICM            := StrZero(TMP->D2_PICM,5,2)
	   AE4->AlICM     := Stuff(cICM,AT(".",cICM),1,"") //elimina o ponto
// 	   AE2->QtPerDe     := Stuff(AE2->QtPerDe,1,0,"0")  // Insere o primeiro caracter
  	   AE4->BasICM    := StrZero(TMP->D2_BASEICM,17,2)
	   AE4->BasICM    := Stuff(AE4->BasICM,AT(".",AE4->BasICM),1,"") //elimina o ponto
  	   AE4->BasICM    := Stuff(AE4->BasICM,1,0,"0")  // Insere o primeiro caracter
  	   AE4->VlICMAp    := StrZero(TMP->D2_VALICM,17,2)
	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,AT(".",AE4->VlICMAp),1,"") //elimina o ponto
  	   AE4->VlICMAp    := Stuff(AE4->VlICMAp,1,0,"0")  // Insere o primeiro caracter
  	   AE4->VlIPIAp    := StrZero(TMP->D2_VALIPI,17,2)
	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,AT(".",AE4->VlIPIAp),1,"") //elimina o ponto
  	   AE4->VlIPIAp    := Stuff(AE4->VlIPIAp,1,0,"0")  // Insere o primeiro caracter
	   AE4->CodSiTr   := "00"
	   AE4->NumDesIt  := Space(30)
	   AE4->DatValDe  := Space(06)
	   AE4->PedRev    := Space(13)
	   AE4->PeItem    := Space(05)
	   AE4->MuPreco   := Space(01)
	   AE4->PreMer    := Strzero(TMP->D2_TOTAL,12,2)
       AE4->PreMer    := Stuff(AE4->PreMer,AT(".",AE4->PreMer),1,"") //elimina o ponto
  	   AE4->PreMer    := Stuff(AE4->PreMer,1,0,"0")  // Insere o primeiro caracter       
  	   AE4->SitTrib   := Space(01)

	   MsUnlock("AE4") 

       FWrite(cArq,(AE4->(IdentSeg+AlICM+BasICM+VlICMAp+VlIPIAp+CodSiTr+NumDesIt+DatValDe+PedRev+PeItem+MuPreco+PreMer+SitTrib)+cNovaLinha))          
       nFTP += 1  //Controle de qtde de segmentos


//------------  SEGMENTO AE3v5 - DADOS ADICIONAIS DE COMERCIAL.                 


/*	   RecLock("AE3",.T.)
	   AE3->IdentSeg := "AE3"
	   AE3->IdentFat := "57290355001585"
	   AE3->IdentCob := "57290355001585"
	   AE3->IdentEnt := Space(14)
	   AE3->Espaco   := Space(30)
	   MsUnlock("AE3")
       
       FWrite(cArq,(AE3->(IdentSeg+IdentFat+IdentCob+IdentEnt+Espaco)+cNovaLinha))             
       nFTP += 1  //Controle de qtde de segmentos    

 
      RecLock("TE1",.T.)
	   TE1->IdentSeg := "TE1"
	   TE1->Texto1   := Space(40)
	   TE1->Texto2   := Space(40)
	   TE1->Texto3   := Space(40)
	   TE1->Espaco   := Space(05)
	   MsUnlock("TE1")
       
      FWrite(cArq,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))             
      nFTP += 1  //Controle de qtde de segmentos                                                
*/ 
            
   EndIf
   XDBF->(DbSkip())
   TMP->(DbSkip())
EndDo    

If nFTP > 1
//-------------  SEGMENTO FTPv5 - Segmento Final Mensagem                    
   nFTP += 1  //Controle de qtde de segmentos
   RecLock("FTP",.T.)
   FTP->IdentSeg := "FTP"
   FTP->NumCont  := "00000"
   FTP->QtdeSeg  :=StrZero(nFTP,9)
   FTP->NumToVl  :="00000000000000000"
   FTP->CatOper  := Space(01)
   FTP->Espaco   := Space(36)
   MsUnlock("FTP")          
    
   FWrite(cArq,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))                
   FClose(cARQ)            
 Else
    Alert("Atencao nao foi Selecionada nenhuma Nota Fiscal")
    FClose(cARQ)         
    fErase(cArQEXP)  // Deleta arquivo de dados pois n�o foi selecionado nenhuma nota
 Endif  

//Close(oDlg)
TMP->(DbCloseArea())
XDBF->(DbCloseArea())
AE1->(DbCloseArea())
AE2->(DbCloseArea())
AE3->(DbCloseArea())
AE4->(DbCloseArea())
TE1->(DbCloseArea())
NF2->(DbCloseArea())
FTP->(DbCloseArea())



Return
 

Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "FAT017"

aRegs   := {}


// VERSAO 811
//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegs,{cPerg,"01","Data Inicial       ?","Data Inicial       ?","Data Inicial       ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Data Final         ?","Data Final         ?","Data Final         ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"03","Cliente            ?","Cliente            ?","Cliente            ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"04","Loja               ?","Loja               ?","Loja               ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If !SX1->(DbSeek(cPerg + "01"))
    
   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock("SX1")
	    SX1->(DbDelete())
      MsUnLock("SX1")
   	SX1->(DbSkip())
   End
    
   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock("SX1")

       DbCommit()
   Next
EndIf

dbSelectArea(_sAlias)

Return
                                     

User Function fCriaDBF()

//��������������������������������������������������������������Ŀ
//� Criando Arquivo Temporario para posterior impressao          �
//����������������������������������������������������������������
_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aITP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aITP,{"NumComu"    ,"C", 03,0})         // Numero Mensagem Comunicacao     M    A       3    0    4    6
AADD(_aITP,{"NumVer"     ,"C", 02,0})         // Numero da Versao da Mensagem    M    N       2    0    7    8
AADD(_aITP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    9   13
AADD(_aITP,{"IdentMov"   ,"C", 12,0})         // Ident. Geracao Movimento        M    N      12    0   14   25
AADD(_aITP,{"IdentTra"   ,"C", 14,0})         // Identificacao do Transmissor    M    N      14    0   26   39
AADD(_aITP,{"IdentRec"   ,"C", 14,0})         // Identificacao do Receptor       M    N      14    0   40   53
AADD(_aITP,{"CodIntTr"   ,"C", 08,0})         // Codigo Interno Transmissor      O    A       8    0   54   61
AADD(_aITP,{"CodIntRe"   ,"C", 08,0})         // Codigo Interno Receptor         O    A       8    0   62   69
AADD(_aITP,{"NomTrans"   ,"C", 25,0})         // Nome do Transmissor             O    A      25    0   70   94
AADD(_aITP,{"NomRece"    ,"C", 25,0})         // Nome do Receptor                O    A      25    0   95  119
AADD(_aITP,{"Espaco"     ,"C", 09,0})         // Espaco                          M    A       9    0  120  128

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.) 

RecLock("ITP",.T.)             
   ITP->IdentSeg  := "ITP"
   ITP->NumComu   := "004"
   ITP->NumVer    := "15"
   ITP->NumCont   := "00001" // Fazer este numero sequencia atraves de MV_VOLKS
   cDtaHor         := Subs(Dtos(dDatabase),3,6)+Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS
   ITP->IdentMov  := Stuff(cDtaHor,AT(":",cDtaHor),1,"")  // DATA+HHMMSS tira o segundo :
   ITP->IdentTra  := "01261681000104"
   ITP->IdentRec  := "90852914000173" //CGC MASTER
   ITP->CodIntTr  := Space(08)
   ITP->CodIntRe  := "MASTER"
   ITP->NomTrans  := "WHB FUNDICAO S.A."  //Identificacao da fundicao
   ITP->NomRece   := "MASTER"	
   ITP->Espaco    := Space(09)

MsUnlock("ITP")

  FWrite(cArq,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentMov+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 
  DbSelectArea("ITP")
  DbCloseArea()
  
// Close ITP
// ------- Segmento AE1 modelo 004 versao 05 -----------
_cArqAE1  := CriaTrab(NIL,.f.)
_cArqAE1 += ".DBF"
_aAE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE1,{"NumNF"      ,"C", 06,0})         //  NUMERO DA NF ORIGEM             M    N       6    0    4    9
AADD(_aAE1,{"SerNF"      ,"C", 04,0})         // SERIE DA NOTA FISCAL ORIGEM     M    A       4    0   10   13
AADD(_aAE1,{"DataNF"     ,"C", 06,0})         // DATA DA NOTA FISCAL             M    D       6    0   14   19
AADD(_aAE1,{"QItNf"      ,"C", 03,0})         // QTDE ITENS POR NOTA FISCAL      M    N       3    0   20   22
AADD(_aAE1,{"VlToNF"     ,"C", 17,2})         // VALOR TOTAL DA NOTA FISCAL      M    N      17    2   23   39
AADD(_aAE1,{"QCDec"      ,"C", 01,0})         // QUANTIDADE DE CASAS DECIMAIS    M    N       1    0   40   40
AADD(_aAE1,{"CFO"        ,"C", 05,0})         // CODIGO FISCAL DE OPERACAO       M    N       5    0   41   45
AADD(_aAE1,{"VlToICM"    ,"C", 17,2})         // VALOR TOTAL DO ICMS APLICADO    M    N      17    2   46   62
AADD(_aAE1,{"DataVen"    ,"C", 06,0})         // DATA VENCIMENTO DO DOCUMENTO    M    D       6    0   63   68
AADD(_aAE1,{"EspNF"      ,"C", 02,0})         // ESPECIE DA NOTA FISCAL          M    N       2    0   69   70
AADD(_aAE1,{"VlIPI"      ,"C", 17,2})         // VALOR IPI APLICADO              M    N      17    2   71   87
AADD(_aAE1,{"CodFabEn"   ,"C", 03,0})         // CODIGO DA FABRICA ENTREGA       O    A       3    0   88   90 Codigo da fabrica de destino do item. Para os pedidos com prefixos terminados em: "P" usar codigo "028" - "T" usar codigo "081" - "C" usar codigo "010".                             
AADD(_aAE1,{"DataPrNF"   ,"C", 06,0})         // DATA PREVISAO ENTREGA DA NF     O    D       6    0   91   96
AADD(_aAE1,{"IdentPer"   ,"C", 04,0})         // IDENT. DO PERIODO DE ENTREGA    O    N       4    0   97  100
AADD(_aAE1,{"DescNat"    ,"C", 15,0})         // DESCRICAO DA NATUREZA OPERACAO  O    A      15    0   101 115
AADD(_aAE1,{"DataEmb"    ,"C", 06,0})         // DATA DE EMBARQUE DA MERCADORIA  O    N       6    0   116 121
AADD(_aAE1,{"HoraSai"    ,"C", 04,0})         // HORA DO EMBARQUE DA MERCADORIA  O    A       4    0  122 125
AADD(_aAE1,{"Espaco"     ,"C", 03,0})         // Espaco                          M    A      19    0  126 128

DbCreate(_cArqAE1,_aAE1)
DbUseArea(.T.,,_cArqAE1,"AE1",.F.) 

    
//---------------  SEGMENTO NF2v5 - COMPLEMENTO DADOS DA NF                    


_cArqNF2  := CriaTrab(NIL,.f.)
_cArqNF2 += ".DBF"
_aNF2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aNF2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aNF2,{"VlDesAc"    ,"C", 12,2})         // VALOR DESPESAS ACESSORIAS       O    N      17    2    4   15
AADD(_aNF2,{"VlFrete"    ,"C", 12,2})         // VALOR DO FRETE                  O    N      17    2   16   27
AADD(_aNF2,{"VlSegu"     ,"C", 12,2})         // VALOR DO SEGURO                 O    N      17    2   28   39
AADD(_aNF2,{"VlDesc"     ,"C", 12,2})         // VALOR DO DESCONTO DA NF         O    N      17    2   40   51
AADD(_aNF2,{"BasICMS"    ,"C", 12,2})         // BASE DE CALCULO DO ICMS         O    N      12    2   52   63
AADD(_aNF2,{"VDesICMS"   ,"C", 12,2})         // VALOR DO DESCONTO DO ICMS       O    N      12    2   64   75
AADD(_aNF2,{"NFFor"      ,"C", 06,0})         // NUMERO NF VENDA DO FORNECEDOR   O    N      6     0   76   81
AADD(_aNF2,{"DtNFFor"    ,"C", 06,0})         // DATA NF DE VENDA DO FORNECEDOR  O    N      6     0   82   87
AADD(_aNF2,{"SeNFFor"    ,"C", 04,0})         // SERIE NF DE VENDA FORNECEDOR    O    A      4     0   88   91
AADD(_aNF2,{"CodFab"     ,"C", 03,0})         // CODIGO DA FABRICA TRANSMISSORA  O    A      3     0   92   94
AADD(_aNF2,{"CFOP"       ,"C", 05,0})         // COD. FISCAL OPERACAO (CFOP)     O    N      5     0   95   99
AADD(_aNF2,{"Espaco"     ,"C", 29,0})         // ESPACO                          M    A      29    0  100   128 

DbCreate(_cArqNF2,_aNF2)
DbUseArea(.T.,,_cArqNF2,"NF2",.F.) 


//---------------- SEGMENTO AE2v5 - DADOS DO ITEM                         

_cArqAE2  := CriaTrab(NIL,.f.)
_cArqAE2 += ".DBF"
_aAE2 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE2,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE2,{"NumItNF"    ,"C", 03,0})         // NUMERO DO ITEM NA NOTA FISCAL   M    N       3    0    4    6
AADD(_aAE2,{"NumPed"     ,"C", 12,0})         // NUMERO DO PEDIDO DE COMPRA      M    A      12    0    7   18
AADD(_aAE2,{"CodItem"    ,"C", 30,0})         // CODIGO DO ITEM                  M    A      30    0   19   48
AADD(_aAE2,{"QINF"       ,"C", 09,0})         // QTDE ITEM UNIDADE NOTA FISCAL   M    N       9    0   49   57
AADD(_aAE2,{"UnMedNF"    ,"C", 02,0})         // UNIDADE MEDIDA NOTA FISCAL      M    A       2    0   58   59
AADD(_aAE2,{"CodClasF"   ,"C", 10,0})         // CODIGO DE CLASSIFICACAO FISCAL  M    N      10    0   60   69
AADD(_aAE2,{"AliIPI"     ,"C", 04,2})         // ALIQUOTA IPI                    M    N       4    2   70   73
AADD(_aAE2,{"VlItem"     ,"C", 12,5})         // VALOR UNITARIO DO ITEM          M    N      12    5   74   85
AADD(_aAE2,{"QItEst"     ,"C", 09,0})         // QTDE ITEM UNIDADE ESTOQUE       O    N       9    0   86   94
AADD(_aAE2,{"UnMedEs"    ,"C", 02,0})         // UNIDADE MEDIDA ESTOQUE          O    A       2    0   95   96
AADD(_aAE2,{"QtUniCom"   ,"C", 09,0})         // QTDE UNIDADE DE COMPRA          O    N       9    0   97  105
AADD(_aAE2,{"UnMedCo"    ,"C", 02,0})         // UNIDADE MEDIDA COMPRA           O    A       2    0  106  107
AADD(_aAE2,{"CodTpFo"    ,"C", 01,0})         // CODIGO DO TIPO DE FORNECIMENTO  O    A       1    0  108  108 Codigo atribuido pelo cliente, que identifica o  uso/destino  do item. P=Producao R=Reposicao T=Triangulacao E=Exportacao X=Outros A=Amostra F=Ferramentas e Solucoes.                 
AADD(_aAE2,{"QtPerDe"    ,"C", 04,2})         // QUANTIDADE PERCENTUAL DESCONTO  O    N       4    2  109  112
AADD(_aAE2,{"VlToDes"    ,"C", 11,2})         // VALOR TOTAL DESCONTO ITEM       O    N      11    2  113  123 Calculado pela formula V=(P * QTD * FC (IPI/100+1) * PD/100) Onde: P= elem. 100; QTD= elem. 122; FC= Fator de convesao de cimal; IPI=aliquota de IPI; PD= percentual de desconto/item  
AADD(_aAE2,{"QtPerDes"   ,"C", 04,0})         // QUANTIDADE PERCENTUAL DESCONTO  O    N       4    0  124  127
AADD(_aAE2,{"Espaco"     ,"C", 01,0})         // Espa�o                          O    N       1    0  128  128

DbCreate(_cArqAE2,_aAE2)
DbUseArea(.T.,,_cArqAE2,"AE2",.F.) 


//-------------  SEGMENTO AE4v5 - DADOS COMPLEMENTARES DO ITEM                  

_cArqAE4  := CriaTrab(NIL,.f.)
_cArqAE4 += ".DBF"
_aAE4 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE4,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE4,{"AlICM"      ,"C", 04,2})         // ALIQUOTA ICMS                   M    N       4    2    4    7
AADD(_aAE4,{"BasICM"     ,"C", 17,2})         // BASE DE CALCULO DO ICMS         M    N      17    2    8   24
AADD(_aAE4,{"VlICMAp"    ,"C", 17,2})         // VALOR DO ICMS APLICADO          M    N      17    2   25   41
AADD(_aAE4,{"VlIPIAp"    ,"C", 17,2})         // VALOR DO IPI APLICADO           M    N      17    2   42   58
AADD(_aAE4,{"CodSiTr"    ,"C", 02,0})         // CODIGO DE SITUACAO TRIBUTARIA   M    A       2    0   59   60
AADD(_aAE4,{"NumDesIt"   ,"C", 30,0})         // NUMERO DESENHO DO ITEM          O    A      30    0   61   90
AADD(_aAE4,{"DatValDe"   ,"C", 06,0})         // DATA DE VALIDADE DESENHO        O    D       6    0   91   96
AADD(_aAE4,{"PedRev"     ,"C", 13,0})         // PEDIDO DA REVENDA               O    A      13    0   97  109
AADD(_aAE4,{"PeItem"     ,"C", 05,0})         // PESO LIQUIDO DO ITEM            O    A       5    0  110  114
AADD(_aAE4,{"MuPreco"    ,"C", 01,0})         // MULTIPLICADOR DE PRECO UNIT.    O    A       1    0  115  115 Fator de multiplicacao do preco unitario. 1-Preco Unit. x 10 2-Preco Unit. x 100, 3-Preco Unit. x 1000, 4-Preco Unit. x 10000, e assim por diante                                    
AADD(_aAE4,{"PreMer"     ,"C", 12,2})         // PRECO TOTAL DA MERCADORIA       O    N      12    2  116  127
AADD(_aAE4,{"SitTrib"    ,"C", 01,0})         // SITUACAO TRIBUTARIA FEDERAL     O    A       1    0  128  128

DbCreate(_cArqAE4,_aAE4)
DbUseArea(.T.,,_cArqAE4,"AE4",.F.) 

 
//------------  SEGMENTO AE3v5 - DADOS ADICIONAIS DE COMERCIAL.                 


_cArqAE3  := CriaTrab(NIL,.f.)
_cArqAE3 += ".DBF"
_aAE3 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aAE3,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aAE3,{"IdentFat"   ,"C", 14,0})         // IDENT. LOCAL FATURAMENTO        M    N      14    0    4   17
AADD(_aAE3,{"IdentCob"   ,"C", 14,0})         // IDENT. DO LOCAL DE COBRANCA     M    N      14    0   18   31
AADD(_aAE3,{"IdentEnt"   ,"C", 14,0})         // IDENT. LOCAL DE ENTREGA         M    A      14    0   32   45
AADD(_aAE3,{"IdentTra"   ,"C", 04,0})         // IDENT. TIPO DE TRANSPORTE       O    A       4    0   46   49
AADD(_aAE3,{"Espaco"     ,"C", 30,0})         // Espaco                          M    A      83    0   50  128

DbCreate(_cArqAE3,_aAE3)
DbUseArea(.T.,,_cArqAE3,"AE3",.F.)       
    

//--------------- SEGMENTO TE1v5 - TEXTO LIVRE                          

_cArqTE1  := CriaTrab(NIL,.f.)
_cArqTE1 += ".DBF"
_aTE1 := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aTE1,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aTE1,{"Texto1"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0    4   43
AADD(_aTE1,{"Texto2"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   44   83
AADD(_aTE1,{"Texto3"     ,"C", 40,0})         // TEXTO LIVRE INFORMATIVO         M    A      40    0   84  123
AADD(_aTE1,{"Espaco"     ,"C", 05,0})         // Espaco                          M    A       5    0  124  128

DbCreate(_cArqTE1,_aTE1)
DbUseArea(.T.,,_cArqTE1,"TE1",.F.) 
   

//-------------  SEGMENTO FTPv5 - Segmento Final Mensagem                    
                    
                    
_cArqFTP  := CriaTrab(NIL,.f.)
_cArqFTP += ".DBF"
_aFTP := {}
                                                  // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aFTP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aFTP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    4    8
AADD(_aFTP,{"QtdeSeg"    ,"C", 09,0})         // Quantidade de Segmentos         M    N       9    0    9   17
AADD(_aFTP,{"NumToVl"    ,"C", 17,2})         // Numero Total de Valores         O    N      17    2   18   34
AADD(_aFTP,{"CatOper"    ,"C", 01,0})         // Categoria da Operacao           O    A       1    0   35   35 indica qual o tipo de transacao foi efetuada na conta corrente da empresa. Ex.: d-debito ou c-credito.                   
AADD(_aFTP,{"Espaco"     ,"C", 93,0})         // Espaco                          M    A      93    0   36  128

DbCreate(_cArqFTP,_aFTP)
DbUseArea(.T.,,_cArqFTP,"FTP",.F.) 
  

// ------- Segmento para mostrar no browse -----------

_cArqDBF  := CriaTrab(NIL,.f.)
//_cArqDBF += ".DBF"
_aDBF := {}
                                                  // Nome              
AADD(_aDBF,{"OK"         ,"C", 02,0})         // Identificacao Marca
AADD(_aDBF,{"Nota"       ,"C", 09,0})         //  NUMERO DA NF 
AADD(_aDBF,{"Serie"      ,"C", 02,0})         // SERIE DA NOTA FISCAL 
AADD(_aDBF,{"Dta"        ,"C", 10,0})         // DATA DA NOTA FISCAL 
AADD(_aDBF,{"Prodcli"    ,"C", 15,2})         // Codigo do produto cliente
AADD(_aDBF,{"Prodwhb"    ,"C", 15,2})         // Codigo do produto new hubner
AADD(_aDBF,{"Total"      ,"N", 17,2})         // VALOR TOTAL DA NOTA FISCAL 
AADD(_aDBF,{"Espaco"     ,"C", 63,0})         // ESPACO

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"XDBF",.F.) 
  
INDEX ON XDBF->NOTA TO (_cArqDBF)

Return                                

User Function fLegenda()

Private aCores := {{ "ENABLE"  , "Nota nao Selecionada" },;
                   { "DISABLE" , "Nota Selecionada" }}

BrwLegenda(cCadastro,"Legenda",aCores)

Return

//marca todas as notas
User Function fMarca()

   XDBF->(DbGoTop())
   While !XDBF->(eof())     
      
      RecLock("XDBF")
         XDBF->OK := cMarca
      MsUnlock("XDBF")
      XDBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return

//desmarca todas as notas
User Function fDesMarca()

   XDBF->(DbGoTop())
   While !XDBF->(eof())     
      
      RecLock("XDBF")
         XDBF->OK := "  "
      MsUnlock("XDBF")
      XDBF->(Dbskip())
   Enddo   
   MarkBRefresh()
Return
                                   
