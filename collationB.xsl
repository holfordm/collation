<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
    <xsl:variable name="collationStructure">
        <xsl:for-each select="collation/gatheringRange">
            
            
            <xsl:choose>
                <!-- ranges of complete quires -->
                <xsl:when test="child::end">
                    <xsl:variable name="start" select="start" as="xs:integer"/>
                    <xsl:variable name="end" select="end" as="xs:integer"/>
                    <xsl:variable name="totalQuires" select="$end - $start"/>
                    <xsl:variable name="leaves" select="leaves"/>
                    <xsl:for-each select="1 to ($totalQuires +1)">
                        <xsl:variable name="quire" select=". + ($start - 1)"></xsl:variable>
                        <quire n="{$quire}">
                            <xsl:for-each select="1 to $leaves">
                                <leaf n="{.}" quire="{$quire}"/>
                            </xsl:for-each>
                        </quire>
                    </xsl:for-each>
                </xsl:when>
                
                <!-- single quires that may or may not have missing or added leaves -->
                <xsl:otherwise>
                   
                    <!-- construct the full gathering -->
                    <xsl:variable name="quire" select="start" as="xs:integer"/>
                    
                    <xsl:variable name="missingLeaves">
                        <xsl:for-each select="missing">
                            <xsl:variable name="missingStart" select="(if(./start) then ./start else .)"/>
                            <xsl:variable name="missingEnd" select="(if(./end) then ./end else $missingStart)"/>
                            <xsl:for-each select="$missingStart to $missingEnd"><missing><xsl:value-of
                                select="."/></missing></xsl:for-each>
                            
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="addedLeaves">
                        <xsl:for-each select="added">
                            <added after="{@after}" before="{@before}"><xsl:value-of select="."/></added>
                        </xsl:for-each>
                        <!--<xsl:for-each select="added[@after]">
                            <addedAfter><xsl:value-of select="."/></addedAfter>
                        </xsl:for-each>-->
                    </xsl:variable>
                    
                    <!--<xsl:copy-of select="$addedLeaves"/>-->
                    
                    <xsl:variable name="fullGathering">
                        <quire n="{$quire}"><xsl:for-each select="1 to leaves">
                            <leaf n="{.}" quire="{$quire}"/>
                        </xsl:for-each></quire>
                    </xsl:variable>
                    <!--
                    <xsl:copy-of select="$fullGathering"/>-->
                    
                    <!-- put in added leaves -->
                    <xsl:variable name="added">
                        <quire n="{$quire}"><xsl:for-each select="$fullGathering/quire/leaf"><xsl:variable name="n" select="./@n"/>
                            <xsl:choose>
                                
                                <xsl:when test="$n = $addedLeaves/*/@before"><xsl:for-each select="1 to $addedLeaves/added[@before=$n]"><leaf added="yes"  quire="{$quire}"/></xsl:for-each>
                                <xsl:copy-of select="."/></xsl:when>
                                <xsl:when test="./@n = $addedLeaves/*/@after">
                                    <xsl:copy-of select="."/><xsl:for-each select="1 to $addedLeaves/added[@after=$n]"><leaf quire="{$quire}" added="yes"  /></xsl:for-each></xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each></quire>
                    </xsl:variable>
                    
                    <!-- remove missing leaves -->
                    <xsl:variable name="final">
                        <quire n="{$quire}"><xsl:for-each select="$added/quire/leaf">
                            <xsl:choose>
                                <xsl:when test="./@n = $missingLeaves/*"><leaf n="{@n}" quire="{$quire}" missing="yes"  /></xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each></quire>
                        
                    </xsl:variable>
                    
                    <xsl:copy-of select="$final"/>
                    
                </xsl:otherwise>
                
            </xsl:choose>
        </xsl:for-each>
        
    </xsl:variable>
    
     
    
    <!-- display collation structure without folio numbers -->
    <!--<xsl:copy-of select="$collationStructure"/>-->
    
    
    
    <!-- call following templates to add folio numbers -->
    <xsl:call-template name="addFolios">
        <xsl:with-param name="collationStructure" select="$collationStructure"/>
        <xsl:with-param name="lastQuire" select="$collationStructure/quire[position()=last()]/@n"/>
    </xsl:call-template>
    
    </xsl:template>
    
    
    
    <xsl:template name="addFolios">
        <xsl:param name="collationStructure"/>
        <xsl:param name="startFolio" select="1"/>
        <xsl:param name="quire" select="1"/>
        <xsl:param name="lastQuire"/>
        
        <quire n="{$quire}">
            <xsl:call-template name="addNumbers">
                <xsl:with-param name="leaves" select="$collationStructure/quire[@n=$quire]"/>
                <xsl:with-param name="startFolio" select="$startFolio"/>
                <xsl:with-param name="pos" select="1"/>
                <xsl:with-param name="last" select="count($collationStructure/quire[@n=$quire]/leaf)"/>
            </xsl:call-template>
            
        
        
        </quire>
        <xsl:if test="number($quire) lt number($lastQuire)">
            <xsl:call-template name="addFolios">
            <xsl:with-param name="collationStructure" select="$collationStructure"/>
                <xsl:with-param name="lastQuire" select="$lastQuire"/>
                <xsl:with-param name="quire" select="$quire + 1"/>
                <xsl:with-param name="startFolio" select="$startFolio + count($collationStructure/quire[@n=$quire]/leaf[not(@missing)])"/>
        </xsl:call-template></xsl:if>
        
        
    
    </xsl:template>
    
    
    <xsl:template name="addNumbers">
        <xsl:param name="startFolio"/>
        <xsl:param name="leaves"/>
        <xsl:param name="last"/>
        <xsl:param name="pos"/>
        
        
        <xsl:for-each select="$leaves/leaf[number($pos)]">
        <xsl:choose>
            <xsl:when test=".[@missing]">
                <xsl:copy-of select="."/>
                <xsl:if test="number($pos) lt number($last)">
                <xsl:call-template name="addNumbers">
                    <xsl:with-param name="last" select="$last"/>
                    <xsl:with-param name="pos" select="$pos + 1"></xsl:with-param>
                    <xsl:with-param name="leaves" select="$leaves"/>
                    <xsl:with-param name="startFolio" select="$startFolio"></xsl:with-param>
                </xsl:call-template></xsl:if>
                    
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    
                    <xsl:attribute name="folio" select="$startFolio"/>
                </xsl:copy>
                <xsl:if test="number($pos) lt number($last)">
                    <xsl:call-template name="addNumbers">
                        <xsl:with-param name="last" select="$last"/>
                        <xsl:with-param name="pos" select="$pos + 1"></xsl:with-param>
                        <xsl:with-param name="leaves" select="$leaves"/>
                        <xsl:with-param name="startFolio" select="$startFolio +1"></xsl:with-param>
                    </xsl:call-template></xsl:if>
            </xsl:otherwise>
            
        </xsl:choose></xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>