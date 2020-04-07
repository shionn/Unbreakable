<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<table class="pure-table pure-table-horizontal">
			<thead>
				<tr>
					<th>Joueur</th>
					<th>Loot en Wish List</th>
					<th>Autre loot</th>
					<th>Loot en +2</th>
					<th>Sacs</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${players}" var="player">
					<tr class="${player.clazz}">
						<td>
							<img class="class" src='<spring:url value="/img/${player.clazz}.jpg"/>'/>
							${player.name}
						</td>
						<td>
							<c:forEach items="${player.getLoots('wishList')}" var="item">${item.name}, </c:forEach>
						</td>
						<td>
							<c:forEach items="${player.getLoots('primary')}" var="item">${item.name}, </c:forEach>
						</td>
						<td>
							<c:forEach items="${player.getLoots('secondary')}" var="item">${item.name}, </c:forEach>
						</td>
						<td>
							<c:forEach items="${player.getLoots('bag')}" var="item">${item.name}, </c:forEach>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
	<jsp:attribute name="script">
	</jsp:attribute>
</t:template>