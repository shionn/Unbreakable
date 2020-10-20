<%@ tag pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="content" fragment="true"%>
<%@ attribute name="script" fragment="true"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.1/build/pure-min.css"
		integrity="sha384-oAOxQR6DkCoMliIh8yFnu25d7Eq/PHS21PClpwjOTeU2jRSq11vu66rf90/cZr47"
		crossorigin="anonymous">
<link rel="stylesheet" href="<spring:url value="/css/generated/style.css"/>" />
<title>Cerberus</title>
</head>
<body>
	<div class="pure-menu pure-menu-horizontal">
		<a href="#" class="pure-menu-heading pure-menu-link">Cerberus</a>
		<ul class="pure-menu-list">
			<li class="pure-menu-item"><a href='<spring:url value="/priority"/>' class="pure-menu-link">Prioritées</a></li>
			<li class="pure-menu-item pure-menu-has-children">
				<a href="#" class="pure-menu-link">Historique</a>
				<ul class="pure-menu-children">
					<li class="pure-menu-item"><a href='<spring:url value="/statistic"/>' class="pure-menu-link">Statistique</a></li>
					<li class="pure-menu-item"><a href='<spring:url value="/historic/raid"/>' class="pure-menu-link">Raids</a></li>
					<li class="pure-menu-item"><a href='<spring:url value="/historic/loot"/>' class="pure-menu-link">Loots</a></li>
				</ul>
			</li>
			<c:if test="${user.admin or user.mdc}">
				<li class="pure-menu-item pure-menu-has-children">
					<a href="#" class="pure-menu-link">Raid</a>
					<ul class="pure-menu-children">
						<li class="pure-menu-item"><a href='<spring:url value="/raid"/>' class="pure-menu-link">Raid en Cours</a></li>
						<li class="pure-menu-item"><a href='<spring:url value="/beforeraid"/>' class="pure-menu-link">Préparation</a></li>
						<c:if test="${user.superAdmin}">
							<li class="pure-menu-item"><a href='<spring:url value="/raid-dispatcher"/>' class="pure-menu-link">Répartiteur</a></li>
						</c:if>
					</ul>
				</li>
			</c:if>
			<li class="pure-menu-item"><a href='<spring:url value="/wish"/>' class="pure-menu-link">Liste de souhait</a></li>
			<c:if test="${user.mdc}">
				<li class="pure-menu-item"><a href='<spring:url value="/info"/>' class="pure-menu-link">Info</a></li>
			</c:if>
			<c:if test="${user.superAdmin}">
				<li class="pure-menu-item"><a href='<spring:url value="/armory"/>' class="pure-menu-link">Armurerie</a></li>
			</c:if>
			<li class="pure-menu-item"><a href='<spring:url value="/admin"/>' class="pure-menu-link">Admin</a></li>
			<c:if test="${user.admin}"><li class="pure-menu-item" style="color: red">ADMIN</li></c:if>
			<c:if test="${user.mdc and not user.admin}"><li class="pure-menu-item" style="color: red">MDC</li></c:if>
		</ul>
	</div>
	<c:if test="${not empty message}">
		<aside class="message success">${message}</aside>
	</c:if>
	<c:if test="${not empty error}">
		<aside class="message error">${error}</aside>
	</c:if>
	<jsp:invoke fragment="content" />
	<script src="<spring:url value="/js/jquery-3.2.1.min.js"/>"></script>
	<script src="<spring:url value="/js/jquery-ui-datepicker-1.12.1.min.js"/>"></script>
	<script src="<spring:url value="/js/jquery-ui-datepicker-fr-1.12.1.js"/>"></script>
	<script src="<spring:url value="/js/jquery-ui-timepicker-addon.min.js"/>"></script>
	<script src="<spring:url value="/js/jquery-ui-timepicker-fr.js"/>"></script>
	<script src="<spring:url value="/js/menu.js"/>"></script>
	<jsp:invoke fragment="script" />
</body>
</html>

