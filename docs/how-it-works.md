---
title: How It Works
layout: default
nav_order: 2
---

# How It Works
{: .no_toc }

This document outlines how things work behind the scenes:

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Resourcesful Actions

First of all, what does Wallaby do exactly?
In short, **Rails defines the resourcesful actions, Wallaby implements them for you.**
For example, new model and controller are created as below:

```sh
$ rails generate model Article title:string text:text
$ rails generate controller Articles
```

As soon as you include the module `Wallaby::ResourcesConcern` for `ArticlesController`:

```ruby
class ArticlesController < ApplicationController
  include Wallaby::ResourcesConcern
end
```

You will have all the resourcesful actions working immediately without writing any boilerplate code even for the views.
Besides, Wallaby covers the other aspects including authentication, authorization and pagination.

Let's take a look at one of the resourcesful actions - `update` that Wallaby has implemented:

```ruby
def update(options = {}, &block)
  set_defaults_for :update, options
  current_authorizer.authorize :update, resource
  current_servicer.update resource, options.delete(:params)
  respond_with resource, options, &block
end
```

Basically, what it does is the same as the following boilerplate:

<a name="update-boilerplate"></a>

```ruby
def update
  @resource = Article.find params[:id]
  authorize @resource # Pundit
  @resource.update params.fetch(:article, {}).permit(:title, :text)
  respond_with @resource # Responder
end
```

The magic is that Wallaby detects what ORM model it's dealing with,
so that it uses the corresponding ORM **servicer** ([read more](???))
to handle the data access (e.g. `resource` object) and manipulation (e.g. its `update` method).
Wallaby also detects the authorization framework in use and
uses the **authorizer** ([read more](???)) to carry out the authorization check for the given resource.
Similarly, Wallaby uses **paginator** ([read more](???)) for `index` action to paginate the collection.

Although Wallaby currently only supports ActiveRecord together with CanCanCan and Pundit,
with the appropriate interfaces in place,
it can be easily extended to support other ORMs and authorization frameworks ([read more](???)).
And before that's possible, **Custom** mode will allow you to support non-ActiveRecord models  ([read more](???)).

## Decorator & Views

After controller action

## Admin Interface

## How Customization is Possible
