using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StoneController : MonoBehaviour
{

    public GameObject stone;
    public Button DropButton;
    public Button ResetButton;
    private Vector3 _InitialPosition;

    // Start is called before the first frame update
    void Awake()
    {
        WaterDropCollision.OnCollided += WaterDropCollision_OnCollided;

        Vector3 _InitialPosition = stone.transform.position;
        DropButton.onClick.AddListener
        (
            () => 
            {
                stone.GetComponent<Rigidbody>().useGravity = true;
                stone.transform.position = _InitialPosition;
                DropButton.enabled = false;
            }
        );
    }

    private void WaterDropCollision_OnCollided(object sender, System.EventArgs e)
    {
        DropButton.enabled = true;
        stone.GetComponent<Rigidbody>().useGravity = false;
        stone.GetComponent<Rigidbody>().velocity = Vector3.zero;
    }
}
