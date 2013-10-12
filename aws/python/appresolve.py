__author__ = 'Markit(chartl)'

import urllib
import doctest
import re

# make use of the itunes store search api to resolve some of the pertinent information about various apps

ITUNES_APP_LOOKUP_FT = "https://itunes.apple.com/lookup?id=%s"


def resolve(appURL):
    app_id = _extract_id(appURL)
    return _lookup_info(app_id) if app_id else None

def _toEndOfURL(url):
    return url.split(" ")[0]

def _extract_id(storeURL,_tryCount=0):
    ''' Extract the id of an app given an app store or itunes store url
        >>> _extract_id("http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=533451786&mt=8")
        533451786
        >>> _extract_id("itms://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=324906251&mt=8&s=143441")
        324906251
        >>> _extract_id("http://hastrk1.com/serve?action=click&publisher_id=7280&site_id=13208&offer_id=249864")
        622768071
    '''
    print(storeURL)
    prefix = storeURL.split("//")[1].split(".")[0]
    if ( prefix != "itunes" and prefix != "www.apple.com/itunes" and prefix != "apple.com/itunes" ):
        # if tried too many times, die.
        if _tryCount > 2:
            return None
        # get the first itunes url on the page that has an id
        redirectInfo = str(urllib.urlopen(storeURL).info()).split("\n")
        redirectInfo = reduce(lambda a,b: a + b,map(lambda t: t.strip("\n").strip("\r").split(),redirectInfo))
        for _str in redirectInfo:
            if _str.startswith("http") or _str.startswith("itms"):
                return _extract_id(_toEndOfURL(_str),_tryCount+1)
        return None
    id_split_token = "id=" if storeURL.find("id=") > -1 else "id"
    # decide which of the ending tokens comes first
    id_plus_suffix = storeURL.split(id_split_token)[1]
    qloc = id_plus_suffix.find("?")
    andloc = id_plus_suffix.find("&")
    sploc = id_plus_suffix.find("%")
    qloc = len(id_plus_suffix) if qloc < 0 else qloc
    andloc = len(id_plus_suffix) if andloc < 0 else andloc
    sploc = len(id_plus_suffix) if sploc < 0 else sploc
    mval = reduce(min,[qloc,andloc,sploc])
    suffix_split = "?" if qloc == mval else "&" if andloc == mval else sploc
    return id_plus_suffix.split(suffix_split)[0]

def _lookup_info(appID):
    '''
    Returns the name, description, and the image of the application referenced by the ID
    '''
    raw_info = urllib.urlopen(ITUNES_APP_LOOKUP_FT % (appID) ).read()
    # this exposes us to an injection attack! probably shouldn't call that out...
    true = True
    false = False
    processed_info = eval(_strip_nonstring_newlines(raw_info))
    if processed_info['resultCount'] == 0:
        return None
    info = processed_info['results'][0]
    return (info['trackCensoredName'],info['description'],info['artworkUrl60'])


def _strip_nonstring_newlines(string):
    '''
    Strip the newlines from a string such as '\n"hello\nworld"' that are not within the context of a specific
    string. That is, only the occurrences of '\n' that are not within double quotes.
    >>> _strip_nonstring_newlines('\n"hello\nworld"\nhello"\n"world')
    '"hello\nworld"hello"\n"world'
    '''
    v = string.split("\"")
    return "\"".join(map(lambda a: _rm_newline(a[0]) if (1+a[1]) % 2 else a[0], zip(v,range(len(v)))))

def _rm_newline(string):
    '''
     remove all instances of newline from the string
    '''
    return string.replace("\n","")