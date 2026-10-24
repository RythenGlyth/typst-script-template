// =============================================================================
// SHOWCASE & DEMONSTRATION FILE
// =============================================================================
// Demonstrates all mathematical environments, outdented lecture markers,
// hanging section numbers, dynamic notation registration, clean subproofs,
// and the alphabetical subject index (Stichwortverzeichnis).
// =============================================================================

#import "lib.typ": *

#show: script-doc.with(
  title: "Algebraische Topologie",
  subtitle: "Vorlesungsskript & Mitschrift",
  author: "Autor Name",
  lecturer: "Prof. Dr. N. N.",
  semester: "Wintersemester 202X/2Y",
  university: "Musteruniversität",
  version: "1.0",
  section-symbol: true,
  hanging-numbers: true, // Outdents § 1 and 1.1 into the margin
  prologue: [
    Dieses Skript begleitet die Vorlesung _„Algebraische Topologie“_.

    *Wichtiger Hinweis:* Dieses Skript ist ein inoffizielles Dokument und basiert auf persönlichen Mitschriften. Es wird keine Gewähr für Vollständigkeit und Fehlerfreiheit übernommen.

    Korrekturhinweise, konstruktive Kritik und Ergänzungsvorschläge sind jederzeit willkommen. Bitte senden Sie diese gerne an: `feedback@example.org`.
  ],
)

// Table of contents (depth 2 is the academic standard)
#table-of-contents(depth: 2)
#pagebreak()

= Homotopie und die Fundamentalgruppe

Die algebraische Topologie untersucht topologische Räume #idx([Raum], [topologischer]), indem sie ihnen algebraische Invarianten wie Gruppen #idx([Gruppe], [abelsche]), Ringe oder Moduln zuordnet. Das fundamentale Prinzip besteht darin, kontinuierliche geometrische Phänomene in diskrete, algebraisch berechenbare Strukturen zu übersetzen. Die grundlegendste dieser Invarianten ist die *Fundamentalgruppe* $pi_1(X, x_0)$ #notate($pi_1(X, x_0)$, [Fundamentalgruppe des Raumes $(X, x_0)$]) #idx("Fundamentalgruppe"), die von Henri Poincaré 1895 eingeführt wurde und geschlossene Schleifen bis auf stetige Deformation klassifiziert #idx([Deformation], [stetige]).

== Homotopie von Wegen

#definition(title: "Weg und geschlossene Kurve")[
  Sei $X$ ein topologischer Raum und $I = [0, 1] subset.eq RR$ #notate($I$, [Einheitsintervall $[0, 1] subset.eq RR$]) das Einheitsintervall.
  + Eine stetige Abbildung $gamma: I -> X$ heißt *Weg* (oder Pfad) #idx("Weg") #idx([Abbildung], [stetige]) in $X$ von $x_0 := gamma(0)$ nach $x_1 := gamma(1)$.
  + Gilt $gamma(0) = gamma(1)$, so heißt $gamma$ eine *Schleife* #idx("Schleife") (oder *geschlossene Kurve*#idx("Kurve", sub: "geschlossene")) mit Basispunkt $x_0$ #idx("Basispunkt").
] <def:path>

#intuition[
  Ein Weg ist die kontinuierliche Bahnkurve eines Teilchens, das sich von Zeitpunkt $t=0$ bis $t=1$ durch den Raum $X$ bewegt. Eine Schleife kehrt zum Ausgangspunkt zurück.
]

#definition(title: "Homotopie von Wegen")[
  Seien $gamma_0, gamma_1: I -> X$ zwei Wege in $X$ mit denselben Endpunkten, also $gamma_0(0) = gamma_1(0) =: x_0$ und $gamma_0(1) = gamma_1(1) =: x_1$.
  Eine *Homotopie relativ zu den Endpunkten* #idx("Homotopie", sub: "relativ zu Endpunkten") zwischen $gamma_0$ und $gamma_1$ ist eine stetige Abbildung
  $
    H: I times I -> X, quad (s, t) |-> H(s, t),
  $
  sodass für alle $s, t in I$ gilt:
  $
    H(s, 0) = gamma_0(s), quad H(s, 1) = gamma_1(s), \
    H(0, t) = x_0, quad H(1, t) = x_1.
  $
  In diesem Fall heißen $gamma_0$ und $gamma_1$ *homotop relativ zu den Endpunkten*, geschrieben $gamma_0 tilde.equiv_"rel" gamma_1$ #notate($gamma_0 tilde.equiv_"rel" gamma_1$, [Homotopie von Wegen relativ zu den Endpunkten]).
] <def:homotopy>

#proposition(title: "Äquivalenzrelation")[
  Die Relation $tilde.equiv_"rel"$ ist eine Äquivalenzrelation #idx("Äquivalenzrelation") auf der Menge aller Wege in $X$ mit festen Endpunkten $x_0, x_1$.
] <prop:equiv>

