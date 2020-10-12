<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<t:template>
	<jsp:attribute name="content">
		<h1>Fonctionnement des EVGP</h1>
		<p>Normalement, le vrais nom c'est EPGP, pour Effort Point et Gain Point.
		Mais ouvrez vos chakras, on va dire EVGP.</p>
		<h2>GP</h2>
		<p>Les GP comptabilise la valeur des objets aquis par le perssonnage. Cette valeur est fonction de l'ilvl de l'objet et du slot.
		On peu bien sur modifier cette règle de calcul.</p>
		<table class="pure-table pure-table-horizontal pure-table-striped">
			<thead>
				<tr>
					<th>Slot</th><th>regle de calcul</th><th>Exemple</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Arme à une main</td><td>ilvl*ilvl*0.42</td><td>Epée trempée chromatiquement 77*77*0.42 = 2490</td>
				</tr>
				<tr>
					<td>Arme à distance</td><td>ilvl*ilvl*0.42</td><td>Ashjre'thul, arbalète de châtiment 77*77*0.42 = 2490</td>
				</tr>
				<tr>
					<td>Baguette</td><td>ilvl*ilvl*0.42</td><td>Récolteur d'essence 70*70*0.42 = 2058</td>
				</tr>
				<tr>
					<td>Anneau</td><td>ilvl*ilvl*0.55</td><td>Anneau d'élémentium Pur 83*83*0.55 = 3788</td>
				</tr>
				<tr>
					<td>Bouclier</td><td>ilvl*ilvl*0.55</td><td>Bouclier en élémentium renforcé 77*77*0.55 = 3260</td>
				</tr>
				<tr>
					<td>Bracelet</td><td>ilvl*ilvl*0.55</td><td>Brassards de précision des arcanes 75*75*0.55 = 3093</td>
				</tr>
				<tr>
					<td>Cape</td><td>ilvl*ilvl*0.55</td><td>Cape brochée d'élémentium 77*77*0.55 = 3260</td>
				</tr>
				<tr>
					<td>Collier</td><td>ilvl*ilvl*0.55</td><td>Talisman de perfidie de Prestor 83*83*0.55 = 3788</td>
				</tr>
				<tr>
					<td>Main gauche</td><td>ilvl*ilvl*0.55</td><td>TODO</td>
				</tr>
				<tr>
					<td>Bijou</td><td>ilvl*ilvl*0.7</td><td>Larme de Neltharion 83*83*0.7 = 4822</td>
				</tr>
				<tr>
					<td>Botte</td><td>ilvl*ilvl*0.777</td><td>Bottes Chromatiques 77*77*0.777 = 4606</td>
				</tr>
				<tr>
					<td>Ceinture</td><td>ilvl*ilvl*0.777</td><td>Ceinture T2 77*77*0.777 = 4606</td>
				</tr>
				<tr>
					<td>Epauliere</td><td>ilvl*ilvl*0.777</td><td>Espauliers griffe-de-drake 75*75*0.777 = 4370</td>
				</tr>
				<tr>
					<td>Gant</td><td>ilvl*ilvl*0.777</td><td>Gant T2 76*76*0.777 = 4487</td>
				</tr>
				<tr>
					<td>Arme à deux mains</td><td>ilvl*ilvl*1</td><td>Baton de la flamme d'ombre 81*81*1 = 6561</td>
				</tr>
				<tr>
					<td>Casque</td><td>ilvl*ilvl*1</td><td>Mish'undare, coiffure du flagelleur mental 83*83*1 = 6889</td>
				</tr>
				<tr>
					<td>Jambiere</td><td>ilvl*ilvl*1</td><td>Jambière Surpuissante T2 77*77*1 = 5929</td>
				</tr>
				<tr>
					<td>Torse</td><td>ilvl*ilvl*1</td><td>Torse T2 76*76*1 = 5776</td>
				</tr>
			</tbody>
		</table>
		<h2>EV</h2>
		<p>Les EV sont les points d'éffort fourni par les joueurs, il existe plusieurs méthode pour les comptabiliser.
		Ici le mode choisit est de prendre la valeur en GP des objets lootés dans le raid, de diviser par le nombre de joueur présent.</p>
		<p>Par exemple dans un raid de 10 personne, 2 items sont attribué en +1, la CTS à 2490 et le Baton de la flamme d'ombre à 6561.
		Le raid a donc une valeur en EV de 2490 + 6561 = 9051. Chaque raideur gagne donc 9051/10 = 905 EV.</p>
		<h2>Dépréciation</h2>
		<p>Les EVGP, ont une dépréciation de 15% par semaine.</p>
	</jsp:attribute>
</t:template>