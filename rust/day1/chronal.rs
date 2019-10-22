// Day 1: Chronal Calibration

use std::collections::HashSet;
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;
use std::process;

fn main() {
    println!("Ho ho ho! Day 1 of our advent calendar!\n");

    let mut sum = 0;

    let path = Path::new("input");
    let display = path.display();

    let mut file = match File::open(&path) {
        Err(why) => panic!("couldn't open {}: {}", display, why.description()),
        Ok(file) => file,
    };

    let mut s = String::new();
    match file.read_to_string(&mut s) {
        Err(why) => panic!("couldn't read {}: {}", display, why.description()),
        Ok(_) => println!("Read file \"input\"\n"),
    }

    let mut freq: HashSet<i32> = HashSet::new();

    for word in s.split_whitespace() {
        let parsed: i32 = word.parse().unwrap();
        sum = sum + parsed;
        if freq.contains(&sum) {
            println!("We have found a duplicate! {}", sum);
        }
        freq.insert(sum);
    }

    println!("Question 1: {}\n", sum);

    loop {
        for word in s.split_whitespace() {
            let parsed: i32 = word.parse().unwrap();
            sum = sum + parsed;
            if freq.contains(&sum) {
                println!("Question 2: {}\n", sum);
                process::exit(0);
            }
            freq.insert(sum);
        }
    }
}
