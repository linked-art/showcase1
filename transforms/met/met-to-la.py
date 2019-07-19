
from lxml import etree
import requests
from cromulent import model, vocab
from sqlitedict import SqliteDict
import sys

cache = SqliteDict('./met-cache.sqlite', autocommit=True)
headers =  {'cookie': 'cro_segment_utm_source=none; cro_segment_utm_medium=none; cro_segment_utm_campaign=none; cro_segment_utm_term=none; cro_segment_utm_content=none; cro_segment_referrer=https://github.com/linked-art/showcase1/issues/2; cro_segment_utm_source=none; cro_segment_utm_medium=none; cro_segment_utm_campaign=none; cro_segment_utm_term=none; cro_segment_utm_content=none; cro_segment_utm_source=none; cro_segment_utm_medium=none; cro_segment_utm_campaign=none; cro_segment_utm_term=none; cro_segment_utm_content=none; visid_incap_1661922=4yNQM1ymQ0S0ds+kNG1sqaW6dVwAAAAAQUIPAAAAAAD3BqDWe3DyqX52iEbWfx60; optimizelyEndUserId=oeu1560957955761r0.8622262633285835; _gcl_au=1.1.1832643035.1560957956; _ga=GA1.2.2010161445.1560957956; visid_incap_1661977=JpQE5VisRAOXiwZGHrp8ywVUCl0AAAAAQUIPAAAAAABUQlmeu8gnK5siPOPXfRGv; ki_s=175475%3A0.0.0.0.0; ObjectPageSet=0.353466468562124; visid_incap_1662004=lm3lPyc+TOqAFKuaI2cszHnFHF0AAAAAQUIPAAAAAABCvBAdZNNIVDgppVgb34y0; ASP.NET_SessionId=va0j4yfzty4gf3n1w0dqvu5w; SC_ANALYTICS_GLOBAL_COOKIE=24aec097a5854058a48a4335f134aba3|False; __RequestVerificationToken=Qw9upa-5qMYvc5u-22W7wMT5jewxYKfHl-rkK8SO-AXYL8rpTDoJ52C1F1Xta0_bngjO8KSSwHkI0K7o8GWWkqtAwvY1; _gid=GA1.2.1226308955.1563319618; ki_r=; incap_ses_549_1661922=tPmjOhRlBTVbgxPu/XGeB39hL10AAAAA4ypjaKYW2Yqdk7KD65ug5g==; incap_ses_549_1662004=TPpyIS6pokWnhxPu/XGeB4RhL10AAAAA1eJ0qg+//hBVudsE4Jz8VQ==; incap_ses_549_1661977=0RTrHVJ5UgTuhxPu/XGeB4RhL10AAAAARrasy1uFNDFIb5OkT5hJ0A==; _dc_gtm_UA-72292701-1=1; ki_t=1560957958043%3B1563381785627%3B1563386864166%3B4%3B16', 'cache-control': 'no-cache', 'Referer': 'https://www.metmuseum.org/art/collection/search/488694?searchField=All&amp;sortBy=Relevance&amp;who=O%27Keeffe%2c+Georgia%24Georgia+O%27Keeffe&amp;ft=*&amp;offset=0&amp;rpp=80&amp;pos=15', 'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3', 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36'}

def fetch(url, type="json", delay=0):
	# Look in sqlite
	if url in cache:
		return cache[url]
	# Otherwise fetch
	print("Fetching remote %s" % url)
	# Be polite...
	time.sleep(delay)
	resp = requests.get(url, headers=headers)
	if type == "json":
		data = resp.json()
		if 'error' in data:
			# bad request, move along
			raise ValueError("no data for %s" % urlpath)
	else:
		data = resp.text

	cache[url] = data
	return data

# https://collectionapi.metmuseum.org/public/collection/v1/objects/488694 

objectTypeMap = {
	"Paintings": vocab.Painting
}

nationalityMap = {
	"American": vocab.instances['american nationality']
}

noteMap = {
	"Signatures, Inscriptions, and Markings": vocab.Inscription,
	"Provenance": vocab.ProvenanceStatement,
	"Exhibition History": vocab.ExhibitionStatement,
	"References": vocab.BibliographyStatement
}

baseUrl = "https://collectionapi.metmuseum.org/public/collection/v1/objects/"

if '--all' in sys.argv:
	alljs = fetch("https://collectionapi.metmuseum.org/public/collection/v1/objects")
	objects = alljs['objectIDs']
	fetchDelay = 1
else:
	# Only George O'Keeffe
	objects = [488694, 489814, 489813, 482299, 484832, 488600, 489816, 489815, 482263, 482289, \
			484830, 484831, 484833, 262102, 489281, 488229, 489245, 489064, 489360, 489156, \
			489063, 487764, 488601, 262098, 262099, 262103, 262104, 262100, 262101, 365574 ]
	fetchDelay = 0

for oid in objects:
	url = "%s%s" % (baseUrl, oid)
	js = fetch(url, "json", fetchDelay)

	cls = objectTypeMap.get(js['classification'], model.HumanMadeObject)
	artwork = cls(ident=url)
	artwork.identified_by = vocab.LocalNumber(value=js['objectID'])
	artwork.identified_by = vocab.AccessionNumber(value=js['accessionNumber'])
	artwork.identified_by = vocab.Title(value=js['title'])

	prod = model.Production()
	artwork.produced_by = prod
	if js['objectBeginDate'] or js['objectEndDate'] or js['objectDate']:
		ts = model.TimeSpan()
		ts.begin_of_the_begin = js.get('objectBeginDate', js.get('objectDate', None))
		ts.end_of_the_end = js.get('objectEndDate', js.get('objectDate', None))
		ts.identified_by = model.Name(value=js['objectDate'])
		prod.timespan = ts

	artist = model.Person()
	if js['artistDisplayName']:
		artist.identified_by = model.Name(value=js['artistDisplayName'])
		prod.carried_out_by = artist
	if js['artistDisplayBio']:
		artist.referred_to_by = vocab.BiographyStatement(value=js['artistDisplayBio'])
	if js['artistNationality']:
		artist.classified_as = nationalityMap[js['artistNationality']]
	if js['artistBeginDate']:
		born = model.Birth()
		bts = model.TimeSpan()
		bts.begin_of_the_begin = js['artistBeginDate']
		bts.end_of_the_end = js['artistBeginDate']
		bts.identified_by = model.Name(value=js['artistBeginDate'])
		born.timespan = bts
		artist.born = born
	if js['artistEndDate']:
		death = model.Death()
		bts = model.TimeSpan()
		bts.begin_of_the_begin = js['artistEndDate']
		bts.end_of_the_end = js['artistEndDate']
		bts.identified_by = model.Name(value=js['artistBeginDate'])
		death.timespan = bts
		artist.died = death

	if js['medium']:
		artwork.referred_to_by = vocab.MaterialStatement(value=js['medium'])
	if js['dimensions']:
		artwork.referred_to_by = vocab.DimensionStatement(value=js['dimensions'])
	if js['creditLine']:
		artwork.referred_to_by = vocab.CreditStatement(value=js['creditLine'])

	if js['geographyType'] == "Made in":
		# Put a place on the Production
		bestPlace = None
		if js['country']:
			country = vocab.Nation()
			country.identified_by = model.Name(value=js['country'])
			bestPlace = country
		if js['state']:
			state = vocab.Province()
			state.identified_by = model.Name(value=js['state'])
			state.part_of = country
			bestPlace = state
		if js['city']:
			city = vocab.City()
			city.identified_by = model.Name(value=js['city'])
			city.part_of = state
			bestPlace = city
		if bestPlace:
			prod.took_place_at = bestPlace


	if js['objectURL']:
		# fetch more data from the website
		data = fetch(js['objectURL'], "html", fetchDelay)
				

		dom = etree.HTML(data)
		art = dom.xpath('//section[@id="artwork-section"]')[0]

		location = art.xpath('.//span[@class="artwork__location--gallery"]//text()')
		if location:
			gallery = vocab.Gallery()
			gallery.identified_by = model.Name(value=location[0])
			artwork.current_location = gallery

		image = art.xpath('.//div[@id="artwork__image__wrapper"]/img/@src')
		if image:
			img = vocab.DigitalImage(ident=image[0])
			artwork.representation = img

		desc = art.xpath('.//div[@class="artwork__intro__desc"]//text()')
		descText = ''.join(desc).strip()
		artwork.referred_to_by = vocab.Description(value=descText)

		accords = dom.xpath('//section[@class="accordion"]/header/h2[@class="accordion__title gtm__accordion--click"]')
		values  = dom.xpath('//section[@class="accordion"]/div[@class="accordion__content"]')

		for (l,v) in zip(accords, values):
			txt = l.text
			value = ''.join(v.xpath('.//text()')).strip()
			cls = noteMap.get(txt)
			artwork.referred_to_by = cls(value=value)

	jstr = model.factory.toString(artwork, compact=False)
	fh = open('../../data/met/%s.json' % oid, 'w')
	fh.write(jstr)
	fh.close()
