from ranger.api.commands import Command
class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf

    Support self.quantifier

    locate dir:
    Usage: fzf_select -d

    locate file:
    Usage: fzf_select -f
    """
    def execute(self):
        import subprocess
        import os.path
        command = "find"
        lastcommand = " | fzf +m --height 70% --layout=reverse --preview 'bat --style=numbers --color=always --line-range :500 {}'"
        if self.arg(1) == '-d':
            # match only directories
            command += ' -type d'
        elif self.arg(1) == '-f':
            # match only files
            command += ' -type f'

        # set depth
        if self.quantifier:
            command += f' -maxdepth {self.quantifier}'

        command += lastcommand
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
