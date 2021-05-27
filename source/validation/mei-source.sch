<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>

    <sch:pattern id="gi">
        <sch:rule context="tei:gi[@scheme = 'MEI']">
            <sch:let name="ident_vals" value="//tei:elementSpec/@ident/string()"/>
            <sch:assert role="error"
                test="
                    some $ident in $ident_vals
                        satisfies ($ident = text()/string())"
                >A &lt;gi scheme="MEI"&gt;<sch:value-of select="text()"/>&lt;/gi&gt; references an element unknown to
                MEI. It has to match an //elementSpec/@ident.</sch:assert>
        </sch:rule>
        <sch:p>A &lt;gi&gt; in the MEI scheme must reference a value from &lt;elementSpec&gt;/@ident.</sch:p>
    </sch:pattern>

    <sch:pattern id="ident">
        <sch:rule context="tei:ident[@type = 'class']">
            <sch:let name="ident_vals" value="//tei:classSpec[@type = ('atts', 'model')]/@ident/string()"/>
            <sch:assert role="error"
                test="
                    some $ident in $ident_vals
                        satisfies ($ident = text()/string())"
                >The &lt;<sch:name/>&gt; contains text which is not declared in any
                &lt;classSpec&gt;/@ident.</sch:assert>
            <sch:p>The text value of &lt;ident&gt; must be equal to at least one value of
                &lt;classSpec&gt;/@ident.</sch:p>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="ptr">
        <sch:rule context="tei:ptr[starts-with(@target, '#')]">
            <sch:let name="div_IDs" value="//tei:div/@xml:id/string()"/>
            <sch:let name="target" value="substring-after(@target, '#')"/>
            <sch:assert role="error"
                test="
                    some $id in $div_IDs
                        satisfies ($id = $target)">The
                &lt;<sch:name/>&gt; points to a &lt;div&gt;/xml:id which wasn't declared.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- check whether att.class names conform to some general principles -->
    <sch:pattern id="attClassNames">
        <sch:rule context="tei:classSpec[@type = 'atts']/@ident">
            <sch:assert test="not(ends-with(., '.visual'))">For consistency reasons, the att.class "<sch:value-of
                    select="."/>" in the "<sch:value-of select="parent::tei:classSpec/@module"/>" module has to be
                renamed to "<sch:value-of select="replace(., '\.visual', '.vis')"/>".</sch:assert>
            <sch:assert test="not(ends-with(., '.logical'))">For consistency reasons, the att.class "<sch:value-of
                    select="."/>" in the "<sch:value-of select="parent::tei:classSpec/@module"/>" module has to be
                renamed to "<sch:value-of select="replace(., '\.logical', '.log')"/>".</sch:assert>
            <sch:assert test="not(ends-with(., '.gestural'))">For consistency reasons, the att.class "<sch:value-of
                    select="."/>" in the "<sch:value-of select="parent::tei:classSpec/@module"/>" module has to be
                renamed to "<sch:value-of select="replace(., '\.gestural', '.ges')"/>".</sch:assert>
            <sch:assert test="not(ends-with(., '.analytical'))">For consistency reasons, the att.class "<sch:value-of
                    select="."/>" in the "<sch:value-of select="parent::tei:classSpec/@module"/>" module has to be
                renamed to "<sch:value-of select="replace(., '\.analytical', '.anl')"/>".</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- check whether modules are handled properly -->
    <sch:pattern id="moduleStructure">
        <sch:rule context="tei:specGrp//@module">
            <sch:assert test=". = ancestor::tei:specGrp/tei:moduleSpec/@ident">
                The <sch:value-of select="parent::*/local-name()"/> "<sch:value-of select="parent::*/@ident"/>" with
                @module="<sch:value-of select="."/>"  must not be stored in the 
                <sch:value-of select="ancestor::tei:specGrp/tei:moduleSpec/@ident"/>.xml file, but in <sch:value-of select="."/>.xml.
            </sch:assert>
        </sch:rule>
        <sch:rule context="tei:classSpec[@type = 'atts']">
            <sch:assert test="not(ends-with(@ident,'.vis')) or @module = 'MEI.visual'">
                Visual domain attribute class "<sch:value-of select="@ident"/>" needs to be put into the MEI.visual module
                and must be moved from <sch:value-of select="@module"/>.xml to the MEI.visual.xml file.
            </sch:assert>
            <sch:assert test="not(ends-with(@ident,'.ges')) or @module = 'MEI.gestural'">
                Gestural domain attribute class "<sch:value-of select="@ident"/>" needs to be put into the MEI.gestural module
                and must be moved from <sch:value-of select="@module"/>.xml to the MEI.gestural.xml file.
            </sch:assert>
            <sch:assert test="not(ends-with(@ident,'.anl')) or @module = 'MEI.analytical'">
                Analytical domain attribute class "<sch:value-of select="@ident"/>" needs to be put into the MEI.analytical module
                and must be moved from <sch:value-of select="@module"/>.xml to the MEI.analytical.xml file.
            </sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- check that each chapter in the guidelines body has an @xml:id -->
    <sch:pattern id="div">
        <sch:rule context="tei:div[ancestor::tei:body]">
            <sch:assert role="error" test="@xml:id">The &lt;<sch:name/>&gt; has no @xml:id.</sch:assert>
        </sch:rule>
    </sch:pattern>

</sch:schema>
