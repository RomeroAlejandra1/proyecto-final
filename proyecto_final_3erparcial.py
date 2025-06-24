import tkinter as tk
from tkinter import messagebox
from tkinter import ttk
from datetime import datetime

class Hospital:
    def __init__(self, root):
        self.root = root
        self.root.title("CONTROL DE PERSONAL HOSPITALARIO")
        self.root.config(bg="lightblue")
        self.root.geometry("800x450")
        self.datos_trabajadores = []
        self.turnos = {}
        self.horarios_guardados = {}
        self.faltas_registradas = {}
        self.periodos_vacacionales = {}

        self.menu_lateral = tk.Frame(self.root, bg="light blue", width=180)
        self.menu_lateral.pack(side="left", fill="y")

        self.area_dinamica = tk.Frame(self.root, bg="white")
        self.area_dinamica.pack(side="right", expand=True, fill="both")

        self.crear_menu()
        self.saludo()

    def crear_menu(self):
        botones = [
            ("INICIO", self.saludo),
            ("TRABAJADOR", self.trabajador),
            ("TURNO", self.turno),
            ("FALTAS", self.faltas),
            ("VACACIONES", self.vacaciones),
            ("HISTORIAL", self.mostrar_historial)
        ]
        for texto, comando in botones:
            tk.Button(self.menu_lateral, text=texto, font="Arial 14 bold", command=comando, width=20).pack(pady=10)

    def limpiar_area_dinamica(self):
        for widget in self.area_dinamica.winfo_children():
            widget.destroy()

    def saludo(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="Bienvenido al sistema de control del hospital", bg="#B3C2F5", font=("Arial", 16, "bold")).pack(pady=20)
        tk.Button(self.area_dinamica, text="Mostrar saludo",
                  command=lambda: messagebox.showinfo("Saludo", "¡Hola!, ¡Qué alegría verte de nuevo!")).pack()

    def trabajador(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="DATOS DEL TRABAJADOR", bg="#FCBDF9", font=("Arial", 14, "bold")).pack(pady=10)

        campos_entry = {}

        etiquetas_campos = ["Nombre", "Edad", "ID", "Teléfono", "Correo electrónico", "Domicilio"]

        for etiqueta in etiquetas_campos:
            tk.Label(self.area_dinamica, text=f"{etiqueta}:").pack(anchor="w", padx=100)
            entrada = tk.Entry(self.area_dinamica, width=40)
            entrada.pack()
            campos_entry[etiqueta] = entrada

        tk.Label(self.area_dinamica, text="Género:").pack(anchor="w", padx=100)
        genero_combo = ttk.Combobox(self.area_dinamica, values=["Masculino", "Femenino"], width=37)
        genero_combo.pack()

        tk.Label(self.area_dinamica, text="Puesto:").pack(anchor="w", padx=100)
        puesto_combo = ttk.Combobox(self.area_dinamica, values=["Médico", "Enfermero", "Limpieza", "Seguridad"], width=37)
        puesto_combo.pack()

        def guardar_datos():
            nombre = campos_entry["Nombre"].get()
            edad = campos_entry["Edad"].get()
            id_trabajador = campos_entry["ID"].get()
            telefono = campos_entry["Teléfono"].get()
            correo = campos_entry["Correo electrónico"].get()
            domicilio = campos_entry["Domicilio"].get()
            genero = genero_combo.get()
            puesto = puesto_combo.get()

            if not all([nombre, edad, id_trabajador, telefono, correo, genero, puesto]):
                messagebox.showwarning("Error", "Por favor llena todos los espacios.")
                return

            if not id_trabajador.isdigit():
                messagebox.showerror("Error", "El ID solo puede tener números.")
                return
            if not edad.isdigit():
                messagebox.showerror("Error", "La edad debe ser numérica.")
                return
            if not telefono.isdigit() or len(telefono) < 7:
                messagebox.showerror("Error", "Número de teléfono inválido.")
                return

            nuevo_trabajador_data = {
                "nombre": nombre,
                "edad": edad,
                "ID": id_trabajador,
                "genero": genero,
                "puesto": puesto,
                "telefono": telefono,
                "correo": correo,
                "domicilio": domicilio,
            }

            for trabajador_data in self.datos_trabajadores:
                if trabajador_data["ID"] == id_trabajador:
                    messagebox.showwarning("Duplicado", "Ya existe un trabajador con el mismo ID")
                    return

            self.datos_trabajadores.append(nuevo_trabajador_data)
            messagebox.showinfo("Registrado", "Datos guardados correctamente")

            for entry in campos_entry.values():
                entry.delete(0, tk.END)
            genero_combo.set('')
            puesto_combo.set('')

        tk.Button(self.area_dinamica, text="Guardar", command=guardar_datos,
                  bg="light blue", fg="black", font=("Arial", 12, "bold")).pack(pady=20)

    def turno(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="TURNO DEL TRABAJADOR", bg="#A2EFFD", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="ID de trabajador:").pack(anchor="w", padx=100)
        id_trabajador_entry = tk.Entry(self.area_dinamica, width=40)
        id_trabajador_entry.pack()

        tk.Label(self.area_dinamica, text="Selecciona el turno:").pack(anchor="w", padx=100)

        turno_combo = ttk.Combobox(self.area_dinamica, values=["Matutino (6:00-14:00)", "Vespertino (14:00-22:00)", "Nocturno (22:00-6:00)"], width=37)
        turno_combo.pack()

        def guardar_turno():
            id_trabajador = id_trabajador_entry.get()
            turno = turno_combo.get()

            if not id_trabajador or not turno:
                messagebox.showwarning("Datos vacios", "Por favor, llene todos los apartados")
                return

            trabajador_existe = False
            for t in self.datos_trabajadores:
                if t["ID"] == id_trabajador:
                    trabajador_existe = True
                    break

            if not trabajador_existe:
                messagebox.showerror("Error", "Este trabajador no está registrado.")
                return

            anterior_turno = self.turnos.get(id_trabajador, None)
            self.turnos[id_trabajador] = turno
            mensaje = f"Turno actualizado de '{anterior_turno}' a '{turno}'" if anterior_turno else f"Turno '{turno}' asignado al trabajador {id_trabajador}."
            messagebox.showinfo("Turno guardado", mensaje)

            id_trabajador_entry.delete(0, tk.END)
            turno_combo.set('')

        tk.Button(self.area_dinamica, text="Guardar turno", command=guardar_turno,
                  bg="light pink", fg="black", font=("Arial", 12, "bold")).pack(pady=20)

    def faltas(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="REGISTRO DE FALTAS", bg="#CAA2FD", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="ID de trabajador:").pack(anchor="w", padx=100)
        id_trabajador_entry = tk.Entry(self.area_dinamica, width=40)
        id_trabajador_entry.pack()

        tk.Label(self.area_dinamica, text="Selecciona la cantidad de faltas:").pack(anchor="w", padx=100)
        faltas_combo = ttk.Combobox(self.area_dinamica, values=["0 días", "1 día", "2 días", "3 días", "4 días", "5 días"], width=37)
        faltas_combo.pack()

        def registrar_falta():
            id_trabajador = id_trabajador_entry.get()
            faltas_str = faltas_combo.get()

            if not id_trabajador.isdigit():
                messagebox.showerror("Error", "ID de trabajador incorrecto.")
                return

            trabajador_existe = False
            for t in self.datos_trabajadores:
                if t["ID"] == id_trabajador:
                    trabajador_existe = True
                    break

            if not trabajador_existe:
                messagebox.showerror("No existe", "Este trabajador no está registrado.")
                return

            try:
                faltas_num = int(faltas_str.split()[0])
            except ValueError:
                messagebox.showerror("Error", "Selecciona una cantidad válida de faltas.")
                return

            self.faltas_registradas[id_trabajador] = self.faltas_registradas.get(id_trabajador, 0) + faltas_num
            messagebox.showinfo("Falta registrada", f"{faltas_num} falta(s) registrada(s) para el trabajador {id_trabajador}.")

            id_trabajador_entry.delete(0, tk.END)
            faltas_combo.set('')

        tk.Button(self.area_dinamica, text="Registrar falta", command=registrar_falta,
                  bg="lightblue", fg="black", font=("Arial", 12, "bold")).pack(pady=20)

    def vacaciones(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="PERIODO VACACIONAL", bg="#A2FDB6", font=("Arial", 14, "bold")).pack(pady=10)

        tk.Label(self.area_dinamica, text="ID de trabajador:").pack(anchor="w", padx=100)
        id_trabajador_entry = tk.Entry(self.area_dinamica, width=40)
        id_trabajador_entry.pack()

        tk.Label(self.area_dinamica, text="Selecciona el periodo vacacional:").pack(anchor="w", padx=100)
        periodo_combo = ttk.Combobox(self.area_dinamica, values=[
            "Enero-Febrero", "Febrero-Marzo", "Marzo-Abril", "Abril-Mayo", "Mayo-Junio",
            "Junio-Julio", "Julio-Agosto", "Agosto-Septiembre", "Septiembre-Octubre", "Octubre-Noviembre", "Noviembre-Diciembre"
        ], width=37)
        periodo_combo.pack()

        def guardar_periodo():
            id_trabajador = id_trabajador_entry.get()
            periodo = periodo_combo.get()

            if not id_trabajador.isdigit():
                messagebox.showerror("Error", "ID de trabajador inválido.")
                return

            trabajador_existe = False
            for t in self.datos_trabajadores:
                if t["ID"] == id_trabajador:
                    trabajador_existe = True
                    break

            if not trabajador_existe:
                messagebox.showerror("No existe", "Este trabajador no está registrado.")
                return

            if not periodo:
                messagebox.showwarning("Datos vacíos", "Por favor llene todos los apartados.")
                return

            self.periodos_vacacionales[id_trabajador] = periodo
            messagebox.showinfo("Periodo guardado", f"Periodo vacacional '{periodo}' asignado al trabajador {id_trabajador}.")

            id_trabajador_entry.delete(0, tk.END)
            periodo_combo.set('')

        tk.Button(self.area_dinamica, text="Guardar periodo", command=guardar_periodo,
                  bg="#28A745", fg="white", font=("Arial", 12, "bold")).pack(pady=20)

    def mostrar_historial(self):
        self.limpiar_area_dinamica()
        tk.Label(self.area_dinamica, text="LISTA DE TRABAJADORES", bg="#FDECA2", font=("Arial", 16, "bold")).pack(pady=10)

        text_area = tk.Text(self.area_dinamica, width=90, height=25, wrap="word")
        text_area.pack(padx=10, pady=10)

        if not self.datos_trabajadores:
            text_area.insert("1.0", "Aún no hay datos de trabajadores registrados.")
        else:
            texto_impresion = "Trabajadores registrados:\n\n"
            trabajadores_ordenados = sorted(self.datos_trabajadores, key=lambda x: x["ID"])

            for trabajador_data in trabajadores_ordenados:
                id_trabajador = trabajador_data["ID"]

                turno = self.turnos.get(id_trabajador, "No asignado")
               
                faltas = self.faltas_registradas.get(id_trabajador, 0)
                periodo = self.periodos_vacacionales.get(id_trabajador, "No asignado")

                texto_impresion += (f"Nombre: {trabajador_data['nombre']}\n"
                                    f"Edad: {trabajador_data['edad']}\n"
                                    f"ID de trabajador: {id_trabajador}\n"
                                    f"Género: {trabajador_data['genero']}\n"
                                    f"Puesto: {trabajador_data['puesto']}\n"
                                    f"Teléfono: {trabajador_data.get('telefono', 'No registrado')}\n"
                                    f"Correo: {trabajador_data.get('correo', 'No registrado')}\n"
                                    f"Domicilio: {trabajador_data.get('domicilio', 'No registrado')}\n"
                                    f"Turno: {turno}\n"
                                    f"Faltas: {faltas} días\n"
                                    f"Periodo vacacional: {periodo}\n\n"
                                    + "="*50 + "\n\n")

            text_area.insert("1.0", texto_impresion)

        text_area.config(state="disabled")

if __name__ == "__main__":
    ventana = tk.Tk()
    app = Hospital(ventana)
    ventana.mainloop()