#proof[
  + *Reflexivität:* Für jeden Weg $gamma$ ist $H(s, t) := gamma(s)$ eine konstante Homotopie von $gamma$ zu $gamma$.
  + *Symmetrie:* Ist $H(s, t)$ eine Homotopie von $gamma_0$ nach $gamma_1$, so definiert $overline(H)(s, t) := H(s, 1 - t)$ eine Homotopie von $gamma_1$ nach $gamma_0$.
  + *Transitivität:* Sind $H_1$ von $gamma_0$ nach $gamma_1$ und $H_2$ von $gamma_1$ nach $gamma_2$ gegeben, so verkleben wir beide stetig:
    $
      H(s, t) := cases(
        H_1(s, 2t) & "für" 0 <= t <= 1/2,
        H_2(s, 2t - 1) & "für" 1/2 <= t <= 1.
      )
    $
    Nach dem Verklebelemma #idx("Verklebelemma") ist $H$ stetig, womit $gamma_0 tilde.equiv_"rel" gamma_2$ gezeigt ist.
]

#example(title: "Konvexe Teilmengen des Euklidischen Raums")[
  Sei $X subset.eq RR^n$ eine konvexe Teilmenge #idx("Konvexe Menge"). Seien $gamma_0, gamma_1: I -> X$ zwei beliebige Wege mit $gamma_0(0) = gamma_1(0)$ und $gamma_0(1) = gamma_1(1)$. Dann ist die lineare Verbindungshomotopie #idx("Verbindungshomotopie")
  $
    H(s, t) := (1 - t) gamma_0(s) + t gamma_1(s)
  $
  eine wohldefinierte Homotopie relativ zu den Endpunkten in $X$. Insbesondere ist jede Schleife in $RR^n$ nullhomotop #idx("Nullhomotopie").
] <ex:convex>

#remark[
  Die Äquivalenzklasse eines Weges $gamma$ unter Homotopie bezeichnen wir mit $[gamma]$ #notate($[gamma]$, [Homotopieklasse des Weges $gamma$]). Gemäß @prop:equiv und @ex:convex besitzt in $RR^n$ jede Schleife dieselbe Homotopieklasse wie die konstante Schleife $c_(x_0)(s) = x_0$. Für Hausdorff-Räume #idx("Hausdorff-Raum") sichert dies eine eindeutige Grenzpunktbildung.
]

#cetz.canvas({
  import cetz.draw: *
  // Sketching a topological path deformation
  line((-3, 0), (3, 0), stroke: 0.5pt + luma(150))
  bezier((-2, 0), (2, 0), (-0.5, 1.2), (0.5, 1.2), stroke: 1.2pt + col-theorem)
  bezier((-2, 0), (2, 0), (-0.5, -0.8), (0.5, -0.8), stroke: 1.2pt + col-definition)
  circle((-2, 0), radius: 2.5pt, fill: black)
  circle((2, 0), radius: 2.5pt, fill: black)
  content((-2, -0.3), [$x_0$])
  content((2, -0.3), [$x_1$])
  content((0, 1.2), text(fill: col-theorem)[$gamma_1$])
  content((0, -0.8), text(fill: col-definition)[$gamma_0$])
  content((0, 0.2), text(fill: col-intuition)[$H(s, t) arrow.t$])
})

// Clean single lecture marker transitioning to lecture 12 (demonstrating datetime auto-formatting)
#lecture(12, date: datetime(year: 2026, month: 11, day: 4))

= Die Fundamentalgruppe des Kreises

In diesem Abschnitt berechnen wir die erste nichttriviale Fundamentalgruppe: die des Kreises $S^1$ #notate($S^n$, [$n$-dimensionale Einheitssphäre]) #idx("Sphäre", sub: "1-Sphäre (Kreis)"). Die Methode beruht auf der Theorie der *Überlagerungen* #idx("Überlagerung"), die ein tiefes Zusammenspiel zwischen Analysis (Wegeliftung) und Gruppentheorie herstellt (wobei alle beteiligten Räume das Hausdorffsche Trennungsaxiom #idx([Trennungsaxiom], [$T_2$]) erfüllen).

#theorem(title: "Fundamentalgruppe der 1-Sphäre")[
  Die Fundamentalgruppe des Kreises $S^1$ ist unendlich zyklisch und isomorph zu den ganzen Zahlen:
  $
    pi_1(S^1, 1) tilde.equiv (ZZ, +).
  $
  Der Isomorphismus wird vermittelt durch den Abbildungsgrad (Windungszahl) #idx("Windungszahl") einer Schleife.
] <thm:pi1-s1>

