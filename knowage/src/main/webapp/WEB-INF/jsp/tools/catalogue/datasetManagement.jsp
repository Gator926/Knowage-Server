<%--
Knowage, Open Source Business Intelligence suite
Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.

Knowage is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

Knowage is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--%>

<%@ page language="java" pageEncoding="utf-8" session="true"%>

<%-- ---------------------------------------------------------------------- --%>
<%-- JAVA IMPORTS															--%>
<%-- ---------------------------------------------------------------------- --%>
<%@page import="it.eng.spagobi.tools.dataset.service.SelfServiceDatasetAction" %>
<%@page import="java.util.Map" %>
<%@page import="org.json.JSONObject"%>
<%@include file="/WEB-INF/jsp/commons/angular/angularResource.jspf"%>
<%  
  SelfServiceDatasetAction ssa= new SelfServiceDatasetAction();
  Map<String,String> parameters= ssa.getParameters((UserProfile)userProfile,locale);
  JSONObject selfServiceParameters=new JSONObject(parameters);
  boolean isAdmin = UserUtilities.isAdministrator(userProfile);
  boolean isTechnicalUser =  UserUtilities.isTechnicalUser(userProfile);
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="datasetModule">
	
	<head>
	
		<%@include file="/WEB-INF/jsp/commons/angular/angularImport.jsp"%>
			
		<link rel="stylesheet" type="text/css" href="<%=urlBuilder.getResourceLink(request, "themes/commons/css/customStyle.css")%>">
		
		<script type="text/javascript"
			src="${pageContext.request.contextPath}/js/src/angular_1.4/tools/catalogues/datasetManagement.js"></script>
		
		<script language="javascript" type="text/javascript">		   
		   var datasetParameters=<%=selfServiceParameters%>;
		   var isAdmin =<%=isAdmin%>;
		   var isTechnicalUser = <%=isTechnicalUser%>;
		</script>
		
		<!-- Codemirror -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/lib/codemirror.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/theme/eclipse.css">  
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/lib/codemirror.js"></script>  
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/lib/angular/codemirror/ui-codemirror.js"></script> 
		<link rel="stylesheet" href="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/addon/hint/show-hint.css" />
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/addon/hint/show-hint.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/addon/hint/sql-hint.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/mode/javascript/javascript.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/mode/groovy/groovy.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/mode/sql/sql.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/addon/selection/mark-selection.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/angular/codemirror/CodeMirror-master/addon/display/autorefresh.js"></script>
		
		<!-- CRON for Dataset Scheduling -->
		<script src="${pageContext.request.contextPath}/js/lib/prettyCron/prettycron.js"></script>
		<script src="${pageContext.request.contextPath}/js/lib/prettyCron/later.js"></script> 	
		<script src="${pageContext.request.contextPath}/js/lib/prettyCron/moment-with-locales.js"></script>

		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		
		<title>Dataset Catalogue</title>
		
		<script>
			var globalQbeJson = "";
		</script> 
		
	</head>
	
	<body ng-controller="datasetController" class="bodyStyle kn-rolesManagement kn-datasetmanagement" style="overflow-y:hidden;">
	
		<!-- 
			The progress circular animation will be shown whenever the REST calls are in progress (before the getting of the response).
			@commentBy Danilo Ristovski (danristo, danilo.ristovski@mht.net) 
		-->					
		<div loading ng-show="showEl" style="position:fixed; z-index:500; height:100%; width:100%; background-color:black; opacity:0.5;">
		 	<md-progress-circular md-mode="indeterminate" md-diameter="75%" style="position:fixed; top:calc(50% - 37.5px); left:calc(50% - 37.5px);"></md-progress-circular>		 
		</div>			
	
		<angular-list-detail>
	       
	       	<list label="translate.load('sbi.roles.datasets')"  new-function="createNewDataSet">
	       
		       	<angular-table
			     	flex
				 	id="datasetList_id" 
				 	ng-model="datasetsListTemp"
					columns=dataSetListColumns
					show-search-bar=true 
					highlights-selected-item=true
					click-function="loadDataSet(item,index)"
					selected-item="selectedDataSetInit" 
					sortable-column="sortableColumn"
					speed-menu-option="manageDataset"
					current-page-number=datasetTableLastPage
					total-item-count=numOfDs
					page-changed-function="changeDatasetPage(itemsPerPage, currentPageNumber)"
					search-function="datasetLike(searchValue, itemsPerPage, currentPageNumber, columnsSearch, columnOrdering, reverseOrdering)"
					 >
				</angular-table> 
	       	</list>
	       
      		<extra-button>

	      		<!-- ADDITIONAL BUTTONS -->
	      		<div style="float:left;" >
	      			
	      			<!-- FIELDS METADATA BUTTON -->
	      			<md-button aria-label="menu" class="md-fab md-raised md-mini md-warn" 
	      					ng-show="selectedDataSet" title="Fields metadata" ng-click="openFieldsMetadata()">
		            	<!-- FM -->
		            	<md-icon md-font-icon="fa fa-magic" ></md-icon>
		          	</md-button>
		          	
		          	<!-- LINK DATASET BUTTON (visible only in Advanced tab) -->
		          	<md-button aria-label="menu" class="md-fab md-raised md-mini md-warn" 
		          			ng-show="selectedDataSet && selectedTab==2" title="Link dataset" ng-click="openLinkDataset()">
		            	<!-- LD -->
		            	<md-icon md-font-icon="fa fa-link" ></md-icon>		            	
		          	</md-button>
		          	
		          	<!-- SAVE WITHOUT METADATA BUTTON -->
		          	<md-button aria-label="menu" class="md-fab md-raised md-mini md-warn" 
		          			ng-show="selectedDataSet" title="Save without metadata" ng-click="saveWithoutMetadata()">
		            	<!-- SWM -->
		            	<md-icon md-font-icon="fa fa-hourglass-start"></md-icon>
		          	</md-button>
		          	
		          	<!-- AVAILABLE PROFILE ATTRIBUTES BUTTON (visible only in Type tab) -->
		          	<md-button aria-label="menu" class="md-fab md-raised md-mini md-warn" 
		          			ng-show="selectedDataSet && selectedTab==1" title="Available profile attributes" ng-click="openAvaliableProfileAttributes()">
		            	<!-- APA -->
	            		<md-icon md-font-icon="fa fa-user" ></md-icon>		            	
		          	</md-button> 		          	            
		          	
		          	<!-- HELP BUTTON -->
		          	<md-button aria-label="menu" class="md-fab md-raised md-mini md-warn" 
		          			ng-show="selectedDataSet!=null && selectedTab && selectedTab>0" title="Help" ng-click="openHelp()">
		            	<!-- H -->
	            		<md-icon md-font-icon="fa fa-question-circle"></md-icon>			            	
		          	</md-button>
		          	
	      		</div> 
		      
			</extra-button>
	       
	       <!-- DATASET DETAIL PANEL -->
	       <detail 	preview-function="checkIfDataSetHasParameters" save-function="saveDataset" cancel-function="closeDatasetDetails" 
	       			show-save-button="showSaveAndCancelButtons" show-cancel-button="showSaveAndCancelButtons" 
	       			disable-save-button="!datasetForm.$valid" 
	       			extra-functions='[
	       			{"name":"test","showOn":showSaveAndCancelButtons,"function":"test"},
	       			{"name":"test2","showOn":showSaveAndCancelButtons}]'>
	       
	       		<form name=datasetForm ng-show="selectedDataSet!=null" style="height:100%; overflow-y:hidden">
	       		
	       			 <!-- DATASET DETAIL PANEL TABS -->
	       			 <md-tabs md-selected="selectedTab" md-border-bottom="" style="min-height:100%">
						     
						 <!-- DATASET DETAIL PANEL "DETAIL" TAB -->            			
						 <md-tab label='{{translate.load("sbi.generic.details");}}' ng-click="changeSelectedTab(0)">
						 
						 	<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" >
								
								<md-card layout-padding>
									
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.label")}}</label>
											<input ng-model="selectedDataSet.label" ng-required="true" ng-change="setFormDirty()">
											<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.label">
		       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
       						 				</div>
										</md-input-container>
									</div>
									
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.name")}}</label>
											<input ng-model="selectedDataSet.name" ng-required="true" ng-change="setFormDirty()">
											<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.name">
		       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
       						 				</div>
										</md-input-container>
									</div>
									
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.description")}}</label>
											<textarea 	ng-model="selectedDataSet.description" md-maxlength="150" rows="3" 
														md-select-on-focus ng-change="setFormDirty()"></textarea>
										</md-input-container>
									</div>
									
									<div flex=100>
								       <md-input-container class="md-block" > 
								       		<label>{{translate.load("sbi.ds.scope")}}</label>
									       	<md-select placeholder ="{{translate.load('sbi.ds.scope')}}"
									        	ng-required = "true" ng-change="changeDatasetScope(); setFormDirty()"
									        	ng-model="selectedDataSet.scopeCd">   
									        	<md-option ng-repeat="l in scopeList" value="{{l.VALUE_CD}}">{{l.VALUE_CD}}
									        	</md-option>
									       	</md-select>  
								       		<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.scopeCd">
				       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
			       						 	</div>
								        </md-input-container>
								   </div>
								  
								   <div flex=100>
								       <md-input-container class="md-block" > 
								       <label>{{translate.load("sbi.generic.category")}}</label>
								       <md-select 	placeholder ="{{translate.load('sbi.generic.category')}}"
								        			ng-required="isCategoryRequired" ng-model="selectedDataSet.catTypeVn"
								        	 		ng-change="setFormDirty()">   
								        <md-option 
								        	ng-repeat="l in categoryList" value="{{l.VALUE_CD}}">{{l.VALUE_CD}}
								        </md-option>
								       </md-select>  
								       
								       	<div  ng-messages="datasetForm.lbl.$error" ng-show="isCategoryRequired && !selectedDataSet.catTypeVn">
			       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
		       						 	</div>
								       
								        </md-input-container>
								   </div>
								</md-card>
							</md-content>
							
							<!-- DATASET VERSIONS -->
							<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" layout-padding style="padding-top:0px;">
							
								<!-- TOOLBAR FOR THE CARD THAT HOLDS OLDER DATASET VERSIONS. (danristo) -->
						     	<md-toolbar class="secondaryToolbar" layout-padding>
						     	
						          	<div class="md-toolbar-tools">
							            
							            <h2>
							              <span>{{translate.load('sbi.ds.versionPanel')}}</span>
							            </h2>
							            
						         		<span flex></span>
							         											            
							            <md-button class="md-icon-button" aria-label="Clear all" ng-click="deleteAllDatasetVersions()" title="{{translate.load('sbi.ds.clearOldVersion')}}">
							              <md-icon md-font-icon="fa fa-eraser" ></md-icon>
							            </md-button>
							         
						          	</div>
						          	
						        </md-toolbar>						         
							    
								<md-card layout-padding style="height:300px; margin:0px">
								
									<angular-table
										 flex
					 					 id="datasetVersionList_id" 
					 					 ng-model="selectedDataSet.dsVersions"
					 					 style="height:100%;"
					 					 click-function="selectDatasetVersion(item,index,a)"
					 					 no-pagination=false
										 columns='[
											         {"label":"Creation User","name":"userIn"},
											         {"label":"Type","name":"type"},
											         {"label":"Creation Date", "name":"dateIn"}
										         ]'
										show-search-bar=false
										highlights-selected-item=true
										speed-menu-option="manageVersion" >
									</angular-table>
									
								</md-card>								
								
							</md-content>
							
					     </md-tab>
					     
					      <!-- DATASET DETAIL PANEL "TYPE" TAB -->  
					     <md-tab label='{{translate.load("sbi.generic.type");}}' ng-click="changeSelectedTab(1)">
					     
					     	<md-content flex class="ToolbarBox miniToolbar noBorder mozTable">
								
								<md-card layout-padding>
									
									<div flex=100 ng-if="selectedDataSet.dsTypeCd!='Federated'">
								       
								       <md-input-container class="md-block"> 
									       <label>{{translate.load("sbi.ds.dsTypeCd")}}</label>									     
									       <md-select 	placeholder ="{{translate.load('sbi.ds.dsTypeCd')}}"
									       	 			ng-required="true" 
									        			ng-model="selectedDataSet.dsTypeCd"
									        			ng-change="resetWhenChangeDSType(selectedDataSet.dsTypeCd);setFormDirty()">   
									        	<md-option ng-repeat="l in datasetTypeList | filter: filterDatasetTypes" value="{{l.VALUE_CD}}">{{l.VALUE_CD}}</md-option>
									       </md-select>  
									       <div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.dsTypeCd">
				       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
			       						 	</div>
								        </md-input-container>
								        
								   </div>
								   
							   		<div ng-if="selectedDataSet.dsTypeCd=='Federated'">
						        		<label>{{translate.load("sbi.ds.dsTypeCd")}}</label>: <strong>Federated</strong>
				        			</div>
								   
								</md-card>
								
							</md-content>
							
						<!-- FILE DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='File'">
							
							<!-- UPLOADING AND CHANGING FILE AS A DATA SOURCE OF THE DATASET -->
							<md-card layout-padding  style="margin-top:0">
								
								<div layout="row" flex=100 layout-align="start center" ng-show="!selectedDataSet.fileName || selectedDataSet.fileName=='' || changingFile">
					                  	
					                <input type="hidden" ng-model="selectedDataSet.fileName" ng-required="true">
					                  	
				                  	<label layout-align="center center" ng-required=true>
				                  		{{translate.load("sbi.ds.wizard.selectFile")}}:
			                  		</label>
				                  
				                  	
				                  
				                  	<file-upload 	flex ng-model="fileObj" id="datasetFile"  ng-required=true
				                  					ng-click="fileChange();checkChange();fileObjTakeBackup()" 
					                  				title="{{translate.load('sbi.workspace.dataset.wizard.browsefile.tooltip')}}">
		                			</file-upload>
				                  	
				                  	<div class="">
					                    <md-button 	ng-click="uploadFile();setFormDirty();" class="md-raised" 
					                     			ng-disabled="!fileObj.fileName || (changingFile && selectedDataSet.fileName==fileObj.fileName)" 
					                     			title="{{datasetWizStep1UploadButtonTitle()}}">
			                     			{{translate.load("sbi.workspace.dataset.wizard.upload")}}
		             					</md-button>
				                  	</div>
				                  	
								</div>
								
								<div layout="row" flex=100 ng-if="selectedDataSet.fileName && selectedDataSet.fileName!='' && !changingFile">
							 		
							 		<label style="margin-top:14px; margin-bottom:8px">
							 			{{translate.load("sbi.workspace.dataset.wizard.file.uploaded")}}: <strong>{{selectedDataSet.fileName}}</strong>
						 			</label>
						 			
								 	<span flex></span>
								  
								  	<div class="">
								  	
									    <md-button 	ng-click="changeUploadedFile()" class="md-raised" 
									    			title="{{translate.load('sbi.workspace.dataset.wizard.file.change.tooltip')}}">
				                     			{{translate.load("sbi.workspace.dataset.wizard.file.change")}}
			             				</md-button>
		             				
		           					</div>
		             				
								</div>
								
							</md-card>
							
							<!-- ELEMENTS FOR SETTING THE 'XLS' FILE CONFIGURATION -->
							<md-card ng-if="selectedDataSet.fileType=='XLS'" layout="column" class="threeCombosThreeNumFields" style="padding:0 16 0 16;">          
				        
						        <div layout="row" class="threeCombosLayout">	
							        
							        <!-- XLS file is uploaded --> 
									<div layout="row" flex >
										
										<div layout="row" layout-wrap flex=30>
					                  		<div flex=90 layout-align="center center">
					                     		<md-input-container class="md-block">
					                        		<label>{{translate.load("sbi.ds.file.xsl.skiprows")}}</label> 
					                        		<input 	ng-model="selectedDataSet.skipRows" type="number" 
					                        				step="1" min="0" value="{{selectedDataSet.skipRows}}"
					                        				ng-change="setFormDirty()">
						                     	</md-input-container>
						                  	</div>
										</div>
					                 	
				                		<div layout="row" layout-wrap flex=30>
					                  		<div flex=90 layout-align="center center">
					                     		<md-input-container class="md-block">
					                        		<label>{{translate.load("sbi.ds.file.xsl.limitrows")}}</label> 
					                        		<input 	ng-model="selectedDataSet.limitRows" type="number" 
					                        				step="1" min="0" value="{{dataset.limitRows}}"
					                        				ng-change="setFormDirty()">
						                     	</md-input-container>
						                  	</div>
										</div>
										
										<div layout="row" layout-wrap flex=30>
					                  		<div flex=90 layout-align="center center">
					                     		<md-input-container class="md-block">
					                        		<label>{{translate.load("sbi.ds.file.xsl.sheetnumber")}}</label> 
					                        		<input 	ng-model="selectedDataSet.xslSheetNumber" type="number" 
					                        				step="1" min="1" value="{{selectedDataSet.xslSheetNumber}}"
					                        				ng-change="setFormDirty()">
						                     	</md-input-container>
						                  	</div>
										</div>
										
									</div>
										
								</div>					
								
				       	 	</md-card>
				       	 	
				       	 	<!-- ELEMENTS FOR SETTING THE 'CSV' FILE CONFIGURATION -->
				       	 	<md-card ng-if="selectedDataSet.fileType=='CSV'" layout="column" class="threeCombosThreeNumFields" style="padding:0 16 0 16;">         		
		         		
				         		<div layout="row" class="threeCombosLayout">								
							              
							        <!-- CSV file is uploaded --> 
									<div layout="row" flex >
						                 	
					                 	<div layout="row" layout-wrap flex=30>
					                  		<div flex=90 layout-align="center center">
					                     		 <md-input-container class="md-block">
					                        		
					                        		<label>{{translate.load("sbi.ds.file.csv.delimiter")}}</label> 
					                        		
					                        		<md-select 	ng-model="selectedDataSet.csvDelimiter" 
					                        					ng-required="selectedDataSet.dsTypeCd=='File'"
					                        					ng-change="setFormDirty()">
					                           			<md-option 	ng-repeat="csvDelimiterCharacterItem in csvDelimiterCharacterTypes" 
					                           						value="{{csvDelimiterCharacterItem.name}}">
			                          						{{csvDelimiterCharacterItem.name}}
			                     						</md-option>
					                        		</md-select>
					                        		
					                        		<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='File' && !selectedDataSet.csvDelimiter">
						       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
					       						 	</div>
					       						 	
						                     	</md-input-container>
						                     	
						                  	</div>
						                  	
										</div>
					                 	
				                		<div layout="row" layout-wrap flex=30>
					                  		
					                  		<div flex=90 layout-align="center center">
					                     		
					                     		<md-input-container class="md-block">
					                        		
					                        		<label>{{translate.load("sbi.ds.file.csv.quote")}}</label> 
					                        		
					                        		<md-select 	aria-label="aria-label" ng-model="selectedDataSet.csvQuote" ng-required="selectedDataSet.dsTypeCd=='File'"
					                        					ng-change="setFormDirty()">
					                           			<md-option 	ng-repeat="csvQuoteCharacterItem in csvQuoteCharacterTypes" 
					                           						value="{{csvQuoteCharacterItem.name}}">
			                          						{{csvQuoteCharacterItem.name}}
			                     						</md-option>
					                        		</md-select>
					                        		
					                        		<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='File' && !selectedDataSet.csvQuote">
						       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
					       						 	</div>
					                        		
						                     	</md-input-container>
						                     	
						                  	</div>
						                  	
										</div>
										
										<div layout="row" layout-wrap flex=30>
					                  		<div flex=90 layout-align="center center">
					                     		<md-input-container class="md-block">
					                        		
					                        		<label>{{translate.load("sbi.workspace.dataset.wizard.csv.encoding")}}</label> 
					                        		
					                        		<md-select 	aria-label="aria-label" ng-model="selectedDataSet.csvEncoding"
					                        					ng-change="setFormDirty()">
					                           			<md-option 	ng-repeat="csvEncodingItem in csvEncodingTypes" 
					                           						value="{{csvEncodingItem.name}}">
			                          						{{csvEncodingItem.name}}
			                     						</md-option>
					                        		</md-select>
					                        		
						                     	</md-input-container>
						                  	</div>
										</div>
											
									</div>					
																
						    	</div>
							    	
						    </md-card>					       	 	
							
						</md-content>
							
						<!-- QUERY DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Query'">
							
							<md-card layout-padding style="margin-top:0">
							
								<div flex=100>
								
							       <md-input-container class="md-block" > 
							       
								       	<label>{{translate.load("sbi.ds.dataSource")}}</label>
								       	
								       	<md-select placeholder ="{{translate.load('sbi.ds.dataSource')}}"
								        	ng-required = "selectedDataSet.dsTypeCd=='Query'"
								        	ng-model="selectedDataSet.dataSource" ng-change="setFormDirty()">   
									        <md-option ng-repeat="l in dataSourceList" value="{{l.label}}">
									        	{{l.label}}
									        </md-option>
								       	</md-select> 
								        
								       	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Query' && !selectedDataSet.dataSource">
			       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
		       						 	</div>
		       						 	
							        </md-input-container>
							        
							   	</div>
							   	
							   	<label>{{translate.load("sbi.ds.query")}}</label>
							   	<md-input-container class="md-block">
							    	
							    	
									<textarea 	ng-required="selectedDataSet.dsTypeCd=='Query'" ng-model="selectedDataSet.query" ui-codemirror="{ onLoad : codemirrorLoaded }" 
												ui-codemirror-opts="codemirrorOptions" rows="8" md-select-on-focus
											 	ng-change="setFormDirty()">
								 	</textarea>
									
									<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Query' && !selectedDataSet.query">
       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
   						 			</div> 
									
								</md-input-container>
								
								<md-button ng-click="openEditScriptDialog()" class="md-raised md-button md-knowage-theme md-ink-ripple">{{translate.load("sbi.ds.editScript")}}</md-button>
								
							</md-card>
							
						</md-content>
							
						<!-- JAVA CLASS DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Java Class'">
							<md-card layout-padding style="margin-top:0">
								<md-input-container class="md-block" flex-gt-sm>
						           	<label>{{translate.load("sbi.ds.jclassName")}}</label>
						           	<input ng-model="selectedDataSet.jClassName" ng-required="selectedDataSet.dsTypeCd=='Java Class'" ng-change="setFormDirty()">
						           	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Java Class' && !selectedDataSet.jClassName">
		       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
       						 		</div>
						         </md-input-container>
							</md-card>
						</md-content>
						
						<!-- SCRIPT DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Script'">
							
							<md-card layout-padding style="margin-top:0">
							
								<md-input-container class="md-block" > 
							       
						      	 	<label>{{translate.load("sbi.functionscatalog.language")}}</label>
							      
					       			<md-select  aria-label="dropdown" placeholder ="{{translate.load('sbi.behavioural.lov.placeholder.script')}}"
										       	name ="scriptLanguageDropdown" 
										        ng-model="selectedDataSet.scriptLanguage"
										        ng-change="modeChanged(selectedDataSet.queryScriptLanguage); setFormDirty()" 
									         	ng-required="selectedDataSet.dsTypeCd=='Script'"> 
							        	
							        	<md-option ng-repeat="l in listOfScriptTypes track by $index" value="{{l.VALUE_CD}}">
							       		 	{{l.VALUE_NM}} 
						       		 	</md-option>
						       		 	
							       	</md-select> 
							       
							       	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Script' && !selectedDataSet.scriptLanguage">
		       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
    						 		</div>
							         
						        </md-input-container>
						        
								<md-input-container class="md-block">
								
									<textarea  	ui-codemirror="cmOption" ng-model="selectedDataSet.script" 
												md-select-on-focus ng-required="selectedDataSet.dsTypeCd=='Script'" ng-change="setFormDirty()"></textarea>
									
									<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Script' && !selectedDataSet.script">
		       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
    						 		</div>
									
								</md-input-container>
								
							</md-card>
							
						</md-content>
							
						<!-- QBE DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Qbe'">
							
							<md-card layout-padding style="margin-top:0">
								
								<div flex=100>
								
							       <md-input-container class="md-block" > 
							       
								       	<label>{{translate.load("sbi.ds.dataSource")}}</label>
								       
							      	 	<md-select 	placeholder ="{{translate.load('sbi.ds.dataSource')}}"
								        			ng-model="selectedDataSet.qbeDataSource" ng-required="selectedDataSet.dsTypeCd=='Qbe'"
								        			ng-change="setFormDirty()">   
									        <md-option ng-repeat="l in dataSourceList" value="{{l.label}}">{{l.label}}</md-option>										        
								       	</md-select>  
								       
								       	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Qbe' && !selectedDataSet.qbeDataSource">
	       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 			</div> 
								       
							        </md-input-container>
							        
							  	 </div>
							  	 
							  	 <div flex=100>									
							       <md-input-container class="md-block" > 
							       								       
								       	<label>{{translate.load("sbi.tools.managedatasets.datamartcombo.label")}}</label>
								       
								       	<md-select 	placeholder ="{{translate.load('sbi.tools.managedatasets.datamartcombo.label')}}"
								        			ng-model="selectedDataSet.qbeDatamarts" ng-required="selectedDataSet.dsTypeCd=='Qbe'" ng-change="setFormDirty()">   
									        <md-option ng-repeat="l in datamartList" value="{{l.name}}">{{l.name}}</md-option>										        
								       	</md-select>  
								       
							      	 	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Qbe' && !selectedDataSet.qbeDatamarts">
	       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
   						 				</div> 
								       
							        </md-input-container>
							        
							  	 </div>
							  	 
						  	  	<div flex=100 style="padding-left:0; padding-top:0;">
																			
									<md-button flex=20 class="md-raised" ng-click="viewQbe()">
										{{translate.load("sbi.ds.qbe.query.view.button")}}
									</md-button> 
									
									<!-- <div flex=30 style="float:right"> -->
									<md-button flex=20 class="md-raised" ng-click="showQbeDataset(selectedDataSet)">
										{{translate.load("sbi.ds.qbe.query.open.button")}}
									</md-button> 								
									
								</div>
							  	 
							</md-card>
							
						</md-content>

						<!-- FLAT DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Flat'">
							
							<md-card layout-padding style="margin-top:0">
							
								<md-input-container class="md-block" flex-gt-sm>
								
						           	<label>{{translate.load("sbi.ds.persistTableName")}}</label>
						           	<input ng-model="selectedDataSet.flatTableName" ng-required="selectedDataSet.dsTypeCd=='Flat'" ng-change="setFormDirty()">
						           	
						           	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Flat' && !selectedDataSet.flatTableName">
	       						 		<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	    						 	</div>
	    						 	
					         	</md-input-container>
					         	
					          	<md-input-container class="md-block" > 
							       
								       	<label>{{translate.load("sbi.ds.dataSource")}}</label>
								       
								       	<md-select 	placeholder ="{{translate.load('sbi.ds.dataSource')}}"
								        			ng-model="selectedDataSet.dataSourceFlat" ng-required="selectedDataSet.dsTypeCd=='Flat'"
								        			ng-change="setFormDirty()">   
									        <md-option ng-repeat="l in dataSourceList" value="{{l.label}}">{{l.label}}</md-option>										        
								       	</md-select>  
								       
									  	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Flat' && !selectedDataSet.dataSourceFlat">
	       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
    						 			</div>    
								       
						        </md-input-container>
						        
							</md-card>
							
						</md-content>
							
						<!-- CKAN DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Ckan'">
						
							<!-- ELEMENTS FOR SETTING THE 'XLS' FILE CONFIGURATION -->
							<md-card layout="column" class="threeCombosThreeNumFields" layout-padding>  
							
								<!-- PICK CKAN FILE DATASET TYPE -->
								<div style="display:flex; padding:8 8 0 8;">
								
							       	<md-input-container class="md-block" style="width:100%"> 
								       	
								       	<label>File type</label>
								       	
								       	<md-select 	placeholder ="Choose the file type"
								       	 			ng-required = "selectedDataSet.dsTypeCd=='Ckan'" ng-change="setFormDirty()"
								        			ng-model="selectedDataSet.ckanFileType">   
								        	<md-option ng-repeat="l in ckanFileType" value="{{l.name}}">{{l.name}}</md-option>
								       	</md-select>  
								       	
								       	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Ckan' && !selectedDataSet.ckanFileType">
			       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
		       						 	</div>
		       						 	
						        	</md-input-container>
							   	</div>        
				        
				        		<!-- TODO: criteria for the XLS configuration -->
				        		<div ng-if="selectedDataSet.ckanFileType=='XLS'" style="padding:0 8 0 8;">
				        		
				        			<div layout="row" class="threeCombosLayout">	
							        
								        <!-- XLS file is uploaded --> 
										<div layout="row" flex >
											
											<div layout="row" layout-wrap flex=30>
						                  		<div flex=90 layout-align="center center">
						                     		<md-input-container class="md-block" style="margin:0">
						                        		<label>{{translate.load("sbi.ds.file.xsl.skiprows")}}</label> 
						                        		<input 	ng-model="selectedDataSet.ckanSkipRows" type="number" 
						                        				step="1" min="0" value="{{selectedDataSet.ckanSkipRows}}"
						                        				ng-change="setFormDirty()">
							                     	</md-input-container>
							                  	</div>
											</div>
						                 	
					                		<div layout="row" layout-wrap flex=30>
						                  		<div flex=90 layout-align="center center">
						                     		<md-input-container class="md-block" style="margin:0">
						                        		<label>{{translate.load("sbi.ds.file.xsl.limitrows")}}</label> 
						                        		<input 	ng-model="selectedDataSet.ckanLimitRows" type="number" 
						                        				step="1" min="0" value="{{selectedDataSet.ckanLimitRows}}"
						                        				ng-change="setFormDirty()">
							                     	</md-input-container>
							                  	</div>
											</div>
											
											<div layout="row" layout-wrap flex=30>
						                  		<div flex=90 layout-align="center center">
						                     		<md-input-container class="md-block" style="margin:0">
						                        		<label>{{translate.load("sbi.ds.file.xsl.sheetnumber")}}</label> 
						                        		<input 	ng-model="selectedDataSet.ckanXslSheetNumber" type="number" 
						                        				step="1" min="1" value="{{selectedDataSet.ckanXslSheetNumber}}"
						                        				ng-change="setFormDirty()">
							                     	</md-input-container>
							                  	</div>
											</div>
											
										</div>
											
									</div>	
				        		
				        		</div>
						        				      		
		         				<!-- TODO: criteria for the XLS configuration -->
				        		<div ng-if="selectedDataSet.ckanFileType=='CSV'" style="padding:0 8 0 8;">
		         					
		         					<div layout="row" class="threeCombosLayout">								
							              
								        <!-- CSV file is uploaded --> 
										<div layout="row" flex >
							                 	
						                 	<div layout="row" layout-wrap flex=30>
						                  		<div flex=90 layout-align="center center">
						                     		<md-input-container class="md-block" style="margin:0">
						                        		
						                        		<label>{{translate.load("sbi.ds.file.csv.delimiter")}}</label> 
						                        		
						                        		<md-select 	aria-label="aria-label" ng-model="selectedDataSet.ckanCsvDelimiter" 
						                        					ng-required="selectedDataSet.dsTypeCd=='Ckan'" ng-change="setFormDirty()">
						                           			<md-option 	ng-repeat="csvDelimiterCharacterItem in csvDelimiterCharacterTypes" 
						                           						value="{{csvDelimiterCharacterItem.name}}">
					                          						{{csvDelimiterCharacterItem.name}}
				                     						</md-option>
						                        		</md-select>
						                        		
						                        		<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Ckan' && !selectedDataSet.ckanCsvDelimiter">
							       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
						       						 	</div>
										                        		
							                     	</md-input-container>
							                  	</div>
											</div>
						                 	
					                		<div layout="row" layout-wrap flex=30>
						                  		<div flex=90 layout-align="center center">
						                     		<md-input-container class="md-block" style="margin:0">
						                        		
						                        		<label>{{translate.load("sbi.ds.file.csv.quote")}}</label> 
						                        		
						                        		<md-select 	aria-label="aria-label" ng-model="selectedDataSet.ckanCsvQuote" 
						                        					ng-required="selectedDataSet.dsTypeCd=='Ckan'" ng-change="setFormDirty()">
						                           			<md-option 	ng-repeat="csvQuoteCharacterItem in csvQuoteCharacterTypes" 
						                           						value="{{csvQuoteCharacterItem.name}}">
					                          						{{csvQuoteCharacterItem.name}}
					                     						</md-option>
						                        		</md-select>
						                        		
						                        		<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Ckan' && !selectedDataSet.ckanCsvQuote">
							       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
						       						 	</div>
						                        		
							                     	</md-input-container>
							                  	</div>
											</div>
											
											<div layout="row" layout-wrap flex=30>
						                  		<div flex=90 layout-align="center center">
						                     		<md-input-container class="md-block" style="margin:0">
						                        		
						                        		<label>{{translate.load("sbi.workspace.dataset.wizard.csv.encoding")}}</label> 
						                        		
						                        		<md-select 	aria-label="aria-label" ng-model="selectedDataSet.ckanCsvEncoding" 
						                        					ng-change="setFormDirty()">
						                           			<md-option 	ng-repeat="csvEncodingItem in csvEncodingTypes" 
						                           						value="{{csvEncodingItem.name}}">
					                          						{{csvEncodingItem.name}}
					                     						</md-option>
						                        		</md-select>
						                        		
							                     	</md-input-container>
							                  	</div>
											</div>
												
										</div>					
																	
							    	</div>
		         				
		         				</div>
		         									         	
					         	<div flex=100 layout-padding ng-if="selectedDataSet.ckanFileType">
					         	
					         			<md-input-container class="md-block" style="margin-bottom:8">
										
								    		<label>{{translate.load("sbi.ds.ckanId")}}</label>
						           	
								           	<input ng-model="selectedDataSet.ckanId" ng-required = "true" ng-change="setFormDirty()">
								           	
								           	<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.ckanId">
				       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
			       						 	</div>
			       						 	
										</md-input-container>
					         	
										<md-input-container class="md-block" style="margin-bottom:8">
										
								    		<label>{{translate.load("sbi.ds.ckanUrl")}}</label>
						           	
								           	<input ng-model="selectedDataSet.ckanUrl" ng-required = "selectedDataSet.dsTypeCd=='Ckan'" ng-change="setFormDirty()">
								           	
								           	<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='Ckan' && !selectedDataSet.ckanUrl">
				       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
			       						 	</div>
			       						 	
										</md-input-container>
										
								</div>
				         		
						    </md-card>
						
						</md-content>
							
						<!-- FEDERATED DATASET -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='Federated'">
							
							<md-card layout-padding style="margin-top:0">
							
								<div flex=100 style="padding-left:0;">
																			
									<md-button flex=20 class="md-raised" ng-click="viewQbe()">
										{{translate.load("sbi.ds.qbe.query.view.button")}}
									</md-button> 
									
									<md-button flex=20 class="md-raised" ng-click="showQbeDataset(selectedDataSet)">
										{{translate.load("sbi.ds.qbe.query.open.button")}}
									</md-button> 
									
								</div>
								
							</md-card>
							
						</md-content>
							
						<!-- REST DATASET (1) -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='REST'">
							
							<md-card layout-padding style="margin-top:0">
								
								<div flex=100>
									<md-input-container class="md-block">
								    	<label>Address</label>
										<input ng-model="selectedDataSet.restAddress" ng-required = "selectedDataSet.dsTypeCd=='REST'" ng-change="setFormDirty()">
										<div ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='REST' && !selectedDataSet.restAddress">
			       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
		       						 	</div>
									</md-input-container>
								</div>
								
								<div flex=100>
									<md-input-container class="md-block">
										<label>Request body</label>
								    	<textarea 	ng-model="selectedDataSet.restRequestBody" md-maxlength="150" rows="3" 
								    				md-select-on-focus ng-change="setFormDirty()"></textarea>
									</md-input-container>
								</div>
								
								<div flex=100>
							       
							       <md-input-container class="md-block" > 
								       
								       	<label>HTTP methods</label>
								       	
								       	<md-select 	placeholder ="HTTP methods" ng-required = "selectedDataSet.dsTypeCd=='REST'"
								        			ng-model="selectedDataSet.restHttpMethod"
								        			ng-change="setFormDirty()">   
									        <md-option ng-repeat="l in httpMethods" value="{{l.value}}">
									        	{{l.name}}
									        </md-option>
								       	</md-select>  
										
										<div  ng-messages="datasetForm.lbl.$error" ng-show="selectedDataSet.dsTypeCd=='REST' && !selectedDataSet.restHttpMethod">
			       						 	<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
		       						 	</div>								
		       						 									        
	       						 	</md-input-container>
		       						 
							   </div>
							   																	
							</md-card>
						
						</md-content>
							
						<!-- REST DATASET (2) -->	
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='REST'" style="padding:0 8 0 8">
							
							<!-- TOOLBAR FOR THE CARD THAT HOLDS ADD REQUEST HEADER BUTTON -->
					     	<md-toolbar class="secondaryToolbar" layout-padding>
					     	
					          	<div class="md-toolbar-tools">
						            
						            <h2>
						              <span>Request Headers</span>
						            </h2>
						            
					         		<span flex></span>
						         											            
						            <md-button 	class="md-icon-button" aria-label="Add request header" 
						            			ng-click="requestHeaderAddItem(); setFormDirty();" 
						            			title="{{translate.load('sbi.generic.add')}}">
						              	<md-icon md-font-icon="fa fa-plus-circle"></md-icon>
						            </md-button>
						            
						            <md-button class="md-icon-button" aria-label="Clear all request headers" 
												ng-click="deleteAllRESTRequestHeaders()" title="Clear all request headers">
						              	<md-icon md-font-icon="fa fa-eraser"></md-icon>
						            </md-button>
						         
					          	</div>
					          	
					        </md-toolbar>						         
						    							
							<md-card layout-padding style="height:300px; margin:0 0 8 0">
																		
								<angular-table
										id="requestHeadersTable"
										flex
										style="height:100%;padding:8px"
										ng-model=restRequestHeaders
										columns=requestHeadersTableColumns
										show-search-bar=false
										scope-functions=requestHeadersScopeFunctions
										no-pagination=false
										speed-menu-option=requestHeadersDelete
										current-page-number=restDsRequestHeaderTableLastPage >
								</angular-table>
								   									
							</md-card>
							
						</md-content>	
							
								
						<!-- REST DATASET (3) -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='REST'" style="padding: 0 8 0 8">
							
							<md-card layout-padding style="margin:0 0 8 0">
							
								<div flex=100 style="display:flex;">											
																			
									<md-input-container class="md-block" style="float:left; width:75%">
								    	<label>JSON Path Items</label>
										<input ng-model="selectedDataSet.restJsonPathItems" ng-change="setFormDirty()">
									</md-input-container>
									 
									<div style="width:25%">
										<md-button 	style="margin:16px 0 16px 0; float:right;" class="md-icon-button" 
													aria-label="Add request header" ng-click="showInfoForRestParams('jsonPathItems')" 
													title="{{translate.load('sbi.ds.help')}}">
							              	<md-icon md-font-icon="fa fa-info-circle"></md-icon>
							            </md-button>
						            </div>
									
								</div>
								
								<div flex=100 style="display:flex;">
									<div flex=50 layout="row" layout-align="start center">
						           	
				                  		<label>
				                  			Use directly JSON Attributes:
			                  			</label> 
				                  		
				                  		
				                  		<md-input-container class="small counter" style="padding-left:8px;">
				                     		<md-checkbox 	aria-label="Checkbox 2" 
					                     					ng-model="selectedDataSet.restDirectlyJSONAttributes" ng-checked="" 
					                     					ng-change="setFormDirty()">
											</md-checkbox>
				                  		</md-input-container>
				                  		
									</div>
									
									<div style="width:50%">
										<md-button 	style="margin:16px 0 16px 0; float:right;" class="md-icon-button" 
													aria-label="Add request header" ng-click="showInfoForRestParams('directJsonAttributes')" 
													title="{{translate.load('sbi.ds.help')}}">
							              	<md-icon md-font-icon="fa fa-info-circle"></md-icon>
							            </md-button>
						            </div>
						            
					            </div>
					            
					            <div flex=100 style="display:flex;">
					            
									<div flex=50 layout="row" layout-align="start center">
						           	
				                  		<label>
				                  			NGSI:
			                  			</label> 
				                  		
				                  		
				                  		<md-input-container class="small counter" style="padding-left:8px;">
				                     		<md-checkbox 	aria-label="Checkbox 2" 
					                     					ng-model="selectedDataSet.restNGSI" ng-checked="" 
					                     					ng-change="setFormDirty()">
											</md-checkbox>
				                  		</md-input-container>
				                  		
									</div>
									
									<div style="width:50%">
										<md-button 	style="margin:16px 0 16px 0; float:right;" class="md-icon-button" 
													aria-label="Add request header" ng-click="showInfoForRestParams('ngsi')" 
													title="{{translate.load('sbi.ds.help')}}">
							              	<md-icon md-font-icon="fa fa-info-circle"></md-icon>
							            </md-button>
						            </div>
						            
					            </div>
								
							</md-card>
							
						</md-content>
							
						<!-- REST DATASET (4) -->
						<!-- JSON path attributes grid  -->
						
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='REST'" style="padding:0 8 0 8">
							
							<!-- TOOLBAR FOR THE CARD THAT HOLDS ADD REQUEST HEADER BUTTON. (danristo) -->
					     	<md-toolbar class="secondaryToolbar" layout-padding>
					     	
					          	<div class="md-toolbar-tools">
						            
						            <h2>
						              <span>JSON path attributes</span>
						            </h2>
						            
					         		<span flex></span>
						         											            
						            <md-button 	class="md-icon-button" aria-label="Add JSON path attributes" 
						            			ng-click="restJsonPathAttributesAddItem(); setFormDirty();" title="{{translate.load('sbi.generic.add')}}">
						              	<md-icon md-font-icon="fa fa-plus-circle"></md-icon>
						            </md-button>
						         
						         	<md-button class="md-icon-button" aria-label="Clear all JSON path attributes" 
												ng-click="deleteAllRESTJsonPathAttributes()" title="Clear all JSON path attributes">
						              <md-icon md-font-icon="fa fa-eraser"></md-icon>
						            </md-button>
						         
						         	 <md-button class="md-icon-button" aria-label="Help" ng-click="showInfoForRestParams('jsonPathAttributes')" title="{{translate.load('sbi.ds.help')}}">
						              	<md-icon md-font-icon="fa fa-info-circle"></md-icon>
						            </md-button>
						            
					          	</div>
					          	
					        </md-toolbar>						         
						    							
							<md-card layout-padding style="height:300px; margin:0 0 8 0">
																					
								<angular-table
										id="jsonPathAttrTable"
										flex
										style="height:100%;padding:8px"
										ng-model=restJsonPathAttributes											
										columns="restJsonPathAttributesTableColumns"
										show-search-bar=false
										scope-functions="jsonPathAttrScopeFunctions"
										no-pagination=false
										speed-menu-option="restJsonPathAttributesDelete"
										current-page-number=restDsJsonPathAttribTableLastPage >
								</angular-table>
								   									
							</md-card>
							
						</md-content>	
						
						<!-- REST DATASET (5) -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" ng-if="selectedDataSet.dsTypeCd=='REST'" style="padding: 0 8 0 8">
							
							<md-card layout-padding style="margin:0 0 8 0">
							
								<div flex=100>											
																			
									<md-input-container class="md-block">
								    	<label>Offset Param</label>
										<input ng-model="selectedDataSet.restOffset" ng-change="setFormDirty()" type="number">
									</md-input-container>
									
								</div>
								
								<div flex=100>											
																			
									<md-input-container class="md-block">
								    	<label>Fetch size Param</label>
										<input ng-model="selectedDataSet.restFetchSize" ng-change="setFormDirty()" type="number">
									</md-input-container>
									
								</div>
								
								<div flex=100>											
																			
									<md-input-container class="md-block">
								    	<label>Max Results Param</label>
										<input ng-model="selectedDataSet.restMaxResults" ng-change="setFormDirty()" type="number">
									</md-input-container>
									
								</div>
							
							</md-card>
							
						</md-content>
							
						<!-- DATASET PARAMETERS -->					
						<md-content ng-show="selectedDataSet.dsTypeCd && selectedDataSet.dsTypeCd.toLowerCase()!='file' && selectedDataSet.dsTypeCd.toLowerCase()!='flat'" 
									style="padding: 0 8 8 8" flex class="ToolbarBox miniToolbar noBorder mozTable">
															
								<md-toolbar class="secondaryToolbar" layout-padding>
								
									<div class="md-toolbar-tools">
								
										<h2>
										  <span>{{translate.load('sbi.execution.parametersselection.parameters')}}</span>
										</h2>
									
										<span flex></span>
									
										<md-button class="md-icon-button" aria-label="Add new dataset parameter" ng-click="parametersAddItem(); setFormDirty()" 
												title="{{translate.load('sbi.ds.parameters.add.tooltip')}}">
										  <md-icon md-font-icon="fa fa-plus-circle" ></md-icon>
										</md-button>
										
										<md-button class="md-icon-button" aria-label="Clear all parameters" 
												ng-click="deleteAllParameters();" title="Clear all parameters">
							              <md-icon md-font-icon="fa fa-eraser" ></md-icon>
							            </md-button>
										
									</div>
												
								</md-toolbar>						         
												
								<md-card layout-padding style="height:300px; margin:0px">
																				      						
									<angular-table
											id="datasetParametersTable"
											flex
											style="height:100%;padding:8px"
											ng-model=parameterItems
											columns=parametersColumns
											show-search-bar=false
											scope-functions=paramScopeFunctions
											no-pagination=false
											speed-menu-option="parameterDelete"
											current-page-number=parametersTableLastPage >
									</angular-table>
								   									
								</md-card>
							
						</md-content>
							
				     </md-tab>	
					     
				      <!-- DATASET DETAIL PANEL "ADVANCED" TAB -->  
				     <md-tab label='{{translate.load("sbi.ds.advancedTab");}}' ng-click="changeSelectedTab(2)">
						
						<!-- OLD TRANSFORMATION TAB -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable">
							
							<md-card layout-padding>
								
								<div flex=100 style="display:flex;">
								
									<div flex=50 layout="row" layout-align="start center">
						           	
				                  		<label>
				                  			{{translate.load('sbi.ds.trasfTypeCd')}}: <strong>{{transformationDataset.VALUE_CD}}</strong>	
			                  			</label> 
				                  
				                  		
				                  		<md-input-container class="small counter" style="padding-left:8px;">
				                     		<md-checkbox 	aria-label="Checkbox 2" 
					                     					ng-model="transformDatasetState" ng-checked="" 
					                     					ng-change="setFormDirty();transformationCheck()">
											</md-checkbox>
				                  		</md-input-container>
				                  		
									</div>
									
								</div>
								
								<div ng-if="transformDatasetState">
								
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.pivotColName")}}</label>
											<input ng-model="selectedDataSet.pivotColName" ng-required="transformDatasetState" ng-change="setFormDirty()">
											<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.pivotColName">
		       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 				</div>
										</md-input-container>
									</div>
									
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.pivotColValue")}}</label>
											<input ng-model="selectedDataSet.pivotColValue" ng-required="transformDatasetState" ng-change="setFormDirty()">
											<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.pivotColValue">
		       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 				</div>
										</md-input-container>
									</div>
									
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.pivotRowName")}}</label>
											<input ng-model="selectedDataSet.pivotRowName" ng-required="transformDatasetState" ng-change="setFormDirty()">
											<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.pivotRowName">
		       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 				</div>
										</md-input-container>
									</div>
									
									<div flex=100 style="display:flex;" >
										
										<div flex=50 layout="row" layout-align="start center">
							           	
					                  		<label>
					                  			{{translate.load('sbi.ds.pivotIsNumRows')}}: 
				                  			</label> 
					                  		
					                  		
					                  		<md-input-container class="small counter" style="padding-left:8px;">
					                     		<md-checkbox 	aria-label="Checkbox 2" 
						                     					ng-model="selectedDataSet.pivotIsNumRows"
						                     					ng-change="setFormDirty()">
												</md-checkbox>
					                  		</md-input-container>
					                  		
										</div>
										
									</div>
								
								</div>
						
							</md-card>
							
						</md-content>
						
						<!-- OLD ADVANCED TAB (Persist HDFS) -->
						<md-content ng-show="showExportHDFS" flex class="ToolbarBox miniToolbar noBorder mozTable">
							<md-card layout-padding style="margin-top:0">
								<div flex=100 style="display:flex;">
									<div flex=50 layout="row" layout-align="start center">
				                  		<label>
				                  			{{translate.load('sbi.ds.hdfs')}}: 
			                  			</label> 

				                  		<md-input-container class="small counter" style="padding-left:8px;">
				                     		<md-checkbox 	aria-label="HDFS Persisted" 
					                     					ng-model="selectedDataSet.isPersistedHDFS" ng-checked="" 
					                     					ng-change="setFormDirty()">
											</md-checkbox>
				                  		</md-input-container>
									</div>
								</div>				
							</md-card>						
						</md-content>
						
						<!-- OLD ADVANCED TAB (Persist) -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable">
							
							<md-card layout-padding style="margin-top:0">
							
								<div flex=100 style="display:flex;">
								
									<div flex=50 layout="row" layout-align="start center">
						           	
				                  		<label>
				                  			{{translate.load('sbi.ds.isPersisted')}}: 
			                  			</label> 
				                  		
				                  		
				                  		<md-input-container class="small counter" style="padding-left:8px;">
				                     		<md-checkbox 	aria-label="Persisted" 
					                     					ng-model="selectedDataSet.isPersisted" ng-checked="" 
					                     					ng-change="setFormDirty()">
											</md-checkbox>
				                  		</md-input-container>
				                  		
									</div>
									
								</div>
								
								<div ng-show="selectedDataSet.isPersisted">
									<div flex=100>
										<md-input-container class="md-block">
									    	<label>{{translate.load("sbi.ds.persistTableName")}}</label>
											<input ng-model="selectedDataSet.persistTableName" ng-required="selectedDataSet.isPersisted" ng-change="setFormDirty()">
											<div  ng-messages="datasetForm.lbl.$error" ng-show="!selectedDataSet.persistTableName">
		       						 			<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 				</div>
										</md-input-container>
									</div>
								
								</div>
							
							</md-card>
							
						</md-content>
						
						<!-- OLD ADVANCED TAB (Scheduling) -->
						<md-content flex class="ToolbarBox miniToolbar noBorder mozTable" style="margin:0 8 0 8" ng-if="showDatasetScheduler && (selectedDataSet.isPersisted || selectedDataSet.isPersistedHDFS)">
							
							<md-toolbar class="secondaryToolbar" layout-padding>
						     	
						          	<div class="md-toolbar-tools">
							            
							            <h2>
							              <span>{{translate.load('sbi.ds.persist.cron.scheduling.title')}}</span>
							            </h2>
							            
						         		<span flex></span>
							         
						          	</div>
						          	
					        </md-toolbar>
						         
							<md-card layout-padding style="margin:0; display:inline-table; width:100%">
							
								<div flex=100>
								
									<div layout-align="start center">
						           	
				                  		<label>
				                  			{{translate.load('sbi.ds.isScheduled')}}: 
			                  			</label> 
				                  		
				                  		
				                  		<md-input-container class="small counter" style="padding-left:8px;">
				                     		<md-checkbox 	aria-label="Scheduling" 
					                     					ng-model="selectedDataSet.isScheduled" ng-checked="" 
					                     					ng-change="setFormDirty()">
											</md-checkbox>
				                  		</md-input-container>
				                  		
									</div>
									
									<!-- Show all Scheduling options if the Scheduling is checked -->
									<div ng-if="selectedDataSet.isScheduled">
									
										<!-- CALENDAR (DATE PICKER) -->
										<div flex=100 style="display:flex;padding-bottom:8;margin-bottom:8">
											
											<div style="float:left" flex=50>
												<label>{{translate.load('sbi.ds.persist.cron.startdate')}}:</label>												
												<md-datepicker ng-model="selectedDataSet.startDate" md-placeholder="Enter date"
		            											md-min-date="minStartDate" md-max-date="maxStartDate" 
		            											ng-change="setFormDirty();checkPickedStartDate();"
		            											md-open-on-focus ng-required="selectedDataSet.isScheduled==true">
												</md-datepicker>
												<div  ng-messages="datasetForm.lbl.$error" class="required-message" ng-show="selectedDataSet.isScheduled==true && !selectedDataSet.startDate">
		       						 				<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 					</div>
											
											</div>
											
											<div style="float:right" flex=50>
												<label>{{translate.load('sbi.ds.persist.cron.enddate')}}:</label>												
												<md-datepicker ng-model="selectedDataSet.endDate" md-placeholder="Enter date"
		            											md-min-date="minEndDate" md-max-date="maxEndDate" 
		            											ng-change="setFormDirty();checkPickedEndDate();"
		            											md-open-on-focus ng-required="selectedDataSet.isScheduled==true">
												</md-datepicker>
												<div  ng-messages="datasetForm.lbl.$error" class="required-message" ng-show="selectedDataSet.isScheduled==true && !selectedDataSet.endDate">
		       						 				<div ng-message="required">{{translate.load("sbi.catalogues.generic.reqired");}}</div>
	   						 					</div>
											</div>
											
										</div>
										
										<!-- MINUTE -->
										<!-- <div flex=100 style="display:flex; background-color:#eceff1;"> -->
										<md-whiteframe class="md-whiteframe-5dp" style="display:flex; padding:8; margin-top:8">
											
											<div flex=100 layout="row" style="display:flex">
											
												<div flex=20 style="align-items:center; display:flex">
													<label style="margin: 4 0 4 0; color:#A9A9A9">
														{{translate.load('sbi.ds.persist.cron.minute')}}s:
													</label>												
												</div>
												
												<!-- VERTICAL ALIGNMENT INSIDE THE DIV: align-items:center; display:flex -->
												<div flex=40 style="align-items:center; display:flex">
													
													<label style="margin: 4 0 4 0; color:#A9A9A9" ng-if="!scheduling.minutesCustom">
														<strong>{{translate.load('sbi.ds.persist.cron.everyminute')}}</strong>
													</label>
													
													<md-select placeholder ="Select minute(s)"
											        	ng-required="selectedDataSet.isScheduled" ng-if="scheduling.minutesCustom" multiple=true
											        	ng-model="scheduling.minutesSelected" style="margin:0; width:80%" title="{{scheduling.minutesSelected}}"
											        	>   
											        	<md-option ng-repeat="l in minutes track by $index" value="{{$index}}" ng-mousedown="setFormDirty()">
											        		{{$index}}
											        	</md-option>
										       		</md-select> 
														
												</div>
												
												<div flex=40>
													
													<div layout="row" layout-align="start center">
							           	
							           					<div flex=50>
							           						{{minutesCustom}}
							           					
								                  			<md-input-container class="small counter" style="margin:8;" >
								                     			<md-checkbox 	aria-label="Checkbox 2" ng-model="scheduling.minutesCustom"								                     						
									                     						ng-mousedown="setFormDirty()">
																</md-checkbox>
								                  			</md-input-container>
								                  			
								                  			<label>
								                  				{{translate.load('sbi.general.custom')}}
							                  				</label> 	
						                  				</div>
						                  				
						                  				<div flex=50 ng-if=scheduling.minutesCustom>					                  				
						                  					<md-button aria-label="menu" class="md-raised md-mini" ng-click="minutesClearSelections();setFormDirty()" 
											      					ng-mousedown="setFormDirty()" title="Fields metadata" style="margin-top:0; margin-bottom:0;">
												            	{{translate.load('sbi.ds.persist.cron.scheduling.multipleselect.clearall')}} 
												          	</md-button>				                  				
						                  				</div>
						                  							                  		
													</div>
													
												</div>
											
											</div>
										
										</md-whiteframe>	
										<!-- </div> -->
										
										<!-- HOUR -->
										<!-- <div flex=100 style="display:flex; background-color:#eceff1; margin-top:8px"> -->
										<md-whiteframe class="md-whiteframe-5dp" style="display:flex; padding:8; margin-top:8">
										
											<div flex=100 layout="row" style="display:flex">
											
												<div flex=20 style="align-items:center; display:flex">
													<label style="margin: 4 0 4 0; color:#A9A9A9">
														{{translate.load('sbi.ds.persist.cron.hour')}}s:
													</label>												
												</div>
												
												<!-- VERTICAL ALIGNMENT INSIDE THE DIV: align-items:center; display:flex -->
												<div flex=40 style="align-items:center; display:flex">
													
													<label style="margin: 4 0 4 0; color:#A9A9A9" ng-if=!scheduling.hoursCustom>
														<strong>{{translate.load('sbi.ds.persist.cron.everyhour')}}</strong>
													</label>
													
													<md-select placeholder ="Select hours(s)"
											        	ng-required = "selectedDataSet.isScheduled" ng-if=scheduling.hoursCustom multiple=true
											        	ng-model="scheduling.hoursSelected" style="margin:0; width:80%" title="{{scheduling.hoursSelected}}">   
											        	<md-option ng-repeat="l in hours track by $index" value="{{$index}}" ng-mousedown="setFormDirty()">
											        		{{$index}}
											        	</md-option>
										       		</md-select> 
														
												</div>
												
												<div flex=40>
													
													<div layout="row" layout-align="start center">
							           	
							           					<div flex=50>
								                  			<md-input-container class="small counter" style="margin:8;">
								                     			<md-checkbox 	aria-label="Checkbox 2" 
										                     					ng-model="scheduling.hoursCustom" ng-checked="" 
										                     					ng-mousedown="setFormDirty()">
																</md-checkbox>
								                  			</md-input-container>
								                  			
								                  			<label>
								                  				{{translate.load('sbi.general.custom')}}
							                  				</label> 	
						                  				</div>
						                  				
						                  				<div flex=50 ng-if=scheduling.hoursCustom>					                  				
						                  					<md-button aria-label="menu" class="md-raised md-mini" ng-click="hoursClearSelections();setFormDirty()" 
											      					ng-show="selectedDataSet" title="Fields metadata" style="margin-top:0; margin-bottom:0;">
												            	{{translate.load('sbi.ds.persist.cron.scheduling.multipleselect.clearall')}} 
												          	</md-button>				                  				
						                  				</div>
						                  							                  		
													</div>
													
												</div>
											
											</div>
										
										</md-whiteframe>	
										<!-- </div> -->
										
										<!-- DAY -->
										<!-- <div flex=100 style="display:flex; background-color:#eceff1; margin-top:8px"> -->
										<md-whiteframe class="md-whiteframe-5dp" style="display:flex; padding:8; margin-top:8">
											
											<div flex=100 layout="row" style="display:flex">
											
												<div flex=20 style="align-items:center; display:flex">
													<label style="margin: 4 0 4 0; color:#A9A9A9">
														{{translate.load('sbi.ds.persist.cron.day')}}s:
													</label>												
												</div>
												
												<!-- VERTICAL ALIGNMENT INSIDE THE DIV: align-items:center; display:flex -->
												<div flex=40 style="align-items:center; display:flex">
													
													<label style="margin: 4 0 4 0; color:#A9A9A9" ng-if=!scheduling.daysCustom>
														<strong>{{translate.load('sbi.ds.persist.cron.everyday')}}</strong>
													</label>
													
													<md-select placeholder ="Select day(s)"
											        	ng-required = "selectedDataSet.isScheduled" ng-if=scheduling.daysCustom multiple=true
											        	ng-model="scheduling.daysSelected" style="margin:0; width:80%" title="{{scheduling.daysSelected}}">   
											        	<md-option ng-repeat="l in days" value="{{l}}" ng-mousedown="setFormDirty()">
											        		{{l}}
											        	</md-option>
										       		</md-select> 
														
												</div>
												
												<div flex=40>
													
													<div layout="row" layout-align="start center">
							           	
							           					<div flex=50>
								                  			<md-input-container class="small counter" style="margin:8;">
								                     			<md-checkbox 	aria-label="Checkbox 2" 
									                     						ng-model="scheduling.daysCustom" ng-checked="" 
									                     						ng-mousedown="setFormDirty()">
																</md-checkbox>
								                  			</md-input-container>
								                  			
								                  			<label>
								                  				{{translate.load('sbi.general.custom')}}
							                  				</label> 	
						                  				</div>
						                  				
						                  				<div flex=50 ng-if=scheduling.daysCustom>					                  				
						                  					<md-button aria-label="menu" class="md-raised md-mini" ng-click="daysClearSelections();setFormDirty()" 
											      					ng-show="selectedDataSet" title="Fields metadata" style="margin-top:0; margin-bottom:0;">
												            	{{translate.load('sbi.ds.persist.cron.scheduling.multipleselect.clearall')}} 
												          	</md-button>				                  				
						                  				</div>
						                  							                  		
													</div>
													
												</div>
											
											</div>
										
										</md-whiteframe>	
										<!-- </div> -->
										
										<!-- MONTH -->
										<!-- <div flex=100 style="display:flex; background-color:#eceff1; margin-top:8px"> -->
										<md-whiteframe class="md-whiteframe-5dp" style="display:flex; padding:8; margin-top:8">
											
											<div flex=100 layout="row" style="display:flex">
											
												<div flex=20 style="align-items:center; display:flex">
													<label style="margin: 4 0 4 0; color:#A9A9A9">
														{{translate.load('sbi.ds.persist.cron.month')}}s:
													</label>												
												</div>
												
												<!-- VERTICAL ALIGNMENT INSIDE THE DIV: align-items:center; display:flex -->
												<div flex=40 style="align-items:center; display:flex">
													
													<label style="margin: 4 0 4 0; color:#A9A9A9" ng-if=!scheduling.monthsCustom>
														<strong>{{translate.load('sbi.ds.persist.cron.everymonth')}}</strong>
													</label>
													
													<md-select placeholder ="Select month(s)"
											        	ng-required = "selectedDataSet.isScheduled" ng-if=scheduling.monthsCustom multiple=true
											        	ng-model="scheduling.monthsSelected" style="margin:0; width:80%" title="{{scheduling.monthsSelected}}">   
											        	<md-option ng-repeat="l in months" value="{{l.value}}" ng-mousedown="setFormDirty()">
											        		{{l.name}}
											        	</md-option>
										       		</md-select> 
														
												</div>
												
												<div flex=40>
													
													<div layout="row" layout-align="start center">
							           	
							           					<div flex=50>
								                  			<md-input-container class="small counter" style="margin:8;">
								                     			<md-checkbox 	aria-label="Checkbox 2" 
										                     					ng-model="scheduling.monthsCustom" ng-checked="" 
										                     					ng-mousedown="setFormDirty()">
																</md-checkbox>
								                  			</md-input-container>
								                  			
								                  			<label>
								                  				{{translate.load('sbi.general.custom')}}
							                  				</label> 	
						                  				</div>
						                  				
						                  				<div flex=50 ng-if=scheduling.monthsCustom>					                  				
						                  					<md-button aria-label="menu" class="md-raised md-mini" ng-click="monthsClearSelections();setFormDirty()" 
											      					ng-show="selectedDataSet" title="Fields metadata" style="margin-top:0; margin-bottom:0;">
												            	{{translate.load('sbi.ds.persist.cron.scheduling.multipleselect.clearall')}} 
												          	</md-button>				                  				
						                  				</div>
						                  							                  		
													</div>
													
												</div>
											
											</div>											
											
										</md-whiteframe>	
										<!-- </div> -->
										
										<!-- WEEKDAY -->
										<!-- <div flex=100 style="display:flex; background-color:#eceff1; margin-top:8px"> -->
										<md-whiteframe class="md-whiteframe-5dp" style="display:flex; padding:8; margin-top:8; margin-bottom:8;">
																					
											<div flex=100 layout="row" style="display:flex">
											
												<div flex=20 style="align-items:center; display:flex">
													<label style="margin: 4 0 4 0; color:#A9A9A9">
														{{translate.load('sbi.ds.persist.cron.weekday')}}s:
													</label>												
												</div>
												
												<!-- VERTICAL ALIGNMENT INSIDE THE DIV: align-items:center; display:flex -->
												<div flex=40 style="align-items:center; display:flex">
													
													<label style="margin: 4 0 4 0; color:#A9A9A9" ng-if=!scheduling.weekdaysCustom>
														<strong>{{translate.load('sbi.ds.persist.cron.everyweekday')}}</strong>
													</label>
													
													<md-select placeholder ="Select weekday(s)"
											        	ng-required = "selectedDataSet.isScheduled" ng-if=scheduling.weekdaysCustom multiple=true
											        	ng-model="scheduling.weekdaysSelected" style="margin:0; width:80%" title="{{scheduling.weekdaysSelected}}">   
											        	<md-option ng-repeat="l in weekdays" value="{{l.value}}" ng-mousedown="setFormDirty()">
											        		{{l.name}}
											        	</md-option>
										       		</md-select> 
														
												</div>
												
												<div flex=40>
													
													<div layout="row" layout-align="start center">
							           	
							           					<div flex=50>
								                  			<md-input-container class="small counter" style="margin:8;">
								                     			<md-checkbox 	aria-label="Checkbox 2" 
										                     					ng-model="scheduling.weekdaysCustom" ng-checked="" 
										                     					ng-mousedown="setFormDirty()">
																</md-checkbox>
								                  			</md-input-container>
								                  			
								                  			<label>
								                  				{{translate.load('sbi.general.custom')}}
							                  				</label> 	
						                  				</div>
						                  				
						                  				<div flex=50 ng-if=scheduling.weekdaysCustom>					                  				
						                  					<md-button aria-label="menu" class="md-raised md-mini" ng-click="weekdaysClearSelections();setFormDirty()" 
											      					ng-show="selectedDataSet" title="Fields metadata" style="margin-top:0; margin-bottom:0;">
												            	{{translate.load('sbi.ds.persist.cron.scheduling.multipleselect.clearall')}} 
												          	</md-button>				                  				
						                  				</div>
						                  							                  		
													</div>
													
												</div>
											
											</div>
										
										</md-whiteframe>	
										<!-- </div> -->
										
										<div flex=100 style="margin-top:8px; display:flex">
											
											<md-input-container class="md-block" flex-gt-sm>								
									           	<label>{{translate.load("sbi.ds.persist.cron.schedulingline")}}</label>											
												<input ng-model="scheduling.cronDescriptionDate" readonly="readonly">				    						 	
								         	</md-input-container>
											
										</div>
										
										<div flex=100 style="display:flex">
											
											<md-input-container class="md-block" flex-gt-sm>
										    	<label>{{translate.load("sbi.ds.persist.cron.nextfire")}}</label>
												<input ng-model="scheduling.cronDescriptionTime" readonly="readonly">
											</md-input-container>
											
										</div>
									
									</div>
									
								</div>
							
							</md-card>
							
						</md-content>
						
				     </md-tab>						
						
					</md-tabs>
	       		
	       		</form>
	       
	       </detail>
	       
		</angular-view-detail>
	
	</body>
	
</html>