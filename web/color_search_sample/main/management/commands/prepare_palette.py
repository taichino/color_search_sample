# -*- coding: utf-8 -*-

from django.core.management.base import BaseCommand, CommandError

from main.models import Image, Color
from main.utils import modified_mediancut

class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        print 'Preparing palette for each images...'

        for image in Image.objects.all():
            colors = image.colors.all()
            if image.dominant_color and len(colors) > 0:
                continue

            colors = modified_mediancut(image.path, 5)
            dominant_color = Color.get_nearest(*colors[0])
            image.dominant_color = dominant_color

            colors = modified_mediancut(image.path, 3)
            for c in colors:
                color = Color.get_nearest(*c)
                image.colors.add(color)

            image.save()
            

        print 'Done...'
                    
