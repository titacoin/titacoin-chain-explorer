<!--#include file="header.asp"-->
<%
bError=false
hash=SanitizeHTML(Request.Querystring("hash"))
if isnumeric(hash) then
	height=int(hash)
	if height>0 then
		hash=GetHashByHeight(height)
	else
		bError=false
	end if
end if

output=goJsonWork("f_block_json",hash)
if instr(output,"Failed to parse hex")>0 or bError then
	Response.Write("Blok Not Found. Check your valid hash or height.")
else

	if instr(output,",""transactions"":")>0 then
		arJsTx1=split(output,",""transactions"":")
		arJsTx2=split(output,"],""transactions")
		arJsTx=split(arJsTx1(1),"],""transactions")
		output=arJsTx1(0)&",""transactions"&arJsTx2(1)
		outputTx=replace(arJsTx(0),"[","")
	end if
	'response.write output
	'response.write outputTx



	jsonString=prepareForBlock(output)
	'response.write jsonString
	set oJson__1 = New JSONobject
	oJson__1.Parse(jsonString)
	nextBlock=findNextBlock(oJson__1.value("height"))
	if nextBlock="-" then
		bNextBlock=false
	else
		bNextBlock=true
	end if
%>
<div class="row ">
		
		<div class="col-lg-12" style="text-overflow: ellipsis; overflow-x:hidden;">
			<h3 class="page-header">
			<i class="fa fa-cube fa-fw"></i> Block  <a href="<%=oJson__1.value("prev_hash")%>"><small><i class="fa fa-chevron-left"></i></small></a>&nbsp;<%=oJson__1.value("height")%>&nbsp;<%if bNextBlock then%><a href="<%=nextBlock%>"><small><i class="fa fa-chevron-right"></i></small>
			</a><%end if%><small><%=oJson__1.value("hash")%></small>
			</h3>
		</div>
		
		<div class="row">
                <div class="col-sm-6">
			<ul class="list-group">
				<li class="list-group-item">
					<i class="fa fa-arrows-v fa-fw"></i> Height
					<span class="pull-right text-muted small"><em><%=oJson__1.value("height")%></em></span>
				</li>
				<li class="list-group-item">
					<i class="fa fa-clock-o fa-fw"></i> Timestamp
					<span class="pull-right text-muted small"><em><%=oJson__1.value("timestamp")%></em></span>
				</li>
					<li class="list-group-item">
					<i class="fa fa-database fa-fw"></i> Difficulty
					<span class="pull-right text-muted small"><em><%=oJson__1.value("difficulty")%></em></span>
				</li>
				
				<li class="list-group-item">
						<i class="fa fa-arrows-h fa-fw"></i> Block size (bytes)
						<span class="pull-right text-muted small"><em><%=oJson__1.value("blockSize")%></em></span>
				</li>
				
			
				
				
			</ul>
		</div>
		<div class="col-sm-6">
			<ul class="list-group">
				
				
				
				<li class="list-group-item">
						<i class="fa fa-arrows-h fa-fw"></i> Total Generated Coins
						<span class="pull-right text-muted small"><em><%=oJson__1.value("baseReward")%></em></span>
				</li>
 
				<li class="list-group-item">
					<i class="fa fa-exchange fa-fw"></i> Transactions
					<span class="pull-right text-muted small"><em>-fixme-</em></span>
				</li>

				<li class="list-group-item">
					<i class="fa fa-money fa-fw"></i> Total Fee Amount
					<span class="pull-right text-muted small"><em><%=oJson__1.value("totalFeeAmount")%></em></span>
				</li>

			</ul>
                </div>
	</div>
	
	
	<%
	
	
	outputTx=fixAmountsForTx(outputTx)
	Response.write outputTx
	set oJson__1 = New JSONobject
	oJson__1.Parse(outputTx)
	
	%>
	
	
	<div class="row">
        <!-- /.col-lg-4 --> 
		<div class="col-sm-12">
	       	        <div class="panel panel-primary">
               	        	<div class="panel-heading large">
                       			Coinbase Transaction
	        	        </div>
        		 </div>
			<div class="panel panel-default panel-table">
                        	<div class="panel-heading">
                	               	<div class="row">
        	                               	<div class="col-xs-2 col-sm-6 col-md-7 hash-header">Hash</div>
		                                <div class="col-xs-6 col-sm-3 col-md-4">Amount</div>
        	                               	<div class="col-xs-1 col-sm-1 col-md-1">Bytes</div>
                	               	</div>
                        	</div>
					                       	<div class="panel-body">
        	               		<div class="row show-grid top-row">
						
        	        	               	<div class="col-xs-2 col-sm-6 col-md-7 hash">
                	                        	<a href="/tx/<%=oJson__1.value("hash")%>"><%=oJson__1.value("hash")%>         </a>               	       		</div>
	                       			<div class="col-xs-6 col-sm-3 col-md-4"><%=oJson__1.value("amount_out")%></div>
        	                		<div class="col-xs-1 col-sm-1 col-md-1"><%=oJson__1.value("size")%> </div>
	                        	</div>
				</div>
			</div>
		</div>
                <!-- /.col-lg-4 -->
 	
	</div>
</div>
<%end if%>
<!--#include file="footer.asp"-->