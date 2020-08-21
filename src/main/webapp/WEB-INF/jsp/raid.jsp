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
					<thead style="position: sticky;top: 0;">
						<tr>
							<th colspan="3">Personnage</th>
							<th colspan="3">EVGP</th>
							<th>NbLoot</th>
							<th>Ratio</th>
							<th colspan="3">NbRaid</th>
							<th colspan="5">Présence</th>
							<th colspan="5">Présence / 14j</th>
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
							<th>ZG</th>
							<th>AQ20</th>
							<th>MC</th>
							<th>BWL</th>
							<th>AQ40</th>
							<th>ZG</th>
							<th>AQ20</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${priorities}" var="p">
							<tr>
								<td>${p.player.name}</td>
								<td><img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/></td>
								<td style="border-right: 1px solid #cbcbcb">${p.player.rank}</td>
								<td>${p.stat.ev}</td>
								<td>${p.stat.gp}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.stat.evgpRatio} %</td>
								<td>${p.stat.nbLoot/10}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.point} %</td>
								<td>${p.stat.nbRaid/10}</td>
								<td>${p.stat.nbRaidWithoutLoot/10}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.nbRaidWait/10}</td>
								<td>${p.stat.getAttendance('MC','always').attendance}</td>
								<td>${p.stat.getAttendance('BWL','always').attendance}</td>
								<td>${p.stat.getAttendance('AQ40','always').attendance}</td>
								<td>${p.stat.getAttendance('ZG','always').attendance}</td>
								<td style="border-right: 1px solid #cbcbcb">${p.stat.getAttendance('AQ20','always').attendance}</td>
								<td>${p.stat.getAttendance('MC','day14').attendance}</td>
								<td>${p.stat.getAttendance('BWL','day14').attendance}</td>
								<td>${p.stat.getAttendance('AQ20','day14').attendance}</td>
								<td>${p.stat.getAttendance('ZG','day14').attendance}</td>
								<td>${p.stat.getAttendance('AQ40','day14').attendance}</td>
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
					<div class="pure-control-group">
						<label for="number">Point</label>
						<input type="text" name="point" value="${raid.point}"> <em>10=MC/BWL, ZG=5, Improvisé=0</em>
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
					<t:priority-table priorities="${raid.selectedWishList}"/>
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
									<td>${e.player.rank}</td>
									<td>
										<c:forEach items="${e.loots}" var="loot">
											<a class="pure-button button-error button-xsmall" href='<spring:url value="/raid/loot/${raid.id}/${e.player.id}/${loot.item.id}"/>'>- ${loot.item.name} (${loot.ratio})</a>,
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
				<div class="pure-control-group">
					<label for="number">Point</label>
					<input type="text" name="point" value="10">
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