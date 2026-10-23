// =============================================================================
// SCRIPT TEMPLATE FOR MATHEMATICS & TOPOLOGY
// =============================================================================
// A clean, modular, and extensible Typst template designed for comprehensive
// lecture notes, scripts, and textbooks in pure mathematics.
// Incorporates architectural patterns from modern mathematical typography.
// =============================================================================

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.4.2"

// -----------------------------------------------------------------------------
// Color Palette (Paul Tol inspired: accessible, elegant, high-contrast)
// -----------------------------------------------------------------------------
#let col-theorem    = rgb("#882255") // TolMutedWine / Deep bordeaux for theorems & corollaries
#let col-definition = rgb("#004488") // TolHighContrastBlue / Deep navy for definitions
#let col-lemma      = rgb("#0077BB") // TolVibrantBlue / Vibrant blue for lemmas
#let col-proposition= rgb("#117733") // TolMutedGreen / Forest green for propositions
#let col-corollary  = rgb("#882255") // Wine / Purple for corollaries
#let col-example    = rgb("#228833") // TolBrightGreen for examples
#let col-remark     = rgb("#555555") // TolDarkGray for remarks & notes
#let col-intuition  = rgb("#d97706") // Warm amber / Ochre for geometric intuition
#let col-rule       = rgb("#64748b") // Slate rule for lecture markers and dividers
#let col-link       = rgb("#1d4ed8") // Blue link color

// -----------------------------------------------------------------------------
// Math Item Environment (Unified Counter, Left-Stripe, Generous Spacing)
// -----------------------------------------------------------------------------

/// Common layout function for theorem-like environments.
/// All environments share the "math-item" figure kind, guaranteeing a single
/// coherent counter across definitions, theorems, lemmas, and examples.
#let math-item(
  type-name,
  stroke-color: black,
  fill-color: none,
  end-symbol: none,
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()
  let body = if pos.len() > 0 { pos.last() } else { [] }
  let title = if "title" in named {
    named.at("title")
  } else if pos.len() > 1 {
    pos.first()
  } else {
    none
  }

  let breakable = if "breakable" in named { named.at("breakable") } else { true }
  
  figure(
    kind: "math-item",
    supplement: type-name,
    caption: title,
    outlined: false,
    block(
      width: 100%,
      stroke: (left: 2.2pt + stroke-color),
      inset: (left: 12pt, right: 4pt, top: 6pt, bottom: 6pt),
      fill: fill-color,
      breakable: breakable,
      spacing: 1.6em,
      align(left)[
        #block(
          width: 100%,
          sticky: true,
          below: 0.6em,
          context {
            let num = counter(figure.where(kind: "math-item")).get().first()
            let hdgs = counter(heading).get()
            let prefix = if hdgs.len() > 0 { str(hdgs.first()) + "." } else { "" }
            let full-num = prefix + str(num)
            text(weight: "bold", fill: stroke-color)[#type-name #full-num]
            if title != none [
              #h(0.35em)
              #text(weight: "bold", fill: rgb("#1f2937"))[(#title)]
            ]
          }
        )
        #body
        #if end-symbol != none {
          place(bottom + right, dx: 0pt, dy: 0pt)[#text(fill: stroke-color)[#end-symbol]]
        }
      ]
    )
  )
}

// -----------------------------------------------------------------------------
// Concrete Mathematical Environments
// -----------------------------------------------------------------------------

#let definition(..args) = math-item("Definition", stroke-color: col-definition, ..args)
#let theorem(..args) = math-item("Satz", stroke-color: col-theorem, ..args)
#let lemma(..args) = math-item("Lemma", stroke-color: col-lemma, ..args)
#let proposition(..args) = math-item("Proposition", stroke-color: col-proposition, ..args)
#let corollary(..args) = math-item("Korollar", stroke-color: col-corollary, ..args)
#let example(..args) = math-item("Beispiel", stroke-color: col-example, end-symbol: $triangle$, ..args)
#let remark(..args) = math-item("Bemerkung", stroke-color: col-remark, ..args)
#let construction(..args) = math-item("Konstruktion", stroke-color: rgb("#78350f"), ..args)

