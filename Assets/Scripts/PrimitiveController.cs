using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrimitiveController : MonoBehaviour
{
    private Rigidbody _RigidBody;


    void Start()
    {
        _RigidBody = gameObject.GetComponent<Rigidbody>();    
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.UpArrow))
        {
            _RigidBody.AddForce(new Vector3(0, 0, 5), ForceMode.Force);
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            _RigidBody.AddForce(new Vector3(0, 0, -5), ForceMode.Force);
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            _RigidBody.AddForce(new Vector3(-5, 0, 0), ForceMode.Force);
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            _RigidBody.AddForce(new Vector3(5, 0, 0), ForceMode.Force);
        }
    }
}
