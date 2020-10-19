<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<c:if test="${items != null}" >
			<spring:url value="/raid/itemhelp" var="url"/>
			<form:form method="POST" class="pure-form-aligned" action="${url}">
				<fieldset>
					<legend>Aide à l'attribution</legend>
					<div class="pure-control-group">
						<label for="item">Item</label>
						<select name="item">
							<c:forEach items="${items}" var="item">
								<option value="${item.id}">${item.name}</option>
							</c:forEach>
						</select>
					</div>
					<div class="pure-controls">
						<button type="submit" class="pure-button pure-button-primary">Voir</button>
					</div>
				</fieldset>
			</form:form>
			<c:if test="${priorities != null}">
				<table class="pure-table pure-table-horizontal">
					<thead>
						<tr>
							<th colspan="3">Personnage</th>
							<th colspan="3">EVGP</th>
							<th>NbLoot</th>
							<th>Ratio</th>
							<th colspan="3">NbRaid</th>
							<th colspan="3">Présence</th>
							<th colspan="3">Présence / 14j</th>
							<th colspan="3">Présence / 28j</th>
						</tr>
						<tr>
							<th colspan="3"></th>
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
							<th>MC</th>
							<th>BWL</th>
							<th>AQ40</th>
							<th>MC</th>
							<th>BWL</th>
							<th>AQ40</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${priorities}" var="p">
							<tr>
								<td>${p.player.name}</td>
								<td><img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/></td>
								<td class="border-right">${p.player.rank.fr}</td>
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
								<td class="border-right">${p.stat.getAttendance('AQ40','always').attendance}</td>
								<td>${p.stat.getAttendance('MC','day14').attendance}</td>
								<td>${p.stat.getAttendance('BWL','day14').attendance}</td>
								<td class="border-right">${p.stat.getAttendance('AQ40','day14').attendance}</td>
								<td>${p.stat.getAttendance('MC','day28').attendance}</td>
								<td>${p.stat.getAttendance('BWL','day28').attendance}</td>
								<td>${p.stat.getAttendance('AQ40','day28').attendance}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</c:if>

		<c:forEach items="${runnings}" var="raid" varStatus="i">
			<spring:url value="/raid/update" var="url"/>
			<form:form method="POST" class="pure-form-aligned" modelAttribute="raid" action="${url}">
				<fieldset>
					<legend>${raid.name}</legend>
					<input type="hidden" name="id" value="${raid.id}">
					<div class="pure-control-group">
						<label for="name">Nom</label>
						<input type="text" name="name" value="${raid.name}">
					</div>
					<div class="pure-control-group">
						<label for="instance">Instance</label>
						<select name="instance">
							<c:forEach items="${instances}" var="c">
								<option value="${c}" <c:if test="${raid.instance==c}">selected="selected"</c:if>>${c}</option>
							</c:forEach>
						</select>
					</div>
					<div class="pure-control-group">
						<label for="date">Date</label>
						<input type="date" name="date" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${raid.date}"/>">
					</div>
					<div class="pure-controls">
						<label for="running">
							<input type="checkbox" name="running" <c:if test="${raid.running}"> checked="checked"</c:if>>
							En cours (une fois décoché le raid n'est plus éditable et tout est comptatbilisé).
						</label>
					</div>
					<div class="pure-controls">
						<button type="submit" class="pure-button pure-button-primary">Sauvegarder</button>
					</div>
<%-- 					<t:priority-table priorities="${raid.selectedWishList}"/> --%>
					<table class="pure-table pure-table-horizontal">
						<thead>
							<tr>
								<th colspan="4">Membre participant (<a href='<spring:url value="/raid/edit/member/${raid.id}"/>'>Editer / Ajouter</a>)</th>
							</tr>
							<tr>
								<th><a href='<spring:url value="/raid/sort/name"/>' style="text-decoration: none; color: black;">Personnage ${raid.players.size()}</a></th>
								<th><a href='<spring:url value="/raid/sort/clazz"/>' style="text-decoration: none; color: black;">Classe</a></th>
								<th>Rang</th>
								<th>Loot</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${raid.players}" var="e" varStatus="i">
								<tr class="${e.player.clazz}">
									<td>
										<input type="hidden" name="players[${i.index}].player.id" value="${e.player.id}">
										${e.player.name}
										<c:if test="${e.bench}"><i class="fa fa-university" aria-hidden="true"></i></c:if>
										<c:if test="${not e.visible}"><i class="fa fa-eye-slash" aria-hidden="true"></i></c:if>
									</td>
									<td><img class="class" src='<spring:url value="/img/${e.player.clazz}.jpg"/>'/></td>
									<td>${e.player.rank.fr}</td>
									<td>
										<c:forEach items="${e.loots}" var="loot">
											<a class="pure-button button-error button-xsmall" href='<spring:url value="/raid/loot/${raid.id}/${e.player.id}/${loot.item.id}"/>'>- ${loot.item.name} (${loot.attribution.shorten})</a>,
										</c:forEach>
										<a class="pure-button button-success button-xsmall" href='<spring:url value="/raid/loot/${raid.id}/${e.player.id}"/>'>+</a>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</fieldset>
			</form:form>
		</c:forEach>
		<spring:url value="/raid/add" var="url"/>
		<form:form method="POST" class="pure-form-aligned" action="${url}">
			<fieldset>
				<legend>Creer un Raid</legend>
				<div class="pure-control-group">
					<label for="name">Nom</label>
					<input type="text" name="name" required="required">
				</div>
				<div class="pure-control-group">
					<label for="instance">Instance</label>
					<select name="instance">
						<c:forEach items="${instances}" var="c">
							<option value="${c}">${c}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-control-group">
					<label for="date">Date</label>
					<input type="date" name="date" required="required" >
				</div>
				<div class="pure-controls">
					<button type="submit" class="pure-button pure-button-primary">Ajouter un raid</button>
				</div>
			</fieldset>
		</form:form>
	</jsp:attribute>
	<jsp:attribute name="script">
	</jsp:attribute>
</t:template>