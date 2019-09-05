using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpherePositionSetter : MonoBehaviour
{
    // Start is called before the first frame update

    private MeshRenderer mat;
    private MaterialPropertyBlock block;

    void Start()
    {
        mat = this.gameObject.GetComponent<MeshRenderer>();
        block = new MaterialPropertyBlock();
        mat.SetPropertyBlock(block);
    }

    private void Update()
    {
        if (block != null)
        {
            block.SetVector("_SphereCenter", new Vector4(this.transform.position.x, this.transform.position.y, this.transform.position.z, 0));

            //mat.material.SetVector("_SphereCenter", new Vector4(this.transform.position.x, this.transform.position.y, this.transform.position.z, 0));

            float minScaleVal = transform.localScale.x;
            minScaleVal = minScaleVal < transform.localScale.y ? minScaleVal : transform.localScale.y;
            minScaleVal = minScaleVal < transform.localScale.z ? minScaleVal : transform.localScale.z;

            block.SetFloat("_SphereRadius", minScaleVal * 0.5f);

            mat.SetPropertyBlock(block);
        }

        //Debug.Log(mat.material.GetFloat("_Depth"));
    }

}
