class Thumbnailizesvg < Nanoc::Filter
    identifier :thumbnailizesvg
    type       :binary

    def run(filename, params={})
		system(
			'inkscape',
			 '-f', 
			filename, 
			'-e',
 			output_filename, 
			'-w', 
			params[:width].to_s
		)
    end
end
