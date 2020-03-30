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
					<legend>Participant ${raid.name}</legend>
					<c:forEach items="${raid.players}" var="p" varStatus="s">
						<div class="pure-controls">
							<input type="hidden" name="players[${s.index}].player.id" value="${p.player.id}">
							<label>
								<input type="checkbox" name="players[${s.index}].member" <c:if test="${p.member}"> checked="checked"</c:if>>
								${p.player.name}
								<img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/>
								${p.player.rank}
							</label>
							<label>
								<input type="checkbox" name="players[${s.index}].bench" <c:if test="${p.bench}"> checked="checked"</c:if>>
								bench
							</label>
							<label>
								<input type="checkbox" name="players[${s.index}].visible" <c:if test="${p.visible}"> checked="checked"</c:if>>
								visible
							</label>
						</div>
					</c:forEach>
					<div class="pure-controls">
						<button type="submit" class="pure-button pure-button-primary">Sauvegarder</button>
					</div>
				</fieldset>
			</form:form>
	</jsp:attribute>
</t:template>