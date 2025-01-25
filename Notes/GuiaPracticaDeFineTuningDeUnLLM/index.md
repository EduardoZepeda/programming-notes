# Guia de fine-tuning para un LLM (Llama 3.2)

## Contexto para el LLM

Creamos un archivo CSV que nos servirá para dotar de contexto al modelo:

``` csv
Context,Response
"La empresa <nombre_de_empresa>", "La empresa <nombre_de_empresa> se dedica a ofrecer servícios y productos a empresas sobre informática corporativa como software de gestión, CRMs, ERPs, portales corporativos, eCommerce, formación, DevOps, etc."
"Servícios de DevOps, GitOps y MLOps","En <nombre_de_empresa> podemos ayudarte ha mejorar tus procesos de CI/CD con nuestros productos y servícios de DevOps."
"Desarrollo de aplicaciones corporativas","En <nombre_de_empresa> podemos ayudarte a digitalizarte con nuestros servícios de desarrollo de aplicaciones corporativas."
"Servícios de formación","En <nombre_de_empresa> te podemos entrenar y formar a múltiples áreas de la informática corporativa como desarrollo, Data, IA o DevOps."
"Tienda online","En <nombre_de_empresa> te podemos desarrollar una tienda online para vender por todo el mundo y mas allà."
"Producto eCommerce","En <nombre_de_empresa> te podemos desarrollar un eCommerce para vender por todo el mundo y mas allà."
```

## Instalación de unsloth

``` bash
virtualenv env
source env/bin/activate

pip install unsloth===2024.11.11
```

## 

``` python
from datasets import load_dataset
from trl import SFTTrainer
from transformers import TrainingArguments, DataCollatorForSeq2Seq
from unsloth import is_bfloat16_supported
from unsloth import FastLanguageModel
from unsloth.chat_templates import train_on_responses_only
import torch

# Replace the model accordingly
src_model = "unsloth/Llama-3.2-3B-Instruct"
new_model = "Llama-3.2-3B-trained"

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name = src_model,
    max_seq_length = 2048,
    dtype = None,
    load_in_4bit = True,
)

# Replace train CSV with your own file
dataset = load_dataset('csv', data_files='./train.csv')

def format_chat_template(row):
    """Specify the format according to the respective CSV file"""
    row_json = [
               {"role": "user", "content": row["Context"]},
               {"role": "assistant", "content": row["Response"]}
               ]
    
    row["text"] = tokenizer.apply_chat_template(row_json, tokenize=False)
    return row

dataset = dataset["train"].map(
    format_chat_template,
    num_proc= 4,
)

dataset = dataset.train_test_split(test_size=0.1)

model = FastLanguageModel.get_peft_model(
    model,
    r = 16,
    target_modules = ["q_proj", "k_proj", "v_proj", "o_proj",
                      "gate_proj", "up_proj", "down_proj",],
    lora_alpha = 16,
    lora_dropout = 0,
    bias = "none", 
    
    use_gradient_checkpointing = "unsloth", 
    random_state = 3407,
    use_rslora = False,
    loftq_config = None,
)

trainer = SFTTrainer(
    model = model,
    tokenizer = tokenizer,
    train_dataset=dataset["train"],
    eval_dataset=dataset["test"],
    dataset_text_field = "text",
    max_seq_length = 2048,
    data_collator = DataCollatorForSeq2Seq(tokenizer = tokenizer),
    dataset_num_proc = 2,
    packing = False, # Can make training 5x faster for short sequences.
    args = TrainingArguments(
        per_device_train_batch_size=2,
        per_device_eval_batch_size=2,
        gradient_accumulation_steps=4,
        eval_strategy="steps",
        eval_steps=0.2,
        warmup_steps = 5,
        # num_train_epochs = 1, # Set this for 1 full training run.
        max_steps = 60,
        learning_rate = 2e-4,
        fp16 = not is_bfloat16_supported(),
        bf16 = is_bfloat16_supported(),
        optim = "adamw_8bit",
        weight_decay = 0.01,
        lr_scheduler_type = "linear",
        seed = 3407,
        output_dir = "model_traning_outputs",
        report_to = "none",
    ),
)

trainer = train_on_responses_only(
    trainer,
    instruction_part = "<|start_header_id|>user<|end_header_id|>\n\n",
    response_part = "<|start_header_id|>assistant<|end_header_id|>\n\n",
)

trainer_stats = trainer.train()

print( trainer_stats )

model.save_pretrained(new_model)
tokenizer.save_pretrained(new_model)
```

Podemos probar el modelo ahora. Además es posible especificar las etiquetas especiales para detectarlas en la respuesta y responder de manera manual, pero personalizada.

``` python
import time
import torch
from transformers import pipeline

# This is the already trained model
model_id = "./Llama-3.2-3B-trained"
# model_id = "unsloth/Llama-3.2-3B-Instruct"

pipe = pipeline(
    "text-generation",
    model=model_id,
    torch_dtype=torch.bfloat16, 
    device_map="auto",
)

instruction = """Eres un asistente que me ayuda a responder a los clientes de la empresa <nombre_de_empresa>:
- <nombre_de_empresa> es una empresa dedicada a ofrecer servícios a empresas.
- Tu misión es ofrecer a los usuarios el producto o servicio de <nombre_de_empresa> perfecto para ellos.
- Responde solo '@SINAYUDA@' si no existe un producto o servício de <nombre_de_empresa> que se adapte a la respuesta.
- Responde solo '@SINCONTEXTO@' si la pregunta no está relacionada con la empresa o con informática corporativa.
- Responde solo '@ECOMMERCE@' si se está preguntando sobre temas de eCommerce o tiendas.
"""

def requestToLLM( i, instruction, req ):
    t = time.time()
    outputs = pipe(
        [
        { "role": "system", "content": instruction },
        { "role": "user", "content": req },
        ],
        max_new_tokens=256,
        temperature=0.9
    )
    t = time.time() - t
    print("\nPREGUNTA ", i,"(" + str(t) + "s.)\n" , outputs[0]["generated_text"][1]["content"] , "\n===================")
    print(outputs[0]["generated_text"][-1]["content"])

requestToLLM( 1, instruction, "De que va esto de la 'photosynthesis'?" )
requestToLLM( 2, instruction, "Como puedo mejorar?" )
requestToLLM( 3, instruction, "Necesito una tienda online" )
requestToLLM( 4, instruction, "Necesito vender online" )
requestToLLM( 5, instruction, "Como puedes ayudarme?" )
requestToLLM( 6, instruction, "Necesito un portal corporativo" )
requestToLLM( 7, instruction, "Que servícios de formación ofrecéis?" )
```

## Fuente del código
[Fine-tuning de Llama 3.2 de Alberto Coranado](https://www.albertcoronado.com/2024/12/10/fine-tuning-de-llama-3-2)