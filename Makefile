version = $(shell poetry version -s)

python_sources = $(wildcard streamlit_url_fragments/*.py) pyproject.toml MANIFEST.in
js_sources := $(wildcard streamlit_url_fragments/public/*) $(wildcard streamlit_url_fragment/src/*) streamlit_url_fragment/tsconfig.json
js_npm_install_marker = streamlit_url_fragments/node_modules/.package-lock.json

build: js sdist wheels

sdist: dist/streamlit-url-fragments-$(version).tar.gz
wheels: dist/streamlit_url_fragments-$(version)-py3-none-any.whl

js: streamlit_url_fragments/build/index.html

dist/streamlit-url-fragments-$(version).tar.gz: $(python_sources) js
	poetry build -f sdist

dist/streamlit_url_fragments-$(version)-py3-none-any.whl: $(python_sources) js
	poetry build -f wheel

streamlit_url_fragments/build/index.html: $(js_sources) $(js_npm_install_marker)
	cd streamlit_url_fragment && npm run build

$(js_npm_install_marker): streamlit_url_fragments/package-lock.json
	cd streamlit_url_fragment && npm install

clean:
	-rm -r -f dist/* streamlit_url_fragments/build/*
