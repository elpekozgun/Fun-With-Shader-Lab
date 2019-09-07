using UnityEngine;


public struct Droplet
{
    Vector3 position;
    float radius;
}


public class RippleComputeManager : MonoBehaviour
{

    public ComputeShader _RippleComputeShader;
    public RenderTexture _RenderTexture;
    private int _Kernel;

    public void Start()
    {
        int _Kernel = _RippleComputeShader.FindKernel("FillWithRed");
        _RenderTexture = new RenderTexture(512, 512, 24);
        _RenderTexture.enableRandomWrite = true;
        _RenderTexture.Create();
        _RippleComputeShader.SetTexture(_Kernel, "Result", _RenderTexture);

        Compute();

        //Droplet[] droplets = new Droplet[8];
        //ComputeBuffer dropletBuffer = new ComputeBuffer(droplets.Length, sizeof(float) * 4);
        //_RippleComputeShader.SetBuffer(0, "_Droplets", dropletBuffer);
        //dropletBuffer.Release();
    }

    public void Compute()
    {
        _RippleComputeShader.Dispatch(_Kernel, 512 >> 3, 512 >> 3, 1);
    }
    
}
