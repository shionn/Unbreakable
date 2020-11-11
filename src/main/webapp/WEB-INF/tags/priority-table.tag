<%@ tag pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ attribute name="priorities" fragment="false" type="java.util.List"%>
<c:if test="${not empty priorities}">
	<c:if test="${user.ml}">
		<a class="fa fa-clipboard copy" style="cursor: pointer;"> Copy lua data</a>
		<textarea style="width:0px;height:0px">${priorities}</textarea>
	</c:if>
	<table class="pure-table pure-table-horizontal">
		<thead>
			<tr>
				<th style="text-align: center">Objet</th>
				<th colspan="3">Personnage</th>
				<c:if test="${user.admin or user.mdc or user.ml}">
					<th colspan="3">EVGP / ERGP</th>
					<th colspan="3">Loots</th>
					<th colspan="3">NbRaid</th>
					<th colspan="3">Présence</th>
					<th colspan="3">Présence / 14j</th>
				</c:if>
			</tr>
			<c:if test="${user.admin or user.mdc or user.ml}">
				<tr>
					<th colspan="4"></th>
					<th>GP</th>
					<th>EV</th>
					<th>ER</th>
					<th>Dernier</th>
					<th>Nb</th>
					<th>Ratio</th>
					<th>Total</th>
					<th>SsLoot</th>
					<th>Attente</th>
					<th>MC</th>
					<th>BWL</th>
					<th>AQ40</th>
					<th>MC</th>
					<th>BWL</th>
					<th>AQ40</th>
				</tr>
			</c:if>
		</thead>
		<tbody>
			<c:forEach items="${priorities}" var="e" varStatus="itemIndex">
				<c:forEach items="${e}" var="p">
					<tr class="${(itemIndex.index%2==0)?'pure-table-odd':'pure-table-even'}">
						<td>${p.item.name}</td>
						<td>${p.player.name}</td>
						<td><img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/></td>
						<td class="border-right">${p.player.rank.fr}</td>
						<c:if test="${user.admin or user.mdc or user.ml}">
							<td>${p.stat.gp}</td>
							<td>${p.stat.ev} <small>${p.stat.evgpRatio}%</small></td>
							<td class="border-right">${p.stat.er} <small>${p.stat.ergpRatio}%</small></td>
							<td><fmt:formatDate value="${p.stat.lastLootDate}" pattern="dd/MM"></fmt:formatDate></td>
							<td>${p.stat.nbLoot}</td>
							<td class="border-right">${p.stat.ratio} %</td>
							<td>${p.stat.nbRaid}</td>
							<td>${p.stat.nbRaidWithoutLoot}</td>
							<td class="border-right">${p.nbRaidWait}</td>
							<td>${p.stat.getAttendance('MC','always').attendance}</td>
							<td>${p.stat.getAttendance('BWL','always').attendance}</td>
							<td class="border-right">${p.stat.getAttendance('AQ40','always').attendance}</td>
							<td>${p.stat.getAttendance('MC','day14').attendance}</td>
							<td>${p.stat.getAttendance('BWL','day14').attendance}</td>
							<td>${p.stat.getAttendance('AQ40','day14').attendance}</td>
						</c:if>
					</tr>
				</c:forEach>
			</c:forEach>
		</tbody>
	</table>
</c:if>