// Geometric Intuition block (specially designed for algebraic topology)
#let intuition(title: "Geometrische Intuition", body) = {
  block(
    width: 100%,
    stroke: (left: 2pt + col-intuition),
    inset: (left: 12pt, right: 6pt, top: 6pt, bottom: 6pt),
    fill: rgb("#fffbeb").lighten(50%),
    breakable: true,
    spacing: 1.4em,
    [
      #text(weight: "bold", fill: col-intuition, size: 0.95em)[#title:]
      #v(0.3em, weak: true)
      #text(size: 0.95em)[#body]
    ]
  )
}

// Formal proof environment with right-aligned Halmos square
#let proof(title: "Beweis", body) = {
  v(0.5em, weak: true)
  block(
    width: 100%,
    spacing: 1.2em,
    breakable: true,
    [
      #text(style: "italic", weight: "medium")[#title.]
      #h(0.4em)
      #body
      #place(bottom + right)[$square$]
    ]
  )
  v(0.8em, weak: true)
}

// Clean sub-claim inside a proof (distinct card, avoids border collisions)
#let claim(title: none, body) = {
  v(0.6em, weak: true)
  block(
    width: 100%,
    stroke: (left: 1.8pt + rgb("#475569")),
    inset: (left: 10pt, top: 5pt, bottom: 5pt, right: 8pt),
    fill: rgb("#f8fafc"),
    radius: (right: 3pt),
    breakable: true,
    spacing: 1em,
    [
      #text(weight: "bold", fill: rgb("#1e293b"), size: 0.95em)[Behauptung#if title != none [ (#title)]:]
      #v(0.25em, weak: true)
      #text(size: 0.95em)[#body]
    ]
  )
  v(0.4em, weak: true)
}

// Subproof of a claim inside a proof, indented and ending with a small hollow diamond
#let subproof(title: "Beweis der Behauptung", body) = {
  v(0.3em, weak: true)
  block(
    width: 100%,
    inset: (left: 12pt),
    breakable: true,
    spacing: 0.8em,
    [
      #text(style: "italic", weight: "medium", fill: rgb("#475569"))[#title:]
      #h(0.35em)
      #text(size: 0.95em)[#body]
      #place(bottom + right)[#text(fill: rgb("#64748b"), size: 0.9em)[$diamond.stroked$]]
    ]
  )
  v(0.6em, weak: true)
}

// -----------------------------------------------------------------------------
// Dynamic Notation Registration
// -----------------------------------------------------------------------------

/// Dynamically registers a notation symbol at this position in the document.
/// If `inline: true`, the symbol is also printed directly into the text.
#let notate(symbol, desc, inline: false) = [
  #metadata((symbol: symbol, desc: desc)) <notation-item>
  #if inline { symbol }
]

// -----------------------------------------------------------------------------
// Lecture Markers
// -----------------------------------------------------------------------------

/// Formats a date for lecture markers. Accepts string or datetime.
/// If datetime is given, formats via .display() (or optional format pattern).
#let format-date(d, format: auto) = {
  if d == none {
    none
  } else if type(d) == datetime {
    if format == auto {
      if d.year() != none and d.month() != none and d.day() != none {
        d.display("[day].[month].[year]")
      } else {
        d.display()
      }
    } else if format != none {
      d.display(format)
    } else {
      d.display()
    }
  } else {
    d
  }
}

