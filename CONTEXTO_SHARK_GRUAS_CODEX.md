# Shark Grúas — Contexto del proyecto para Codex

## 1. Objetivo
Desarrollar un sitio web profesional para **Shark Grúas**, empresa de servicios de grúas y transporte de vehículos y maquinaria. El sitio debe presentar el negocio, generar confianza, responder dudas frecuentes y permitir que los clientes obtengan **cotizaciones automáticas** mediante una página independiente.

Este archivo es el contexto funcional inicial para Codex. **No inventar tarifas, reglas comerciales, credenciales, datos de contacto, textos legales ni compromisos operativos** que no hayan sido confirmados.

## 2. Decisiones ya tomadas
- **Cobertura confirmada por el responsable del proyecto:** base operativa en la Región Metropolitana y servicios de traslado desde La Serena hasta Chillán. El mapa regional destaca las regiones de ese recorrido; no equivale a confirmar cobertura completa de todas las localidades de cada región.
- Habrá **dos páginas públicas principales**: **Inicio** (`/`) y **Cotizador** (`/cotizar`).
- El **cotizador no irá embebido en la página principal**. La página de Inicio sí tendrá botones visibles para acceder a él.
- La portada se centrará en **presentación de la empresa, servicios, cobertura, preguntas frecuentes y contacto**.
- La **cotización es automática**: se debe calcular una tarifa a partir de reglas del negocio, aún pendientes de definir.
- El **club de referidos queda fuera del alcance por ahora**, aunque aparezca en la presentación original.
- El **panel administrativo se considera una etapa posterior**, no parte del MVP inicial.
- Tecnologías previstas: **Next.js**, **Vercel**, **Supabase** y **n8n**.

## 3. Información de negocio de la presentación entregada
Según el material proporcionado por Shark Grúas (PPT SHARK GRÚAS):
- Base operativa principal en la **Región Metropolitana**.
- Cobertura declarada desde **La Serena hasta Chillán**, con detalle de comunas en las preguntas frecuentes del material.
- Atención declarada **24 horas, los 365 días del año**.
- Transportan automóviles, SUV, camionetas, furgones, camiones livianos y diversos tipos de maquinaria industrial o agrícola; también describen capacidad para vehículos pesados.
- Ofrecen traslados de emergencia y servicios programados.
- Mencionan convenios comerciales para talleres y empresas.
- Formas de pago declaradas: efectivo, transferencia, tarjetas de débito y crédito.
- Mencionan seguros de carga vigentes y descuentos para traslados de múltiples vehículos.
- Indican un tiempo de espera promedio de **30 a 45 minutos en la Región Metropolitana**, sujeto a condiciones externas.

**Importante:** Estos son contenidos declarados en la presentación, no especificaciones técnicas verificadas. Antes de publicarlos, validar su vigencia y redacción con el cliente. La presentación menciona precio “en tiempo real” y también un correo enviado “en unos minutos”; se debe definir si el precio aparece inmediatamente en pantalla, si llega por correo, o ambas cosas.

## 4. Arquitectura de información / páginas

### Página Inicio (`/`)
Proponer estas secciones, con diseño adaptable a móviles:
1. **Encabezado**: logo, navegación Inicio / Cotizar / Contacto y acceso destacado a Cotizar.
2. **Hero**: presentación breve y clara de Shark Grúas, propuesta de valor y botones **Cotizar traslado** y **Contactar**.
3. **Sobre la empresa**: descripción y enfoque en seguridad, atención y experiencia (sin inventar años de trayectoria).
4. **Servicios**: categorías de traslados, explicadas de forma sencilla.
5. **Cobertura**: base en RM, alcance regional declarado, y aclaraciones sobre disponibilidad según ubicación.
6. **Por qué elegirnos**: solo ventajas que el cliente haya confirmado.
7. **Preguntas frecuentes**: acordeón accesible con preguntas relevantes de la presentación; resumir y agrupar las largas listas de comunas cuando convenga.
8. **Contacto**: canales reales una vez entregados (WhatsApp, teléfono, correo), llamadas a la acción y pie de página.

El **formulario de cotización no debe aparecer en Inicio**; solo botones/enlaces a `/cotizar`.

### Página Cotizador (`/cotizar`)
Crear una experiencia guiada que permita recopilar datos, calcular y mostrar una tarifa **automática**. Campos preliminares a validar con el negocio:
- Origen del traslado (dirección o lugar seleccionable).
- Destino del traslado.
- Tipo de vehículo o maquinaria.
- Cantidad de unidades.
- Fecha y hora solicitadas.
- Tipo de servicio (programado o emergencia), si influye en disponibilidad/precio.
- Nombre, teléfono y correo del solicitante.
- Información adicional relevante (observaciones).

Comportamiento esperado:
1. Validar campos y mostrar errores útiles.
2. Obtener distancia/ruta por carretera **solo cuando se elija y configure un proveedor de mapas**.
3. Calcular el precio **en el servidor**, usando reglas y tarifas configuradas y verificadas; jamás confiar en un importe remitido por el navegador.
4. Mostrar total y desglose entendible si las reglas lo permiten.
5. Guardar la solicitud y el resultado de la cotización en Supabase.
6. Confirmar al cliente el registro y, cuando estén configuradas las integraciones, enviar correo o notificación mediante n8n.
7. Manejar errores de geocodificación, ubicaciones fuera de cobertura, ausencia de una tarifa aplicable y fallos de conexión sin mostrar precios inventados.

