#![allow(dead_code)]

extern crate serde_json;
extern crate serde;
extern crate lazy_static;

use serde::{Serialize};

use std::env;
use std::process::exit;
use std::fs::read_to_string as read_file;
use regex::Regex;
use lazy_static::lazy_static;

#[derive(Debug, Serialize)]
struct Recipe {
  name: String,
  parts: Vec<Part>
}

#[derive(Debug, Serialize)]
struct Part {
  label: String,
  instructions: Vec<Instruction>
}

#[derive(Debug, Serialize)]
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

lazy_static! {
  static ref INGREDIENT_REGEX: Regex = Regex::new(r"([^\[^\]]+)\[?([^\[^\].]*)\]?").unwrap();
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
        recipe.name = title(&text);
      }

      (_, Some("#")) => {
        state = State::Part;
        current_part.label = title(&text);
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

  println!("{}", serde_json::to_string(&recipe).unwrap());
}

fn title(text: &String) -> String {
  text.get(1..).unwrap().trim().to_string()
}

fn ingredient_and_modifier(ingredient: &str) -> (String, String) {
  let captures = INGREDIENT_REGEX.captures(&ingredient).unwrap();
  (
    captures[1].trim().to_string(),
    captures[2].trim().to_string()
  )
}

fn ingredient(text: &String) -> Instruction {
  let items: Vec<&str> = text.split("|").collect();
  let (ingredient, modifier) = ingredient_and_modifier(items[2]);
  Instruction::Ingredient {
    amount: items[0].trim().to_string(),
    unit: items[1].trim().to_string(),
    ingredient: ingredient,
    modifier: modifier
  }
}
