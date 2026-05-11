# Agentes con LangGraph

Guía práctica para construir agentes inteligentes con LangChain y LangGraph. Cada sección cubre un concepto fundamental con ejemplos concisos.

---

## Cómo construir agentes inteligentes con LangGraph

LangGraph permite orquestar agentes como grafos de nodos. Ejecuta el servidor de desarrollo con `langgraph dev --tunnel`.

### Agente básico con tool de clima

```python
from langchain.agents import create_agent
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI

@tool
def get_weather(city: str):
    """Returns the weather for a given city."""
    return f"The weather in {city} is sunny."

llm = ChatOpenAI(model="deepseek-v4-flash", openai_api_base="https://api.deepseek.com")
agent = create_agent(llm, [get_weather])
```

### Visualizar el grafo del agente

```python
from IPython.display import Image, display
display(Image(agent.get_graph().draw_mermaid_png()))
```

---

## Configuración de entorno Python y primer agente con LangGraph

### Inicializar proyecto con uv

```bash
uv init
```

### Agregar dependencias

```bash
# Producción
uv add langchain-openai langchain-anthropic

# Desarrollo
uv add --dev langgraph jupyter
```

### Ejecutar con uv

```bash
uv run
```

---

## Configuración de uv para escalar agentes de IA en producción

`uv` centraliza gestión de dependencias en `project.toml`, siendo 10x más rápido que pip.

### Estructura de carpetas recomendada

```
CDC/
├── agents/
│   ├── __init__.py
│   └── main.py
├── api/
│   └── __init__.py
└── notebooks/
    └── __init__.py
```

### Configuración de project.toml

```toml
[tool.setuptools.packages.find]
where = ["."]
```

### Buenas prácticas

- Ignorar carpetas internas y `.env` en `.gitignore`
- Separar dependencias de producción vs desarrollo
- Usar `__init__.py` en subcarpetas para paquetes Python

---

## Cómo funciona el estado compartido en LangGraph

El **estado** es un diccionario tipado (`TypedDict`) compartido entre todos los nodos del grafo.

### Definición de estado

```python
from typing import TypedDict

class State(TypedDict):
    customer_name: str
    my_age: int
```

### Acceso seguro al estado

```python
state: State = {}
print(state.get("customer_name"))           # None si no existe
name = state.get("customer_name", "default")  # con fallback
```

### Nodos que actualizan estado

```python
def node_1(state: State):
    if state.get("customer_name") is None:
        return {"customer_name": "John Doe", "my_age": 20}
    return {}  # No modifica nada si ya existe el nombre
```

### Construcción del grafo

```python
from langgraph.graph import StateGraph, START, END

builder = StateGraph(State)
builder.add_node("node_1", node_1)
builder.add_edge(START, "node_1")
builder.add_edge("node_1", END)
agent = builder.compile()
```

### MessagesState para historial automático

```python
from langgraph.graph import MessagesState

class State(MessagesState):
    customer_name: str
    my_age: int
```

### Puntos clave

- Nodo = función que recibe estado y devuelve solo los cambios
- Usar `get()` para evitar `KeyError`
- `MessagesState` agrega campo `messages` automáticamente

---

## Gestión de historial de mensajes en LangGraph

LangChain ofrece tipos de mensajes para estructurar conversaciones.

### Tipos de mensajes

```python
from langchain_core.messages import AIMessage, HumanMessage, SystemMessage

ai_msg = AIMessage(content="Message from the AI")
h_msg = HumanMessage(content="Message from a Human")
```

### Concatenación correcta de listas

```python
# Correcto
history = [human_msg]
new_ai = AIMessage(content="Entendido.")
history = history + [new_ai]  # Lista + Lista

# Incorrecto - Error
# history = history + new_ai  # No puedes sumar objeto directo
```

### Nodo que agrega mensajes al historial

```python
def simple_node(state):
    customer = state.get("customer_name")
    
    if not customer:
        return {"customer_name": "Nicolás Molina"}
    
    return {
        "messages": [AIMessage(content="Hola, ¿en qué más te ayudo?")]
    }
```

