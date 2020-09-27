---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
menu_title: Home
menu_order: 1
list_title: Recent from the blog
---


<div class="section dark " style="background-image: url('{{ "/assets/images/coding_with_love_since_2004_1440x600px.jpeg" | relative_url }}'); padding: 300px 0; margin-top: -80px; background-position: right center; background-size: cover">
</div>


{%- if site.posts.size > 0 -%}
<div id="section-blog" class="page-section">
        <h2 class="text-center text-uppercase font-weight-light ls3 font-body">
		{{ page.list_title | default: "Posts" }} 
        </h2>
</div>

<div class="section mb-0">
	<div class="container clearfix">
		<div class="row posts-md mt-5 col-mb-50 mb-0">
			{% assign posts = site.posts | slice:0, site.tiles_count %}
			{%- for post in posts -%}
			<div class="entry col-md-6">
				<div class="grid-inner row align-items-center">
					<div class="col-lg-6">
						<div class="entry-image">
							<a href="{{ post.url | relative_url }}">
								{% if post.cover_image %}
								
								{% assign cover_image_path = "assets/images/" | append: post.cover_image %}
								{% responsive_image_block %}
									path: {{ cover_image_path }}
									alt: {{ post.cover_image_alt | default: post.title }}
									template: "_includes/srcset_grid_image_template.html"

								{% endresponsive_image_block %}    

								{% else %}

								<img src="{{ post.share_image | default: site.canvas.default_share_image }}" alt="{{ post.cover_image_alt | default: post.title }}">

								{% endif %}
							</a>
						</div>
					</div>
					<div class="col-lg-6 mt-3 mt-lg-0">
						<span class="before-heading font-normal">{{ post.categories }}</span>
						<div class="entry-title nott">
							<h3 class="font-weight-normal"><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
						</div>
						<div class="entry-content">
							<a href="{{ post.url | relative_url }}" class="more-link">Read more <i class="icon-angle-right"></i></a>
						</div>
					</div>
				</div>
			</div>
			{%- endfor -%}
		</div>
	</div>
</div>

{%- endif -%}
