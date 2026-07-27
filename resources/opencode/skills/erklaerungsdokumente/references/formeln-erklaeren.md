# Formeln erklären — Die 5-Schritt-Struktur

Formeln sind die größte Hürde für Verständnis. Die meisten Leser sehen eine Formel und schalten ab. Ziel: **Jede Formel wird in natürlicher Sprache übersetzt**, bevor sie formal notiert wird.

## Die 5 Schritte

### 1. Intuition (Was misst diese Formel?)

Übersetze die Formel in 1-2 Sätze natürlicher Sprache. Keine Symbole.

> "Die gewichtete Impurity misst, wie **heterogen** die Kind-Knoten nach einem Split sind. Eine niedrige Impurity bedeutet: Die Kinder sind jeweils homogen (ähnliche y-Werte)."

### 2. Komponenten zerlegen (Jedes Symbol benennen)

Jedes Symbol wird einzeln benannt. Nicht in einem Satz — als Liste.

> - $n$ = Anzahl der Samples
> - $y_s$ = Target-Wert von Sample $s$
> - $\hat{y}_{S'}$ = Mittelwert aller $y$-Werte in der Sample-Menge $S'$
> - $\text{Var}(S')$ = Varianz der $y$-Werte in $S'$

### 3. Konkrete Zahlen (Beispiel mit echten Werten)

Setze konkrete Werte ein und rechne das Ergebnis aus. Schritt für Schritt.

> **Formel:** $\text{Var}(S') = \frac{1}{|S'|} \sum_{s \in S'} (\hat{y}_{S'} - y_s)^2$
>
> **Beispiel:** $S' = \{s_1, s_2, s_3\}$ mit $y = \{5.1, 5.3, 4.9\}$
>
> 1. Mittelwert: $\hat{y}_{S'} = (5.1 + 5.3 + 4.9)/3 = 5.1$
> 2. Abweichungen: $(5.1-5.1)=0$, $(5.3-5.1)=0.2$, $(4.9-5.1)=-0.2$
> 3. Quadrate: $0^2 = 0$, $0.2^2 = 0.04$, $(-0.2)^2 = 0.04$
> 4. Summe: $0 + 0.04 + 0.04 = 0.08$
> 5. Varianz: $0.08/3 \approx 0.027$

### 4. Extremfälle und Intuition schärfen

Was passiert in Grenzfällen? Das schärft das Verständnis für die Formel.

> - **Varianz = 0:** Alle $y$-Werte sind identisch. Die Gruppe ist perfekt homogen.
> - **Varianz groß:** Die $y$-Werte streuen stark. Die Gruppe ist heterogen.
> - **Ein einzelner Ausreißer:** Ein Wert wie $y = 100$ in einer sonst homogenen Gruppe treibt die Varianz enorm nach oben.

### 5. Warum diese Form? (Alternative und Begründung)

Warum ist die Formel genau so aufgebaut und nicht anders?

> "Warum Varianz und nicht absolute Abweichung $(|y - \hat{y}|)$? Die Quadrierung bestraft große Abweichungen überproportional. Ein Split, der einen extremen Ausreißer isoliert, bekommt eine viel bessere Impurity als einer, der 'mittelmäßige' Gruppen erzeugt. Das ist gewollt — wir wollen klare, separierende Splits."

---

## Erweiterte Patterns

### Teleskop-Summen verständlich machen

Manche Formeln sind Teleskop-Summen — viele Terme heben sich gegenseitig auf. Diese sind besonders schwer zu verstehen.

**Pattern:** Schreibe die ersten 2-3 Glieder aus, zeige die Aufhebung, dann das Ergebnis.

> $\text{VI}(f) = \sum_{v \in V_f} \text{VI}(f, v)$
>
> Ausgeschrieben für 3 Knoten:
> $\text{VI}(f) = (|S_1|\text{Var}(S_1) - |S_1^L|\text{Var}(S_1^L) - |S_1^R|\text{Var}(S_1^R))$
> $\phantom{\text{VI}(f)} + (|S_2|\text{Var}(S_2) - |S_2^L|\text{Var}(S_2^L) - |S_2^R|\text{Var}(S_2^R))$
> $\phantom{\text{VI}(f)} + (|S_3|\text{Var}(S_3) - |S_3^L|\text{Var}(S_3^L) - |S_3^R|\text{Var}(S_3^R))$
>
> Da die Kinder eines Knotens die Eltern des nächsten sind, heben sich die Terme bis auf Wurzel minus Leaves weg.

### Große Formeln zerlegen

Eine komplexe Formel wird in ihre **Teilausdrücke** zerlegt. Jeder Teilausdruck bekommt einen Namen und eine Erklärung.

> **GENIE3 Edge Weight:**
>
> $w_{g',g} = \text{VI}_{F_g}(g')$
>
> Teilausdrücke:
> - $g'$ = potentieller Regulator (ein Transkriptionsfaktor-Gen)
> - $g$ = Zielgen
> - $F_g$ = Random Forest, der $g$ aus allen anderen Genen vorhersagt
> - $\text{VI}_{F_g}(g')$ = Variable Importance von Gen $g'$ im Random Forest für Gen $g$
> - $w_{g',g}$ = Kantengewicht = "Wie stark reguliert $g'$ das Gen $g$?"

### Herleitungen als Dialog

Statt einer Herleitung als monolithischen Block: **Frage-Antwort-Struktur.**

> **Warum ist $\sum_{g' \neq g} w_{g',g} \approx n \cdot \text{Var}(\mathbf{X}_{\cdot,g})$?**
>
> Weil die Summe aller Feature Importances in einem Baum einer Teleskopsumme entspricht:
> Starte mit der Varianz an der Wurzel, ziehe die Varianzen an den Leaves ab.
> Da Leaves homogen sind (Varianz $\approx 0$), bleibt nur die Wurzelvarianz.
>
> **Und warum ist das ein Problem?**
> Gene mit hoher Varianz bekommen mehr "Importance-Budget". Wenn Gen $X$ zehnmal so stark streut wie Gen $Y$, werden alle Kanten, die auf $X$ zeigen, systematisch höher bewertet.
>
> **Lösung?**
> Normalisiere jedes Gen auf Unit Variance. Dann hat jedes Gen das gleiche "Budget".

---

## Anti-Patterns (vermeiden)

| Anti-Pattern | Warum schlecht | Besser |
|---|---|---|
| Formel hinschreiben ohne Kontext | Leser sieht nur Symbole | Erst sagen, *was* sie misst |
| Alle Symbole in einem Satz erklären | Überfordert | Liste mit je einem Symbol pro Punkt |
| Nur abstraktes Beispiel | Keine Verankerung | Konkrete Zahlen einsetzen |
| Herleitung in einem Block | Leser verliert den Faden | In kleine Schritte zerlegen |
| Ausnahme weglassen | Leser denkt Formel gilt immer | Grenzfälle zeigen |
