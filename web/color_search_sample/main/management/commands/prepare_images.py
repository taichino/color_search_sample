# -*- coding: utf-8 -*-

import os
from optparse import make_option

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError

from pit import Pit
import flickrapi

from main.models import Image, Color

class Command(BaseCommand):
    option_list = BaseCommand.option_list + (
        make_option('--tags',
                    action='store',
                    type="string",
                    help='Tags of images to be downloaded'),
    )
    
    def handle(self, *args, **options):
        print 'Downloading images from Flickr'

        config = Pit.get('flickr.com')
        key = config['api_key']
        api = flickrapi.FlickrAPI(key)

        tags = options.get('tags')
        if tags:
            tags = [tag.strip() for tag in tags.split(',')]
        else:
            tags = ['blue', 'red', 'green', 'yellow', 'purple', 'cyan']
            
        index = Image.objects.count()
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
