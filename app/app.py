# En tu app principal (tu_app.py)
import reflex as rx

class CounterState(rx.State):
    count: int = 0
    
    def increment(self):
        print(f"Backend funcionando! Count: {self.count}")  # Log para debug
        self.count += 1
        
    def decrement(self):
        print(f"Backend funcionando! Count: {self.count}")  # Log para debug
        self.count -= 1

def index():
    return rx.center(
        rx.vstack(
            rx.heading("Contador", size="9"),
            rx.heading(CounterState.count, size="7"),
            rx.hstack(
                rx.button("Incrementar", on_click=CounterState.increment),
                rx.button("Decrementar", on_click=CounterState.decrement),
            ),
            spacing="4",
        ),
        height="100vh",
    )

app = rx.App()
app.add_page(index)