/// Primary lecture marker (marks the start of a lecture).
/// Sits in the left margin directly above a wide rule extending across the page.
/// Date can be a string or a datetime object (automatically formatted via .display()).
#let lecture(number, date: none, date-format: auto, outdent: 2.0cm) = {
  let label-text = if type(number) == str and number.starts-with("Vorlesung") {
    number
  } else {
    [Vorlesung #number]
  }
  let date-text = format-date(date, format: date-format)

  v(1.8em)
  block(
    width: 100%,
    breakable: false,
    {
      move(dx: -outdent)[
        #box(width: 100% + outdent * 2)[
          #grid(
            columns: (auto, 1fr),
            align: (bottom + left, bottom + right),
            text(size: 8.5pt, weight: "bold", fill: rgb("#334155"))[#label-text],
            if date-text != none { text(size: 8.5pt, fill: rgb("#64748b"))[#date-text] }
          )
        ]
      ]
      v(-0.35em)
      move(dx: -outdent)[
        #line(length: 100% + outdent * 2, stroke: 0.5pt + col-rule)
      ]
    }
  )
  v(1.5em)
}

/// Alias for `lecture` for compatibility
#let lecture-marker(number, date: none, date-format: auto, outdent: 2.0cm) = lecture(number, date: date, date-format: date-format, outdent: outdent)

/// Merged transition marker between two lectures.
/// Displays "Ende der Vorlesung X" above the line, and "Vorlesung Y (Datum)" below the line.
#let lecture-break(end-number, next-number, date: none, date-format: auto, outdent: 2.0cm) = {
  let end-label = if type(end-number) == str and (end-number.starts-with("Ende") or end-number.starts-with("Vorlesung")) {
    if end-number.starts-with("Ende") { end-number } else { [Ende der #end-number] }
  } else {
    [Ende der Vorlesung #end-number]
  }
  let next-label = if type(next-number) == str and next-number.starts-with("Vorlesung") {
    next-number
  } else {
    [Vorlesung #next-number]
  }
  let date-text = format-date(date, format: date-format)

  v(1.8em)
  block(
    width: 100%,
    breakable: false,
    {
      move(dx: -outdent)[
        #text(size: 8.5pt, weight: "bold", fill: rgb("#64748b"))[#end-label]
      ]
      v(-0.35em)
      move(dx: -outdent)[
        #line(length: 100% + outdent * 2, stroke: 0.5pt + col-rule)
      ]
      v(0.25em)
      move(dx: -outdent)[
        #box(width: 100% + outdent * 2)[
          #grid(
            columns: (auto, 1fr),
            align: (top + left, top + right),
            text(size: 8.5pt, weight: "bold", fill: rgb("#334155"))[#next-label],
            if date-text != none { text(size: 8.5pt, fill: rgb("#64748b"))[#date-text] }
          )
        ]
      ]
    }
  )
  v(1.5em)
}

/// Standalone end-of-lecture marker (e.g. before semester break).
#let lecture-end(number, outdent: 2.0cm) = {
  let end-label = if type(number) == str and (number.starts-with("Ende") or number.starts-with("Vorlesung")) {
    if number.starts-with("Ende") { number } else { [Ende der #number] }
  } else {
    [Ende der Vorlesung #number]
  }

  v(1.8em)
  block(
    width: 100%,
    breakable: false,
    {
      move(dx: -outdent)[
        #text(size: 8.5pt, weight: "bold", fill: rgb("#334155"))[#end-label]
      ]
      v(-0.35em)
      move(dx: -outdent)[
        #line(length: 100% + outdent * 2, stroke: 0.5pt + col-rule)
      ]
    }
  )
  v(1.8em)
}

// -----------------------------------------------------------------------------
// Indices, Outlines & Front Matter
// -----------------------------------------------------------------------------

/// Standardized table of contents with configurable depth (defaults to 2).
#let table-of-contents(depth: 2, title: "Inhaltsverzeichnis") = {
  outline(
    title: title,
    depth: depth,
    indent: auto,
  )
}

/// Renders a dynamic Notation and Symbol Index table.
/// Automatically queries all `#notate(...)` calls in the document, deduplicates them,
/// and builds a reference table with page links.
#let notation-index(title: "Symbol- und Notationsverzeichnis") = {
  heading(level: 1, numbering: none)[#title]
  v(0.6em)
  context {
    let items = query(<notation-item>)
    if items.len() == 0 [
      #text(style: "italic", fill: rgb("#64748b"))[Keine Notationen erfasst.]
    ] else {
      let seen = ()
      let unique-items = ()
      for it in items {
        let key = repr(it.value.symbol)
        if key not in seen {
          seen.push(key)
          unique-items.push(it)
        }
      }

      table(
        columns: (2.8cm, 1fr, 1.5cm),
        stroke: none,
        align: (left, left, right),
        table.header(
          [*Symbol*], [*Bedeutung / Beschreibung*], [*Seite*],
        ),
        table.hline(stroke: 0.8pt + col-rule),
        ..unique-items.map(it => (
          it.value.symbol,
          it.value.desc,
          link(it.location())[#text(fill: col-link, weight: "medium")[#it.location().page()]],
        )).flatten(),
        table.hline(stroke: 0.5pt + rgb("#cbd5e1")),
      )
    }
  }
}

// -----------------------------------------------------------------------------
// Alphabetical Subject Index (Stichwortverzeichnis)
// -----------------------------------------------------------------------------

/// Registers an entry in the alphabetical subject index (Stichwortverzeichnis).
/// Supports primary terms and optional sub-terms:
/// e.g. #idx("Homotopie") or #idx("Homotopie", sub: "von Wegen")
#let idx(term, sub: none) = [
  #metadata((term: term, sub: sub)) <subject-index-item>
]

/// Generates an alphabetical Subject Index (Stichwortverzeichnis).
/// Automatically collects all `#idx(...)` tags, groups them by initial letter
/// (A, B, C, ...), and renders a clean 2-column directory with direct page links.
#let subject-index(title: "Stichwortverzeichnis", num-columns: 2) = {
  heading(level: 1, numbering: none)[#title]
  v(1.0em)
  context {
    let items = query(<subject-index-item>)
    if items.len() == 0 [
      #text(style: "italic", fill: rgb("#64748b"))[Keine Einträge im Stichwortverzeichnis vorhanden.]
    ] else {
      let index-dict = (:)
      for it in items {
        let term = it.value.term
        let sub = it.value.sub
        let p = it.location().page()
        let loc = it.location()

        if term not in index-dict {
          index-dict.insert(term, (pages: (), subs: (:)))
        }

        let entry = index-dict.at(term)
        if sub == none {
          if p not in entry.pages.map(x => x.page) {
            entry.pages.push((page: p, loc: loc))
          }
        } else {
          if sub not in entry.subs {
            entry.subs.insert(sub, ())
          }
          let sub-pages = entry.subs.at(sub)
          if p not in sub-pages.map(x => x.page) {
            sub-pages.push((page: p, loc: loc))
            entry.subs.insert(sub, sub-pages)
          }
        }
        index-dict.insert(term, entry)
      }

      let clean-sort-key(k) = {
        lower(k.replace("Ä", "A").replace("ä", "a")
         .replace("Ö", "O").replace("ö", "o")
         .replace("Ü", "U").replace("ü", "u")
         .replace("ß", "ss"))
      }
      let sorted-terms = index-dict.keys().sorted(key: clean-sort-key)

      columns(num-columns)[
        #let current-letter = none
        #for term in sorted-terms {
          let first-char = term.clusters().first()
          let letter = if first-char in ("Ä", "ä") { "A" }
            else if first-char in ("Ö", "ö") { "O" }
            else if first-char in ("Ü", "ü") { "U" }
            else { upper(first-char) }
          if letter != current-letter {
            current-letter = letter
            v(1.4em, weak: true)
            text(weight: "bold", size: 1.2em, fill: rgb("#1e3a8a"))[#letter]
            v(0.25em, weak: true)
            line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
            v(0.4em, weak: true)
          }

          let data = index-dict.at(term)
          let page-links = if data.pages.len() > 0 {
            data.pages.map(p-data => link(p-data.loc)[#text(fill: col-link, weight: "medium")[#p-data.page]]).join(", ")
          } else { none }

          block(spacing: 0.65em)[
            #text(weight: "medium", fill: rgb("#1f2937"))[#term]
            #if page-links != none [ #h(0.35em) #page-links ]
            #if data.subs.len() > 0 {
              v(0.2em, weak: true)
              for (sub-term, sub-pages) in data.subs {
                let sub-links = sub-pages.map(p-data => link(p-data.loc)[#text(fill: col-link, weight: "medium")[#p-data.page]]).join(", ")
                [#h(1.2em)#text(fill: rgb("#475569"))[– #sub-term] #h(0.3em) #sub-links \ ]
              }
            }
          ]
        }
      ]
    }
  }
}

/// Helper color mapper for math index categories
#let get-category-color(sup-item) = {
  let s = if type(sup-item) == str {
    sup-item
  } else if type(sup-item) == content and "text" in sup-item.fields() {
    sup-item.text
  } else {
    repr(sup-item)
  }
  if "Definition" in s { col-definition }
  else if "Satz" in s or "Theorem" in s or "Korollar" in s { col-theorem }
  else if "Lemma" in s { col-lemma }
  else if "Proposition" in s { col-proposition }
  else if "Beispiel" in s { col-example }
  else { col-remark }
}

/// Generates a structured, publication-quality index of all theorems, definitions, and lemmas.
/// Groups items by Chapter/Section and includes clean indentation, hairline dividers, and spacious typography.
#let math-index(title: "Verzeichnis der Definitionen und Sätze") = {
  heading(level: 1, numbering: none)[#title]
  v(0.8em)
  context {
    let all-items = query(figure.where(kind: "math-item"))
    // Filter out uncaptioned remarks to keep the theorem directory clean and academic
    let items = all-items.filter(fig => {
      let is-remark = repr(fig.supplement).contains("Bemerkung")
      fig.caption != none or not is-remark
    })

    if items.len() == 0 [
      #text(style: "italic", fill: rgb("#64748b"))[Keine Sätze oder Definitionen erfasst.]
    ] else {
      let current-sec = none
      for fig in items {
        let loc = fig.location()
        let sup = fig.supplement
        let cap = if fig.caption != none { fig.caption.body } else { none }
        let num = counter(figure.where(kind: "math-item")).at(loc).first()
        let hdgs = counter(heading).at(loc)
        let sec-num = if hdgs.len() > 0 { str(hdgs.first()) } else { "0" }
        let full-num = sec-num + "." + str(num)

        // Chapter grouping header with elegant hairline divider
        if sec-num != current-sec {
          current-sec = sec-num
          let sec-headings = query(heading.where(level: 1)).filter(hd => counter(heading).at(hd.location()).at(0, default: 0) == int(sec-num))
          let sec-title = if sec-headings.len() > 0 { sec-headings.first().body } else { [Kapitel #sec-num] }
          v(1.8em, weak: true)
          text(weight: "bold", size: 1.05em, fill: rgb("#312e81"))[§ #sec-num #h(0.4em) #sec-title]
          v(0.25em, weak: true)
          line(length: 100%, stroke: 0.4pt + rgb("#cbd5e1"))
          v(0.65em, weak: true)
        }

        let cat-color = get-category-color(sup)
        pad(left: 1em)[
          #grid(
            columns: (3.4cm, 1fr, 1.2cm),
            gutter: 0.5em,
            align: (left, left, right),
            link(loc)[#text(weight: "bold", fill: cat-color)[#sup #full-num]],
            link(loc)[
              #if cap != none [#text(fill: rgb("#374151"))[#cap]]
              #box(width: 1fr, pad(x: 0.5em, repeat[#text(fill: rgb("#94a3b8"), size: 0.8em)[. ]]))
            ],
            link(loc)[#text(fill: col-link, weight: "bold")[#loc.page()]]
          )
        ]
        v(0.5em, weak: true)
      }
    }
  }
}

// -----------------------------------------------------------------------------
// Document Layout & Configuration Function
// -----------------------------------------------------------------------------

#let script-doc(
  title: none,
  subtitle: none,
  author: none,
  lecturer: none,
  semester: none,
  university: none,
  date: auto,
  lang: "de",
  prologue: none,          // Optional foreword / disclaimer text
  section-symbol: true,    // Prepends § to section numbers if true
  hanging-numbers: true,   // Outdents section numbers into left margin
  body,
) = {
  // Document metadata
  set document(
    title: title,
    author: author,
    date: date,
  )

  // Symmetric margins for comfortable digital reading (tablet / PDF reader)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 2.8cm, bottom: 2.5cm),
    numbering: "1",
    number-align: center,
    header: context {
      let page-num = counter(page).get().first()
      // Suppress running header on title page and prologue page
      if page-num > 2 {
        let h-all = query(heading.where(level: 1))
        let h-before = h-all.filter(h => h.location().page() < page-num)
        let h-on-page = h-all.filter(h => h.location().page() == page-num)

        // If the page starts with a level-1 heading near the top (allowing room for lecture markers),
        // show that new heading. Otherwise, show the heading active at the start of the page.
        let active-heading = if h-on-page.len() > 0 and h-on-page.first().location().position().y < 8.0cm {
          h-on-page.first().body
        } else {
          // Look backwards for the most recent numbered heading (to avoid unnumbered TOC bleeding into content)
          let numbered-before = h-before.filter(h => h.numbering != none)
          if numbered-before.len() > 0 {
            numbered-before.last().body
          } else if h-before.len() > 0 {
            h-before.last().body
          } else if h-on-page.len() > 0 {
            h-on-page.first().body
          } else {
            none
          }
        }

        grid(
          columns: (1fr, auto),
          align: (left, right),
          text(size: 8.5pt, fill: rgb("#64748b"))[#title],
          if active-heading != none { text(size: 8.5pt, fill: rgb("#64748b"))[#active-heading] }
        )
        v(0.4em)
        line(length: 100%, stroke: 0.4pt + rgb("#cbd5e1"))
      }
    }
  )

  // Typography & Paragraph rules
  set text(
    font: "New Computer Modern",
    size: 10.5pt,
    lang: lang,
  )
  set par(
    justify: true,
    leading: 0.68em,
  )
  show math.equation: set block(breakable: true)

  // Headings configuration
  set heading(numbering: "1.1")

  // Make math-item figures breakable across page boundaries and render pure body (suppresses bottom caption)
  show figure.where(kind: "math-item"): set block(breakable: true)
  show figure.where(kind: "math-item"): it => it.body

  // Top-level heading styling & math-item counter reset
  show heading.where(level: 1): it => {
    counter(figure.where(kind: "math-item")).update(0)
    v(2.0em, weak: true)
    if it.numbering != none {
      if hanging-numbers {
        // Outdent section number into left margin so title text aligns with paragraph body
        block(width: 100%, {
          let num-text = if section-symbol [§ #counter(heading).display()] else [#counter(heading).display()]
          place(dx: -2.0cm)[
            #box(width: 1.8cm, align(right)[
              #text(fill: rgb("#312e81"), size: 1.25em, weight: "bold")[#num-text]
            ])
          ]
          text(fill: rgb("#312e81"), size: 1.25em, weight: "bold")[
            #smallcaps(it.body)
          ]
        })
      } else {
        let prefix = if section-symbol [§ #counter(heading).display() #h(0.4em)] else [#counter(heading).display() #h(0.4em)]
        text(fill: rgb("#312e81"), size: 1.25em, weight: "bold")[
          #prefix #smallcaps(it.body)
        ]
      }
    } else {
      text(fill: rgb("#312e81"), size: 1.25em, weight: "bold")[
        #it.body
      ]
    }
    v(0.9em, weak: true)
  }

  show heading.where(level: 2): it => {
    v(1.5em, weak: true)
    if hanging-numbers and it.numbering != none {
      block(width: 100%, {
        place(dx: -2.0cm)[
          #box(width: 1.8cm, align(right)[
            #text(size: 1.1em, weight: "bold", fill: rgb("#334155"))[#counter(heading).display()]
          ])
        ]
        text(size: 1.1em, weight: "bold", fill: rgb("#111827"))[#it.body]
      })
    } else {
      it
    }
    v(0.65em, weak: true)
  }

  // Links styling: colored without ugly global underline
  show link: set text(fill: col-link)
  show ref: it => text(fill: col-link)[#it]

  // --- Title Page ---
  align(center + horizon)[
    #v(-3em)
    #text(size: 2.2em, weight: "bold", fill: rgb("#111827"))[#title] \
    #if subtitle != none {
      v(0.6em)
      text(size: 1.3em, weight: "medium", fill: rgb("#374151"))[#subtitle]
      v(0.4em)
    }
    #if university != none or lecturer != none [
      #v(1.2em)
      #if university != none [#text(size: 1.1em, fill: rgb("#4b5563"))[#university] \ ]
      #if lecturer != none [#text(size: 1.1em, fill: rgb("#4b5563"))[#lecturer] \ ]
    ]
    #if author != none [
      #v(2.5em)
      #text(size: 1.15em, weight: "semibold")[#author] \
    ]
    #if semester != none [
      #v(0.3em)
      #text(size: 1.0em, fill: rgb("#6b7280"))[#semester]
    ]
    #v(3em)
  ]
  pagebreak()

  // Optional Prologue / Foreword page (without redundant author/date footer)
  if prologue != none {
    heading(level: 1, numbering: none)[Vorwort]
    v(0.6em)
    prologue
    pagebreak()
  }

  body
}