### Puntos clave

- `messages_stage` concatena sin sobrescribir historial
- Usar `prettyprint()` para depurar mensajes
- El estado garantiza que siempre recibes un array

---

## Integración de modelos OpenAI y Anthropic con LangChain

Arquitectura agnóstica: cambia de proveedor sin reescribir código.

### Configuración con .env

```python
from dotenv import load_dotenv
load_dotenv()
assert os.getenv("OPENAI_API_KEY") is not None
```

### ChatOpenAI básico

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0.7)
response = llm.invoke("Hola, ¿cómo estás?")
print(response.text)
```

### ChatAnthropic

```python
pip install -U langchain-anthropic --pre

from langchain_anthropic import ChatAnthropic
llm = ChatAnthropic(model="claude-sonnet-4", temperature=0.7)
```

### API agnóstica con init_chat_model

```python
from langchain import init_chat_model

llm = init_chat_model(
    model="gpt-4",
    model_provider="openai",  # cambiar a "anthropic" sin reescribir lógica
    temperature=0.3
)
```

### Envío de historial de chat

```python
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage

history = [
    SystemMessage(content="Eres un asistente útil."),
    HumanMessage(content="Me llamo Juan."),
    AIMessage(content="Hola Juan, ¿cómo estás?"),
]
response = llm.invoke(history)
```

---

## Integración de LLM en grafos para agentes que razonan

Inyecta un LLM en el grafo para que los nodos **decidan, ramifiquen y hagan ciclos**.

### Nodo con memoria y mensajes

```python
import random

def node1(state):
    new_state = {}
    
    if not state.get("customer_name"):
        new_state["customer_name"] = "John Doe"
    else:
        new_state["my_age"] = random.randint(18, 80)
    
    history = state.get("messages", [])
    ai_reply = {"role": "ai", "content": "Hola, estoy aquí para ayudarte."}
    new_state["messages"] = history + [ai_reply]
    
    return new_state
```

### Conceptos clave

- **Memoria por hilo**: el estado persiste mientras uses el mismo `thread_id`
- **new_state**: consolida cambios antes de retornarlos
- **Unión de arrays**: `history + [nuevo_mensaje]`

---

## RAG con OpenAI file search para consultar PDFs

RAG sencillo usando la tool `file_search` de OpenAI para consultar PDFs subidos.

### Configuración de file search

```python
vector_store_ids = ["vs_XXXXXXXX"]

tools = [
    {
        "type": "file_search",
        "vector_store_ids": vector_store_ids
    }
]

llm = LLM(provider="openai", tools=tools)
```

### Envío de último mensaje (evitar errores de contexto)

```python
last_message = history[-1].text
response = llm.invoke(user_input=last_message)
```

### Pasos para configurar

1. Crear vector store en OpenAI Dashboard > Storage
2. Subir PDFs al vector store
3. Copiar el ID del vector store
4. Integrar en el código con `file_search`

---

## Prompt chaining: encadenar agentes en secuencia con LangGraph

Conecta nodos en secuencia donde cada uno realiza una tarea específica.

### Secuencia básica

```python
builder.add_edge("node_one", "node_two")
builder.add_edge("node_two", "node_three")
```

### Alternativa compacta

```python
builder.add_sequence([node_one, node_two, node_three])
```

### Cuándo usar chaining vs chain of thought

| Chaining | Chain of Thought |
|----------|-------------------|
| Pasos con alta carga cognitiva | Tareas simples |
| Integración con servicios externos | Un solo prompt puede resolverlo |
| Modelos diferentes por paso (ej: DALL-E) | Más económico en llamadas |

---

## 10. Respuestas estructuradas en LLMs para agentes

Fuerza al LLM a devolver JSON válido con schema definido.

### Schema con Pydantic

```python
from pydantic import BaseModel, Field
from typing import List

