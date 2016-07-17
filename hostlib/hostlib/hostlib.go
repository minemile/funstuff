package hostlib

import (
	"fmt"
	"net/url"
	"strings"
	"unicode"
)

var allUrls = make(map[string]*url.URL)

func getURL(u string) *url.URL {
	strings.ToLower(u)
	url, ok := allUrls[u]
	if !ok {
		urlParse, err := url.Parse(u)
		allUrls[u] = urlParse
		if err != nil {
			panic(err)
		}
		return urlParse
	}
	return url
}

//ValidHTTPOnly removes https domains
func ValidHTTPOnly(urls []string) []string {
	out := urls[:0]
	for _, u := range urls {
		if strings.HasPrefix(u, "http://") && strings.Contains(u, ".") {
			out = append(out, u)
		}
	}
	return out
}

//Lower adds domains in lowercase
func Lower(urls []string) []string {
	for _, u := range urls {
		for _, c := range u {
			if unicode.IsUpper(c) {
				url := getURL(u)
				lowerHost := strings.Replace(u, url.Host, strings.ToLower(url.Host), 1)
				urls = append(urls, lowerHost)
				break
			}
		}
	}
	return urls
}

//DomainChange dublicates vk.com <=> vkontakte.ru
func DomainChange(urls []string) []string {
	replaces := map[string]string{"vk.com": "vkontakte.ru", "vkontakte.ru": "vk.com"}
	for _, u := range urls {
		for key, value := range replaces {
			if strings.Contains(u, key) && key == getURL(u).Host {
				urls = append(urls, strings.Replace(u, key, value, 1))
			}
		}
	}
	return urls
}

//RemoveWWW removes useless 'www' from url
func RemoveWWW(urls []string) []string {
	for i, u := range urls {
		if "www." == u[7:11] {
			fmt.Println(u)
			urls = append(urls, strings.Replace(u, "www.", "", 1))
			if strings.Count(getURL(u).Host, ".") < 3 {
				urls[i] = urls[len(urls)-1]
				urls = urls[:len(urls)-1]
			}
		}
	}
	return urls
}
