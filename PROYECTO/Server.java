public class Server{
    public static void main(String args[]){
        System.out.println("Server iniciado");
        Conector server=new Conector();
        String mensaje="";
        byte[] a;
        while(mensaje!=null){
            mensaje=server.recibirMensaje();
            //System.out.println(Byte.toString(a[0]));
            //server.enviarMensaje("Mensaje recibido");
            System.out.println(mensaje);
        }
        System.exit(0);
    }
}