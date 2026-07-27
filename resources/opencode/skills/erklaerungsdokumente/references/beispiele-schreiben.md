# Beispiele schreiben — Patterns für gute Beispiele

Beispiele sind das Herz jeder guten Erklärung. Ein gutes Beispiel **verankert** ein abstraktes Konzept in der konkreten Erfahrung des Lesers.

## Die 4 Eigenschaften eines guten Beispiels

### 1. Minimal

Das Beispiel ist so klein wie möglich, aber so groß wie nötig.

> **Zu groß:** "Wir nehmen 10.000 Strings der Länge 200..."
> **Genau richtig:** "Wir nehmen 3 Reads: CTGA, GAGA, AGAG."

**Faustregel:** Wenn das Beispiel mehr als 5 Elemente hat, ist es zu groß für ein erstes Verständnis.

### 2. Durchgerechnet

Jeder Zwischenschritt wird gezeigt. Der Leser muss **jeder Zeile folgen** können.

> **Schlecht:** "Der Overlap zwischen CTGA und GAGA ist 2, also wird das Ergebnis CTGAGA."
>
> **Gut:**
> 1. $s_1 =$ CTGA, $s_2 =$ GAGA
> 2. Finde das längste Suffix von CTGA, das auch Präfix von GAGA ist:
>    - Suffixe von CTGA: A, GA, TGA, CTGA
>    - Präfixe von GAGA: G, GA, GAG, GAGA
>    - Gemeinsam: GA (Länge 2)
> 3. $\text{ov}(s_1, s_2) = 2$
> 4. $|s_1 \oplus s_2| = 4 + 4 - 2 = 6$
> 5. $s_1 \oplus s_2 =$ CTGA + GA → CTGA + GA... nein, verschmelze: CT + GA + GA = CTGAGA

### 3. Erwartungsbruch (optional aber wirkungsvoll)

Das Beispiel zeigt einen **Fall, in dem der Leser intuitiv das Falsche denkt** und dann sieht, warum es richtig ist.

> "Man könnte denken, dass mehr Coverage immer besser ist. Aber schauen wir uns an, was mit Repeats passiert..."
>
> "Man könnte denken, dass der Greedy-Algorithmus immer das Optimum findet. Aber hier ist ein Gegenbeispiel..."

### 4. Anders als das Vorlesungsbeispiel

Das Beispiel ist **nicht** die Eins-zu-eins-Kopie des Vorlesungsbeispiels. Der Leser lernt mehr, wenn er ein zweites, anderes Beispiel sieht.

## Typst-Umsetzung: Beispiel-Box

Jedes Beispiel wird in einer gelben Box dargestellt:

```typst
#block(
  fill: rgb("#FEF9E7"),
  inset: 1em,
  radius: 4pt,
  stroke: rgb("#F1C40F") + 1pt
)[
  *Beispiel:*
  
  Gegeben: $s_1 =$ `CTGA`, $s_2 =$ `GAGA`
  
  Überlapp: Suffix `GA` = Präfix `GA` → Länge 2
  
  Verschmelzung: $s_1 \oplus s_2 =$ `CTGAGA` (Länge $4 + 4 - 2 = 6$)
]
```

## Beispiele nach Typ

### Algorithmus-Beispiel

Zeige den Algorithmus **Schritt für Schritt** an einem minimalen Input.

```
Input: [minimales Beispiel]

Schritt 1: [Was passiert?] → [Zwischenergebnis]
Schritt 2: [Was passiert?] → [Zwischenergebnis]
...
Ergebnis: [finales Ergebnis]
```

### Formel-Beispiel

Setze **konkrete Zahlen** in jede Komponente der Formel ein.

```
Formel: x = (a + b) / c

a = 5, b = 3, c = 4
x = (5 + 3) / 4 = 8 / 4 = 2
```

### Definitions-Beispiel

Zeige, **was in die Definition hineinfällt** und was nicht.

```
Definition: Ein Eulerischer Pfad besucht jede Kante genau einmal.

✅ Beispiel: Graph A→B→C→D (jede Kante genau einmal)
✅ Beispiel: Graph A→B→A→C (jede Kante genau einmal, Knoten mehrfach)
❌ Beispiel: Graph A→B→C→B (Kante B→C und C→B... oder Kante B→C zweimal?)
```

### Vergleichs-Beispiel

Zeige beide Optionen am **gleichen Input** nebeneinander.

```
Input: [derselbe Input]

Methode A:     Methode B:
Schritt 1: →   Schritt 1: →
Schritt 2: →   Schritt 2: →
Ergebnis: X    Ergebnis: Y

→ Warum unterscheiden sich die Ergebnisse?
```

## Anti-Patterns

| Anti-Pattern | Problem | Lösung |
|---|---|---|
| Zu großes Beispiel | Leser verliert den Überblick | Maximal 3-5 Elemente |
| Fehlende Zwischenschritte | Leser kann nicht folgen | Jede Umformung zeigen |
| Gleiches Beispiel wie Vorlesung | Kein Mehrwert | Zweites, anderes Beispiel |
| Zu speziell | Leser erkennt das Muster nicht | Zeige Generalisierung nach dem Beispiel |
| Ohne Ergebniskommentar | Leser weiß nicht, was das Beispiel zeigt | "Das Ergebnis zeigt, dass..." |
