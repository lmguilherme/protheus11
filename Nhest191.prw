/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST191  �Autor  �Marcos R. Roquitski � Data �  08/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail apos exclusao da Nota Fiscal de Entrada.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhest191()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
QAA->(DbSetOrder(6))
SC1->(DbSetOrder(1))
lEnd := .F.   
e_email = .F.                         

fEnviaEmail()

Return(.t.)


Static Function fEnviaEmail()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)

	lRet      := .F.
	_cMail    := "" 
	_cMail    := Iif(SM0->M0_CODIGO$"IT","fiscal@itesapar.com.br","lista-fiscal@whbbrasil.com.br")
	_cNome    := "Nota Fiscal: " + SF1->F1_DOC 
	_cSerie   := "Serie......: " + SF1->F1_SERIE 
	_cForne   := "Fornecedor.: " + SF1->F1_FORNECE + ' '+SF1->F1_LOJA + ' - '+SA2->A2_NOME
	_dEmissao := "Digitacao..: " + Dtoc(SF1->F1_DTDIGIT)
	e_email = .T.                                   

	If !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'
        
		cMsg += '</head>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">** Nota Fiscal Excluida:</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

	    cMsg += '<tr>'
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
	    cMsg += '<tr>'
	    cMsg += '<b><font size="4" face="Courier">' + _cSerie + '</font></b>' + CRLF
	    cMsg += '<tr>'
	    cMsg += '<b><font size="4" face="Courier">' + _cForne + '</font></b>' + CRLF
	    cMsg += '<tr>'
	    cMsg += '<b><font size="4" face="Courier">' + _dEmissao + '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

	    cMsg += '<b><font size="4" face="Courier">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + "Depto Fiscal"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF
		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			SUBJECT 'Exclusao de Nota Fiscal';
			BODY cMsg;
			RESULT lEnviado
			If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
	    	Endif
		Else
			Alert("Erro ao se conectar no servidor: " + cServer)		
		Endif
		lRet := .F.
	Endif	
	ZRA->(DbSkip())


Return(.T.)