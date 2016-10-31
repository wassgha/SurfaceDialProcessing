/**
 * Proof of concept for using a phone as a rotation input
 * (DIY Surface Dial)
 * 
 * @author Wassim Gharbi
 */
import com.onlylemi.processing.android.capture.*;
AndroidSensor as;
ArrayList<Float> smoothing = new ArrayList<Float>();
int smooth_val;

void setup() {
  fullScreen();
  noStroke();
  smooth_val = 10;
  for(int i = 0; i<smooth_val; i++)
    smoothing.add(0.0);
  as = new AndroidSensor(0);
  as.start();
}

void draw() {
  background(0);

  float[] values = as.getAccelerometerSensorValues();
  smoothing.remove(0);
  smoothing.add(smoothing.size(), values[1]);
  
  // If phone is near screen (proximity sensor) and is almost vertical (accelerometer)
  if (Math.abs(values[2]) <2 && as.getProximitySensorValues() < 2)
    // Draw dial
    Dial(600, int(map(calculateAverage(smoothing), -12, 12, 0, 360)));
}

void Dial(float diameter, int angle) {
  fill(127, 140, 141);
  ellipse(width/2, height/2, diameter, diameter);
  
  fill((float)Math.sin(map(angle, 0, 360, 0, 32)*0.3 + 0) * 127 + 128, (float)Math.sin(map(angle, 0, 360, 0, 32)*0.3 + 2) * 127 + 128, (float)Math.sin(map(angle, 0, 360, 0, 32)*0.3 + 4) * 127 + 128 );
  arc(width/2, height/2, diameter+50, diameter+50, radians(angle-90), radians(angle -90 + 50));
  
  fill(0);
  ellipse(width/2, height/2, diameter-40, diameter-40);
}

/**
Method used to smooth accelerometer data
*/
public float calculateAverage(ArrayList <Float> marks) {
  Float sum = 0.0;
  if(!marks.isEmpty()) {
    for (Float mark : marks) {
        sum += mark;
    }
    return sum / marks.size();
  }
  return sum;
}