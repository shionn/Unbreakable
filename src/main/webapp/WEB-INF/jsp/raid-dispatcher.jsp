<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<H1 style="color:red">Toujours en cours de dev</H1>
		<c:forEach items="${raids}" var="raid">
			<div style="width: 800px; text-align: center">${raid.name} (${raid.players.size()})</div>
			<div style="display: flex;flex-direction: row;">
				<div class="rh col">
					<span class="rh player">Tank</span>
					<c:forEach items="${raid.getPlayers('Tank', 'Bear', 'ProtPaladin')}" var="player">
						<span class="rh player ${player.role}">
							<a href='<spring:url value="/raid-dispatcher/bench/${player.name}"/>' class="fa fa-university"></a>
							<c:if test="${player.moveable}">
								<a href='<spring:url value="/raid-dispatcher/move/${player.name}"/>' class="fa fa-retweet"></a>
							</c:if>
							${player.name}
							<c:if test="${player.isLate(raid.name)}"><i class="fa fa-clock-o"></i></c:if>
							<c:if test="${player.isTentative(raid.name)}"><i class="fa fa-balance-scale"></i></c:if>
						</span>
					</c:forEach>
				</div>
				<div class="rh col">
					<span class="rh player">Healer</span>
					<c:forEach items="${raid.getPlayers('Priest', 'HolyPaladin', 'RestoDruid')}" var="player">
						<span class="rh player ${player.role}">
							<a href='<spring:url value="/raid-dispatcher/bench/${player.name}"/>' class="fa fa-university"></a>
							<c:if test="${player.moveable}">
								<a href='<spring:url value="/raid-dispatcher/move/${player.name}"/>' class="fa fa-retweet"></a>
							</c:if>
							${player.name}
							<c:if test="${player.isLate(raid.name)}"><i class="fa fa-clock-o"></i></c:if>
							<c:if test="${player.isTentative(raid.name)}"><i class="fa fa-balance-scale"></i></c:if>
						</span>
					</c:forEach>
				</div>
				<div class="rh col">
					<span class="rh player">Dps Mag</span>
					<c:forEach items="${raid.getPlayers('Mage', 'Warlock', 'Shadow', 'Balance')}" var="player">
						<span class="rh player ${player.role}">
							<a href='<spring:url value="/raid-dispatcher/bench/${player.name}"/>' class="fa fa-university"></a>
							<c:if test="${player.moveable}">
								<a href='<spring:url value="/raid-dispatcher/move/${player.name}"/>' class="fa fa-retweet"></a>
							</c:if>
							${player.name}
							<c:if test="${player.isLate(raid.name)}"><i class="fa fa-clock-o"></i></c:if>
							<c:if test="${player.isTentative(raid.name)}"><i class="fa fa-balance-scale"></i></c:if>
						</span>
				</c:forEach>
				</div>
				<div class="rh col">
					<span class="rh player">Dps Physique</span>
					<c:forEach items="${raid.getPlayers('Warrior', 'Rogue', 'Hunter', 'Feral', 'Retri')}" var="player">
						<span class="rh player ${player.role}">
							<a href='<spring:url value="/raid-dispatcher/bench/${player.name}"/>' class="fa fa-university"></a>
							<c:if test="${player.moveable}">
								<a href='<spring:url value="/raid-dispatcher/move/${player.name}"/>' class="fa fa-retweet"></a>
							</c:if>
							${player.name}
							<c:if test="${player.isLate(raid.name)}"><i class="fa fa-clock-o"></i></c:if>
							<c:if test="${player.isTentative(raid.name)}"><i class="fa fa-balance-scale"></i></c:if>
						</span>
					</c:forEach>
				</div>
			</div>
		</c:forEach>
		<spring:url value="/raid-dispatcher?${_csrf.parameterName}=${_csrf.token}" var="action" />
		<form:form method="POST" class="pure-form-aligned" enctype="multipart/form-data" action="${action}">
			<fieldset>
				<legend>Importer un raid helper</legend>
				<div class="pure-control-group">
					<label for="file">CSV</label>
					<input type="file" name="file">
				</div>
				<div class="pure-controls">
					<button type="submit" class="pure-button pure-button-primary">Ajouter</button>
				</div>
			</fieldset>
		</form:form>
	</jsp:attribute>
</t:template>