class Aspirant(BaseModel):
    name: str = Field(description="The full name of the aspirant")
    base_technical_skills: List[str] = Field(description="Technical skills")
    ideal_role: str = Field(description="The ideal role seeking")
    years_of_experience: int = Field(description="Years of experience")
    psicological_traits: List[str] = Field(description="Psychological traits")
```

### Configurar structured output

```python
llm_with_structured_output = llm.with_structured_output(schema=Aspirant)
response = llm_with_structured_output.invoke(messages)
```

### Errores comunes

- **Alucinación de datos**: pedir "si no encuentras, no inventes"
- **Validaciones estrictas**: usar `str | None` en vez de tipos rígidos
- **Prompt claro**: recordar que no es chat, es extracción

---

## 11. Organización de código en LangGraph para sistemas complejos

Refactoriza hacia arquitectura modular: **cada agente = carpeta**.

### Estructura recomendada

```
agents/
├── support/
│   ├── __init__.py
│   ├── state.py          # estado del mensaje
│   ├── agent.py          # construcción del grafo
│   └── nodos/
│       ├── extractor/
│       │   ├── node.py
│       │   └── prompt.py
│       └── conversation/
│           ├── node.py
│           ├── prompt.py
│           └── tools.py
```

### Prompt por nodo

```python
# extractor/prompt.py
SYSTEM_PROMPT = """Tú eres un asistente que extrae información de una conversación."""
```

### Nodo autocontenido

```python
# conversation/node.py
def configure_conversation_node(llm):
    llm_with_tools = llm.bind_tools(tools)
    return {"llm": llm_with_tools, "system_prompt": SYSTEM_PROMPT}
```

---

## 12. Prompts dinámicos con LangChain y templates condicionales

Gestiona prompts como plantillas, no como strings concatenados.

### Template básico

```python
from langchain.prompts import PromptTemplate

template = """\
Instrucciones:
- Sigue el rol indicado.
Fecha actual: {fecha_actual}
Texto: {texto_anuncio}
"""

prompt_tmpl = PromptTemplate(template=template)
prompt_final = prompt_tmpl.format(
    fecha_actual="2024-05-01",
    texto_anuncio="Lanza tu producto con 20% de descuento."
)
```

### Partial variables (autocompletado)

```python
from datetime import date

prompt_tmpl = PromptTemplate(
    template=template,
    partial_variables={"fecha_actual": lambda: date.today().isoformat()}
)
```

### Templates condicionales con Jinja2

```bash
pip install jinja2
```

```python
from langchain.prompts import PromptTemplate

rag_template = """\
Eres un asistente que responde al usuario.
{% if name -%}
El cliente se llama {{ name }}.
{%- endif %}
Mensaje: {{ user_message }}
"""

prompt_tmpl = PromptTemplate(
    template=rag_template,
    input_variables=["user_message", "name"],
    template_format="ninja_two"
)
```

---

## 13. Patrón ReAct para agentes que razonan y ejecutan tools

**ReAct = Reason + Act**: integra razonamiento y ejecución en un bucle iterativo.

### Flujo del patrón

1. Agente recibe prompt + historial
2. Evalúa si necesita tools
3. Invoca tool y observa resultado
4. Decide si continuar o finalizar

### Modelos recomendados

| Proveedor | Modelos con razonamiento |
|-----------|-------------------------|
| OpenAI | o1, o3, o1-mini, o4-mini |
| Google | Gemini 2.5 Pro Thinking |
| Anthropic | Claude Opus 4.1, Claude Sonnet 4 |

### Puntos clave

- Controla bucles con máximo de iteraciones (evitar ciclos infinitos)
- No depende del proveedor: define tus propias tools
- Combina `create_agent` (LangChain) con grafos (LangGraph)

---

## 14. Implementación de Tools en ReAct Agents con LangChain Core

Las tools son funciones que el modelo invoca para actuar, no el modelo ejecuta.

### Definición de tools

```python
from langchain_core.tools import tool

