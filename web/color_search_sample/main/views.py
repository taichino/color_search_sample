# -*- coding: utf-8 -*-

import json
from django.conf import settings
from django.http import HttpResponse

from main.models import Image, Color

def mono_color(request):
    catalog = []

    R = int(request.GET.get('R', -1))
    G = int(request.GET.get('G', -1))
    B = int(request.GET.get('B', -1))

    target_color = Color.get_nearest(R, G, B)
    print target_color
    for image in Image.objects.filter(colors = target_color)[:10]:
        props = {
            'path': image.path,
            'width': image.width,
            'height': image.height
            }
        catalog.append(props)
    
    return HttpResponse(json.dumps(catalog), mimetype='application/json')
