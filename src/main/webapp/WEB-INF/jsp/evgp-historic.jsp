<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<table class="pure-table pure-table-horizontal class-color">
			<thead>
				<tr>
					<th>Personnage</th>
					<th>Raid</th>
					<th>Date</th>
					<th>EV</th>
					<th>ER</th>
					<th>Loot</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${histories}" var="h">
					<tr class="${h.player.clazz}">
						<td>
							<img class="class" src='<spring:url value="/img/${h.player.clazz}.jpg"/>'/>
							${h.player.name}
							<c:if test="${h.reroll}">
								<small>En reroll avec ${h.rerollName}</small>
							</c:if> 
						</td>
						<td>[${h.raid.instance}] ${h.raid.name}</td>
						<td><fmt:formatDate pattern="dd/MM/yyyy" value="${h.raid.date}"/></td>
						<td>${h.stat.ev} <small>(${h.stat.evInitial})</small></td>
						<td>${h.stat.er} <small>(${h.stat.erInitial})</small></td>
						<td>
							<c:forEach items="${h.player.loots}" var="l">
								<c:if test="${l.item.big}"><strong>${l.item.name}</strong></c:if>
								<c:if test="${not l.item.big}">${l.item.name}</c:if>
								${l.gp} <small>(${l.initialGp})</small> <br/>
							</c:forEach>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
	<jsp:attribute name="script">
	</jsp:attribute>
</t:template>