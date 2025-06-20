import tkinter as tk
from tkinter import messagebox
from tkinter import ttk
from datetime import datetime

# El nuevo cambio que hice es agregarle una clase padre
class Persona:
    def __init__(self, nombre, edad, genero):
        self.nombre = nombre
        self.edad = edad
        self.genero = genero

# Y una clase hija
class Trabajador(Persona):
    def __init__(self, nombre, edad, genero, numero_trabajador, puesto):
        super().__init__(nombre, edad, genero)
        self.numero_trabajador = numero_trabajador
        self.puesto = puesto

class Hospital:
    def __init__(self, root):
        self.root = root
        self.root.title("CONTROL DE PERSONAL HOSPITALARIO")
        self.root.config(bg="lightblue")
        self.root.geometry("800x450") 

        self.datos_trabajadores = []
        self.seleccionar_turnos = []
        self.registro_asistencia = {}
        self.gestionar_vacaciones = {}

        self.menu_lateral = tk.Frame(self.root, bg="light blue", width=180)
        self.menu_lateral.pack(side="left", fill="y")

        self.area_dinamica = tk.Frame(self.root, bg="white")
        self.area_dinamica.pack(side="right", expand=True, fill="both")

        self.crear_menu()
        self.saludo()

    def crear_menu(self):
        tk.Button(self.menu_lateral, text="INICIO", font="Arial 14 bold", command=self.saludo, width=20).pack(pady=10)
        tk.Button(self.menu_lateral, text="TRABAJADOR", font="Arial 14 bold", command=self.trabajador, width=20).pack(pady=10)
        tk.Button(self.menu_lateral, text="TURNO", font="Arial 14 bold", command=self.turno, width=20).pack(pady=10)
        tk.Button(self.menu_lateral, text="ASISTENCIAS", font="Arial 14 bold", command=self.asistencias, width=20).pack(pady=10)
        tk.Button(self.menu_lateral, text="VACACIONES", font="Arial 14 bold", command=self.periodo_vacacional, width=20).pack(pady=10)
        tk.Button(self.menu_lateral, text="HISTORIAL", font="Arial 14 bold", command=self.imprimir, width=20).pack(pady=10)

    def limpiar_area_dinamica(self):
        for widget in self.area_dinamica.winfo_children():
            widget.destroy()

    def saludo(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="Bienvenido al sistema de control del hospital", font=("Arial", 16, "bold")).pack(pady=20)
        tk.Button(self.area_dinamica, text="Mostrar saludo",
                  command=lambda: messagebox.showinfo("Saludo", "¡Hola!, ¡Qué alegría verte de nuevo!")).pack()

    def trabajador(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="Datos del trabajador", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="Nombre:").pack(anchor="w", padx=100)
        nombre_entry = tk.Entry(self.area_dinamica, width=40)
        nombre_entry.pack()

        tk.Label(self.area_dinamica, text="Edad:").pack(anchor="w", padx=100)
        edad_entry = tk.Entry(self.area_dinamica, width=40)
        edad_entry.pack()

        tk.Label(self.area_dinamica, text="ID:").pack(anchor="w", padx=100)
        num_trab_entry = tk.Entry(self.area_dinamica, width=40)
        num_trab_entry.pack()

        tk.Label(self.area_dinamica, text="Género:").pack(anchor="w", padx=100)
        genero_combo = ttk.Combobox(self.area_dinamica, values=["Masculino", "Femenino"], width=37)
        genero_combo.pack()

        tk.Label(self.area_dinamica, text="Puesto:").pack(anchor="w", padx=100)
        puesto_combo = ttk.Combobox(self.area_dinamica, values=["Médico", "Enfermero", "Limpieza", "Seguridad"], width=37)
        puesto_combo.pack()

        def guardar_datos():
            numero = num_trab_entry.get()
            if not numero.isdigit():
                messagebox.showerror("Error", "El ID solo puede tener números.")
                return

            datos = {
                "nombre": nombre_entry.get(),
                "edad": edad_entry.get(),
                "numero_trabajador": numero,
                "genero": genero_combo.get(),
                "puesto": puesto_combo.get()
            }

            if not all(datos.values()):
                messagebox.showwarning("Datos vacíos", "Por favor llene todos los apartados.")
                return

            for trabajador in self.datos_trabajadores:
                if trabajador["numero_trabajador"] == numero:
                    messagebox.showwarning("Duplicado", "Ya hay un trabajador existente con el mismo ID.")
                    return
            # Use la clase hija Trabajador
            nuevo_trabajador = Trabajador( self nombre, edad, genero, numero, puesto)
            self.datos_trabajadores.append(nuevo_trabajador)
            messagebox.showinfo("Registro exitoso", "Datos guardados correctamente")
            nombre_entry.delete(0, tk.END)
            edad_entry.delete(0, tk.END)
            num_trab_entry.delete(0, tk.END)
            genero_combo.set('')
            puesto_combo.set('')

        tk.Button(self.area_dinamica, text="Guardar", command=guardar_datos, bg="light blue", fg="white", font=("Arial", 12, "bold")).pack(pady=20)

    def turno(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="TURNO DEL TRABAJADOR", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="Número de trabajador:").pack(anchor="w", padx=100)
        num_trab_entry = tk.Entry(self.area_dinamica, width=40)
        num_trab_entry.pack()

        tk.Label(self.area_dinamica, text="Selecciona el turno:").pack(anchor="w", padx=100)
        turno_combo = ttk.Combobox(self.area_dinamica, values=["Matutino (6:00-14:00)", "Vespertino (14:00-22:00)", "Nocturno (22:00-6:00)"], width=37)
        turno_combo.pack()

        def guardar_turno():
            numero = num_trab_entry.get()
            turno = turno_combo.get()

            if not numero or not turno:
                messagebox.showwarning("Datos vacíos", "Por favor llene todos los apartados.")
                return

            if numero not in [t["numero_trabajador"] for t in self.datos_trabajadores]:
                messagebox.showerror("Error", "Este trabajador no está registrado.")
                return

            found = False
            for i, t in enumerate(self.seleccionar_turnos):
                if t["numero_trabajador"] == numero:
                    self.seleccionar_turnos[i]["turno"] = turno
                    found = True
                    break
            if not found:
                self.seleccionar_turnos.append({"numero_trabajador": numero, "turno": turno})

            messagebox.showinfo("Turno guardado", f"Turno '{turno}' asignado al trabajador {numero}.")
            num_trab_entry.delete(0, tk.END)
            turno_combo.set('')

        tk.Button(self.area_dinamica, text="Guardar turno", command=guardar_turno, bg="light pink", fg="black", font=("Arial", 12, "bold")).pack(pady=20)

    def asistencias(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="REGISTRO DE ASISTENCIAS", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="ID del Empleado:").pack(anchor="w", padx=100)
        id_empleado_entry = tk.Entry(self.area_dinamica, width=40)
        id_empleado_entry.pack()

        tk.Label(self.area_dinamica, text="Fecha (DD-MM-AAAA):").pack(anchor="w", padx=100)
        fecha_entry = tk.Entry(self.area_dinamica, width=40)
        fecha_entry.pack()
        fecha_entry.insert(0, datetime.now().strftime("%d-%m-%Y")) 

        tk.Label(self.area_dinamica, text="Estado del Trabajador:").pack(anchor="w", padx=100)
        estado_combo = ttk.Combobox(self.area_dinamica, values=["Presente", "Ausente"], width=37)
        estado_combo.pack()

        def registrar_asistencia():
            empleado_id = id_empleado_entry.get()
            fecha_str = fecha_entry.get()
            estado = estado_combo.get()

            if not empleado_id or not fecha_str or not estado:
                messagebox.showwarning("Datos vacíos", "Por favor llene todos los apartados.")
                return

            if not empleado_id.isdigit():
                messagebox.showerror("Error", "El ID del empleado deben ser numéros.")
                return

            if empleado_id not in [t["numero_trabajador"] for t in self.datos_trabajadores]:
                messagebox.showerror("Error", "Este ID de empleado no está registrado.")
                return

            try:
                datetime.strptime(fecha_str, "%d-%m-%Y")
            except ValueError:
                messagebox.showerror("Error", "Registre correctamente la fecha")
                return

            if empleado_id not in self.registro_asistencia:
                self.registro_asistencia[empleado_id] = []

            for record in self.registro_asistencia[empleado_id]:
                if record["fecha"] == fecha_str:
                    messagebox.showwarning("Error, Asistencia duplicada")
                    return

            self.registro_asistencia[empleado_id].append({
                "fecha": fecha_str,
                "estado": estado
            })

            messagebox.showinfo("Registro exitoso", f"Asistencia registrada para el empleado {empleado_id} el {fecha_str} ({estado}).")

            id_empleado_entry.delete(0, tk.END)
            fecha_entry.delete(0, tk.END)
            fecha_entry.insert(0, datetime.now().strftime("%d-%m-%Y")) 
            estado_combo.set('')

        tk.Button(self.area_dinamica, text="Registrar Asistencia", command=registrar_asistencia, bg="#007BFF", fg="white", font=("Arial", 12, "bold")).pack(pady=20)

    def periodo_vacacional(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="PERIODO VACACIONAL", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="Número de trabajador:").pack(anchor="w", padx=100)
        num_trab_entry = tk.Entry(self.area_dinamica, width=40)
        num_trab_entry.pack()

        tk.Label(self.area_dinamica, text="Selecciona el periodo vacacional:").pack(anchor="w", padx=100)
        periodo_combo = ttk.Combobox(self.area_dinamica, values=[
            "Enero-Febrero", "Febrero-Marzo", "Marzo-Abril", "Abril-Mayo", "Mayo-Junio",
            "Junio-Julio", "Julio-Agosto", "Agosto-Septiembre", "Septiembre-Octubre", "Octubre-Noviembre", "Noviembre-Diciembre"
        ], width=37)
        periodo_combo.pack()

        def guardar_periodo():
            numero = num_trab_entry.get()
            periodo = periodo_combo.get()

            if not numero.isdigit():
                messagebox.showerror("Error", "Número de trabajador inválido.")
                return

            if numero not in [t["numero_trabajador"] for t in self.datos_trabajadores]:
                messagebox.showerror("No existe", "Este trabajador no está registrado.")
                return

            if not periodo:
                messagebox.showwarning("Datos vacíos", "Por favor llene todos los apartados.")
                return

            self.gestionar_vacaciones[numero] = periodo
            messagebox.showinfo("Periodo guardado", f"Periodo '{periodo}' registrado para el trabajador {numero}.")
            num_trab_entry.delete(0, tk.END)
            periodo_combo.set('')

        tk.Button(self.area_dinamica, text="Guardar periodo", command=guardar_periodo, bg="#28A745", fg="white", font=("Arial", 12, "bold")).pack(pady=20)

    def imprimir(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="LISTA DE TRABAJADORES", font=("Arial", 16, "bold")).pack(pady=10)

        if not self.datos_trabajadores:
            tk.Label(self.area_dinamica, text="Aún no hay datos de trabajadores registrados.", font=("Arial", 12)).pack(pady=10)
            return

        trabajadores_ordenados = sorted(self.datos_trabajadores, key=lambda x: x["numero_trabajador"])

        columns = ("ID", "Nombre", "Puesto", "Turno", "Vacaciones", "Asistencias Registradas")
        self.tree = ttk.Treeview(self.area_dinamica, columns=columns, show="headings")
        self.tree.pack(fill="both", expand=True, padx=10, pady=10)

        for col in columns:
            self.tree.heading(col, text=col, anchor=tk.W)
            self.tree.column(col, width=100)

        self.tree.column("ID", width=50)
        self.tree.column("Nombre", width=150)
        self.tree.column("Puesto", width=100)
        self.tree.column("Turno", width=150)
        self.tree.column("Vacaciones", width=120)
        self.tree.column("Asistencias Registradas", width=200)

        for persona in trabajadores_ordenados:
            numero = persona["numero_trabajador"]
            turno = next((t["turno"] for t in self.seleccionar_turnos if t["numero_trabajador"] == numero), "Sin turno asignado")
            periodo_vacacional = self.gestionar_vacaciones.get(numero, "No asignado")

            asistencias_info = []
            if numero in self.registro_asistencia:
                for record in self.registro_asistencia[numero]:
                    asistencias_info.append(f"{record['fecha']} ({record['estado']})")

            asistencias_str = ", ".join(asistencias_info) if asistencias_info else "Ninguna"

            self.tree.insert("", "end", values=(
                persona['numero_trabajador'],
                persona['nombre'],
                persona['puesto'],
                turno,
                periodo_vacacional,
                asistencias_str
            ))

if __name__ == "__main__":
    ventana = tk.Tk()
    app = Hospital(ventana)
    ventana.mainloop()

