// Day

use std::fs::File;
use std::io::prelude::*;
use std::io::Result;

fn main() -> Result<()> {
    let mut file = File::open("input")?;

    let mut s = String::new();
    file.read_to_string(&mut s)?;

    println!("{}", s);
    Ok(())
}
