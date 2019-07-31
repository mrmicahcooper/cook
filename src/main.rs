extern crate handlebars;
extern crate serde_json;
extern crate serde;
extern crate glob;
extern crate regex;

use glob::glob;
use regex::Regex;
use handlebars::Handlebars;
use serde::{Serialize};
use std::fs::File;



#[derive(Serialize, Debug)]
struct Recipe {
  path: String,
  name: String
}

fn main() 
{
  let recipes:std::vec::Vec<Recipe> = recipes();
  let mut handlebars = Handlebars::new();
  let data = serde_json::to_string(&recipes).unwrap();
  let index = index();

  println!(
        "{}",
        handlebars.render_template(&index, &recipes)
    );

}

fn index()  -> String
{
  let index_file = File::open("index.hbs");
  let mut buffer = String::new();
  index_file.read_to_string(&mut buffer)
}

fn recipes() -> std::vec::Vec<Recipe> 
{
  let mut recipes = Vec::new();
  let regex = Regex::new(r"^([\w-]*)").unwrap();

  for entry in glob("./*.txt").unwrap() {
    if let Ok(path) = entry {

      let filename:String = path.display().to_string();
      let recipe_name:String = regex.captures(&filename).unwrap()[0].to_string();

      recipes.push(
        Recipe {
          path: filename,
          name: recipe_name
        });
    }
  }

  recipes
}
