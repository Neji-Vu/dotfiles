function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

if status is-interactive
    # Commands to run in interactive sessions can go here
end
alias vim="nvim"
