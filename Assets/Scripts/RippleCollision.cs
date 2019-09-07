using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RippleCollision : MonoBehaviour
{

    public static event EventHandler OnCollided;

    private Renderer _Renderer;
    private float _Speed;
    private float _MeshSize;
    private float _HitPower;
    private float[] _OffsetX;
    private float[] _OffsetZ;
    private float[] _TravelDistance;
    private float[] _Amplitude;
    private int _MaxWaveCount = 8; // TODO : there must be a way to extract this constant from shader. till then sync it with MAX_WAVE in ripple.shader.
    private int _WaveIndex;

    void Start()
    {
        _Renderer = gameObject.GetComponent<Renderer>();
        _MeshSize = gameObject.GetComponent<MeshFilter>().mesh.bounds.size.magnitude;

        _OffsetX = new float[_MaxWaveCount];
        _OffsetZ = new float[_MaxWaveCount];
        _TravelDistance = new float[_MaxWaveCount];
        _Amplitude = new float[_MaxWaveCount];

        _Renderer.material.SetFloatArray("_Amplitude", _Amplitude);
        _Renderer.material.SetFloatArray("_OffsetX", _OffsetX);
        _Renderer.material.SetFloatArray("_OffsetZ", _OffsetZ);
        _Renderer.material.SetFloatArray("_TravelDistance", _TravelDistance);
        _Speed = _Renderer.material.GetFloat("_Speed");
    }

    private void OnTriggerEnter(Collider collider)
    {
        if (collider != null)
        {
            var points = _Renderer.transform.InverseTransformPoint(collider.gameObject.transform.position);

            _WaveIndex = _WaveIndex % _MaxWaveCount == 0 ? 0 : _WaveIndex;

            _OffsetX[_WaveIndex] = points.x;
            _OffsetZ[_WaveIndex] = points.z;
            _Amplitude[_WaveIndex] = collider.attachedRigidbody.velocity.magnitude * collider.attachedRigidbody.mass;

            _Renderer.material.SetFloatArray("_OffsetX", _OffsetX);
            _Renderer.material.SetFloatArray("_OffsetZ", _OffsetZ);
            _Renderer.material.SetFloatArray("_Amplitude", _Amplitude);
            _WaveIndex++;
            OnCollided(collider, new EventArgs());
        }
        //_Renderer.material.SetTexture("_MainTex", gameObject.GetComponent<RippleComputeManager>()._RenderTexture);
    }

    void FixedUpdate()
    {
        _Amplitude = _Renderer.material.GetFloatArray("_Amplitude");
        for (int i = 0; i < _MaxWaveCount; i++)
        {
            if (_Amplitude[i] < 0.002f)
            {
                _TravelDistance[i] = 0.0f;
                _Amplitude[i] = 0;
            }
            else if (_Amplitude[i] > 0.0f)
            {
                _TravelDistance[i] += (_Speed / gameObject.GetComponent<MeshFilter>().mesh.bounds.size.magnitude);
                _Amplitude[i] *= 0.9f;
            }
        }
        _Renderer.material.SetFloatArray("_TravelDistance", _TravelDistance);
        _Renderer.material.SetFloatArray("_Amplitude", _Amplitude);
    }


}
