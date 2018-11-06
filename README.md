# ServiceObjecter

[![Build Status](https://travis-ci.com/tier-tools/service_objecter.svg?branch=master)](https://travis-ci.com/tier-tools/service_objecter)

## Description

Simple module, to tidy service objects.

You can read our guide how we think service objects should works [The best service object (for us)](https://github.com/tier-tools/service_objecter/wiki/The-best-service-object-(for-us))

## Usage

### Always call service object in one way, ex. by `call` method.

```ruby
class Service
  def call
    puts 'hello'
  end
end

Service.new.call
```

To simplify this ServiceObjecter provides some shortcuts

```ruby
class Service
  include ServiceObjecter
  def call
    puts 'hello'
  end
end

Service.call
```

### Returns result object as Result struct object

```ruby
class Service
  include ServiceObjecter

  def call
    puts 'hello'
    success('some value')
  end
end

service = Service.call
service.success? #=> true
service.failure? #=> false
service.value #=> 'some value'
```

With ServiceObjecter You can end call in many ways

```ruby
success(:optional_value)
failed(:optional_value)
Result.new(
  true, #=> success?
  'optional_value'
)
```

## Full example


```ruby
class Service
  include ServiceObjecter

  def call(params) #=> instead of passing params to #new, do it in #call
    a = params[:a]
    # do something important
    Result.new(true, a)# return result object
  end
end

params = {a: 1}
service = Service.call(params)

if service.success?
  puts service.value
end
```

## ChainIt integration

Install `ChainIt` to get more power of service objects.
Read more [ChainIt gem](https://github.com/tier-tools/ChainIt)
With `ServiceObjecter` you get shortcuts.

```ruby
class Service
  include ServiceObjecter

  def call(params)
    chain { some method }
    chain { other method }
    result
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tier-tools/service_objecter.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
