<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<c:forEach items="${raids}" var="raid" varStatus="i">
			<table class="pure-table pure-table-horizontal">
				<thead>
					<tr>
						<th colspan="4" style="text-align:center">${raid.name} <fmt:formatDate pattern="dd/MM/yyyy" value="${raid.date}"/> (${raid.players.size()})</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${raid.players}" var="e" varStatus="i">
						<tr class="${e.player.clazz}">
							<td>
								${e.player.name}
								<c:if test="${e.bench}"><i class="fa fa-university" aria-hidden="true" title="Bench"></i></c:if>
							</td>
							<td><img class="class" src='<spring:url value="/img/${e.player.clazz}.jpg"/>'/></td>
							<td>${e.player.rank}</td>
							<td>
								<c:forEach items="${e.items}" var="item">${item.name}, </c:forEach>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:forEach>
	</jsp:attribute>
	<jsp:attribute name="script">
	</jsp:attribute>
</t:template>