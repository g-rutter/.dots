function make_docs
    make clean; rm -rf source/generated/*; make html;
    begin
        bash -c "cd build/html && python -m SimpleHTTPServer"
    end
end
