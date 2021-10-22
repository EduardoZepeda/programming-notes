Patrones de diseño en python
============================

Builder
-------

Este patrón consta de un director y un constructor. El constructor es responsable de crear varias partes del objeto complejo, el director controla el proceso de construcción usando una instancia del constructor.
La clase director tendrá un método para construir que será totalmente abstracto, su método get_constructed_object() retorna el objeto construido de su propio constructor.
Cada uno de los métodos de la clase AbstractFormBuilder son abstractos y se utilizarán por la clase que herede de esta, en este caso HtmlFormBuilder
La clase HtmlForm representa al formulario en si.
Cada método de la clase HtmlFormBuilder añadirá el código HTML al field_list previamente inicializado como una lista vacia de la clase HtmlForm
En la clase FormDirector especificamos el método construct() que quedó pendiente, este método llamará a los métodos add_text_field(), add_checkbox() y add_button() respectivamente de su propio constructor

.. code-block:: python


    from abc import ABCMeta, abstractmethod

    class Director(object, metaclass = ABCMeta): 

        def __init__(self):
            self._builder = None

        def set_builder(self, builder):
            self._builder = builder
        
        @abstractmethod
        def construct(self, field_list): 
            pass

        def get_constructed_object(self): 
            return self._builder.constructed_object

    class AbstractFormBuilder(object, metaclass = ABCMeta): # ***
        
        def __init__(self):
            self.constructed_object = None

        @abstractmethod
        def add_text_field(self, field_dict): 
            pass

        @abstractmethod
        def add_checkbox(self, checkbox_dict):
            pass

        @abstractmethod
        def add_button(self, button_dict):
            pass

    class HtmlForm(object):

        def __init__(self):
            self.field_list = []

        def __repr__(self):
            return "<form>{}</form>".format("".join(self.field_list))

    class HtmlFormBuilder(AbstractFormBuilder): 
        
        def __init__(self):
            self.constructed_object = HtmlForm()

        def add_text_field(self, field_dict): 
            self.constructed_object.field_list.append(
                '{0}:<br><input type="text" name="{1}"><br>'.format(
                    field_dict['label'],
                    field_dict['field_name']
            )
        )

        def add_checkbox(self, checkbox_dict):
            self.constructed_object.field_list.append(
                '<label><input type="checkbox" id="{0}" value="{1}"> {2}<br>'.format(
                    checkbox_dict['field_id'],
                    checkbox_dict['value'],
                    checkbox_dict['label']
                )
            )

        def add_button(self, button_dict):
            self.constructed_object.field_list.append(
                '<button type="button">{}</button>'.format(
                    button_dict['text']
                )
            )

    class FormDirector(Director):   

        def__init__(self):
            Director.__init__(self)

        def construct(self, field_list): 
            for field in field_list:
                if field["field_type"] == "text_field":
                self._builder.add_text_field(field)
            elif field["field_type"] == "checkbox":
                self._builder.add_checkbox(field)
            elif field["field_type"] == "button":
                self._builder.add_button(field)

    if __name__ == "__main__":
        director = FormDirector() 
        html_form_builder = HtmlFormBuilder() 
        director.set_builder(html_form_builder) 
        field_list = [{
                "field_type": "text_field",
                "label": "Best text you have ever written",
                "field_name": "Field One"
            },
            {
                "field_type": "checkbox",
                "field_id": "check_it",
                "value": "1",
                "label": "Check for on",
            },
            {
                "field_type": "text_field",
                "label": "Another Text field",
                "field_name": "Field One"
            },
            {
                "field_type": "button",
                "text": "DONE"
            }
        ]
        director.construct(field_list)
        with open("form_file.html", 'w') as f:
            f.write(
                "<html><body>{0!r}</body></html>".format(
                    director.get_constructed_object() 
                )
            )

Si lo de arriba es muy confuso aquí hay otra aproximación más simple.

