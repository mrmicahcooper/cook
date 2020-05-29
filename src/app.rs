extern crate handlebars;
extern crate serde_json;
extern crate serde;
extern crate glob;
extern crate regex;

use glob::glob;
use regex::Regex;
use handlebars::Handlebars;
use serde::{Serialize};
use std::vec::{Vec};
use std::fs::read_to_string as read_file;
use std::fs::write as write_file;

#[derive(Serialize)]
struct Recipe {
  path: String,
  name: String
}

#[derive(Serialize)]
struct Data{
  recipes: Vec<Recipe>
}

fn main() 
{
  let recipes = Data { recipes: recipes()};
  let hbs:String  = read_file("index.hbs").expect("couldn't read index.hbs");
  let recipe_data = serde_json::to_value(&recipes).unwrap();
  let index:String = Handlebars::new().render_template(&hbs, &recipe_data).unwrap();

  write_file("index.html", index).expect("could not write index.html");
  println!("index.html has been written");
}

fn recipes() -> Vec<Recipe>
{
  let mut recipes = Vec::new();
  let regex = Regex::new(r"([\w-]*)\.txt").unwrap();

  for entry in glob("./recipes/*.txt").unwrap() {
    if let Ok(path) = entry {

      let filename:String = path.display().to_string();
      let recipe_name:String = regex.captures(&filename).unwrap()[1].to_string();

      recipes.push(
        Recipe {
          path: filename,
          name: recipe_name
        });
    }
  }

  recipes
}
