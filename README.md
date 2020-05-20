# Clank | Cook

[![Netlify Status](https://api.netlify.com/api/v1/badges/2b2711c1-a5aa-4327-80ae-56ab53d6bb10/deploy-status)](https://app.netlify.com/sites/cookclank/deploys)

## Recipe Format

```txt
// this file describes how to write a recipe
// max line length 50 characters
!recipe-name

#instruction label
action
  ingredient
action
  intgredient

action

Ingredient =
  amount | unit | food-or-component [modifier]

=============================
```

## Usage

- Clone the repo
- Add a recipe with  <recipe_name>.txt
- Any .txt file will be added to the site via the `./build_recipes`
- Create a PR for the new recipe
- Once it's merged, it will be added to the site.
```
