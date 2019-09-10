using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowTrail : MonoBehaviour
{
    public static event EventHandler OnCollided;

    private Renderer _Renderer;
    private float _MeshSize;
    private float[] _OffsetX;
    private float[] _OffsetZ;
    private int _MaxCount = 256; // TODO : there must be a way to extract this constant from shader. till then sync it with MAX_WAVE in ripple.shader.

    void Start()
    {
        _Renderer = gameObject.GetComponent<Renderer>();
        _MeshSize = gameObject.GetComponent<MeshFilter>().mesh.bounds.size.magnitude;
        _OffsetX = new float[_MaxCount];
        _OffsetZ = new float[_MaxCount];

    }


    private void OnTriggerEnter(Collider col)
    {
        
    }

    void Update()
    {
        int i = 0;
        if (Input.GetKey(KeyCode.Mouse0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

            Physics.Raycast(ray, out RaycastHit info);
            if (info.collider != null)
            {
                var point = _Renderer.transform.InverseTransformPoint(info.point);

                _OffsetX[i] = point.x;
                _OffsetZ[i] = point.z;
                Debug.Log(_OffsetX[i]);
                Debug.Log(_OffsetZ[i]);
                i++;
            }
        }
        _Renderer.material.SetFloatArray("_OffsetX", _OffsetX);
        _Renderer.material.SetFloatArray("_OffsetZ", _OffsetZ);
    }

}
