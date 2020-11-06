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
						<th colspan="4" style="text-align:center">
							[${raid.instance}] ${raid.name}
							<fmt:formatDate pattern="dd/MM/yyyy" value="${raid.date}"/>
							(${raid.players.size()})
							<c:if test="${user.mdc}">
								| EV : ${raid.ev} (${raid.initialEv})
							</c:if>
							<c:if test="${user.ml}">
								<a href='<spring:url value="/raid/edit/${raid.id}"/>' class="pull-right fa fa-pencil"></a>
							</c:if>
						</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${raid.players}" var="e" varStatus="i">
						<tr class="${e.player.clazz}">
							<td>
								${e.player.displayName}
								<c:if test="${e.bench}"><i class="fa fa-university" aria-hidden="true" title="Bench"></i></c:if>
							</td>
							<td><img class="class" src='<spring:url value="/img/${e.player.clazz}.jpg"/>'/></td>
							<td>${e.player.rank.fr}</td>
							<td>
								<c:forEach items="${e.loots}" var="loot">
									${loot.item.name}
									<small>(${loot.attribution.shorten})</small>
									<c:if test="${user.mdc and loot.attribution.displayGp}"><strong>GP : ${loot.gp} (${loot.initialGp})</strong></c:if>,
								</c:forEach>
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