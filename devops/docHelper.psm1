$global:htmlSnippetsPath=".\doc\htmlsnippets"
$global:htmlOutputPath=".\deployment\doc"
$global:assetPath=".\doc\assets"
$global:relImagePath="assets/images"

$global:htmlSnippetHeadName="head"
$global:htmlSnippetBodyHeaderName="bodyheader"
$global:htmlSnippetBodyFooterName="bodyfooter"
$global:htmlSnippetSidebarName="sidebar"
$global:htmlSnippetIndexPageHeaderName="indexpageheader"
$global:htmlSnippetIndexBodyHeaderName="indexbodyheader"
$global:htmlSnippetIndexBodyFooterName="indexbodyfooter"
$global:htmlSnippetSideBarHeaderName="sidebarheader"
$global:htmlSnippetSideBarFooterName="sidebarfooter"
$global:htmlSnippetArticleHeaderName="articleheader"
$global:htmlSnippetIndexCardName="indexcard"

class docuBase{
    $id
    $parent
    docuBase() {
        $this.id=$([guid]::newGuid() | select -ExpandProperty guid)
        $this.parent=$null
    }
    docuBase($parent) {
        $this.id=$([guid]::newGuid() | select -ExpandProperty guid)
        $this.parent=$parent
    }
    [string]render() {
        $s=""
        return $s
    }
}
class htmlSnippet:docuBase{
    $name
    $basepath=$global:htmlSnippetsPath
    $substObjects=@()
    htmlSnippet($name,$parent=$null):base($parent) {
        $this.name=$name
        if ($null -ne $parent) {
            $this.substObjects+=$parent
        }        
    }
    addSubstitutionObjects($objects) {
        $this.substObjects+=$objects
    }
    [string]render() {
        $s=gc "$($this.basepath)\$($this.name).html" -Encoding UTF8 -raw
        $this.substObjects | ? {$null -ne $_} | %{
            $o=$_            
            $o | Get-Member -MemberType Property | %{
                $s=$s.Replace("###$($_.Name.ToLower())###",$o.$($_.Name))
            }
        }
        return $s
    }
}
class docuText:docuBase{
    $text
    docuText($text,$parent):base($parent) {
        $this.text=$text
    }
    [string]render() {
        $s=""

        $docu=$this.parent
        while ($null -ne $docu -and (($docu.gettype() | select -ExpandProperty name) -ne "docu")) {
            $docu=$docu.parent
        }

        @("section","article","page") | % {
            $linkType=$_
            $i=$this.text.indexof("<$($linkType):")
            while ($i -ge 0) {
                $snippet=$this.text.Substring($i,$this.text.indexof('>',$i+1)-$i+1)
                $snippetName=$snippet.split(":")[1].replace(">","")
                $replace=""
                if ($null -ne $docu) {
                    $e=$(Invoke-Command([scriptblock]::Create("`$docu.$($linkType)(`$snippetName)")))
                    if ($null -ne $e) {
                        $replace=$e.seeAlso()
                    }
                }
                $this.text=$this.text.replace($snippet,$replace)
                $i=$this.text.indexof("<$($linkType):")
            }
        }

        $i=$this.text.indexof('  ')
        while ($i -gt 0) {$this.text=$this.text.replace('  ',' ');$i=$this.text.indexof('  ')}
        $i=$this.text.indexof('`n`r')
        if ($i -gt 0) {$this.text.replace('`n`r','')}
        $i=$this.text.indexof('`n')
        if ($i -gt 0) {$this.text.replace('`n','')}        
        return $this.text
    }
}
class docuElementText:docuBase{
    $text
    docuElementText($text,$parent):base($parent) {
        $this.text=[docuText]::new($text,$this)
    }
    [string]render() {
        $s=""
        $s+='<p>'
        <#
        $i=$this.text.indexof('  ')
        while ($i -gt 0) {$this.text=$this.text.replace('  ',' ');$i=$this.text.indexof('  ')}
        $i=$this.text.indexof('`n')
        if ($i -gt 0) {$this.text.replace('`n','')}
        $s+=$this.text
        #>
        $s+=$this.text.render()
        $s+='</p>'+"`r`n"
        return $s
    }
}
class docuElementTitle:docuBase{
    $title
    docuElementTitle($title,$parent):base($parent) {
        $this.title=$title
    }
    [string]render() {
        $s=""
        $s+='<h3>'+$this.title+'</h3>'
        return $s
    }
}
class docuElementTable:docuBase{
    $records
    $class
    docuElementTable($records,$parent):base($parent) {
        $this.records=$records
        $this.class="table table-stripped"
    }
    docuElementTable($records,$class,$parent):base($parent) {
        $this.records=$records
        $this.class=$class
    }
    [string]render() {
        $s=""    
        $s+='    <div class="table-responsive my-4">'+"`r`n"
        $s+='        <table class="table table-striped">'+"`r`n"
        $s+='            <thead>'+"`r`n"
        $s+='                <tr>'+"`r`n"
        if ($this.records.length -gt 0) {
            $this.records[0] | Get-Member -MemberType NoteProperty | select -ExpandProperty name | sort | %{
                $s+='                    <th scope="col">' + $($_.Substring(1)) + '</th>'+"`r`n"
            }
        }
        $s+='                </tr>'+"`r`n"
        $s+='            </thead>'+"`r`n"
        $s+='            <tbody>'+"`r`n"
        if ($this.records.length -gt 0) {
            $this.records | ? {$null -ne $_} | %{
                $s+='                <tr>'+"`r`n"
                $record=$_
                $record | Get-Member -MemberType NoteProperty | select -ExpandProperty name | sort | %{
                    $s+='                    <td>' + $($record.$($_))  + '</td>'+"`r`n"
                }
                $s+='                </tr>'+"`r`n"
            }
        }
        $s+='            </tbody>'+"`r`n"
        $s+='        </table>'+"`r`n"
        $s+='    </div><!--//table-responsive-->'+"`r`n"
        return $s
    }
}
class docuElementButton:docuBase{
    $text
    $link
    $class
    docuElementButton($text,$link,$parent):base($parent) {
        $this.text=$text
        $this.link=$link
        $this.class="btn btn-primary"
    }
    docuElementButton($text,$link,$class,$parent):base($parent) {
        $this.text=$text
        $this.link=$link
        $this.class=$class
    }
    [string]render() {
        $s=""
        $s+='<p><a href="' + $($this.link) + '" class="' + $($this.class) + '">' + $($this.caption) + '</a></p>'
        return $s
    }
}
class docuElementImage:docuBase{
    $name
    $class
    docuElementImage($name,$parent):base($parent) {
        $this.name=$name
        $this.class="figure-img img-fluid shadow rounded"
    }
    docuElementImage($name,$class,$parent):base($parent) {
        $this.name=$name
        $this.class=$class
    }
    [string]render() {
        $s=""
        $s+='<img class="' + $this.class + '" src="' + "$($global:relImagePath)/$($this.name).png" + '" alt="" title="' + $this.name + '"/>'+"`r`n"
        return $s
    }
}
class docuElementCode:docuBase{
    $text
    docuElementCode($text,$parent):base($parent) {
        $this.text=$text
    }
    [string]render() {
        $s=""
        $s+='<pre class="shadow p-3 mb-5 bg-grey rounded" style="white-space: pre-wrap;word-wrap: break-word;text-align: justify">'+"`r`n"
        $s+=$this.text
        $s+='</pre>'
        return $s
    }
}
class docuElementGallery:docuBase{
    $names
    docuElementGallery($names,$parent):base($parent) {
        $this.names=@()
        $this.names+=$names.split(",")
    }
    [string]render() {
        $s=""
        $s+='<div class="simplelightbox-gallery row mb-3">'+"`r`n"
        $this.names | ? {$null -ne $_} | %{
            $s+='<div class="col-12 col-md-4 mb-3">'+"`r`n"
            $s+='    <a href="' + "$($global:relImagePath)/$($_).png" + '"><img class="figure-img img-fluid shadow rounded" src="' + "$($global:relImagePath)/$($_).png" + '" alt="" title="' + $_ + '"/></a>'+"`r`n"
            $s+='</div>'+"`r`n"
        }       
        $s+='</div>'+"`r`n"
        return $s
    }
}
class docuSection:docuBase{
    $title
    $elements
    docuSection($parent):base($parent) {
        $this.title=""
        $this.elements=@()
    }
    docuSection($title,$parent):base($parent) {
        $this.title=$title
        $this.elements=@()
    }
    [docuElementText]addText($text) {
        $e=[docuElementText]::new($text,$this)
        $this.elements+=$e
        return $e
    }
    [docuElementTitle]addTitle($title) {
        $e=[docuElementTitle]::new($title,$this)
        $this.elements+=$e
        return $e
    }
    [docuElementTable]addTable($records) {
        $e=[docuElementTable]::new($records,$this)
        $this.elements+=$e
        return $e
    }
    [docuElementImage]addImage($name) {
        $e=[docuElementImage]::new($name,$this)
        $this.elements+=$e
        return $e
    }
    [docuElementCode]addCode($text) {
        $e=[docuElementCode]::new($text,$this)
        $this.elements+=$e
        return $e
    }
    [docuElementGallery]addGallery($names) {
        $e=[docuElementGallery]::new($names,$this)
        $this.elements+=$e
        return $e
    }
    [string]link() {
        return "$($this.parent.parent.link())#$($this.ID)"
    }
    [string]seeAlso() {
        return "(see also <a href='$($this.link())'>$($this.title)</a>)"
    }
    [string]render() {
        $s=""
        $s+='<section class="docs-section" id="' + $($this.id) + '">'+"`r`n"
        if ($this.title.length -gt 0) {
            $s+='<h2 class="section-heading">' + $($this.title) + '</h2>'+"`r`n"
        }
        $this.elements | ? {$null -ne $_} | %{
            $s+=$_.render()
        }
        $s+='</section>'+"`r`n"
        return $s
    }
}
class docuArticle:docuBase{
    $title
    $text
    $header
    $sections
    docuArticle($title,$text,$parent):base($parent) {
        $this.title=$title
        $this.text=$text
        $this.header=[htmlSnippet]::new($global:htmlSnippetArticleHeaderName,$this)
        $this.sections=@()
    }
    [docuSection]addSection($title) {
        $e=[docuSection]::new($title,$this)
        $this.sections+=$e
        return $e
    }
    [string]link() {
        return "$($this.parent.link())#$($this.ID)"
    }
    [string]seeAlso() {
        return "(see also <a href='$($this.link())'>$($this.title)</a>)"
    }
    [string]render() {
        $s=""
        $s+='<article class="docs-article" id="'+ $($this.id) +'">'+"`r`n"
        $s+=$this.header.render()+"`r`n"
        $this.sections | ? {$null -ne $_}  | %{
            $s+=$_.render()
        }
        $s+='</article>'+"`r`n"
        return $s
    }
}
class docuSideBar:docuBase{
    $header
    $footer
    docuSideBar($parent):base($parent) {
        $this.header=[htmlSnippet]::new($global:htmlSnippetSideBarHeaderName,$this)
        $this.footer=[htmlSnippet]::new($global:htmlSnippetSideBarFooterName,$this)
    }
    [string]render() {
        $s=""
        $s+=$this.header.render()+"`r`n"
        $this.parent.articles | ? {$null -ne $_} | %{
            $article=$_
            $s+='<li class="nav-item section-title mt-3"><a class="nav-link scrollto" href="#' + $($article.id) + '"><span class="theme-icon-holder me-2"><i class="fas fa-arrow-down"></i></span>' + $($article.title) + '</a></li>'+"`r`n"
            $article.sections | ? {$null -ne $_} | %{
                $section=$_
                $s+='<li class="nav-item"><a class="nav-link scrollto" href="#' + $($section.id) + '">' + $($section.title) + '</a></li>'+"`r`n"
            }            
        }
        $s+=$this.footer.render()+"`r`n"
        return $s
    }
}
class docuIndexCard:docuBase{    
    $title
    $text
    $icon
    $link
    $card
    docuIndexCard($title,$text,$icon,$link,$parent):base($parent) {        
        $this.title=$title
        $this.text=$text
        $this.icon=$icon
        $this.link=$link
        $this.card=[htmlSnippet]::new($global:htmlSnippetIndexCardName,$this)
    }
    [string]render() {
        $s=""
        $s+=$this.card.render()
        return $s
    }
}
class docuPageBase:docuBase{
    $name
    $title
    $description
    $head
    $pageHeader
    $bodyHeader
    $bodyFooter
    docuPageBase($name,$title,$description,$parent):base($parent) {
        $this.name=$name
        $this.title=$title
        $this.description=$description        
    }
    [string]link() {
        return "$($this.name).html"
    }
    [string]seeAlso() {
        return "(see also <a href='$($this.link())'>$($this.title)</a>)"
    }
    [string]render() {
        $s=""      
        return $s
    }
    save() {
        $this.render() | Out-File "$($global:htmlOutputPath)\$($this.name).html" -Encoding utf8
    }    
}
class docuPage:docuPageBase{
    $icon
    $head
    $bodyHeader
    $bodyFooter
    $sideBar
    $articles=@()
    docuPage($name,$title,$description,$icon,$parent):base($name,$title,$description,$parent) {
        $this.icon=$icon
        $this.head=[htmlSnippet]::new($global:htmlSnippetHeadName,$this)
        $this.bodyheader=[htmlSnippet]::new($global:htmlSnippetBodyHeaderName,$this)
        $this.bodyfooter=[htmlSnippet]::new($global:htmlSnippetBodyFooterName,$this)
        $this.sidebar=[docuSideBar]::new($this)
    }
    [docuArticle]addArticle($title,$text) {
        $e=[docuArticle]::new($title,$text,$this)
        $this.articles+=$e
        return $e
    }
    [string]render() {
        $s=""
        $s+='<!DOCTYPE html>'+"`r`n"
        $s+='<html lang="en"> '+"`r`n"
        $s+=$this.head.render()+"`r`n"               
        $s+='<body class="docs-page">'+"`r`n"
        $s+=$this.bodyheader.render()+"`r`n"
        $s+='<div class="docs-wrapper">'+"`r`n"
        $s+=$this.sideBar.render()+"`r`n"
        $s+='<div class="docs-content">'+"`r`n"
        $s+='<div class="container">'+"`r`n"
        $this.articles | ? {$null -ne $_} | % {
            $s+=$_.render()+"`r`n"
        }
        $s+='</div>'+"`r`n"
        $s+='</div>'+"`r`n"
        $s+='</div><!--//docs-wrapper-->'+"`r`n"
        $s+=$this.bodyFooter.render()+"`r`n"
        $s+='</body>'+"`r`n"
        $s+='</html> '+"`r`n"        
        return $s
    }
}
class docuIndexPage:docuPageBase{
    $head
    $pageHeader
    $bodyHeader
    $bodyFooter
    $cards=@()
    docuIndexPage($name,$title,$description,$parent):base($name,$title,$description,$parent) {
        $this.head=[htmlSnippet]::new($global:htmlSnippetHeadName,$this)
        $this.pageHeader=[htmlSnippet]::new($global:htmlSnippetIndexPageHeaderName,$this)
        $this.bodyheader=[htmlSnippet]::new($global:htmlSnippetIndexBodyHeaderName,$this)
        $this.bodyfooter=[htmlSnippet]::new($global:htmlSnippetIndexBodyFooterName,$this)
    }
    [docuIndexCard]addCard($title,$text,$icon,$link) {
        $e=[docuIndexCard]::new($title,$text,$icon,$link,$this)
        $this.cards+=$e
        return $e
    }
    [string]render() {
        $s=""
        $s+='<!DOCTYPE html>'+"`r`n"
        $s+='<html lang="en">'+"`r`n"
        $s+=$this.head.render()+"`r`n"               
        $s+='<body>'+"`r`n"
        $s+=$this.bodyHeader.render()+"`r`n"
        $s+=$this.pageHeader.render()+"`r`n"
        $s+='   <div class="page-content">'+"`r`n"
        $s+='       <div class="container">'+"`r`n"
        $s+='          <div class="docs-overview py-5">'+"`r`n"
        $s+='             <div class="row justify-content-center">'+"`r`n"
        $this.cards | ? {$null -ne $_} | %{
            $s+=$_.render()+"`r`n"
        }
        $s+=''+"`r`n"
        $s+=''+"`r`n"
        $s+=''+"`r`n"
        $s+='            </div><!--//row-->'+"`r`n"
        $s+='         </div><!--//container-->'+"`r`n"
        $s+='       </div><!--//container-->'+"`r`n"
        $s+='    </div><!--//page-content-->'+"`r`n"
        $s+=$this.bodyFooter.render()+"`r`n"
        $s+='</body>'+"`r`n"
        $s+='</html> '+"`r`n"        
        return $s
    }
}
class docu{
    $pages
    $articles
    $sections
    $elements
    $currentPage
    $currentArticle
    $currentSection
    $currentElement
    docu() {
        $this.pages=[hashtable]@{}
        $this.articles=[hashtable]@{}
        $this.sections=[hashtable]@{}
        $this.elements=[hashtable]@{}
        $this.currentPage=$null
        $this.currentArticle=$null
        $this.currentSection=$null
        $this.currentElement=$null
    }
    [void]addPage($name,$title,$description,$icon) {
        $e=[docuPage]::new($name,$title,$description,$icon,$this)
        $this.pages.add($name,$e)
        $this.currentPage=$e
    }
    [void]addArticle($title,$text) {
        if ($null -ne $this.currentPage) {
            $e=$this.currentPage.addArticle($title,$text)
        } else {
            $e=[docuArticle]::new($title,$text,$null)
        }
        $this.articles.add($title,$e)
        $this.currentArticle=$e
    }
    [void]addSection($title) {
        if ($null -ne $this.currentArticle) {
            $e=$this.currentArticle.addSection($title)
        } else {
            $e=[docuSection]::new($title,$null)
        }
        $this.sections.add($title,$e)
        $this.currentSection=$e
    }
    [void]addText($text) {
        if ($null -ne $this.currentSection) {
            $e=$this.currentSection.addText($text)
        } else {
            $e=[docuElementText]::new($text,$null)
        }
        $this.elements.add($e.id,$e)
        $this.currentElement=$e
    }
    [void]addTitle($title) {
        if ($null -ne $this.currentSection) {
            $e=$this.currentSection.addTitle($title)
        } else {        
            $e=[docuElementTitle]::new($title,$null)
        }
        $this.elements.add($e.id,$e)
        $this.currentElement=$e        
    }
    [void]addTable($records) {
        if ($null -ne $this.currentSection) {
            $e=$this.currentSection.addTable($records)
        } else {
            $e=[docuElementTable]::new($records,$null)
        }
        $this.elements.add($e.id,$e)
        $this.currentElement=$e
    }
    [void]addImage($name) {
        if ($null -ne $this.currentSection) {
            $e=$this.currentSection.addImage($name)
        } else {        
            $e=[docuElementImage]::new($name,$null)
        }
        $this.elements.add($e.id,$e)
        $this.currentElement=$e
    }
    [void]addCode($text) {
        if ($null -ne $this.currentSection) {
            $e=$this.currentSection.addCode($text)
        } else {            
            $e=[docuElementCode]::new($text,$null)
        }
        $this.elements.add($e.id,$e)
        $this.currentElement=$e
    }
    [void]addGallery($names) {
        if ($null -ne $this.currentSection) {
            $e=$this.currentSection.addGallery($names)
        } else {             
            $e=[docuElementGallery]::new($names,$null)
        }
        $this.elements.add($e.id,$e)
        $this.currentElement=$e
    }
    [docuPage]page($key) {
        if ($this.pages.containsKey($key)) {
            return $this.pages[$key]
        } else {
            return $null
        }
    }
    [docuArticle]article($key) {
        if ($this.articles.containsKey($key)) {
            return $this.articles[$key]
        } else {
            return $null
        }
    }
    [docuSection]section($key) {
        if ($this.sections.containsKey($key)) {
            return $this.sections[$key]
        } else {
            return $null
        }
    }
    save() {
        $indexPage=[docuIndexPage]::new("index","WIDup documentation","WIDup documentation",$this)
        $this.pages.GetEnumerator() | ? {$null -ne $_} | % {
            $p=$_.value
            $indexPage.addCard($p.title,$p.description,$p.icon,$p.link())
            $p.save()
        }
        $indexPage.save()
        Copy-Item -Path $global:assetPath -Destination $global:htmlOutputPath -Recurse -ErrorAction SilentlyContinue
    }

}
function Set-wupDok() {
    param(
        $htmlOutputPath
    )
    function getqueuenames() {
        $vars=$((gc .\variables.json -Raw) | convertfrom-json | select -ExpandProperty default)
        $($vars | get-member -MemberType NoteProperty | ? {$_.name -like "*queue_name"} | select -ExpandProperty name | %{[PSCustomObject]@{
            AQueue = $vars.$($_).value
            BDescription = $vars.$($_).description
        }})    
    }
    function getqueueworker() {
        gci '.\ps\Azure Functions' -Directory | ? {$_.fullname -like '*_queueworker'} | %{
            $skip=$false
            $code=(gc "$($_.fullname)\run.ps1" | %{if ($_.indexof("<#") -ge 0) {$skip=$true};if (!$skip) {$_};if ($_.indexof("#>") -ge 0) {$skip=$false}} | ? {$_ -notlike "#*"}) -join "`r`n"
            $config=(gc "$($_.fullname)\function.json" -raw)
            $c=(gc "$($_.fullname)\run.ps1" -Raw).Replace("`r`n","")
            $text=$(if ($c.IndexOf("<DOC>") -gt 0) {$c.Substring($c.IndexOf("<DOC>")+5,$c.IndexOf("</DOC>")-$c.IndexOf("<DOC>")-5)} else {""})
            [PSCustomObject]@{
                title=$(($_.Name.split("_") | select -last 2) -join "_")
                text=$text
                code=$code
                config=$config
            }
        }
    }
    function getbicepresources() {
        $s=$(gc ".\IaC\source.bicep" -Raw -Encoding UTF8)
        $i=-1
        $i=$s.IndexOf("`r`nresource ",$i+1)
        $(while ($i -ge 0) {
            $j=$i
            while ($j -ge 0 -and $s.Substring($j,1) -ne "}") {$j-=1}
            $j+=1
            $k=$s.IndexOf("`r`nresource ",$i+1)
            while ($k -ge 0 -and $s.Substring($k,1) -ne "}") {$k-=1}
            $i1=$s.IndexOf("'",$i)+1
            $i2=$s.IndexOf("'",$i1+1)-1
            $name=$s.Substring($i,$i2-$i-1).split(" ")[1]
            [PSCustomObject]@{
                type = $s.Substring($i1,$i2-$i1+1)
                basetype=$s.Substring($i1,$i2-$i1+1).split("@")[0].Split(".")[1].split("/")[0]
                name = $s.Substring($i,$i2-$i-1).split(" ")[1]
                text = $s.Substring($j,$i-$j+1).replace('/*',"").replace('*/',"").replace("`r`n","")
                code = $(if ($k -gt 0) {$s.Substring($i+2,$k-$i-1)} else {$s.Substring($i+2)})
            }
            #$i=$k+3
            $i=$s.IndexOf("`r`nresource ",$i+1)
        })        
    }
    function getvariables() {
        $v=gc .\variables.json -raw | convertfrom-json
        $v.default | get-member -MemberType NoteProperty | select @{name="AName";Expression={$_.name}},@{name="BDescription";Expression={$v.default.$($_.name).description}},@{name="CType";Expression={$v.default.$($_.name).type}} |sort aname
    }
    function getfoldercode() {
        function rec($f,$l,$m) {
            gci -path $f -Directory | ? {$null -ne $_} | sort name | %{
                "$(@(0..$l) | %{"    "})$($_.name)"
                if ($l -lt $m) {rec -f $($_.fullname) -l $($l+1)}
            }
        }
        rec -f ".\" -l 0 -m 2
    }
    function getfunction($name) {
        $(gci ".\" -filter "*.psm1" -exclude "az.*" -Recurse |%{
            $f=$_
            $("`r`n$(gc -path $f.fullname -raw -Encoding utf8)`r`n").split("`r`nfunction ").split("`r`nClass ") | ? {$_.indexof("{") -gt 0} | %{       
                $n=$_.substring(0,$(if ($_.indexof("()") -gt 0) {$_.indexof("()")} else {$_.indexof(" ")}))
                $m=$f.name.replace(".psm1","")
                $c="Module $($m):`r`n" + $(if ($_.indexof("<#") -gt 0) {"function " + $_.substring(0,$_.indexof("<#")) + $_.substring($_.indexof("#>")+2)} else {"function " + $_})
                $d=$(if ($_.indexof("<#") -gt 0) {$_.substring($_.indexof("<#")+2,$_.indexof("#>")-$_.indexof("<#")-2)} else {""}).replace("`r`n","").replace("  "," ").replace("  "," ")
                [PSCustomObject]@{
                    name=$n
                    code=$c
                    module=$m
                    description=$d
                }
            }
        }) | ? {$_.name -like $name} | select -first 1
    }

    $global:htmlOutputPath=$htmlOutputPath
    $doc=[docu]::new()
    $doc.addPage("queues","WIDup queues","Staged processing via Azure Storage Queues is one of the 
    core principles of the WIDup interface.","fa-square-check")

    $doc.addArticle("WIDup queue processing","Staged processing via Azure Storage Queues is one of 
    the core principles of the WIDup interface. Data that is inserted into the interface is passed on via 
    different queues; the worker of each queue fulfils a specific subtask of the interface, e.g. it sends 
    the data to one of the connected systems.<br/>This type of processing offers a high level of resilience 
    to failures and errors in the connected systems and good possibilities for loss-free restart after such 
    a partial failure.<br/>This chapter explains processing via queues in WIDup.")
    $doc.addSection("Azure storage queues")
    $doc.addText("WIDup uses the Azure platform service Storage Accounts as its basis. Queues are a sub-functionality 
    of this PaaS service. Queue storage can cache a large number of messages and output them again according to the FIFO 
    principle.<br/>Further information on Azure Storage queues is available <a href='https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction' target='_blank'>here</a>.")
    $doc.addText("A single queue message can have a maximum size of 64KB. WIDup therefore uses the queue service in 
    combination with Azure Storage Blobs. The queue item contains a Json data record with the attribute 'blobID'. The 
    attribute contains a GUID value that represents the name of the storage blob that contains the actual data. In this 
    way, it is possible to use much larger data sets in the context of queues.")
    $doc.addSection("WIDup queues")
    $doc.addText("WIDup uses the following storage account queues; the names of the queues are defined in the application 
    variables.<br/>For each of the queues there is an additional 'poison'-queue that is used in case of errors in the processing.
    <br/>The graphic illustrates the use of the individual queues in the context of the connected systems. The cycle via the various 
    queues is set in motion in two ways. Some interface processes run according to a schedule; in this case, a scheduler process 
    starts the cycle. In the other case, a third-party system transmits data to the WIDup interface via a REST API; this data is 
    then used as the start data set and the cycle is started.")
    $doc.addGallery(@("queueOverview"))
    $doc.addTable($(getqueuenames))
    $doc.addText("Note that the current version of the interface does not yet include a queue for the Dynamics CRM system.")
    
    $doc.addArticle("WIDup queue workers","The queue workers are the actual workhorses of the WIDup interface. The entire 
    interface logic is processed in them and the data record is inserted back into a queue. The queue into which a worker passes 
    the data record depends on whether the processing of the worker was successful.")
    $doc.addSection("Queue worker processing")
    $doc.addText("The processes at the start and end of each queue worker are (almost) identical for all queues. The data is 
    loaded, processed, supplemented and forwarded. The result of the processing is taken into account. It is important that the data 
    record is always entered in a downstream queue. This ensures that no data can be lost during processing, even if a worker process 
    fails. Examples of errors include the temporary unavailability of connected systems or errors in the transferred data.<br>The following 
    diagram illustrates the data flow process in the queues.")
    $doc.addGallery(@("queueWorker"))
    $doc.addText("The process of an individual worker is started by a notification from the queue storage. The queue sends the 
    worker a new element from the queue. This notification is triggered by a trigger definition in the configuration of the worker process 
    (1).<br/><br/>The worker reads the blobID parameter from the queue message and loads the corresponding blob from the storage container 
    ('queuecache'). The blob contains a JSON string that represents the current data set. The worker converts the data into a syncjob 
    object (2).<br/><br/>The worker then executes its processes on the data set. Each worker adds additional data to the data set (3).<br/><br/>
    The completion of the process depends on whether the worker was able to execute its processes successfully or not.<br/><br/>In the positive 
    case (green digits), the worker saves the output data set in a new blob (4) and inserts a new message in the next queue; the message in 
    turn contains the reference to the newly created blob (5). If all processes up to this point have been successful, the previous blob is 
    finally deleted (6).<br/><br/>If one or more errors occur, the old queue message is first inserted back into the original queue n times (7). 
    The associated blob remains in place. n is defined in the host configuration of the function app; WIDup uses a value of 5.<br/>The re-inserted 
    record is reloaded by the worker at the next opportunity and processing is attempted again. This type of error handling is suitable 
    for tolerating temporary errors, e.g. connection errors; in such cases, there is a good chance that processing will work in one of the 
    retries.<br/><br/>If processing does not work even the nth time, the record is finally inserted into the poison queue, which belongs to the 
    input queue (7). The record remains stored there for 7 days; during this time, errors that last longer can be checked. Once the error 
    has been rectified, the messages from the poison queue can be re-inserted into the active queue so that they can be processed again.")
    $doc.addArticle("Queue worker reference","A worker is defined within the Azure Function App via two files. One is the 
    configuration file (function.json) and the other is the code file that contains the code (run.ps1). WIDup uses Powershell as the scripting 
    language.<br/>The individual workers are described in detail below.")
    getqueueworker | ? {$null -ne $_} | %{
        $doc.addSection($_.title)
        $doc.addText($_.text)
        $doc.addTitle("Function configuration")
        $doc.addCode($_.config)
        $doc.addTitle("Function code")
        $doc.addCode($_.code)
    }

    $doc.addPage("infrastructure","WIDup PaaS infrastructure","WIDup is a distributed cloud application that consists of various PaaS elements.","fa-square-check")
    $doc.addArticle("PaaS element reference","The elements of the WIDup interface are rolled out via automatic processes (CI/CD pipelines). The script language 
    bicep is used for the infrastructure part. The image below provides an overview of the used resources in WIDup.")
    $doc.addSection("Infrastructure overview")
    $doc.addGallery(@("infrastructure"))
    $doc.addText("The main components of the WIDup interface are the components in the Web and Storage groups. Storage - as the name 
    suggests - is used to store data. WIDup uses queues, tables and blobs. The resources in the Web group form the compute part, 
    i.e. the part of the application in which the code is executed.<br/>The key vault resources are used to store and manage sensitive 
    elements of the interface configuration, e.g. access data to the connected systems.<br/>Managed identities are special accounts 
    in Microsoft Entra ID that can be linked to a resource and allow the resource to log in to services that are managed via Entra ID. 
    These logins and the necessary assignments of authorisations are provided via authorisation resources (RBAC assignments).<br/>
    The numerous components under the relay service are used to establish a connection from the function app to a virtual computer 
    in the local data centre; WIDup uses such a connection for the ADDS service component.<br/>Finally, the two insights resources 
    are used to collect (insights) and save (operational insights) logs from the interface application.")
    getbicepresources | group basetype | sort name | %{
        $doc.addSection($_.name)
        $_.group | % {
            $doc.addTitle("$($_.name) [$($_.type)]")
            $doc.addText($_.text)
            $doc.addCode($_.code)
        }
    }
    
    $doc.addPage("variables","WIDup variables","Variables are the key to WIDup's multi-environment support.","fa-square-check")
    $doc.addArticle("Variables","The particular configuration of a WIDup instance is specified by a large number of variables. The variables are used both for the 
    definition of the infrastructure elements and as application-specific parameters.")
    $doc.addSection("Variable definition")
    $doc.addText("Variables are defined in a central file (variables.json). The file represents a data set with different areas. There is a 'default' area and an 
    area for each application environment.<br/><br/>All variables are defined with name, description and type in the 'default' area. For variables whose value is the 
    same for all application environments, the value is also set in the 'default' area. The 'default' area also offers the option of defining a scheme for the 
    variable values for the different application environments; in this way, naming conventions can be stored by inserting variables as placeholders with curly brackets 
    in the schema definitions.<br/><br/>The areas for the application environments 
    in the variables.json file have the same name as the application environment, e.g. WAGNERTEST. This is where the environment-specific values for the variables 
    defined in the 'default' area are recorded.<br/><br/>A rendering process that runs in the context of the CI/CD pipelines then calculates the specific variable-set 
    for the application environment to be enrolled based on the definitions in the variables.json file. For variables that have been defined in the 'default' area with a 
    schema for the values of the application environments, the placeholders are replaced with the effective values by recursive, repeated substitution.")
    $doc.addSection("Render function")
    $doc.addText("The render function compiles a set of variables for a specified application environment. To do this, the function loads the variable definition file 
    and calculates the values for the target application environment through repeated string substitution. At the same time, a string variable is created that 
    contains the bicep code for the variable definition in main.bicep.<br/>The name of the target application environment must be specified as a parameter.")
    $doc.addCode($(getfunction "get-bicepvariabledefinition" | select -expandproperty code))
    $doc.addSection("Variable usage")
    $doc.addText("The variables are used in three places.<br/>
    <ul>
    <li>The variable part of the main.bicep definition file<br/>
    The bicep file is created dynamically in the build phase of the iac artefacts. The variables from the variables.json file are integrated as bicep variables.
    </li>
    <li>The configuration parameters of the Azure function app<br/>
    These parameters are inserted into the configuration parameters of the function app as part of the bicep definition and are available in the code as environment variables.
    </li>
    <li>In the CI/CD pipeline scripts<br/>
    In the build phase of the CI/CD pipelines, the variables are used to build the code artefacts for the respective target application environment.
    </li>
    </ul>")
    $doc.addSection("Overview of variables")
    $doc.addTable($(getvariables))
    
    if (!(Test-path $global:htmlOutputPath)) {new-item -Path $global:htmlOutputPath -ItemType Directory}
    $doc.save()
}