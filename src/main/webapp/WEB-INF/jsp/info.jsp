<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<p>Pour rensigné votre Wish List il suffit d'envoyer à Galy les item que vous
voulez, <b>par message privé via discord</b>.</p>
		<ul>
			<li>5 objet maximum</li>
			<li>Pas d'ordre sur ces 5 items</li>
			<li>A chaque fois que vous obtener un nouveau loot vous pouvez la mettre à jour.</li>
			<li>Si vous ne raider pas, vous perdrez en position</li>
		</ul>
		<p>La wish liste est une aide à l'aide à la decision du loot council.
EElle n'est pas absolut. Les officier peuvent y déroger.</p>
		<p>Quelque soit le cas, un reroll, ne sera jamais prioritare sur un main.</p>
	</jsp:attribute>
</t:template>