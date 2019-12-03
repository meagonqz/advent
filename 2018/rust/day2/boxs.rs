// Day 2: Inventory Management System

use std::collections::HashMap;
use std::fs::File;
use std::io::prelude::*;
use std::io::Result;

fn main() -> Result<()> {
    let mut file = File::open("input")?;

    let mut s = String::new();
    file.read_to_string(&mut s)?;

    let mut twice = 0;
    let mut thrice = 0;

    for word in s.split_whitespace() {
        let parsed: String = word.parse().unwrap();
        let mut charCounts: HashMap<char, u64> = HashMap::new();
        // Creates a map of char -> occurrences
        for ch in word.chars() {
            let mut value: u64 = match charCounts.get(&ch) {
                Some(c) => c + 1,
                None => 1,
            };
            charCounts.insert(ch, value);
        }
        //println!("{}", charCounts.len());
        let mut counts2 = charCounts.clone();
        counts2.retain(|_, v| *v == 2);

        let mut counts3 = charCounts.clone();
        counts3.retain(|_, v| *v == 3);

        let twiceCounts = counts2.len();
        let thriceCounts = counts3.len();
        if twiceCounts > 0 {
            twice = twice + 1;
        }
        if thriceCounts > 0 {
            thrice = thrice + 1;
        }
    }

    println!("The checksum is {}", twice * thrice);
    Ok(())
}
