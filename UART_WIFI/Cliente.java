public class Cliente{
    public static void main(String args[]){
        System.out.println("Cliente iniciado");
        Conector cliente=new Conector("localhost");
        String mensaje="";
        while(mensaje!=null){
            mensaje = System.console().readLine();
            cliente.enviarMensaje(mensaje);
            mensaje=cliente.recibirMensaje();
            System.out.println(mensaje);
        }
    }
}