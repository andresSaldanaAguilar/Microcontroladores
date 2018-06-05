import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
public class Server{
    public static void main(String args[]) throws FileNotFoundException, IOException{
        System.out.println("Server iniciado"); 
        String mensaje="";
        byte[] a;
        while(true){
            Conector server=new Conector();
            a=server.recibirMensaje();
            try (FileOutputStream fos = new FileOutputStream("/Users/andressaldana/Documents/Github/Microcontroladores/PROYECTO.X/muestras.txt")){
                fos.write(a);
                fos.close(); 
            }
            System.out.println(new String(a,0,2048));
            //server.enviarMensaje("Mensaje recibido");
            System.out.println(mensaje);
            server.desconectar();
        }
        //System.exit(0);
    }
}