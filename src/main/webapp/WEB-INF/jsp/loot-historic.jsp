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
					<th>Joueur</th>
					<th>Loot en Wish List</th>
					<th>Loot en +1</th>
					<th>Loot en +2</th>
					<th>Sacs / Monture</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${players}" var="player">
					<tr class="${player.clazz}">
						<td>
							<img class="class" src='<spring:url value="/img/${player.clazz}.jpg"/>'/>
							${player.displayName}
						</td>
						<td>
							<ul>
								<c:forEach items="${player.getLoots('wishList')}" var="loot">
									<li>
										<c:if test="${loot.item.big}"><strong>${loot.item.name}</strong></c:if>
										<c:if test="${not loot.item.big}">${loot.item.name}</c:if>
										<em><small><fmt:formatDate pattern="dd/MM/yyyy" value="${loot.lootDate}"/></small></em>
									</li>
								</c:forEach>
							</ul>
						</td>
						<td>
							<ul>
								<c:forEach items="${player.getLoots('primary')}" var="loot">
									<li>
										<c:if test="${loot.item.big}"><strong>${loot.item.name}</strong></c:if>
										<c:if test="${not loot.item.big}">${loot.item.name}</c:if>
										<em><small><fmt:formatDate pattern="dd/MM/yyyy" value="${loot.lootDate}"/></small></em>
									</li>
								</c:forEach>
							</ul>
						</td>
						<td>
							<ul>
								<c:forEach items="${player.getLoots('secondary')}" var="loot">
									<li>
										<c:if test="${loot.item.big}"><strong>${loot.item.name}</strong></c:if>
										<c:if test="${not loot.item.big}">${loot.item.name}</c:if>
										<em><small><fmt:formatDate pattern="dd/MM/yyyy" value="${loot.lootDate}"/></small></em>
									</li>
								</c:forEach>
							</ul>
						</td>
						<td>
							<ul>
								<c:forEach items="${player.getLoots('bag')}" var="loot">
									<li>
										<c:if test="${loot.item.big}"><strong>${loot.item.name}</strong></c:if>
										<c:if test="${not loot.item.big}">${loot.item.name}</c:if>
										<em><small><fmt:formatDate pattern="dd/MM/yyyy" value="${loot.lootDate}"/></small></em>
									</li>
								</c:forEach>
							</ul>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<table class="pure-table pure-table-horizontal pure-table-striped">
			<thead>
				<tr>
					<th>Date</th>
					<th>Loot en Wish List</th>
					<th>Loot en +1</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${loots.dates}" var="date">
					<tr>
						<td><fmt:formatDate pattern="dd/MM/yyyy" value="${date}"/></td>
						<td>
							<ul>
								<c:forEach items="${loots.getLoots(date,'wishList')}" var="loot">
									<li>${loot.player.name} :
										<c:if test="${loot.item.big}"><strong>${loot.item.name}</strong></c:if>
										<c:if test="${not loot.item.big}">${loot.item.name}</c:if>
									</li>
								</c:forEach>
							</ul>
						</td>
						<td>
							<ul>
								<c:forEach items="${loots.getLoots(date,'primary')}" var="loot">
									<li>${loot.player.name} :
										<c:if test="${loot.item.big}"><strong>${loot.item.name}</strong></c:if>
										<c:if test="${not loot.item.big}">${loot.item.name}</c:if>
									</li>
								</c:forEach>
							</ul>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</jsp:attribute>
	<jsp:attribute name="script">
	</jsp:attribute>
</t:template>