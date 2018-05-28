public class Server{
    public static void main(String args[]){
        System.out.println("Server iniciado");
        Conector server=new Conector();
        String mensaje="";
        while(mensaje!=null){
            mensaje=server.recibirMensaje();
            server.enviarMensaje("Mensaje recibido");
            System.out.println(mensaje);
        }
        System.exit(0);
    }
}