.. code-block:: python



    """
    Separate the construction of a complex object from its representation so
    that the same construction process can create different representations.
    """

    import abc


    class Director:
        """
        Construct an object using the Builder interface.
        """

        def __init__(self):
            self._builder = None

        def construct(self, builder):
            self._builder = builder
            self._builder._build_part_a()
            self._builder._build_part_b()
            self._builder._build_part_c()


    class Builder(metaclass=abc.ABCMeta):
        """
        Specify an abstract interface for creating parts of a Product
        object.
        """

        def __init__(self):
            self.product = Product()

        @abc.abstractmethod
        def _build_part_a(self):
            pass

        @abc.abstractmethod
        def _build_part_b(self):
            pass

        @abc.abstractmethod
        def _build_part_c(self):
            pass


    class ConcreteBuilder(Builder):
        """
        Construct and assemble parts of the product by implementing the
        Builder interface.
        Define and keep track of the representation it creates.
        Provide an interface for retrieving the product.
        """

        def _build_part_a(self):
            pass

        def _build_part_b(self):
            pass

        def _build_part_c(self):
            pass


    class Product:
        """
        Represent the complex object under construction.
        """

        pass


    def main():
        concrete_builder = ConcreteBuilder()
        director = Director()
        director.construct(concrete_builder)
        product = concrete_builder.product


    if __name__ == "__main__":
        main()



Factory
-------


En este ejemplo primero creamos clases para cuadrado y circulo, cada clase tendrá un método para dibujarse en pantalla, la fabrica abstracta solo tendra el método make_object, y tendremos una fabrica de circulos y una de cuadrados, la funcion draw_function simplemente tomará el tipo de fabrica y ejecutará su método draw. De esta manera la función draw_function se vuelve universal y funcionará para cualquier tipo de fabrica de objetos que le pongamos.

.. code-block:: python


        import abc, pygame
	
	    class Shape(object):

	        def __init__(self, x, y):
	            self.x = x
	        self.y = y

	        def draw(self):
	            raise NotImplementedError()

	        def move(self, direction):
	            if direction == 'up':
	            self.y -= 4
	            elif direction == 'down':
	            self.y += 4
	            elif direction == 'left':
	            self.x -= 4
	            elif direction == 'right':
	            self.x += 4
	
	
	    class Square(Shape):

	      def draw(self):
	          pygame.draw.rect(
	            screen,
	            (255, 255, 0),
	            pygame.Rect(self.x, self.y, 20, 20)
	          )


	    class Circle(Shape):

	      def draw(self):
	          pygame.draw.circle(
	            screen,
	            (0, 255, 255),
	            (selfx, self.y),
	            10
	          )
	
	    class AbstractFactory(object):
	      __metaclass__ = abc.ABCMeta

	        @abc.abstractmethod
	        def make_object(self):
	          return
	
	    class CircleFactory(AbstractFactory):

	      def make_object(self): #do something
	        return Circle()
	
	    class SquareFactory(AbstractFactory):

	        def make_object(self): #do something
	          return Square()
	
	    def draw_function(factory):
	        drawable = factory.make_object()
	        drawable.draw()
	
	    def prepare_client():
	        squareFactory = SquareFactory()
	        draw_function(squareFactory)        
	        circleFactory = CircleFactory()
	        draw_function(circleFactory)
	
	
	
Facade
------


El patrón de facade nos permite simplemente crear una interfaz (puede ser una clase) donde nosotros podamos volver más sencillo una interfaz (Una API, interacciones entre objetos). **El objetivo es crear una caja negra que nos provea de una interfaz sencilla con la cual interaccionar**, generalmente para ocultar una interfaz mucho más compleja y caótica.
En el ejemplo anterior, en lugar de acceder al método de cada objeto creamos una clase llamada Sale, que nos servirá como un punto de acceso a cada clase, con esto simplificamos el código y escondemos la complejidad de las clases.

