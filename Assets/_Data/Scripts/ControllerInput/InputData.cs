using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

public class InputData : MonoBehaviour
{
    public InputDevice _rightController;
    public InputDevice _leftController;
    public InputDevice _Hmd;

    void Update()
    {
        if (!_rightController.isValid || !_leftController.isValid || !_Hmd.isValid)
            InitializeInputDevices();
    }

    private void InitializeInputDevices()
    {
        if (!_rightController.isValid)
            InitializeInputDevice(InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Right, ref _rightController);
        if (!_leftController.isValid)
            InitializeInputDevice(InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Left, ref _leftController);
        if (!_Hmd.isValid)
            InitializeInputDevice(InputDeviceCharacteristics.HeadMounted , ref _Hmd);

    }

    private void InitializeInputDevice(InputDeviceCharacteristics inputCharacteristics,ref InputDevice inputdevice)
    {
        List<InputDevice> devices = new List<InputDevice>();

        InputDevices.GetDevicesWithCharacteristics(inputCharacteristics, devices);

        if(devices.Count > 0)
            inputdevice = devices[0];
    }
}
