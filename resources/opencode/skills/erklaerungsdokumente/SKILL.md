---
name: erklaerungsdokumente
description: "Use when writing or revising detailed educational explanations, lecture summaries, tutorial-style documents that explain algorithms, formulas, or complex concepts step-by-step. Focused on German-language explanation documents that prioritize deep understanding over rote memorization. Triggers: 'erklärung', 'zusammenfassung', 'summary', 'tutorial', 'verständlich erklären', 'algorithmus erklären', 'formel erklären', lecture transcript to notes, Vorlesung aufbereiten."
---

# Erklärungsdokumente-Skill

## Overview

Erstelle extrem detaillierte, aber trotzdem präzise Erklärungsdokumente aus Vorlesungsmaterial (PDF-Folien oder Rohtext). Das Ziel ist **wirkliches Verstehen**, nicht Auswendiglernen.

**Output:** Typst `.typ` → kompiliert zu PDF (via `typster`-Agent)

**Kernprinzip:** Jedes abstrakte Konzept bekommt:
- eine **Intuition** (Warum? Was ist das Ziel?)
- eine **Definition/Formalisierung**
- ein **minimales, durchgerechnetes Beispiel**
- eine **Einordnung** (Wo sind die Grenzen? Wann versagt es?)

## When to Use

**Gesuchte Rohdaten finden:**
- PDF-Folien: `pdftotext datei.pdf -` (Ausgabe in Datei umleiten für weitere Verarbeitung)
- Existierende `.txt`-Extrakte: liegen meist in einem `text/`-Unterverzeichnis
- Vorlesungs-Notizen, Manuskripte

**Nicht verwenden für:**
- Allgemeine Dokumente ohne Erklärungscharakter → normaler Schreibmodus
- Rein visuelle Diagramme → plantuml-skill
- Akademische Paper → research-paper-writing

## Workflow

### Schritt 0: Zielgruppe und Kontext klären

Bevor ein einziges Wort geschrieben wird:

- **Wer liest das?** (Klausurvorbereitung? Erstsemester? Fortgeschrittene?)
- **Was ist das Ziel?** (Überblick? Tiefenverständnis? Prüfungsrelevanz?)
- **Welche Vorkenntnisse** werden vorausgesetzt und welche müssen erklärt werden?

→ Diese Entscheidungen bestimmen Tiefe, Sprache und Umfang.

### Schritt 1: Rohmaterial analysieren

Extrahiere Text aus der Quelle und identifiziere die Kernstruktur:

```
pdftotext vorlesung-X.pdf text/vorlesung-X.txt
```

Ordne den Inhalt in:
- **Kernkonzepte** (müssen verstanden werden)
- **Definitionen** (exakt zu fassen)
- **Algorithmen** (in Schritte zerlegbar)
- **Formeln** (komponentenweise erklärbar)
- **Beispiele** (die in der Vorlesung genannt wurden)
- **Beweise/Begründungen** (Argumentationsketten)

### Schritt 2: Konzept-Map bauen

Bestimme die Reihenfolge und Abhängigkeiten:

```
Konzept A ──braucht──> Konzept B ──braucht──> Konzept C
     │                                            │
     └── Beispiel A1                              └── Beispiel C1
     └── Beispiel A2
```

→ Nur Konzepte erklären, deren Voraussetzungen bereits eingeführt wurden.
→ Kein Konzept darf unerklärt verwendet werden.

### Schritt 3: Struktur planen

Jedes Hauptkonzept folgt dieser Gliederung:

```
= Hauptkonzept

== Problem / Motivation
   • Warum brauchen wir das? Was ist das Ziel?

== Kernidee
   • Der zentrale Gedanke in 1-2 Sätzen.
   • Intuition: "Stell dir vor..."

== Formale Definition
   • Exakt, aber kommentiert.
   • Jedes Symbol wird benannt.

== Beispiel
   • Minimal, durchgerechnet, mit Zwischenschritten.
   • Möglichst anders als das Standardbeispiel aus der Vorlesung.

== (optional) Beweis / Begründung
   • Nur wenn er zum Verständnis beiträgt.
   • Beweisskizze statt vollständigem Beweis.

== Grenzen / Probleme
   • Wo versagt das Konzept?
   • Was passiert wenn Annahmen verletzt werden?
```

### Schritt 4: Typst-Dokument schreiben

Nutze den `typster`-Agenten zur Erstellung des `.typ`-Dokuments.