@tool
def get_products(category: str = None, min_price: int = None) -> str:
    """Obtiene lista de productos del inventario.
    
    Args:
        category: Categoría del producto
        min_price: Precio mínimo como entero
    """
    # Llamada a API real
    products = api.get_products(category=category, min_price=min_price)
    
    # Formatear respuesta en texto
    result = []
    for p in products:
        result.append(f"{p['title']} - ${p['price']}")
    
    return "\n".join(result)
```

### Conexión al LLM

```python
llm_with_tools = llm.bind_tools([get_products])
```

### Flujo completo

1. Usuario envía request
2. Modelo identifica tool y extrae parámetros
3. Tool se ejecuta en la capa de aplicación
4. Resultado vuelve al modelo
5. Modelo interpreta y responde

### Puntos clave

- La tool ejecuta en tu aplicación, no en el modelo
- Devolver texto formateado, no arrays
- Conectar APIs reales evita alucinaciones

---

## 15. Integración de tools con LLM y manejo de respuestas estructuradas

Combina tools + structured output para agentes que actúan y responden con formato fijo.

### Integrar extractor en agente

```python
# Nodo extractor con structured output
extractor_llm = ChatAnthropic(model="claude-opus-4")
structured_llm = extractor_llm.with_structured_output(ContactInfo)

def extractor_node(state):
    response = structured_llm.invoke(state["messages"])
    return {
        "customer_name": response.name,
        "email": response.email,
        "phone": response.phone,
    }
```

### Lógica de disparo

```python
def should_extract(state):
    return state.get("customer_name") is None or len(state["messages"]) > 10
```

### Puntos clave

- Mantener LLM conversacional separado del extractor
- Guardar en estado compartido para uso en otros nodos
- Evitar llamadas innecesarias si ya se obtuvo el dato


## Enrutamiento de Agentes con Conditional Edge en LangGraph

El **routing** permite que un agente elija el siguiente paso sin seguir un camino rígido, bifurcando el flujo según contexto.

### Nodos vs Edges

| Componente | Rol |
|------------|-----|
| **Nodos** | Actualizan estado y persisten en memoria compartida |
| **Edges** | Solo derivan hacia otros nodos, no modifican estado |
| **Conditional Edge** | Devuelve destinos posibles según lógica |

### Decisiones de enrutamiento

El routing puede basarse en:
- Lógica programada
- Datos en memoria compartida
- Salida del LLM
- Umbral aleatorio (random threshold)

### Implementación de conditional edge

```python
def route_edge(state: State):
    if condition:
        return 'node_2'
    return 'node_3'
```

### En el builder

```python
builder.add_conditional_edges('node_1', route_edge)
```

### Puntos clave

- El edge **accede** al estado pero **no lo actualiza**
- El nodo es el único responsable de persistir cambios
- Start puede conectarse directamente a un conditional edge
- Si el routing evalúa intención desde el inicio, no necesitas un nodo intermedio

### Reto sugerido

- Derivar a 4 nodos en vez de 3
- Reemplazar random por reglas basadas en memoria
- Colocar routing en nodos intermedios

---

## Routing Inteligente con LLM para Derivar Conversaciones

Un router con **structured output** permite que el agente decida dinámicamente a qué nodo enviar cada mensaje.

### Arquitectura del flujo

```
Inicio → Extractor → Intent Route → Conversation | Booking → End
                                   └ LLM decide
```

### Definición del schema de decisión

```python
from typing import Literal
from pydantic import BaseModel

class IntentDecision(BaseModel):
    step: Literal["conversation", "booking"] | None = None

SYSTEM_PROMPT = (
    "Eres un asistente que enruta al paso adecuado: "
    "'conversation' para preguntas generales, "
    "'booking' si el usuario habla de citas o appointments."
)
```

### Función de enrutamiento

```python
def intent_route(messages, llm):
    decision = llm.with_structured_output(schema=IntentDecision)([
        {"role": "system", "content": SYSTEM_PROMPT},
        *messages
    ])
    if decision and decision.step:
        return decision.step
    return "conversation"  # valor por defecto
