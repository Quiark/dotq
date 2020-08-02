# pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib oauth2client
import os
import sys
import json
from subprocess import Popen
from pprint import pprint
from os.path import join

from apiclient import sample_tools
import apiclient
from httplib2 import Http

from ConfigParser import ConfigParser

cfg = ConfigParser()
cfg.read('blogpost.ini')


service, flags = sample_tools.init(
      sys.argv, 'blogger', 'v3', __doc__, __file__,
      # CTC: OAuth 2.0 scope information for the Blogger API
      scope='https://www.googleapis.com/auth/blogger')


blog = service.blogs().getByUrl(url=cfg.get('blog', 'url')).execute()
blogId = blog['id']

sposts = service.posts()

def all_posts(blogId, bodies=False):
    request = sposts.list(blogId=blogId, fetchBodies=bodies)
    while request != None:
        posts_doc = request.execute()
        if 'items' in posts_doc and not (posts_doc['items'] is None):
            for post in posts_doc['items']:
                yield post
        request = sposts.list_next(request, posts_doc)

# TODO: dump / backup all to file if asked
# but need to do paging
#pprint(posts)

def update_post(title, content):
    #print('T', title)
    fnd = None
    for i in all_posts(blogId):
        #print('F', i['title'])
        if i['title'] == title:
            fnd = i
            break

    if fnd == None:
        sposts.insert(
            blogId=blog['id'],
            body={
                'content': content,
                'title': title
            }).execute()
    else:
        sposts.patch(
            blogId=blogId,
            postId=fnd['id'],
            body={
                'content': content
            }).execute()


def convert_post(name):
    filename, ext = os.path.splitext(name)
    outfile = filename + '.html'
    p = Popen(['pandoc', '-t', 'html', '-f', 'markdown', '-o', outfile, name])
    p.wait()

    with open(outfile) as inf:
        body = inf.read()

    return body

def do_backup():
    data = list(all_posts(blogId, True))

    with open(cfg.get('blog', 'backup'), 'wc') as outf:
        json.dump(data, outf)

def do_update():
    post_name = cfg.get('input', 'name') + '.md'
    title = unicode(cfg.get('input', 'title'))
    body = convert_post(join(cfg.get('input', 'path'), post_name))
    update_post(title, body)


if __name__ == '__main__':
    #do_backup()
    do_update()
