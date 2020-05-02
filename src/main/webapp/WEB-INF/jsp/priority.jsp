<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<table class="pure-table pure-table-horizontal">
			<thead style="position: sticky;top: 0;">
				<tr>
					<th>Objet</th>
					<th colspan="3">Personnage</th>
					<c:if test="${user.mdc}">
						<th>Priorité</th>
						<th>Point</th>
						<th>NbLoot</th>
						<th colspan="3">NbRaid</th>
						<th colspan="3">Présence</th>
						<th colspan="3">Présence / 14j</th>
					</c:if>
				</tr>
				<c:if test="${user.mdc}">
					<tr>
						<th colspan="7"></th>
						<th>Total</th>
						<th>SsLoot</th>
						<th>Attente</th>
						<th>BWL</th>
						<th>MC</th>
						<th>ZG</th>
						<th>BWL</th>
						<th>MC</th>
						<th>ZG</th>
					</tr>
				</c:if>
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
								<td>${p.nbLoot/10}</td>
								<td>${p.nbRaid/10}</td>
								<td>${p.nbRaidWithoutLoot/10}</td>
								<td>${p.nbRaidWait/10}</td>
								<td>${p.getAttendance('BWL','always').attendance}</td>
								<td>${p.getAttendance('MC','always').attendance}</td>
								<td>${p.getAttendance('ZG','always').attendance}</td>
								<td>${p.getAttendance('BWL','day14').attendance}</td>
								<td>${p.getAttendance('MC','day14').attendance}</td>
								<td>${p.getAttendance('ZG','day14').attendance}</td>
							</c:if>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
</t:template>