using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawSnowTrack : MonoBehaviour
{
    public Shader SnowTrailDrawShader;

    private RenderTexture _TrailMap;
    private Material _SnowMaterial;
    private Material _DrawMaterial;


    private void Start()
    {
        _DrawMaterial = new Material(SnowTrailDrawShader);
        _DrawMaterial.SetVector("_Color", Color.red);

        _SnowMaterial = gameObject.GetComponent<MeshRenderer>().material;
        _TrailMap = new RenderTexture(1024, 1024, 0,RenderTextureFormat.ARGBFloat);
        _SnowMaterial.SetTexture("_TrailMap", _TrailMap);
    }


    private void Update()
    {
        if (Input.GetKey(KeyCode.Mouse0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out RaycastHit  info))
            {

                _DrawMaterial.SetVector("_Coordinate", new Vector4(info.textureCoord.x, info.textureCoord.y, 0, 0 ));
                RenderTexture temp = RenderTexture.GetTemporary(_TrailMap.width, _TrailMap.height, 0, RenderTextureFormat.ARGBFloat);
                Graphics.Blit(_TrailMap, temp);
                Graphics.Blit(temp, _TrailMap, _DrawMaterial);
                RenderTexture.ReleaseTemporary(temp);
            }
        }
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, 256, 256), _TrailMap, ScaleMode.ScaleToFit, false, 1);
    }

}
