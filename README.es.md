<div align="center">

# 🛡️ Laboratorio de Seguridad y Estrés de Recursos en Linux

**Proyecto académico de Sistemas Operativos para estudiar el consumo intensivo de recursos, la detección de anomalías, la contención de procesos y la evaluación del rendimiento.**

![Linux](https://img.shields.io/badge/Linux-Bash-4EAA25?logo=linux&logoColor=white)
![Estado](https://img.shields.io/badge/Estado-Prototipo%20acad%C3%A9mico-orange)

**[Read in English](README.md) · [Arquitectura](docs/ARCHITECTURE.md) · [Revisión de seguridad](docs/SECURITY_REVIEW.md) · [Guía de demostración](docs/DEMO_GUIDE.md) · [Publicación en GitHub](PUBLISHING.md)**

</div>

> [!WARNING]
> **No es un virus real ni una solución antivirus.** Los cinco scripts originales de la práctica se conservaron sin modificar. Algunos pueden consumir grandes cantidades de CPU, RAM y disco; finalizar procesos no relacionados o modificar el firewall, SSH y políticas del sistema. **No ejecutes `malware_sim.sh`, `kill_malware.sh` ni `proteccion.sh` en tu equipo principal o servidores.** Consulta la [auditoría de seguridad](docs/SECURITY_REVIEW.md) antes de probarlos en una máquina virtual aislada y desechable.

## 🎯 Descripción

Este proyecto explora el comportamiento de un sistema Linux frente a cargas que simulan síntomas asociados con software malicioso: saturación de CPU, consumo de memoria, escrituras en disco y proliferación de procesos. También incorpora herramientas de monitoreo, una propuesta de contención, una práctica de endurecimiento del sistema y un análisis comparativo del rendimiento.

La simulación **no realiza autorreplicación, persistencia o robo de información**; es una práctica de disponibilidad y observabilidad del sistema operativo.

## 🧩 Componentes

| Script | Función principal |
|---|---|
| `scripts/malware_sim.sh` | Simula cargas de CPU, RAM, disco y creación de procesos |
| `scripts/detector.sh` | Supervisa recursos, procesos, puertos y artefactos en `/tmp` |
| `scripts/kill_malware.sh` | Realiza una limpieza demostrativa de procesos y archivos; tiene riesgos por patrones amplios |
| `scripts/proteccion.sh` | Muestra configuraciones de UFW, SSH, contraseñas, límites de procesos y ACL; **al ejecutarse modifica el sistema** |
| `scripts/medicion_desempenio.sh` | Captura datos de tres escenarios y genera reportes TXT y CSV |

## 🔬 Metodología de evaluación

1. **A — Sistema limpio:** captura una línea base de uso de recursos.
2. **B — Sistema bajo estrés:** mide el mismo conjunto de métricas durante la simulación.
3. **C — Sistema posterior a contención:** mide después del intento de detener procesos y limpiar artefactos.
4. **Comparación:** revisa CPU, RAM, disco, procesos, carga promedio, latencia y tiempo de respuesta.

No se incluyen resultados numéricos porque no venían en el archivo original. El término «infectado» dentro del código solo identifica un escenario del experimento; **no existe una infección real**.

## 📂 Organización

```text
scripts/                 5 scripts Bash originales
README.md                Documentación principal en inglés
README.es.md             Este resumen en español
docs/ARCHITECTURE.md     Arquitectura y flujo de datos
docs/SECURITY_REVIEW.md  Riesgos y mejoras pendientes
docs/DEMO_GUIDE.md       Demostración sin lanzar el estrés
tests/static_checks.sh   Comprobación de sintaxis sin ejecución
.github/workflows/       Integración continua de sintaxis
```

## 🧪 Validación sin ejecutar la simulación

```bash
bash tests/static_checks.sh
```

Para observar únicamente el monitoreo de recursos del host en Linux (se crea `/tmp/detector_log.txt`):

```bash
bash scripts/detector.sh
# Presiona Ctrl+C para detener.
```

El detector utiliza umbrales heurísticos, por lo que pueden existir falsos positivos. Los scripts de estrés, limpieza y endurecimiento requieren un rediseño de seguridad antes de considerarse aptos para una ejecución general. El código se presenta con fines de aprendizaje y revisión técnica.

## 🧠 Habilidades demostradas

**Linux y Bash**, administración de procesos, uso de CPU/RAM/disco, comandos de observabilidad, registros del sistema, monitoreo, fundamentos de control de acceso, medición de rendimiento y análisis de riesgos.

## 🚧 Mejoras previstas

- Límites estrictos de CPU, RAM, disco y procesos, con tiempo de ejecución realmente acotado.
- Identificación precisa de procesos propios y limpieza sin patrones globales.
- Modo de solo auditoría para configuraciones de seguridad.
- Pruebas funcionales en máquinas virtuales y resultados reproducibles anonimizados.

**Contexto:** Sistemas Operativos, Facultad de Ingeniería, Universidad Nacional Autónoma de México (UNAM). **Repositorio:** [Alexisvop](https://github.com/Alexisvop). **Licencia:** pendiente de definir según autoría y condiciones académicas.
