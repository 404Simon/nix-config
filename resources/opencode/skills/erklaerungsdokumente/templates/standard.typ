// =============================================================================
// Standard-Template für Erklärungsdokumente
// Layout angelehnt an Sequence Assembly Summary (Algorithmic Bioinformatics)
// =============================================================================

// --- Seiten-Setup ---
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2cm),
  numbering: "1",
)

#set text(
  font: "New Computer Modern",
  size: 11pt,
)

#set par(justify: true)

#set heading(numbering: "1.1")

// =============================================================================
// TITELSEITE
// =============================================================================

// --- ANPASSEN: Titel, Untertitel, Kurs, Dozent ---
#align(center)[
  #v(2cm)
  #text(size: 24pt, weight: "bold")[
    TITEL_DOKUMENT
  ]

  #v(0.5cm)
  #text(size: 18pt)[
    UNTERTITEL
  ]

  #v(1cm)
  #text(size: 14pt)[
    KURSNAME
  ]

  #v(3cm)

  #v(1fr)
  #text(size: 12pt)[
    Based on lectures by DOZENT
  ]

  #v(1cm)
]

#pagebreak()

// --- Inhaltsverzeichnis ---
#outline(indent: auto)

#pagebreak()

// =============================================================================
// BOXEN-DEFINITIONEN (Farbcodierte Informationsblöcke)
// =============================================================================

// Blaue Box: Definitionen
#let defbox(body) = block(
  fill: rgb("#E8F4F8"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#0066CC") + 1pt,
  body,
)

// Grüne Box: Algorithmen
#let algbox(body) = block(
  fill: rgb("#E6F7E6"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#00AA00") + 1pt,
  body,
)

// Orange Box: Theoreme / Sätze
#let theobox(body) = block(
  fill: rgb("#FFF4E6"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#FF9900") + 1pt,
  body,
)

// Gelbe Box: Beispiele
#let examplebox(body) = block(
  fill: rgb("#FEF9E7"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#F1C40F") + 1pt,
  body,
)

// Rote Box: Warnung / Stolperfalle
#let warnbox(body) = block(
  fill: rgb("#FDEDEC"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#E74C3C") + 1pt,
  body,
)

// Graue Box: Zusammenfassung / Key Takeaways
#let summarybox(body) = block(
  fill: rgb("#F0F0F0"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#555555") + 1pt,
  body,
)

// =============================================================================
// DOKUMENT-INHALT
// =============================================================================

// --- ANPASSEN: Ab hier schreiben ---

//= KAPITEL_1
//...
