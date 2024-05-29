vim.filetype.add {
    pattern = {
        [ '.*' ] = {
            priority = math.huge,
            function(path, bufnr)
                local line1 = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
                local line2 = vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1] or ""

                if string.match(line1, "AWS:TemplateFormatVersion") or string.match(line1, "AWS::Serverless-2016-10-31") then
                    return 'yaml.cloudformation'
                elseif string.match(line1, "AWS:TemplateFormatVersion")
                    or string.match(line2, "AWS:TemplateFormatVersion")
                    or string.match(line1, "AWS::Serverless-2016-10-31")
                    or string.match(line2, "AWS::Serverless-2016-10-31")
                then
                    return 'json.cloudformation'
                end
            end,
        },
    },
}

