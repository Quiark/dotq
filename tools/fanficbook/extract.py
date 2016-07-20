import os
import sys
from lxml import etree
import lxml.html
import requests

URL = r'https://www.fanfiction.net/s/7278544/{}/First-Contact'
COUNT = 16

outfname = os.path.basename(URL) + '.html'
with open(outfname, 'wc') as outf:

	for i in range(1, COUNT + 1):
		page = requests.get(URL.format(i)).content
		#open('out.html', 'wc').write(page.encode('utf-8'))
		dom = lxml.html.fromstring(page)

		#all table rows
		#xpatheval = etree.XPathDocumentEvaluator(dom)
		rows = dom.xpath('//div[@id="storytext"]')

		outf.write( etree.tostring(rows[0]) )


os.system('pandoc -f html -t epub -o {} {}'.format(os.path.basename(URL) + '.epub', outfname))
