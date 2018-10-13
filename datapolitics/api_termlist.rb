require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpNews"
annotators_to_run = [ 
                      {
                        annotator_name: "TermlistAnnotator",
                        fields_to_check: ["article_text"],
                        input_params: {
                          term_list: File.read("country_names.json"),
                          case_sensitive: false},
                        output_param_name: "Countries Mentioned",
                        output_param_icon: "countries"
                      },
                      {
                        annotator_name: "NormalizedTermlistAnnotator",
                        fields_to_check: ["article_text"],
                        input_params: {
                          term_list: File.read("normalized_topics.json"),
                          case_sensitive: false},
                        output_param_name: "Normalized Topics Discussed",
                        output_param_icon: "document-topic"
                      }
                     ]

docs_to_process = {
  run_over: "all",
}

recipe_name = "Recipe Name 8"

inputs = {
  title: recipe_name,
  docs_to_process: docs_to_process,
  index_name: index_name,
  doc_type: default_dataspec
}

c = Curl::Easy.http_post("http://localhost:3000/create_recipe",
                         Curl::PostField.content('recipe', JSON.generate(inputs)))

annotators_to_run.each do |annotator|
  annotate_in = {
    annotator_class: annotator[:annotator_name],
    human_readable_label: annotator[:output_param_name],
    icon: annotator[:output_param_icon],
    fields_to_check: annotator[:fields_to_check],
    annotator_options: annotator[:input_params]
  }

  c = Curl::Easy.http_post("http://localhost:3000/create_annotator",
                           Curl::PostField.content('recipe_name', recipe_name),
                           Curl::PostField.content('annotator', JSON.generate(annotate_in)))

  # Read the annotator output
  annotators = Curl.get("http://localhost:3000/get_annotators_for_recipe", {recipe_name: recipe_name})
  annotator_list = JSON.parse(annotators.body_str)
  
  # Update the annotator
  annotate_in[:human_readable_label] = annotator[:output_param_name]+" Changed"
  c = Curl::Easy.http_post("http://localhost:3000/update_annotator",
                           Curl::PostField.content('annotator_id', annotator_list.first["id"]),
                           Curl::PostField.content('updated_annotator', JSON.generate(annotate_in)))
end

# Read the recipe output
recipes = Curl.get("http://localhost:3000/get_recipes_for_index", {index_name: index_name})
cookbook = JSON.parse(recipes.body_str)

# Read the annotator output
annotators = Curl.get("http://localhost:3000/get_annotators_for_recipe", {recipe_name: recipe_name})
annotator_list = JSON.parse(annotators.body_str)

# Run Catalyst
Curl.get("http://localhost:3000/run_recipe", {recipe_name: recipe_name})
sleep(60)
# Update recipes (commented as need to get the specific ID to run)
inputs[:title] = "UPDATED"
c = Curl::Easy.http_post("http://localhost:3000/update_recipe",
                                                  Curl::PostField.content('recipe_id', cookbook.first["id"]),
                                                  Curl::PostField.content('updated_recipe', JSON.generate(inputs)))

# Destroy the annotator
c = Curl::Easy.http_post("http://localhost:3000/destroy_annotator",
                                                  Curl::PostField.content('annotator_id', annotator_list.first["id"]))

# Destroy the recipe
c = Curl::Easy.http_post("http://localhost:3000/destroy_recipe",
                         Curl::PostField.content('recipe_id', cookbook.first["id"]))
