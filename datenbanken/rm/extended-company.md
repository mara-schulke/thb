# Extended Company Relational Model

## mitarbeiter

| _id_ | first_name | last_name | abteilung |
| ---- | ---------- | --------- | --------- |
| 1    | John       | Doe       | 1         |
| 2    | Foo        | Bar       | 4         |

## arbeitet_an

| _mitarbeiter_ | _projekt_ |
| ------------- | --------- |
| 1             | 1         |
| 2             | 1         |

## projekt

| _id_ | name | leiter | teil_von_projekt |
| ---- | ---- | ------ | ---------------- |
| 1    | Foo  | 2      | NULL             |
| 2    | Bar  | 1      | 1                |

## abteilung

| _id_ | name             |
| ---- | ---------------- |
| 1    | Buchhaltung      |
| 2    | Human Ressources |
| 3    | Design           |
| 4    | IT               |
