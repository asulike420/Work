import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;
 
public class ImageDownloader
{      
    public static void main(String[] args )
    {
        BufferedImage image =null;
        try{
 
            URL url =new URL("https://www.ikea.com/in/en/p/pugg-wall-clock-stainless-steel-90391909/");
            // read the url
           image = ImageIO.read(url);
 
            for png
            ImageIO.write(image, "png",new File("/tmp/have_a_question.png"));
 
            // for jpg
            ImageIO.write(image, "jpg",new File("/tmp/have_a_question.jpg"));
 
        }catch(IOException e){
            e.printStackTrace();
        }
    }}