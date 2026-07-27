# Algorithmen erklären — Die 7-Schritt-Struktur

Jeder Algorithmus wird nach dem gleichen Schema erklärt. Das Ziel: Der Leser versteht nicht nur *was* der Algorithmus tut, sondern *warum* er es tut und *wann* er scheitert.

## Die 7 Schritte

### 1. Problem / Ziel

Was will der Algorithmus erreichen? In maximal 2 Sätzen.

> **Beispiel:** "Wir haben eine Menge von DNA-Reads und wollen das ursprüngliche Genom rekonstruieren — die kürzeste Sequenz, die alle Reads als Teilstring enthält."

### 2. Naive Idee (und warum sie scheitert)

Was würde man intuitiv versuchen? Warum reicht das nicht?

> **Beispiel:** "Man könnte alle möglichen Anordnungen der Reads durchprobieren (Permutationen). Bei n Reads gibt es n! Möglichkeiten — das ist ab n=20 astronomisch. Für ein ganzes Genom unmöglich."

### 3. Kernidee

Der zentrale Gedanke, der den Algorithmus ausmacht. Ein Satz, maximal zwei.

> **Beispiel:** "Statt alle Permutationen zu probieren, wählen wir **gierig** immer das Read-Paar mit dem größten Überlapp aus und verschmelzen es. Wir entscheiden lokal optimal und hoffen, dass das global gut ist."

### 4. Formaler Algorithmus (als nummerierte Schritte)

Jeder Schritt ist eine präzise Anweisung. Keine Implementierungsdetails.

> **Beispiel:**
>
> **Greedy SCS Algorithmus**
> 1. Initialisiere Menge $S'$ mit allen Reads.
> 2. Solange $|S'| > 1$:
>    a. Finde das Paar $(s_i, s_j)$ in $S'$ mit dem **größten Überlapp**.
>    b. Verschmelze sie: $s_{\text{neu}} = s_i \oplus s_j$.
>    c. Entferne $s_i, s_j$ aus $S'$, füge $s_{\text{neu}}$ hinzu.
> 3. Gib den einzigen verbleibenden String zurück.

### 5. Minimales Durchbeispiel

Das ist der **wichtigste Schritt**. Das Beispiel muss:
- **Minimal** sein (kleinstmöglicher Input, der den Algorithmus zeigt)
- **Jeden Schritt** zeigen (nicht nur das Ergebnis)
- **Zwischenzustände** sichtbar machen

> **Beispiel:**
>
> **Input:** Reads = {CTGA, GAGA, AGAG}
>
> **Schritt 1:** Berechne alle Überlappungen:
> - `CTGA` + `GAGA`: Überlapp `GA` = 2
> - `CTGA` + `AGAG`: Überlapp `A` = 1
> - `GAGA` + `AGAG`: Überlapp `AGA` = 3 ← **größter!**
> - `GAGA` + `CTGA`: Überlapp `A`=1
> - `AGAG` + `CTGA`: Überlapp `A`=1
> - `AGAG` + `GAGA`: Überlapp `A`=1
>
> **Schritt 2:** Größter Überlapp ist 3 (`GAGA` + `AGAG` → `GAGAG`)
> $S'$ = {CTGA, GAGAG}
>
> **Schritt 3:** Einziger verbleibender Überlapp:
> - `CTGA` + `GAGAG`: Überlapp `GA`=2
> - `GAGAG` + `CTGA`: Überlapp `A`=1
> → Wähle `CTGA` + `GAGAG` = `CTGAGAG`
>
> **Ergebnis:** `CTGAGAG` (Länge 7)

### 6. Formalisierung

Jetzt die formale Notation — aber **jedes Symbol wird benannt**.

> **Beispiel:**
>
> Sei $\text{ov}(s_i, s_j)$ die Länge des längsten Suffixes von $s_i$, das auch Präfix von $s_j$ ist.
>
> Die Länge des verschmolzenen Strings ist:
> $|s_i \oplus s_j| = |s_i| + |s_j| - \text{ov}(s_i, s_j)$
>
> Die Gesamtlänge einer Superstring $s$ aus einer Permutation $\pi$ ist:
> $|s| = \sum_{i=1}^n |s_i| - \sum_{i=1}^{n-1} \text{ov}(s_{\pi(i)}, s_{\pi(i+1)})$
>
> Um die Superstring-Länge zu minimieren, müssen wir **die Gesamtüberlappung maximieren**.

### 7. Grenzen / Probleme

Wo versagt der Algorithmus? Welche Annahmen werden verletzt?

> **Beispiel:**
>
> - **NP-hart:** SCS ist NP-hart. Der Greedy Algorithmus ist nur eine Approximation.
> - **Approximationsfaktor:** $\alpha \leq 3.5$ (bekannt), vermutlich $\alpha = 2$.
> - **Repeats:** Bei Wiederholungen im Genom kollabiert der Greedy-Algorithmus (er verschmilzt identische Reads aus verschiedenen Repeat-Instanzen → zu kurze Assemblierung).
> - **Chimäre Assemblierung:** Wenn ein Repeat an zwei verschiedenen Stellen vorkommt, springt der Algorithmus zwischen ihnen hin und her → falsche Sequenz.

## Wichtige Patterns für Algorithmus-Erklärungen

### "Stell dir vor..." — Analogien

Zu Beginn eines Algorithmus: Eine Analogie aus dem Alltag, die das Problem greifbar macht.

> **Beispiel:** "Stell dir vor, du hast 10 Schnipsel eines zerrissenen Briefs. Du suchst die richtige Reihenfolge, indem du immer die zwei Schnipsel zusammenklebst, die am besten zusammenpassen."

### Schritt-Kommentare

Jeder Algorithmusschritt bekommt einen Kommentar, *warum* er gemacht wird.

> **Schlecht:** "Wähle das Paar mit dem größten Überlapp."
>
> **Gut:** "Wähle das Paar mit dem größten Überlapp — diese beiden Reads gehören in der echten DNA-Sequenz höchstwahrscheinlich nebeneinander."

### Visualisierung der Zwischenzustände

Für zustandsverändernde Algorithmen: Zeige den Zustand *vor* und *nach* jedem wichtigen Schritt.

> **Beispiel (Overlap-Graph):**
> ```
> Vor Schritt 2:    Nach Schritt 2:
> CTGA ──2──→ GAGA    CTGA ──2──→ GAGAG
>  │               
>  1
>  ↓
> AGAG
> ```

### Erwartungsbruch einbauen

Zeige einen Fall, in dem der Algorithmus *anders* handelt als man denkt, und erkläre warum.

> **Beispiel:** "Man würde erwarten, dass mehr Coverage immer zu besseren Ergebnissen führt. Aber: Bei Repeats führt hohe Coverage dazu, dass der Greedy-Algorithmus die identischen Repeat-Kopien fälschlich verschmilzt — mehr Daten machen das Problem *schlimmer*."
