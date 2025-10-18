use zed_extension_api as zed;

struct TauExt;

impl zed::Extension for TauExt {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        id: &zed::LanguageServerId,
        _worktree: &zed::Worktree,
    ) -> zed::Result<zed::Command> {
        if id.as_ref() == "tau-lsp" {
            Ok(zed::Command {
                command: "/home/speedking/.local/bin/tau-lsp".into(), // or absolute path
                args: vec!["--stdio".into()],
                env: Default::default(),
            })
        } else {
            Err("unknown language server id".into())
        }
    }
}

zed::register_extension!(TauExt);