.. code-block:: python


	class Sale(object):

	    def __init__(self):
	        pass

	    @staticmethod
	    def make_invoice(customer_id):
	        return Invoice(Customer.fetch(customer_id))

	    @staticmethod
	    def make_customer():
	        return Customer()

	    @staticmethod
	    def make_item(item_barcode):
	        return Item(item_barcode)

	    @staticmethod
	    def make_invoice_line(item):
	        return InvoiceLine(item)

	    @staticmethod
	    def make_receipt(invoice, payment_type):
	        return Receipt(invoice, payment_type)

	    @staticmethod
	    def make_loyalty_account(customer):
	        return LoyaltyAccount(customer)

	    @staticmethod
	    def fetch_invoice(invoice_id):
	        return Invoice(customer)

	    @staticmethod
	    def fetch_customer(customer_id):
	        return Customer(customer_id)

	    @staticmethod
	    def fetch_item(item_barcode):
	        return Item(item_barcode)

	    @staticmethod
	    def fetch_invoice_line(line_item_id):
	        return InvoiceLine(item)

	    @staticmethod
	    def fetch_receipts(invoice_id):
	        return Receipt(invoice, payment_type)

	    @staticmethod
	    def fetch_loyalty_account(customer_id):
	        return LoyaltyAccount(customer)  

	    @staticmethod
	    def add_item(invoice, item_barcode, amount_purchased):
	        item = Item.fetch(item_barcode)
	        item.amount_in_stock - amount_purchased
	        item.save()
	        invoice_line = InvoiceLine.make(item)
	        invoice.add_line(invoice_line)  

	    @staticmethod
	    def finalize(invoice):
	        invoice.calculate()
	        invoice.save()
	        loyalt_account = LoyaltyAccount.fetch(invoice.customer)
	        loyalty_account.calculate(invoice)
	        loyalty_account.save()

	    @staticmethod
	    def generate_receipt(invoice, payment_type):
	        receipt = Receipt(invoice, payment_type)
	        receipt.save()
	
	
	# Aquí tratamos a cada objeto como una entidad separada, volviendo la función muy compleja
	def complex_sales_processor(customer_code, item_dict_list, payment_type):
	    customer = Customer.fetch_customer(customer_code)
	    invoice = Invoice()
	    for item_dict in item_dict_list:
	        item = Item.fetch(item_dict["barcode"])
	        item.amount_in_stock - item_dict["amount_purchased"]
	        item.save()
	    invoice_line = InvoiceLine(item)
	    invoice.add_line(invoice_line)
	    invoice.calculate()
	    invoice.save()
	    loyalt_account = LoyaltyAccount.fetch(customer)
	    loyalty_account.calculate(invoice)
	    loyalty_account.save()
	    receipt = Receipt(invoice, payment_type)
	    receipt.save()
	
	# Con el nuevo modelo podemos simplificar la función y esconder las funciones especificas del objeto al que consuma la interfaz
	def nice_sales_processor(customer_id, item_dict_list, payment_type):
	    invoice = Sale.make_invoice(customer_id)
	    for item_dict in item_dict_list:
	        Sale.add_item(invoice, item_dict["barcode"], item_dict_list["amount_purchased"])
	    Sale.finalize(invoice)
	    Sale.generate_receipt(invoice,payment_type)
	
	
State
-----


Este patrón de sirve para manejar los cambios de estado de un objeto, ya sea un personaje de un videojuego (correr a la izquierda, derecha, agacharse, brincar, pararse), los de un cajero automático, esperar tarjeta, recibir tarjeta, validar nip, rechazar nip, imprimir recibo, etc). Para no entrar en un bucle de if else, el cambio puede manejarse desde la función switch_state(), incluso podriamos pasarle un parámetro. Así mismo podemos causar que se ejecuten funciones intermedias entre las transiciones de cada estado.

Aquí hay algunas ideas simples para construir tu propia solución.

1. Identifica los estados en los que tu máquina puede estar.
2. Identifica las entradas que esperas para cada estado
3. Dibuja una transición del estado actual al siguiente basado en los datos de entrada.
4. Define acciones a tomar por la máquina en cada estado.
5. Abstrae las acciones compartidas en la clase base **State**
6. Implemente clases concretas para cada estado definido
7. Implemente un método de transición para lidiar con la entrada esperada para cada estado.
8. Implemente las acciones que son requeridas por la máquina en cada estado. Recuerda que esas viven en la clase concreta State y en la clase base State.

