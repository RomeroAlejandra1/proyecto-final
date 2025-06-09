
import tkinter as tk
from tkinter import messagebox, ttk
from datetime import date

def registro_asistencia(area_dinamica):
    tk.Label(area_dinamica, text="Registro de Asistencia Diaria", font=("Arial", 14, "bold")).pack(pady=10)

    tk.Label(area_dinamica, text="Número de Empleado (ID):").pack(anchor='w', padx=10)
    campo_id = tk.Entry(area_dinamica, width=40)
    campo_id.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Fecha (DD-MM-AAAA):").pack(anchor='w', padx=10)
    campo_fecha = tk.Entry(area_dinamica, width=40)
    campo_fecha.insert(0, date.today().strftime("%d-%m-%Y"))
    campo_fecha.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Estado:").pack(anchor='w', padx=10)
    estado_var = tk.StringVar(value="Presente")
    for estado in ["Presente", "Ausente", "Retraso", "Vacaciones", "Día Libre"]:
        tk.Radiobutton(area_dinamica, text=estado, variable=estado_var, value=estado).pack(anchor='w', padx=20)

    tk.Label(area_dinamica, text="Turno:").pack(anchor='w', padx=10)
    turno = ttk.Combobox(area_dinamica, values=["Matutino", "Vespertino", "Nocturno"], state="readonly")
    turno.current(0)
    turno.pack(pady=5, padx=10)

    def guardar_asistencia():
        if not campo_id.get() or not campo_fecha.get():
            messagebox.showwarning("Datos incompletos", "Complete todos los campos.")
            return
        mensaje = f"ID: {campo_id.get()}\nFecha: {campo_fecha.get()}\nEstado: {estado_var.get()}\nTurno: {turno.get()}"
        messagebox.showinfo("Asistencia registrada", mensaje)

    tk.Button(area_dinamica, text="Registrar Asistencia", command=guardar_asistencia).pack(pady=20)
def registro_vacaciones(area_dinamica):
   
    area_dinamica_limpia(area_dinamica)
    tk.Label(area_dinamica, text="Registro de Vacaciones", font=("Arial", 14, "bold")).pack(pady=10)

    tk.Label(area_dinamica, text="ID del Empleado:").pack(anchor='w', padx=10)
    campo_id = tk.Entry(area_dinamica, width=40)
    campo_id.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Fecha de Inicio:").pack(anchor='w', padx=10)
    campo_inicio = tk.Entry(area_dinamica, width=40)
    campo_inicio.insert(0, date.today().strftime("%d-%m-%Y"))
    campo_inicio.pack(pady=5, padx=10)

    tk.Label(area_dinamica, text="Fecha de Fin:").pack(anchor='w', padx=10)
    campo_fin = tk.Entry(area_dinamica, width=40)
    campo_fin.pack(pady=5, padx=10)

    def guardar_vacaciones():
        if not campo_id.get() or not campo_inicio.get() or not campo_fin.get():
            messagebox.showwarning("Datos incompletos", "Complete todos los campos.")
            return
        mensaje = f"Vacaciones registradas para ID {campo_id.get()} del {campo_inicio.get()} al {campo_fin.get()}"
        messagebox.showinfo("Vacaciones registradas", mensaje)

    tk.Button(area_dinamica, text="Registrar Vacaciones", command=guardar_vacaciones).pack(pady=20)

