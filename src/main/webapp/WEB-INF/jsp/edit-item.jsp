<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
<jsp:attribute name="content">
	<spring:url value="/admin/edit-item/${item.id}" var="url"/>
	<form:form method="POST" class="pure-form pure-form-aligned" action="${url}">
		<fieldset>
			<legend>Edition object</legend>
			<div class="pure-control-group">
				<label for="name">Nom</label>
				<input name="name" type="text" required="required" value="${item.name}">
			</div>
			<div class="pure-control-group">
				<label for="raid">Raid</label>
				<select name="raid">
					<c:forEach items="${raids}" var="c">
						<option value="${c}" <c:if test="${item.raid==c}">selected="selected"</c:if>>${c}</option>
					</c:forEach>
				</select>
			</div>
			<div class="pure-control-group">
				<label for="boss">Boss</label>
				<input name="boss" type="text" required="required" value="${item.boss}">
			</div>
			<div class="pure-controls">
				<button type="submit" class="pure-button pure-button-primary">Valider</button>
			</div>
		</fieldset>
	</form:form>
</jsp:attribute>
</t:template>