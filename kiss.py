from typing import List
from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: List[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    w = boss.active_window
    if w is not None:
        boss.call_remote_control(w, ('launch', '--type=overlay', 'kiss.sh'))
