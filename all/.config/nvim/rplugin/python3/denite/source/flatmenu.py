from pynvim import Nvim
import typing

from denite.base.source import Base
from denite.util import UserContext, Candidates

GREP_HEADER_SYNTAX = (
    'syntax match deniteSource_flatmenuHeader '
    r'=\<\w\+ \/= '
    'contained')

class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'flatmenu'
        self.kind = 'command'
        self.vars = {
                'menus': {}
        }

    def on_init(self, context):
        pass

    def define_syntax(self):
        self.vim.command(
            'syntax region ' + self.syntax_name + ' start=// end=/$/ '
            'contains=deniteSource_flatmenuHeader contained')

    def highlight(self) -> None:
        self.vim.command(GREP_HEADER_SYNTAX)
        self.vim.command('hi link deniteSource_flatmenuHeader Macro')

    def gather_candidates(self, context):
        if 'menus' not in self.vars or self.vars['menus'] == {}:
            return []

        lines = []
        menus = self.vars['menus']
        args = context['args']
        for cat, cand in menus.items():
            for it in cand:
                name, cmd = it
                lines.append({
                        'word': '{} /  {}'.format(cat, name),
                        'kind': 'command',
                        'action__command': cmd 
                     })

        return lines
