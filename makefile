name = ~/papers/2026-geom-emp/src_methods_paper
slides = 

all: $(shell perl hdeps.pl index.html)

ifdef slides
$(foreach idx,$(shell seq 1 $(words $(slides))), $(eval static/figures/$(word $(idx),$(slides)).pdf: build/slide$(idx).pdf))

$(foreach idx,$(shell seq 1 $(words $(slides))),%/slide$(idx).pdf): figures.key | build static/figures
	keysplit --crop $< $*
endif

slides: $(foreach fig,$(slides),static/figures/$(fig).pdf)

$(foreach fig,$(slides),static/figures/$(fig).pdf):
	cp $< $@

static/%.svg: static/%.pdf
	pdf2svg $< $@

static/%.png: static/%.pdf
	pdf2png $< $@

static/videos/%.png: static/videos/%.mp4
	ffmpeg -i $< -ss 00:00:01 -vframes 1 $@

static/%.png: static/%.pdf
	pdf2png $< $@

static/figures/%: $(name)/figures/%
	cp $< $@

static/figures/%: $(name)/../figures/%
	cp $< $@

static/figures/%: $(name)/figures/%
	mkdir -p $(@D)
	cp $< $@

static/figures/%: $(name)/theory_final_figs/%
	cp $< $@

static/pdf/%: $(name)/../dist/%
	cp $< $@

build:
	mkdir -p $@

clean:
	rm -rf build
