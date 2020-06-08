<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
			<form:form method="POST" class="pure-form pure-form-aligned" modelAttribute="raid">
				<fieldset>
					<legend>Ajout d'un loot</legend>
					<div class="pure-control-group">
						<label for="item">Object looter</label>
						<select name="item">
							<c:forEach items="${items}" var="c">
								<option value="${c.id}">${c.name}</option>
							</c:forEach>
						</select>
					</div>
					<div class="pure-control-group">
						<label for="ratio">Valeur</label>
						<input name="ratio" type="text" required="required" value="10"> <em>(10=+1/WL, 0=+2/sac/idole)</em>
					</div>
					<div class="pure-controls">
						<button type="submit" class="pure-button pure-button-primary">Ajouter</button>
					</div>
				</fieldset>
			</form:form>
	</jsp:attribute>
</t:template>