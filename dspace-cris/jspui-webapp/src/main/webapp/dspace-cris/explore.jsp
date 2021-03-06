<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    https://github.com/CILEA/dspace-cris/wiki/License

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@ page import="org.dspace.content.DSpaceObject" %>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.discovery.configuration.DiscoveryViewConfiguration" %>
<%@page import="org.dspace.app.webui.components.MostViewedBean"%>
<%@page import="org.dspace.app.webui.components.MostViewedItem"%>
<%@page import="org.dspace.discovery.SearchUtils"%>
<%@page import="org.dspace.discovery.IGlobalSearchResult"%>
<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilter" %>

<%@page import="org.dspace.core.NewsManager" %>


<%
        String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));        

	int discovery_panel_cols = 12;
	int discovery_facet_cols = 4;
	List<DiscoverySearchFilter> filters = (List<DiscoverySearchFilter>) request.getAttribute("filters");
%>
<c:set var="dspace.layout.head.last" scope="request">
<script type="text/javascript"><!--
function newRow(){
	var newRow = jQuery('div.row.template').clone().removeClass('template').removeClass('hidden').addClass('newRow');
	newRow.insertBefore(jQuery('#lastRow'));
	
	newRow.find('select.index option').filter(function() {
	    return $(this).text() == jQuery('#lastRow').find('select.index').val(); 
	}).prop('selected', true);
	
	newRow.find('input.query').val(jQuery('#lastRow').find('input.query').val());
	jQuery('#lastRow').find('select.index option:first').prop('selected', true);
	jQuery('#lastRow').find('input.query').val('');
}

function resetForm() {
	jQuery('div.row.newRow').remove();
}

function submitForm() {
	var query = '';
	var conj = '';
	jQuery('form div.row.datainput').not('.template').each(function(idx) {
		var index = jQuery(this).find('select.index').val();
		var terms =  jQuery(this).find('input.query').val();
		
		if (terms == '') return;
		if (index != '') {
			query += ' '+conj+ ' ' + index+':(' + terms + ')';
		}
		else {
			query += ' '+conj+ ' (' + terms + ')';
		}
		conj = jQuery(this).find('select.conjuction').val();
	});
	jQuery('#query').val(query);
	jQuery('#searchform').submit();
}

-->
</script>
</c:set>
<c:set var="fmtkey">
 jsp.layout.navbar-default.cris.${location}
</c:set>
<dspace:layout locbar="link" parenttitlekey="${fmtkey}" parentlink="/cris/explore/${location}" titlekey="${fmtkey}">

<div class="row nomargintop" >
    <h1 class="pagehidden">Explore.jsp</h1>
    
    <div class="rowimage">
        <img class="img-responsive" src="<%= request.getContextPath() %>/image/s.3.2-.png" width="100%" alt=""/>  
    </div>        
    <div class="topNews_msg">
        <%= topNews %>            
    </div> 
</div>
<br/><br/>
<div class=" rowtitlecytc bgcytc_blue nobrdradius">
    
    <h5 class=" panel-heading ">        
        <div class="container">
            <dspace:include page="/layout/location-bar.jsp" />            
        </div>        
    </h5>
</div> 
    <br/>
