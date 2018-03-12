<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:common="http://exslt.org/common">

  <xsl:variable name="CESectionNames">
    <sections>
      <section id="bly">Blood and lymph disorders</section>
      <section id="cvd">Cardiovascular disorders</section>
      <section id="chd">Child health</section>
      <section id="dia">Diabetes</section>
      <section id="dsd">Digestive system disorders</section>
      <section id="ent">Ear, nose, and throat disorders</section>
      <section id="end">Endocrine and metabolic disorders</section>
      <section id="eyd">Eye disorders</section>
      <section id="hiv">HIV and AIDS</section>
      <section id="ind">Infectious diseases</section>
      <section id="knd">Kidney disorders</section>
      <section id="lfs">Lifestyle</section>
      <section id="msh">Men's health</section>
      <section id="meh">Mental health</section>
      <section id="msd">Musculoskeletal disorders</section>
      <section id="nud">Neurological disorders</section>
      <section id="onc">Oncology</section>
      <section id="orh">Oral health</section>
      <section id="poc">Perioperative care</section>
      <section id="pos">Poisoning</section>
      <section id="pac">Pregnancy and childbirth</section>
      <section id="rda">Respiratory disorders (acute)</section>
      <section id="rdc">Respiratory disorders (chronic)</section>
      <section id="seh">Sexual health</section>
      <section id="skd">Skin disorders</section>
      <section id="sld">Sleep disorders</section>
      <section id="sch">Social and community health</section>
      <section id="spc">Supportive and palliative care</section>
      <section id="trh">Travel health</section>
      <section id="woh">Women's health</section>
      <section id="wnd">Wounds</section>
    </sections>
  </xsl:variable>
  
  <xsl:template name="ce-section-name">
    <xsl:param name="id"/>
    <xsl:apply-templates select="common:node-set($CESectionNames)//section[@id=$id]"/>
  </xsl:template>
  
</xsl:stylesheet>
