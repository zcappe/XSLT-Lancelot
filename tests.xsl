<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/> 
    
    
    <!-- Déclaration des chemins de sortie des fichiers html -->
    
    <xsl:variable name="file">
        <xsl:value-of select="replace(base-uri(.), '.xml', '')"/>
    </xsl:variable>
    
    <xsl:variable name="accueil">
        <xsl:value-of select="concat($file, 'accueil', '.html')"/>
    </xsl:variable>
    
    <xsl:variable name="indexPersonnages">
        <xsl:value-of select="concat($file, 'indexPersonnages', '.html')"/>
    </xsl:variable>  
    
    <xsl:variable name="texteNorm">
        <xsl:value-of select="concat($file, 'texteNorm', '.html')"/>
    </xsl:variable>        
    
    <xsl:variable name="texteTranscrit">
        <xsl:value-of select="concat($file, 'texteTranscrit', '.html')"/>
    </xsl:variable>
    
    
    
    <!-- Variables pour les informations que l'on retrouve sur les 
        différentes pages -->
    
    <xsl:variable name="titre1">
        <xsl:value-of select="//titleStmt/title"/>
    </xsl:variable>
    
    <xsl:variable name="titre2">
        <xsl:value-of select="//head/title"/>
    </xsl:variable>
    
    <xsl:variable name="textauthor">
        <xsl:value-of select="//titleStmt/author"/>
    </xsl:variable>
    
    
    
    <!-- Variables et templates particulières aux différentes pages: -->
    
    <!-- Page d'accueil: -->
    
    <xsl:variable name="edauthor">
        <xsl:value-of select="//titleStmt/editor/name"/>
    </xsl:variable>
    
    <xsl:variable name="nbf">
        <xsl:value-of select="//msItemStruct/locus"/>
    </xsl:variable>
    
    
    <!-- Index: -->
    
    
    
    
    <!-- Transcription normalisée: -->
    
    <xsl:template match="choice" mode="reg">
        <xsl:value-of select=".//reg/text() | .//expan//text()"/>
    </xsl:template>
    
    
    <!-- Transcription fascimilaire: -->
    
    
    
    <xsl:template match="choice" mode="orig">
        <xsl:value-of select=".//orig/text() | .//abbr/text()"/>
    </xsl:template>
    
    
    
    <xsl:variable name="imgp1">
        <span>
            <a href="{//pb[1]/@facs}">Numérisation de la page</a>
        </span>
    </xsl:variable>
    
    <xsl:variable name="imgp2">
        <span>
            <a href="{//pb[2]/@facs}">Numérisation de la page</a>
        </span>
    </xsl:variable>
    
    <xsl:variable name="imgp3">
        <span>
            <a href="{//pb[3]/@facs}">Numérisation de la page</a>
        </span>
    </xsl:variable>
    
    
    
    
    
    
    
    
    
    <!-- Mise en forme des pages du site -->
    
    <xsl:template match="/">
        
        <!-- La page d'accueil -->
        <!-- Elle présente les principales informations sur l'édition et permet d'accéder
        aux différentes pages -->
        <xsl:result-document href="{$accueil}">
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select="$titre1"/>
                    </title>
                </head>
                <body>
                    <h1>
                        <xsl:value-of select="$titre2"/>
                    </h1>
                    <h2>
                        <xsl:value-of select="$textauthor"/>
                    </h2>
                    <h3>
                        <xsl:value-of select="$nbf"/>
                    </h3>
                    <div>
                        <p>Cette édition a été réalisée par <xsl:value-of select="$edauthor"/></p>
                        <p>Le texte est disponible sous deux formes:</p>
                        <ul>
                            <li><a href="{$texteTranscrit}">édition paléographique</a></li>
                            <li><a href="{$texteNorm}">texte normalisé</a></li>
                        </ul>
                        <p>On peut aussi consulter l'<a href="{$indexPersonnages}">index des personnages</a></p>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        
        <!-- La page de la transcription normalisée -->
        
        <xsl:result-document href="{$texteNorm}">
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select="$titre1"/>
                    </title>
                </head>
                <body>
                    <h1>
                        <xsl:value-of select="$titre2"/>
                    </h1>
                    <h2>
                        <xsl:value-of select="$textauthor"/>
                    </h2>
                    <div>
                        <!-- Le texte étant en prose, il a paru intéressant de le faire apparaître dans
                        sa version normalisée sous forme de paragraphe -->
                        <p>
                            <xsl:for-each select="//l">
                                <xsl:choose>
                                    <xsl:when test="position() = 1">    
                                        <xsl:apply-templates select="text() | add/text() | persName/text() | damage/text() | supplied/text() | g/text()" 
                                            mode="reg"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="' '"/> <!-- cela permet d'avoir des espaces à chaque
                                       changement de ligne et rend le texte plus lisible, mais pose le problème des
                                       espaces entre les coupures de mots-->
                                        <xsl:apply-templates select="text() | add/text() | persName/text() | damage/text() | supplied/text() | g/text()" 
                                            mode="reg"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </p>
                    </div>
                    <div>
                        <p><a href="{$accueil}">Retour à la page d'accueil</a></p>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- La page de la transcription fascimilaire -->
        
        <xsl:result-document href="{$texteTranscrit}">
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select="$titre1"/>
                    </title>
                </head>
                <body>
                    <h1>
                        <xsl:value-of select="$titre2"/>
                    </h1>
                    <h2>
                        <xsl:value-of select="$textauthor"/>
                    </h2>
                    <div>
                        <ul>
                            <xsl:for-each select="//l">
                                <xsl:choose>
                                    <xsl:when test="position() = 1">
                                        <xsl:element name="li">
                                            <xsl:apply-templates select="text() | add/text() | persName/text() | damage/text() | supplied/text() | g/text()" mode="orig"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="li">
                                            <xsl:apply-templates select="text() | add/text() | persName/text() | damage/text() | supplied/text() | g/text()"
                                                mode="orig"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <div>
                        <p><a href="{$accueil}">Retour à la page d'accueil</a></p>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- La page de l'index des personnages -->
        
        <xsl:result-document href="{$indexPersonnages}">
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select="$titre1"/>
                    </title>
                </head>
                <body>
                    <h1>
                        <xsl:value-of select="$titre2"/>
                    </h1>
                    <h2>
                        <xsl:value-of select="$textauthor"/>
                    </h2>
                    <div>
                        
                    </div>
                    <div>
                        <p><a href="{$accueil}">Retour à la page d'accueil</a></p>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        
        
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    
    
</xsl:stylesheet>