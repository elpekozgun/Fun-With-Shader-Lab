using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RippleCollision : MonoBehaviour
{

    private Renderer _Renderer;
    private float _Amplitude;
    private float _TravelDistance;
    private float _Speed;
    private float _MeshSize;
    private float _InitialHitAmplitude;

    void Start()
    {
        _Renderer = gameObject.GetComponent<Renderer>();
        _MeshSize = gameObject.GetComponent<MeshFilter>().mesh.bounds.size.magnitude;
        _InitialHitAmplitude = 1f;
        _Speed = 0.1f;  _Renderer.material.GetFloat("_Speed");
    }


    private void OnTriggerEnter(Collider collider)
    {
        
    }


    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Mouse0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            Physics.Raycast(ray,out RaycastHit info);
            if (info.collider != null && info.collider.gameObject.name == this.gameObject.name)
            {
                var points = _Renderer.transform.InverseTransformPoint(info.point);
                _Renderer.material.SetFloat("_OffsetX", points.x);
                _Renderer.material.SetFloat("_OffsetZ", points.z);
                _Renderer.material.SetFloat("_Amplitude", _InitialHitAmplitude);
            }
            
        }

        _Amplitude = _Renderer.material.GetFloat("_Amplitude");
        if (_Amplitude < 0.0005f)
        {
            _TravelDistance = 0.0f;
            _Renderer.material.SetFloat("_TravelDistance", _TravelDistance);
            _Renderer.material.SetFloat("_Amplitude", 0);
        }
        else if (_Amplitude > 0.0f)
        {
            _TravelDistance += 0.1f;
            _Renderer.material.SetFloat("_TravelDistance", _TravelDistance);
            _Renderer.material.SetFloat("_Amplitude", _Amplitude * 0.9f);
        }
    }


}
