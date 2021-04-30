# Company Relational Model

## mitarbeiter

| _id_ | vorname | nachname | abteilung |
| ---- | ------- | -------- | --------- |
| 1    | John    | Doe      | 1         |

## arbeitet_an

| _mitarbeiter_ | _projekt_ |
| ------------- | --------- |
| 1             | 1         |

## projekt

| _id_ | name |
| ---- | ---- |
| 1    | Foo  |

## abteilung

| _id_ | name             |
| ---- | ---------------- |
| 1    | Buchhaltung      |
| 2    | Human Ressources |
| 3    | Design           |
| 4    | IT               |
