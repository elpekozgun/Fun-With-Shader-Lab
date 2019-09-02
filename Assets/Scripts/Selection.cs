using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Selection : MonoBehaviour
{

    private void Update()
    {
        if (Input.GetKey(KeyCode.Mouse0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out RaycastHit info) && info.collider.gameObject == this.gameObject)
            {
                gameObject.GetComponent<MeshRenderer>().materials[0].SetFloat("_Selected", 1);
            }
            else
            {
                gameObject.GetComponent<MeshRenderer>().materials[0].SetFloat("_Selected", 0);
            }
        }
    }

}
