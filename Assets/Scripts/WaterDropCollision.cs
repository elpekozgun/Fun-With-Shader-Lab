using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterDropCollision : MonoBehaviour
{
    private Renderer _Renderer;
    private MeshFilter _MeshFilter;
    private GameObject _Collider;

    public float WaveAmplitude;
    public float Distance;
    public float WaveSpeed;
    [Range(1, 100)]
    public float VelocityFineTune;

    public static event EventHandler OnCollided;

    void Start()
    {
        _Renderer = gameObject.GetComponent<Renderer>();
        _MeshFilter = this.gameObject.GetComponent<MeshFilter>();
    }

    private void OnTriggerEnter(Collider collider)
    {
        if (collider != null)
        {
            _Collider = collider.gameObject;

            WaveAmplitude = 0;
            Vector2 dist = Vector2.zero;

            dist.x = (gameObject.transform.position.x - collider.gameObject.transform.position.x);
            dist.y = (gameObject.transform.position.z - collider.gameObject.transform.position.z);

            _Renderer.material.SetVector
            (
                "_Offset",
                new Vector4
                (
                    dist.x /*/ _MeshFilter.mesh.bounds.size.x*/,
                    dist.y /*/ _MeshFilter.mesh.bounds.size.z*/
                )
            );

            _Renderer.material.SetVector
            (
                "_Impact",
                new Vector4
                (
                    collider.gameObject.transform.position.x,
                    collider.gameObject.transform.position.z
                )
            );

            _Renderer.material.SetFloat("_WaveAmplitude", collider.attachedRigidbody.velocity.magnitude / VelocityFineTune);
            OnCollided(collider, new EventArgs());
        }
    }

    void Update()
    {
        if (_Collider != null)
        {
            WaveAmplitude = _Renderer.material.GetFloat("_WaveAmplitude");
            if (WaveAmplitude < 0.01f)
            {
                Distance = 0.0f;
                _Renderer.material.SetFloat("_WaveAmplitude", 0);
            }
            else if (WaveAmplitude > 0.0f)
            {
                //Distance += WaveSpeed;
                Distance = 10;
                _Renderer.material.SetFloat("_Distance", Distance);
                _Renderer.material.SetFloat("_WaveAmplitude", WaveAmplitude * 0.98f);
            }

        }
    }
}
