import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class Conector{
    private Socket socket;
    private ServerSocket server;
    private DataInputStream entradaSocket;
    private DataOutputStream salida;
    private BufferedReader entrada;
    final short puerto=8000;
    public Conector(){
        try{
            //Establecemos la conexion
            server=new ServerSocket(puerto);
            socket=server.accept();
            //Declaramos a los objetos para el manejo de Inputs y Outputs
            entradaSocket=new DataInputStream(socket.getInputStream());
            //entrada=new BufferedReader(entradaSocket);
            salida=new DataOutputStream(socket.getOutputStream());
        }catch(Exception e){
            System.out.println("Hubo en error en el socket server: "+e);
        }
    }
    public Conector(String ip){
        try{
            //Establecemos la conexion
            socket=new Socket(ip,this.puerto);
            //Declaramos a los objetos para el manejo de Inputs y Outputs
            entradaSocket=new DataInputStream(socket.getInputStream());
            //entrada=new BufferedReader(entradaSocket);
            salida=new DataOutputStream(socket.getOutputStream());
        }catch(Exception e){
            System.out.println("Hubo en error en el socket: "+e);
        }
    }
    public void enviarMensaje(String mensaje){
        try{
            //byte a=2;
            salida.writeUTF(mensaje);
            //salida.writeUTF(mensaje);
        }catch(Exception e){
            System.out.println("Error al enviar el mensaje: "+e);
        }
    }
    public String recibirMensaje(){
        try{
            //byte[] a =new byte[4];
            //a[0]=entradaSocket.readByte();
            //a[1]=entradaSocket.readByte();
            //a[2]=entradaSocket.readByte();
            //a[3]=entradaSocket.readByte();
            //return a;
            return entradaSocket.readUTF();
            //return Character.toString((char)Byte.toString(entradaSocket.readByte()));
            //return Character.toString((char)entradaSocket.readByte());
        }catch(Exception e){
            System.out.println("Error al leer el mensaje: "+e);
            return null;
        }
    }
    public void desconectar(){
        try{
            server.close();
            socket.close();
        }catch(Exception e){
            System.out.println("Error al desconectar: "+e);
        }
    }
}