<div class="row">
	<div class="col-sm-4 col-md-3">
            <h2 class="htitlesearch bgcytc_lightblue brdradiusright clrcytc_white text-center"><fmt:message key="jsp.general.browse" />&nbsp;&nbsp;</h2>
		<ul class="nav nav-pills nav-stacked cris-tabs-menu">
		<c:forEach var="browse"  items="${browseNames}">
                    <li><a class="text-center clrcytc_blue font_bolder" href="<%= request.getContextPath() %>/browse?type=${browse}"><fmt:message key="browse.menu.${browse}" /></a></li>
		</c:forEach>
		</ul>
	</div>
	<div class="col-sm-8 col-md-9">
            <div class="container">
		<h2 class="htitlesearch clrcytc_blue"><fmt:message key="jsp.explore.${location}.search" /></h2>
		<form id="searchform" class="form-group" action="<%= request.getContextPath() %>/simple-search">
			<input type="hidden" id="location" name="location" value="${location}" />
			<input type="hidden" id="query" name="query" value="" />
		<div class="row datainput">
		<div class="col-xs-4 col-sm-3">
		<select class="index form-control bgcytc_green brdradius clrcytc_white font_bolder">
			<option value=""><fmt:message key="jsp.explore.index.all" /></option>
		<c:forEach var="filter" items="${filters}">
			<c:set var="i18nkey" value="jsp.search.filter.${filter.indexFieldName}" />
			<option value="${filter.indexFieldName}"><fmt:message key="${i18nkey}" /></option>
		</c:forEach>
		</select>
		</div>
		<div class="col-xs-6 col-sm-7">
		<input class="query form-control" type="text" size="60" />
		</div>
		<div class="col-xs-2">
		<select class="conjuction form-control bgcytc_lightgray clrcytc_darkgray font_bolder">
			<option>AND</option>
			<option>OR</option>
			<option>NOT</option>
		</select>
		</div>
		</div>
		<div class="row datainput">
		<div class="col-xs-4 col-sm-3">
		<select class="index form-control bgcytc_blue brdradius clrcytc_white font_bolder">
			<option value=""><fmt:message key="jsp.explore.index.all" /></option>
		<c:forEach var="filter" items="${filters}">
			<c:set var="i18nkey" value="jsp.search.filter.${filter.indexFieldName}" />
			<option value="${filter.indexFieldName}"><fmt:message key="${i18nkey}" /></option>
		</c:forEach>
		</select>
		</div>
		<div class="col-xs-6 col-sm-7">
		<input class="query form-control" type="text" size="60" />
		</div>
		<div class="col-xs-2">
		<select class="conjuction form-control bgcytc_lightgray clrcytc_darkgray font_bolder">
			<option>AND</option>
			<option>OR</option>
			<option>NOT</option>
		</select>
		</div>
		</div>
		<div class="row datainput" id="lastRow">
		<div class="col-xs-4 col-sm-3">
		<select class="index form-control bgcytc_lightblue brdradius clrcytc_white font_bolder">
			<option value=""><fmt:message key="jsp.explore.index.all" /></option>
		<c:forEach var="filter" items="${filters}">
			<c:set var="i18nkey" value="jsp.search.filter.${filter.indexFieldName}" />
			<option value="${filter.indexFieldName}"><fmt:message key="${i18nkey}" /></option>
		</c:forEach>
		</select>
		</div>
		<div class="col-xs-6 col-sm-7">
		<input class="query form-control" type="text" size="60" />
		</div>
		<div class="col-xs-2">
			<button onclick="javascript:newRow()" type="button"
				class="btn btn-info col-xs-12 brdradius"><fmt:message key="jsp.explore.index.add" /></button>
		</div>
		</div>
		<div class="row datainput template hidden ">
		<div class="col-xs-4 col-sm-3">
		<select class="index form-control">
			<option><fmt:message key="jsp.explore.index.all" /></option>
		<c:forEach var="filter" items="${filters}">
			<c:set var="i18nkey" value="jsp.search.filter.${filter.indexFieldName}" />
			<option value="${filter.indexFieldName}"><fmt:message key="${i18nkey}" /></option>
		</c:forEach>
		</select>
		</div>
		<div class="col-xs-6 col-sm-7">
		<input class="query form-control" type="text" size="60" />
		</div>
		<div class="col-xs-2">
		<select class="conjuction form-control">
			<option>AND</option>
			<option>OR</option>
			<option>NOT</option>
		</select>
		</div>
		</div>
		<div class="row">
		<br/>
		<div class="col-md-offset-6 col-md-3 col-sm-offset-4 col-sm-4 col-xs-6">
			<input type="reset" onclick="javascript:resetForm()"
				class="btn btn-default col-xs-12 bgcytc_gray brdradius clrcytc_white font_bolder" value="<fmt:message key="jsp.explore.index.reset" />" />
		</div>
		<div class="col-md-3 col-sm-4 col-xs-6">
			<input type="submit" onclick="javascript:submitForm()"
				class="btn btn-primary col-xs-12 bgcytc_green brdradius font_bolder" value="<fmt:message key="jsp.explore.index.search" />" />
		</div>
		</div>
		</form>
            </div>                
	</div>
</div>
<div class="clearfix"></div>
        <br/><br/>
    
	<div class="container ">
		<div class="col-sm-6 ctycenvios ">                    
		<%
			RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("top_recentsubmission");
		%>
		<%@ include file="/dspace-cris/explore/topObjectsRecent.jsp" %>
		</div>
		<div class="col-sm-6 ctycenvios">
		<%
			RecentSubmissions viewed = (RecentSubmissions) request.getAttribute("top_view");
		%>
		<%@ include file="/dspace-cris/explore/topObjectsViewed.jsp" %>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6 ctycenvios">
		<%
			RecentSubmissions cited = (RecentSubmissions) request.getAttribute("top_cited");
		%>
		<%@ include file="/dspace-cris/explore/topObjectsCited.jsp" %>
		</div>	
		<div class="col-sm-6 ctycenvios">
		<%
			RecentSubmissions download = (RecentSubmissions) request.getAttribute("top_download");
		%>
		<%@ include file="/dspace-cris/explore/topObjectsDownload.jsp" %>
		</div>
	</div>
            <br/><br/>

	<div class="row">         
            -->
        <br/>        <br/>

	<c:set var="discovery.searchScope" value="${location}" scope="request"/>
            <div class="container">
                <h3 class="htitlesearch  text-center bgcytc_lightblue clrcytc_white brdradius" style="margin:12px">

                        <fmt:message key="jsp.search.facet.refine" />   

                </h3>                 
                <%@ include file="/discovery/static-sidebar-facet.jsp" %>
            
            </div>
	</div>
</dspace:layout>
