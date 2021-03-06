/*                                                   
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCFG003  �Autor  �Marcos R Roquitski  � Data �  18/04/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Manutencao no Cadastro de Usuarios X Grupos(cadastro de    ���
���          � produtos).                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function NhCfg003()

SetPrvt("cCadastro,aRotina,Local _Login, _Grupo, _LocalPad, _Desc, _Cod")

cCadastro := 'Cadastro de Usuarios X Grupos'
aRotina := {{ "Pesquisa"   ,"AxPesqui"      , 0 , 1},;
            { "Visualizar" ,"AxVisual"      , 0 , 2},;
            { "Incluir"    ,"U_ManUser(1)"  , 0 , 3},;
            { "Alterar"    ,"U_ManUser(2)"  , 0 , 4},; 
            { "Duplica"    ,"U_CFG3DUPL()"  , 0 , 3},;
            { "Inc.V�rios" ,"U_IncVar()"    , 0 , 3},;
            { "Excluir"    ,"AxDeleta"      , 0 , 5},;
            { "Corrige"    ,"U_ManUser(3)"      , 0 , 3}}

DbSelectArea("SX5")
Set filter to SX5->X5_TABELA = 'ZU'
SX5->(DbGotop())
mBrowse(06,01,22,75,"SX5",,,,,,)
Set Filter to 
SX5->(DbGotop())

Return

User Function ManUser(pOpcao)

If pOpcao == 1 // Inclusao
	_Login := Space(15)
	_Grupo := Space(04)
	_LocalPad := Space(02)
	_Desc := Space(30)
ElseIf pOpcao == 3 // Corrige
	Processa({|| fCorrige() },'Corrigindo...')
	Return
Else
	_Login := Substr(SX5->X5_DESCRI,01,15)
	_Grupo := Alltrim(Substr(SX5->X5_DESCRI,16,4))
	_LocalPad := Substr(SX5->X5_DESCRI,20,2)
	_Desc := Space(30)
	BuscaGrupo()
Endif	

@ 200,050 To 400,600 Dialog DlgTabela Title OemToAnsi("Cadastro Usuarios X Grupos")

@ 010,020 Say OemToAnsi("Login         ") Size 35,8
@ 025,020 Say OemToAnsi("Grupo         ") Size 35,8
@ 040,020 Say OemToAnsi("Local Padrao  ") Size 35,8
If pOpcao == 1
	@ 009,070 Get _Login     PICTURE "@!" F3 "QUS" Size 55,8
Else
	@ 009,070 Get _Login     PICTURE "@!" When .F. Size 55,8
Endif
@ 026,070 Get _Grupo     PICTURE "@!" F3 "SBM" Valid BuscaGrupo(1) Size 45,8
@ 026,115 Get _Desc      PICTURE "@!" When .F. Size 120,8
@ 041,070 Get _LocalPad  PICTURE "@!" F3 "ALM" Size 20,8
      
@ 075,070 BMPBUTTON TYPE 01 ACTION GravaDados(pOpcao,.t.)
@ 075,110 BMPBUTTON TYPE 02 ACTION Close(DlgTabela)
Activate Dialog DlgTabela CENTERED

Return

Static Function BuscaGrupo(pGrupo)
Local lRet := .T.
SBM->(DbSeek(xFilial("SBM") + _Grupo))
If SBM->(Found())
	_Desc := SBM->BM_DESC
Elseif pGrupo == 1
	lRet := .F.
	_Desc := Space(30)
	MsgBox("Grupo nao pertence ao cadastro !","Grupos","ALERT")
Endif
Return(lRet)	


Static Function GravaDados(pOpcao,lMsg)
_Cod := 0

If Empty(_Login) .Or. Empty(_Grupo)
	MsgBox("Login ou Grupo estao com dados em branco Corrija !","Grupos","ALERT")
	Close(DlgTabela)
	Return
Endif
        
cDescri := Subs(AllTrim(_Login)+Replicate(" ",10),1,15) + AllTrim(_Grupo) + _LocalPad
    
If pOpcao == 1 
	SX5->(Dbgotop())
	While !SX5->(Eof())
		If SX5->X5_TABELA  == "ZU" .AND. Val(SX5->X5_CHAVE) > _Cod
			_Cod := Val(SX5->X5_CHAVE)
		Endif
		SX5->(DbSkip())
	Enddo
	
	If Alltrim(Str(_Cod +1))$"***"
		If lMsg
			Alert('Erro, c�digo igual a ***!')
		Endif
		return
	EndIf

	//-- validacao para nao incluir duplicados
	cAl := getnextalias()
	
	beginSql Alias cAl
		SELECT X5_DESCRI 
		FROM %Table:SX5%
		WHERE X5_DESCRI = %Exp:cDescri%
		AND X5_TABELA = 'ZU'
		AND %NotDel%
	endSql
	
	If (cAl)->(!eof())
		
		If lMsg
			Alert('J� existe!')
		Endif
		
		(cAl)->(dbclosearea())
		return
	EndIf

	(cAl)->(dbclosearea())	
	//-- fim validacao duplicados
	
	RecLock("SX5",.T.)
		SX5->X5_TABELA  := "ZU"
		SX5->X5_CHAVE   := Alltrim(Str(_Cod +1))
		SX5->X5_DESCRI  := cDescri
		SX5->X5_DESCSPA := cDescri
		SX5->X5_DESCENG := cDescri
	MsUnLock("SX5")

	Close(DlgTabela)
	
Else

	RecLock("SX5",.F.)
		SX5->X5_DESCRI  := cDescri
		SX5->X5_DESCSPA := cDescri
		SX5->X5_DESCENG := cDescri
	MsUnLock("SX5")

	Close(DlgTabela)

Endif

User Function CFG3DUPL()

_LoginOri := space(15)
_LoginDes := space(15)

@ 200,050 To 400,600 Dialog DlgTabela Title OemToAnsi("Cadastro Usuarios X Grupos")

@ 010,020 Say OemToAnsi("Login Origem  ") Size 35,8
@ 025,020 Say OemToAnsi("Login Destino ") Size 35,8
@ 009,070 Get _LoginOri  PICTURE "@!" F3 "QUS" Size 55,8
@ 026,070 Get _LoginDes  PICTURE "@!" F3 "QUS" Size 55,8
      
@ 075,070 BMPBUTTON TYPE 01 ACTION GrvDupl()
@ 075,110 BMPBUTTON TYPE 02 ACTION Close(DlgTabela)

Activate Dialog DlgTabela CENTERED

Return

Static Function GrvDupl()
	If !msgyesno('Duplicar os acessos de grupo do usu�rio '+alltrim(_LoginOri)+' para '+alltrim(_LoginDes)+'?')
		Close(DlgTabela)
		return
	Endif

	Processa({||Grv2Dupl()},'Copiando...')
Return

Static Function Grv2Dupl()

	cAl2 := getnextalias()
	
	_LoginOri := Subs(AllTrim(_LoginOri)+Replicate(" ",10),1,15)
	
	beginSql Alias cAl2
		SELECT X5_DESCRI 
		FROM %Table:SX5%
		WHERE SUBSTRING(X5_DESCRI,1,15) = %Exp:_LoginOri%
		AND X5_FILIAL = %xFilial:SZU%
		AND X5_TABELA = 'ZU'
		AND %NotDel%
	endSql
	
	ProcRegua(0)
	
	While (cAl2)->(!eof())
	    
   		_Login := _LoginDes
		_Grupo := Substr( (cAl2)->X5_DESCRI , 16,4 )
		_LocalPad := Substr( (cAl2)->X5_DESCRI , 20,2 )
	
		IncProc(_Grupo)
		    
		GravaDados(1,.f.) //INCLUI
		
		(cAl2)->(dbskip())
	Enddo

	Close(DlgTabela)
	
	alert('Copiado com sucesso!')
	
Return 

//�������������������Ŀ
//� CORRIGE DUPLICADOS�
//���������������������
Static Function fCorrige()
Local aMat := {}
local count := 0

DBSELECTAREA('SX5')
SET FILTER TO SX5->X5_TABELA = 'ZU'
	
	Procregua(SX5->(RECCOUNT()))
	
	While SX5->(!eof()) .AND. SX5->X5_TABELA=='ZU'
	    
		IncProc()
		
		_n := aScan(aMat,{|x| x==SX5->X5_FILIAL+Substr(SX5->X5_DESCRI,1,19)})
		
		If _n==0
			aAdd(aMat,SX5->X5_FILIAL+Substr(SX5->X5_DESCRI,1,19))
		Else
			Reclock('SX5',.F.)
				dbdelete()
			Msunlock('SX5')
			count++
		Endif

		SX5->(dbskip())
	Enddo
	
	Alert(alltrim(str(count))+' duplicados excluidos!')	

Return

//�������������������������������������������������<�
//�Fun��o para inclur mais de um grupo por usu�rio.�
//�By Jos� Henrique Medeiros Felipetto.            �
//�������������������������������������������������<�
/*
User Function IncVarios()
SetPrvt("cMarca,_aDBF,_cArqDBF,aCampos,cCadastro,aRotina,oDlgLocalNF,oDlgParamNF,cAl,_dData,_dDataA,aOldRotina,_cLogin,oDlg,_cDeGr,_cAteGr")
aOldRotina := aRotina

getLogin()

cAl := getNextAlias()
cMarca := GetMark()
cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarcavk()' , 0 , 4 },;
             {"Desmarca Tudo" ,'U_fDesmarvk()', 0 , 1 },;
             {"Legenda"       ,'U_fLegVoks()' , 0 , 1 },;
             {"Encerrar"      ,'U_fEncerra()' , 0 , 1 } }

// Cria Campos para mostrar no Browser
_cArqDBF := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aDBF    := {}

AADD(_aDBF,{"OK"         ,"C", 02,0})
AADD(_aDBF,{"Login"      ,"C", 15,0})
AADD(_aDBF,{"Grupo"      ,"C", 06,0})
AADD(_aDBF,{"Desc"       ,"C", 40,0})

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.)

aCampos := {}
Aadd(aCampos,{"OK"        ,"C", "  "    	,"@!"	 	  })
Aadd(aCampos,{"Login"     ,"C", "Login" 	,"@!"		  })
Aadd(aCampos,{"Grupo"     ,"C", "Grupo" 	,"@!"		  })
Aadd(aCampos,{"Desc"      ,"C", "Descri��o" ,"@!"		  })

beginSql Alias cAl
	SELECT BM_GRUPO,BM_DESC 
	FROM   %TABLE:SBM%
	WHERE  BM_FILIAL = %xFilial:SBM%
	AND    BM_GRUPO BETWEEN %Exp:_cDeGr% AND %Exp:_cAteGr%
	AND   %notDel%
EndSql

While (cAl)->(!Eof() )
	RecLock("DBF",.T.)
		DBF->OK    		:= ""
		DBF->Login  	:= _cLogin
		DBF->Grupo 		:= (cAl)->BM_GRUPO
		DBF->Desc 		:= (cAl)->BM_DESC
	MsUnLock("DBF")
	(cAl)->(DbSkip() )
EndDo
(cAl)->(DbCloseArea() )

DBF->(DbGoTop() )
MarkBrow("DBF","OK" ,"DBF->OK",aCampos,,cMarca)

GravaVGru(_cLogin)


aRotina := aOldRotina
Return

Static Function getLogin()
_cLogin := space(15)
_cDeGr := space(len(SBM->BM_GRUPO))
_cAteGr := space(len(SBM->BM_GRUPO))

oDlg  := MsDialog():New(0,0,180,260,"Incluir v�rios grupos",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay2 := TSay():New(08,10,{||"Login:"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(06,50,{|u| if(Pcount() > 0, _cLogin := u,_cLogin)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"QUS","_cLogin")
	
	oSay3 := TSay():New(28,10,{||"de Grupo:"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(26,50,{|u| if(Pcount() > 0, _cDeGr := u,_cDeGr)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"SBM","_cDeGr")
	
	oSay4 := TSay():New(48,10,{||"at� Grupo:"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(46,50,{|u| if(Pcount() > 0, _cAteGr := u,_cAteGr)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"SBM","_cAteGr")	
	
	oBtn := tButton():New(66,50,"Ok",oDlg,{|| oDlg:End() } ,60,10,,,,.T.)					
					
oDlg:Activate(,,,.t.,{||.T.},,)
Return

Static Function GravaVGru(Login)
Local lCont := .F.
_cCod := 0

SX5->(Dbgotop())
While !SX5->(Eof())
	If SX5->X5_TABELA  == "ZU" .AND. Val(SX5->X5_CHAVE) > _cCod
		_cCod := Val(SX5->X5_CHAVE)
	Endif
	SX5->(DbSkip())
Enddo

While DBF->(!EOF() ) 
	If !EMPTY(DBF->OK)
		RecLock("SX5",.T.)
			SX5->X5_TABELA  := "ZU"
			SX5->X5_CHAVE   := Alltrim(Str(_cCod +1))
			SX5->X5_DESCRI  := Subs(AllTrim(_Login)+Replicate(" ",10),1,15) + AllTrim(DBF->GRUPO)
			SX5->X5_DESCSPA := Subs(AllTrim(_Login)+Replicate(" ",10),1,15) + AllTrim(DBF->GRUPO)
			SX5->X5_DESCENG := Subs(AllTrim(_Login)+Replicate(" ",10),1,15) + AllTrim(DBF->GRUPO)
		MsUnLock("SX5")
		lCont := .T.	
	EndIf
	DBF->(DbSkip() )
EndDo
If lCont
	MsgInfo("Grupos cadastrados com sucesso!")
EndIf

Return*/
