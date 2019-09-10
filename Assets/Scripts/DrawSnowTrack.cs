using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawSnowTrack : MonoBehaviour
{
    public Shader SnowTrailDrawShader;

    private RenderTexture _TrailMap;
    private Material _SnowMaterial;
    private Material _TrailMaterial;
    public Transform _Transform;
    private int _LayerMask;

    [Range(0,2)]
    public float BrushSize;
    [Range(0,1)]
    public float BrushStrength;

    private void Start()
    {
        _LayerMask = LayerMask.GetMask("Ground");
        _TrailMaterial = new Material(SnowTrailDrawShader);
        _TrailMaterial.SetVector("_Color", Color.red);
        BrushSize = _TrailMaterial.GetFloat("_Size");
        BrushStrength = _TrailMaterial.GetFloat("_Strength");

        //_SnowMaterial = gameObject.GetComponent<Terrain>().materialTemplate;
        _SnowMaterial = gameObject.GetComponent<Renderer>().material;
        _TrailMap = new RenderTexture(1024, 1024, 0,RenderTextureFormat.ARGBFloat);
        _SnowMaterial.SetTexture("_TrailMap", _TrailMap);
    }

    //private void OnCollisionStay(Collision collision)
    //{
    //    if (collision != null)
    //    {
    //        Ray ray = new Ray(collision.contacts[0].point - collision.contacts[0].normal, collision.contacts[0].normal);

    //        if (Physics.Raycast(ray, out RaycastHit info))
    //        {
    //            _TrailMaterial.SetVector("_Coordinate", new Vector4(info.textureCoord.x, info.textureCoord.y, 0, 0));
    //            RenderTexture temp = RenderTexture.GetTemporary(_TrailMap.width, _TrailMap.height, 0, RenderTextureFormat.ARGBFloat);
    //            Graphics.Blit(_TrailMap, temp);
    //            Graphics.Blit(temp, _TrailMap, _TrailMaterial);
    //            RenderTexture.ReleaseTemporary(temp);
    //        }
    //    }
    //}

    //private void Update()
    //{
    //    if (Input.GetKey(KeyCode.Mouse0))
    //    {
    //        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
    //        if (Physics.Raycast(ray, out RaycastHit info))
    //        {
    //            _TrailMaterial.SetFloat("_Size", BrushSize);
    //            _TrailMaterial.SetFloat("_Strength", BrushStrength);
    //            _TrailMaterial.SetVector("_Coordinate", new Vector4(info.textureCoord.x, info.textureCoord.y, 0, 0));
    //            RenderTexture temp = RenderTexture.GetTemporary(_TrailMap.width, _TrailMap.height, 0, RenderTextureFormat.ARGBFloat);
    //            Graphics.Blit(_TrailMap, temp);
    //            Graphics.Blit(temp, _TrailMap, _TrailMaterial);
    //            RenderTexture.ReleaseTemporary(temp);
    //        }
    //    }
    //}

    private void Update()
    {
        if (Physics.Raycast(_Transform.position, Vector3.down, out RaycastHit info, transform.localScale.x * 0.5f, _LayerMask))
        {
            _TrailMaterial.SetVector("_Coordinate", new Vector4(info.textureCoord.x, info.textureCoord.y, 0, 0));
            RenderTexture temp = RenderTexture.GetTemporary(_TrailMap.width, _TrailMap.height, 0, RenderTextureFormat.ARGBFloat);
            Graphics.Blit(_TrailMap, temp);
            Graphics.Blit(temp, _TrailMap, _TrailMaterial);
            RenderTexture.ReleaseTemporary(temp);
        }
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, 256, 256), _TrailMap, ScaleMode.ScaleToFit, false, 1);
    }

}
