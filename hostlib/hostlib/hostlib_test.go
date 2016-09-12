package hostlib

import (
	"sort"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

type Tests struct {
	input string
	want  string
}

func TestPickGet(t *testing.T) {
	tests := []*Tests{
		{"http://testing.ru", ""},
		{"http://багофичи.рф/гет-запрос", "/гет-запрос"},
		{"http://request.good/request_good", "/request_good"},
		{"http://request.good?request_bad", "?request_bad"},
	}
	for _, test := range tests {
		get := getURL(test.input).Path
		if get == "" {
			get = strings.Trim(getURL(test.input).RequestURI(), "/")
		}
		assert.Equal(t, test.want, get)
	}
}
func TestHost(t *testing.T) {
	tests := []*Tests{
		{"http://testing.ru", "testing.ru"},
		{"http://багофичи.рф/гет-запрос", "багофичи.рф"},
		{"http://testing.ru?request", "testing.ru"},
	}
	for _, test := range tests {
		host := getURL(test.input).Host
		assert.Equal(t, test.want, host)
	}
}

func TestValidHTTPOnly(t *testing.T) {
	input := []string{
		"http://normal.url",
		"https://normal.url",
		"https://bad.url",
		"http://normal2.url",
		"# comment",
		"http://"}
	expected := []string{
		"http://normal.url",
		"http://normal2.url",
	}
	assert.Equal(t, ValidHTTPOnly(input), expected)
}

func TestLower(t *testing.T) {
	input := []string{
		"http://norm.url",
		"http://UPPER.URL",
		"http://Mixed.Url",
		"http://norm.url/get",
		"http://UPPER.URL/UPPER.GET",
		"http://UPPER.URL/lower.get",
		"http://КИРИЛЛИЧЕСКИЙ.РФ",
		"http://КИРИЛЛИЧЕСКИЙ.РФ?zaproS",
	}
	expected := []string{
		"http://norm.url",
		"http://UPPER.URL",
		"http://upper.url",
		"http://Mixed.Url",
		"http://mixed.url",
		"http://norm.url/get",
		"http://UPPER.URL/UPPER.GET",
		"http://upper.url/UPPER.GET",
		"http://UPPER.URL/lower.get",
		"http://upper.url/lower.get",
		"http://КИРИЛЛИЧЕСКИЙ.РФ",
		"http://кириллический.рф",
		"http://КИРИЛЛИЧЕСКИЙ.РФ?zaproS",
		"http://кириллический.рф?zaproS",
	}
	for _, u := range Lower(input) {
		assert.Contains(t, expected, u)
	}
}

func TestDomainChange(t *testing.T) {
	input := []string{
		"http://vk.com/cybergetrequest",
		"http://vkontakte.ru/cyberget",
		"http://normal.url/cyberget",
		"http://normal.url/vk.com/lol",
	}
	expected := []string{
		"http://vk.com/cybergetrequest",
		"http://vkontakte.ru/cybergetrequest",
		"http://vkontakte.ru/cyberget",
		"http://vk.com/cyberget",
		"http://normal.url/cyberget",
		"http://normal.url/vk.com/lol",
	}
	for _, u := range DomainChange(input) {
		assert.Contains(t, expected, u)
	}
}

func TestWWW(t *testing.T) {
	input := []string{
		"http://normal.url",
		"http://both.url",
		"http://www.both.url",
		"http://www.only.url",
		"http://www.much.items.url.blin/request",
	}
	expected := []string{
		"http://normal.url",
		"http://both.url",
		"http://only.url",
		"http://www.much.items.url.blin/request",
		"http://much.items.url.blin/request",
	}
	for _, u := range RemoveWWW(input) {
		assert.Contains(t, expected, u)
	}
}

func TestDomainOnlyURL(t *testing.T) {
	input := []string{
		"http://domain.ru/kek/",
		"http://domain.ru/kek/lol",
		"http://slash.no",
		"http://slash.yes",
		"http://slash.yes/",
		"http://slash.only/",
	}
	expected := []string{
		"slash.no",
		"slash.only",
		"slash.yes",
	}
	var actual []string
	for host := range domainOnlyURL(input) {
		actual = append(actual, host)
	}
	sort.Strings(actual)
	assert.Equal(t, expected, actual)
}

func TestFullDomainReduce(t *testing.T) {
	input := []string{
		"http://domain.ru/",
		"http://domain.ru/kek/",
		"http://domain.ru/kek/lol",
		"http://slash.no",
		"http://slash.yes",
		"http://slash.yes/",
		"http://just.url/kek/lol",
	}
	expected := []string{
		"http://domain.ru",
		"http://just.url/kek/lol",
		"http://slash.no",
		"http://slash.yes",
	}
	var actual []string
	actual = FullDomainReduce(input)
	sort.Strings(actual)
	assert.Equal(t, expected, actual)
}

func TestFqdn(t *testing.T) {
	input := []string{
		"http://norm.url",
		"http://norm.url.",
		"http://fqdn.url.",
		"http://norm.url/get_request",
		"http://fqdn.url./get_request",
		"http://norm.url?bad_request",
		"http://fqdn.url?bad_request",
	}
	expected := []string{
		"http://norm.url",
		"http://norm.url",
		"http://fqdn.url",
		"http://norm.url/get_request",
		"http://fqdn.url/get_request",
		"http://norm.url?bad_request",
		"http://fqdn.url?bad_request",
	}
	assert.Equal(t, expected, Fqdn(input))
}

func TestIDNA(t *testing.T) {
	input := []string{
		"http://normal.url",
		"http://кириллица.рф",
		"http://кириллица.рф/just-request",
		"http://combined.рф",
		"http://with.request/кириллический-запрос",
	}
	expected := []string{
		"http://normal.url",
		"http://with.request/кириллический-запрос",
		"http://xn--80apaahia1b8c.xn--p1ai",
		"http://xn--80apaahia1b8c.xn--p1ai/just-request",
		"http://combined.xn--p1ai",
	}
	assert.Equal(t, expected, IDNA(input))
}
