using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;



public class WaterDropController : MonoBehaviour
{
    public Drop[] Drops;
    public Button DropButton;
    public Button ResetButton;
    private Vector3[] _InitialPositions;
    private float _MaxLevel;

    // Start is called before the first frame update
    void Awake()
    {
        Drops = GameObject.FindObjectsOfType<Drop>();

        RippleCollision.OnCollided += WaterDropCollision_OnCollided;
        _InitialPositions = new Vector3[Drops.Length];
        
        // TODO : özgün : Fix the goddamn event;

        for (int i = 0; i < Drops.Length; ++i)
        {
            _InitialPositions[i] = Drops[i].transform.position;
            _MaxLevel = _InitialPositions[i].y > _MaxLevel ? _InitialPositions[i].y : _MaxLevel;
        }
        DropButton.onClick.AddListener(Drop);
        ResetButton.onClick.AddListener(Reset);
    }


    private void Drop()
    {
        for (int i = 0; i < Drops.Length; i++)
        {
            Drops[i].GetComponent<Rigidbody>().useGravity = true;
            DropButton.enabled = false;
        }
    }

    private void Reset()
    {
        for (int i = 0; i < Drops.Length; i++)
        {
            Drops[i].GetComponent<Rigidbody>().useGravity = false;
            Drops[i].GetComponent<Rigidbody>().velocity = Vector3.zero;
            Drops[i].transform.position = new Vector3(_InitialPositions[i].x, _MaxLevel , _InitialPositions[i].z);
            DropButton.enabled = true;
        }
    }

    private void WaterDropCollision_OnCollided(object sender, System.EventArgs e)
    {
        var stone = sender as Collider;

        for (int i = 0; i < Drops.Length; ++i)
        {
            if (Drops[i].name == stone.gameObject.name)
            {
                float randomX = Random.Range(-1f, 1f);
                float randomY = Random.Range(-1f, 1f);
                stone.transform.position = new Vector3(_InitialPositions[i].x + randomX, _MaxLevel, _InitialPositions[i].z + randomY);
                stone.attachedRigidbody.velocity = Vector3.zero;
            }
        }
    }
}