**No simular cotizaciones como si fueran reales.** Mientras falten reglas comerciales, usar un módulo de cálculo desacoplado con estado explícito de “pendiente de configuración”; si se crean mocks para desarrollo, marcarlos como datos de prueba y no mostrarlos como cotizaciones definitivas.

### Panel administrativo — fase posterior
Fuera del alcance inicial. Posibles capacidades futuras: autenticación, listado y filtros de cotizaciones, estados, clientes y administración de tarifas. Diseñar la base de datos para permitir su ampliación sin implementar ahora el panel.

## 5. Stack y responsabilidades
- **Next.js + TypeScript**: interfaz, navegación, validación y endpoints/acciones seguras para operaciones del servidor.
- **Vercel**: despliegue de la aplicación y variables de entorno.
- **Supabase**: PostgreSQL para clientes, solicitudes, cotizaciones y eventualmente reglas tarifarias; establecer políticas de seguridad y acceso mínimo.
- **n8n**: automatización de mensajes y procesos a partir de eventos de cotización; usar un mecanismo seguro para activar los flujos y evitar duplicaciones.
- **Proveedor de mapas/rutas por definir**: geocodificación, ruta real y distancia si el precio depende de kilómetros de viaje.

Nunca exponer claves de servicio de Supabase, credenciales de n8n ni secretos de proveedores externos al navegador. No enviar datos personales a servicios no autorizados.

## 6. Modelo de datos inicial (propuesta, sujeto a validación)
Separar, al menos conceptualmente:
- `customers`: id, nombre, correo, teléfono, fecha de creación.
- `quote_requests`: id, customer_id, origen/destino, tipo de vehículo, cantidad, fecha solicitada, observaciones, estado, fecha de creación.
- `quotes`: id, request_id, moneda, subtotal, recargos, descuentos, total, distancia usada, versión de regla tarifaria, fecha de cálculo, vigencia (si aplica).
- `pricing_rules` (futuro o necesario para motor): tipo de servicio/vehículo, tarifa base, precio/km, mínimos, recargos, descuentos, vigencia.

El esquema definitivo debe adaptarse a las reglas comerciales reales. Prever consentimiento/aviso de privacidad y protección de datos personales, junto con controles antispam y límites de solicitudes.

## 7. Reglas comerciales PENDIENTES — bloqueo del cotizador real
Solicitar al negocio antes de activar cálculos reales:
1. Tarifa base por categoría de vehículo y tipo de grúa.
2. Valor por kilómetro y **qué distancia se cobra** (origen-destino, ida de grúa, retorno, etc.).
3. Precio mínimo, zonas de cobertura, zonas excluidas y tratamiento de viajes largos.
4. Recargos por horario, urgencia, peajes, carga/descarga, condiciones del vehículo u otros.
5. Descuentos por múltiples vehículos y cómo se aplican.
6. Impuestos, moneda, redondeo, vigencia del presupuesto y tratamiento de disponibilidad.
7. Casos que deben derivarse a evaluación manual (maquinaria especial, vehículos pesados, rutas complejas).
8. Si el precio se muestra en pantalla, se envía por correo o ambas cosas; y si constituye oferta vinculante o estimación.
9. Datos de contacto oficiales, identidad visual, logo, fotografías y dominio.

## 8. Fases de implementación
**Fase 1 — MVP público**
- Inicio responsive con contenidos aprobados, FAQ y llamadas a la acción.
- Página separada `/cotizar`.
- Formulario funcional y validado.
- Persistencia segura en Supabase.
- Motor de tarifas configurable **una vez recibidas las reglas**.
- Envío de notificaciones con n8n una vez configurado.
- Publicación en Vercel, revisión SEO básico, accesibilidad y pruebas.

**Fase 2 — Evolución**
- Panel administrativo privado para cotizaciones/clientes y estados.
- Gestión de tarifas mediante interfaz.
- Mejoras de automatización, reportes y otras funcionalidades aprobadas.
- Club de referidos: **no planificar ni implementar hasta nueva indicación**.

## 9. Criterios de aceptación sugeridos para Fase 1
- Inicio y cotizador cargan y funcionan en móvil y escritorio.
- Desde Inicio es fácil llegar a `/cotizar`.
- Preguntas frecuentes se pueden expandir y contraer correctamente.
- El formulario valida campos obligatorios y formatos.
- El servidor calcula la tarifa usando reglas verificadas, o informa claramente que aún no está disponible.
- Las solicitudes se almacenan una sola vez, sin exposición pública de datos.
- Se informa del éxito o error del registro de forma comprensible.
- Las notificaciones no se duplican en reintentos normales.
- No hay credenciales en el repositorio ni secretos expuestos al cliente.

## 10. Indicaciones de trabajo para Codex
1. Revisar primero el repositorio; si está vacío, proponer una estructura Next.js + TypeScript limpia y mantenible.
2. Implementar por componentes reutilizables; priorizar una interfaz clara, rápida, accesible y móvil.
3. Mantener **contenido**, **lógica de negocio/tarifas**, **persistencia** e **integraciones** separados.
4. No inventar nombres, teléfonos, correos, tarifas, fotos o testimonios reales.
5. Señalar supuestos y aspectos pendientes de aprobación, especialmente tarifas y operación del cotizador.
6. Preparar un `.env.example` sin valores secretos reales y un README con instrucciones locales.
7. No implementar el panel administrativo ni el club de referidos en esta fase.

---
**Referencia de negocio:** presentación facilitada por el cliente, `PPT SHARK GRÚAS.pptx`. Este documento resume las decisiones del proyecto y la información utilizable de esa presentación; ante conflictos, solicitar confirmación del responsable del negocio.
