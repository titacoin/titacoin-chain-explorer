<!--#include file="static.asp"-->
<!--#include file="jsonObject.class.asp"-->
<%
Function goJsonWork(work,order)
	strJson=""
	set oJson = New JSONobject
	
	oJson.Add "jsonrpc", "2.0"
	oJson.Add "id", "test"
	if work="f_blocks_list_json" then
		strJson = toJson(preJson("""method"": ""f_blocks_list_json"", ""params"": { ""height"": "&order&" }"))
	elseif work="f_get_blockchain_settings" then
		oJson.Add "method", "f_get_blockchain_settings"
		strJson = oJson.Serialize()
	elseif work="f_block_json" then
		strJson = toJson(preJson("""method"": ""f_block_json"", ""params"": { ""hash"": """&order&""" } "))
	elseif work="getblockheaderbyhash" then
		strJson = toJson(preJson("""method"": ""getblockheaderbyhash"", ""params"": { ""hash"": """&order&""" } "))
	elseif work="getblockheaderbyheight" then
		strJson = toJson(preJson("""method"": ""getblockheaderbyheight"", ""params"": { ""height"": "&order&" } "))
	elseif work="getcurrencyId" then
		strJson = toJson(preJson("""method"": ""getcurrencyId"" "))
	elseif work="getlastblockheader" then
		strJson = toJson(preJson("""method"": ""getlastblockheader"" "))
	elseif work="getblockhash" then
		strJson = toJson(preJson("""method"": ""on_getblockhash"" }, { ""params"": { ""height"": "&order&" } ")) 'fix me - this has bugs
	elseif work="getblockcount" then
		strJson = toJson(preJson("""method"": ""getblockcount"" "))
	end if
	
	'response.write strJson&"<br/><br/>"
	out=ASPPostJSON(jsonRpcFullURL&"/json_rpc",strJson)
	goJsonWork=out
	'Response.Write out
end Function

function findNextBlock(currentHeight)

	findNextBlock=GetHashByHeight(currentHeight+1)
	
end Function

function GetBlockSizeByHeight(iHeight)
	output=goJsonWork("f_blocks_list_json",iHeight)
	if instr(output,"Failed")>0 or  instr(output,"To big height")>0 then
		GetBlockSizeByHeight="0"
	else
		GetBlockSizeByHeight=prepareForBlockSize(output)
	end if
end function

function GetHashByHeight(iHeight)
	output=goJsonWork("getblockheaderbyheight",iHeight)
	if instr(output,"Failed")>0 or  instr(output,"To big height")>0 then
		GetHashByHeight="-"
	else
		jsonString=prepareForBlock(output)
		set oJson_ = New JSONobject
		oJson_.Parse(jsonString)
		GetHashByHeight=oJson_.value("hash")
	end if
end function

function preJson(strData)
	preJson = " { ""jsonrpc"": ""2.0"", ""id"": ""tita01"", "& strData & " }"
End Function

Function toJson(strData)

	set jParser = New JSONobject ' double double quotes here because of the VBScript quotes scaping
	jsonString = strData
	jParser.Parse(jsonString)
	toJson=jParser.Serialize() ' outputs: '{"strings":"valorTexto","numbers":123.456,"arrays":[1,"2",3.4,[5,6,[7,8]]]}'

end Function

Function ASPGet(url)
	'declare a variable
	Dim objXmlHttp

	Set objXmlHttp = Server.CreateObject("Microsoft.XMLHTTP")

	'If the API needs userName and Password authentication then pass the values here
	objXmlHttp.Open "GET", url, False
	objXmlHttp.Send
	
	If objXmlHttp.Status = 200 Then
		ASPGet = CStr(objXmlHttp.ResponseText)
	else
		ASPGet = "Error : HttpStatus "&objXmlHttp.Status&" "
	end if

	'return the response from the API server
	'Response.write(ASPGet)
	Set objXmlHttp = Nothing
	
end Function

Function ASPPostJSON(url,json)

	'declare a variable
	Dim objXmlHttp

	Set objXmlHttp = Server.CreateObject("Microsoft.XMLHTTP")

	'If the API needs userName and Password authentication then pass the values here
	objXmlHttp.Open "POST", url, False
	objXmlHttp.SetRequestHeader "Content-Type", "application/json"
	objXmlHttp.SetRequestHeader "User-Agent", "block-explorer-on-rpc/1.0"

	'send the json string to the API server
	objXmlHttp.Send json

	If objXmlHttp.Status = 200 Then
		ASPPostJSON = CStr(objXmlHttp.ResponseText)
	else
		ASPPostJSON = "Error : HttpStatus "&objXmlHttp.Status&" "
	end if

	'return the response from the API server
	'Response.write(ASPPostJSON)
	Set objXmlHttp = Nothing

End Function


function getLastHeight()
	jsonString=ASPGet(jsonRpcFullURL&"/getheight")
	set oJson_ = New JSONobject
	oJson_.Parse(jsonString)
	getLastHeight=int(oJson_.value("height"))-1
end Function

function updateLastHeight(newHeight)
	update=false
	if isnumeric(newHeight) then
		update=True
		
		if newHeight>0 then
			update=True
		else
			update=false
		end if

	End if
	
	if update then
		dim fs,f
		set fs=Server.CreateObject("Scripting.FileSystemObject")
		set f=fs.CreateTextFile(DBPATH_LastHeight,true)
		f.WriteLine(newHeight)
		f.Close
		set f=nothing
		set fs=nothing
	end if
end function

Function prepareForList(strData)
	arFstrData=split(strData,"{""blocks"":[")
	arLstrData=split(arFstrData(1),"],""status""")
	strData=arLstrData(0)
	ar__StrData=split(strData,"},{")
	iCount=int(Ubound(ar__StrData))
	Dim arForJson()
	
	for i=0 to iCount
		if i=0 then
			ReDim arForJson(0)
		end if
		str__Data= "{"&ar__StrData(i)&"}"
		arForJson(i) = str__Data
		ReDim  PreServe arForJson(i+1)
	Next
	
	prepareForList=arForJson
end Function

Function prepareForBlockSize(strData)
	'response.write strData
	arFstrData1=split(strData,",""hash""")
	arLstrData1=split(arFstrData1(0),"cumul_size"":")
	strData=arLstrData1(1)
	prepareForBlockSize=strData
end function

Function prepareForBlock(strData)
	if instr(strData,"{""block_header"":")>0 then
		arFstrData1=split(strData,"{""block_header"":")
	elseif instr(strData,"{""block"":")>0 then
		arFstrData1=split(strData,"{""block"":")
	end if
	arLstrData1=split(arFstrData1(1),",""status""")
	strData=arLstrData1(0)
	prepareForBlock=strData
end function

function SanitizeHTML(strTextToStrip)
	'regEx initialization
	Dim regEx
	set regEx = New RegExp  'Creates a regexp object
	regEx.IgnoreCase = True 'Set case sensitivity
	regEx.Global = True     'Global applicability

	regEx.Pattern = "<[^>]*>" 'Remove all HTML
	strTextToStrip = regEx.Replace(strTextToStrip, " ")
	SanitizeHTML=strTextToStrip
end function

function fixAmountsForTx(strData)
	strData=replace(strData,"amount_out"":","amount_out"": """)
	strData=replace(strData,",""fee"":",""",""fee"":""")
	strData=replace(strData,",""hash"":",""",""hash"":")
	fixAmountsForTx=strData
end Function
%>