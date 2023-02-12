import flet
from flet import Control, IconButton, Page, Row, TextField, icons


def plus_minus(page: Page) -> Control:
    txt_number = TextField(
        value="0",
        text_align="right",
        width=100,
    )

    def minux_click(e):
        txt_number.value = int(txt_number.value) - 1
        page.update()

    def plus_click(e):
        txt_number.value = int(txt_number.value) + 1
        page.update()

    return Row(
        controls=[
            IconButton(icons.REMOVE, on_click=minux_click),
            txt_number,
            IconButton(icons.ADD, on_click=plus_click),
        ],
        alignment="center",
    )


def main(page: Page):
    page.title = "My first flet"
    page.vertical_alignment = "center"

    pm = plus_minus(page=page)

    page.add(pm)


if __name__ == "__main__":
    flet.app(
        target=main,
        port=8550,
        view=flet.WEB_BROWSER,
    )
