use regex::Regex;
use std::collections::HashSet;
use std::fs::File;
use std::io::prelude::*;
use std::io::Result;

extern crate regex;

fn main() -> Result<()> {
    let mut file = File::open("input")?;

    let mut s = String::new();
    file.read_to_string(&mut s)?;

    let mut dups: HashSet<(i64, i64)> = HashSet::new();
    let mut visited: HashSet<(i64, i64)> = HashSet::new();
    let mut no_dups: Vec<(&str, Vec<(i64, i64)>)> = Vec::new();
    // Example #123 @ 3,2: 5x4
    let re = Regex::new(r"(#\d*)\s@\s(\d*),(\d*):\s(\d*)x(\d*)").expect("Invalid regex");

    let words = s.split("\n");
    for word in words {
        if word.len() == 0 {
            continue;
        }
        let captures = re.captures(word);
        let caps = captures.expect("Expected captures");

        let offset_x: i64 = caps
            .get(2)
            .expect("Param 2")
            .as_str()
            .parse()
            .expect("Integer 2");
        let offset_y: i64 = caps
            .get(3)
            .expect("Param 3")
            .as_str()
            .parse()
            .expect("Integer 3");
        let width: i64 = caps
            .get(4)
            .expect("Param 4")
            .as_str()
            .parse()
            .expect("Integer 4");
        let height: i64 = caps
            .get(5)
            .expect("Param 5")
            .as_str()
            .parse()
            .expect("Integer 5");
        let indices: Vec<(i64, i64)> = calculate_indices(offset_x, offset_y, width, height);
        let dup_indices = indices.clone();
        let mut dup_found: bool = false;
        for i in indices {
            // If already in dup set, continue
            if dups.contains(&i) {
                dup_found = true;
                continue;
            // Else, on each index insertion, check if in visited set, if so, add to new dup set
            } else if visited.contains(&i) {
                dup_found = true;
                dups.insert(i);
            // Otherwise mark as visited
            } else {
                visited.insert(i);
            }
        }
        if !dup_found {
            no_dups.push((caps.get(1).expect("Param 1").as_str(), dup_indices));
        }
    }
    println!("{}", dups.len());

    for (claim, indices) in no_dups {
        let mut dup = false;
        for i in indices {
            if dups.contains(&i) {
                dup = true;
            }
        }
        if !dup {
            println!("{}", claim)
        }
    }
    Ok(())
}

fn calculate_indices(offset_x: i64, offset_y: i64, width: i64, height: i64) -> Vec<(i64, i64)> {
    let x: i64 = offset_x;
    let y: i64 = offset_y;
    let w: i64 = offset_x + width;
    let h: i64 = offset_y + height;

    let mut indices = Vec::new();
    for c0 in x..w {
        for c1 in y..h {
            indices.push((c0, c1));
        }
    }
    return indices;
}
