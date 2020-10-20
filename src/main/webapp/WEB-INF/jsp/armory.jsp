<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<c:forEach items="${groups}" var="g">
			<h1>${g.raid}</h1>
			<table class="pure-table pure-table-horizontal">
				<thead>
					<tr>
						<th>#</th>
						<c:forEach items="${g.getPlayers('priest')}" var="p">
							<th>${p.playerName}</th>
						</c:forEach>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${g.getItems('priest')}" var="i">
						<tr>
							<td>${i.itemName}</td>
							<c:forEach items="${g.getPlayers('priest')}" var="p">
								<td style="background-color: ${g.getBgColor(i.item, p.player)}">${g.getStatus(i.item, p.player)}</td>
							</c:forEach>
						</tr>
					</c:forEach>
				</tbody>
			</table>

		</c:forEach>
	</jsp:attribute>
	<jsp:attribute name="script">
	</jsp:attribute>
</t:template>