```

### Estructura de proyecto recomendada

```
agents/
├── nodes/
│   ├── conversation/
│   ├── extractor/
│   └── booking/          # subgrafo React
└── routes/
    ├── __init__.py
    ├── route.py
    └── prompt.py
```

### Errores comunes y correcciones

| Error | Corrección |
|-------|------------|
| Nombre de módulo mal escrito | Verificar nombre exacto del nodo |
| Condición lógica invertida | Usar `is not None` en vez de `is None` |
| Prompt muy específico | Usar términos generales (ej: "appointments") |
| Sin visibilidad al debug | Imprimir el schema devuelto + LangSmith |

### Pruebas recomendadas

- **Mensaje casual**: "Hola, ¿cómo estás?" → Conversation
- **Petición de cita**: "Quiero cita para mañana con el Dr. Pérez" → Booking
- **Pregunta técnica**: "Cómo mejorar rendimiento de un website" → Conversation + RAG

### Buenas prácticas

- Usar historial completo en el router para mayor precisión
- Incluir few-shot en el system prompt para desambigar
- Para clasificación simple, LLM sin razonamiento puede bastar
- Para booking con React, usar modelo con mejor razonamiento

---

## Paralelización de Nodos en Agentes con LangGraph

La **paralelización** ejecuta varios nodos simultáneamente, dividiendo el problema en pasos independientes.

### Diferencias con otros patrones

| Patrón | Comportamiento |
|--------|----------------|
| **Chaining** | Un nodo tras otro, secuencial |
| **Routing** | Elige uno u otro, nunca ambos |
| **Paralelización** | Ejecuta varios nodos a la vez |

### Implementación

```python
# Desde node_1, disparar a node_2 y node_3 en paralelo obligatoriamente
builder.add_edge("node_1", "node_2")
builder.add_edge("node_1", "node_3")

# Ambos convergen en el aggregator
builder.add_edge("node_2", "aggregator")
builder.add_edge("node_3", "aggregator")
builder.add_edge("aggregator", END)
```

### Por qué es crítico el Aggregator

El aggregator impide respuestas duplicadas. Si los nodos paralelos finalizaran solos, el agente intentaría responder dos veces. El aggregator:
- Espera a que todos terminen
- Recopila salidas
- Produce una única respuesta final

### Visualización ASCII

- **Línea sólida**: camino obligatorio
- **Línea punteada**: camino condicional

### Iniciando desde Start

```python
# Start dispara varios nodos a la vez
builder.add_edge(START, "node_1")
builder.add_edge(START, "node_2")
builder.add_edge(START, "node_3")
# Todos convergen en aggregator
```

### Puntos clave

- La salida final debe ser **una sola**: el end
- Todos los caminos paralelos deben converger en un único aggregator

---

## Patrón Orchestrator para Selección Dinámica de Nodos

El **orchestrator** elige dinámicamente qué nodos ejecutar según el contexto, superando la paralelización fija.

### Cómo supera a otros patrones

| Patrón | Selección |
|--------|-----------|
| Paralelización | Siempre ejecuta todos |
| Routing | Ejecuta uno u otro |
| **Orchestrator** | Selecciona dinámicamente: uno, dos o tres |

### Decisión del orchestrator

```python
import random

def orchestrator(state: dict) -> dict:
    posibles = [
        ["nodo_1"], ["nodo_2"], ["nodo_3"],
        ["nodo_1", "nodo_2"], ["nodo_2", "nodo_3"],
        ["nodo_1", "nodo_3"], ["nodo_1", "nodo_2", "nodo_3"]
    ]
    elegidos = random.choice(posibles)
    state["nodos"] = elegidos
    return state
```

### Envío en paralelo con send

```python
from langgraph.constants import Send

def asignar_nodos(state: dict):
    return [
        Send(nodo, {}) for nodo in state.get("nodos", [])
    ]