#proof[
  Wir betrachten die universelle Überlagerung #idx("Überlagerung", sub: "universelle") $p: RR -> S^1, t |-> e^(2 pi i t)$.

  #claim(title: "Eindeutige Wegelifteigenschaft")[
    Zu jedem Weg $gamma: I -> S^1$ mit $gamma(0) = 1$ und jedem $t_0 in p^(-1)(1) = ZZ$ existiert genau ein Lift $tilde(gamma): I -> RR$ mit $tilde(gamma)(0) = t_0$ und $p compose tilde(gamma) = gamma$ #idx("Wegeliftung").
  ]

  #subproof[
    Die Aussage folgt durch Lebesgue-Zerteilen (Lebesgue-Zahl #idx("Lebesgue-Zahl")) des Intervalls $I$ in kleine Teilintervalle $[t_k, t_(k+1)]$, deren Bilder in gleichmäßig überdeckten offenen Umgebungen #idx([Umgebung], [offene]) von $S^1$ liegen, und sukzessiver Fortsetzung über die lokalen Homöomorphismus-Blätter.
  ]

  Ist $gamma$ eine Schleife mit $gamma(0) = gamma(1) = 1$, so wähle den Lift $tilde(gamma)$ mit $tilde(gamma)(0) = 0$. Dann ist $p(tilde(gamma)(1)) = gamma(1) = 1$, woraus $tilde(gamma)(1) in ZZ$ folgt.
  Die Zuordnung
  $
    Phi: pi_1(S^1, 1) -> ZZ, quad [gamma] |-> tilde(gamma)(1)
  $
  ist wohldefiniert, ein Gruppenhomomorphismus und Isomorphismus #idx("Isomorphismus").
]

#corollary(title: "Fundamentalsatz der Algebra")[
  Jedes nichtkonstante komplexe Polynom $P(z) = z^n + a_(n-1)z^(n-1) + dots + a_0 in CC[z]$ mit $n >= 1$ besitzt mindestens eine Nullstelle in $CC$ #idx("Fundamentalsatz der Algebra").
] <cor:fta>

#lemma(title: "Nichtexistenz einer Retraktion")[
  Es existiert keine stetige Retraktion $r: D^2 -> S^1$ #idx("Retraktion") #idx("Deformationsretrakt") von der zweidimensionalen Kreisscheibe $D^2$ #notate($D^n$, [$n$-dimensionaler abgeschlossener Einheitsball]) #idx([Kreisscheibe], [$D^2$]) #idx([Ball], [$n$-dimensionaler]) auf ihren Rand $partial D^2$ #notate($partial M$, [Topologischer Rand einer Mannigfaltigkeit $M$]).
] <lem:no-retract>

== Kommutative Diagramme in der Topologie

In der algebraischen Topologie werden Zusammenhänge systematisch über Funktoren und exakte Sequenzen #idx("Exakte Sequenz") (wie die Mayer-Vietoris-Sequenz #idx("Mayer-Vietoris-Sequenz")) beschrieben. Dies verallgemeinert sich auf CW-Komplexe #idx([CW-Komplex]), Tori $T^2$ #idx([Torus], [$T^2$]), Produkt- #idx([Produktraum]) und Quotientenräume #idx("Quotientenraum"), Simplizialkomplexe #idx([Simplizialkomplex]) mit Standard-Simplizes #idx([Standard-Simplex], [$Delta^n$]) sowie die Berechnung der Euler-Charakteristik #idx("Euler-Charakteristik"). Mit dem eingebundenen `fletcher`-Paket lassen sich kommutative Diagramme direkt darstellen:

#align(center)[
  #diagram(
    node-stroke: 0.5pt,
    spacing: (3.5cm, 2cm),
    {
      node((0, 0), [$pi_1(A inter B, x_0)$])
      node((1, 0), [$pi_1(A, x_0)$])
      node((0, 1), [$pi_1(B, x_0)$])
      node((1, 1), [$pi_1(X, x_0)$])

      edge((0, 0), (1, 0), "->", [$i_*$])
      edge((0, 0), (0, 1), "->", [$j_*$])
      edge((1, 0), (1, 1), "->", [$k_*$])
      edge((0, 1), (1, 1), "->", [$l_*$])
    }
  )
]

Obiges Diagramm stellt das kanonische Pushout-Quadrat #idx("Pushout") im *Satz von Seifert-van Kampen* #idx("Satz von Seifert-van Kampen") dar. Verwandte Resultate wie der Jordan-Kurvensatz #idx("Jordan-Kurvensatz") beruhen auf ähnlichen Zerlegungen unter Kompaktheit #idx([Kompaktheit]) und Wegezusammenhang #idx([Zusammenhang], [Wegezusammenhang]).

#lecture-break(12, 13, date: datetime(year: 2026, month: 11, day: 11))

== Verweise und Konsistenzprüfung

Wir prüfen die Querverweise unseres Templates:
- Aus @def:path und @def:homotopy leiten wir die Fundamentalgruppe ab.
- Die Berechnung in @thm:pi1-s1 liefert unmittelbar @lem:no-retract und @cor:fta.
- Wie in @ex:convex erläutert, verschwindet die Fundamentalgruppe für konvexe Räume.

#pagebreak()

// -----------------------------------------------------------------------------
// Back Matter: Dynamic Symbol Index & Alphabetical Subject Index (Stichwortverzeichnis)
// -----------------------------------------------------------------------------

// 1. Symbol & Notation Index (dynamically collected from #notate calls)
#notation-index()

#pagebreak()

// 2. Alphabetical Subject Index (Stichwortverzeichnis)
#subject-index()
