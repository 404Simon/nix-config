# Konzept-Struktur — Aufbau eines Erklärungsdokuments

Dieses Dokument definiert, wie ein gesamtes Erklärungsdokument aufgebaut wird — von der Makro-Ebene (Kapitel-Struktur) bis zur Mikro-Ebene (Absatz-Struktur).

## Makro-Struktur: Das gesamte Dokument

```
=== Titelblatt
     - Thema (24pt bold)
     - Untertitel (18pt)
     - Kursname (14pt)
     - Dozent
=== Inhaltsverzeichnis
=== Kapitel 1: Erstes Hauptkonzept
     - Motivation / Problem
     - Kernidee
     - Formale Definition
     - Durchgerechnetes Beispiel
     - Grenzen / Probleme
=== Kapitel 2: Zweites Hauptkonzept
     ...
=== Zusammenfassung
     - Key Takeaways (als Box)
     - Formelsammlung (wichtigste Formeln kompakt)
=== (optional) Klausurvorbereitung
     - Typische Aufgabenstellungen
     - Häufige Fehler
```

## Mikro-Struktur: Ein einzelnes Konzept

Jedes Konzept folgt der **P-D-B-K-G-Struktur**:

```
┌─────────────────────────────────────────────┐
│ Problem / Motivation                         │
│ → Warum brauchen wir das? Was ist das Ziel?  │
├─────────────────────────────────────────────┤
│ Definition / Kernidee                        │
│ → Was ist es? In 1-2 Sätzen                 │
├─────────────────────────────────────────────┤
│ Beispiel                                     │
│ → Konkret, minimal, durchgerechnet           │
├─────────────────────────────────────────────┤
│ Formalisierung (optional)                    │
│ → Formeln, formale Notation                 │
├─────────────────────────────────────────────┤
│ Grenzen / Einordnung                         │
│ → Wann versagt es? Was sind die Limits?     │
└─────────────────────────────────────────────┘
```

### Richtlinien pro Sektion

#### Problem / Motivation

- Starte mit einer **Frage** oder einem **konkreten Szenario**
- Maximal 3 Sätze
- Keine Fachbegriffe, die nicht erklärt werden

> **Schlecht:** "Die ganzzahlige lineare Programmierung ist ein NP-vollständiges Problem."
>
> **Gut:** "Wir haben ein Netzwerk und wollen die ähnlichsten Knoten zwischen zwei Netzwerken finden. Das ist ein Optimierungsproblem — aber leider mathematisch extrem schwer zu lösen."

#### Definition / Kernidee

- **Fett** für den definierten Begriff
- Definition in maximal 2 Sätzen
- Danach: Intuition (siehe unten)

> **Beispiel:**
> Ein **Eulerischer Pfad** ist ein Pfad in einem Graphen, der **jede Kante genau einmal** besucht.
>
> *Intuition:* Stell dir vor, du musst in einer Stadt jede Straße genau einmal befahren, ohne eine Straße zweimal zu nehmen. Der Start- und Endpunkt sind unterschiedlich.

#### Beispiel

- Siehe `references/beispiele-schreiben.md`
- **Pflicht:** Jedes Konzept hat genau ein durchgerechnetes Beispiel
- Das Beispiel kommt *vor* der Formalisierung (es sei denn, das Konzept ist rein formal)

#### Formalisierung

- Formeln immer mit **Komponenten-Erklärung** (siehe `references/formeln-erklaeren.md`)
- Beweise sind optional — nur wenn sie zum Verständnis beitragen
- Beweisskizze > vollständiger Beweis

#### Grenzen

- **Pflicht:** Kein Konzept wird ohne seine Grenzen vorgestellt
- Frage: "Unter welchen Bedingungen funktioniert es nicht?"
- Frage: "Was passiert, wenn die Annahmen verletzt werden?"

## Absatz-Struktur: Ein einzelner Absatz

Jeder Absatz enthält **genau eine** Idee.

```text
[Topic Sentence] — sagt, worum es in diesem Absatz geht.
[Erklärung] — entwickelt die Idee.
[Beispiel/Konsequenz] — zeigt die Konsequenz oder ein Beispiel.
[Übergang] — optional: verknüpft mit dem nächsten Absatz.
```

**Prüffrage:** Kann ich für jeden Absatz eine Überschrift formulieren, die den Inhalt präzise beschreibt? Wenn nicht, hat der Absatz mehr als eine Idee.

## Übergänge zwischen Konzepten

Zwischen zwei Konzepten muss klar sein, **warum** das zweite kommt.

| Schlecht | Gut |
|----------|-----|
| "Kommen wir nun zu Random Forests." | "Bagging reduziert die Varianz, aber die Bäume bleiben korreliert. **Deshalb** führen wir Feature Randomization ein — das ist die Kernidee von Random Forests." |
| "Als nächstes betrachten wir Precision." | "Wir haben jetzt ein GRN inferiert. Aber wie gut ist es? Dazu brauchen wir Metriken — und die erste ist Precision." |

## Sprache und Ton

- **Aktiv statt Passiv:** "Der Algorithmus wählt..." statt "Es wird gewählt..."
- **Konkret statt abstrakt:** "Die Varianz ist 0.027" statt "Die Varianz ist klein"
- **Kurze Sätze:** Maximal 25 Wörter. Längere Sätze aufbrechen.
- **Fachbegriffe:** Beim ersten Auftreten **fett** markieren und definieren
- **Vergleiche:** "Anders als bei [Altkonzept], macht [Neukonzept] hier..."

## Dokument-Sprache

Das gesamte Dokument ist in **einheitlicher Sprache**. Entweder komplett Deutsch oder komplett Englisch (wenn die Vorlesung auf Englisch ist). Kein Code-Switching.

**Ausnahme:** Englische Fachbegriffe, die im Deutschen etabliert sind (z.B. "Random Forest", "Overlap", "Bootstrap") bleiben auf Englisch, werden aber beim ersten Auftreten erklärt.