```

### Casos de uso ideales

- Solicitudes largas con múltiples subtareas en un mensaje
- Escenarios multimodales (imagen + voz + texto)
- Tareas donde distintas herramientas deben coordinarse

### Consideraciones prácticas

- No es routing (pueden ejecutarse varios)
- No es paralelización fija (la lista es dinámica)
- El aggregator debe consolidar solo resultados disponibles

---

## Evaluator Optimizer: Ciclos de Autocrítica para Agentes

El patrón **Evaluator Optimizer** crea un ciclo de mejora donde un generador produce y un evaluador juzga hasta que la respuesta pasa los criterios.

### Flujo del patrón

```
Generator → Evaluator → ¿Pasa criterios? → End
                ↑                              ↓
                └──── Feedback + Reintento ←────┘
```

### Componentes

| Componente | Rol |
|------------|-----|
| **Generator** | Produce respuesta inicial con LLM |
| **Evaluator** | Aplica criterios y devuelve veredicto |
| **Loop** | Reintenta con feedback si falla |

### Schema de evaluación

```python
from pydantic import BaseModel

class EvaluationResult(BaseModel):
    es_gracioso: bool
    feedback: str  # instrucciones para mejorar
```

### Ejemplo: generador de chistes

```python
def evaluator_node(state):
    # Evalúa con temperatura 0 para consistencia
    evaluator_llm = init_chat_model(temperature=0)
    structured = evaluator_llm.with_structured_output(EvaluationResult)

    chiste = state.get("chiste_actual", "")
    evaluacion = structured.invoke(
        f"Evalúa si este chiste es gracioso:\n\n{chiste}"
    )

    return {
        "es_gracioso": evaluacion.es_gracioso,
        "feedback": evaluacion.feedback
    }
```

### Routing edge para el ciclo

```python
def routing_edge(state: State):
    if state.get("es_gracioso"):
        return "END"
    return "generator"  # reintentar
```

### Criterios configurables

Definidos en el prompt del Evaluador:
- Longitud mínima (ej: más de dos párrafos)
- Calidad percibida (booleano)
- Feedback accionable para siguiente intento

### Configuración de temperatura

| Nodo | Temperatura | Razón |
|------|-------------|-------|
| Generator | 1 | Variedad y creatividad |
| Evaluator | 0 | Consistencia en evaluación |

### Puntos clave

- El Evaluador escribe veredicto + feedback en el state
- El Generator usa el feedback del state para reintentar
- Criterios claros en el prompt del Evaluador = decisiones determinísticas
- El ciclo termina cuando se cumplen todos los criterios

### Habilidades practicadas

- Diseño de ciclos de mejora automática
- Routing edge y conditional edge para control de flujo
- Structured output para evaluación determinística
- Prompt engineering para criterios y reintentos
- Gestión de estado para pasar feedback entre nodos

---

## Checkpointers de LangGraph para Persistir Estado en Postgres

Los **checkpointers** permiten guardar el estado de la conversación en Postgres, evitando que el agente "olvide" cada interacción.

### ¿Por qué necesitas un checkpointer?

| Sin Checkpointer | Con Checkpointer |
|------------------|------------------|
| Cada pregunta empieza de cero | Recupera historial y memoria |
| No recuerda al usuario | Persiste estado por thread ID |
| Incompatible con endpoints reales | Estado guardado en base de datos |

El checkpointer crea un **snapshot** del diálogo, lo asocia a un `thread_id` y lo persiste para restaurar: mensajes, memoria compartida y nodo actual.

### Bases de datos soportadas

| Tipo | Estado |
|------|--------|
| **Postgres** | Oficialmente mantenido (recomendado) |
| SQLite | Oficialmente mantenido |
| Dynamo, Firestore, Django | Integraciones de comunidad |

### Instalación y configuración

```bash
# Instalar librería del checkpointer
uv add langgraph-checkpoint-postgres

# Levantar Postgres con Docker
docker compose up -d

