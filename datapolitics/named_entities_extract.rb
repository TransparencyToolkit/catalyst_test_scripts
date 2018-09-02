require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpNews"
annotators_to_run = [ {
                        annotator_name: "PersonEntityAnnotator",
                        fields_to_check: ["article_text"]
                      },
                      {
                        annotator_name: "OrganizationEntityAnnotator",
                        fields_to_check: ["article_text"]
                      },
                      {
                        annotator_name: "LocationEntityAnnotator",
                        fields_to_check: ["article_text"],
                        output_param_name: "Locations Mentioned",
                        output_param_icon: "map"
                      }
                     ]

docs_to_process = {
  run_over: "all",
}


   c = Curl::Easy.http_post("http://localhost:9004/annotate",
                            Curl::PostField.content('default_dataspec', default_dataspec),
                            Curl::PostField.content('index', index_name),
                            Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                            Curl::PostField.content('input-params', JSON.generate(annotators_to_run)))