.. code-block:: python

        class State(object):
	        pass
	
	    class ConcreteState1(State):
	        def __init__(self, state_machine):
	            self.state_machine = state_machine
	
	        def switch_state(self):
	            self.state_machine.state = self.state_machine.state2
	
	    class ConcreteState2(State):
	        def __init__(self, state_machine):
	            self.state_machine = state_machine
	
	        def switch_state(self):
	            self.state_machine.state = self.state_machine.state1
	
	    class StateMachine(object):
	        def __init__(self):
	            self.state1 = ConcreteState1(self) # aquí se le pasa self para que se inicialize con el mismo objeto
	            self.state2 = ConcreteState2(self)
	            self.state = self.state1
	
	        def switch(self):
	            self.state.switch_state()
	
	        def __str__(self):
	            return str(self.state)
	
	    def main():
	        state_machine = StateMachine()
	        print(state_machine)
	        state_machine.switch()
	        print(state_machine)
	
	    if __name__ == "__main__":
	        main()
	
	
Interpreter
-----------


El patrón interprete se trata de la creación de un Lenguaje de dominio especifico (DSL), el cual es un esquema (puede ser gramatical) que pueda ser ejecutado como código una vez que un parser lo interprete. Esto para tener una interfaz amigable con el usuario pero con las limitaciones de su misma simplicidad, pues siempre será inferior al código.

