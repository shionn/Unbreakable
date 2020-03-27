<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
<jsp:attribute name="content">
	<form:form method="POST" class="pure-form pure-form-aligned">
		<fieldset>
			<div class="pure-control-group">
				<label for="pseudo">Pseudo</label>
				<input name="pseudo" type="text" placeholder="pseudo" required="required">
			</div>
			<div class="pure-control-group">
				<label for="email">Email</label>
				<input name="email" type="email" placeholder="email" required="required">
			</div>
			<div class="pure-control-group">
				<label for="pass">Password</label>
				<input name="pass" type="password" placeholder="password" required="required">
			</div>
			<div class="pure-control-group">
				<label for="pass-confirm">Confirm Password</label>
				<input name="pass-confirm" type="password" placeholder="password" required="required">
			</div>
			<div class="pure-controls">
				<button type="submit" class="pure-button pure-button-primary">Valider</button>
			</div>
		</fieldset>
	</form:form>
</jsp:attribute>
</t:template>