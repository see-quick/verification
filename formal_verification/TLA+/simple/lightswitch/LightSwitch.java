public class LightSwitch {

    private boolean isOn;

    public LightSwitch() {
        this.isOn = false;
    }

    public void toggle() {
        this.isOn = !this.isOn;
    }

    public boolean isOn() {
        return isOn;
    }

    public static void main(String[] args) {
        LightSwitch light = new LightSwitch();
        System.out.println("Is light on? " + light.isOn()); // should print false
        light.toggle();
        System.out.println("Is light on? " + light.isOn()); // should print true
        light.toggle();
        System.out.println("Is light on? " + light.isOn()); // should print false
    }
}
