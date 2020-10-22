<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">

	<p>Connecté avec les roles : ${user.roles}</p>

	<c:if test="${user.admin}">
		<spring:url value="/admin/create-player" var="url" />
		<form:form method="POST" class="pure-form-aligned" action="${url}">
			<fieldset>
				<legend>Creation joueur</legend>
				<div class="pure-control-group">
					<label for="pseudo">Pseudo</label>
					<input name="pseudo" type="text" placeholder="pseudo"
							required="required">
				</div>
				<div class="pure-control-group">
					<label for="class">Class</label>
					<select name="class">
						<c:forEach items="${playerclasses}" var="c">
							<option value="${c}">${c}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-control-group">
					<label for="rank">Grade</label>
					<select name="rank">
						<c:forEach items="${playerranks}" var="r">
							<option value="${r}">${r.fr}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-controls">
					<button type="submit" class="pure-button pure-button-primary">Valider</button>
				</div>
			</fieldset>
		</form:form>

		<spring:url value="/admin/edit-player" var="url" />
		<form:form method="POST" class="pure-form-stacked" action="${url}">
			<fieldset>
				<legend>Edition joueur</legend>
				<div class="pure-g" style="width:1000px">
					<div class="pure-u-1-3">
						<label for="id">Joueur à éditer</label>
						<select name="id">
							<c:forEach items="${players}" var="c">
								<option value="${c.id}">${c.name}</option>
							</c:forEach>
						</select>
					</div>
					<div class="pure-u-1-3" style="display: flex;flex-direction: column-reverse;">
						<button type="submit" class="pure-button pure-button-primary">Commencer l'édition</button>
					</div>
				</div>
			</fieldset>
		</form:form>

		<spring:url value="/admin/create-item" var="url" />
		<form:form method="POST" class="pure-form-aligned" action="${url}">
			<fieldset>
				<legend>Creation objet</legend>
				<div class="pure-control-group">
					<label for="name">Nom</label>
					<input name="name" type="text" placeholder="Nom"
							required="required">
				</div>
				<div class="pure-control-group">
					<label for="raid">Raid</label>
					<select name="raid">
						<c:forEach items="${raids}" var="c">
							<option value="${c}">${c}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-control-group">
					<label for="slot">Slot</label>
					<select name="slot">
						<c:forEach items="${slots}" var="c">
							<option value="${c}">${c.fr}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-control-group">
					<label for="ilvl">Ilvl</label>
					<input name="ilvl" type="text" required="required">
				</div>
				<div class="pure-control-group">
					<label for="big" class="pure-checkbox">Grosse item</label>
					<input type="checkbox" name="big" />
				</div>
				<div class="pure-control-group">
					<label for="boss">Boss</label>
					<input name="boss" type="text" placeholder="Boss"
							required="required">
				</div>
				<div class="pure-control-group">
					<label>Disponible pour :</label>
					<c:forEach items="${playerclasses}" var="cl" varStatus="s">
						<input type="checkbox" name="classes[${s.index}]" value="${cl}">${cl} &nbsp;
					</c:forEach>
				</div>
				<div class="pure-controls">
					<button type="submit" class="pure-button pure-button-primary">Valider</button>
				</div>
			</fieldset>
		</form:form>

		<spring:url value="/admin/edit-item" var="url" />
		<form:form method="POST" class="pure-form-stacked" action="${url}">
			<fieldset>
				<legend>Edition objet</legend>
				<div class="pure-g" style="width:1000px">
					<div class="pure-u-2-3">
						<label for="id">Object à éditer</label>
						<select name="id">
							<c:forEach items="${items}" var="c">
								<option value="${c.id}">${c.name} (${c.slot.fr} ${c.ilvl})</option>
							</c:forEach>
						</select>
					</div>
					<div class="pure-u-1-3" style="display: flex;flex-direction: column-reverse;">
						<button type="submit" class="pure-button pure-button-primary">Commencer l'édition</button>
					</div>
				</div>
			</fieldset>
		</form:form>

		<spring:url value="/admin/edit-boss" var="url" />
		<form:form method="POST" class="pure-form-stacked" action="${url}" style="margin-bottom:50px">
			<fieldset>
				<legend>Edition Boss</legend>
				<div class="pure-g" style="width:1000px">
					<div class="pure-u-1-3">
						<label for="bossname">Boss à éditer</label>
						<select name="bossname">
							<c:forEach items="${bosses}" var="b">
								<option value="${b}">${b}</option>
							</c:forEach>
						</select>
					</div>
					<div class="pure-u-1-3">
						<label for="newbossname">Nouveau Nom</label>
						<input name="newbossname" type="text" placeholder="Nom" required="required">
					</div>
					<div class="pure-u-1-3" style="display: flex;flex-direction: column-reverse;">
						<button type="submit" class="pure-button pure-button-primary">Rennomer</button>
					</div>
				</div>
			</fieldset>
		</form:form>
	</c:if>

</jsp:attribute>
<jsp:attribute name="script">
	<script src="<spring:url value="/js/admin.js"/>"></script>
</jsp:attribute>
</t:template>