#!/usr/bin/env python3

import os
import sys
import json
import uuid
import pathlib
import itertools
import pprint
from contextlib import suppress
from flask import Flask, escape, request

from cromulent import model, vocab

model.factory.base_url = "http://localhost:5000/"

model.HumanMadeObject._uri_segment = "object"
model.Activity._uri_segment = "activity"
model.Place._uri_segment = "place"
model.InformationObject._uri_segment = "info"
model.Group._uri_segment = "group"
model.Actor._uri_segment = "actor"
model.Person._uri_segment = "person"
model.TimeSpan._uri_segment = "time"
model.Production._uri_segment = "activity"
model.Acquisition._uri_segment = "activity"
model.Purchase._uri_segment = "activity"
model.Payment._uri_segment = "activity"
model.MonetaryAmount._uri_segment = "money"
model.Currency._uri_segment = "money"
model.PhysicalObject._uri_segment = "object"
model.Identifier._uri_segment = "identifier"
model.TransferOfCustody._uri_segment = "activity"
model.Move._uri_segment = "activity"
model.LinguisticObject._uri_segment = "text"
model.Appellation._uri_segment = "name"
model.Name._uri_segment = "name"
model.AttributeAssignment._uri_segment = "activity"
model.Dimension._uri_segment = "value"
model.PropositionalObject._uri_segment = "concept"  # For Exhibition concept and bid
model.Destruction._uri_segment = "activity"
model.Phase._uri_segment = "activity"
model.Birth._uri_segment = "activity"
model.Death._uri_segment = "activity"


class Builder:
	def __init__(self):
		self.counter = itertools.count()
		self.class_styles = {
					"HumanMadeObject": "object",
					"Place": "place",
					"Actor": "actor",
					"Person": "actor",
					"Group": "actor",
					"Type": "type",
					"MeasurementUnit": "type",
					"Currency": "type",
					"Material": "type",
					"Language": "type",
					"Name": "name",
					"Identifier": "name",
					"Dimension": "dims",
					"MonetaryAmount": "dims",			
					"LinguisticObject": "infoobj",
					"VisualItem": "infoobj",
					"InformationObject": "infoobj",
					"Set": "infoobj",
					"PropositionalObject": "infoobj",
					"Right": "infoobj",
					"PropertyInterest": "infoobj",
					"TimeSpan": "timespan",
					"Activity": "event",
					"Event": "event",
					"Birth": "event",
					"Death": "event",
					"Production": "event",
					"Destruction": "event",
					"Creation": "event",
					"Formation": "event",
					"Dissolution": "event",
					"Acquisition": "event",
					"TransferOfCustody": "event",
					"Move": "event",
					"Payment": "event",
					"AttributeAssignment": "event",
					"Phase": "event"
				}	

	def normalize_string(self, s, length=40):
		# s = unidecode(s)
		s = s.replace('"', "'")
		# s = truncate_with_ellipsis(s, length) or s
		return s
		
	def uri_to_label_link(self, uri, type):
		link = None
		if uri.startswith('http://vocab.getty.edu/'):
			uri = uri.replace('http://vocab.getty.edu/', '')
			uri = uri.replace('/', ': ')
			return uri, link
		elif uri.startswith(model.factory.base_url):
			uri = uri.replace(model.factory.base_url, '')
			uri = uri.replace('/', '')
			return uri, link
		else:
			return uri, link

	def walk(self, js, curr_int, id_map, mermaid):
		if isinstance(js, dict):
			# Resource
			curr = js.get('id', f'b{next(self.counter)}')
			if curr in id_map:
				currid = id_map[curr]
			else:
				currid = "O%s" % curr_int
				curr_int += 1
				id_map[curr] = currid
			lbl, link = self.uri_to_label_link(curr, js.get('type'))
			line = "%s(\"%s\")" % (currid, lbl)
			if not line in mermaid:
				mermaid.append(line)
			if link:
				line = f'click {currid} "{link}" "Link"'
				if not line in mermaid:
					mermaid.append(line)
			t = js.get('type', '')
			if t:
				style = self.class_styles.get(t, '')
				if style:
					line = "class %s %s;" % (currid, style)
					if not line in mermaid:
						mermaid.append("class %s %s;" % (currid, style))
				else:
					print("No style for class %s" % t)
				line = "%s-- type -->%s_0[%s]" % (currid, currid, t)
				if not line in mermaid:
					mermaid.append(line) 			
					mermaid.append("class %s_0 classstyle;" % currid)

			n = 0
			for k,v in js.items():
				n += 1
				if k in ["@context", "id", "type"]:
					continue
				elif isinstance(v, list):
					for vi in v:
						if isinstance(vi, dict):
							(rng, curr_int, id_map) = self.walk(vi, curr_int, id_map, mermaid)
							mermaid.append("%s-- %s -->%s" % (currid, k, rng))				
						else:
							print("Iterating a list and found %r" % vi)
				elif isinstance(v, dict):
					(rng, curr_int, id_map) = self.walk(v, curr_int, id_map, mermaid)
					line = "%s-- %s -->%s" % (currid, k, rng)
					if not line in mermaid:
						mermaid.append(line)				
				else:
					line = "%s-- %s -->%s_%s(%s)" % (currid, k, currid, n, v)
					if not line in mermaid:
						mermaid.append(line)
						mermaid.append("class %s_%s literal;" % (currid, n))
			return (currid, curr_int, id_map)

	def build_mermaid(self, js):
		curr_int = 1
		mermaid = []
		id_map = {}
		mermaid.append("graph TD")
		mermaid.append("classDef object stroke:black,fill:#E1BA9C,rx:20px,ry:20px;")
		mermaid.append("classDef actor stroke:black,fill:#FFBDCA,rx:20px,ry:20px;")
		mermaid.append("classDef type stroke:red,fill:#FAB565,rx:20px,ry:20px;")
		mermaid.append("classDef name stroke:orange,fill:#FEF3BA,rx:20px,ry:20px;")
		mermaid.append("classDef dims stroke:black,fill:#c6c6c6,rx:20px,ry:20px;")
		mermaid.append("classDef infoobj stroke:#907010,fill:#fffa40,rx:20px,ry:20px")
		mermaid.append("classDef timespan stroke:blue,fill:#ddfffe,rx:20px,ry:20px")
		mermaid.append("classDef place stroke:#3a7a3a,fill:#aff090,rx:20px,ry:20px")
		mermaid.append("classDef event stroke:blue,fill:#96e0f6,rx:20px,ry:20px")
		mermaid.append("classDef literal stroke:black,fill:#f0f0e0;")
		mermaid.append("classDef classstyle stroke:black,fill:white;")
		self.walk(js, curr_int, id_map, mermaid)
		return "\n".join(mermaid)
	

builder = Builder()
app = Flask(__name__)

bi = __builtins__.copy()
tokill = ['print', 'input', '__import__', 'exec', 'eval', 'exit', 'help', 
		  'license', '__loader__', 'memoryview', 'quit']
for k in tokill:
	del bi[k]

@app.route('/', methods=['GET', 'POST'])
def python_to_mermaid():
	if request.method == "POST":	
		py = request.data;
		try:
			# Trash all the globals to prevent easy idiocy
			gl = {'model': model, 'vocab':vocab, '__builtins__': bi}
			exec(py, gl, gl)	
			top = gl['top']
			js = model.factory.toJSON(top)
			mmd = builder.build_mermaid(js)
			return mmd			
		except Exception as e:
			return str(e)
	else:
		fh = open('static/form.html')
		html = fh.read()
		fh.close()
		return html
