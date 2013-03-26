# -*- coding: utf-8 -*-

import os

from django.conf import settings
from django.db import models

import requests
from PIL import Image as PIL_Image

class Color(models.Model):
    R = models.IntegerField(default=0)
    G = models.IntegerField(default=0)
    B = models.IntegerField(default=0)

    @staticmethod
    def get_nearest(R, G, B):
        R = int((R + 8) / 16) * 16
        G = int((G + 8) / 16) * 16
        B = int((B + 8) / 16) * 16

        return Color.objects.get(R=R, G=G, B=B)


class ImageManager(models.Manager):
    def get_or_create_or_update(self, url, num):
        resp = requests.get(url)
        if resp.status_code != 200:
            raise "ERR status code: %s" % (resp.status_code)
        
        filename = '{0:03d}.jpg'.format(num)
        path = os.path.join(settings.MEDIA_ROOT, 'img', filename)
        with open(path, 'wb') as f:
            for chunk in resp.iter_content():
                f.write(chunk)

        pil_image = PIL_Image.open(path)
        orig_width = pil_image.size[0]
        factor = float(150) / orig_width
        width = int(pil_image.size[0] * factor)
        height = int(pil_image.size[1] * factor)
        
        pil_image = pil_image.resize([width, height])
        pil_image.save(path)
        
        obj, created = self.get_or_create(path=path)
        obj.width = width
        obj.height = height
        obj.orig_url = url

        return obj
        

class Image(models.Model):
    objects = ImageManager()
    
    path = models.CharField(max_length=128, unique=True)
    orig_url = models.TextField()
    width = models.IntegerField(default=0)
    height = models.IntegerField(default=0)
    dominant_color = models.ForeignKey(Color, related_name='dominant_color', blank=True, null=True)
    colors = models.ManyToManyField(Color)

