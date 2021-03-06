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
        <xsl:value-of select="concat($file, '_accueil', '.html')"/>
    </xsl:variable>
    
    <xsl:variable name="indexPersonnages">
        <xsl:value-of select="concat($file, '_indexPersonnages', '.html')"/>
    </xsl:variable>  
    
    <xsl:variable name="texteNorm">
        <xsl:value-of select="concat($file, '_texteNorm', '.html')"/>
    </xsl:variable>        
    
    <xsl:variable name="texteTranscrit">
        <xsl:value-of select="concat($file, '_texteTranscrit', '.html')"/>
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
    
    <xsl:variable name="eddate">
        <xsl:value-of select="//publicationStmt/date"/>
    </xsl:variable>
    
    <xsl:variable name="nbf">
        <xsl:value-of select="//msItemStruct/locus"/>
    </xsl:variable>
    
        
    <!-- Index: -->
        
    <xsl:template name="index">
        <xsl:for-each select=".//listPerson/person">
            <li>
                <!-- Pour donner plus d'informations sur les personnages, les notes, quand 
                    il y en a, sont ajoutées entre parenthèses à côté de leur nom -->
                <xsl:variable name="person">
                    <xsl:value-of select=".//persName"/>
                </xsl:variable>
                
                <xsl:variable name="notepers">
                    <xsl:value-of select="lower-case(.//note/text())"/>
                </xsl:variable>
                
                <xsl:choose>
                    <xsl:when test=".//note/text()">
                        <xsl:value-of select="concat($person, ' (', $notepers, ')')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$person"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:variable name="idPerson">
                    <xsl:value-of select=".//@xml:id"/>
                </xsl:variable>
                
                <xsl:text> : </xsl:text>
                
                <!-- Pour éviter des problèmes de chevauchement des balises, les noms ont parfois
                été encodés seulement en partie dans l'édition. C'est pourquoi seules les lignes
                où les personnages apparaissent sont indiquées dans l'index -->
                <xsl:for-each select="ancestor::TEI//body//persName[replace(@ref, '#', '')=$idPerson]">
                    <xsl:text> l.</xsl:text>
                    <xsl:value-of select="count(parent::l/preceding::l) + 1"/>
                    <xsl:choose>
                        <xsl:when test="position()!=last()">, </xsl:when>
                        <xsl:otherwise>.</xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </li>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- Transcription normalisée: -->
    
    <!-- cette variable permet de récupérer les caractères dans leur version
    normalisée quand il y a un choix possible -->
    <xsl:template match="choice" mode="reg">
        <xsl:value-of select=".//reg/text() | .//expan//text()"/>
    </xsl:template>
    
    
    <!-- Transcription fascimilaire: -->
    
    <!-- cette variable permet de récupérer les caractères tels qu'ils ont été
        écrits dans le texte original quand il y a un choix possible -->
    <xsl:template match="choice" mode="orig">
        <xsl:value-of select=".//orig/text() | .//abbr/text()"/>
    </xsl:template>
    
    


    <!-- Mise en forme des pages du site -->
    
    <!-- Utiliser un template qui matche tout l'ensemble des balises permet d'éviter
    d'avoir du texte non voulu dans la version de sortie de l'édition, comme ici pour
    la majeure partie du teiHeader qui n'apporte pas d'informations importantes pour
    la présente valorisation de l'édition -->
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
                        <p>Cette édition a été réalisée par <xsl:value-of select="concat($edauthor, ', en ', $eddate)"/>.</p>
                        <p>Le texte est disponible sous deux formes:</p>
                        <ul>
                            <li><a href="{$texteTranscrit}">transcription fascimilaire</a></li>
                            <li><a href="{$texteNorm}">transcription normalisée</a></li>
                        </ul>
                        <p>On peut aussi consulter l'<a href="{$indexPersonnages}">index des personnages</a>.</p>
                    </div>
                    <div>
                        <p>Les numérisations des feuillets édités :</p>
                        <ul>
                            <li><a href="{//pb[1]/@facs}">f.101v</a></li>
                            <li><a href="{//pb[2]/@facs}">f.102r</a></li>
                            <li><a href="{//pb[3]/@facs}">f.102v</a></li>
                        </ul>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        
        <!-- La page de la transcription normalisée -->
        
        <!-- Cette page permet de visualiser le texte avec les abréviations développées,
        grâce à l'utilisation du mode "reg" -->
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
                        <!-- Le texte étant en prose, il nous a paru intéressant de le faire apparaître dans
                            sa version normalisée sous la forme d'un paragraphe. -->  
                        <xsl:for-each select=".//l">
                            <xsl:choose>
                                <xsl:when test="position() = 1">    
                                    <xsl:apply-templates mode="reg"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="' '"/> <!-- cela permet d'avoir des espaces à chaque
                                        changement de ligne et rend le texte plus lisible, mais pose le problème des
                                        espaces entre les coupures de mots qui n'a pas pu être résolu -->
                                    <xsl:apply-templates mode="reg"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        
                    </div>
                    <div>
                        <p><a href="{$accueil}">Retour à la page d'accueil</a></p>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        
        <!-- La page de la transcription fascimilaire -->
        
        <!-- Cette page permet de visualiser le texte dans une forme aussi proche que possible
        de celle du texte manuscrit, grâce à l'utilisation du mode "orig" qui ne résoud pas 
        les abréviations -->
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
                        
                        <xsl:element name="ol">
                            <!-- Ici on crée, pour chaque élément <l> un élément <li> qui contient le texte
                                de chaque ligne, sans la répéter plusieurs fois -->
                            <xsl:for-each select=".//l">
                                <xsl:choose>
                                    <xsl:when test="position() = 1">
                                        <xsl:element name="li">
                                            <xsl:apply-templates mode="orig"/>
                                            <!-- L'élément <c type="hyphen"> servait à signaler les endroits où le copiste avait
                                                inscrit un tiret en fin de ligne pour les renvois à la ligne de mots divisés par
                                                la justification du texte, on transforme donc cet élément ici afin de faire
                                                apparaître un tiret à sa place. -->
                                            <xsl:choose>
                                                <xsl:when test=".//c[@type='hyphen']">
                                                    <xsl:text>-</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="li">
                                            <xsl:apply-templates mode="orig"/>
                                            <xsl:choose>
                                                <xsl:when test=".//c[@type='hyphen']">
                                                    <xsl:text>-</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            
                        </xsl:element>
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
                        <!-- On appelle ici l'index pour le rendre visible sur la page -->
                        <xsl:call-template name="index"/>
                    </div>
                    <div>
                        <p><a href="{$accueil}">Retour à la page d'accueil</a></p>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        
        
    </xsl:template>
    
</xsl:stylesheet>