using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControler : MonoBehaviour
{
    private GameObject gameCameraObject;
	private GameObject gameLightObject;

	float x1;
    float x2;
    float x3;
    float x4;

	enum RotationAxes { MouseXAndY, MouseX, MouseY }
	RotationAxes axes = RotationAxes.MouseXAndY;

	float sensitivityX = 15;

	float sensitivityY = 15;
	//private float minimumX = -360; 
	//private float maximumX = 360; 
	float minimumY = -80;
	float maximumY = 80;
	private float rotationY = 0;
	// Start is called before the first frame update
	void Start()
    {
        gameCameraObject = GameObject.Find("Camera");
		gameLightObject = GameObject.Find("Directional Light");
		if (GetComponent<Rigidbody>())
			GetComponent<Rigidbody>().freezeRotation = true;
	}

    // Update is called once per frame
    void Update()
    {
		//空格键抬升高度
		if (Input.GetKey(KeyCode.Space))
		{
			transform.position = new Vector3(transform.position.x, transform.position.y + 1, transform.position.z);
		}

		//w键前进
		if (Input.GetKey(KeyCode.W))
		{
			this.gameCameraObject.transform.Translate(new Vector3(0, 0, 5 * Time.deltaTime));
		}
		//s键后退
		if (Input.GetKey(KeyCode.S))
		{
			this.gameCameraObject.transform.Translate(new Vector3(0, 0, -5 * Time.deltaTime));
		}
		//a键后退
		if (Input.GetKey(KeyCode.A))
		{
			this.gameCameraObject.transform.Translate(new Vector3(-0.1f, 0, 0 * Time.deltaTime));
		}
		//d键后退
		if (Input.GetKey(KeyCode.D))
        {
            this.gameCameraObject.transform.Translate(new Vector3(0.1f, 0, 0 * Time.deltaTime));
        }
        if (Input.GetAxis("Mouse ScrollWheel") != 0)
        {
            this.gameCameraObject.transform.Translate(new Vector3(0, 0, Input.GetAxis("Mouse ScrollWheel")));
        }
        if (Input.GetMouseButton(0))
		{
			if (axes == RotationAxes.MouseXAndY)
			{
				float rotationX = this.gameCameraObject.transform.localEulerAngles.y + Input.GetAxis("Mouse X") * sensitivityX;
				rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
				rotationY = Mathf.Clamp(rotationY, minimumY, maximumY);
				this.gameCameraObject.transform.localEulerAngles = new Vector3(-rotationY, rotationX, 0);
			}
			else if (axes == RotationAxes.MouseX)
			{
				this.gameCameraObject.transform.Rotate(0, Input.GetAxis("Mouse X") * sensitivityX, 0);
			}
			else
			{
				rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
				rotationY = Mathf.Clamp(rotationY, minimumY, maximumY);
				this.gameCameraObject.transform.localEulerAngles = new Vector3(-rotationY, transform.localEulerAngles.y, 0);
			}
		}
		if (Input.GetMouseButton(1))
        {
			float fMouseX = Input.GetAxis("Mouse X");
			float fMouseY = Input.GetAxis("Mouse Y");
			this.gameLightObject.transform.Rotate(Vector3.up, -fMouseX * 15, Space.World);
			this.gameLightObject.transform.Rotate(Vector3.right, fMouseY * 15, Space.World);
		}
    }
}
