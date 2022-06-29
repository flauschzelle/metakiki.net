class Thumbnailizesvg < Nanoc::Filter
    identifier :thumbnailizesvg
    type       :binary

    def run(filename, params={})
		`inkscape "#{filename}" --export-type=png -o - -w #{params[:width].to_s} > "#{output_filename}"`
    end
end
