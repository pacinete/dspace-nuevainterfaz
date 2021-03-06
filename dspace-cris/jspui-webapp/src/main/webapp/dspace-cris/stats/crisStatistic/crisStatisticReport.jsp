<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    https://github.com/CILEA/dspace-cris/wiki/License

--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="researchertags" prefix="researcher"%>
<%@ page import="org.dspace.core.ConfigurationManager"%>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@page import="org.dspace.core.NewsManager" %>

<%
        String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));        

%>

<c:set var="contextPath" scope="application">${pageContext.request.contextPath}</c:set>
<c:set var="dspace.layout.head" scope="request">    
	<script type="text/javascript" src="${contextPath}/js/rgbcolor.js"></script>
	<script type="text/javascript" src="${contextPath}/js/canvg.js"></script>
	<script type="text/javascript" src="${contextPath}/js/stats.js"></script>
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">      
      google.load('visualization', '1.1', {packages: ['corechart', 'controls']});
    </script>
    	
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<link href="${contextPath}/css/stats.css" type="text/css" rel="stylesheet" />
	<style type="text/css">
	  #map_canvas { height: 100% }
	</style>
	
    <script src="//maps.googleapis.com/maps/api/js?key=<%= ConfigurationManager.getProperty("key.googleapi.maps") %>&sensor=true&v=3" type="text/javascript"></script>
	
	<script type="text/javascript">
		function setMessage(message,div){
			document.getElementById(div).innerHTML=message;
		}
		function setGenericEmpityDataMessage(div){
			document.getElementById(div).innerHTML='<fmt:message key="view.generic.data.empty" />';
		}
	</script>
</c:set>

<c:set var="type"><%=request.getParameter("type") %></c:set>
<c:set var="mode"><%=request.getParameter("mode") %></c:set>

<dspace:layout titlekey="jsp.statistics.${data.jspKey}.${mode}title">
<div class="row nomargintop" >
    <h1 class="pagehidden">crisStatisticReport.jsp</h1>
    
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
<div class="container">
    <br/><br/>
<div id="content">

 	<h1 class="clrcytc_blue">
            <fmt:message key="view.${data.jspKey}.page.title">
                <fmt:param>
                    <h1 class="clrcytc_blue"><fmt:message key="statistics.type.${data.target.simpleName}" /></fmt:param>
                <fmt:param><br/><br/>
                    <a href="${contextPath}/cris/${data.object.publicPath}/${data.object.crisID}">${data.title}</a>
                </fmt:param>
            </fmt:message></h1>
	
	<div class="pull-right">
		<span class="label label-info"><fmt:message key="view.statistics.range.from" /></span> &nbsp; 
			<c:if test="${empty data.stats_from_date}"><fmt:message key="view.statistics.range.no-start-date" /></c:if>
			${fn:escapeXml(data.stats_from_date)} &nbsp;&nbsp;&nbsp; 
		<span class="label label-info"><fmt:message key="view.statistics.range.to" /></span> &nbsp; 
			<c:if test="${empty data.stats_to_date}"><fmt:message key="view.statistics.range.no-end-date" /></c:if>
			${fn:escapeXml(data.stats_to_date)} &nbsp;&nbsp;&nbsp;
		<a class="btn btn-default bgcytc_green clrcytc_white brdradius font_bolder" data-toggle="modal" data-target="#stats-date-change-dialog"><fmt:message key="view.statistics.change-range" /></a>
	</div>	
	
	<div class="row">			 
	 <c:set var="type"><%=request.getParameter("type") %></c:set>
	 <%@include file="/dspace-cris/stats/common/changeRange.jsp"%>
	<%@ include file="/dspace-cris/stats/crisStatistic/_crisStatisticReport-right.jsp" %>

	<div class="richeditor">
		<div class="top"></div>
			<%@ include file="/dspace-cris/stats/crisStatistic/_crisStatisticReport.jsp" %>
		<div class="bottom"></div>
	</div> <%--close richeditor --%>
  </div><%--close tab contents --%>
</div>
</div>


	<div class="clear"></div>
</dspace:layout>