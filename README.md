[![Gem Version](https://badge.fury.io/rb/vimeo_upload.svg)](https://badge.fury.io/rb/vimeo_upload)

[Github](https://github.com/sajinmp/vimeo_upload)

# VimeoUpload

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/vimeo_upload`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vimeo_upload'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vimeo_upload

## Usage

Require the gem

```ruby
require 'vimeo_upload'
```

## Uploading a video

```ruby
VimeoUpload.upload('absolute_filepath', 'filename', 'api_key')
```

    eg: VimeoUpload.upload("#{Rails.root}/public/uploads/video.webm", 'My Video', ENV['api_key'])

## Changing video title

```ruby
VimeoUpload.change_title('filename', 'video_id', 'api_key')
```

    eg: VimeoUpload.upload("'My Video', '123456789', ENV['api_key'])")

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sajinmp/vimeo_upload.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

