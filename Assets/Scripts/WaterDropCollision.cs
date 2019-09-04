using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterDropCollision : MonoBehaviour
{
    private Renderer _Renderer;
    private MaterialPropertyBlock _Block;
    private MeshFilter _MeshFilter;
    
    public int WaveNo;
    public float DistanceX;
    public float DistanceZ;
    public float[] WaveAmplitudes;
    [Range(1,100)]
    public float VelocityFineTune;

    void Start()
    {
        _Renderer = gameObject.GetComponent<Renderer>();
        _Block = new MaterialPropertyBlock();
        _MeshFilter = this.gameObject.GetComponent<MeshFilter>();
        _Renderer.GetPropertyBlock(_Block);
        _Renderer.SetPropertyBlock(_Block);
        WaveAmplitudes = new float[8];
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.rigidbody != null)
        {
            WaveNo++;
            if (WaveNo == 9)
            {
                WaveNo = 1;
            }
            WaveAmplitudes[WaveNo - 1] = 0;
            var dist = (gameObject.transform.position - collision.transform.position);
            DistanceX = dist.x;
            DistanceZ = dist.z;

            _Renderer.sharedMaterial.SetFloat("_OffsetX" + WaveNo, DistanceX / _MeshFilter.mesh.bounds.size.x);
            _Renderer.sharedMaterial.SetFloat("_OffsetZ" + WaveNo, DistanceZ / _MeshFilter.mesh.bounds.size.z);
            _Renderer.sharedMaterial.SetFloat("_WaveAmplitude" + WaveNo, collision.rigidbody.velocity.magnitude / VelocityFineTune);
        }
    }

    void Update()
    {
        for (int i = 1; i < 9; i++)
        {
            WaveAmplitudes[i-1] = _Renderer.sharedMaterial.GetFloat("_WaveAmplitude" + i);
            if (WaveAmplitudes[i-1] < 0.01f)
            {
                _Renderer.sharedMaterial.SetFloat("_WaveAmplitude" + i, 0);
            }
            else
            {
                _Renderer.sharedMaterial.SetFloat("_WaveAmplitude" + i, WaveAmplitudes[i - 1] * 0.99f);
            }
        }

    }
}
