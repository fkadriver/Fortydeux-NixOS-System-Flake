{ config, pkgs, inputs, username, ... }:

{
  home.packages = (with pkgs; [
    appflowy #An open-source alternative to Notion - now with AI drafting features
    code-cursor #AI-powered code editor built on vscode
    tenere #Rust-based TUI for interacting with LLM
    warp-terminal #Modern rust-based terminal       
    waveterm  #Paneled Terminal, File-Manager w/ Preview, AI chat, and Webviewer
    windsurf #Agentic IDE powered by AI Flow paradigm
    zed-editor #Modern text editor with AI built in - still in development for Linux
  ]);
}
