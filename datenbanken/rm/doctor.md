# Doctor Relational Model

## patient

| _id_ | vorname | nachname | straße          | hausnummer | stadt  | plz   |
| ---- | ------- | -------- | --------------- | ---------- | ------ | ----- |
| 1    | John    | Doe      | Friedrichstraße | 1          | Berlin | 10969 |

## rezept

| _id_ |  _patient_ | datum      |
| ---- | ---------- | ---------- |
| 1    | 1          | 30.04.2021 |

## erkrankung

| _rezept_ | _patient_ |
| -------- | --------- |
| 1        | 1         |

## teil_von_rezept

| _rezept_ | _medizin_ | menge | dosis |
| -------- | --------- | ----- | ----- |
| 1        | 1         | 12    | 300mg |

## medizin

| _id_ | name    | lieferant |
| ---- | ------- | --------- |
| 1    | Aspirin | 1         |

## behandelt

| _medizin_ | _krankheit_ |
| --------- | ----------- |
| 1         | 1           |

## krankheit

| _id_ | name          |
| ---- | ------------- |
| 1    | Kopfschmerzen |

## besteht_aus

| medizin | inhaltsstoff |
| ------- | ------------ |
| 1       | 1            |

## inhaltsstoff

| _id_ | name               |
| ---- | ------------------ |
| 1    | Acetylsalicylsäure |

## lieferant

| _id_ | name  |
| ---- | ----- |
| 1    | Bayer |
