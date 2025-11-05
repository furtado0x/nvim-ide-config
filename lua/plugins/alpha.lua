return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        if vim.fn.argc() == 0 then  
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.startify")

            dashboard.section.header.val = {
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                     ]],
              [[       ████ ██████           █████      ██                     ]],
              [[      ███████████             █████                             ]],
              [[      █████████ ███████████████████ ███   ███████████   ]],
              [[     █████████  ███    █████████████ █████ ██████████████   ]],
              [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
              [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
              [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                       ]],
            }

            alpha.setup(dashboard.opts)
        end
    end,
}
