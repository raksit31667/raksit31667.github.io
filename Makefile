# Serve the site locally
# Usage: make serve
.PHONY: serve
serve:
	bundle exec jekyll serve --drafts

# Create a new file under _drafts directory with the given title and commit to git
# Usage: make draft title="my-new-draft-title"
DATE := $(shell date +%Y-%m-%d)

.PHONY: draft
draft: check-title
	@echo "Creating a new draft with title: $(title)"
	@echo "---\nlayout: post\ntitle: \"$(title)\"\ndate: $(DATE)\ntags: []\n---" > _drafts/$(title).markdown
	@echo "Draft created at _drafts/$(title).markdown"
	@echo "Adding the draft to git"
	git add _drafts/$(title).markdown
	git commit -m "create a new draft $(title)"

# Finish the draft with the given title and commit to git
# Usage: make finish title="my-new-draft-title"
.PHONY: finish
finish: check-title
	@echo "Finishing the draft with title: $(title)"
	@echo "Adding the draft to git"
	git add _drafts/$(title).markdown
	git add assets
	git commit -m "finish drafting $(title)"

# Publish the draft with the given title
# Usage: make publish title="my-new-draft-title"
# This will move the draft to _posts directory with the current date and commit to git
.PHONY: publish
publish: check-title
	@echo "Publishing the draft with title: $(title)"
	@mv _drafts/$(title).markdown _posts/$(DATE)-$(title).markdown
	@echo "Draft published at _posts/$(DATE)-$(title).markdown"
	@echo "Adding the draft to git"
	git add _drafts/$(title).markdown
	git add _posts/$(DATE)-$(title).markdown
	git commit -m "publish $(title)"

.PHONY: check-title
check-title:
	@if [ -z "$(title)" ]; then \
		echo "Please provide a title for the draft"; \
		exit 1; \
	fi