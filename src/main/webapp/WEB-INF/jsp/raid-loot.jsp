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
							<option value="${c.id}" data-wish="${c.attribution != null}" data-attribution="${c.attribution}">
								${c.name}
								<c:if test="${c.attribution != null}">(Wish List : ${c.attribution.shorten}) </c:if>
							</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-controls">
					<label for="ratio" class="pure-checkbox">
						<input type="checkbox" name="wishlist"<c:if test="${items[0].attribution != null}"> checked="checked"</c:if> >
						Attribuée sur Wish List
					</label>
				</div>
				<div class="pure-control-group">
					<label for="attribution">Valeur</label>
					<select name="attribution">
						<c:forEach items="${attributions}" var="a">
							<option value="${a}" <c:if test="${items[0].attribution==a}">selected="selected"</c:if>>${a.shorten}</option>
						</c:forEach>
					</select>
				</div>
				<div class="pure-controls">
					<button type="submit" class="pure-button pure-button-primary">Ajouter</button>
				</div>
			</fieldset>
		</form:form>
	</jsp:attribute>
	<jsp:attribute name="script">
		<script src="<spring:url value="/js/raid-loot.js"/>"></script>
	</jsp:attribute>
</t:template>