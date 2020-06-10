<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<c:if test="${user.mdc}">
			<table class="pure-table pure-table-horizontal">
				<thead style="position: sticky;top: 0;">
					<tr>
						<th colspan="3">Personnage</th>
						<th colspan="3">EVGP</th>
						<th>NbLoot</th>
						<th colspan="2">NbRaid</th>
						<th colspan="3">Présence</th>
						<th colspan="3">Présence / 14j</th>
					</tr>
					<tr>
						<th colspan="3"></th>
						<th>EV</th>
						<th>GP</th>
						<th>%</th>
						<th></th>
						<th>Total</th>
						<th>SsLoot</th>
						<th>BWL</th>
						<th>MC</th>
						<th>ZG</th>
						<th>BWL</th>
						<th>MC</th>
						<th>ZG</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${players}" var="s">
						<tr class="${s.player.clazz}">
							<td>${s.player.name}</td>
							<td><img class="class" src='<spring:url value="/img/${s.player.clazz}.jpg"/>'/></td>
							<td>${s.player.rank}</td>
							<td>${s.ev}</td>
							<td>${s.gp}</td>
							<td>${s.evgpRatio}</td>
							<td>${s.nbLoot/10}</td>
							<td>${s.nbRaid/10}</td>
							<td>${s.nbRaidWithoutLoot/10}</td>
							<td>${s.getAttendance('BWL','always').attendance}</td>
							<td>${s.getAttendance('MC','always').attendance}</td>
							<td>${s.getAttendance('ZG','always').attendance}</td>
							<td>${s.getAttendance('BWL','day14').attendance}</td>
							<td>${s.getAttendance('MC','day14').attendance}</td>
							<td>${s.getAttendance('ZG','day14').attendance}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
		<table class="pure-table pure-table-horizontal">
			<thead style="position: sticky;top: 0;">
				<tr>
					<th>Nom</th>
					<th>NbLoot</th>
					<th>Derniere fois</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${items}" var="i">
					<tr>
						<td>${i.name}</td>
						<td>${i.count}</td>
						<td><fmt:formatDate value="${i.last}" pattern="dd/MM/yyyy"/></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
</t:template>