**Muss-Vorgaben:**
- Standard-Template aus `templates/standard.typ` verwenden (Seiten-Setup, Schriftart, Boxen)
- Farbcodierte Boxen für verschiedene Inhaltstypen (siehe Boxen-Referenz unten)
- Für jeden Algorithmus die 7-Schritt-Struktur aus `references/algorithmen-erklaeren.md`
- Für jede Formel die 5-Schritt-Struktur aus `references/formeln-erklaeren.md`
- Jedes abstrakte Konzept hat genau ein durchgerechnetes Beispiel

**Typst-Syntax:**
- Fett: `*text*` — NICHT `**text**`
- Math inline: `$x^2$`
- Math display: `$ ... $` (auf separaten Zeilen)
- Listen: `- bullet`, `+ numbered`
- Brüche: `(a)/(b)` oder `frac(a, b)`
- Summen: `sum_(i=1)^n`

### Schritt 5: Verständlichkeitsprüfung

Jedes abgeschlossene Kapitel/Teil wird geprüft:

- [ ] **Definition vor Nutzung** — Wird jeder Fachbegriff definiert, bevor er verwendet wird?
- [ ] **Beispiel-Zwang** — Hat jedes abstrakte Konzept ein konkretes, durchgerechnetes Beispiel?
- [ ] **Intuition vor Formel** — Steht die Intuition/Warum-Erklärung vor der formalen Notation?
- [ ] **Schritt-für-Schritt** — Sind Algorithmen als nummerierte Schritte formuliert?
- [ ] **Symbolerklärung** — Wird jedes Symbol in jeder Formel benannt?
- [ ] **Grenzen** — Sind die Einschränkungen des Konzepts genannt?
- [ ] **Ein-Konzept-pro-Absatz** — Enthält jeder Absatz genau eine Idee?

### Schritt 6: Kompilieren und Review

```
typst compile dokument.typ
```

- Kompilierfehler sofort fixen (kleine Schritte, häufiges Kompilieren)
- Nach erfolgreicher Kompilierung: nochmalige Prüfung auf Verständlichkeit
- Maximal 3 Review-Runden pro Dokument

## Boxen-Referenz (Farbcodierung)

| Typ | Farbe | Stroke | Einsatz |
|-----|-------|--------|---------|
| Definition | `rgb("#E8F4F8")` | `#0066CC` | Neue Begriffe, formale Definitionen |
| Theorem/Satz | `rgb("#FFF4E6")` | `#FF9900` | Wichtige Aussagen, Theoreme, Lemmata |
| Algorithmus | `rgb("#E6F7E6")` | `#00AA00` | Algorithmenschritte, Pseudocode |
| Beispiel | `rgb("#FEF9E7")` | `#F1C40F` | Durchgerechnete Beispiele |
| Warnung/Hinweis | `rgb("#FDEDEC")` | `#E74C3C` | Typische Fehler, Stolperfallen |
| Zusammenfassung | `rgb("#F0F0F0")` | `#555555` | Abschlussbox, Key Takeaways |

**Template-Code für Boxen:**

```typst
#block(
  fill: rgb("#E8F4F8"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#0066CC") + 1pt
)[
  *Titel der Box*
  
  Inhalt...
]
```

## Referenzen (laden nach Bedarf)

- `references/algorithmen-erklaeren.md` — Die 7-Schritt-Struktur für Algorithmen mit Beispiel
- `references/formeln-erklaeren.md` — Die 5-Schritt-Struktur für Formeln mit Beispiel
- `references/konzept-struktur.md` — Gesamtaufbau eines Erklärungsdokuments
- `references/beispiele-schreiben.md` — Patterns für gute, minimal durchgerechnete Beispiele
- `templates/standard.typ` — Typst-Startvorlage mit Setup und Boxen-Definitionen

## Qualitätsbar

1. **Kein Konzept wird unerklärt verwendet.** Jeder Fachbegriff wird beim ersten Auftreten definiert.
2. **Jede Formel wird komponentenweise erklärt.** Keine Formel steht isoliert.
3. **Jeder Algorithmus wird an einem minimalen Beispiel durchgerechnet.** Nicht nur abstrakt beschrieben.
4. **Die Erklärung ist in sich geschlossen.** Ein Leser mit den angegebenen Vorkenntnissen kann alles verstehen.
5. **Die Erklärung ist maximal präzise und minimal weitschweifig.** Jeder Satz trägt zum Verständnis bei. Keine Füllsätze.
6. **Nach dem Lesen kann der Leser:** das Konzept erklären, eine Beispielaufgabe lösen, die Grenzen nennen.