# Verificar servicios activos
docker compose ps
```

### Configuración del agente con checkpointer

```python
from langgraph.checkpoint.postgres import PostgresSaver
from langgraph.graph import StateGraph, START, END

# Crear conexión a Postgres
checkpointer = PostgresSaver.from_conn_string(
    "postgresql://user:password@localhost:5432/dbname"
)

# Compilar con checkpointer
builder = StateGraph(State)
# ... agregar nodos ...
agent = builder.compile(checkpointer=checkpointer)
```

### Uso con thread ID

```python
# Cada usuario tiene su propio thread
config = {"configurable": {"thread_id": "usuario_123"}}

# El agente recupera el estado previo automáticamente
response = agent.invoke({"messages": [("user", user_input)]}, config)
```

### Políticas de thread ID

| Política | Descripción | Caso de uso |
|----------|-------------|-------------|
| **1:1** | Usuario → un solo thread | Historial completo, pero contexto crece |
| **Caducidad por tiempo** | Nuevo thread si pasan 24h/48h/semana | Reinicia contexto periódicamente |
| **Por objetivo** | Finaliza cuando se resuelve la solicitud | Como un call center |
| **Concurrencia** | Múltiples threads por usuario | Aislar sesiones simultáneas |

### Puntos clave

- El `thread_id` identifica la conversación y qué estado cargar
- Cambiar el ID = empezar hilo nuevo; reutilizar = continuar
- Postgres recomendado por fiabilidad
- El checkpointer persiste **todo**: mensajes, estado, nodo actual

### Casos de uso

- Endpoints de producción donde el estado debe persistir
- Múltiples usuarios simultáneos sin interferencia
- Recuperación ante fallos sin perder contexto


```python
@app.post("/chat/{chat_id}")
async def chat(chat_id: str, item: Message):
    config = {
        "configurable": {
        "thread_id": chat_id
        }
    }
    human_message = HumanMessage(content=item.message)

    response = agent.invoke({"messages": [human_message]}, config)
    last_message = response["messages"][-1]

    return last_message. text
```

---

## Configuración de Checkpointer Dinámico con FastAPI y Postgres

Conecta tu agente a una base de datos y preserva el historial sin dolores de cabeza. Aquí verás cómo construir un grafo con checkpointer dinámico, inicializarlo con FastAPI y Postgres, inyectar dependencias, y evitar que el contexto se corrompa al guardar solo lo esencial. Además, se señalan errores reales y cómo depurarlos con LangGraph Studio.

### ¿Cómo crear un checkpointer dinámico con FastAPI y Postgres?

Para que el agente recuerde y comparta estado, la configuración debe ser dinámica. La clave es recibir el checkpointer desde la app web y no quemarlo en el build del agente.

### ¿Cómo definir la función makegraph con configuración dinámica?

Define una función que construya el grafo y reciba un config con el checkpointer. Envía el checkpointer al construir el agente.

```python
from typing import TypedDict, Optional

class GraphConfig(TypedDict, total=False):
    checkpointer: object  # instancia del checkpointer

def makegraph(config: GraphConfig):
    checkpointer = config.get("checkpointer", None)
    # construir el agente/grafo usando el checkpointer dinámico
    agent = build_agent(checkpointer=checkpointer)  # función de construcción existente
    return agent
```

Ventaja: permite seguir usando LangGraph Studio para debug (si no pasas checkpointer, usarán uno propio) y, a la vez, integrarlo bien con FastAPI.

### ¿Cómo inicializar la conexión en el lifespan de FastAPI?

Crea una instancia global para el checkpointer de Postgres. Inicializa antes de levantar la app con lifespan y ejecuta el setup para las tablas del estado. Evita credenciales quemadas; usa variables de ambiente.

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI

checkpointer_global = None  # instancia global

@asynccontextmanager
async def lifespan(app: FastAPI):
    global checkpointer_global
    # ejemplo: lee de env en la práctica (aquí simplificado)
    dsn = "postgresql+psycopg://user:password@localhost:5432/db"
    checkpointer_global = PostgresCheckpointer(dsn)
    await checkpointer_global.setup()  # crea tablas para estado del grafo
    yield
    # opcional: cerrar conexiones

def get_checkpointer():
    if not checkpointer_global:
        raise RuntimeError("checkpointer no inicializado")
    return checkpointer_global
```

