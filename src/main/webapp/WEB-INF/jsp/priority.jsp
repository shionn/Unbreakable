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
					<th colspan="3">Personnage</th>
					<c:if test="${user.mdc}">
						<th>Priorité</th>
						<th>Point</th>
						<th>NbLoot</th>
						<th>NbRaid</th>
						<th>NbRaid<br/>Ss Loot</th>
						<th>NbRaid<br/>Attente</th>
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
							<c:if test="${user.mdc}">
								<td>
									<c:if test="${p.looted}">Obtenu</c:if>
									<c:if test="${not p.looted}">${p.order}</c:if>
								</td>
								<td>${p.point} %</td>
								<td>${p.nbLoot/100}</td>
								<td>${p.nbRaid/100}</td>
								<td>${p.nbRaidWithoutLoot/100}</td>
								<td>${p.nbRaidWait/100}</td>
							</c:if>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
</t:template>