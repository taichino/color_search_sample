# -*- coding: utf-8 -*-

import os

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError

from pit import Pit
import flickrapi

from main.models import Image, Color

class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        print 'Downloading images from Flickr'

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
                print 'downloading {0}'.format(url)

                image = Image.objects.get_or_create_or_update(url, index)
                image.save()

                index += 1

        print 'Done...'
