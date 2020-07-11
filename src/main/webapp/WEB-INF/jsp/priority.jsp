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
						<th colspan="3">EVGP</th>
						<th>NbLoot</th>
						<th>Ratio</th>
						<th colspan="3">NbRaid</th>
						<th colspan="5">Présence</th>
						<th colspan="5">Présence / 14j</th>
					</c:if>
				</tr>
				<c:if test="${user.mdc}">
					<tr>
						<th colspan="5"></th>
						<th>EV</th>
						<th>GP</th>
						<th>%</th>
						<th colspan="2"></th>
						<th>Total</th>
						<th>SsLoot</th>
						<th>Attente</th>
						<th>MC</th>
						<th>BWL</th>
						<th>AQ40</th>
						<th>ZG</th>
						<th>AQ20</th>
						<th>MC</th>
						<th>BWL</th>
						<th>AQ40</th>
						<th>ZG</th>
						<th>AQ20</th>
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
							<td style="border-right: 1px solid #cbcbcb">${p.player.rank}</td>
							<c:if test="${user.mdc}">
								<td style="border-right: 1px solid #cbcbcb">
									<c:if test="${p.looted}">Obtenu</c:if>
									<c:if test="${not p.looted}">${p.order}</c:if>
								</td>
								<td>${p.ev}</td>
								<td>${p.gp}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.evgpRatio} %</td>
								<td>${p.nbLoot/10}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.point} %</td>
								<td>${p.nbRaid/10}</td>
								<td>${p.nbRaidWithoutLoot/10}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.nbRaidWait/10}</td>
								<td>${p.getAttendance('MC','always').attendance}</td>
								<td>${p.getAttendance('BWL','always').attendance}</td>
								<td>${p.getAttendance('AQ40','always').attendance}</td>
								<td>${p.getAttendance('ZG','always').attendance}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.getAttendance('AQ20','always').attendance}</td>
								<td>${p.getAttendance('MC','day14').attendance}</td>
								<td>${p.getAttendance('BWL','day14').attendance}</td>
								<td>${p.getAttendance('AQ20','day14').attendance}</td>
								<td>${p.getAttendance('ZG','day14').attendance}</td>
								<td>${p.getAttendance('AQ40','day14').attendance}</td>
							</c:if>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
</t:template>