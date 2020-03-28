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
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${priorities}" var="entry" varStatus="itemIndex">
					<c:forEach items="${entry.value}" var="p" varStatus="pIndex">
						<tr class="${(itemIndex.index%2==0)?'pure-table-odd':'pure-table-even'}">
							<td>${p.item.name}</td>
							<td>${p.player.name}</td>
							<td><img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/></td>
							<td>${p.player.rank}</td>
							<td>${p.order}</td>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
</t:template>