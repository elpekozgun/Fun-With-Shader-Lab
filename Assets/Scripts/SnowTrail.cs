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

    //private void OnTriggerEnter(Collider collider)
    //{
    //    if (collider != null)
    //    {
    //        var points = _Renderer.transform.InverseTransformPoint(collider.gameObject.transform.position);

    //        _WaveIndex = _WaveIndex % _MaxWaveCount == 0 ? 0 : _WaveIndex;

    //        _Amplitude[_WaveIndex] = collider.attachedRigidbody.velocity.magnitude * collider.attachedRigidbody.mass / ((gameObject.GetComponent<MeshFilter>().mesh.bounds.size.magnitude /** _MeshScale*/));
    //        _OffsetX[_WaveIndex] = points.x;
    //        _OffsetZ[_WaveIndex] = points.z;
    //        _T0[_WaveIndex] = UnityEngine.Time.timeSinceLevelLoad;

    //        _Renderer.material.SetFloatArray("_OffsetX", _OffsetX);
    //        _Renderer.material.SetFloatArray("_OffsetZ", _OffsetZ);
    //        _Renderer.material.SetFloatArray("_Amplitude", _Amplitude);
    //        _Renderer.material.SetFloatArray("_T0", _T0);

    //        _WaveIndex++;
    //        OnCollided(collider, new EventArgs());
    //    }
    //    //_Renderer.material.SetTexture("_MainTex", gameObject.GetComponent<RippleComputeManager>()._RenderTexture);
    //}

    // MUST BE IN SHADER
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
