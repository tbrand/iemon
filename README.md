<p align="center">
  Iemon (伊右衛門)
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/3483230/42362737-99827998-812f-11e8-93c3-b149355a07f1.png" width="200" />
</p>

<p align="center">
  <i>Awesome shared object in multiple processes</i>
</p>

```crystal
my_object = MyObj.new(x: 1)

fork do
  my_object.x = 2
end

sleep 0.1

puts my_object.x
#=> 2
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  iemon:
    github: tbrand/iemon
```

## Usage

```crystal
require "iemon"
```

Define your object which inherits `Iemon::Object`.
Iemon manages shared properties. You can define it by using `assigns` method.
```crystal
class MyObj < Iemon::Object
  assigns(x: Int32)
end
```

Then `x` of `MyObj` will be shared between multiple processes.
So below code will work correctly.
```crystal
my_obj = MyObj.new(x: 1)

fork do
  my_obj.x = 2
end

sleep 0.1 # wait a little for a forked process

puts my_obj.x
#=> 2
```

Call `Iemon::Object#clean` once if you don't need to share the properties of the object anymore.
Otherwise the shared memory remains even if the execution is finished.
```crystal
my_obj.clean
```

If you forget to do that, you can clean all of them by
```
crystal lib/iemon/tools/clean.cr
```

## Development

The project is still under the work in progress.

Any contributions are welcome! :tada:

## Contributing

1. Fork it (<https://github.com/tbrand/iemon/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
