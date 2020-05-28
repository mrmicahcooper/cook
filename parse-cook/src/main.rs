#![allow(dead_code)]

use std::env;
use std::fs::read_to_string as read_file;
use regex::Regex;

#[derive(Debug)]
struct Recipe {
  name: String,
  parts: Vec<Part>
}

#[derive(Debug)]
struct Part {
  label: String,
  instructions: Vec<Instruction>
}

#[derive(Debug)]
enum Instruction {
  Action(String),
  Ingredient { 
    amount: i8, 
    unit: String, 
    ingredient: String, 
    modifier: String 
  }
}

#[derive(PartialEq)]
enum State {
  Empty,
  Title,
  Part,
  Action,
  Ingredient
}

fn main() {
  let args: Vec<String> = env::args().collect();
  let file = read_file(&args[1]).unwrap();
  let lines: Vec<&str> = file.split("\n").collect(); 

  let mut recipe = Recipe{ name: String::new(), parts: Vec::new() };
  let mut current_part = Part { label: String::new(), instructions: Vec::new() };
  let mut state: State = State::Empty;

  for line_number in 0..=lines.len() -2 {
    let line: String = lines[line_number].to_string();

    if line == "" { continue; }

    let first_character = &line[0..1];

    match (&state, line_number, first_character) {
      (State::Empty, 0, _) => {
        state = State::Title;
        recipe.name = line;
      }

      (State::Title, _, "#") => {
        state = State::Part;
        current_part.label = line;
      }

      (State::Part, _, " ") => {
        state = State::Action;
        let action = Instruction::Action(line);
        current_part.instructions.push(action);
      }

      (State::Part, _, _) => {
        state = State::Action;
        let ingredient = ingredient(line)
        let action = Instruction::Ingredient();
        current_part.instructions.push(action);
      }

      _ => {}
    }

  }

  println!("{:?}", recipe);
}

fn ingredient(line: String) -> Instruction::Ingredient {
  let regex = Regex::new(r"(.+)\[(.+)\]").unwrap();
  let [amount, unit, ingredient_base] = line.split("|");
  let [ingredient, modifier] = regex.captures(&ingredient_base)?

}
