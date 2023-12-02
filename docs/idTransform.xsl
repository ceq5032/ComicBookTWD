<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="yes" include-content-type="no"
        indent="yes"/>


    <xsl:template match="panel">
        <panel num="{count(preceding-sibling::panel) + 1}">
            <xsl:apply-templates/>

        </panel>


    </xsl:template>
    <xsl:template match="/">
        <html>
            <head>
                <title>The Walking Dead Characters</title>
                <link rel="stylesheet" type="text/css" href="style.css"/>
            </head>
            <body>

                <h1>
                    <xsl:apply-templates select="descendant::title"/>
                </h1>
                <div id="table">
                    
                    
                    <xsl:variable name="docTree" as="document-node()" select="current()"/>
                    
                    
                    
                    <xsl:variable name="myData" as="item()+" select=".//balloon/@who ! normalize-space() ! 
                        tokenize(., ' ') => distinct-values() => sort()"/>
                    
                    
                    
                    
                    <table>
                        <tr>
                            <th>Character</th>
                            <th>Panels</th>
                            
                        </tr>
                        
                        <xsl:for-each select="$myData"> 
                            
                            <tr>
                                
                                <td><xsl:value-of select="substring-after(., '#')"/></td>
                                <td>
                                    <ul>
                                        <xsl:apply-templates select="$docTree//div[@type='page' and panel[contains(@who, current()) ]]" mode="toc">
                                            <xsl:with-param name="currentCharacter" as="item()" select="current()"/>  
                                        </xsl:apply-templates>
                                        
                                        
                                    </ul>
                                </td>
                                
                                
                                
                            </tr>
                            
                            
                        </xsl:for-each>
                        
                    </table>
                    
                </div>   
                

                <div id="reading-view">
                    <xsl:apply-templates select="descendant::comic"/>
                </div>

            </body>
        </html>
    </xsl:template>
    <xsl:template match="panel" mode="toc">
        <xsl:param name="currentCharacter"/>
        <xsl:if test="@who ! contains(., $currentCharacter)">
            <li>
                <a href="#{ancestor::page/@num}-panel-{@num}">Panel <xsl:value-of select="@num"/></a>
            </li>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="page[@num = 'page']" mode="toc">
        <xsl:param name="currentCharacter"/>

        <li>Page <xsl:value-of select="@who ! substring-after(., '_')"/>
            <ul>
                <xsl:apply-templates select="descendant::balloon" mode="toc"> <xsl:with-param
                        name="currentCharacter" select="$currentCharacter"/>
                </xsl:apply-templates>
            </ul>
        </li>

<!-- I can not remember or figure out how to get the panels listed for when the characters show up -->

    </xsl:template>

    <xsl:template match="panel" mode="toc">
        <xsl:param name="currentCharacter"/>
        <xsl:if test="@who ! contains(., $currentCharacter)">
            <li>
                <a href="{ancestor::page/@num}-panel-{@n}">Panel <xsl:value-of select="@n"/></a>
            </li>
        </xsl:if>

    </xsl:template>
    
    <xsl:template match="page">
        <section class="{@num}">
            <xsl:apply-templates/>
        </section>
    </xsl:template>


    <xsl:template match="panel[@n = 'page']">
        <section class="{@n}" id="{@who}">
            <xsl:apply-templates/>

        </section>
    </xsl:template>

    <xsl:template match="panel">
        <div class="panel">

            <xsl:apply-templates/>

        </div>

    </xsl:template>

    <xsl:template match="panelDesc">
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="action">
        <p class="action">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="balloon">
        <p class="{name()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="sound">
        <span class="{name()}" style="color:red">
            <xsl:apply-templates/>
        </span>
    </xsl:template>





</xsl:stylesheet>