### ¿Cómo invocar el grafo desde el endpoint con dependencia?

Inyecta el checkpointer como dependencia. Construye el grafo con makegraph y pásale la instancia.

```python
from fastapi import FastAPI, Depends
from db import lifespan, get_checkpointer
from makegraph import makegraph

app = FastAPI(lifespan=lifespan)

@app.post("/chat")
async def chat_endpoint(payload: dict, checkpointer=Depends(get_checkpointer)):
    agent = makegraph({"checkpointer": checkpointer})
    state = {"messages": [payload.get("message")]}  # además de otros campos de estado
    result = await agent.invoke(state)
    return result
```

Tip: si usas el endpoint de stream, inyecta también la dependencia del checkpointer.

### ¿Cómo mantener limpio el estado y el historial del grafo?

El estado es memoria compartida. Si guardas metadatos ruidosos, el prompt y el routing se degradan. La solución: persistir solo el texto útil.

### ¿Qué guardar del AI message para no corromper el contexto?

Problema observado: guardar la respuesta con metadata y response completos ensucia el historial. Solución: parsear el AI message y almacenar solo el texto cuando trabajes con texto plano.

```python
# al producir la respuesta en el nodo de conversation
raw_ai_message = await conversation_node(...)  # respuesta del modelo
clean_text = raw_ai_message.content if hasattr(raw_ai_message, "content") else str(raw_ai_message)

# guardar solo clean_text en historial/DB
save_message({
    "role": "ai",
    "content": clean_text,
})
```

Beneficio: el language model recibe contexto claro. Evitas errores en system history y routing.

### ¿Cómo usar thread ID, CRUD y memoria compartida de forma segura?

Cada conversación usa un thread ID. Si cambias el thread ID, inicias otra memoria desde cero.

Guarda entrada y salida: add_message del usuario y también de la AI con su chat ID. Puedes reconstruir el estado desde la base: cargas historial y lo inyectas como state junto a campos como customer_name. Si un thread quedó sucio, crea uno nuevo y continúa con historial limpio.

### Buenas prácticas

- Persistir mensajes con CRUD simple
- Asociar por chat ID
- Evitar metadata innecesaria en el historial

### ¿Cómo depurar errores frecuentes con LangGraph Studio y el API?

La depuración combina impresión rápida, revisión del historial y ajuste del routing. Estos fueron fallos típicos y su enfoque.

### ¿Qué hacer ante internal server error e invalid request?

Verifica que ya no invocas al agente directo: usa makegraph con checkpointer en el endpoint. Imprime el último message para validar formato de entrada. Aunque no es lo ideal, un print veloz ayuda a aislar el problema. Revisa si el error proviene del extractor y no del nodo de conversación. Ajusta esa etapa primero.

### ¿Cómo revisar system history y routing con LangGraph Studio?

Usa LangGraph Studio para ejecutar la función constructora del grafo y ver el system history. Imprime el historial y valida que no contenga metadatos no deseados. Si el primer thread se creó sin checkpointer, puede haber historial viejo. Crea un thread nuevo y prueba.

### ¿Cómo optimizar el flujo con booking e intent route?

El booking (creative rig agent) comparte estado completo y suele manejar mejor el historial limpio. Si el rack de OpenAI solo toma el último mensaje, ajusta el prompt o define un custom rack según el caso. Guía con intent route hacia el agente correcto cuando el usuario pida acciones como citas médicas.

### Señales de mejora

- Evitar búsquedas a file search para preguntas simples
- Inyectar prompt con datos del usuario si corresponde
- Limpiar también la salida del agente de booking si añade metadata

