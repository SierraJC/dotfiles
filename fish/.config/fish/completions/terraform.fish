
function __complete_terraform
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    /Users/sierra/.tenv/Terraform/1.11.4/terraform
end
complete -f -c terraform -a "(__complete_terraform)"

