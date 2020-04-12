<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<table class="pure-table pure-table-horizontal">
			<thead>
				<tr>
					<th>Objet</th>
					<th>Personnage</th>
					<th>Classe</th>
					<th>Rang</th>
					<th>Priorité</th>
					<c:if test="${user.admin}">
						<th>Point</th>
						<th>NbLoot</th>
						<th>NbRaid</th>
					</c:if>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${priorities}" var="entry" varStatus="itemIndex">
					<c:forEach items="${entry}" var="p" varStatus="pIndex">
						<tr class="${(itemIndex.index%2==0)?'pure-table-odd':'pure-table-even'}">
							<td>${p.item.name}</td>
							<td>${p.player.name}</td>
							<td><img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/></td>
							<td>${p.player.rank}</td>
							<td>
								<c:if test="${p.looted}">Obtenu</c:if>
								<c:if test="${not p.looted}">${p.order}</c:if>
							</td>
							<c:if test="${user.admin}">
								<td>${p.point}</td>
								<td>${p.nbLoot}</td>
								<td>${p.nbRaid}</td>
							</c:if>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
</t:template>