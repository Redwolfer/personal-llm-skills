# Output format

Deliver the topic heading and the workflow's tables in the order below. Include no opening speech, commentary between tables, or closing offer.

Write original prose in Bahasa Indonesia using [GenZVoice.md](GenZVoice.md). Apply [Humanize.md](Humanize.md), the complete bundled [Humanizer](references/humanizer.md) in embedded mode, and the final evidence check to every prose cell. Keep direct quotations, source titles, names, and identifiers intact. Section headings are allowed; prose outside tables is not part of the final deliverable.

The research table must identify source types, actual execution mode, and unavailable searches. Label execution and access notes as status rows, separate from numbered evidence rows. Do not list a status note as a supporting source. Cite real pages with descriptive Markdown links and keep limitations visible through all rounds.

## Member names

Use the name and role you gave each member in its brief. Keep those names identical across every table.

## Detail requirements

| Table | Default length per substantive cell |
|-------|--------------------------|
| Round 1 and Round 2 positions/responses; Round 3 final recommendation | At least 150 words; aim for 150-220 |
| Perspective cell (QUICK) | At least 80 words; aim for 80-120 |
| Synthesis / summary row content | At least 120 words; aim for 120-200 |

Develop the evidence, conditions, and implications rather than adding filler. Research rows, roster cells, and Round 3 agreement/disagreement cells can be shorter. Follow an explicit user request for a shorter format while keeping sources, caveats, and dissent.

## Full debate transcript

```markdown
## Council: [Topik]

### Riset Awal

| # | Sumber | Jenis Sumber | Temuan Kunci | Relevansi untuk Anggota |
|---|--------|--------------|---------------|--------------------------|
| Status | Mode eksekusi | Keterangan | [Agen independen yang benar-benar dipanggil, atau simulasi satu sesi] | [Batas independensi hasil] |
| Status | Akses sumber | Keterangan | [Situs yang tidak bisa dicek dan alasannya, jika ada] | [Dampaknya pada kesimpulan] |
| 1 | [Judul dan tautan asli] | [Primer / Reddit / X-Twitter / forum / lainnya] | [Temuan spesifik dan batas buktinya] | [Anggota yang memakainya] |

### Anggota Dewan

| Nama | Peran & Keahlian | Sikap Awal | Poin yang Diuji |
|------|-------------------|------------|-----------------------------------|
| [Nama 1] | [Peran] | [Sikap] | [Target argumen] |
| [Nama 2] | [Peran] | [Sikap] | [Target argumen] |
| [Nama 3] | [Peran] | [Sikap] | [Target argumen] |
| [Nama 4] | [Peran] | [Sikap] | [Target argumen] |

### Ronde 1: Posisi Awal

| Anggota | Posisi Awal (Detail) |
|---------|------------------------|
| [Nama 1] | [Jawaban detail, mengutip temuan riset spesifik, dalam suara manusia] |
| [Nama 2] | [...] |
| [Nama 3] | [...] |
| [Nama 4] | [...] |

### Ronde 2: Tanggapan & Tantangan

| Anggota | Menanggapi | Tanggapan/Tantangan (Detail) |
|---------|------------|--------------------------------|
| [Nama 1] | [Nama lain + poin spesifik] | [Tanggapan detail] |
| [Nama 2] | [...] | [...] |
| [Nama 3] | [...] | [...] |
| [Nama 4] | [...] | [...] |

### Ronde 3: Sintesis & Konvergensi

| Anggota | Titik Temu | Perbedaan yang Tersisa | Rekomendasi Akhir (Detail) |
|---------|------------|--------------------------|-------------------------------|
| [Nama 1] | [...] | [...] | [...] |
| [Nama 2] | [...] | [...] | [...] |
| [Nama 3] | [...] | [...] | [...] |
| [Nama 4] | [...] | [...] | [...] |

### Kesimpulan Dewan

| Aspek | Isi (Detail) |
|-------|----------------|
| Area Kesepakatan | [Poin yang disetujui 3+ anggota, dengan alasan] |
| Perbedaan yang Tersisa | [Trade-off yang belum terpecahkan, dengan alasan tiap sisi] |
| Bobot Argumen | [Argumen mana yang paling kuat secara bukti, dan kenapa] |
| Rekomendasi Akhir | [Rekomendasi konkret dan dapat ditindaklanjuti] |
```

## Quick council format

```markdown
## Council cepat: [Topik]

### Riset Awal

| # | Sumber | Jenis Sumber | Temuan Kunci | Relevansi untuk Anggota |
|---|--------|--------------|---------------|--------------------------|
| Status | Mode eksekusi | Keterangan | [Agen independen atau simulasi satu sesi] | [Batas independensi hasil] |
| Status | Akses sumber | Keterangan | [Situs yang tidak bisa dicek dan alasannya, jika ada] | [Dampaknya pada kesimpulan] |
| 1 | [Judul dan tautan asli] | [Primer / Reddit / X-Twitter / forum / lainnya] | [Temuan spesifik dan batas buktinya] | [Anggota yang memakainya] |

### Anggota Dewan

| Nama | Peran & Keahlian | Sikap |
|------|-------------------|-------|
| [Nama 1] | [Peran] | [Sikap] |
| [Nama 2] | [Peran] | [Sikap] |
| [Nama 3] | [Peran] | [Sikap] |
| [Nama 4] | [Peran] | [Sikap] |

### Perspektif

| Anggota | Pandangan (Detail) |
|---------|------------------------|
| [Nama 1] | [Jawaban 80-120 kata, spesifik, suara manusia] |
| [Nama 2] | [...] |
| [Nama 3] | [...] |
| [Nama 4] | [...] |

### Ringkasan Cepat

| Aspek | Isi (Detail) |
|-------|----------------|
| Konsensus | [Apakah mereka sepakat, dan soal apa persisnya] |
| Kekhawatiran | [Red flag yang muncul, dengan siapa yang mengangkatnya] |
| Rekomendasi | [Lanjut / Tinjau ulang / Perlu debat penuh, dengan alasan] |
```

## Output requirements

- Put the result in tables, including the synthesis. Section headings are the only text outside the tables.
- Give each round a separate table.
- Follow the detail requirements above and any explicit user request for a shorter format.
- Keep each member's reasoning and voice distinct after applying Humanizer and the Indonesian style guide.
- In Round 2 and later, reference other members by name and address their actual points. Trace factual claims to research rows or the user's supplied facts.
- Preserve qualifications, source links, unresolved disagreement, and access limitations. Do not substitute unsupported opinions or repeat an opening position without engaging.
- Keep member names identical across tables and consistent with their briefs.
