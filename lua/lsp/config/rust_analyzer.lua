-- lua/lsp/config/rust_analyzer.lua
-- Rust Analyzer LSP configuration

return {
  settings = {
    ["rust-analyzer"] = {
      -- Enable all features
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      -- Configure procMacro
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
      -- Checkons
      checkOnSave = {
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      -- Experimental features
      experimental = {
        procAttrMacros = true,
      },
      -- Diagnostics
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
      },
      -- Inlay hints
      inlayHints = {
        bindingModeHints = {
          enable = true,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 10,
        },
        closureReturnTypeHints = {
          enable = "always",
        },
        lifetimeElisionHints = {
          enable = "always",
          useParameterNames = true,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "always",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
      -- Lens 
      lens = {
        enable = true,
        debug = {
          enable = false,
        },
        forceCustomCommands = true,
        implementations = {
          enable = true,
        },
        run = {
          enable = true,
        },
        references = {
          adt = {
            enable = true,
          },
          enumVariant = {
            enable = true,
          },
          method = {
            enable = true,
          },
          trait = {
            enable = true,
          },
        },
      },
      -- Enable hover actions
      hoverActions = {
        enable = true,
        debug = {
          enable = false,
        },
        gotoTypeDef = {
          enable = true,
        },
        implementations = {
          enable = true,
        },
        references = {
          enable = true,
        },
        run = {
          enable = true,
        },
      },
      -- Completion settings
      completion = {
        autoimport = {
          enable = true,
        },
        autoself = {
          enable = true,
        },
        callable = {
          snippets = "fill_arguments",
        },
        fullFunctionSignatures = {
          enable = true,
        },
        postfix = {
          enable = true,
        },
        privateEditable = {
          enable = false,
        },
        snippets = {
          custom = {
            ["Arc::new"] = {
              postfix = "arc",
              body = "Arc::new(${receiver})",
              requires = "std::sync::Arc",
              description = "Put the expression into an `Arc`",
              scope = "expr",
            },
            ["Rc::new"] = {
              postfix = "rc",
              body = "Rc::new(${receiver})",
              requires = "std::rc::Rc",
              description = "Put the expression into an `Rc`",
              scope = "expr",
            },
            ["Box::new"] = {
              postfix = "box",
              body = "Box::new(${receiver})",
              requires = "std::boxed::Box",
              description = "Put the expression into a `Box`",
              scope = "expr",
            },
            ["Ok"] = {
              postfix = "ok",
              body = "Ok(${receiver})",
              description = "Wrap the expression in a `Result::Ok`",
              scope = "expr",
            },
            ["Err"] = {
              postfix = "err",
              body = "Err(${receiver})",
              description = "Wrap the expression in a `Result::Err`",
              scope = "expr",
            },
            ["Some"] = {
              postfix = "some",
              body = "Some(${receiver})",
              description = "Wrap the expression in an `Option::Some`",
              scope = "expr",
            },
          },
        },
      },
      -- Assist configuration
      assist = {
        importEnforceGranularity = true,
        importGranularity = "module",
        importPrefix = "plain",
      },
      -- Misc settings
      rustfmt = {
        rangeFormatting = {
          enable = true,
        },
      },
      semanticHighlighting = {
        operator = {
          specialization = {
            enable = true,
          },
        },
        punctuation = {
          enable = true,
          separate = {
            macro = {
              bang = true,
            },
          },
          specialization = {
            enable = true,
          },
        },
      },
    },
  },
}
