package hostlib

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

type Tests struct {
	input string
	want  string
}

func TestHost(t *testing.T) {
	tests := []*Tests{
		{"http://testing.ru", "testing.ru"},
		{"http://багофичи.рф/гет-запрос", "багофичи.рф"},
		{"http://testing.ru?request", "testing.ru"},
	}
	for _, test := range tests {
		hostName := getURL(test.input).Host
		assert.Equal(t, hostName, test.want)
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
