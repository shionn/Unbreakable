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
					<div style="display: flex">
						<div style="width: 330px;border-right:1px solid #e5e5e5; margin-right: 15px;">
							<div style="text-align: center;font-weight: bold;">Membre / Casu / Test</div>
							<c:forEach items="${raid.players}" var="p" varStatus="s">
								<c:if test="${p.player.isRank('test','membre','casu')}">
									<div class="pure-g">
										<input type="hidden" name="players[${s.index}].player.id" value="${p.player.id}">
										<label class="pure-u-12-24">
											<input type="checkbox" name="players[${s.index}].member" <c:if test="${p.member}"> checked="checked"</c:if>>
											${p.player.name}
										</label>
										<label class="pure-u-4-24">
											<img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/>
			<%-- 								${p.player.rank.fr} --%>
										</label>
										<label class="pure-u-4-24">
											<input type="checkbox" name="players[${s.index}].bench" <c:if test="${p.bench}"> checked="checked"</c:if>>
											b
										</label>
										<label class="pure-u-4-24">
											<input type="checkbox" name="players[${s.index}].visible" <c:if test="${p.visible}"> checked="checked"</c:if>>
											v
										</label>
									</div>
								</c:if>
							</c:forEach>
						</div>
						<div style="width: 330px;border-right:1px solid #e5e5e5;margin-right: 15px;">
							<div style="text-align: center;font-weight: bold;">Associé</div>
							<c:forEach items="${raid.players}" var="p" varStatus="s">
								<c:if test="${p.player.isRank('pu')}">
									<div class="pure-g">
										<input type="hidden" name="players[${s.index}].player.id" value="${p.player.id}">
										<label class="pure-u-12-24">
											<input type="checkbox" name="players[${s.index}].member" <c:if test="${p.member}"> checked="checked"</c:if>>
											${p.player.name}
										</label>
										<label class="pure-u-4-24">
											<img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/>
			<%-- 								${p.player.rank.fr} --%>
										</label>
										<label class="pure-u-4-24">
											<input type="checkbox" name="players[${s.index}].bench" <c:if test="${p.bench}"> checked="checked"</c:if>>
											b
										</label>
										<label class="pure-u-4-24">
											<input type="checkbox" name="players[${s.index}].visible" <c:if test="${p.visible}"> checked="checked"</c:if>>
											v
										</label>
									</div>
								</c:if>
							</c:forEach>
						</div>
						<div style="width: 400px">
							<div style="text-align: center;font-weight: bold;">Reroll</div>
							<c:forEach items="${raid.players}" var="p" varStatus="s">
								<c:if test="${p.player.isRank('reroll')}">
									<div class="pure-g">
										<input type="hidden" name="players[${s.index}].player.id" value="${p.player.id}">
										<label class="pure-u-15-24">
											<input type="checkbox" name="players[${s.index}].member" <c:if test="${p.member}"> checked="checked"</c:if>>
											${p.player.name}
										</label>
										<label class="pure-u-3-24">
											<img class="class" src='<spring:url value="/img/${p.player.clazz}.jpg"/>'/>
			<%-- 								${p.player.rank.fr} --%>
										</label>
										<label class="pure-u-3-24">
											<input type="checkbox" name="players[${s.index}].bench" <c:if test="${p.bench}"> checked="checked"</c:if>>
											b
										</label>
										<label class="pure-u-3-24">
											<input type="checkbox" name="players[${s.index}].visible" <c:if test="${p.visible}"> checked="checked"</c:if>>
											v
										</label>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>
					<div class="pure-controls">
						<button type="submit" class="pure-button pure-button-primary">Sauvegarder</button>
					</div>
				</fieldset>
			</form:form>
	</jsp:attribute>
</t:template>