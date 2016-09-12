package hostlib

import (
	"log"
	"net/url"
	"regexp"
	"strings"
	"unicode"

	"golang.org/x/net/idna"
)

var notIdnaHost = regexp.MustCompile("^[a-zA-Z:\\._0-9-]+$")

var allUrls = make(map[string]*url.URL)

//getURL returns *URL struct from rawURL. Adds new rawURL into allUrls or returns
//*URL from dict
func getURL(u string) *url.URL {
	dictURL, ok := allUrls[u]
	if !ok {
		urlParse, err := url.Parse(u)
		allUrls[u] = urlParse
		if err != nil {
			log.Fatal(err)
		}
		return urlParse
	}
	return dictURL
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

//RemoveWWW removes 'www' from url
func RemoveWWW(urls []string) []string {
	for i, u := range urls {
		if "www." == u[7:11] {
			urls = append(urls, strings.Replace(u, "www.", "", 1))
			if strings.Count(getURL(u).Host, ".") < 3 {
				urls[i] = urls[len(urls)-1]
				urls = urls[:len(urls)-1]
			}
		}
	}
	return urls
}

//domainOnlyURL returns only domain part
func domainOnlyURL(urls []string) map[string]struct{} {
	var onlyUniqueDomains = make(map[string]struct{}, len(urls))
	for _, rawURL := range urls {
		u := getURL(rawURL)
		if u.Path == "/" || u.Path == "" {
			if _, ok := onlyUniqueDomains[u.Host]; ok {
				continue
			}
			onlyUniqueDomains[u.Host] = struct{}{}
		}
	}
	return onlyUniqueDomains
}

//FullDomainReduce removes URI, that was fully blocked
func FullDomainReduce(urls []string) []string {
	var out = make(map[string]struct{}, len(urls))
	var outString = make([]string, 0, len(urls))
	domains := domainOnlyURL(urls)
	for _, rawURL := range urls {
		out[rawURL] = struct{}{}
	}
	for _, rawURL := range urls {
		host := getURL(rawURL).Host
		if _, ok := domains[host]; ok && rawURL != "http://"+host {
			//delete(allUrls, rawURL)
			delete(out, rawURL)
			out["http://"+host] = struct{}{}
		}
	}
	for urls := range out {
		outString = append(outString, urls)
	}
	return outString
}

//Fqdn removes dot from uri
func Fqdn(urls []string) []string {
	out := urls[:0]
	for _, u := range urls {
		host := getURL(u).Host
		if strings.HasSuffix(host, ".") {
			out = append(out, strings.Replace(u, host, strings.TrimSuffix(host, "."), 1))
		} else {
			out = append(out, u)
		}
	}
	return out
}

//IDNA encodes kirillic uri
func IDNA(urls []string) []string {
	out := urls[:0]
	var idnaHosts []string
	for _, url := range urls {
		host := getURL(url).Host
		if notIdnaHost.MatchString(host) {
			out = append(out, url)
			continue
		}
		hostToIdna, err := idna.ToASCII(host)
		if err != nil {
			log.Fatal(err)
		}
		idnaHosts = append(idnaHosts, strings.Replace(url, host, hostToIdna, 1))
	}
	out = append(out[:], idnaHosts[:]...)
	return out
}

//GetQuestionRemove removes "?" from GET
func GetQuestionRemove(urls []string) []string {
	return nil
}
