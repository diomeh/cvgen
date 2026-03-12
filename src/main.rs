use std::{fs, process::Command};

fn main() {
    fs::create_dir_all("dist").expect("failed to create dist/");

    let entries = fs::read_dir("content").expect("content/ directory not found");

    for entry in entries {
        let path = entry.unwrap().path();
        let ext = path.extension().and_then(|e| e.to_str());
        if ext != Some("yaml") && ext != Some("yml") {
            continue;
        }

        let lang = path.file_stem().unwrap().to_str().unwrap();

        if lang == "example" {
            println!("skipping {lang} (demo file)");
            continue;
        }

        let output = format!("dist/{lang}.pdf");
        let filename = path.file_name().unwrap().to_str().unwrap();

        // Pass path from root, Typst will resolve /content/en.yml from --root .
        let content_arg = format!("content=/content/{filename}");

        println!("compiling {lang}...");

        let status = Command::new("typst")
            .args([
                "compile",
                "templates/cv.typ",
                &output,
                "--root", ".",
                "--input", &content_arg,
                "--font-path", "fonts/",
            ])
            .status()
            .expect("typst not found — is it installed?");

        if status.success() {
            println!("  -> {output}");
        } else {
            eprintln!("  -> failed for {lang}");
        }
    }
}
