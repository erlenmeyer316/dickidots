from ranger.colorschemes.default import Default
from ranger.gui.color import green, yellow, red, black, bold

class Scheme(Default):
    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.in_browser and context.directory:
            fg, attr = green, bold

        if context.in_browser and context.selected:
            fg, bg, attr = black, green, bold

        if context.in_browser and context.marked:
            fg, attr = yellow, bold

        if context.error:
            fg, attr = red, bold

        return fg, bg, attr

