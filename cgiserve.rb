require 'filemagic'

class CGIServe
    def initialize(root_path)
        @root_path = root_path
        @fm = FileMagic.open(:mime)
        @custom_env = {
            'DOCUMENT_ROOT' => File.expand_path(root_path)
        }
    end

    def call(env)
        filtered_env = ENV.to_h.merge(env.select{|k, v| !k.start_with?('rack.') && v.is_a?(String)}.merge(@custom_env))
        handle = nil
        headers = {}
        status = 200
        begin
            file = File.join(@root_path, env['REQUEST_PATH'])
            if File.exists?(file)
                stat = File::Stat.new(file)
                if stat.executable?
                    handle = IO.popen(filtered_env, file, 'r+')
                    loop do
                        line = handle.gets
                        raise 'Unexpected EOF while reading from external process' unless line
                        line.chomp!
                        break if line.empty?
                        key, value = line.split(':', 2)
                        raise "Line '#{line}' does not split into key and value" unless key and value
                        value.gsub!(/^("?)(.*)\1$/, $2)
                        if key.downcase == 'status'
                            status = value.split(' ').first.to_i
                        else
                            headers[key] = value
                        end
                    end
                    File.copy_stream(env['rack.input'], handle)
                    handle.close_write
                else
                    # Not executable
                    headers['Content-Type'] = @fm.file(file)
                    headers['Content-Length'] = stat.size.to_s if stat.size?
                    handle = File.open(file)
                end
            else
                status = 404
                handle = ['404 Not Found']
                headers = {'Content-Type' => 'text/plain'}
            end
        rescue => e
            status = 500
            headers = {'Content-Type' => 'text/plain'}
            handle = ["Error: #{e.message}\n", e.backtrace.map{|l| "    #{l}"}.join("\n")]
        end
        [status, headers, handle]
    end
end
