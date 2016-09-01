          <div class="row">
                <div class="col-xs-12 col-lg-12">
                    <h3 class="page-header"><i class="fa fa-chain fa-fw"></i> Latest blocks</h3>
                    <div class="col-xs-12" id="previous-blocks" >
			<!--
			disable
			<span class="pull-right"><a href="/browser/blocks/1126488"><small>Previous blocks >></small></a></span>
			-->
                    </div>
                </div>
            </div>
            <!-- /.row -->

            <div class="row">
                <!-- /.col-lg-8 -->
                <div class="col-xs-12 col-lg-12">
                    <div class="panel panel-default panel-table">
                        <div class="panel-heading">
                            <div class="row ">
								<div class="col-xs-3 col-sm-1 col-md-1 first-column">Height</div>
								<div class="col-xs-2 col-sm-1 col-md-1">Size</div>
								<div class="col-xs-2 col-sm-1 col-md-1">Tx</div>
								<div class="col-xs-5 col-sm-3 col-md-2">Timestamp</div>
								<div class="col-xs-12 col-sm-6 col-md-2 hash-header" >Block Hash</div>
                            </div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
						<%
						iLastHeight=getLastHeight()
						output=goJsonWork("f_blocks_list_json",iLastHeight)
						strList=output
						arJsonList=prepareForList(strList)
						for y=0 to ubound(arJsonList)-1
							set oJson_ = New JSONobject
							oJson_.Parse(arJsonList(y))
						%>
							<div class="row show-grid top-row">
								<a href="block/1126538"></a>
								<div class="col-xs-3 col-sm-1 col-md-1"><strong class="primary-font"><%=oJson_.value("height")%></strong></div>
								<div class="col-xs-2 col-sm-1 col-md-1"><%=oJson_.value("cumul_size")%></div>
								<div class="col-xs-2 col-sm-1 col-md-1"><%=oJson_.value("tx_count")%></div>
								<div class="col-xs-5 col-sm-3 col-md-2"><%=oJson_.value("timestamp")%></div>
                                <div class="col-xs-12 col-sm-6 col-md-7 hash"><a href="block/<%=oJson_.value("hash")%>"><%=oJson_.value("hash")%></a></div>
                           	 </div>
						<%next%>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                     <!-- /.panel -->
                </div>
                <!-- /.col-lg-4 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->
    </div>
    <!-- /#wrapper -->