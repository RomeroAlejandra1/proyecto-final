import tkinter as tk
from tkinter import messagebox
from tkinter import ttk

def area_dinamica_limpia():
    for widget in area_dinamica.winfo_children():
        widget.destroy()

def inicio_hospital():
    area_dinamica_limpia()
    tk.Label(area_dinamica, text="CONTROL DE ASISTENCIAS EN UN HOSPITAL", font=("Arial", 14, "bold")).pack(pady=20)
    tk.Label(area_dinamica, text="Bienvenido al sistema de gestión de personal.", font=("Arial", 12)).pack(pady=10)
    tk.Button(area_dinamica, text="Ver Resumen", command=lambda: messagebox.showinfo("Resumen", "Aquí se mostrará un resumen general de asistencias.")).pack(pady=10)

def datos_trabajador():
    area_dinamica_limpia()
    tk.Label(area_dinamica, text="Datos del Trabajador", font=("Arial", 14, "bold")).pack(pady=10)

    tk.Label(area_dinamica, text="Nombre completo:").pack(anchor='w', padx=10)
    campo_nombre = tk.Entry(area_dinamica, width=40)
    campo_nombre.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Número de Empleado (ID):").pack(anchor='w', padx=10)
    campo_id = tk.Entry(area_dinamica, width=40)
    campo_id.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Género:").pack(anchor='w', padx=10)
    opcion_genero = tk.StringVar(value="Masculino")
    tk.Radiobutton(area_dinamica, text="Masculino", variable=opcion_genero, value="Masculino").pack(anchor='w', padx=20)
    tk.Radiobutton(area_dinamica, text="Femenino", variable=opcion_genero, value="Femenino").pack(anchor='w', padx=20)

    tk.Label(area_dinamica, text="Edad:").pack(anchor='w', padx=10)
    campo_edad = tk.Entry(area_dinamica, width=40)
    campo_edad.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Puesto:").pack(anchor='w', padx=10)
    opcion_puesto = ttk.Combobox(area_dinamica, values=["Médico", "Enfermera", "Limpieza", "Seguridad"], state="readonly")
    opcion_puesto.pack(pady=5, padx=10)
    opcion_puesto.current(0)

    def guardar_datos_trabajador():
        nombre = campo_nombre.get()
        empleado_id = campo_id.get()
        genero = opcion_genero.get()
        edad = campo_edad.get()
        puesto = opcion_puesto.get()

        if not all([nombre, empleado_id, edad, genero, puesto]):
            messagebox.showwarning("Campos Vacíos", "Por favor, complete todos los campos.")
            return

        try:
            int(empleado_id)
            int(edad)
        except ValueError:
            messagebox.showerror("Error de Datos", "ID de Empleado y Edad deben ser números.")
            return

        mensaje = (
            f"Datos Guardados:\n"
            f"Nombre: {nombre}\n"
            f"ID: {empleado_id}\n"
            f"Género: {genero}\n"
            f"Edad: {edad}\n"
            f"Puesto: {puesto}"
        )
        messagebox.showinfo("Confirmación", mensaje)

    tk.Button(area_dinamica, text="Guardar Datos", command=guardar_datos_trabajador).pack(pady=20)
inicio_hospital()
ventana_principal.mainloop()