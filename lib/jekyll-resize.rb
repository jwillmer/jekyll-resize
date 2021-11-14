require "digest"
require "mini_magick"

module Jekyll
  module Resize
    CACHE_DIR = "cache/resize/"
    OUT_FORMAT = "webp"
    FILE_EXT = ".webp"
    HASH_LENGTH = 32

    # Read, process, and write out as new image.
    def _process_img(src_path, options, dest_path)
      image = MiniMagick::Image.open(src_path)

      image.strip
      image.resize options
      image.format OUT_FORMAT

      image.write dest_path
    end

    # Generate output image filename.
    #
    # e.g. '7f1f9026239...821410_800x800.jpg'
    def _dest_filename(src_path, dest_dir, options)
      hash = Digest::SHA256.file(src_path)
      short_hash = hash.hexdigest()[0, HASH_LENGTH]
      options_slug = options.gsub(/[^\da-z]+/i, '')

      "#{short_hash}_#{options_slug}#{FILE_EXT}"
    end

    # Liquid tag entry-point.
    #
    # param source: e.g. "my-image.jpg"
    # param options: e.g. "800x800>"
    #
    # return dest_path_rel: Relative path for output file.
    def resize(source, options)
      raise "`source` may not be empty" unless source.length > 0
      raise "`options` may not be empty" unless options.length > 0

      site = @context.registers[:site]

      src_path = File.join(site.source, source)
      raise "Image at #{src_path} is not readable" unless File.readable?(src_path)

      dest_dir = File.join(site.source, CACHE_DIR)
      FileUtils.mkdir_p dest_dir

      dest_filename = _dest_filename(src_path, dest_dir, options)

      dest_path = File.join(dest_dir, dest_filename)
      dest_path_rel = File.join(CACHE_DIR, dest_filename)

      if !File.exist?(dest_path) || File.mtime(dest_path) <= File.mtime(src_path)
        puts "Resizing '#{source}' to '#{dest_path_rel}' - using options: '#{options}'"

        _process_img(src_path, options, dest_path)

        site.static_files << Jekyll::StaticFile.new(site, site.source, CACHE_DIR, dest_filename)
      end

      dest_path_rel
    end
  end
end

Liquid::Template.register_filter(Jekyll::Resize)
