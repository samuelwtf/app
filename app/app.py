import reflex as rx

# ---------- State ----------
class RegisterState(rx.State):
    name: str = ""
    email: str = ""
    password: str = ""
    confirm_password: str = ""
    terms_accepted: bool = False

    is_loading: bool = False
    show_password: bool = False
    show_confirm_password: bool = False
    error_message: str = ""
    success_message: str = ""

    def set_name(self, value: str):
        self.name = value
        self.error_message = ""

    def set_email(self, value: str):
        self.email = value
        self.error_message = ""

    def set_password(self, value: str):
        self.password = value
        self.error_message = ""

    def set_confirm_password(self, value: str):
        self.confirm_password = value
        self.error_message = ""

    def toggle_terms(self, checked: bool):
        self.terms_accepted = checked
        self.error_message = ""

    def toggle_password_visibility(self):
        self.show_password = not self.show_password

    def toggle_confirm_password_visibility(self):
        self.show_confirm_password = not self.show_confirm_password

    def validate_form(self) -> bool:
        if not self.name.strip():
            self.error_message = "El nombre es requerido"
            return False
        if not self.email.strip():
            self.error_message = "El email es requerido"
            return False
        if "@" not in self.email:
            self.error_message = "Ingresa un email válido"
            return False
        if len(self.password) < 6:
            self.error_message = "La contraseña debe tener al menos 6 caracteres"
            return False
        if self.password != self.confirm_password:
            self.error_message = "Las contraseñas no coinciden"
            return False
        if not self.terms_accepted:
            self.error_message = "Debes aceptar los términos y condiciones"
            return False
        return True

    async def handle_register(self):
        if not self.validate_form():
            return

        self.is_loading = True
        self.error_message = ""

        yield rx.sleep(2)  # Simular tiempo de procesamiento

        self.success_message = f"¡Bienvenido {self.name}! Tu cuenta ha sido creada exitosamente."
        self.is_loading = False

        self.name = ""
        self.email = ""
        self.password = ""
        self.confirm_password = ""
        self.terms_accepted = False


# ---------- Componentes reutilizables ----------
def layout(content):
    return rx.container(
        rx.vstack(
            rx.hstack(
                rx.link("Inicio", href="/"),
                rx.link("Registro", href="/register"),
                spacing="4",
                padding="4",
            ),
            rx.divider(),
            content,
        ),
        max_width="100%",
    )


def form_field(label: str, input_component, helper_text: str = ""):
    return rx.vstack(
        rx.text(label, weight="medium", size="2"),
        input_component,
        rx.cond(helper_text != "", rx.text(helper_text, size="1", color="gray")),
        spacing="1",
        width="100%",
    )


def password_input(value: str, placeholder: str, on_change, show_password: bool, toggle_visibility):
    return rx.hstack(
        rx.input(
            value=value,
            placeholder=placeholder,
            type=rx.cond(show_password, "text", "password"),
            on_change=on_change,
            width="100%",
        ),
        rx.button(
            rx.icon(tag=rx.cond(show_password, "eye-off", "eye"), size=16),
            on_click=toggle_visibility,
            variant="ghost",
            size="1",
        ),
        width="100%",
        align="center",
    )


# ---------- Página principal ----------
def index():
    return layout(
        rx.center(
            rx.vstack(
                rx.heading("Bienvenido a Mi Aplicación", size="9"),
                rx.text("Explora nuestras funcionalidades."),
                rx.link(
                    rx.button("Registrarse", size="3"),
                    href="/register",
                ),
                spacing="4",
                align="center",
            ),
            height="80vh",
        )
    )


# ---------- Página de registro ----------
def register_form():
    return rx.card(
        rx.vstack(
            rx.hstack(
                rx.icon(tag="user-plus", size=24, color="blue"),
                rx.heading("Crear Cuenta", size="6"),
                align="center",
                spacing="2",
            ),
            rx.text("Completa el formulario para crear tu cuenta", size="2", color="gray", text_align="center"),

            form_field(
                "Nombre completo",
                rx.input(
                    value=RegisterState.name,
                    placeholder="Juan Pérez",
                    on_change=RegisterState.set_name,
                ),
            ),
            form_field(
                "Email",
                rx.input(
                    value=RegisterState.email,
                    placeholder="juan@ejemplo.com",
                    type="email",
                    on_change=RegisterState.set_email,
                ),
            ),
            form_field(
                "Contraseña",
                password_input(
                    RegisterState.password,
                    "Mínimo 6 caracteres",
                    RegisterState.set_password,
                    RegisterState.show_password,
                    RegisterState.toggle_password_visibility,
                ),
                "Debe tener al menos 6 caracteres",
            ),
            form_field(
                "Confirmar contraseña",
                password_input(
                    RegisterState.confirm_password,
                    "Repite tu contraseña",
                    RegisterState.set_confirm_password,
                    RegisterState.show_confirm_password,
                    RegisterState.toggle_confirm_password_visibility,
                ),
            ),

            rx.hstack(
                rx.checkbox(
                    checked=RegisterState.terms_accepted,
                    on_change=RegisterState.toggle_terms,
                ),
                rx.text(
                    "Acepto los ",
                    rx.link("términos y condiciones", href="/terms", color="blue"),
                    " y la ",
                    rx.link("política de privacidad", href="/privacy", color="blue"),
                    size="2",
                ),
                align="start",
                spacing="2",
            ),

            rx.cond(
                RegisterState.error_message != "",
                rx.callout(RegisterState.error_message, icon="alert-circle", color="red", size="1"),
            ),
            rx.cond(
                RegisterState.success_message != "",
                rx.callout(RegisterState.success_message, icon="check-circle", color="green", size="1"),
            ),

            rx.button(
                rx.cond(
                    RegisterState.is_loading,
                    rx.hstack(rx.spinner(size="1"), "Creando cuenta...", align="center", spacing="2"),
                    rx.hstack(rx.icon(tag="user-plus", size=16), "Crear cuenta", align="center", spacing="2"),
                ),
                on_click=RegisterState.handle_register,
                disabled=RegisterState.is_loading,
                width="100%",
                size="3",
            ),

            rx.divider(),
            rx.hstack(
                rx.text("¿Ya tienes cuenta?", size="2", color="gray"),
                rx.link("Iniciar sesión", href="/login", color="blue", size="2"),
                align="center",
                spacing="2",
                justify="center",
            ),
            spacing="4",
            width="100%",
        ),
        max_width="400px",
        padding="6",
        variant="classic",
    )


def register_page():
    return layout(
        rx.center(
            register_form(),
            min_height="100vh",
            padding="4",
        )
    )


# ---------- Configuración de la App ----------
app = rx.App()
app.add_page(index, route="/")
app.add_page(register_page, route="/register")