.. code-block:: python


        class Boiler: 

	        def __init__(self): 
	            self.temperature =  83 # in  celsius
	
	        def __str__(self): 
	            return 'boiler temperature: {}'.format(self.temperature)  
	
	        def increase_temperature(self, amount): 
	            print("increasing the boiler's temperature by {}
	                      degrees".format(amount)) 
	            self.temperature += amount 
	
	        def decrease_temperature(self, amount): 
	            print("decreasing the boiler's temperature by {}  
	                      degrees".format(amount)) 
	            self.temperature -= amount
	
	    word = Word(alphanums) 
	        command = Group(OneOrMore(word)) 
	        token = Suppress("->") 
	        device = Group(OneOrMore(word)) 
	        argument = Group(OneOrMore(word)) 
	        event = command + token + device + Optional(token + argument) 
	
	        boiler = Boiler() 
	        print(boiler)
	
	    # increase -> boiler temperature -> 3 degrees
	
	    [['increase'], ['boiler', 'temperature'], ['3', 'degrees']]
	
	    cmd, dev, arg = event.parseString('increase -> boiler temperature -> 3 degrees')
	        if 'increase' in ' '.join(cmd): 
	            if 'boiler' in ' '.join(dev): 
	                boiler.increase_temperature(int(arg[0])) 
	
	        print(boiler)
	
	
Command
-------


Este patrón permite tener una clase de comando, esta clase se encargará de recibir una clase con la función print_message. La clase Invoker ejecutará su método run, que a su vez ejecutará el método execute() del objeto Command, y esto hará que se ejecute el método print_message de la clase Receiver.

.. code-block:: python


        class Command:

	        def __init__(self, receiver, text):
	            self.receiver = receiver
	            self.text = text
	
	        def execute(self):
	            self.receiver.print_message(self.text)
	
	    class Receiver(object):

	        def print_message(self, text):
	            print("Message received: {}".format(text))
	
	    class Invoker(object):

	        def __init__(self):
	            self.commands = []
	
	        def add_command(self, command):
	            self.commands.append(command)
	
	        def run(self):
	            for command in self.commands:
	                command.execute()
	
	    if __name__ == "__main__":
	        receiver = Receiver()
	        command1 = Command(receiver, "Execute Command 1")
	        command2 = Command(receiver, "Execute Command 2")
	        invoker = Invoker()
	        invoker.add_command(command1)
	        invoker.add_command(command2)
	        invoker.run()
	
	
Strategy
--------


El patrón de estrategia permite cambiar las opciones de ejecución. En lugar de usar múltiples if/else para seleccionar el tipo de operación que queremos hacer designamos clases que hagan la función y las pasamos como parámetros directamente como argumentos (o en el constructor en caso de que sean una clase). De esta manera tendremos código más desacoplado.

.. code-block:: python


        def executor(arg1, arg2, func=None):
	        if func is None:
	            return "Strategy not implemented..."
	        return func(arg1, arg2)
	
	    def strategy_addition(arg1, arg2):
	        return arg1 + arg2
	
	    def strategy_subtraction(arg1, arg2):
	        return arg1 - arg2
	
	    def main():
	        print(executor(4, 6))
	        print(executor(4, 6, strategy_addition))
	        print(executor(4, 6, strategy_subtraction))
	    if __name__ == "__main__":
	        main()
	
	
	
Singleton
---------


El truco ocurre en el método __new__ este método se llama cuando se crea una clase y recibe la clase como parámetro.
En este caso si no detecta el atributo "instance" creará una instancia de la clase para retornarla, si la detecta simplemente la retornará.

Los métodos __getattr__ y __setattr__ están modificados para obtener y asignar los atributos a la subclase.

Si intentamos crear otra instancia de la clase simplemente retornará la que ya tiene.

.. code-block:: python

        #singleton_object.py
	    class SingletonObject(object):
	        class __SingletonObject():
	            def __init__(self):
	                self.val = None
	
	            def __str__(self):
	                return "{0!r} {1}".format(self, self.val)
	    # the rest of the class definition will follow here, as per the previous logging script
	        instance = None
	
	        def __new__(cls):
	            if not SingletonObject.instance:
	                SingletonObject.instance = SingletonObject.__SingletonObject()
	            return SingletonObject.instance
	
	        def __getattr__(self, name):
	            return getattr(self.instance, name)
	
	        def __setattr__(self, name):
	            return setattr(self.instance, name)
	
	
Decorators
----------


Con un decorador podemos agregarle una funcionalidad extra a una función, el decorador wraps nos permite mantener constantes los atributos __name__ de cada función, aun con un cambio en el scope
Podemos agregar variables a los decoradores anidándolos nuevamente.

.. code-block:: python


    import time
	from functools import wraps
	
	    def profiling_decorator_with_unit(unit):
	        def profiling_decorator(f):
	            @wraps(f)
	                def wrap_f(n):
	                    start_time = time.time()
	                    result = f(n)
	                    end_time = time.time()
	                    if unit == "seconds":
	                        elapsed_time = (end_time - start_time) / 1000
	                    else:
	                        elapsed_time = (end_time - start_time)
	                        print("[Time elapsed for n = {}] {}".format(n, elapsed_time))
	                    return result
	            return wrap_f
	        return profiling_decorator
	
	@profiling_decorator_with_unit("seconds")
	def fib(n):
	    print("Inside fib")
	    if n < 2:
	        return
	
	    fibPrev = 1
	    fib = 1
	    for num in range(2, n):
	        fibPrev, fib = fib, fib + fibPrev
	        return fib
	
	if __name__ == "__main__":
	    n = 77
	    print("Fibonacci number for n = {}: {}".format(n, fib(n)))
	
	
	
Prueba_proto
------------


El uso del decorador @abstractmethod forza a la clase individuo a poseer un método llamado prueba()
from abc import ABCMeta, abstractmethod

.. code-block:: python
	
	class proto(metaclass=ABCMeta):
	
	    @abstractmethod
	    def prueba(self):
	        pass
	
	
	class individuo(proto):

	    def prueba(self):
	        return 1
	
	
	if __name__ == '__main__':
	    indi1 = individuo()
	
	
Proxy
-----


Un proxy provee la misma interfaz que el objeto original, pero controla el acceso. Como parte de ese control puede efectuar otras tareas antes o después de que el objeto original sea accesado, esto es especialmente útil cuando queremos implementar algo, como la memoización, sin colocar ninguna responsabilidad en el entendimiento del cache por parte del cliente. 
La diferencia entre el proxy y el adaptador es que este último cambia la interfaz, mientras que en el proxy la interfaz es la misma pero hay acciones que toman lugar en el fondo.

Aquí estamos usando el CalculatorProxy para dotar de la capacidad de memoización (el uso de cache), a la función de fibonnaci, la función se mantiene y funciona igual, con la diferencia de que se cachea cada resultado para un resultado más rápido.

.. code-block:: python


        import time
	
	    class RawCalculator(object):

	        def fib(self, n):
	            if n < 2:
	                return 1            
	            return self.fib(n - 2) + self.fib(n - 1)
	
	    def memoize(fn):
	        __cache = {}
	        def memoized(*args):
	            key = (fn.__name__, args)
	            if key in __cache:
	                return __cache[key]
	            __cache[key] = fn(*args)
	            return __cache[key]
	        return memoized
	
	    class CalculatorProxy(object):

	        def __init__(self, target):
	            self.target = target
	            fib = getattr(self.target, 'fib')
	            setattr(self.target, 'fib', memoize(fib))
	
	        def __getattr__(self, name):
	            return getattr(self.target, name)
	
	    if __name__ == "__main__":
	        calculator = CalculatorProxy(RawCalculator())
	        start_time = time.time()
	        fib_sequence = [calculator.fib(x) for x in range(0, 80)]
	        end_time = time.time()
	        print("Calculating the list of {} Fibonacci numbers took {}
	            seconds".format(
	                len(fib_sequence),
	                end_time - start_time
	            )
	        )
	
	
Mvc
---


En el modelo vista controlador se trata de encapsular los diferentes flujos de un programa input, procesamiento y salida en partes diferentes. Y asignar una única tarea a cada uno, el modelo se encarga únicamente de procesar data (CRUD), la vista de mostrarla y el controlador de la lógica del programa. Es bastante tentador poner lógica en el modelo o darle más funcionalidades a la vista, pero debe evitarse por ser contrario al modelo.

.. code-block:: python


    # controller.py
	import sys
	#from model import NameModel
	#from view import GreetingView
	
	class GreetingController(object):

	    def __init__(self):
	        self.model = NameModel()
	        self.view = GreetingView()
	
	    def handle(self, request):
	        if request in self.model.get_name_list():
	            self.view.generate_greeting(name=request, known=True)
	        else:
	            self.model.save_name(request)
	            self.view.generate_greeting(name=request, known=False)
	
	
	# model.py
	import os
	
	class NameModel(object):

	    def __init__(self):
	        self.filename = 'names.dat'
	
	    def _get_append_write(self):
	        if os.path.exists(self.filename):
	            return 'a'
	        return 'w'
	
	    def get_name_list(self):
	        if not os.path.exists(self.filename):
	            return False
	        with open(self.filename, 'r') as data_file:
	            names = data_file.read().split('\n')
	        return names
	
	    def save_name(self, name):
	        with open(self.filename, self._get_append_write()) as data_file:
	            data_file.write("{}\n".format(name))
	
	# view.py
	class GreetingView(object):

	    def __init__(self):
	        pass
	
	    def generate_greeting(self, name, known):
	        if name == "lion":
	            print("RRRrrrrroar!")
	            return
	        if known:
	            print("Welcome back {}!".format(name))
	        else:
	            print("Hi {}, it is good to meet you".format(name))
	
	
	
	def main(name):
	    request_handler = GreetingController()
	    request_handler.handle(name)
	
	if __name__ == "__main__":
	    main(sys.argv[1])
	
	

Chain of responsability
-----------------------


Cada función tiene una única responsabilidad. El patrón de responsabilidad puede servir para encapsular el procesamiento de elementos como si se tratara de una tubería (pipeline). Para encadenar las ejecuciones y tener un código más ordenado y desacoplado, colocamos un método handle_request (que recibe como parámetros el request y la respuesta), que se encargará de procesar la petición y un atributo next_handler, que es el que se encargara de decidir a que objeto se pasará el objeto de petición para que lo procese con su propia función de handle_request, si este último valor no se ha modificado será igual a EndHandler, que devolverá la respuesta. Es algo parecido a como funciona el Middleware de Django. Todos los handlers que quisieramos agregar deben tener el método __init__() estableciendo self.next_handler como una instancia de EndHandler(), para poder usarlos en cualquier orden.

.. code-block:: python

    class EndHandler(object):

        def __init__(self):
            pass

        def handle_request(self, request):
            pass

    class Handler1(object):

        def __init__(self):
            self.next_handler = EndHandler()

        def handle_request(self, request):
            self.next_handler.handle_request(request)

    def main(request):
        concrete_handler = Handler1()
        concrete_handler.handle_request(request) #Aquí podrían encadenarse más

    if __name__ == "__main__":
        main(request)
	
	
	
Observer
--------


El ejemplo correspondiente a la clase Task da cuenta de objetos acoplados, en el que es necesario que un objeto sepa muchísima información de los métodos y atributos a los que hace referencia. En este caso debe saber que user tiene un método add_experience() y hace referencia a otro objeto llamado wallet, con un método increase_balance()
El patrón observador permite a un objeto mantenerse al tanto sobre los cambios de estado de otro objeto. Para lograr esto nos aseguraremos de que cada observador posea un método update(), este método será llamado por el Observable, en esta clase por medio de un callback que es una función anónima. De esta manera tendremos un desacoplamiento de las clases que observan, pues estas solo necesitan contar con un método update(). Contrastalo con el ejemplo incorrecto, donde el objeto Task, necesita saber que el objeto user tiene un método llamado add_experience(), el objeto wallet tiene un méotodo llamado increase_balance() y el objeto badge un método llamado add_points(). Al momento de crear tests para este objeto se complicara innecesariamente.

.. code-block:: python


    class Task(object):

	    def __init__(self, user, _type):
	        self.user = user
	        self._type = _type
	
	    def complete(self):
	        self.user.add_experience(1)
	        self.user.wallet.increase_balance(5)
	        for badge in self.user.badges:
	            if self._type == badge._type:
	                badge.add_points(2)
	
	
	class ConcreteObserver(object):

	    def update(self, observed):
	        print("Observing: {}".format(observed))
	
	class Observable(object):

	    def __init__(self):
	        self.callbacks = set()
	
	    def register(self, callback):
	        self.callbacks.add(callback)
	
	    def unregister(self, callback):
	        self.callbacks.discard(callback)
	
	    def unregister_all(self):
	        self.callbacks = set()
	
	    def update_all(self):
	        for callback in self.callbacks:
	            callback(self)
	
	def main():
	    observed = Observable()
	    observer1 = ConcreteObserver()
	    observed.register(lambda x: observer1.update(x))
	    observed.update_all()
	
	if __name__ == "__main__":
	    main()
	
	
Template
--------


En este patrón se busca utilizar el decorador @abstractmethod para forzar la implementación de los métodos en una clase derivada. el método template_method() también se hereda y es el que contendrá cada uno de los pasos a ejecutar

.. code-block:: python


    import abc
	
	class TemplateAbstractBaseClass(metaclass=abc.ABCMeta):

	    def template_method(self):
	        self._step_1()
	        self._step_2()
	        self._step_n()
	    
	    @abc.abstractmethod
	    def _step_1(self): pass
	
	    @abc.abstractmethod
	    def _step_2(self): pass
	
	    @abc.abstractmethod
	    def _step_3(self): pass
	
	class ConcreteImplementationClass(TemplateAbstractBaseClass):

	    def _step_1(self): pass
	    def _step_2(self): pass
	    def _step_3(self): pass
	
	
	
Adapter
-------


Si quisieramos utilizar la función required_function en una interfaz pero esa función tuviera otro nombre en otro objeto, en lugar de heredar del objeto podriamos simplemente pasarlo como un parámetro y utilizar la función __getattr__ para que todo parámetro sea obtenido del objeto que le pasamos.
El patrón de adaptación nos permite utilizar la función required_function en nuestra interfaz

.. code-block:: python


    from third_party import WhatIHave
	
	class ObjectAdapter(object):
	
	    def __init__(self, what_i_have):
	        self.what_i_have = what_i_have
	
	    def required_function(self):
	        return self.what_i_have.provided_function_1()
	
	    def __getattr__(self, attr):
	        # Everything else is handeled by the wrapped object
	        return getattr(self.what_i_have, attr)
	
	
	
Prototype
---------


El patrón de prototipo requiere lo siguiente:

* El cliente crea un nuevo objeto pidiendo que se clone a si mismo
* El prototipo declara una interfaz para clonarse
* El prototipo concreto implemente la operación de clonarse

1. En este punto se inicializan las clases, de esta manera solo se crearán UNA SOLA VEZ, las sucesivas apariciones de cada clase serán llamadas al método clone()
2. Como las clases se crean una única vez no tendremos llamadas al método open cada vez que creemos una instancia. 
3. Una clase cuya metaclase sea igual a ABCMeta no podrá instanciarse a menos de que TODOS sus métodos abstractos y propiedades estén sobreescritos
4. Aquí es donde se crea cada unidad, de esta manera no es necesario crear un método para cada tipo de clase a crear

.. code-block:: python


    from abc import ABCMeta, abstractmethod
	
	class Prototype(metaclass=ABCMeta): # 3
	    @abstractmethod
	    def clone(self):
	        pass
	
	class Knight(Prototype):

	    def __init__(self, level):
	        self.unit_type = "Knight"
	        filename = "{}_{}.dat".format(self.unit_type, level)
	        with open(filename, 'r') as parameter_file: # 2
	            lines = parameter_file.read().split("\n")
	            self.life = lines[0]
	            self.speed = lines[1]
	            self.attack_power = lines[2]
	            self.attack_range = lines[3]
	            self.weapon = lines[4]

	    def __str__(self):
	        return "Type: {0}\n" \
	            "Life: {1}\n" \
	            "Speed: {2}\n" \
	            "Attack Power: {3}\n" \
	            "Attack Range: {4}\n" \
	            "Weapon: {5}".format(
	            self.unit_type,
	            self.life,
	            self.speed,
	            self.attack_power,
	            self.attack_range,
	            self.weapon
	            )
	
	    def clone(self):
	        return deepcopy(self)
	
	class Archer(Prototype):
	    def __init__(self, level):
	        self.unit_type = "Archer"
	        filename = "{}_{}.dat".format(self.unit_type, level)
	        with open(filename, 'r') as parameter_file: #2
	            lines = parameter_file.read().split("\n")
	            self.life = lines[0]
	            self.speed = lines[1]
	            self.attack_power = lines[2]
	            self.attack_range = lines[3]
	            self.weapon = lines[4]
	
	    def __str__(self):
	        return "Type: {0}\n" \
	            "Life: {1}\n" \
	            "Speed: {2}\n" \
	            "Attack Power: {3}\n" \
	            "Attack Range: {4}\n" \
	            "Weapon: {5}".format(
	            self.unit_type,
	            self.life,
	            self.speed,
	            self.attack_power,
	            self.attack_range,
	            self.weapon
	            )
	
	    def clone(self):
	        return deepcopy(self)
	
	class Barracks(object):

	    def __init__(self): # 1
	        self.units = {
	        "knight": {
	        1: Knight(1), 
	        2: Knight(2)
	        },
	        "archer": {
	        1: Archer(1),
	        2: Archer(2)
	        }
	        }
	
	
	    def build_unit(self, unit_type, level):
	        return self.units[unit_type][level].clone() # 4
	
	if __name__ == "__main__":
	    barracks = Baracks()
	    knight1 = barracks.build_unit("knight", 1)
	    archer1 = barracks.build_unit("archer", 2)
	    print("[knight1] {}".format(knight1))
	    print("[archer1] {}".format(archer1))
	
Publisher
---------

.. code-block:: python

        class Message(object):

            def __init__(self):
                self.payload = None


        class Subscriber(object):

            def __init__(self, dispatcher):
                dispatcher.subscribe(self)

            def process(self, message):
                print("Message: {}".format(message.payload))

        class Publisher(object):

            def __init__(self, dispatcher):
                self.dispatcher = dispatcher

            def publish(self, message):
                self.dispatcher.send(message)

        class Dispatcher(object):

            def __init__(self):
                self.subscribers = set()

            def subscribe(self, subscriber):
                self.subscribers.add(subscriber)

            def unsubscribe(self, subscriber):
                self.subscribers.discard(subscriber)

            def unsubscribe_all(self):
                self.subscribers = set()

            def send(self, message):
                for subscriber in self.subscribers:
                    subscriber.process(message)
