use zed_extension_api as zed;

struct TauExt;

impl zed::Extension for TauExt {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> zed::Result<zed::Command> {
        if id.as_ref() != "tau-lsp" {
            return Err("unknown language server id".into());
        }

        // On the PATH first, which is where make install puts it, and then
        // where that install would have put it, in case Zed was started
        // without the user's PATH: a desktop launcher usually is.
        let command = worktree
            .which("tau-lsp")
            .or_else(|| {
                let home = std::env::var("HOME").ok()?;
                let path = format!("{home}/.local/bin/tau-lsp");
                std::path::Path::new(&path).exists().then_some(path)
            })
            .ok_or("tau-lsp not found: build it with `make tau-lsp` and put it on the PATH")?;

        // It speaks LSP over stdin and stdout and takes no argument for it.
        Ok(zed::Command {
            command,
            args: vec![],
            env: Default::default(),
        })
    }
}

zed::register_extension!(TauExt);
