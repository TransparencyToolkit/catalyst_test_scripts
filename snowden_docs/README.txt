This repository contains a cut-down version of the Snowden Document Search
dataspec. The goal of this is to see how well we can duplicate the results of
the text extraction scripts
(https://github.com/TransparencyToolkit/NSA-Data/tree/master/get-data) using
Catalyst alone.

Writing scripts to manipulate the data directly is not allowed. Adding or
manipulating term lists to work with the Catalyst format is allowed and will
be necessary (and eventually these should be addable via the UI).

Adding the manual tags from the RSS feed to the dataspec and extracting terms
matching a term list is allowed for duplicating manually-tagged fields, but we
should also experiment with other options for duplicating the manual tags from
scratch using a combination of entity extraction and term lists.
