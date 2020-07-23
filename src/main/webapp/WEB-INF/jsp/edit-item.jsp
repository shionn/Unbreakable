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
			<legend>Ajout loot</legend>
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
				<label for="slot">Slot</label>
				<select name="slot">
					<c:forEach items="${slots}" var="c">
						<option value="${c}" <c:if test="${item.slot==c}">selected="selected"</c:if>>${c}</option>
					</c:forEach>
				</select>
			</div>
			<div class="pure-control-group">
				<label for="ilvl">Ilvl</label>
				<input name="ilvl" type="text" required="required" value="${item.ilvl}">
			</div>
			<div class="pure-control-group">
				<label for="big" class="pure-checkbox">
					Grosse item
				</label>
				<input type="checkbox" name="big"<c:if test="${item.big}"> checked="checked"</c:if>/>
			</div>
			<div class="pure-control-group">
				<label for="boss">Boss</label>
				<input name="boss" type="text" required="required" value="${item.boss}">
			</div>
			<div class="pure-control-group">
				<label>Disponible pour :</label>
				<c:forEach items="${playerclasses}" var="cl" varStatus="s">
					<input type="checkbox" name="classes[${s.index}]" value="${cl}"<c:if test="${item.isAvailableFor(cl)}"> checked="checked"</c:if>>${cl} &nbsp;
				</c:forEach>
			</div>
			<div class="pure-controls">
				<button type="submit" class="pure-button pure-button-primary">Valider</button>
			</div>
		</fieldset>
	</form:form>
</jsp:attribute>
</t:template>