# proyecto-final
#Mi proyecto será sobre el registro de empleados en un hospital
La gestión de personal es crucial para el buen desempeño de cualquier negocio u organización, sobre todo en un hospital.
Es un sistema que nos permite identificar y monitorear a cada individuo en la compañía. Su importancia radica tanto en el cumplimiento de la ley como en la eficiencia operativa diaria.
 Aquí se guardan desde detalles básicos como nombre, dirección, CURP o número de seguridad social, hasta datos más específicos del puesto, salario, horarios, etc..
Comenzaremos con registrar los datos del empleado

---------------DATOS DEL EMPLEADO-----------------------
Crearemos una ventana con campos para registrar la información fundamental de cada trabajador. Esta sección incluirá:
Nombre completo del empleado.
Número de empleado (ID), un identificador único para cada trabajador.
Género del empleado.
Edad.
Puesto que ocupa dentro del hospital (Médico, Cirujano, Enfermero, Seguridad).

------------Registro de Asistencia Diaria---------------
Ventana para Registrar la Asistencia
Esta sección permitirá llevar un control diario de la presencia o ausencia del personal. La ventana de registro de asistencia incluirá:

Un campo para ingresar el Número de Empleado (ID), para identificar al trabajador.
Un campo para la Fecha del registro de asistencia.
Opciones para indicar el estado de asistencia:
Asistió (Presente)
Faltó (Ausente)
Retraso (Opcional)
Está de Vacaciones
Día Libre
Una selección para especificar el Turno del trabajador (Matutino, Vespertino, Nocturno).

-----------------Gestión de Vacaciones---------------
Ventana para Gestionar Días de Vacaciones
Aquí se manejarán las solicitudes y el seguimiento de los periodos vacacionales de los empleados. La ventana contendrá:

Un campo para el Número de Empleado (ID) del trabajador que solicita las vacaciones.
Un campo para indicar la cantidad de días de vacaciones disponibles que tiene el empleado.
Campos para ingresar la Fecha de Inicio y la Fecha de Fin del periodo de vacaciones solicitado.
Validación de Fechas: Se asegurará que la fecha de inicio no sea posterior a la fecha de fin y que los días solicitados no excedan los días disponibles.
Control de Días No Laborales: Se incluirá una advertencia o restricción si la solicitud de vacaciones abarca fines de semana o días feriados (esta lógica necesitaría la integración de un calendario laboral).

----------------------Calendario Laboral------------------
Ventana para Visualizar el Calendario
Esta sección proporcionará una vista general de las fechas importantes, facilitando la planificación y la gestión. La ventana mostrará:

Un calendario básico del mes y año actuales.
Indicaciones sobre cómo se podrían marcar los días feriados y fines de semana, relevantes para la programación de turnos y vacaciones.
