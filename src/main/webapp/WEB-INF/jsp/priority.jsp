<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<table class="pure-table pure-table-horizontal">
			<thead>
				<tr>
					<th colspan="2">Objet</th>
					<th colspan="3">Personnage</th>
					<c:if test="${user.mdc}">
						<th>Sel</th>
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
						<th colspan="7"></th>
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
							<td>${p.attribution.shorten}</td>
							<td>${p.item.name}</td>
							<td>${p.player.name}</td>
							<td><img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/></td>
							<td class="border-right">${p.player.rank.fr}</td>
							<c:if test="${user.mdc}">
								<td><input type="checkbox" data-url="<spring:url value="/priority/${p.player.id}/${p.item.id}"/>" <c:if test="${p.selected}"> checked="checked"</c:if>/></td>
								<td class="border-right">
									<c:if test="${p.looted}">Obtenu</c:if>
									<c:if test="${not p.looted}">${p.order}</c:if>
								</td>
								<td>${p.stat.ev}</td>
								<td>${p.stat.gp}</td>
								<td class="border-right">${p.stat.evgpRatio} %</td>
								<td>${p.stat.nbLoot}</td>
								<td class="border-right">${p.stat.ratio} %</td>
								<td>${p.stat.nbRaid}</td>
								<td>${p.stat.nbRaidWithoutLoot}</td>
								<td class="border-right">${p.nbRaidWait}</td>
								<td>${p.stat.getAttendance('MC','always').attendance}</td>
								<td>${p.stat.getAttendance('BWL','always').attendance}</td>
								<td>${p.stat.getAttendance('AQ40','always').attendance}</td>
								<td>${p.stat.getAttendance('ZG','always').attendance}</td>
								<td class="border-right">${p.stat.getAttendance('AQ20','always').attendance}</td>
								<td>${p.stat.getAttendance('MC','day14').attendance}</td>
								<td>${p.stat.getAttendance('BWL','day14').attendance}</td>
								<td>${p.stat.getAttendance('AQ40','day14').attendance}</td>
								<td>${p.stat.getAttendance('ZG','day14').attendance}</td>
								<td>${p.stat.getAttendance('AQ20','day14').attendance}</td>
							</c:if>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
	<jsp:attribute name="script">
		<script type="text/javascript">
			$(function(){
				$("input[type=checkbox]").on("click", function(e) {
					$.ajax({
						url : $(e.target).attr("data-url")
					})
				})
			});
		</script>
	</jsp:attribute>
</t:template>