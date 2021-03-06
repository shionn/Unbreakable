<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
<jsp:attribute name="content">

	<c:if test="${user.mdc}">
		<spring:url value="/wish" var="url"/>
		<form:form method="GET" class="pure-form-aligned" action="${url}">
			<fieldset>
				<legend>Voir la liste de souhait d'un joueur</legend>
				<div class="pure-control-group">
					<label for="player">Joueur</label>
					<select name="player">
						<c:forEach items="${players}" var="c">
							<option value="${c.id}">${c.name}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-controls">
					<button type="submit" class="pure-button pure-button-primary">Voir</button>
				</div>
			</fieldset>
		</form:form>

		<c:if test="${player != null}">
			<spring:url value="/wish/update" var="url"/>
			<form:form method="POST" class="pure-form-aligned" action="${url}" modelAttribute="player">
				<input type="hidden" name="id" value="${player.id}" />
				<fieldset>
					<legend>Liste de souhait de ${player.name} (${player.clazz})</legend>
					<c:forEach items="${player.wishes}" var="w" varStatus="s">
						<div class="pure-control-group">
							<select name="wishes[${s.index}].item.id">
								<c:forEach items="${items}" var="item">
									<option value="${item.id}" <c:if test="${w.item.id==item.id}">selected="selected"</c:if>>${item.name}</option>
								</c:forEach>
							</select>
							<select name="wishes[${s.index}].attribution">
								<c:forEach items="${attributions}" var="attribution">
									<option value="${attribution}" <c:if test="${w.attribution==attribution}">selected="selected"</c:if>>${attribution.shorten}</option>
								</c:forEach>
							</select>
						</div>
					</c:forEach>
					<div class="pure-controls">
						<button type="submit" class="pure-button pure-button-primary">Modifier</button>
					</div>
				</fieldset>
			</form:form>
		</c:if>
	</c:if>

	<table class="pure-table pure-table-horizontal">
		<thead>
			<tr>
				<th colspan="3">Joueur</th><th>Objet</th><th> </th><th>Date d'ajout</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${wishes}" var="wish">
				<tr class="${wish.player.clazz}">
					<td>${wish.player.name}</td>
					<td><img class="class" src='<spring:url value="/img/${wish.player.clazz}.jpg"/>'/></td>
					<td>${wish.player.rank.fr}</td>
					<td>${wish.item.name}</td>
					<td>${wish.attribution.shorten}</td>
					<td><fmt:formatDate value="${wish.created}" pattern="dd/MM/yyyy"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

</jsp:attribute>
</t:template>