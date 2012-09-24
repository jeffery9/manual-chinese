<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="user.footer.content">
    <xsl:text disable-output-escaping="yes">
    <![CDATA[    
        <div id="weibo_comments">
            <!-- Duoshuo Comment BEGIN -->
            <div class="ds-thread" data-thread-key="" 
            data-title="" data-author-key="" data-url=""></div>
            <script type="text/javascript">
            var duoshuoQuery = {short_name:"neo4jdocs"};
            (function() {
                var ds = document.createElement('script');
                ds.type = 'text/javascript';ds.async = true;
                ds.src = 'http://static.duoshuo.com/embed.js';
                ds.charset = 'UTF-8';
                (document.getElementsByTagName('head')[0] 
                || document.getElementsByTagName('body')[0]).appendChild(ds);
            })();
            </script>
            <!-- Duoshuo Comment END -->
        </div> 
        <!--<div id="right-column"></div>-->
        <script type="text/javascript" src="http://www.neo4j.org.cn/js/right-column.js"></script>
    ]]>
    </xsl:text>
    
    <HR/>
    <a>
        <xsl:attribute name="href">
            <xsl:apply-templates select="/book/bookinfo/legalnotice[1]" mode="chunk-filename"/>
        </xsl:attribute>

        <xsl:apply-templates select="/book/bookinfo/copyright[1]" mode="titlepage.mode"/>
    </a>    
    
</xsl:template>

</xsl:stylesheet>


