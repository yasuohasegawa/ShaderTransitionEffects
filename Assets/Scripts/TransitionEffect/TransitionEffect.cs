using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class TransitionEffect : MonoBehaviour
{
    [SerializeField] private Material _mat;
    [SerializeField] private Material _mat2;
    [SerializeField] private Material _mat3;
    private Tweener _tw;
    private List<Tweener> _tws = new List<Tweener>();

    // Start is called before the first frame update
    void Start()
    {
        ResetEffect();
    }

    private void ApplyEffect(Material mat)
    {
        if (_tw != null)
        {
            _tw.Kill();
            _tw = null;
        }
        mat.SetFloat("_EffectVal", 0);
        _tw = DOVirtual.Float(0, 1, 2f, (val) =>
        {
            mat.SetFloat("_EffectVal", val);
        }).SetEase(Ease.InOutCubic);
    }

    [ContextMenu("TestEffect")]
    private void TestEffect()
    {
        ApplyEffect(_mat);
    }

    [ContextMenu("TestEffect2")]
    private void TestEffect2()
    {
        ApplyEffect(_mat2);
    }

    [ContextMenu("TestEffect3")]
    private void TestEffect3()
    {
        for (var i = 0; i< _tws.Count; i++)
        {
            var tw = _tws[i];
            if (tw != null) _tw.Kill(); _tw = null;
        }
        _tws.Clear();

        var posList = new List<Vector4>();
        var sizeList = new List<float>();

        for (var i = 0; i<5; i++)
        {
            float x = Random.Range(-0.5f, 0.5f);
            float y = Random.Range(-0.27f, 0.27f);
            posList.Add(new Vector4(x, y, 0, 0));
            sizeList.Add(0);
        }

        _mat3.SetVectorArray("_CirclePos", posList);
        _mat3.SetFloatArray("_CircleSize", sizeList);

        for (var i = 0; i < sizeList.Count; i++)
        {
            var index = i;
            var tw = DOVirtual.Float(0, 1f, 1.5f, (val) =>
            {
                sizeList[index] = val;
                _mat3.SetFloatArray("_CircleSize", sizeList);
            }).SetEase(Ease.InOutCubic).SetDelay(i * 0.06f);
            _tws.Add(tw);
        }
    }

    [ContextMenu("ResetEffect")]
    private void ResetEffect()
    {
        _mat.SetFloat("_EffectVal", 0);
        _mat2.SetFloat("_EffectVal", 0);

        var posList = new List<Vector4>();
        var sizeList = new List<float>();
        for (var i = 0; i < 5; i++)
        {
            posList.Add(new Vector4(999, 999, 0, 0));
            sizeList.Add(0);
        }
        _mat3.SetVectorArray("_CirclePos", posList);
        _mat3.SetFloatArray("_CircleSize", sizeList);
    }
}
