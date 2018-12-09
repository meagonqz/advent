// Day 2: Inventory Management System

#[macro_use] extern crate itertools;

use itertools::Itertools;
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

    let words = s.split_whitespace();
    for word in words {
        let mut char_counts: HashMap<char, u64> = HashMap::new();
        // Creates a map of char -> occurrences
        for ch in word.chars() {
            let mut value: u64 = match char_counts.get(&ch) {
                Some(c) => c + 1,
                None => 1,
            };
            char_counts.insert(ch, value);
        }
        let mut counts2 = char_counts.clone();
        counts2.retain(|_, v| *v == 2);

        let mut counts3 = char_counts.clone();
        counts3.retain(|_, v| *v == 3);

        let twice_counts = counts2.len();
        let thrice_counts = counts3.len();
        if twice_counts > 0 {
            twice = twice + 1;
        }
        if thrice_counts > 0 {
            thrice = thrice + 1;
        }
    }
    println!("{}", twice * thrice);
    let words2 = s.split_whitespace();
    let words3 = words2.clone();
        let (a, b) = words2
            .cartesian_product(words3)
            .find(|(a, b)| diff_by_one(a, b))
            .expect("Hm, nope");
        println!("{}", common_letters(a, b));
    Ok(())
    }

fn diff_by_one(a: &str, b: &str) -> bool {
    let diff = a.chars().zip(b.chars()).filter(|(a,b)| a != b).count();

    diff == 1
}

fn common_letters(a: &str, b: &str) -> String {
    a.chars().zip(b.chars()).filter(|(a, b)| a == b).map(|(a, _)| a).collect()
}

