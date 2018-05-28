public class Server{
    public static void main(String args[]){
        System.out.println("Server iniciado");
        Conector server=new Conector();
        String mensaje;
        while(true){
            mensaje=server.recibirMensaje();
            System.out.println(mensaje);
        }
    }
}