#![allow(dead_code)]

use std::env;
use std::process::exit;
use std::fs::read_to_string as read_file;

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
    amount: String,
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

  if args.len() < 2 {
    println!("filename required");
    exit(0);
  }

  let file = read_file(&args[1]).unwrap();
  let lines = file.split("\n");

  let mut recipe = Recipe{ name: String::new(), parts: Vec::new() };
  let mut current_part = Part { label: String::new(), instructions: Vec::new() };
  let mut state: State = State::Empty;

  for line in lines {
    let text = line.to_string();

    match (&state, &text.get(0..1)) {

      (State::Empty, None) => { }

      (State::Empty, Some("!")) => {
        state = State::Title;
        recipe.name = text;
      }

      (State::Title, Some("#")) => {
        state = State::Part;
        current_part.label = text;
      }

      (State::Part, None) => {
        recipe.parts.push(current_part);
        current_part = Part { label: String::new(), instructions: Vec::new() };
      }

      (State::Part, Some(" ")) => {
        current_part.instructions.push(ingredient(&text.to_string()));
      }

      (State::Part, _) => {
        let action = Instruction::Action(text);
        current_part.instructions.push(action);
      }

      _ => {}
    }

  }

  println!("{:?}", recipe);
}

fn ingredient(text: &String) -> Instruction {
  let items: Vec<&str> = text.split("|").collect();
  Instruction::Ingredient {
    amount: items[0].trim().to_string(),
    unit: items[1].trim().to_string(),
    ingredient: items[2].trim().to_string(),
    modifier: String::from("modifier")
  }
}
