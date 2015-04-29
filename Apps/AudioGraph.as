package 
{
    import flash.geom.Rectangle; 
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.events.SampleDataEvent;
    import flash.media.Microphone;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    public class AudioGraph extends Sprite 
    {
        public var bmp:Bitmap = new Bitmap(new BitmapData(512,500,false,0x006600)), //the bitmap that will be used to represent the time domain
        mic:Microphone = Microphone.getMicrophone(), //the default microphone if available
        n:int, // the sample number
        sn:Number,  //sample value at n, or s[n] 
        bah:ByteArray, //Byte Array  that Holds the sample data
        A:Number = 250,//amount to normailize for visual representation, or 'A'  for amplitude factor.  
        rect:Rectangle = new Rectangle(0, 0, 1, 20); //for drawing each data point
        
	public function sdeh(e:SampleDataEvent):void //sample data event handler
        { 
            bah = e.data;
            bah.position = 0;
            bmp.bitmapData.lock();
            bmp.bitmapData.fillRect(bmp.bitmapData.rect, 0x3CD8FF);
            for (n = 0;n<512;++n)
	    {
               sn = bah.readFloat();//reads 4 bytes = 32 bit floating point sample value
               rect.x = n;
               rect.y = 240-sn*A;
               bmp.bitmapData.fillRect(rect,0xd7f7ff);
            }
            bmp.bitmapData.unlock();
        }

        public function AudioGraph() 
	{
            stage.addChild(bmp);//make the bitmap visible on the display list
            mic.rate = 11;// sets N, the sample frequency, to 11025hz
            mic.setSilenceLevel(0);//Enable no silence in background
            mic.addEventListener(SampleDataEvent.SAMPLE_DATA,sdeh); // call the sdeh function if the mic hears audio
        }
    }
}