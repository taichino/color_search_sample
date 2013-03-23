#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json
import math

from xml.etree.ElementTree import tostring
from PIL import Image
import requests
import itertools

import flickrapi
from pit import Pit
from mediancut2 import median_cut2
from util import *


ORIG_DIR = 'orig'
PROC_DIR = 'img'

for target in [ORIG_DIR, PROC_DIR]:
    if not os.path.exists(target):
        os.mkdir(target)

def download():
    config = Pit.get('flickr.com')
    key = config['api_key']

    api = flickrapi.FlickrAPI(key)

    tags = ['blue', 'red', 'green', 'yellow', 'purple', 'cyan']
    index = 0
    for tag in tags:
        for photo in api.photos_search(tags=tag, sort="relevance", license='2')[0]:
            photo_id = photo.attrib['id']

            try:
                sizes = api.photos_getSizes(photo_id=photo_id)[0]
            except:
                continue
            small = sizes.find('.//size[@label="Small"]')
            url = small.attrib['source']

            print 'downloading {0} as {1}'.format(url, index)
            resp = requests.get(url)
            if resp.status_code != 200:
                continue
            with open('{0}/{1:02d}.jpg'.format(ORIG_DIR, index), 'wb') as f:
                for chunk in resp.iter_content():
                    f.write(chunk)
            index += 1
        

def shrink():
    for (parent, dirs, files) in os.walk(ORIG_DIR):
        for file in files:
            path = os.path.join(parent, file)
            image = Image.open(path)
            orig_width = image.size[0]
            factor = float(200) / orig_width
            image = image.resize([int(l * factor) for l in image.size])
            out_path = os.path.join(PROC_DIR, file)
            image.save(out_path)

        
def prepare_palette():
    palettes = {}
    for (parent, dirs, files) in os.walk('img'):
        for file in files:
            path = os.path.join(parent, file)
            palette = median_cut2(path, 3)
            palette = sorted(palette, key=lambda x:((x[0]<<16)+(x[1]<<8)+x[2]))
            palettes[file] = palette

    with open('palette.json', 'w+') as f:
        json.dump(palettes, f)


if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        sys.exit()
    
    cmd = sys.argv[1]
    if cmd == 'download':
        download()
    elif cmd == 'shrink':
        shrink()
    elif cmd == 'palette':
        prepare_palette()

        
        

