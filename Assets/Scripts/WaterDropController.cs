using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;



public class WaterDropController : MonoBehaviour
{
    public GameObject[] Stones;
    public Button DropButton;
    public Button ResetButton;
    private Vector3[] _InitialPositions;
    private float _MaxLevel;

    // Start is called before the first frame update
    void Awake()
    {
        RippleCollision.OnCollided += WaterDropCollision_OnCollided;
        _InitialPositions = new Vector3[Stones.Length];

        // TODO : özgün : Fix the goddamn event;

        for (int i = 0; i < Stones.Length; ++i)
        {
            _InitialPositions[i] = Stones[i].transform.position;
            _MaxLevel = _InitialPositions[i].y > _MaxLevel ? _InitialPositions[i].y : _MaxLevel;
        }
        DropButton.onClick.AddListener(Drop);
        ResetButton.onClick.AddListener(Reset);
    }


    private void Drop()
    {
        for (int i = 0; i < Stones.Length; i++)
        {
            Stones[i].GetComponent<Rigidbody>().useGravity = true;
            DropButton.enabled = false;
        }
    }

    private void Reset()
    {
        for (int i = 0; i < Stones.Length; i++)
        {
            Stones[i].GetComponent<Rigidbody>().useGravity = false;
            Stones[i].GetComponent<Rigidbody>().velocity = Vector3.zero;
            Stones[i].transform.position = new Vector3(_InitialPositions[i].x, _MaxLevel , _InitialPositions[i].z);
            DropButton.enabled = true;
        }
    }

    private void WaterDropCollision_OnCollided(object sender, System.EventArgs e)
    {
        var stone = sender as Collider;

        for (int i = 0; i < Stones.Length; ++i)
        {
            if (Stones[i].name == stone.gameObject.name)
            {
                stone.transform.position = new Vector3(_InitialPositions[i].x, _MaxLevel, _InitialPositions[i].z);
                stone.attachedRigidbody.velocity = Vector3.zero;
            }
        }


    }
}
