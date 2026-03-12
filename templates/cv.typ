#let cv = yaml(sys.inputs.at("content", default: "../content/en.yml"))

// Page setup
#set page(
  paper: "us-letter",
  margin: (x: 1.0in, y: 1in),
)

// Typography
#set text(
  font: "Linux Libertine",
  size: 10.5pt,
  lang: "en",
)

#set par(
  justify: true,
  leading: 0.65em,
)

//  Helper components 

// Section heading with a full-width rule below
#let section(title) = {
  v(0.8em)
  text(weight: "bold", size: 11pt, upper(title))
  line(length: 100%, stroke: 0.5pt)
  v(0.3em)
}

// A single work entry
#let entry(role, company, location, period, bullets) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    row-gutter: 0.5em,
    [*#company*],   align(right)[*#location*],
    [#role],        align(right)[#period],
  )
  v(0.25em)
  for b in bullets {
    [• #b \ ]
  }
  v(0.5em)
}

#let cert(name, detail, url, year) = {
  grid(
    columns: (1fr, auto),
    [*#name* \ #detail \ #link(url)],
    align(right)[*#year*],
  )
  v(0.4em)
}

//  Header 
#align(center)[
  #text(size: 18pt, weight: "bold")[#cv.name] \
  #v(0.3em)
  #link("mailto:" + cv.email)[#cv.email] |
  #link("tel:" + cv.phone)[#cv.phone] |
  #link("https://" + cv.linkedin)[#cv.linkedin]
]

//  Technical Skills 
#section(cv.ui.skills)
#for s in cv.skills [
  *#s.label:* #s.value \
]

//  Work Experience 
#section(cv.ui.experience)
#for e in cv.experience { entry(e.role, e.company, e.location, e.period, e.bullets) }

//  Certifications & Awards 
#section(cv.ui.certifications)
#for c in cv.certifications { cert(c.name, c.detail, c.url, c.year) }
