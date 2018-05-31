public class Server{
    public static void main(String args[]){
        System.out.println("Server iniciado"); 
        String mensaje="";
        byte[] a;
        while(true){
            Conector server=new Conector();
            a=server.recibirMensaje();
            System.out.println(new String(a,0,4));
            //server.enviarMensaje("Mensaje recibido");
            System.out.println(mensaje);
            server.desconectar();
        }
        //System.exit(0);
    }
}