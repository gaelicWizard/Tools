#!/usr/bin/env python
# -*- coding: utf-8 -*-

### This script takes one arguments: 
### ### the path of the plist to populate WITHOUT THE EXTENSION #TODO:FIXME:bug


import imdb
import subprocess
import sys
import os

atomicMetadataTrack = os.path.abspath(sys.argv[1])
 # /path/to/plist
imdbID = subprocess.Popen(
                            [
                                "defaults", 
                                "read", 
                                atomicMetadataTrack, 
                                "imdbID"
                            ], 
                            stdout=subprocess.PIPE
                          ).communicate()[0].strip()

if imdbID.isdigit() is False:
 print imdbID
 die



i = imdb.IMDb()
m = i.get_movie(imdbID)
i.update(m,'all') # overkill


def pluraliseOrMap(that):
 if that in ["writer"]:
  return "screenwriters"
 elif that in ["plotoutline"]:
  return "description" # unused
 elif that in ["productioncompanies"]:
  return "studio"
 elif that in ["cast", "productioncompanies"]:
  return that
 else:
  return that + "s"



# First loop, for iTunMOVI-style array-of-dictionaries lists
## Each 'the_person' is a dictionary, containing _at least_ a 'name' key and an imdbID
## Some 'the_person' objects may also have a currentRole instance variable, which _may_ be a list
for the_person_type in [ # Code Duplication :-/
                        'cast', # The list of all actors appearing
                        'co director', # A list of crew
                        'co executive producer', # A list of crew
                        'co producer', # A list of crew
                        'director', # A list of crew
                        'producer', # A list of crew
                        'writer', # The list of authors, screen writers, developers, &c.
                        'executive producer', # A list of crew
                        'supervising producer', # A list of crew
                        'assistant producer', # A list of crew
                        'associate producer', # A list of crew
                        'coordinating producer', # A list of crew
                        'consulting producer', # A list of crew
                        'line producer', # A list of crew
                        'production companies', # A list of companies
                        'editor',
                        'costume designer', 
                        'art direction', 
                        'assistant director', 
                        'casting director', 
                        'production manager', 
                        'cinematographer', 
                        ]:
 if m.has_key(the_person_type):
  for the_person in m[the_person_type]:
   cr = ""
   
   if the_person.currentRole:
    cr = "role = "
    if isinstance(the_person.currentRole, list):
     pcr = the_person.currentRole
    else:
     pcr = [ the_person.currentRole ]
    
    #^cr is list
    cr+= "("
    for the_cr in pcr:
     cr+= "{ "
     cr+= "name = \"" + the_cr['name'] + "\";"
     try: # Some character objects _do not have_ imdbIDs.
      cr+= "imdbID = \"" + i.get_imdbID(the_cr) + "\";"
     except:
      pass
     cr+= " },"
    #^the_cr loop
    cr = cr[:-1] # Remove the final comma
    cr+= ");"
   #^p.cr
   
   print the_person_type+": "+ the_person['name']
   subprocess.call([
                    "defaults", 
                    "write", 
                    atomicMetadataTrack, 
                    pluraliseOrMap(the_person_type.replace(" ","")), 
                    "-array-add", 
                    "{ name = \"" + the_person['name'] + "\";"
                     +
                    "imdbID = \"" + i.get_imdbID(the_person) + "\";" +cr+ " }" # Make sure to produce _extra_ quotes for defaults(1) to parse
                    ])



# Second loop, for simple lists
## each the_metadata_type is a list of strings
for the_metadata_type in [
                          'genres',
                          'release dates',
                          'akas',
                          'runtimes',
                          'taglines',
                          'certificates',
                          'locations', 
                          'keywords',
                         ]:
 if m.has_key(the_metadata_type):
  for the_metadata in m[the_metadata_type]:
   print the_metadata_type+": "+ the_metadata
   subprocess.call([
                    "defaults", 
                    "write", 
                    atomicMetadataTrack,
                    the_metadata_type.replace(" ",""), 
                    "-array-add", 
                    "\""+the_metadata+"\"" # Make sure to produce _extra_ quotes for defaults(1) to parse
                    ])



# Third loop, for single property/attribute
for the_metadata_type in [
                          'mpaa',
                          'plot outline', # One sentence(?).
                          'year',
                          'title',
                          'kind',
                          'cover url',
                          'full-size cover url',
                          'long imdb title', 
                         ]:
 if m.has_key(the_metadata_type):
  if isinstance(m[the_metadata_type],int):
   the_metadata = repr(m[the_metadata_type])
  else:
   the_metadata = m[the_metadata_type]
  print the_metadata_type+": "+ the_metadata
  subprocess.call([
                   "defaults", 
                   "write", 
                   atomicMetadataTrack,
                   the_metadata_type.replace(" ",""), 
                   "\""+the_metadata+"\"" # Make sure to produce _extra_ quotes for defaults(1) to parse
                   ])

subprocess.call([ "plutil", "-convert", "xml1", atomicMetadataTrack+".plist"])
 # Convert from binary plist to text-based xml


#unused
def prop_attr(ob, lok):
 ospl = ""
 for mdt in lok:
  if ob.has_key(mdt):
   if isinstance(ob[mdt],int):
    md = repr(ob[mdt])
   else:
    md = ob[mdt]
   ospl += "\""+ mdt +"\" = \""+ md +"\"; "
 return ospl

